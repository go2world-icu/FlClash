/// XBoard 日志模块
///
/// 基于 `logger` 包（v2.x）的统一日志框架，支持：
/// - 控制台彩色输出
/// - AES-256-CBC 加密文件存储
/// - 自动按天轮转，仅保留 1 天
/// - 文件和模块级别标签
library;

export 'logger_interface.dart';
export 'file_logger.dart';
export 'log_file_manager.dart';
export 'log_upload_service.dart';

import 'dart:async';

import 'package:logger/logger.dart' as pkg;

import 'logger_interface.dart';
import 'log_file_manager.dart';

/// 全局唯一 Logger 实例（延迟初始化）
pkg.Logger? _globalLogger;

/// 加密文件输出实例（持有引用防止 GC）
EncryptedFileLogOutput? _fileOutput;

/// 日志配置
class LoggerConfig {
  /// 最低日志级别
  final LogLevel minLevel;

  /// 是否启用控制台输出
  final bool enableConsole;

  /// 是否启用加密文件输出
  final bool enableFile;

  /// 文件日志加密密钥
  final String encryptionKey;

  /// 控制台是否开启颜色
  final bool consoleColors;

  const LoggerConfig({
    this.minLevel = LogLevel.info,
    this.enableConsole = true,
    this.enableFile = true,
    this.encryptionKey = 'xboard_default_key',
    this.consoleColors = true,
  });

  /// 将 LogLevel 转为 logger 包的 Level
  pkg.Level get _packageLevel => switch (minLevel) {
        LogLevel.debug => pkg.Level.debug,
        LogLevel.info => pkg.Level.info,
        LogLevel.warning => pkg.Level.warning,
        LogLevel.error => pkg.Level.error,
      };
}

/// XBoard 日志管理器
///
/// 提供全局日志实例，底层基于 `logger` 包。
/// 兼容旧版 API，以最小化迁移成本。
class XBoardLogger {
  /// 获取当前全局 Logger 实例
  static pkg.Logger get instance {
    if (_globalLogger == null) {
      _initDefault();
    }
    return _globalLogger!;
  }

  /// 获取文件输出管理器（可用于导出/分享日志）
  static EncryptedFileLogOutput? get fileOutput => _fileOutput;

  /// 初始化默认 Logger（仅控制台输出）
  static void _initDefault() {
    _globalLogger = pkg.Logger(
      level: pkg.Level.trace,
      printer: pkg.SimplePrinter(printTime: true)
    );
  }

  /// 配置并初始化 Logger
  ///
  /// 在应用启动时调用，建议传入自定义配置。
  /// 调用后全局实例被替换。
  static Future<void> configure([LoggerConfig config = const LoggerConfig()]) async {
    final outputs = <pkg.LogOutput>[];

    // 控制台输出
    if (config.enableConsole) {
      outputs.add(pkg.ConsoleOutput());
    }

    // 加密文件输出
    if (config.enableFile) {
      _fileOutput = EncryptedFileLogOutput(appKey: config.encryptionKey);
      outputs.add(_fileOutput!);
    }

    if (outputs.isEmpty) {
      // 兜底：至少有一个输出
      outputs.add(pkg.ConsoleOutput());
    }

    final logOutput = outputs.length > 1
        ? pkg.MultiOutput(outputs)
        : outputs.first;

    _globalLogger = pkg.Logger(
      level: config._packageLevel,
      printer: pkg.SimplePrinter(printTime: true),
      output: logOutput,
    );
  }

  /// 重置为默认（控制台）实现
  static void reset() {
    _fileOutput = null;
    _initDefault();
  }

  // ========== 便捷方法（兼容旧版 API） ==========

  /// 记录调试日志
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    instance.d(message, error: error, stackTrace: stackTrace);
  }

  /// 记录信息日志
  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    instance.i(message, error: error, stackTrace: stackTrace);
  }

  /// 记录警告日志
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    instance.w(message, error: error, stackTrace: stackTrace);
  }

  /// 记录错误日志
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    instance.e(message, error: error, stackTrace: stackTrace);
  }
}
