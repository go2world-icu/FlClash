import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:path/path.dart';
import 'storage_interface.dart';

/// 文件存储实现
///
/// 以 JSON 文件形式存储数据到主应用的 `appPath.homeDirPath/xboard/` 目录下。
/// 与 SharedPreferences 不同，此实现将数据和主应用的配置放在同一位置，
/// 便于统一备份和恢复。
///
class FileStorage implements StorageInterface {
  late final Directory _baseDir;
  final Map<String, String> _cache = {};

  FileStorage._();

  static Future<FileStorage> create() async {
    final storage = FileStorage._();
    await storage._init();
    return storage;
  }

  Future<void> _init() async {
    try {
      final basePath = join(await appPath.homeDirPath, 'xboard');
      _baseDir = Directory(basePath);
      if (!await _baseDir.exists()) {
        await _baseDir.create(recursive: true);
      }
      await _loadCache();
    } catch (_) {}
  }

  Future<void> _loadCache() async {
    try {
      final file = File(join(_baseDir.path, 'data.json'));
      if (await file.exists()) {
        final content = await file.readAsString();
        final json = jsonDecode(content) as Map<String, dynamic>;
        json.forEach((key, value) {
          _cache[key] = value as String;
        });
      }
    } catch (_) {}
  }

  void _persist() {
    try {
      final file = File(join(_baseDir.path, 'data.json'));
      file.writeAsStringSync(jsonEncode(_cache));
    } catch (_) {}
  }

  @override
  Future<Result<String?>> getString(String key) async {
    return Result.success(_cache[key]);
  }

  @override
  Future<Result<bool>> setString(String key, String value) async {
    _cache[key] = value;
    _persist();
    return Result.success(true);
  }

  @override
  Future<Result<int?>> getInt(String key) async {
    final value = _cache[key];
    if (value == null) return Result.success(null);
    return Result.success(int.tryParse(value));
  }

  @override
  Future<Result<bool>> setInt(String key, int value) async {
    _cache[key] = value.toString();
    _persist();
    return Result.success(true);
  }

  @override
  Future<Result<bool?>> getBool(String key) async {
    final value = _cache[key];
    if (value == null) return Result.success(null);
    return Result.success(value == 'true');
  }

  @override
  Future<Result<bool>> setBool(String key, bool value) async {
    _cache[key] = value.toString();
    _persist();
    return Result.success(true);
  }

  @override
  Future<Result<double?>> getDouble(String key) async {
    final value = _cache[key];
    if (value == null) return Result.success(null);
    return Result.success(double.tryParse(value));
  }

  @override
  Future<Result<bool>> setDouble(String key, double value) async {
    _cache[key] = value.toString();
    _persist();
    return Result.success(true);
  }

  @override
  Future<Result<List<String>?>> getStringList(String key) async {
    final value = _cache[key];
    if (value == null) return Result.success(null);
    return Result.success((jsonDecode(value) as List<dynamic>).cast<String>());
  }

  @override
  Future<Result<bool>> setStringList(String key, List<String> value) async {
    _cache[key] = jsonEncode(value);
    _persist();
    return Result.success(true);
  }

  @override
  Future<Result<bool>> remove(String key) async {
    _cache.remove(key);
    _persist();
    return Result.success(true);
  }

  @override
  Future<Result<bool>> clear() async {
    _cache.clear();
    _persist();
    return Result.success(true);
  }

  @override
  Future<Result<bool>> containsKey(String key) async {
    return Result.success(_cache.containsKey(key));
  }

  @override
  Future<Result<Set<String>>> getKeys() async {
    return Result.success(_cache.keys.toSet());
  }
}
