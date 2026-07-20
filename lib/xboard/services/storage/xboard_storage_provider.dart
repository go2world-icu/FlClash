/// XBoard Storage Service Provider
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/xboard/infrastructure/infrastructure.dart';
import 'package:fl_clash/xboard/infrastructure/storage/file_storage.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'xboard_storage_service.dart';

/// Storage 实例（由 _preloadXBoard 在启动时初始化）
StorageInterface? _storageInstance;

/// 预热 xboard 存储（启动时调用）
Future<void> warmUpXBoardStorage() async {
  _storageInstance = await FileStorage.create();
}

/// XBoard Storage Service Provider
///
/// 启动时由 _preloadXBoard 预热，之后立即可用。
final storageServiceProvider = Provider<XBoardStorageService>((ref) {
  final storage = _storageInstance ?? _PlaceholderStorage();
  return XBoardStorageService(storage);
});

/// 占位符存储实现，用于存储未初始化时的临时使用
class _PlaceholderStorage implements StorageInterface {
  @override
  Future<Result<String?>> getString(String key) async => Result.success(null);
  
  @override
  Future<Result<bool>> setString(String key, String value) async => Result.success(false);
  
  @override
  Future<Result<int?>> getInt(String key) async => Result.success(null);
  
  @override
  Future<Result<bool>> setInt(String key, int value) async => Result.success(false);
  
  @override
  Future<Result<bool?>> getBool(String key) async => Result.success(null);
  
  @override
  Future<Result<bool>> setBool(String key, bool value) async => Result.success(false);
  
  @override
  Future<Result<double?>> getDouble(String key) async => Result.success(null);
  
  @override
  Future<Result<bool>> setDouble(String key, double value) async => Result.success(false);
  
  @override
  Future<Result<List<String>?>> getStringList(String key) async => Result.success(null);
  
  @override
  Future<Result<bool>> setStringList(String key, List<String> value) async => Result.success(false);
  
  @override
  Future<Result<bool>> remove(String key) async => Result.success(false);
  
  @override
  Future<Result<bool>> clear() async => Result.success(false);
  
  @override
  Future<Result<bool>> containsKey(String key) async => Result.success(false);
  
  @override
  Future<Result<Set<String>>> getKeys() async => Result.success({});
}

