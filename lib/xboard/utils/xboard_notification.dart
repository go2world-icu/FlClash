import 'package:material_ui/material_ui.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';

class XBoardNotification {
  XBoardNotification._();

  static void showError(String message) {
    dialogs.showNotifier(message, level: MessageLevel.error);
  }

  static void showSuccess(String message) {
    dialogs.showNotifier(message, level: MessageLevel.success);
  }

  static void showInfo(String message) {
    dialogs.showNotifier(message);
  }

  static Future<bool> showConfirm(String message, {String? title}) async {
    final result = await dialogs.showMessage(
      message: TextSpan(text: message),
      cancelable: true,
    );
    return result == true;
  }
}
