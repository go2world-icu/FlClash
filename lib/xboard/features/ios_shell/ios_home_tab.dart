import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/ios_lifecycle.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/profile/models/import_models.dart';
import 'package:fl_clash/xboard/features/profile/providers/profile_import_provider.dart';
import 'package:fl_clash/xboard/features/initialization/initialization.dart';
import 'package:fl_clash/xboard/features/shared/widgets/notice_banner.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prism_ui/prism_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ios_line_page.dart';
import 'ios_line_country.dart';
import 'ios_managed_connection.dart';
import 'ios_member_strings.dart';
import 'ios_member_colors.dart';

class IosHomeTab extends ConsumerStatefulWidget {
  const IosHomeTab({super.key});

  @override
  ConsumerState<IosHomeTab> createState() => _IosHomeTabState();
}

class _IosHomeTabState extends ConsumerState<IosHomeTab> {
  bool _switching = false;
  bool _refreshing = false;
  bool _refreshFailed = false;
  bool _connectionFailed = false;
  bool _requestedConnect = false;

  Future<void> _setRunning(bool running) async {
    if (_switching) return;
    setState(() {
      _switching = true;
      _requestedConnect = running;
      _connectionFailed = false;
    });
    var ok = false;
    try {
      ok = await ref.read(iosManagedConnectionProvider).setRunning(running);
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _switching = false;
          _connectionFailed = _connectionFailed || !ok;
        });
      }
    }
  }

  Future<void> _refresh() async {
    if (_refreshing) return;
    setState(() {
      _refreshing = true;
      _refreshFailed = false;
    });
    try {
      final initialization = ref.read(initializationProvider);
      if (!initialization.isReady) {
        await ref.read(initializationProvider.notifier).refresh();
        if (!mounted) return;
      }
      await ref.read(xboardUserProvider.notifier).refreshSubscriptionInfo();
    } catch (_) {
      if (mounted) setState(() => _refreshFailed = true);
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.appLocalizations;
    final IosMemberStrings strings = context.iosMemberStrings;
    ref.listen(iosTunnelStatusProvider, (before, after) {
      if (after == 'connected' && _connectionFailed) {
        setState(() => _connectionFailed = false);
      }
      if (_requestedConnect &&
          before == 'connecting' &&
          after == 'disconnected') {
        setState(() => _connectionFailed = true);
      }
    });
    final native = ref.watch(iosTunnelStatusProvider);
    final isRunning = ref.watch(isStartProvider);
    final connected = native == 'connected';
    final starting = native == 'connecting' || native == 'reasserting';
    final stopping = native == 'disconnecting';
    final canStop = connected || starting || isRunning;
    final initializing = !ref.watch(initProvider);
    final (importing, importFailed) = ref.watch(
      profileImportProvider.select(
        (state) => (state.isImporting, state.status == ImportStatus.failed),
      ),
    );
    final profile = ref.watch(iosManagedProfileProvider);
    final subscription = ref.watch(subscriptionInfoProvider);
    final user = ref.watch(userInfoProvider);
    final active = hasActiveIosPlan(subscription, user);
    final ready = profile.asData?.value != null && active;
    final currentLine = ref.watch(iosSelectedLineProvider);
    final currentLineFlag = iosLineCountryFlag(currentLine ?? '');
    final (syncingAccount, accountSyncFailed) = ref.watch(
      xboardUserProvider.select(
        (state) => (state.isLoading, state.membershipRefreshFailed),
      ),
    );
    final syncPending =
        _refreshing || importing || profile.isLoading || syncingAccount;
    final safeMode = ref.watch(safeModeProvider);
    final showNotice = ref.watch(
      initializationProvider.select((state) => state.isReady),
    );
    final status = switch (native) {
      'connected' => app.connected,
      'connecting' || 'reasserting' => app.connecting,
      'disconnecting' => strings.disconnecting,
      _ => strings.notConnected,
    };
    final statusHint = safeMode && !canStop
        ? app.safeMode
        : _connectionFailed
        ? strings.connectionFailed
        : _switching || starting || stopping
        ? strings.waitingForResponse
        : connected
        ? strings.vpnRunning
        : syncPending || initializing
        ? strings.syncing
        : ready
        ? strings.syncedAndReady
        : active
        ? strings.refreshToSync
        : strings.membershipRequired;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      children: [
        if (showNotice) const NoticeBanner(),
        DecoratedBox(
          decoration: const ShapeDecoration(
            gradient: IosMemberColors.gradient,
            shape: AppShape.xl,
          ),
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    DecoratedBox(
                      decoration: const ShapeDecoration(
                        color: Color(0x33c5dcff),
                        shape: AppShape.md,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: const GlyphIcon(
                          XBoardGlyphs.shieldCheck,
                          color: Color(0xffd4e4fa),
                          size: 22,
                        ),
                      ),
                    ),
                    const Spacer(),
                    DecoratedBox(
                      decoration: ShapeDecoration(
                        color: connected
                            ? const Color(0xff0d634c)
                            : const Color(0x33e1eeff),
                        shape: AppShape.full,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        child: Text(
                          status,
                          style: AppTextStyle.footnote
                              .of(context, emphasized: true)
                              .copyWith(color: const Color(0xfff0f6ff)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  connected
                      ? strings.vpnConnected
                      : ready && !starting && !stopping && !_switching
                      ? strings.readyToConnect
                      : app.connection,
                  style: AppTextStyle.title1
                      .of(context, emphasized: true)
                      .copyWith(color: const Color(0xfff4f9ff)),
                ),
                const SizedBox(height: 6),
                Text(
                  statusHint,
                  style: AppTextStyle.subheadline
                      .of(context)
                      .copyWith(color: const Color(0xffd4e4fa)),
                ),
                if (connected) ...[
                  const SizedBox(height: 10),
                  const _IosLiveTraffic(),
                ],
                const SizedBox(height: 15),
                FilledButton.icon(
                  style: ButtonStyle.from(
                    backgroundColor: const Color(0xffedf5ff),
                    foregroundColor: const Color(0xff143762),
                  ),
                  onPressed:
                      _switching ||
                          stopping ||
                          (!canStop &&
                              (!ready ||
                                  syncPending ||
                                  initializing ||
                                  safeMode))
                      ? null
                      : () => _setRunning(!canStop),
                  icon: GlyphIcon(
                    AppGlyphs.playPause(canStop ? 1 : 0),
                    fill: 1,
                  ),
                  label: Text(canStop ? strings.disconnect : strings.connect),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          padding: const EdgeInsets.all(13),
          onPressed: () => Navigator.of(context).push<void>(
            PageRouteBuilder<void>(
              pageBuilder: (_, _, _) => const IosLinePage(),
            ),
          ),
          child: Row(
            children: [
              if (currentLineFlag != null)
                SizedBox.square(
                  dimension: 28,
                  child: Center(
                    child: EmojiText(
                      currentLineFlag,
                      style: AppTextStyle.title2.of(context),
                    ),
                  ),
                )
              else
                GlyphIcon(
                  XBoardGlyphs.router,
                  color: context.colorScheme.primary,
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.currentLine,
                      style: AppTextStyle.footnote.of(context),
                    ),
                    Text(
                      currentLine?.isNotEmpty == true
                          ? currentLine!
                          : strings.managedLines,
                      style: AppTextStyle.subheadline.of(
                        context,
                        emphasized: true,
                      ),
                    ),
                  ],
                ),
              ),
              const GlyphIcon(AppGlyphs.chevronForward),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const IosMembershipCard(),
        if (!syncPending && accountSyncFailed)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              strings.accountSyncFailed,
              style: AppTextStyle.footnote
                  .of(context)
                  .copyWith(color: context.colorScheme.error),
            ),
          ),
        if (!syncPending && (_refreshFailed || importFailed))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              strings.membershipSyncFailed,
              style: AppTextStyle.footnote
                  .of(context)
                  .copyWith(color: context.colorScheme.error),
            ),
          ),
        TextButton(
          onPressed: syncPending ? null : _refresh,
          child: Text(
            syncPending ? strings.syncing : strings.refreshMembership,
          ),
        ),
      ],
    );
  }
}

class _IosLiveTraffic extends ConsumerWidget {
  const _IosLiveTraffic();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final traffic = ref.watch(
      trafficsProvider.select((state) => state.list.safeLast(const Traffic())),
    );
    final runTime = ref.watch(runTimeProvider);
    final strings = context.iosMemberStrings;
    final metrics = [
      (strings.upstream, '${traffic.up.traffic.show}/s'),
      (strings.downstream, '${traffic.down.traffic.show}/s'),
      (context.iosMemberStrings.connectionDuration, getTimeText(runTime)),
    ];
    return Row(
      children: [
        for (final (label, value) in metrics)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyle.footnote
                      .of(context)
                      .copyWith(color: const Color(0xffd4e4fa)),
                ),
                Text(
                  value,
                  style: AppTextStyle.subheadline
                      .of(context, emphasized: true)
                      .copyWith(color: const Color(0xfff4f9ff)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

final iosMembershipWebsiteProvider = Provider<Uri?>((ref) {
  ref.watch(initializationProvider.select((state) => state.isReady));
  for (final url in [XBoardConfig.panelUrl, XBoardConfig.appWebsite]) {
    final uri = url == null ? null : Uri.tryParse(url.trim());
    if (uri != null &&
        (uri.isScheme('https') || uri.isScheme('http')) &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty) {
      return uri;
    }
  }
  return null;
});

class IosMembershipCard extends ConsumerWidget {
  const IosMembershipCard({super.key, this.showDetails = false});

  final bool showDetails;

  Future<void> _renew(BuildContext context, Uri website) async {
    try {
      if (await launchUrl(website, mode: LaunchMode.externalApplication)) {
        return;
      }
    } catch (_) {}
    if (context.mounted) {
      dialogs.showBanner(
        context.iosMemberStrings.openWebsiteFailed,
        level: BannerLevel.error,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(subscriptionInfoProvider);
    final user = ref.watch(userInfoProvider);
    final colors = context.colorScheme;
    final active = hasActiveIosPlan(plan, user);
    final expiry = plan?.expiredAt;
    final days = plan?.daysRemaining;
    final strings = context.iosMemberStrings;
    final nearExpiry = days != null && days < 10;
    final website = ref.watch(iosMembershipWebsiteProvider);
    final offerRenewal =
        website != null &&
        user?.banned != true &&
        (showDetails ||
            !active ||
            nearExpiry ||
            (plan?.usagePercentage ?? 0) >= 80);
    final syncedAt = showDetails
        ? ref.watch(
            iosManagedProfileProvider.select(
              (state) => state.asData?.value?.lastUpdateDate,
            ),
          )
        : null;
    final label = switch (plan) {
      _ when user?.banned == true => context.iosMemberStrings.accountRestricted,
      null => xboardL10n.xboardNoSubscriptionInfo,
      _ when plan.isExpired => xboardL10n.subscriptionExpired,
      _ when plan.transferLimit > 0 && plan.isTrafficExhausted =>
        xboardL10n.subscriptionTrafficExhausted,
      _ when active && nearExpiry => strings.daysRemaining(days),
      _ when active => xboardL10n.subscriptionValid,
      _ => xboardL10n.subscriptionNoSubscription,
    };
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).languageCode,
    );
    if (showDetails) {
      return Card(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan?.planName?.isNotEmpty == true
                        ? plan!.planName!
                        : strings.membership,
                    style: AppTextStyle.headline.of(context),
                  ),
                ),
                if (offerRenewal)
                  TextButton.icon(
                    onPressed: () => _renew(context, website),
                    icon: const GlyphIcon(AppGlyphs.openExternal),
                    label: Text(strings.renewedOnWebsite),
                  ),
              ],
            ),
            if (plan == null || !active)
              Text(label, style: AppTextStyle.footnote.of(context)),
            if (plan != null && plan.transferLimit > 0)
              _DetailRow(
                label: strings.usedDataLabel,
                value:
                    '${plan.formattedUsedTraffic} / ${plan.formattedTotalTraffic}',
              ),
            if (expiry != null)
              _DetailRow(
                label: strings.expiryDate,
                value: dateFormat.format(expiry.toLocal()),
              ),
            if (syncedAt != null)
              _DetailRow(
                label: strings.latestConfigSync,
                value: dateFormat.add_jm().format(syncedAt.toLocal()),
              ),
          ],
        ),
      );
    }
    return Card(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan?.planName?.isNotEmpty == true
                      ? plan!.planName!
                      : strings.membership,
                  style: AppTextStyle.headline.of(context),
                ),
              ),
              DecoratedBox(
                decoration: ShapeDecoration(
                  color: active
                      ? IosMemberColors.badge
                      : colors.surfaceContainerHighest,
                  shape: AppShape.full,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  child: Text(
                    label,
                    style: AppTextStyle.footnote
                        .of(context)
                        .copyWith(
                          color: active
                              ? IosMemberColors.foreground
                              : colors.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
            ],
          ),
          if (plan != null && plan.transferLimit > 0) ...[
            const SizedBox(height: 10),
            Text(
              strings.remainingData,
              style: AppTextStyle.footnote.of(context),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.formattedRemainingTraffic,
                    style: AppTextStyle.title1.of(context, emphasized: true),
                  ),
                ),
                Text(
                  strings.total(plan.formattedTotalTraffic),
                  style: AppTextStyle.footnote.of(context),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Semantics(
              label: strings.remainingData,
              value: plan.formattedRemainingTraffic,
              child: LayoutBuilder(
                builder: (_, constraints) => Container(
                  height: 5,
                  decoration: ShapeDecoration(
                    color: colors.surfaceContainerHighest,
                    shape: AppShape.full,
                  ),
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    width:
                        constraints.maxWidth * (1 - plan.usagePercentage / 100),
                    decoration: ShapeDecoration(
                      color: colors.primary,
                      shape: AppShape.full,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
          if (expiry != null || offerRenewal)
            Row(
              children: [
                Expanded(
                  child: Text(
                    expiry == null
                        ? ''
                        : strings.expiresOn(
                            dateFormat.format(expiry.toLocal()),
                          ),
                    style: AppTextStyle.footnote
                        .of(context)
                        .copyWith(color: colors.onSurfaceVariant),
                  ),
                ),
                if (offerRenewal)
                  TextButton.icon(
                    onPressed: () => _renew(context, website),
                    icon: const GlyphIcon(AppGlyphs.openExternal),
                    label: Text(strings.renewedOnWebsite),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyle.subheadline
                .of(context)
                .copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyle.subheadline.of(context, emphasized: true),
          ),
        ),
      ],
    ),
  );
}
