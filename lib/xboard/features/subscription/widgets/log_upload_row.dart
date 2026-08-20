import 'dart:convert';
import 'dart:io';

import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/xboard/features/remote_task/services/device_info_service.dart';
import 'package:flutter/material.dart';

/// 日志上报行（内嵌在滚动内容中）
///
/// 自行持有上传状态，不依赖 Riverpod。
class LogUploadRow extends StatefulWidget {
  const LogUploadRow({super.key});

  @override
  State<LogUploadRow> createState() => _LogUploadRowState();
}

class _LogUploadRowState extends State<LogUploadRow> {
  bool _isUploading = false;
  bool _hasUploaded = false;

  /// 禁用态颜色（上传中或已上报）
  Color get _disabledColor => Theme.of(
    context,
  ).colorScheme.onSurfaceVariant.withValues(alpha: _hasUploaded ? 0.4 : 0.5);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '遇到问题？',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          GestureDetector(
            onTap: (_isUploading || _hasUploaded) ? null : _uploadLogs,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_hasUploaded)
                  Icon(Icons.bug_report, size: 14, color: _disabledColor),
                if (!_hasUploaded) const SizedBox(width: 4),
                Text(
                  _isUploading ? '上传中...' : (_hasUploaded ? '已上报' : '日志上报'),
                  style: TextStyle(
                    color: _disabledColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: (_isUploading || _hasUploaded)
                        ? null
                        : TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 上传日志到服务端
  Future<void> _uploadLogs() async {
    final fileOutput = XBoardLogger.fileOutput;
    if (fileOutput == null) {
      _showSnackBar('日志未启用');
      return;
    }

    setState(() => _isUploading = true);

    try {
      // 单文件模式，直接获取当前日志文件
      final logPath = fileOutput.currentLogFilePath;
      if (logPath == null) {
        _showSnackBar('日志文件未初始化');
        return;
      }
      final logFile = File(logPath);
      if (!await logFile.exists()) {
        _showSnackBar('日志文件不存在');
        return;
      }
      final fileBytes = await logFile.readAsBytes();
      final filename = logFile.path.split(Platform.pathSeparator).last;

      // 设备信息
      final deviceInfoResult = await DeviceInfoService.collectBasicDeviceInfo();
      final deviceInfoJson = deviceInfoResult['status'] == 'success'
          ? jsonEncode(deviceInfoResult['device_info'])
          : '{}';

      final reportUrl = XBoardConfig.reportLogUrl;
      if (reportUrl == null || reportUrl.isEmpty) {
        _showSnackBar('未配置日志上报服务器地址');
        return;
      }

      final success = await XBoardSDK.instance.reportLog(
        fileBytes,
        filename,
        deviceInfoJson: deviceInfoJson,
        customUrl: reportUrl,
      );

      if (!mounted) return;

      if (success) {
        _hasUploaded = true;
        _showSnackBar('日志上报成功 ✓');
      } else {
        _showSnackBar('日志上报失败');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('上报异常: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  /// 显示 SnackBar 提示
  void _showSnackBar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
