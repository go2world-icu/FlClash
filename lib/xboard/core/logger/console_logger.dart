/// 控制台日志实现
library;

import 'logger_interface.dart';

/// 控制台日志实现
class ConsoleLogger implements LoggerInterface {
  static const String _prefix = '[XBoard]';

  @override
  LogLevel minLevel;

  ConsoleLogger({
    this.minLevel = LogLevel.info,
  });

  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (minLevel.index <= LogLevel.debug.index) {
      _log('DEBUG', message, error, stackTrace);
    }
  }

  @override
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    if (minLevel.index <= LogLevel.info.index) {
      _log('INFO', message, error, stackTrace);
    }
  }

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (minLevel.index <= LogLevel.warning.index) {
      _log('WARN', message, error, stackTrace);
    }
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (minLevel.index <= LogLevel.error.index) {
      _log('ERROR', message, error, stackTrace);
    }
  }

  void _log(
    String level,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    print('$_prefix [$level] $message');
    if (error != null) print('$_prefix [$level] Error: $error');
    if (stackTrace != null) print('$_prefix [$level] $stackTrace');
  }
}

