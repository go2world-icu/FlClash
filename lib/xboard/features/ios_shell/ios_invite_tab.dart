import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:fl_clash/xboard/features/invite/widgets/commission_history_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/error_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/invite_qr_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/invite_rules_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/invite_stats_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/wallet_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// iOS 外壳「邀请」标签页内容。
///
/// 不自带 Scaffold / AppBar —— 由 [XBoardIosShell] 统一提供。
class IosInviteTab extends ConsumerStatefulWidget {
  const IosInviteTab({super.key});

  @override
  ConsumerState<IosInviteTab> createState() => _IosInviteTabState();
}

class _IosInviteTabState extends ConsumerState<IosInviteTab>
    with AutomaticKeepAliveClientMixin {
  bool _hasInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_hasInitialized) return;
      _hasInitialized = true;

      await ref.read(inviteProvider.notifier).refresh();
      if (!mounted) return;
      final inviteState = ref.read(inviteProvider);
      if (!inviteState.hasInviteData || inviteState.inviteData!.codes.isEmpty) {
        await ref.read(inviteProvider.notifier).generateInviteCode();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () => ref.read(inviteProvider.notifier).refresh(),
      child: const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ErrorCard(),
            InviteRulesCard(),
            SizedBox(height: 16),
            InviteQrCard(),
            SizedBox(height: 16),
            InviteStatsCard(),
            SizedBox(height: 16),
            WalletDetailsCard(),
            SizedBox(height: 16),
            CommissionHistoryCard(),
          ],
        ),
      ),
    );
  }
}
