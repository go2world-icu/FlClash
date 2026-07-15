import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 判断 xboard 配置文件是否存在
bool get hasXboardConfig {
  try {
    return File('assets/config/xboard.config.yaml').existsSync();
  } catch (_) {
    return false;
  }
}

/// xboard 是否启用
final xboardEnabledProvider = Provider<bool>((ref) {
  return hasXboardConfig;
});
