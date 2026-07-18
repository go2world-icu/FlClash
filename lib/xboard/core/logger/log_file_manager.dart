/// Encrypted file log output with 1-day retention
///
/// 基于 `logger` 包的加密文件日志输出，自动按天轮转并清理超期日志
library;

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';

/// 加密文件日志输出
///
/// 功能：
/// - 按天轮转日志文件（app_yyyy-MM-dd.log.enc）
/// - AES-256-CBC 加密存储
/// - 自动清理超过 1 天的旧日志
/// - 支持导出日志文件
class EncryptedFileLogOutput extends LogOutput {
  static const Duration _maxAge = Duration(days: 1);
  static const String _logDirName = 'xboard_logs';
  static const String _filePrefix = 'app_';
  static const String _fileExtension = '.log.enc';

  final String appKey;
  late Directory _logDir;
  File? _currentFile;
  String? _currentDateStr;
  late encrypt.Key _key;
  late encrypt.IV _iv;
  bool _initialized = false;

  /// [appKey] 用于派生加密密钥的应用密钥
  EncryptedFileLogOutput({this.appKey = 'xboard_default_key'});

  /// [baseDir] — custom log directory (e.g. App Group on iOS).  Falls back
  /// to `getApplicationDocumentsDirectory()` when omitted.
  @override
  Future<void> init({String? baseDir}) async {
    if (_initialized) return;
    super.init();

    final dirPath = baseDir ?? (await getApplicationDocumentsDirectory()).path;
    _logDir = Directory('$dirPath/$_logDirName');

    if (!await _logDir.exists()) {
      await _logDir.create(recursive: true);
    }

    // 派生 AES-256 密钥（SHA-256 哈希）
    final keyBytes = sha256.convert(utf8.encode(appKey)).bytes;
    _key = encrypt.Key(Uint8List.fromList(keyBytes));
    // IV = SHA-256(appKey + "_iv") 的前 16 字节，同一密钥永远得到同一 IV
    final ivHash = sha256.convert(utf8.encode('${appKey}_iv')).bytes;
    _iv = encrypt.IV(Uint8List.fromList(ivHash.sublist(0, 16)));

    // 清理过期日志
    await _cleanOldLogs();

    // 初始化当日日志文件
    await _rotateFile();

    _initialized = true;
  }

  @override
  void output(OutputEvent event) {
    if (!_initialized || _currentFile == null) return;
    final now = DateTime.now();
    final dateStr = _dateString(now);

    // 如果日期变更，轮转文件
    if (dateStr != _currentDateStr) {
      _rotateFile();
    }

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

  /// 获取日志目录路径
  String get logDirectoryPath => _logDir.path;

  /// 获取所有日志文件列表
  Future<List<File>> getLogFiles() async {
    if (!await _logDir.exists()) return [];

    return _logDir.list().where((entity) =>
      entity is File &&
      entity.path.endsWith(_fileExtension)
    ).cast<File>().toList();
  }

  /// 获取当日日志文件路径
  String? get currentLogFilePath => _currentFile?.path;

  /// 轮转日志文件（按天）
  Future<void> _rotateFile() async {
    final now = DateTime.now();
    _currentDateStr = _dateString(now);
    final fileName = '$_filePrefix$_currentDateStr$_fileExtension';
    final file = File('${_logDir.path}/$fileName');

    if (!await file.exists()) {
      await file.create();
    }

    _currentFile = file;

    // 每次轮转时顺便清理
    await _cleanOldLogs();
  }

  /// 清理超过 1 天的旧日志
  Future<void> _cleanOldLogs() async {
    if (!await _logDir.exists()) return;

    final cutoff = DateTime.now().subtract(_maxAge);

    await for (final entity in _logDir.list()) {
      if (entity is File && entity.path.endsWith(_fileExtension)) {
        try {
          final stat = await entity.stat();
          if (stat.modified.isBefore(cutoff)) {
            await entity.delete();
          }
        } catch (_) {
          // 跳过无法读取的文件
        }
      }
    }
  }

  String _dateString(DateTime dt) {
    return '${dt.year}-${_pad(dt.month)}-${_pad(dt.day)}';
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.year}-${_pad(dt.month)}-${_pad(dt.day)} '
        '${_pad(dt.hour)}:${_pad(dt.minute)}:${_pad(dt.second)}';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}
