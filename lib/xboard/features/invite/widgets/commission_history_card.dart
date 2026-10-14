import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/icons/icons.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:fl_clash/xboard/features/invite/dialogs/withdraw_dialog.dart';
import 'package:fl_clash/xboard/features/invite/dialogs/commission_history_dialog.dart';

class CommissionHistoryCard extends ConsumerWidget {
  const CommissionHistoryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inviteState = ref.watch(inviteProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalizations.commissionHistory,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (inviteState.totalCommission > 0)
                  TextButton.icon(
                    onPressed: () => _showWithdrawDialog(context),
                    icon: const GlyphIcon(AppGlyphs.creditCard),
                    label: Text(appLocalizations.withdraw),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (inviteState.commissionHistory.isEmpty)
              Center(
                child: Column(
                  children: [
                    GlyphIcon(
                      AppGlyphs.history,
                      size: 48,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appLocalizations.noCommissionRecord,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...inviteState.commissionHistory
                  .take(5)
                  .map(
                    (commission) => _buildCommissionItem(context, commission),
                  ),
            if (inviteState.commissionHistory.length >= 5)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () => _showCommissionHistoryDialog(context),
                    icon: const GlyphIcon(AppGlyphs.history),
                    label: Text(appLocalizations.viewHistory),
                  ),
                  if (inviteState.commissionHistory.length >= 5)
                    TextButton.icon(
                      onPressed: () => ref
                          .read(inviteProvider.notifier)
                          .loadNextHistoryPage(),
                      icon: inviteState.isLoadingHistory
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const GlyphIcon(AppGlyphs.refresh),
                      label: Text(
                        inviteState.isLoadingHistory
                            ? appLocalizations.loading
                            : appLocalizations.loadMore,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommissionItem(
    BuildContext context,
    DomainCommission commission,
  ) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        shape: AppShape.sm.copyWith(
          side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          GlyphIcon(AppGlyphs.coin, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¥${commission.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  appLocalizations.orderNumber(commission.tradeNo),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${commission.createdAt.year}-${commission.createdAt.month.toString().padLeft(2, '0')}-${commission.createdAt.day.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const WithdrawDialog());
  }

  void _showCommissionHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CommissionHistoryDialog(),
    );
  }
}
