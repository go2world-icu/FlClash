import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/xboard/config_check.dart';
import 'package:fl_clash/xboard/features/initialization/initialization.dart';
import 'package:fl_clash/xboard/xboard.dart';

import 'home_shell.dart';
import 'features/ios_shell/ios_shell.dart';
import 'xboard_material_theme.dart';

/// The panel's home, upstream's page with the start button at the dock's end.
export 'home_shell.dart';

/// 面板自有字符串表（原本放在上游 arb 里，是每次合并最大的冲突源）
export 'l10n/xboard_strings.dart';

/// xboard 导航入口 — "我的"页面
///
/// 已登录 → xboard 首页（套餐/订阅信息）
/// 未登录 → 登录页
class XBoardPage extends ConsumerWidget {
  const XBoardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      XBoardMaterialTheme(child: _buildPage(context, ref));

  Widget _buildPage(BuildContext context, WidgetRef ref) {
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

Widget buildXBoardHome() {
  if (usesIosMemberPanel) {
    return const XBoardMaterialTheme(child: XBoardIosShell());
  }
  return const XBoardShellHome();
}

/// Warms the panel's storage and runs its initialization — the panel's screens
/// assume both have happened, and neither is part of the core's own startup.
void preloadXBoard(WidgetRef ref) {
  XBoardLogger.flushPending();
  if (!hasXboardConfig) return;
  warmUpXBoardStorage().then((_) {
    ref.read(initializationProvider.notifier).initialize().catchError((_) {});
  });
}
