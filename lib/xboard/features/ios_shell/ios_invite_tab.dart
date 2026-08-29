import 'package:fl_clash/xboard/features/initialization/initialization.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:fl_clash/xboard/features/invite/widgets/commission_history_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/error_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/invite_qr_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/invite_rules_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/invite_stats_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/wallet_details_card.dart';
import 'package:fl_clash/xboard/features/subscription/widgets/log_upload_row.dart';
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

    // 邀请数据依赖 SDK API，而 SDK 只有在统一初始化流程（域名检查 → SDK 初始化）
    // 完成后才就绪。冷启动时外壳会先因本地 token 进入首页，此时初始化仍在后台
    // 进行；这里不直接读 xboardSdkProvider（会绕过 XBoardConfig.initialize 的正常
    // 顺序），而是监听 initializationProvider 就绪后再加载邀请数据。
    if (ref.read(initializationProvider).isReady) {
      _loadInviteData();
      return;
    }

    ref.listenManual(initializationProvider, (previous, next) {
      if (previous?.isReady != true && next.isReady) {
        _loadInviteData();
      }
    });
  }

  Future<void> _loadInviteData() async {
    if (_hasInitialized) return;
    _hasInitialized = true;

    // initState 或初始化监听回调可能在 build 阶段触发，此时同步修改 provider
    // 会抛 "Tried to modify a provider while the widget tree was building"，
    // 推迟到当前帧结束后再执行。
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;

    await ref.read(inviteProvider.notifier).refresh();
    if (!mounted) return;
    final inviteState = ref.read(inviteProvider);
    if (!inviteState.hasInviteData || inviteState.inviteData!.codes.isEmpty) {
      await ref.read(inviteProvider.notifier).generateInviteCode();
    }
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
            SizedBox(height: 16),
            LogUploadRow(),
          ],
        ),
      ),
    );
  }
}
