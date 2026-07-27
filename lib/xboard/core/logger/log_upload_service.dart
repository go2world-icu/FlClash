/// 日志上报服务
///
/// 读取加密日志文件，通过 API 上报到服务端
library;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_clash/xboard/core/logger/log_file_manager.dart';

/// 日志上报结果
sealed class LogUploadResult {
  const LogUploadResult();
  bool get isSuccess => this is LogUploadSuccess;
  bool get isFailure => this is LogUploadFailure;
}

class LogUploadSuccess extends LogUploadResult {
  final String message;
  const LogUploadSuccess([this.message = '']);
}

class LogUploadFailure extends LogUploadResult {
  final String message;
  final int? statusCode;
  const LogUploadFailure(this.message, {this.statusCode});
}

/// 日志上报服务
class LogUploadService {
  final String uploadUrl;
  final Dio _dio;

  LogUploadService({
    required this.uploadUrl,
    Dio? dio,
  }) : _dio = dio ?? Dio();

  /// 上报日志文件到服务端
  ///
  /// [fileOutput] 加密文件输出实例（包含文件路径和密钥信息）
  /// [authToken] Bearer Token 用于接口鉴权
  /// [extraData] 可选的额外数据
  Future<LogUploadResult> uploadLogs(
    EncryptedFileLogOutput fileOutput, {
    String? authToken,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      // 单文件模式，直接获取当前日志文件
      final logPath = fileOutput.currentLogFilePath;
      if (logPath == null) {
        return const LogUploadFailure('日志文件未初始化');
      }
      final logFile = File(logPath);
      if (!await logFile.exists()) {
        return const LogUploadFailure('日志文件不存在');
      }

      // 读取文件内容
      final fileBytes = await logFile.readAsBytes();

      // 构建上传表单
      final formData = FormData.fromMap({
        'log_file': MultipartFile.fromBytes(
          fileBytes,
          filename: logFile.path.split(Platform.pathSeparator).last,
        ),
        if (extraData != null) ...extraData,
      });

      // 上传
      final response = await _dio.post(
        uploadUrl,
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Accept': '*/*',
            if (authToken != null) 'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return LogUploadSuccess(
          '上报成功 (${response.statusCode})',
        );
      } else {
        return LogUploadFailure(
          '服务器返回 ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is DioException) {
        return LogUploadFailure(
          '网络错误: ${e.message}',
          statusCode: e.response?.statusCode,
        );
      }
      return LogUploadFailure('上报失败: $e');
    }
  }
}
