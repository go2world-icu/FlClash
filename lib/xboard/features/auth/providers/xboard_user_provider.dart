import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/xboard/features/auth/auth.dart';
import 'package:fl_clash/xboard/services/services.dart';
import 'package:fl_clash/xboard/features/profile/providers/profile_import_provider.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart' hide XBoardException;
import 'package:fl_clash/xboard/adapter/state/user_state.dart';
import 'package:fl_clash/xboard/adapter/state/subscription_state.dart';
import 'package:fl_clash/providers/providers.dart';

// 鍒濆鍖栨枃浠剁骇鏃ュ織鍣?
final _logger = FileLogger('xboard_user_provider.dart');

// 浣跨敤棰嗗煙妯″瀷 - Riverpod 3.x NotifierProvider 妯″紡
final userInfoProvider = NotifierProvider<_DomainUserHolder, DomainUser?>(_DomainUserHolder.new);
final subscriptionInfoProvider = NotifierProvider<_DomainSubscriptionHolder, DomainSubscription?>(_DomainSubscriptionHolder.new);
final userUIStateProvider = NotifierProvider<_UIStateHolder, UIState>(_UIStateHolder.new);

class _DomainUserHolder extends Notifier<DomainUser?> {
  @override
  DomainUser? build() => null;
  void set(DomainUser? value) => state = value;
}

class _DomainSubscriptionHolder extends Notifier<DomainSubscription?> {
  @override
  DomainSubscription? build() => null;
  void set(DomainSubscription? value) => state = value;
}

class _UIStateHolder extends Notifier<UIState> {
  @override
  UIState build() => const UIState();
  void set(UIState value) => state = value;
}
class XBoardUserAuthNotifier extends Notifier<UserAuthState> {
  late final XBoardStorageService _storageService;
  
  @override
  UserAuthState build() {
    _storageService = ref.read(storageServiceProvider);
    return const UserAuthState();
  }
  Future<bool> quickAuth() async {
    try {
      _logger.info('蹇€熻璇佹鏌ワ細妫€鏌ョ櫥褰曠姸鎬?..');
      final hasToken = await XBoardSDK.instance.hasToken()
          .timeout(const Duration(seconds: 5), onTimeout: () {
        _logger.info('蹇€熻璇佽秴鏃讹紝鍋囪鏃爐oken');
        return false;
      });
      
      if (hasToken) {
        String? email;
        DomainUser? userInfo;
        DomainSubscription? subscriptionInfo;
        try {
          final emailResult = await _storageService.getUserEmail()
              .timeout(const Duration(seconds: 2));
          email = emailResult.dataOrNull;
          
          final userInfoResult = await _storageService.getDomainUser()
              .timeout(const Duration(seconds: 2));
          userInfo = userInfoResult.dataOrNull;
          
          final subscriptionInfoResult = await _storageService.getDomainSubscription()
              .timeout(const Duration(seconds: 2));
          subscriptionInfo = subscriptionInfoResult.dataOrNull;
        } catch (e) {
          _logger.info('鑾峰彇缂撳瓨鏁版嵁澶辫触锛屼絾缁х画杩涜璁よ瘉: $e');
        }
        
        state = state.copyWith(
          isAuthenticated: true,
          isInitialized: true,
          email: email,
        );
        
        if (userInfo != null) {
          ref.read(userInfoProvider.notifier).state = userInfo;
        }
        if (subscriptionInfo != null) {
          ref.read(subscriptionInfoProvider.notifier).state = subscriptionInfo;
        }
        
        _logger.info('蹇€熻璇佹垚鍔燂細宸叉湁token锛岀洿鎺ヨ繘鍏ヤ富鐣岄潰. isInitialized: ${state.isInitialized}');
        _backgroundTokenValidation();
        
        // 鍚姩鏃惰嚜鍔ㄥ鍏ヨ闃?
        if (subscriptionInfo?.subscribeUrl?.isNotEmpty == true) {
          _logger.info('鍚姩鏃惰嚜鍔ㄥ鍏ヨ闃? ${subscriptionInfo!.subscribeUrl}');
          ref.read(profileImportProvider.notifier).importSubscription(subscriptionInfo.subscribeUrl);
        }
        
        return true;
      } else {
        _logger.info('蹇€熻璇侊細鏃犳湰鍦皌oken锛屾樉绀虹櫥褰曢〉闈? isInitialized: ${state.isInitialized}');
        state = state.copyWith(isInitialized: true);
        return false;
      }
    } catch (e) {
      _logger.info('蹇€熻璇佸け璐? $e');
      state = state.copyWith(isInitialized: true);
      _logger.info('蹇€熻璇佸け璐? $e. isInitialized: ${state.isInitialized}');
      return false;
    } finally {
      if (!state.isInitialized) {
        _logger.info('寮哄埗璁剧疆鍒濆鍖栫姸鎬佷负true. isInitialized: ${state.isInitialized}');
        state = state.copyWith(isInitialized: true);
      }
    }
  }
  void _backgroundTokenValidation() {
    Future.delayed(const Duration(milliseconds: 1000), () async {
      try {
        _logger.info('鍚庡彴楠岃瘉token鏈夋晥鎬?..');
        // 浣跨敤 getUserInfo 楠岃瘉 token
        try {
          await ref.read(getUserInfoProvider.future);
          _logger.info('Token楠岃瘉鎴愬姛锛岄潤榛樻洿鏂扮敤鎴锋暟鎹?);
          _silentUpdateUserData();
        } catch (e) {
          _logger.info('Token楠岃瘉澶辫触锛屾樉绀虹櫥褰曡繃鏈熸彁绀? $e');
          _showTokenExpiredDialog();
        }
      } catch (e) {
        _logger.info('鍚庡彴token楠岃瘉寮傚父: $e');
      }
    });
  }
  Future<void> _silentUpdateUserData() async {
    try {
      // 鑾峰彇璁㈤槄淇℃伅
      final subscriptionModel = await ref.read(getSubscriptionProvider.future) as SubscriptionModel;
      final subscriptionData = _mapSubscription(subscriptionModel);

      // 鑾峰彇鐢ㄦ埛淇℃伅
      try {
        final userModel = await ref.read(getUserInfoProvider.future) as UserModel;
        final userInfoData = _mapUser(userModel);

        await _storageService.saveDomainUser(userInfoData);
        ref.read(userInfoProvider.notifier).state = userInfoData;
      } catch (e) {
        _logger.info('闈欓粯鏇存柊鐢ㄦ埛淇℃伅澶辫触: $e');
      }

      await _storageService.saveDomainSubscription(subscriptionData);
      ref.read(subscriptionInfoProvider.notifier).state = subscriptionData;

      if (subscriptionData.subscribeUrl.isNotEmpty) {
        _logger.info('[鍚庡彴楠岃瘉] 寮€濮嬭嚜鍔ㄥ鍏ヨ闃呴厤缃? ${subscriptionData.subscribeUrl}');
        ref.read(profileImportProvider.notifier).importSubscription(subscriptionData.subscribeUrl);
      } else {
        _logger.info('[鍚庡彴楠岃瘉] 璁㈤槄URL涓虹┖锛岃烦杩囬厤缃鍏?);
      }

      _logger.info('闈欓粯鏇存柊鐢ㄦ埛鏁版嵁瀹屾垚');
    } catch (e) {
      _logger.info('闈欓粯鏇存柊鐢ㄦ埛鏁版嵁澶辫触: $e');
    }
  }
  void _showTokenExpiredDialog() {
    state = state.copyWith(
      errorMessage: 'TOKEN_EXPIRED', // 鐗规畩鏍囪锛孶I灞傛娴嬪埌鍚庢樉绀哄璇濇
    );
  }
  void clearTokenExpiredError() {
    if (state.errorMessage == 'TOKEN_EXPIRED') {
      state = state.copyWith(errorMessage: null);
    }
  }
  Future<void> handleTokenExpired() async {
    _logger.info('澶勭悊token杩囨湡锛屾竻闄よ璇佺姸鎬?);
    await XBoardSDK.instance.logout();
    state = const UserAuthState(isInitialized: true);
  }
  Future<bool> autoAuth() async {
    return await quickAuth();
  }
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      _logger.info('寮€濮嬬櫥褰? $email');
      
      final success = await XBoardSDK.instance.loginWithCredentials(email, password);
      
      if (!success) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '鐧诲綍澶辫触',
        );
        return false;
      }
      
      _logger.info('鐧诲綍鎴愬姛锛岀珛鍗宠幏鍙栫敤鎴蜂俊鎭?);
      await _storageService.saveUserEmail(email);
      
      // 鑾峰彇鐢ㄦ埛淇℃伅鍜岃闃呬俊鎭?
      try {
        _logger.info('寮€濮嬭幏鍙栫敤鎴蜂俊鎭?..');
        final userModel = await ref.read(getUserInfoProvider.future) as UserModel;
        final userInfo = _mapUser(userModel);
        
        _logger.info('鐢ㄦ埛淇℃伅API璋冪敤瀹屾垚');
        ref.read(userInfoProvider.notifier).state = userInfo;
        await _storageService.saveDomainUser(userInfo);
        _logger.info('鐢ㄦ埛淇℃伅宸蹭繚瀛? ${userInfo.email}');
        
        _logger.info('寮€濮嬭幏鍙栬闃呬俊鎭?..');
        final subscriptionModel = await ref.read(getSubscriptionProvider.future) as SubscriptionModel;
        final subscriptionInfo = _mapSubscription(subscriptionModel);
        
        _logger.info('璁㈤槄淇℃伅API璋冪敤瀹屾垚');
        ref.read(subscriptionInfoProvider.notifier).state = subscriptionInfo;
        await _storageService.saveDomainSubscription(subscriptionInfo);
        _logger.info('璁㈤槄淇℃伅宸蹭繚瀛橈紝subscribeUrl: ${subscriptionInfo.subscribeUrl}');
        
        // 鐧诲綍鎴愬姛鍚庤嚜鍔ㄥ鍏ヨ闃呴厤缃?
        if (subscriptionInfo.subscribeUrl.isNotEmpty) {
          _logger.info('[鐧诲綍鎴愬姛] 寮€濮嬭嚜鍔ㄥ鍏ヨ闃呴厤缃? ${subscriptionInfo.subscribeUrl}');
          ref.read(profileImportProvider.notifier).importSubscription(subscriptionInfo.subscribeUrl);
        } else {
          _logger.info('[鐧诲綍鎴愬姛] 璁㈤槄URL涓虹┖锛岃烦杩囬厤缃鍏?);
        }
      } catch (e, stackTrace) {
        _logger.info('鑾峰彇鐢ㄦ埛/璁㈤槄淇℃伅澶辫触锛屼絾缁х画鐧诲綍: $e');
        _logger.info('閿欒鍫嗘爤: $stackTrace');
      }
        
        _logger.info('鍑嗗鏇存柊鐘舵€?..');
        final newState = state.copyWith(
          isAuthenticated: true,
          isInitialized: true,
          email: email,
          isLoading: false,
        );
        state = newState;
        _logger.info('===== 璁よ瘉鐘舵€佸凡鏇存柊! =====');
        _logger.info('isAuthenticated: ${state.isAuthenticated}');
        _logger.info('isInitialized: ${state.isInitialized}');
        _logger.info('email: ${state.email}');
        _logger.info('===========================');
        
        return true;
    } catch (e) {
      _logger.info('鐧诲綍鍑洪敊: $e');
      String errorMessage = '鐧诲綍澶辫触';
      if (e is XBoardException) {
        errorMessage = e.message;
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );
      return false;
    }
  }
  Future<bool> register(String email, String password, String? inviteCode, String emailCode) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      _logger.info('寮€濮嬫敞鍐? $email');
      
      final success = await XBoardSDK.instance.auth.register(
        email,
        password,
        inviteCode: inviteCode,
        emailCode: emailCode,
      );
      
      if (success) {
        _logger.info('娉ㄥ唽鎴愬姛');
        await _storageService.saveUserEmail(email);
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '娉ㄥ唽澶辫触',
        );
        return false;
      }
    } catch (e) {
      _logger.info('娉ㄥ唽鍑洪敊: $e');
      String errorMessage = '娉ㄥ唽澶辫触';
      if (e is XBoardException) {
        errorMessage = e.message;
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );
      return false;
    }
  }
  Future<bool> sendVerificationCode(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      _logger.info('鍙戦€侀獙璇佺爜鍒? $email');
      // 鍩熷悕鏈嶅姟鏆傛椂涓嶆敮鎸佸彂閫侀獙璇佺爜鍔熻兘
      throw UnimplementedError('鍙戦€侀獙璇佺爜鍔熻兘鏆傛椂涓嶅彲鐢?);
    } catch (e) {
      _logger.info('鍙戦€侀獙璇佺爜鍑洪敊: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
  Future<bool> resetPassword(String email, String password, String emailCode) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      _logger.info('閲嶇疆瀵嗙爜: $email');
      
      final success = await XBoardSDK.instance.auth.forgotPassword(
        email,
        emailCode,
        password,
      );
      
      if (success) {
        _logger.info('瀵嗙爜閲嶇疆鎴愬姛');
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '瀵嗙爜閲嶇疆澶辫触',
        );
        return false;
      }
    } catch (e) {
      _logger.info('閲嶇疆瀵嗙爜鍑洪敊: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
  Future<void> refreshSubscriptionInfoAfterPayment() async {
    if (!state.isAuthenticated) {
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      _logger.info('鍒锋柊璁㈤槄淇℃伅...');
      
      DomainUser? userInfo;
      DomainSubscription? subscriptionData;
      
      try {
        final userModel = await ref.read(getUserInfoProvider.future) as UserModel;
        userInfo = _mapUser(userModel);
        await _storageService.saveDomainUser(userInfo);
        ref.read(userInfoProvider.notifier).state = userInfo;
      } catch (e) {
        _logger.info('鑾峰彇鐢ㄦ埛璇︾粏淇℃伅澶辫触: $e');
      }

      try {
        final subscriptionModel = await ref.read(getSubscriptionProvider.future) as SubscriptionModel;
        subscriptionData = _mapSubscription(subscriptionModel);
        await _storageService.saveDomainSubscription(subscriptionData);
        ref.read(subscriptionInfoProvider.notifier).state = subscriptionData;
      } catch (e) {
        _logger.info('鑾峰彇璁㈤槄淇℃伅澶辫触: $e');
      }

      state = state.copyWith(
        userInfo: userInfo,
        subscriptionInfo: subscriptionData,
        isLoading: false,
      );
      _logger.info('璁㈤槄淇℃伅宸插埛鏂?);

      if (subscriptionData?.subscribeUrl.isNotEmpty == true) {
        _logger.info('[鏀粯鎴愬姛] 寮€濮嬮噸鏂板鍏ヨ闃呴厤缃? ${subscriptionData!.subscribeUrl}');
        _logger.info('[鏀粯鎴愬姛] 浣跨敤寮哄埗鍒锋柊妯″紡锛岃烦杩囬噸澶嶆娴?);
        ref.read(profileImportProvider.notifier).importSubscription(
          subscriptionData.subscribeUrl,
          forceRefresh: true,
        );
      } else {
        _logger.info('[鏀粯鎴愬姛] 璁㈤槄閾炬帴涓虹┖锛岃烦杩囬噸鏂板鍏?);
      }
    } catch (e) {
      _logger.info('鍒锋柊璁㈤槄淇℃伅鍑洪敊: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshSubscriptionInfo() async {
    if (!state.isAuthenticated) {
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      _logger.info('鍒锋柊璁㈤槄淇℃伅...');
      
      DomainUser? userInfo;
      DomainSubscription? subscriptionData;
      
      try {
        final userModel = await ref.read(getUserInfoProvider.future) as UserModel;
        userInfo = _mapUser(userModel);
        await _storageService.saveDomainUser(userInfo);
        ref.read(userInfoProvider.notifier).state = userInfo;
      } catch (e) {
        _logger.info('鑾峰彇鐢ㄦ埛璇︾粏淇℃伅澶辫触: $e');
      }

      try {
        final subscriptionModel = await ref.read(getSubscriptionProvider.future) as SubscriptionModel;
        subscriptionData = _mapSubscription(subscriptionModel);
        await _storageService.saveDomainSubscription(subscriptionData);
        ref.read(subscriptionInfoProvider.notifier).state = subscriptionData;
      } catch (e) {
        _logger.info('鑾峰彇璁㈤槄淇℃伅澶辫触: $e');
      }

      state = state.copyWith(
        userInfo: userInfo,
        subscriptionInfo: subscriptionData,
        isLoading: false,
      );
      _logger.info('璁㈤槄淇℃伅宸插埛鏂?);

      // 瑙﹀彂璁㈤槄瀵煎叆娴佺▼
      if (subscriptionData?.subscribeUrl.isNotEmpty == true) {
        _logger.info('[鎵嬪姩鍒锋柊] 寮€濮嬪鍏ヨ闃呴厤缃? ${subscriptionData!.subscribeUrl}');
        _logger.info('[鎵嬪姩鍒锋柊] 浣跨敤寮哄埗鍒锋柊妯″紡锛岃烦杩囬噸澶嶆娴?);
        ref.read(profileImportProvider.notifier).importSubscription(
          subscriptionData.subscribeUrl,
          forceRefresh: true,
        );
      } else {
        _logger.info('[鎵嬪姩鍒锋柊] 璁㈤槄閾炬帴涓虹┖锛岃烦杩囧鍏?);
      }
    } catch (e) {
      _logger.info('鍒锋柊璁㈤槄淇℃伅鍑洪敊: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
  Future<void> refreshUserInfo() async {
    if (!state.isAuthenticated) {
      return;
    }
    try {
      _logger.info('鍒锋柊鐢ㄦ埛璇︾粏淇℃伅...');
      
      _logger.info('鍒锋柊鐢ㄦ埛璇︾粏淇℃伅...');
      
      final userModel = await ref.read(getUserInfoProvider.future) as UserModel;
      final userInfoData = _mapUser(userModel);
      
      await _storageService.saveDomainUser(userInfoData);
      ref.read(userInfoProvider.notifier).state = userInfoData;
      state = state.copyWith(userInfo: userInfoData);
      _logger.info('鐢ㄦ埛璇︾粏淇℃伅宸插埛鏂?);
    } catch (e) {
      _logger.info('鍒锋柊鐢ㄦ埛璇︾粏淇℃伅鍑洪敊: $e');
    }
  }
  Future<void> logout() async {
    _logger.info('鐢ㄦ埛鐧诲嚭');

    await XBoardSDK.instance.logout();
    await _storageService.clearAuthData();

    // 娓呯悊 xboard 瀵煎叆鐨勮闃呴厤缃?
    try {
      final profiles = ref.read(profilesProvider);
      for (final profile in profiles.toList()) {
        await ref.read(profilesActionProvider.notifier).deleteProfile(profile.id);
      }
    } catch (e) {
      _logger.info('娓呯悊璁㈤槄閰嶇疆澶辫触: $e');
    }

    state = const UserAuthState(
      isInitialized: true,
    );
  }
  String? get currentAuthToken => null; // Token绠＄悊宸插鎵樼粰鍩熷悕鏈嶅姟
  bool get isAuthenticated => state.isAuthenticated;
  String? get currentEmail => state.email;
}
final xboardUserAuthProvider = NotifierProvider<XBoardUserAuthNotifier, UserAuthState>(
  XBoardUserAuthNotifier.new,
);
final xboardUserProvider = xboardUserAuthProvider;
extension UserInfoHelpers on WidgetRef {
  DomainUser? get userInfo => read(userInfoProvider);
  DomainSubscription? get subscriptionInfo => read(subscriptionInfoProvider);
  UserAuthState get userAuthState => read(xboardUserAuthProvider);
  bool get isAuthenticated => read(xboardUserAuthProvider).isAuthenticated;
}

DomainUser _mapUser(UserModel user) {
  return DomainUser(
    email: user.email,
    uuid: user.uuid,
    avatarUrl: user.avatarUrl,
    planId: user.planId,
    transferLimit: user.transferEnable.toInt(),
    uploadedBytes: 0,
    downloadedBytes: 0,
    balanceInCents: (user.balance * 100).toInt(),
    commissionBalanceInCents: (user.commissionBalance * 100).toInt(),
    expiredAt: user.expiredAt,
    lastLoginAt: user.lastLoginAt,
    createdAt: user.createdAt,
    banned: user.banned,
    remindExpire: user.remindExpire,
    remindTraffic: user.remindTraffic,
    discount: user.discount,
    commissionRate: user.commissionRate,
    telegramId: user.telegramId,
  );
}

DomainSubscription _mapSubscription(SubscriptionModel sub) {
  return DomainSubscription(
    subscribeUrl: sub.subscribeUrl ?? '',
    email: sub.email ?? '',
    uuid: sub.uuid ?? '',
    planId: sub.planId ?? 0,
    planName: sub.planName,
    token: sub.token,
    transferLimit: sub.transferEnable ?? 0,
    uploadedBytes: sub.u ?? 0,
    downloadedBytes: sub.d ?? 0,
    speedLimit: sub.speedLimit,
    deviceLimit: sub.deviceLimit,
    expiredAt: sub.expiredAt,
    nextResetAt: sub.nextResetAt,
  );
}