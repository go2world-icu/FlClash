import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/xboard/xboard.dart';

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
