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
  /// [fileOutput] 加密文件输出实例（包含文件和密钥信息）
  /// [authToken] Bearer Token 用于接口鉴权
  /// [extraData] 可选的额外数据
  Future<LogUploadResult> uploadLogs(
    EncryptedFileLogOutput fileOutput, {
    String? authToken,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      // 获取所有日志文件列表
      final logFiles = await fileOutput.getLogFiles();
      if (logFiles.isEmpty) {
        return const LogUploadFailure('暂无日志文件');
      }

      // 读取最新的日志文件（当天的）
      final latestFile = _getLatestFile(logFiles);
      if (latestFile == null) {
        return const LogUploadFailure('无可用日志文件');
      }

      // 读取文件内容
      final fileBytes = await latestFile.readAsBytes();

      // 构建上传表单
      final formData = FormData.fromMap({
        'log_file': MultipartFile.fromBytes(
          fileBytes,
          filename: latestFile.path.split(Platform.pathSeparator).last,
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

  /// 获取最新的日志文件
  File? _getLatestFile(List<File> files) {
    if (files.isEmpty) return null;

    files.sort((a, b) {
      final aStat = a.statSync();
      final bStat = b.statSync();
      return bStat.modified.compareTo(aStat.modified);
    });

    return files.first;
  }
}
