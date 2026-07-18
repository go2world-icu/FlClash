import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool _hasXboardConfig = false;

/// 判断 xboard 配置文件是否存在
bool get hasXboardConfig => _hasXboardConfig;

/// 在 runApp 前调用一次。
///
/// 配置以 asset 形式打进 bundle，移动端沙盒内不存在对应的文件系统路径，
/// 必须通过 rootBundle 探测（桌面/移动行为一致）。
Future<void> resolveXboardConfig() async {
  try {
    await rootBundle.loadString('assets/config/xboard.config.yaml');
    _hasXboardConfig = true;
  } catch (_) {
    _hasXboardConfig = false;
  }
}

/// xboard 是否启用
final xboardEnabledProvider = Provider<bool>((ref) {
  return hasXboardConfig;
});
