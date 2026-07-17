/// XBoard 鏁版嵁瀛樺偍鏈嶅姟
///
/// 鎻愪緵XBoard鐩稿叧鏁版嵁鐨勫瓨鍌ㄥ拰璇诲彇
library;

import 'dart:convert';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/xboard/infrastructure/infrastructure.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart' as sdk;
import 'package:fl_clash/xboard/domain/domain.dart';

/// XBoard 瀛樺偍鏈嶅姟
///
/// 璐熻矗瀛樺偍鍜岃鍙朮Board鐩稿叧鏁版嵁锛屽鐢ㄦ埛淇℃伅銆佽闃呬俊鎭瓑
class XBoardStorageService {
  final StorageInterface _storage;
  
  XBoardStorageService(this._storage);

  // 瀛樺偍閿畾涔?
  static const String _userEmailKey = 'xboard_user_email';
  static const String _userInfoKey = 'xboard_user_info';  // 淇濈暀鍏煎
  static const String _subscriptionInfoKey = 'xboard_subscription_info';  // 淇濈暀鍏煎
  static const String _domainUserKey = 'xboard_domain_user';  // 鏂帮細棰嗗煙妯″瀷
  static const String _domainSubscriptionKey = 'xboard_domain_subscription';  // 鏂帮細棰嗗煙妯″瀷
  static const String _tunFirstUseKey = 'xboard_tun_first_use_shown';
  static const String _savedEmailKey = 'xboard_saved_email';
  static const String _savedPasswordKey = 'xboard_saved_password';
  static const String _rememberPasswordKey = 'xboard_remember_password';


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
      return Result.failure(XBoardStorageException(
        message: '淇濆瓨棰嗗煙鐢ㄦ埛淇℃伅澶辫触',
        operation: 'write',
        key: _domainUserKey,
        originalError: e,
        stackTrace: stackTrace,
      ));
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
          return Result.failure(XBoardParseException(
            message: '瑙ｆ瀽棰嗗煙鐢ㄦ埛淇℃伅澶辫触',
            dataType: 'DomainUser',
            originalError: e,
            stackTrace: stackTrace,
          ));
        }
      },
      failure: (error) => Result.failure(error),
    );
  }

  // ===== 棰嗗煙妯″瀷锛氳闃呬俊鎭?=====

  Future<Result<bool>> saveDomainSubscription(DomainSubscription subscription) async {
    try {
      final subscriptionJson = jsonEncode(subscription.toJson());
      return await _storage.setString(_domainSubscriptionKey, subscriptionJson);
    } catch (e, stackTrace) {
      return Result.failure(XBoardStorageException(
        message: '淇濆瓨棰嗗煙璁㈤槄淇℃伅澶辫触',
        operation: 'write',
        key: _domainSubscriptionKey,
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<DomainSubscription?>> getDomainSubscription() async {
    final result = await _storage.getString(_domainSubscriptionKey);
    return result.when(
      success: (subscriptionJson) {
        if (subscriptionJson == null) return Result.success(null);
        try {
          final Map<String, dynamic> subscriptionMap = jsonDecode(subscriptionJson);
          return Result.success(DomainSubscription.fromJson(subscriptionMap));
        } catch (e, stackTrace) {
          return Result.failure(XBoardParseException(
            message: '瑙ｆ瀽棰嗗煙璁㈤槄淇℃伅澶辫触',
            dataType: 'DomainSubscription',
            originalError: e,
            stackTrace: stackTrace,
          ));
        }
      },
      failure: (error) => Result.failure(error),
    );
  }

  // ===== 璁㈤槄淇℃伅锛堝凡绉婚櫎锛屼娇鐢―omainSubscription浠ｆ浛锛?=====

  // ===== 璁よ瘉鏁版嵁娓呯悊 =====

  Future<Result<bool>> clearAuthData() async {
    final results = await Future.wait([
      _storage.remove(_userEmailKey),
      _storage.remove(_userInfoKey),
      _storage.remove(_subscriptionInfoKey),
      _storage.remove(_domainUserKey),  // 娓呯悊棰嗗煙妯″瀷
      _storage.remove(_domainSubscriptionKey),  // 娓呯悊棰嗗煙妯″瀷
    ]);
    
    final allSuccess = results.every((r) => r.dataOrNull == true);
    return Result.success(allSuccess);
  }

  // ===== TUN 棣栨浣跨敤鏍囪 =====

  Future<Result<bool>> hasTunFirstUseShown() async {
    final result = await _storage.getBool(_tunFirstUseKey);
    return result.map((value) => value ?? false);
  }

  Future<Result<bool>> markTunFirstUseShown() async {
    return await _storage.setBool(_tunFirstUseKey, true);
  }

  // ===== 鐧诲綍鍑嵁 =====

  Future<Result<bool>> saveCredentials(
    String email,
    String password,
    bool rememberPassword,
  ) async {
    final results = await Future.wait([
      _storage.setString(_savedEmailKey, email),
      _storage.setString(_savedPasswordKey, rememberPassword ? password : ''),
      _storage.setBool(_rememberPasswordKey, rememberPassword),
    ]);
    
    final allSuccess = results.every((r) => r.dataOrNull == true);
    return Result.success(allSuccess);
  }

  Future<Result<Map<String, dynamic>>> getSavedCredentials() async {
    final emailResult = await _storage.getString(_savedEmailKey);
    final passwordResult = await _storage.getString(_savedPasswordKey);
    final rememberResult = await _storage.getBool(_rememberPasswordKey);
    
    return Result.success({
      'email': emailResult.dataOrNull,
      'password': passwordResult.dataOrNull,
      'rememberPassword': rememberResult.dataOrNull ?? false,
    });
  }

  // 渚挎嵎鏂规硶锛氳幏鍙栧崟涓繚瀛樼殑鍑嵁瀛楁
  Future<String?> getSavedEmail() async {
    final result = await _storage.getString(_savedEmailKey);
    return result.dataOrNull;
  }

  Future<String?> getSavedPassword() async {
    final result = await _storage.getString(_savedPasswordKey);
    return result.dataOrNull;
  }

  Future<bool> getRememberPassword() async {
    final result = await _storage.getBool(_rememberPasswordKey);
    return result.dataOrNull ?? false;
  }

  Future<Result<bool>> clearSavedCredentials() async {
    final results = await Future.wait([
      _storage.remove(_savedEmailKey),
      _storage.remove(_savedPasswordKey),
      _storage.remove(_rememberPasswordKey),
    ]);
    
    final allSuccess = results.every((r) => r.dataOrNull == true);
    return Result.success(allSuccess);
  }
}

