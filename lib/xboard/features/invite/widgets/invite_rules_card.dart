import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/icons/icons.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';

class InviteRulesCard extends ConsumerWidget {
  const InviteRulesCard({super.key});

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
              children: [
                GlyphIcon(
                  AppGlyphs.rules,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  xboardL10n.inviteRules,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '• ${xboardL10n.inviteRegisterReward}\n'
              '• ${xboardL10n.friendInviteReward}\n'
              '• ${xboardL10n.currentCommissionRate(inviteState.commissionRate.toString())}\n'
              '• ${xboardL10n.commissionSettled}\n'
              '• ${xboardL10n.withdrawalAvailable}',
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
