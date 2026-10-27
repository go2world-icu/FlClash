/// XBoard 数据存储服务
///
/// 提供XBoard相关数据的存储和读取
library;

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/xboard/infrastructure/infrastructure.dart';
import 'package:fl_clash/xboard/domain/domain.dart';

/// XBoard 存储服务
///
/// 负责存储和读取XBoard相关数据，如用户信息、订阅信息等
class XBoardStorageService {
  final StorageInterface _storage;
  final FlutterSecureStorage _secureStorage;

  XBoardStorageService(this._storage, {FlutterSecureStorage? secureStorage})
    : _secureStorage =
          secureStorage ??
          const FlutterSecureStorage(
            mOptions: MacOsOptions(usesDataProtectionKeychain: false),
          );

  // 存储键定义
  static const String _userEmailKey = 'xboard_user_email';
  static const String _userInfoKey = 'xboard_user_info'; // 保留兼容
  static const String _subscriptionInfoKey = 'xboard_subscription_info'; // 保留兼容
  static const String _domainUserKey = 'xboard_domain_user'; // 新：领域模型
  static const String _domainSubscriptionKey =
      'xboard_domain_subscription'; // 新：领域模型
  static const String _tunFirstUseKey = 'xboard_tun_first_use_shown';
  static const String _savedEmailKey = 'xboard_saved_email';
  static const String _savedPasswordKey = 'xboard_saved_password';
  static const String _rememberPasswordKey = 'xboard_remember_password';

  String _ownedProfilesKey(String email) =>
      'xboard_owned_profiles_${sha256.convert(utf8.encode(email.trim().toLowerCase()))}';

  Future<List<int>> getOwnedProfileIds(String email) async {
    final value = (await _storage.getString(
      _ownedProfilesKey(email),
    )).dataOrNull;
    if (value == null) return [];
    try {
      return (jsonDecode(value) as List).whereType<int>().toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> setOwnedProfileIds(String email, List<int> ids) async {
    final result = await _storage.setString(
      _ownedProfilesKey(email),
      jsonEncode(ids),
    );
    if (result.dataOrNull != true) {
      throw StateError('Unable to save XBoard profile ownership');
    }
  }

  Future<Result<bool>> saveUserEmail(String email) async {
    return await _storage.setString(_userEmailKey, email);
  }

  Future<Result<String?>> getUserEmail() async {
    return await _storage.getString(_userEmailKey);
  }

  Future<Result<bool>> saveDomainUser(DomainUser user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      return await _storage.setString(_domainUserKey, userJson);
    } catch (e, stackTrace) {
      return Result.failure(
        XBoardStorageException(
          message: '保存领域用户信息失败',
          operation: 'write',
          key: _domainUserKey,
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<Result<DomainUser?>> getDomainUser() async {
    final result = await _storage.getString(_domainUserKey);
    return result.when(
      success: (userJson) {
        if (userJson == null) return Result.success(null);
        try {
          final Map<String, dynamic> userMap = jsonDecode(userJson);
          return Result.success(DomainUser.fromJson(userMap));
        } catch (e, stackTrace) {
          return Result.failure(
            XBoardParseException(
              message: '解析领域用户信息失败',
              dataType: 'DomainUser',
              originalError: e,
              stackTrace: stackTrace,
            ),
          );
        }
      },
      failure: (error) => Result.failure(error),
    );
  }

  // ===== 领域模型：订阅信息 =====

  Future<Result<bool>> saveDomainSubscription(
    DomainSubscription subscription,
  ) async {
    try {
      final subscriptionJson = jsonEncode(subscription.toJson());
      return await _storage.setString(_domainSubscriptionKey, subscriptionJson);
    } catch (e, stackTrace) {
      return Result.failure(
        XBoardStorageException(
          message: '保存领域订阅信息失败',
          operation: 'write',
          key: _domainSubscriptionKey,
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<Result<DomainSubscription?>> getDomainSubscription() async {
    final result = await _storage.getString(_domainSubscriptionKey);
    return result.when(
      success: (subscriptionJson) {
        if (subscriptionJson == null) return Result.success(null);
        try {
          final Map<String, dynamic> subscriptionMap = jsonDecode(
            subscriptionJson,
          );
          return Result.success(DomainSubscription.fromJson(subscriptionMap));
        } catch (e, stackTrace) {
          return Result.failure(
            XBoardParseException(
              message: '解析领域订阅信息失败',
              dataType: 'DomainSubscription',
              originalError: e,
              stackTrace: stackTrace,
            ),
          );
        }
      },
      failure: (error) => Result.failure(error),
    );
  }

  // ===== 订阅信息（已移除，使用DomainSubscription代替） =====

  // ===== 认证数据清理 =====

  Future<Result<bool>> clearAuthData() async {
    final results = await Future.wait([
      _storage.remove(_userEmailKey),
      _storage.remove(_userInfoKey),
      _storage.remove(_subscriptionInfoKey),
      _storage.remove(_domainUserKey), // 清理领域模型
      _storage.remove(_domainSubscriptionKey), // 清理领域模型
    ]);

    final allSuccess = results.every((r) => r.dataOrNull == true);
    return Result.success(allSuccess);
  }

  // ===== TUN 首次使用标记 =====

  Future<Result<bool>> hasTunFirstUseShown() async {
    final result = await _storage.getBool(_tunFirstUseKey);
    return result.map((value) => value ?? false);
  }

  Future<Result<bool>> markTunFirstUseShown() async {
    return await _storage.setBool(_tunFirstUseKey, true);
  }

  // ===== 登录凭据 =====

  Future<Result<bool>> saveCredentials(
    String email,
    String password,
    bool rememberPassword,
  ) async {
    try {
      if (rememberPassword) {
        await _secureStorage.write(key: _savedPasswordKey, value: password);
      } else {
        await _secureStorage.delete(key: _savedPasswordKey);
      }
      await _storage.remove(_savedPasswordKey);
      final emailResult = await _storage.setString(_savedEmailKey, email);
      final rememberResult = await _storage.setBool(
        _rememberPasswordKey,
        rememberPassword,
      );
      return Result.success(
        emailResult.dataOrNull == true && rememberResult.dataOrNull == true,
      );
    } catch (error, stackTrace) {
      return Result.failure(
        XBoardStorageException(
          message: '安全保存登录凭据失败',
          operation: 'write',
          key: _savedPasswordKey,
          originalError: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<Result<Map<String, dynamic>>> getSavedCredentials() async {
    final emailResult = await _storage.getString(_savedEmailKey);
    final password = await getSavedPassword();
    final rememberResult = await _storage.getBool(_rememberPasswordKey);

    return Result.success({
      'email': emailResult.dataOrNull,
      'password': password,
      'rememberPassword': rememberResult.dataOrNull ?? false,
    });
  }

  // 便捷方法：获取单个保存的凭据字段
  Future<String?> getSavedEmail() async {
    final result = await _storage.getString(_savedEmailKey);
    return result.dataOrNull;
  }

  Future<String?> getSavedPassword() async {
    final saved = await _secureStorage.read(key: _savedPasswordKey);
    final legacy = (await _storage.getString(_savedPasswordKey)).dataOrNull;
    if (legacy != null && legacy.isNotEmpty) {
      if (saved == null || saved.isEmpty) {
        await _secureStorage.write(key: _savedPasswordKey, value: legacy);
      }
      await _storage.remove(_savedPasswordKey);
    }
    return saved?.isNotEmpty == true ? saved : legacy;
  }

  Future<bool> getRememberPassword() async {
    final result = await _storage.getBool(_rememberPasswordKey);
    return result.dataOrNull ?? false;
  }

  Future<Result<bool>> clearSavedCredentials() async {
    await _secureStorage.delete(key: _savedPasswordKey);
    final results = await Future.wait([
      _storage.remove(_savedEmailKey),
      _storage.remove(_savedPasswordKey),
      _storage.remove(_rememberPasswordKey),
    ]);

    final allSuccess = results.every((r) => r.dataOrNull == true);
    return Result.success(allSuccess);
  }
}
