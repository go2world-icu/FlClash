import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/xboard/xboard.dart';

/// iOS 专用外壳（仅 iOS 使用，接管整个 App 界面）
export 'features/ios_shell/ios_shell.dart';

/// xboard 导航入口 — "我的"页面
///
/// 已登录 → xboard 首页（套餐/订阅信息）
/// 未登录 → 登录页
class XBoardPage extends ConsumerWidget {
  const XBoardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(xboardUserProvider);
    if (userState.isAuthenticated) {
      return const XBoardHomePage();
    }
    return const LoginPage();
  }
}
