import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/core/logger/logger.dart';

void forwardSdkLog(
  SdkLogLevel level,
  String message,
  Object? error,
  StackTrace? stackTrace,
) {
  switch (level) {
    case SdkLogLevel.debug:
      XBoardLogger.debug(message, error, stackTrace);
    case SdkLogLevel.info:
      XBoardLogger.info(message, error, stackTrace);
    case SdkLogLevel.warning:
      XBoardLogger.warning(message, error, stackTrace);
    case SdkLogLevel.error:
      XBoardLogger.error(message, error, stackTrace);
  }
}
