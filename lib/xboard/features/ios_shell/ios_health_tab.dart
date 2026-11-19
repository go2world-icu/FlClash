import 'dart:convert';
import 'dart:io';

import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/ios_lifecycle.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/initialization/initialization.dart';
import 'package:fl_clash/xboard/features/profile/models/import_models.dart';
import 'package:fl_clash/xboard/features/profile/providers/profile_import_provider.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prism_ui/prism_ui.dart';

import 'ios_connection_activity.dart';
import 'ios_managed_connection.dart';
import 'ios_member_strings.dart';

typedef _HealthResult = ({
  bool channelReady,
  bool? tunnelReady,
  IpInfo? exit,
  int? delay,
});

class IosHealthTab extends ConsumerStatefulWidget {
  const IosHealthTab({super.key});

  @override
  ConsumerState<IosHealthTab> createState() => _IosHealthTabState();
}

class _IosHealthTabState extends ConsumerState<IosHealthTab> {
  bool _checking = false;
  bool _sending = false;
  int _revision = 0;
  _HealthResult? _result;

  void _resetResult() {
    if (!_checking && _result == null) return;
    _revision++;
    setState(() {
      _checking = false;
      _result = null;
    });
  }

  Future<void> _check() async {
    if (_checking) return;
    final line = ref.read(iosSelectedLineProvider);
    final revision = ++_revision;
    setState(() {
      _checking = true;
      _result = null;
    });
    var channelReady = false;
    bool? tunnelReady;
    IpInfo? exit;
    int? delay;
    try {
      channelReady = await ref.refresh(iosCoreChannelProvider.future);
      if (!channelReady || !mounted || revision != _revision) return;
      tunnelReady = false;
      final state = await ref.refresh(iosCoreBootProvider.future);
      tunnelReady = state?.booted == true && state?.tunStarted == true;
      if (tunnelReady && line != null && mounted && revision == _revision) {
        final reply = await ref
            .read(coreHandlerProvider)
            .outboundIp(
              OutboundIpParams(
                proxyName: line,
                urls: const [iosManagedProbeUrl],
                timeout: outboundIpTimeoutDuration.inMilliseconds,
              ),
            );
        if (reply.error == null && reply.url == iosManagedProbeUrl) {
          final candidate = IpInfo.fromCloudflareTrace(reply.body);
          if (InternetAddress.tryParse(candidate.ip) != null &&
              RegExp(r'^[A-Z]{2}$').hasMatch(candidate.countryCode)) {
            exit = candidate;
            delay = reply.delay > 0 ? reply.delay : null;
          }
        }
      }
    } catch (_) {
      exit = null;
    } finally {
      if (mounted && revision == _revision) {
        setState(() {
          _checking = false;
          _result = (
            channelReady: channelReady,
            tunnelReady: tunnelReady,
            exit: exit,
            delay: delay,
          );
        });
      }
    }
  }

  Future<void> _copySummary(String summary) async {
    try {
      await Clipboard.setData(ClipboardData(text: summary));
      if (mounted) dialogs.showBanner(context.iosMemberStrings.summaryCopied);
    } catch (_) {
      if (mounted) {
        dialogs.showBanner(
          context.iosMemberStrings.copyFailed,
          level: BannerLevel.error,
        );
      }
    }
  }

  Future<void> _report(String status, List<(String, String)> checks) async {
    if (_sending) return;
    final result = _result;
    final packageInfo = globalState.packageInfo;
    final payload = {
      'app_version': packageInfo.version,
      'build_number': packageInfo.buildNumber,
      'vpn_status': status,
      'channel_ready': result?.channelReady,
      'tunnel_ready': result?.tunnelReady,
      'exit_verified': result == null ? null : result.exit != null,
      'response_ms': result?.delay,
    };
    final strings = context.iosMemberStrings;
    final canSend = ref.read(initializationProvider).isReady;
    final summary = [
      '${strings.appVersion} · ${packageInfo.version} (${packageInfo.buildNumber})',
      for (final (label, value) in checks) '$label · $value',
    ].join('\n');
    setState(() => _sending = true);
    try {
      final confirmed = await dialogs.showCommonDialog<bool>(
        context: context,
        child: Builder(
          builder: (context) => AlertDialog(
            title: strings.diagnosticReport,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(context.appLocalizations.close),
              ),
              TextButton(
                onPressed: () => _copySummary(summary),
                child: Text(strings.copySummary),
              ),
              TextButton(
                onPressed: canSend
                    ? () => Navigator.of(context).pop(true)
                    : null,
                child: Text(strings.sendReport),
              ),
            ],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(summary),
                const SizedBox(height: 10),
                Text(strings.confirmReport),
              ],
            ),
          ),
        ),
      );
      if (confirmed != true ||
          !mounted ||
          !ref.read(xboardUserProvider).isAuthenticated ||
          !ref.read(initializationProvider).isReady) {
        return;
      }
      final sent = await XBoardSDK.instance.reportLog(
        utf8.encode(jsonEncode(payload)),
        'toworld-connection.log',
        customUrl: XBoardConfig.reportLogUrl,
      );
      if (mounted) _reportFeedback(sent);
    } catch (_) {
      if (mounted) _reportFeedback(false);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _reportFeedback(bool sent) => dialogs.showBanner(
    sent
        ? context.iosMemberStrings.reportSent
        : context.iosMemberStrings.reportFailed,
    level: sent ? BannerLevel.info : BannerLevel.error,
  );

  @override
  Widget build(BuildContext context) {
    final app = context.appLocalizations;
    final strings = context.iosMemberStrings;
    ref.listen(iosTunnelStatusProvider, (_, _) => _resetResult());
    ref.listen(iosSelectedLineProvider, (_, _) => _resetResult());
    ref.listen(currentProfileIdProvider, (_, _) => _resetResult());
    ref.listen(
      routeTrackerProvider.select(
        (route) => (route.coreEpoch, route.routeVersion, route.hostEpoch),
      ),
      (_, _) => _resetResult(),
    );
    final status = ref.watch(iosTunnelStatusProvider);
    final active = hasActiveIosPlan(
      ref.watch(subscriptionInfoProvider),
      ref.watch(userInfoProvider),
    );
    final profile = ref.watch(iosManagedProfileProvider);
    final (syncing, accountSyncFailed) = ref.watch(
      xboardUserProvider.select(
        (state) => (state.isLoading, state.membershipRefreshFailed),
      ),
    );
    final (importing, failed, errorType) = ref.watch(
      profileImportProvider.select(
        (state) => (
          state.isImporting,
          state.status == ImportStatus.failed,
          state.lastResult?.errorType,
        ),
      ),
    );
    final connected = status == 'connected';
    final line = ref.watch(iosSelectedLineProvider);
    final result = _result;
    final exit = result?.exit;
    final tunnelStatus = switch (status) {
      'connected' => app.connected,
      'connecting' || 'reasserting' => app.connecting,
      'disconnecting' => strings.disconnecting,
      _ => strings.notConnected,
    };
    final title = switch (result) {
      _ when _checking => xboardL10n.checking,
      _ when !connected => strings.waitingForVpn,
      null when line == null => strings.selectLineToCheck,
      null => strings.readyToCheck,
      _ when !result.channelReady => strings.extensionUnavailable,
      _ when result.tunnelReady != true => strings.tunnelUnavailable,
      _ when exit != null => strings.connectionHealthy,
      _ when line == null => strings.selectLineToCheck,
      _ => strings.exitFailed,
    };
    final configuration = switch (errorType) {
      _ when importing || profile.isLoading => app.loading,
      ImportErrorType.networkError ||
      ImportErrorType.downloadError when failed => strings.configDownloadFailed,
      ImportErrorType.validationError when failed =>
        strings.configValidationFailed,
      ImportErrorType.storageError when failed => strings.configSaveFailed,
      _ when failed || profile.hasError => strings.configSyncFailed,
      _ when profile.asData?.value != null => strings.synced,
      _ => strings.needsSync,
    };
    final channel = switch (result?.channelReady) {
      true => strings.reachable,
      false => strings.extensionUnavailable,
      null => connected ? strings.notChecked : strings.waitingForConnection,
    };
    final core = switch (result?.tunnelReady) {
      true => strings.ready,
      false => strings.coreUnavailable,
      null => connected ? strings.notChecked : strings.waitingForConnection,
    };
    final checks = [
      (strings.vpnTunnel, tunnelStatus),
      (strings.extensionChannel, channel),
      (strings.coreStartup, core),
    ];
    final responseTime = result?.delay == null ? '—' : '${result!.delay} ms';
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      children: [
        Card(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              GlyphIcon(
                exit == null
                    ? XBoardGlyphs.networkCheck
                    : AppGlyphs.checkCircle,
                color: context.colorScheme.primary,
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyle.headline.of(context)),
                    const SizedBox(height: 4),
                    Text(
                      !connected
                          ? strings.healthDisconnectedHint
                          : exit != null
                          ? strings.healthSuccessHint
                          : result?.tunnelReady == true
                          ? strings.healthFailedHint
                          : strings.healthReadyHint,
                      style: AppTextStyle.subheadline.of(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _CheckSection(
          title: strings.connectionChecklist,
          values: [
            (
              strings.accountAndPlan,
              syncing
                  ? app.loading
                  : accountSyncFailed
                  ? strings.accountSyncFailed
                  : active
                  ? strings.valid
                  : xboardL10n.subscriptionNoSubscription,
            ),
            (strings.configuration, configuration),
            ...checks,
          ],
        ),
        const SizedBox(height: 12),
        const IosConnectionActivityCard(),
        const SizedBox(height: 12),
        _CheckSection(
          title: strings.exitVerification,
          status: result == null
              ? strings.notChecked
              : exit == null
              ? strings.exitFailed
              : strings.passed,
          values: [
            (context.iosMemberStrings.exitRegion, exit?.countryCode ?? '—'),
            (context.iosMemberStrings.exitIp, exit?.ip ?? '—'),
            (strings.responseTime, responseTime),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: connected && !_checking ? _check : null,
          child: Text(
            _checking
                ? xboardL10n.checking
                : !connected
                ? strings.connectFirst
                : result == null
                ? strings.checkConnection
                : strings.recheckConnection,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          context.iosMemberStrings.exitCheckDisclosure,
          style: AppTextStyle.footnote
              .of(context)
              .copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
        TextButton(
          onPressed: _sending
              ? null
              : () => _report(status, [
                  ...checks,
                  (strings.exitVerification, title),
                  (strings.responseTime, responseTime),
                ]),
          child: Text(strings.viewDiagnosticReport),
        ),
      ],
    );
  }
}

class _CheckSection extends StatelessWidget {
  const _CheckSection({required this.title, required this.values, this.status});

  final String title;
  final List<(String, String)> values;
  final String? status;

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: AppTextStyle.headline.of(context)),
              ),
              if (status != null)
                Text(status!, style: AppTextStyle.footnote.of(context)),
            ],
          ),
          const SizedBox(height: 6),
          for (final (label, value) in values)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyle.subheadline
                          .of(context)
                          .copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      value,
                      textAlign: TextAlign.end,
                      style: AppTextStyle.subheadline.of(
                        context,
                        emphasized: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
