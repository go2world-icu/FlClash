import 'dart:collection';

import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/common/print.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/state.dart';

import 'log_redaction.dart';

export 'package:fl_clash/enum/enum.dart' show LogLevel;
export 'file_logger.dart';

class XBoardLogger {
  static final _pending = Queue<Log>();
  static bool _enabled = true;
  static LogLevel _minLevel = LogLevel.info;

  static void configure({required bool enabled, required LogLevel minLevel}) {
    _enabled = enabled;
    _minLevel = minLevel;
  }

  static void flushPending() {
    if (!globalState.isAttach || _pending.isEmpty) return;
    // Early records already reached the console; replay only to the log list.
    final logs = globalState.container.read(logsProvider.notifier);
    while (_pending.isNotEmpty) {
      logs.add(_pending.removeFirst());
    }
  }

  static void debug(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.debug, message, error, stackTrace);

  static void info(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.info, message, error, stackTrace);

  static void warning(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) => _log(LogLevel.warning, message, error, stackTrace);

  static void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.error, message, error, stackTrace);

  static void _log(
    LogLevel level,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    if (!_enabled || level.index < _minLevel.index) return;
    final text = redactLogMessage(
      [
        '[XBoard] $message',
        if (error != null) compactError(error),
        if (stackTrace != null) stackTrace.toString(),
      ].join('\n'),
    );
    if (globalState.isAttach) {
      flushPending();
    } else {
      if (_pending.length == maxLogsLength) _pending.removeFirst();
      _pending.add(Log.app('[APP] $text').copyWith(logLevel: level));
    }
    commonPrint.log(text, logLevel: level);
  }
}
