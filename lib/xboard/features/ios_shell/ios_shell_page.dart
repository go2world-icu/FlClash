import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/xboard/features/auth/pages/login_page.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/invite/widgets/user_menu_widget.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_home_tab.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_invite_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// iOS 专用 XBoard 外壳 —— 接管整个 App 界面。
///
/// 自包含模块，唯一对外入口。宿主只需挂载它并注入连接控件：
///
/// ```dart
/// XBoardIosShell(
///   connectionControl: Column(children: [NodeSelectorBar(), XBoardConnectButton()]),
/// )
/// ```
///
/// 未登录 → 登录页；已登录 → 首页 / 邀请 两个标签页 + 右上角设置菜单。
class XBoardIosShell extends ConsumerStatefulWidget {
  /// 连接控件插槽。外壳本身不关心代理如何启停，由宿主决定注入什么。
  final Widget connectionControl;

  const XBoardIosShell({super.key, required this.connectionControl});

  @override
  ConsumerState<XBoardIosShell> createState() => _XBoardIosShellState();
}

class _XBoardIosShellState extends ConsumerState<XBoardIosShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(
      xboardUserProvider.select((state) => state.isAuthenticated),
    );

    if (!isAuthenticated) {
      return const LoginPage();
    }

    final appLocalizations = AppLocalizations.of(context);
    final titles = [appLocalizations.xboardHome, appLocalizations.invite];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        automaticallyImplyLeading: false,
        actions: const [UserMenuWidget(), SizedBox(width: 4)],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          IosHomeTab(connectionControl: widget.connectionControl),
          const IosInviteTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        height: 60,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined, size: 22),
            selectedIcon: const Icon(Icons.home, size: 22),
            label: appLocalizations.xboardHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline, size: 22),
            selectedIcon: const Icon(Icons.people, size: 22),
            label: appLocalizations.invite,
          ),
        ],
      ),
    );
  }
}
