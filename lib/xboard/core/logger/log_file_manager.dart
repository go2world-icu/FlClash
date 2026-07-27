/// Encrypted single-file log output with 1-day retention
///
/// 基于 `logger` 包的加密文件日志输出，使用 AppPath 统一管理路径。
/// 单文件按天命名（xboard_yyyy-MM-dd.log.enc），保留 1 天。
library;

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:logger/logger.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';

import 'package:fl_clash/common/path.dart' show appPath;

/// AES-256-CBC 加密单文件日志输出
///
/// 功能：
/// - 单文件按天命名：xboard_yyyy-MM-dd.log.enc
/// - 保留 1 天，旧文件自动删除
/// - AES-256-CBC 加密存储
/// - 支持解密导出
class EncryptedFileLogOutput extends LogOutput {
  static const String _fileNamePrefix = 'xboard_';
  static const String _fileExtension = '.log.enc';

  final String appKey;
  File? _currentFile;
  late encrypt.Key _key;
  late encrypt.IV _iv;
  bool _initialized = false;

  /// [appKey] 用于派生加密密钥的应用密钥
  EncryptedFileLogOutput({this.appKey = 'xboard_default_key'});

  @override
  Future<void> init({String? baseDir}) async {
    if (_initialized) return;
    super.init();

    // 路径统一由 AppPath 管理，存放到临时目录
    final dirPath = await appPath.tempPath;

    // 派生 AES-256 密钥（SHA-256 哈希）
    final keyBytes = sha256.convert(utf8.encode(appKey)).bytes;
    _key = encrypt.Key(Uint8List.fromList(keyBytes));
    // IV = SHA-256(appKey + "_iv") 的前 16 字节，同一密钥永远得到同一 IV
    final ivHash = sha256.convert(utf8.encode('${appKey}_iv')).bytes;
    _iv = encrypt.IV(Uint8List.fromList(ivHash.sublist(0, 16)));

    // 按天命名，保留当天文件，删除旧文件
    final today = _dateString(DateTime.now());
    _currentFile = File('$dirPath/$_fileNamePrefix$today$_fileExtension');

    // 清理非今天的日志文件（保留 1 天）
    final dir = Directory(dirPath);
    if (await dir.exists()) {
      await for (final entity in dir.list()) {
        if (entity is File &&
            entity.path.startsWith('$dirPath/$_fileNamePrefix') &&
            entity.path.endsWith(_fileExtension) &&
            entity.path != _currentFile!.path) {
          try {
            await entity.delete();
          } catch (_) {
            // 忽略删除失败
          }
        }
      }
    }

    if (!await _currentFile!.exists()) {
      await _currentFile!.create();
    }

    _initialized = true;
  }

  @override
  void output(OutputEvent event) {
    if (!_initialized || _currentFile == null) return;

    final now = DateTime.now();
    final timestamp = _formatTimestamp(now);
    final level = event.level.name.toUpperCase();

    for (final line in event.lines) {
      final logLine = '[$timestamp] [$level] $line\n';
      _writeEncrypted(logLine);
    }
  }

  /// 写入加密日志行
  void _writeEncrypted(String line) {
    if (_currentFile == null) return;

    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
      final encrypted = encrypter.encrypt(line, iv: _iv);
      final base64Line = '${encrypted.base64}\n';

      _currentFile!.writeAsStringSync(
        base64Line,
        mode: FileMode.append,
        flush: true,
      );
    } catch (e) {
      // 加密失败时回退到明文写入（带错误标记）
      _currentFile!.writeAsStringSync(
        '[ENCRYPT_FAILED] $line',
        mode: FileMode.append,
        flush: true,
      );
    }
  }

  /// 解密日志文件内容
  static Future<String> decryptFile(File file, {String appKey = 'xboard_default_key'}) async {
    final keyHash = sha256.convert(utf8.encode(appKey)).bytes;
    final key = encrypt.Key(Uint8List.fromList(keyHash));
    // IV = SHA-256(appKey + "_iv") 前 16 字节，与加密端一致的确定性派生
    final ivHash = sha256.convert(utf8.encode('${appKey}_iv')).bytes;
    final iv = encrypt.IV(Uint8List.fromList(ivHash.sublist(0, 16)));
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final lines = await file.readAsLines();
    final buffer = StringBuffer();

    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      if (line.startsWith('[ENCRYPT_FAILED]')) {
        buffer.writeln(line.substring('[ENCRYPT_FAILED] '.length));
        continue;
      }

      try {
        final encrypted = encrypt.Encrypted.fromBase64(line);
        final decrypted = encrypter.decrypt(encrypted, iv: iv);
        buffer.write(decrypted);
      } catch (e) {
        buffer.writeln('[DECRYPT_FAILED] $line');
      }
    }

    return buffer.toString();
  }

  /// 获取日志文件路径
  String? get currentLogFilePath => _currentFile?.path;

  String _dateString(DateTime dt) {
    return '${dt.year}-${_p(dt.month)}-${_p(dt.day)}';
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.year}-${_p(dt.month)}-${_p(dt.day)} '
        '${_p(dt.hour)}:${_p(dt.minute)}:${_p(dt.second)}';
  }

  String _p(int n) => n.toString().padLeft(2, '0');
}
