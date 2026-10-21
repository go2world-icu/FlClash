import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:fl_clash/xboard/features/invite/widgets/stat_item_widget.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';

class InviteStatsCard extends ConsumerWidget {
  const InviteStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inviteState = ref.watch(inviteProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              xboardL10n.inviteStats,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (inviteState.isLoading && !inviteState.hasInviteData)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                children: [
                  Expanded(
                    child: StatItemWidget(
                      title: xboardL10n.totalInvites,
                      value: '${inviteState.totalInvites}',
                      icon: XBoardGlyphs.people,
                    ),
                  ),
                  Expanded(
                    child: StatItemWidget(
                      title: xboardL10n.commissionRate,
                      value: '${inviteState.commissionRate}%',
                      icon: XBoardGlyphs.percent,
                    ),
                  ),
                  Expanded(
                    child: StatItemWidget(
                      title: xboardL10n.totalCommission,
                      value: inviteState.formattedCommission,
                      icon: XBoardGlyphs.coin,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
