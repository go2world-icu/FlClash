import 'package:fl_clash/xboard/features/auth/pages/login_page.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/initialization/initialization.dart';
import 'package:fl_clash/xboard/features/invite/widgets/user_menu_widget.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_core_status.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_home_tab.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_invite_tab.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_splash_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:fl_clash/icons/icons.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';
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
    final userState = ref.watch(xboardUserProvider);
    final initState = ref.watch(initializationProvider);

    // 本地登录态还在恢复中（quickAuth 未返回）且初始化仍在进行，
    // 先显示启动屏，避免已登录用户先看到登录页闪现、过一会才被切回首页。
    // 初始化失败时不能卡在启动屏 —— 交回 LoginPage，它有失败提示和退避重试。
    final initPending = !initState.isReady && !initState.isFailed;
    if (!userState.isInitialized && initPending) {
      return const IosSplashScreen();
    }

    if (!userState.isAuthenticated) {
      return const LoginPage();
    }

    final titles = [xboardL10n.xboardHome, xboardL10n.invite];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        automaticallyImplyLeading: false,
        actions: const [
          IosCoreStatus(),
          SizedBox(width: 4),
          UserMenuWidget(),
          SizedBox(width: 4),
        ],
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
            icon: const GlyphIcon(XBoardGlyphs.home, size: 22),
            selectedIcon: const GlyphIcon(XBoardGlyphs.home, size: 22),
            label: xboardL10n.xboardHome,
          ),
          NavigationDestination(
            icon: const GlyphIcon(XBoardGlyphs.people, size: 22),
            selectedIcon: const GlyphIcon(XBoardGlyphs.people, size: 22),
            label: xboardL10n.invite,
          ),
        ],
      ),
    );
  }
}
