import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/xboard/config/core/service_locator.dart';
import 'package:fl_clash/xboard/config/services/online_support_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';

// 鍒濆鍖栨枃浠剁骇鏃ュ織鍣?
final _logger = FileLogger('service_config.dart');

/// 瀹㈡湇绯荤粺鏈嶅姟閰嶇疆
class CustomerSupportServiceConfig {
  static OnlineSupportService? _service;

  /// 鍒濆鍖栭厤缃湇鍔?
  static void _initializeService() {
    if (_service == null) {
      try {
        _service = ServiceLocator.get<OnlineSupportService>();
      } catch (e) {
        _logger.error('Failed to get OnlineSupportService', e);
        // 鏈嶅姟涓嶅彲鐢ㄦ椂锛宊service 淇濇寔涓?null锛屽皢浣跨敤榛樿鍊?
      }
    }
  }

  /// HTTP API 鍩虹URL
  static String? get apiBaseUrl {
    _initializeService();
    return _service?.getApiBaseUrl();
  }

  /// WebSocket 鍩虹URL
  static String? get wsBaseUrl {
    _initializeService();
    return _service?.getWebSocketBaseUrl();
  }

  /// 鑾峰彇褰撳墠鐢ㄦ埛鐨勮璇乀oken
  static Future<String?> getUserToken() async {
    try {
      final token = await XBoardSDK.instance.getToken();
      _logger.debug('getUserToken() 鑾峰彇鍒扮殑token: $token');
      return token;
    } catch (e) {
      _logger.error('getUserToken() 鑾峰彇token澶辫触', e);
      // 濡傛灉鑾峰彇澶辫触锛岃繑鍥瀗ull
      return null;
    }
  }

  /// 妫€鏌ラ厤缃湇鍔℃槸鍚﹀彲鐢?
  static bool get isConfigServiceAvailable {
    _initializeService();
    return _service != null && _service!.hasAvailableConfig();
  }

  /// 鑾峰彇閰嶇疆缁熻淇℃伅锛堢敤浜庤皟璇曪級
  static Map<String, dynamic> getConfigStats() {
    _initializeService();
    return _service?.getConfigStats() ?? {
      'totalConfigs': 0,
      'hasApiConfig': false,
      'hasWebSocketConfig': false,
      'usingFallback': true,
    };
  }
}
