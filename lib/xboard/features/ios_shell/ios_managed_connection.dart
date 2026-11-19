import 'dart:io';
import 'dart:isolate';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/ios_lifecycle.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/plugins/ios_service.dart';
import 'package:fl_clash/plugins/service.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/xboard/adapter/flclash_gateway.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/profile/providers/profile_import_provider.dart';
import 'package:fl_clash/xboard/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const iosManagedProbeUrl = 'https://toworld.uk/cdn-cgi/trace';

final iosManagedProfileProvider = FutureProvider.autoDispose<Profile?>((
  ref,
) async {
  final user = ref.watch(
    xboardUserProvider.select(
      (state) => (isAuthenticated: state.isAuthenticated, email: state.email),
    ),
  );
  final subscription = ref.watch(subscriptionInfoProvider);
  final profile = ref.watch(currentProfileProvider);
  final email = user.email;
  if (!user.isAuthenticated || email == null || profile == null) return null;
  final ids = await ref.watch(storageServiceProvider).getOwnedProfileIds(email);
  final url = subscription?.subscribeUrl;
  final ownsProfile =
      ids.contains(profile.id) ||
      url != null && url.isNotEmpty && profile.url == url;
  if (!ownsProfile) return null;
  final path = await appPath.getProfilePath(profile.id.toString());
  final stat = await FileStat.stat(path);
  return stat.type == FileSystemEntityType.file && stat.size > 0
      ? profile
      : null;
});

bool hasActiveIosPlan(DomainSubscription? subscription, DomainUser? user) =>
    user?.banned != true &&
    subscription != null &&
    subscription.planId > 0 &&
    subscription.subscribeUrl.isNotEmpty &&
    !subscription.isExpired &&
    (subscription.transferLimit <= 0 || !subscription.isTrafficExhausted);

bool _isManagedNode(Proxy proxy) {
  final type = proxy.type.toLowerCase().replaceAll('-', '');
  return !const {
    'direct',
    'reject',
    'rejectdrop',
    'compatible',
    'pass',
    'dns',
    'selector',
    'select',
    'urltest',
    'fallback',
    'loadbalance',
    'relay',
  }.contains(type);
}

typedef IosManagedLines = ({Group group, List<Proxy> options});

IosManagedLines? iosManagedLines(List<Group> groups) {
  for (final group in groups) {
    if (group.hidden == true ||
        group.name == GroupName.GLOBAL.name ||
        group.type != GroupType.Selector) {
      continue;
    }
    final options = group.all.where((proxy) {
      final nested = groups.getGroup(proxy.name);
      return nested == null
          ? _isManagedNode(proxy)
          : nested.type.isComputedSelected &&
                nested.all.isNotEmpty &&
                nested.all.every(_isManagedNode);
    }).toList();
    if (options.isNotEmpty) return (group: group, options: options);
  }
  return null;
}

final iosManagedLinesProvider = Provider.autoDispose<IosManagedLines?>((ref) {
  if (ref.watch(iosTunnelStatusProvider) != 'connected' ||
      ref.watch(iosManagedProfileProvider).asData?.value == null) {
    return null;
  }
  return iosManagedLines(ref.watch(groupsProvider));
});

final iosSelectedLineProvider = Provider.autoDispose<String?>((ref) {
  final lines = ref.watch(iosManagedLinesProvider);
  if (lines == null) return null;
  final group = lines.group;
  final selection = ref.watch(selectedMapProvider)[group.name] ?? '';
  final name = group.getCurrentSelectedName(selection);
  return lines.options.any((line) => line.name == name) ? name : null;
});

final iosManagedConnectionProvider = Provider<IosManagedConnection>(
  IosManagedConnection.new,
);

class IosManagedConnection {
  IosManagedConnection(this._ref);

  final Ref _ref;
  final _commands = SerialTaskScheduler();
  int _revision = 0;

  bool _canStart(Profile profile, String? email, int revision, int session) {
    final user = _ref.read(xboardUserProvider);
    return revision == _revision &&
        _ref.read(xboardUserProvider.notifier).sessionEpoch == session &&
        user.isAuthenticated &&
        !user.isLoading &&
        user.email == email &&
        _ref.read(initProvider) &&
        !_ref.read(safeModeProvider) &&
        !_ref.read(profileImportProvider).isImporting &&
        _ref.read(currentProfileProvider)?.id == profile.id &&
        hasActiveIosPlan(
          _ref.read(subscriptionInfoProvider),
          _ref.read(userInfoProvider),
        );
  }

  Future<bool> setRunning(bool running) {
    final revision = ++_revision;
    return _commands.run(() => _setRunning(running, revision));
  }

  Future<bool> _setRunning(bool running, int revision) async {
    if (revision != _revision) return false;
    final gateway = _ref.read(flClashGatewayProvider);
    if (!running) return gateway.setRunning(false);

    final session = _ref.read(xboardUserProvider.notifier).sessionEpoch;
    final email = _ref.read(xboardUserProvider).email;
    final profile = await _ref.read(iosManagedProfileProvider.future);
    final native = service;
    if (profile == null ||
        native == null ||
        !_canStart(profile, email, revision, session)) {
      return false;
    }

    final file = await profile.file;
    final network = _ref.read(networkSettingProvider);
    final configured = _ref.read(patchClashConfigProvider);
    final patch = configured.copyWith(
      mode: Mode.rule,
      allowLan: false,
      externalController: ExternalControllerStatus.close,
      tun: configured.tun.copyWith(enable: false),
    );
    final path = file.path;
    final rawConfig = await Isolate.run(() {
      final decoded = loadPlainYaml(File(path).readAsStringSync());
      return decoded is Map
          ? Map<String, dynamic>.from(decoded)
          : <String, dynamic>{};
    });
    if (rawConfig.isEmpty) return false;
    final built = await makeRealProfileTask(
      MakeRealProfileState(
        profilesPath: await appPath.profilesPath,
        profileId: profile.id,
        rawConfig: rawConfig,
        realPatchConfig: patch,
        appendSystemDns: network.appendSystemDns,
        bypassPrivateRoute: network.bypassPrivateRoute,
        keepEmptyDnsOverrides: true,
        proxyGroups: const [],
        rules: const [],
        addedRules: const [],
        defaultUA: globalState.packageInfo.ua,
        authentication: network.authentication.credentials,
      ),
    );

    if (!_canStart(profile, email, revision, session)) return false;
    await appPath.ensureProviderDirs(profile.id);
    await File(
      await appPath.configFilePath,
    ).writeAsStringAtomically(built.yaml);
    if (!_canStart(profile, email, revision, session)) return false;
    _ref
        .read(patchClashConfigProvider.notifier)
        .update(
          (state) => state.copyWith(
            mode: patch.mode,
            allowLan: patch.allowLan,
            externalController: patch.externalController,
          ),
        );
    await _ref.read(vpnOptionsProvider.future);
    if (!_canStart(profile, email, revision, session)) return false;
    final problem = await native.saveState(_ref.read(sharedStateProvider));
    if (problem.isNotEmpty || !_canStart(profile, email, revision, session)) {
      return false;
    }
    _ref.read(groupsProvider.notifier).value = const [];
    return gateway.setRunning(true);
  }
}
