import 'dart:convert';

import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/common/exception.dart';
import 'package:fl_clash/common/path.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/core/logger/log_report.dart';
import 'package:fl_clash/xboard/features/remote_task/services/device_info_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logReportUploaderProvider = Provider<Future<bool> Function(List<Log>)>(
  (ref) => _uploadLogReport,
);

Future<bool> _uploadLogReport(List<Log> logs) async {
  final reportUrl = XBoardConfig.reportLogUrl;
  if (reportUrl == null || reportUrl.isEmpty) {
    throw const MessageException('未配置日志上报服务器地址');
  }
  final filename = logFileName;
  final bytes = await encodeLogReport(logs);
  final deviceInfo = await DeviceInfoService.collectBasicDeviceInfo();
  return XBoardSDK.instance.reportLog(
    bytes,
    filename,
    deviceInfoJson: deviceInfo['status'] == 'success'
        ? jsonEncode(deviceInfo['device_info'])
        : '{}',
    customUrl: reportUrl,
  );
}
