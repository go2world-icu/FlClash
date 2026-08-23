import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:flutter/material.dart';

/// iOS 外壳启动屏 —— 在本地登录态恢复（`quickAuth`）完成前显示。
///
/// 冷启动时 `isAuthenticated` 初始为 false，直接进 `LoginPage` 会导致
/// 已登录用户先看到登录页、再被切回首页（闪现）。这里用启动屏占住
/// 这段「认证恢复中」的窗口，等 `isInitialized` 后再决定进首页还是登录页。
class IosSplashScreen extends StatelessWidget {
  const IosSplashScreen({super.key});

  /// 启动屏会在 XBoardConfig 初始化完成前就挂载；现在 `appTitle`/`appWebsite`
  /// 未初始化时返回空串（不再抛 StateError），这里在标题为空时兜底到全局
  /// `appName`，等初始化完成后外壳会切走，不影响正式标题。
  static String _configTitle() {
    final title = XBoardConfig.appTitle;
    return title.isEmpty ? appName : title;
  }

  static String _configWebsite() {
    return XBoardConfig.appWebsite;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.vpn_key_outlined,
                  size: 48,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _configTitle(),
                style: textTheme.displaySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _configWebsite(),
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
