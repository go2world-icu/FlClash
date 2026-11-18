import 'dart:io';

import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/plugins/ios_service.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:fl_clash/xboard/features/auth/models/auth_state.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_line_page.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_managed_connection.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_shell_page.dart';
import 'package:fl_clash/xboard/services/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/common_button.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/app_paths.dart';
import '../support/xboard_provider_fakes.dart';
import '../support/xboard_support.dart';

const _email = 'member@example.test';
const _member = UserAuthState(
  isAuthenticated: true,
  isInitialized: true,
  email: _email,
);
const _plan = DomainSubscription(
  subscribeUrl: 'https://toworld.example.test/subscribe',
  email: _email,
  uuid: 'test',
  planId: 1,
  planName: 'Member Plan',
  transferLimit: 10 * 1024 * 1024 * 1024,
  uploadedBytes: 0,
  downloadedBytes: 2 * 1024 * 1024 * 1024,
);

class _Core extends Mock implements CoreHandlerInterface {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => AppLocalizations.load(const Locale('en')));

  test('only an owned or matching stored subscription can start', () async {
    final home = await Directory.systemTemp.createTemp('toworld-ios-panel');
    addTearDown(() => home.delete(recursive: true));
    await useAppPaths(home);
    const manual = Profile(
      id: 11,
      autoUpdateDuration: Duration.zero,
      url: 'https://unrelated.example.test/profile',
    );
    final file = await manual.file;
    await file.parent.create(recursive: true);
    await file.writeAsString('proxies: []');
    final storage = XBoardStorageService(FakeStorage());

    Future<Profile?> verifiedProfile() async {
      final container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          xboardUserProvider.overrideWith(() => FakeUserAuthNotifier(_member)),
          subscriptionInfoProvider.overrideWithBuild((_, _) => _plan),
          currentProfileProvider.overrideWithValue(manual),
        ],
      );
      final listener = container.listen(iosManagedProfileProvider, (_, _) {});
      try {
        return await container.read(iosManagedProfileProvider.future);
      } finally {
        listener.close();
        container.dispose();
      }
    }

    expect(await verifiedProfile(), isNull);
    await storage.setOwnedProfileIds('someone-else@example.test', [manual.id]);
    expect(await verifiedProfile(), isNull);
    await storage.setOwnedProfileIds(_email, [manual.id]);
    expect(await verifiedProfile(), manual);
  });

  test(
    'automatic lines and nodes are offered without direct or policy groups',
    () {
      const node = Proxy(name: 'Hong Kong', type: 'Shadowsocks');
      const automatic = Proxy(name: 'Fastest', type: 'URLTest');
      const direct = Proxy(name: 'DIRECT', type: 'Direct');
      const global = Group(
        name: 'GLOBAL',
        type: GroupType.Selector,
        all: [node],
      );
      const group = Group(
        name: 'ToWorld',
        type: GroupType.Selector,
        all: [automatic, node, direct],
      );
      const autoGroup = Group(
        name: 'Fastest',
        type: GroupType.URLTest,
        all: [node],
      );

      final lines = iosManagedLines([global, group, autoGroup]);
      expect(lines?.group, group);
      expect(lines?.options, [automatic, node]);
      expect(hasActiveIosPlan(_plan, null), isTrue);
      expect(
        hasActiveIosPlan(
          _plan.copyWith(downloadedBytes: _plan.transferLimit),
          null,
        ),
        isFalse,
      );
    },
  );

  testWidgets('shows the member home and keeps a manual profile disconnected', (
    tester,
  ) async {
    await pumpXboard(
      tester,
      const XBoardIosShell(),
      overrides: [
        ...xboardBaseOverrides(),
        xboardUserProvider.overrideWith(() => FakeUserAuthNotifier(_member)),
        subscriptionInfoProvider.overrideWithBuild((_, _) => _plan),
        iosManagedProfileProvider.overrideWith((_) => null),
        currentProfileProvider.overrideWithValue(null),
        selectedMapProvider.overrideWithValue(const {}),
        initProvider.overrideWithBuild((_, _) => true),
      ],
    );
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(find.text('Member Plan'), findsOneWidget);
    expect(find.text('8.00 GB'), findsOneWidget);
    final connect = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Connect'),
    );
    expect(connect.onPressed, isNull);

    await tester.tap(find.text('Connection health'));
    await tester.pumpAndSettle();
    expect(find.text('Waiting for the VPN'), findsOneWidget);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(XBoardIosShell)),
    );
    container.read(iosTunnelStatusProvider.notifier).update('connected');
    await tester.pumpAndSettle();
    expect(find.text('Select a managed line to check'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 10));
  });
  testWidgets(
    'managed sign-in asks the member to read the privacy information',
    (tester) async {
      await pumpXboard(
        tester,
        const XBoardIosShell(),
        overrides: [
          ...xboardBaseOverrides(),
          xboardUserProvider.overrideWith(
            () =>
                FakeUserAuthNotifier(const UserAuthState(isInitialized: true)),
          ),
        ],
      );
      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();
      final signIn = find.widgetWithText(
        material.FilledButton,
        'Sign in and sync',
      );
      expect(tester.widget<material.FilledButton>(signIn).onPressed, isNull);
      await tester.tap(find.byType(material.Checkbox));
      await tester.pumpAndSettle();
      expect(tester.widget<material.FilledButton>(signIn).onPressed, isNotNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 10));
    },
  );

  testWidgets('health checks the ToWorld endpoint and clears stale results', (
    tester,
  ) async {
    final core = _Core();
    const request = OutboundIpParams(
      proxyName: 'Hong Kong 01',
      urls: ['https://toworld.uk/cdn-cgi/trace'],
      timeout: 6000,
    );
    registerFallbackValue(request);
    when(() => core.outboundIp(any())).thenAnswer(
      (_) async => const OutboundIpResult(
        url: 'https://toworld.uk/cdn-cgi/trace',
        body: 'ip=203.0.113.24\nloc=HK\n',
        delay: 42,
      ),
    );
    const node = Proxy(name: 'Hong Kong 01', type: 'Shadowsocks');
    const group = Group(
      name: 'ToWorld',
      type: GroupType.Selector,
      all: [node],
      now: 'Hong Kong 01',
    );
    const profile = Profile(id: 42, autoUpdateDuration: Duration.zero);
    await pumpXboard(
      tester,
      const XBoardIosShell(),
      overrides: [
        ...xboardBaseOverrides(),
        xboardUserProvider.overrideWith(() => FakeUserAuthNotifier(_member)),
        subscriptionInfoProvider.overrideWithBuild((_, _) => _plan),
        iosManagedProfileProvider.overrideWith((_) => profile),
        currentProfileProvider.overrideWithValue(profile),
        selectedMapProvider.overrideWithValue(const {}),
        iosManagedLinesProvider.overrideWith(
          (_) => (group: group, options: [node]),
        ),
        iosCoreBootProvider.overrideWith(
          (_) async =>
              const IosCoreState(booted: true, tunStarted: true, error: ''),
        ),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
      ],
    );
    tester.view.physicalSize = const Size(390, 844);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(XBoardIosShell)),
    );
    container.read(iosTunnelStatusProvider.notifier).update('connected');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hong Kong 01'));
    await tester.pumpAndSettle();
    expect(find.byType(IosLinePage), findsOneWidget);
    expect(find.text('Test line response times'), findsOneWidget);
    Navigator.of(tester.element(find.byType(IosLinePage))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Connection health'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check connection'));
    await tester.pumpAndSettle();
    expect(find.text('Exit verified'), findsOneWidget);
    expect(find.text('203.0.113.24'), findsOneWidget);
    expect(find.text('42 ms'), findsOneWidget);
    final calls = verify(() => core.outboundIp(captureAny())).captured;
    final called = calls.single as OutboundIpParams;
    expect(called.urls, request.urls);
    expect(called.proxyName, request.proxyName);
    container.read(iosTunnelStatusProvider.notifier).update('disconnected');
    await tester.pumpAndSettle();
    expect(find.text('203.0.113.24'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 10));
  });
}
