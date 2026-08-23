/// XBoard Storage Service Provider
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/xboard/infrastructure/infrastructure.dart';
import 'package:fl_clash/xboard/infrastructure/storage/file_storage.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'xboard_storage_service.dart';

/// Storage 实例（惰性创建，由 [warmUpXBoardStorage] 或首次读写触发）。
///
/// 用 Future 而非裸实例：iOS 外壳把 LoginPage 挂成根页面，t=0 就会读到
/// storageServiceProvider，此时 _preloadXBoard 的磁盘预热还没跑完。
/// 若这里直接返回一个「永远 null」的占位符，provider 会被缓存成假存储，
/// 之后「记住密码」再也读不到持久化数据。改用惰性 Future 后，
/// 任何时刻读取都会最终落到真实的 FileStorage。
Future<StorageInterface>? _storageFuture;

Future<StorageInterface> _getStorage() {
  return _storageFuture ??= FileStorage.create();
}

/// 预热 xboard 存储（启动时调用）。幂等。
Future<void> warmUpXBoardStorage() async {
  await _getStorage();
}

/// XBoard Storage Service Provider
final storageServiceProvider = Provider<XBoardStorageService>((ref) {
  return XBoardStorageService(_LazyStorage(_getStorage()));
});

/// 惰性存储：把真实 FileStorage 的解析推迟到首次读写。
///
/// 与占位符不同，它最终会把调用转发给真实实现，而非永远返回 null。
/// 多个 provider 实例各自持有自己的 [_LazyStorage]，但都共享同一个
/// [_getStorage] future，因此底层仍是同一个 FileStorage 实例，
/// 内存缓存与磁盘数据保持一致。
class _LazyStorage implements StorageInterface {
  final Future<StorageInterface> _delegate;
  StorageInterface? _resolved;

  _LazyStorage(this._delegate);

  Future<StorageInterface> get _storage async {
    return _resolved ??= await _delegate;
  }

  @override
  Future<Result<String?>> getString(String key) async =>
      (await _storage).getString(key);

  @override
  Future<Result<bool>> setString(String key, String value) async =>
      (await _storage).setString(key, value);

  @override
  Future<Result<int?>> getInt(String key) async =>
      (await _storage).getInt(key);

  @override
  Future<Result<bool>> setInt(String key, int value) async =>
      (await _storage).setInt(key, value);

  @override
  Future<Result<bool?>> getBool(String key) async =>
      (await _storage).getBool(key);

  @override
  Future<Result<bool>> setBool(String key, bool value) async =>
      (await _storage).setBool(key, value);

  @override
  Future<Result<double?>> getDouble(String key) async =>
      (await _storage).getDouble(key);

  @override
  Future<Result<bool>> setDouble(String key, double value) async =>
      (await _storage).setDouble(key, value);

  @override
  Future<Result<List<String>?>> getStringList(String key) async =>
      (await _storage).getStringList(key);

  @override
  Future<Result<bool>> setStringList(String key, List<String> value) async =>
      (await _storage).setStringList(key, value);

  @override
  Future<Result<bool>> remove(String key) async =>
      (await _storage).remove(key);

  @override
  Future<Result<bool>> clear() async => (await _storage).clear();

  @override
  Future<Result<bool>> containsKey(String key) async =>
      (await _storage).containsKey(key);

  @override
  Future<Result<Set<String>>> getKeys() async =>
      (await _storage).getKeys();
}
