import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/qr_code.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prism_ui/prism_ui.dart';

import 'ios_home_tab.dart';
import 'ios_member_strings.dart';
import 'ios_member_colors.dart';

class IosInvitePage extends ConsumerStatefulWidget {
  const IosInvitePage({super.key});

  @override
  ConsumerState<IosInvitePage> createState() => _IosInvitePageState();
}

class _IosInvitePageState extends ConsumerState<IosInvitePage> {
  @override
  void initState() {
    super.initState();
    unawaited(
      Future<void>.microtask(() {
        if (mounted) return ref.read(inviteProvider.notifier).loadInviteData();
      }),
    );
  }

  Future<void> _copy(String link) async {
    try {
      await Clipboard.setData(ClipboardData(text: link));
      if (mounted) dialogs.showBanner(xboardL10n.copiedToClipboard);
    } catch (_) {
      if (mounted) {
        dialogs.showBanner(
          context.iosMemberStrings.copyFailed,
          level: BannerLevel.error,
        );
      }
    }
  }

  Future<void> _share(String link) => dialogs.showCommonDialog<void>(
    context: context,
    child: Builder(
      builder: (context) => AlertDialog(
        title: context.iosMemberStrings.shareInvite,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.appLocalizations.close),
          ),
          TextButton(
            onPressed: () => _copy(link),
            child: Text(context.iosMemberStrings.copyLink),
          ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrCodeView(data: link, size: 150),
            const SizedBox(height: 8),
            Text(context.iosMemberStrings.inviteLink),
            SelectableText(link, textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final strings = context.iosMemberStrings;
    final invite = ref.watch(inviteProvider);
    final rate = NumberFormat('0.##').format(invite.commissionRate);
    final activeCode = invite.inviteData?.codes
        .where((code) => code.isAvailable && code.code.isNotEmpty)
        .firstOrNull;
    final website = ref.watch(iosMembershipWebsiteProvider);
    final link = activeCode == null || website == null
        ? null
        : website
              .resolve('login')
              .replace(
                query: null,
                fragment:
                    '/register?${Uri(queryParameters: {'code': activeCode.code}).query}',
              )
              .toString();
    final loading = invite.isLoading || invite.isGenerating;
    ref.listen(inviteProvider.select((state) => state.errorMessage), (
      _,
      error,
    ) {
      if (error != null) dialogs.showBanner(error, level: BannerLevel.error);
    });
    return material.Scaffold(
      backgroundColor: SurfaceLevel.page.colorOf(context.colorScheme),
      appBar: material.AppBar(
        foregroundColor: context.colorScheme.onSurface,
        leading: material.IconButton(
          tooltip: material.MaterialLocalizations.of(context).backButtonTooltip,
          icon: const GlyphIcon(AppGlyphs.arrowBack),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        backgroundColor: SurfaceLevel.page.colorOf(context.colorScheme),
        title: Text(strings.inviteRewards),
      ),
      body:
          !ref.watch(xboardUserProvider.select((user) => user.isAuthenticated))
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (invite.hasInviteData) ...[
                  DecoratedBox(
                    decoration: ShapeDecoration(
                      gradient: IosMemberColors.gradient,
                      shape: AppShape.xl,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 13, 15, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              DecoratedBox(
                                decoration: ShapeDecoration(
                                  color: const Color(0x33c5dcff),
                                  shape: AppShape.md,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: const GlyphIcon(
                                    XBoardGlyphs.coin,
                                    color: IosMemberColors.secondary,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () => dialogs.showAlert(
                                  title: strings.commissionRules,
                                  message: TextSpan(
                                    text: strings.commissionRuleDetails(rate),
                                  ),
                                ),
                                child: Text(
                                  strings.commissionRules,
                                  style: AppTextStyle.footnote
                                      .of(context)
                                      .copyWith(
                                        color: IosMemberColors.secondary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            xboardL10n.availableCommission,
                            style: AppTextStyle.body
                                .of(context)
                                .copyWith(color: IosMemberColors.secondary),
                          ),
                          Text(
                            invite.formattedAvailableCommission,
                            style: AppTextStyle.title1
                                .of(context, emphasized: true)
                                .copyWith(color: IosMemberColors.foreground),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 1),
                          Row(
                            children: [
                              for (final (label, value) in [
                                (
                                  strings.pendingSettlement,
                                  invite.formattedPendingCommission,
                                ),
                                (
                                  strings.cumulativeCommission,
                                  invite.formattedCommission,
                                ),
                                (
                                  strings.invited,
                                  strings.invitedCount(invite.totalInvites),
                                ),
                              ])
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        label,
                                        style: AppTextStyle.footnote
                                            .of(context)
                                            .copyWith(
                                              color: IosMemberColors.secondary,
                                            ),
                                      ),
                                      Text(
                                        value,
                                        style: AppTextStyle.subheadline
                                            .of(context, emphasized: true)
                                            .copyWith(
                                              color: IosMemberColors.foreground,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(xboardL10n.inviteCode),
                                  Text(
                                    activeCode?.code ?? '—',
                                    style: AppTextStyle.headline.of(context),
                                  ),
                                ],
                              ),
                            ),
                            DecoratedBox(
                              decoration: ShapeDecoration(
                                color: IosMemberColors.badge,
                                shape: AppShape.full,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  strings.commissionRate(rate),
                                  style: AppTextStyle.footnote
                                      .of(context)
                                      .copyWith(
                                        color: IosMemberColors.foreground,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (link != null)
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () => _share(link),
                                  icon: const GlyphIcon(
                                    AppGlyphs.qrCode,
                                    fill: 1,
                                  ),
                                  label: Text(strings.shareInvite),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextButton(
                                  onPressed: () => _copy(link),
                                  child: Text(
                                    context.iosMemberStrings.copyLink,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (activeCode == null)
                          TextButton(
                            onPressed: loading
                                ? null
                                : () => ref
                                      .read(inviteProvider.notifier)
                                      .generateInviteCode(),
                            child: Text(strings.generateInviteCode),
                          )
                        else
                          Text(strings.inviteLinkUnavailable),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (loading)
                  const Center(child: ActivityIndicator())
                else if (invite.errorMessage != null || !invite.hasInviteData)
                  TextButton(
                    onPressed: () =>
                        ref.read(inviteProvider.notifier).loadInviteData(),
                    child: Text(context.appLocalizations.retry),
                  ),
                Card(
                  onPressed: () => Navigator.of(context).push<void>(
                    PageRouteBuilder<void>(
                      pageBuilder: (_, _, _) => const _IosCommissionPage(),
                    ),
                  ),
                  child: ListRow(
                    leading: const GlyphIcon(XBoardGlyphs.history),
                    title: Text(context.iosMemberStrings.commissionDetails),
                    trailing: const GlyphIcon(AppGlyphs.chevronForward),
                  ),
                ),
              ],
            ),
    );
  }
}

class _IosCommissionPage extends ConsumerStatefulWidget {
  const _IosCommissionPage();

  @override
  ConsumerState<_IosCommissionPage> createState() => _IosCommissionPageState();
}

class _IosCommissionPageState extends ConsumerState<_IosCommissionPage> {
  @override
  void initState() {
    super.initState();
    unawaited(
      Future<void>.microtask(() {
        if (mounted) {
          return ref.read(inviteProvider.notifier).refreshCommissionHistory();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final invite = ref.watch(inviteProvider);
    final history = invite.commissionHistory;
    final actions = ref.read(inviteProvider.notifier);
    final date = DateFormat.yMMMd(Localizations.localeOf(context).languageCode);
    return material.Scaffold(
      backgroundColor: SurfaceLevel.page.colorOf(context.colorScheme),
      appBar: material.AppBar(
        backgroundColor: SurfaceLevel.page.colorOf(context.colorScheme),
        title: Text(context.iosMemberStrings.commissionDetails),
        foregroundColor: context.colorScheme.onSurface,
        leading: material.IconButton(
          tooltip: material.MaterialLocalizations.of(context).backButtonTooltip,
          icon: const GlyphIcon(AppGlyphs.arrowBack),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body:
          !ref.watch(xboardUserProvider.select((user) => user.isAuthenticated))
          ? const SizedBox.shrink()
          : PrismListView(
              padding: const EdgeInsets.all(16),
              itemCount: history.length + 1,
              itemBuilder: (context, index) {
                if (index == history.length) {
                  if (invite.isLoadingHistory) {
                    return const Center(child: ActivityIndicator());
                  }
                  if (invite.historyLoadFailed) {
                    return TextButton(
                      onPressed: actions.retryCommissionHistory,
                      child: Text(context.appLocalizations.retry),
                    );
                  }
                  if (history.isEmpty) {
                    return Text(xboardL10n.noCommissionRecord);
                  }
                  return invite.hasMoreHistory
                      ? TextButton(
                          onPressed: actions.loadNextHistoryPage,
                          child: Text(xboardL10n.loadMore),
                        )
                      : const SizedBox.shrink();
                }
                final record = history[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    child: ListRow(
                      title: Text(
                        context.iosMemberStrings.invitationCommission,
                      ),
                      subtitle: Text(
                        '${xboardL10n.orderNumber(record.tradeNo)} · ${date.format(record.createdAt.toLocal())}',
                      ),
                      trailing: Text(
                        '${record.amount > 0 ? '+' : ''}¥${record.amount.toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
