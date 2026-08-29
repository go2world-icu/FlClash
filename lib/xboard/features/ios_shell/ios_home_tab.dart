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
            const XBoardNetworkDetection(),
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
