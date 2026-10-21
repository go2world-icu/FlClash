import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/xboard/config_check.dart';
import 'package:fl_clash/xboard/features/initialization/initialization.dart';
import 'package:fl_clash/xboard/xboard.dart';

import 'features/ios_shell/ios_shell.dart';
import 'home_shell.dart';

/// The panel's home, upstream's page with the start button at the dock's end.
export 'home_shell.dart';

/// iOS 专用外壳（仅 iOS 使用，接管整个 App 界面）
export 'features/ios_shell/ios_shell.dart';

/// 面板自有字符串表（原本放在上游 arb 里，是每次合并最大的冲突源）
export 'l10n/xboard_strings.dart';

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

/// The shell's home: the panel's iOS form, or the panel's copy of upstream's
/// page (which seats the start button at the end of the floating dock).
///
/// `lib/application.dart` only names this, so what the panel adds to the shell
/// can change without adding fork diff to an upstream file.
Widget buildXBoardHome() {
  if (!system.isIOS || !hasXboardConfig) {
    return const XBoardShellHome();
  }
  return const XBoardIosShell(
    connectionControl: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(margin: EdgeInsets.zero, child: NodeSelectorBar()),
        SizedBox(height: 12),
        XBoardConnectButton(),
      ],
    ),
  );
}

/// Warms the panel's storage and runs its initialization — the panel's screens
/// assume both have happened, and neither is part of the core's own startup.
void preloadXBoard(WidgetRef ref) {
  if (!hasXboardConfig) return;
  warmUpXBoardStorage().then((_) {
    ref.read(initializationProvider.notifier).initialize().catchError((_) {});
  });
}
