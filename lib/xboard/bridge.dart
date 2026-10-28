import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/xboard/config_check.dart';
import 'package:fl_clash/xboard/features/initialization/initialization.dart';
import 'package:fl_clash/xboard/xboard.dart';

import 'home_shell.dart';

/// The panel's home, upstream's page with the start button at the dock's end.
export 'home_shell.dart';

// iOS used to open on its own shell — a subscription feed with two tabs and a
// connect button in place of the dashboard. It now opens on the same shell as
// Android, so `XBoardIosShell` (`features/ios_shell/`) is parked rather than
// deleted: un-comment the two lines below and the branch in `buildXBoardHome`
// to bring it back. The startup dots it carried in its bar moved with it, to
// the dashboard's — see `IosCoreStatus`.
// export 'features/ios_shell/ios_shell.dart';

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
      final initialization = ref.watch(initializationProvider);
      if (!initialization.isReady) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (initialization.isFailed) ...[
                      Text(
                        initialization.errorMessage ??
                            context.appLocalizations.initFailed,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () async {
                          try {
                            await ref
                                .read(initializationProvider.notifier)
                                .refresh();
                          } catch (_) {}
                        },
                        child: Text(context.appLocalizations.retry),
                      ),
                    ] else ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(context.appLocalizations.loading),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      }
      return const XBoardHomePage();
    }
    return const LoginPage();
  }
}

/// The shell's home: the panel's copy of upstream's page, which seats the
/// start button at the end of the floating dock.
///
/// `lib/application.dart` only names this, so what the panel adds to the shell
/// can change without adding fork diff to an upstream file.
Widget buildXBoardHome() {
  // iOS used to take its own shell here (`XBoardIosShell`); it now opens on
  // this one too, so the panel's screen is the same on every platform.
  //
  //   if (system.isIOS) {
  //     return const XBoardIosShell(
  //       connectionControl: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Card(margin: EdgeInsets.zero, child: NodeSelectorBar()),
  //           SizedBox(height: 12),
  //           XBoardConnectButton(),
  //         ],
  //       ),
  //     );
  //   }
  return const XBoardShellHome();
}

/// Warms the panel's storage and runs its initialization — the panel's screens
/// assume both have happened, and neither is part of the core's own startup.
void preloadXBoard(WidgetRef ref) {
  if (!hasXboardConfig) return;
  warmUpXBoardStorage().then((_) {
    ref.read(initializationProvider.notifier).initialize().catchError((_) {});
  });
}
