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
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prism_ui/prism_ui.dart';

import 'ios_managed_connection.dart';
import 'ios_member_strings.dart';

typedef _HealthResult = ({bool tunnelReady, IpInfo? exit, int? delay});

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
    if (line == null) return;
    final revision = ++_revision;
    setState(() {
      _checking = true;
      _result = null;
    });
    var ready = false;
    IpInfo? exit;
    int? delay;
    try {
      final state = await ref.refresh(iosCoreBootProvider.future);
      ready = state?.booted == true && state?.tunStarted == true;
      if (ready && mounted && revision == _revision) {
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
          _result = (tunnelReady: ready, exit: exit, delay: delay);
        });
      }
    }
  }

  Future<void> _report(String status) async {
    if (_sending) return;
    final result = _result;
    final payload = {
      'app_version': globalState.packageInfo.version,
      'vpn_status': status,
      'tunnel_ready': result?.tunnelReady,
      'exit_verified': result == null ? null : result.exit != null,
      'response_ms': result?.delay,
    };
    setState(() => _sending = true);
    try {
      final confirmed = await dialogs.showMessage(
        context: context,
        title: context.iosMemberStrings.diagnosticReport,
        message: TextSpan(text: context.iosMemberStrings.confirmReport),
        confirmText: context.iosMemberStrings.sendReport,
        cancelText: context.appLocalizations.cancel,
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
    final syncing =
        profile.isLoading ||
        ref.watch(xboardUserProvider.select((state) => state.isLoading));
    final connected = status == 'connected';
    final line = ref.watch(iosSelectedLineProvider);
    final result = _result;
    final exit = result?.exit;
    final initReady = ref.watch(
      initializationProvider.select((state) => state.isReady),
    );
    final tunnelStatus = switch (status) {
      'connected' => app.connected,
      'connecting' || 'reasserting' => app.connecting,
      'disconnecting' => context.iosMemberStrings.disconnecting,
      _ => app.disconnected,
    };
    final title = switch (result) {
      _ when _checking => xboardL10n.checking,
      _ when !connected => context.iosMemberStrings.waitingForVpn,
      _ when line == null => context.iosMemberStrings.selectLineToCheck,
      null => context.iosMemberStrings.readyToCheck,
      _ when exit != null => context.iosMemberStrings.exitVerified,
      _ when !result.tunnelReady => context.iosMemberStrings.tunnelUnavailable,
      _ => context.iosMemberStrings.exitFailed,
    };
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
                child: Text(title, style: AppTextStyle.headline.of(context)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _CheckSection(
          title: context.iosMemberStrings.connectionChecklist,
          values: [
            (
              context.iosMemberStrings.membership,
              active
                  ? xboardL10n.subscriptionValid
                  : xboardL10n.subscriptionNoSubscription,
            ),
            (
              context.iosMemberStrings.configuration,
              syncing
                  ? app.loading
                  : profile.asData?.value != null
                  ? context.iosMemberStrings.synced
                  : context.iosMemberStrings.needsSync,
            ),
            (xboardL10n.iosTunnel, tunnelStatus),
          ],
        ),
        const SizedBox(height: 12),
        _CheckSection(
          title: context.iosMemberStrings.exitVerification,
          values: [
            (context.iosMemberStrings.exitRegion, exit?.countryCode ?? '—'),
            (context.iosMemberStrings.exitIp, exit?.ip ?? '—'),
            (
              context.iosMemberStrings.responseTime,
              result?.delay == null ? '—' : '${result!.delay} ms',
            ),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed:
              connected &&
                  !_checking &&
                  profile.asData?.value != null &&
                  line != null
              ? _check
              : null,
          child: Text(
            _checking
                ? xboardL10n.checking
                : context.iosMemberStrings.checkConnection,
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
          onPressed: _sending || !initReady ? null : () => _report(status),
          child: Text(context.iosMemberStrings.diagnosticReport),
        ),
      ],
    );
  }
}

class _CheckSection extends StatelessWidget {
  const _CheckSection({required this.title, required this.values});

  final String title;
  final List<(String, String)> values;

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppTextStyle.headline.of(context)),
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
