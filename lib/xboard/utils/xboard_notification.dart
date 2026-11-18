import 'package:flutter/widgets.dart';
import 'package:prism_ui/prism_ui.dart';
import 'package:fl_clash/common/common.dart';

class XBoardNotification {
  XBoardNotification._();

  static void showError(String message) {
    dialogs.showBanner(message, level: BannerLevel.error);
  }

  static void showSuccess(String message) {
    dialogs.showBanner(message, level: BannerLevel.success);
  }

  static void showInfo(String message) {
    dialogs.showBanner(message);
  }

  static Future<bool> showConfirm(String message, {String? title}) async {
    final result = await dialogs.showMessage(message: TextSpan(text: message));
    return result == true;
  }
}
