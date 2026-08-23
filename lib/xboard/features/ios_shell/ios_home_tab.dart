import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/profile/providers/profile_import_provider.dart';
import 'package:fl_clash/xboard/features/shared/shared.dart';
import 'package:fl_clash/xboard/features/subscription/services/subscription_status_checker.dart';
import 'package:fl_clash/xboard/features/subscription/widgets/subscription_usage_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// iOS 外壳「首页」标签页内容。
///
/// 不自带 Scaffold / AppBar —— 由 [XBoardIosShell] 统一提供。
class IosHomeTab extends ConsumerStatefulWidget {
  /// 连接控件插槽，由宿主注入（见 `lib/application.dart`）。
  final Widget connectionControl;

  const IosHomeTab({super.key, required this.connectionControl});

  @override
  ConsumerState<IosHomeTab> createState() => _IosHomeTabState();
}

class _IosHomeTabState extends ConsumerState<IosHomeTab>
    with AutomaticKeepAliveClientMixin {
  bool _hasInitialized = false;
  bool _hasCheckedSubscriptionStatus = false;
  bool _hasAutoStarted = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_hasInitialized) return;
      _hasInitialized = true;
      if (ref.read(xboardUserProvider).isAuthenticated) {
        _waitForSubscriptionImportThenCheck();
      }
      // 冷启动兜底：quickAuth 触发的订阅导入可能在本页挂载前就已完成，
      // 此时监听器收不到 isImporting 的翻转，这里补一次自动启动判断。
      _tryAutoStartIfConfigReady();
    });

    // 订阅导入完成后检查订阅状态
    ref.listenManual(profileImportProvider, (previous, next) {
      final importFinished = previous?.isImporting == true && !next.isImporting;
      if (importFinished && !_hasCheckedSubscriptionStatus) {
        _hasCheckedSubscriptionStatus = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && context.mounted) {
            subscriptionStatusChecker.checkSubscriptionStatusOnStartup(
              context,
              ref,
            );
          }
        });
      }
      // iOS 上节点要等隧道起来才会上报，订阅导入成功后自动连接一次 VPN，
      // 把节点加载出来，节点选择器才能展示节点。
      if (importFinished && next.lastResult?.isSuccess == true && !_hasAutoStarted) {
        _hasAutoStarted = true;
        _autoStartProxy();
      }
    });
  }

  /// 兜底：若 3 秒内监听器未触发，主动检查一次订阅状态。
  Future<void> _waitForSubscriptionImportThenCheck() async {
    await Future.delayed(const Duration(seconds: 3));
    if (_hasCheckedSubscriptionStatus || !mounted) return;
    _hasCheckedSubscriptionStatus = true;
    if (!context.mounted) return;
    try {
      subscriptionStatusChecker.checkSubscriptionStatusOnStartup(context, ref);
    } catch (_) {
      // 忽略 dispose 后的 ref 错误
    }
  }

  /// 冷启动兜底：若订阅已导入成功（lastResult 成功）但代理未启动，
  /// 补一次自动连接（与监听器触发互斥，`_hasAutoStarted` 保证只跑一次）。
  void _tryAutoStartIfConfigReady() {
    if (_hasAutoStarted) return;
    final importState = ref.read(profileImportProvider);
    if (importState.lastResult?.isSuccess == true && !ref.read(isStartProvider)) {
      _hasAutoStarted = true;
      _autoStartProxy();
    }
  }

  /// 订阅导入成功后自动连接 VPN，把节点加载出来供节点选择器展示。
  ///
  /// 只触发一次（[importFinished] 处已用 `_hasAutoStarted` 保证），
  /// 且仅在配置就绪（init 完成 + 有 profile）且尚未启动时静默启动，失败不打扰用户。
  void _autoStartProxy() {
    Future.delayed(const Duration(milliseconds: 300), () async {
      if (!mounted) return;
      final isInit = ref.read(initProvider);
      final currentProfile = ref.read(currentProfileProvider);
      final isStart = ref.read(isStartProvider);
      if (!isInit || currentProfile == null || isStart) return;
      try {
        await ref.read(setupActionProvider.notifier).updateStatus(true);
      } catch (_) {
        // 自动启动失败静默处理（如 VPN 配置尚未安装），不打扰用户。
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            colorScheme.surface,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const NoticeBanner(),
            const SizedBox(height: 14),
            _buildUsageCard(),
            const SizedBox(height: 14),
            const XBoardOutboundModeSelector(),
            const SizedBox(height: 14),
            widget.connectionControl,
          ],
        ),
      ),
    );
  }

  Widget _buildUsageCard() {
    return Consumer(
      builder: (_, ref, _) {
        final userInfo = ref.watch(userInfoProvider);
        final subscriptionInfo = ref.watch(subscriptionInfoProvider);
        final currentProfile = ref.watch(currentProfileProvider);
        return Card(
          margin: EdgeInsets.zero,
          child: SubscriptionUsageCard(
            subscriptionInfo: subscriptionInfo,
            userInfo: userInfo,
            profileSubscriptionInfo: currentProfile?.subscriptionInfo,
          ),
        );
      },
    );
  }
}
