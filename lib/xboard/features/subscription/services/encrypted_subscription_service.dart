import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/config/utils/config_file_loader.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
// 宸蹭粠core/utils瀵煎嚭
import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/xboard/infrastructure/infrastructure.dart';
import 'package:fl_clash/xboard/infrastructure/http/user_agent_config.dart';
import 'concurrent_subscription_service.dart';

// 鍒濆鍖栨枃浠剁骇鏃ュ織鍣?
final _logger = FileLogger('encrypted_subscription_service.dart');

/// 鍔犲瘑璁㈤槄鑾峰彇鏈嶅姟
/// 
/// 璐熻矗浠嶺Board鍔犲瘑绔偣鑾峰彇璁㈤槄鏁版嵁骞惰В瀵?
class EncryptedSubscriptionService {
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  /// 浠庣櫥褰曟暟鎹腑鑾峰彇鍔犲瘑璁㈤槄锛堟帹鑽愭柟娉曪級
  /// 
  /// [preferEncrypt] 鏄惁浼樺厛浣跨敤鍔犲瘑绔偣锛岄粯璁rue
  /// [enableRace] 鏄惁鍚敤璁㈤槄URL绔為€燂紝榛樿true
  /// 
  /// 杩斿洖瑙ｅ瘑鍚庣殑Clash閰嶇疆鍐呭
  static Future<SubscriptionResult> getEncryptedSubscriptionFromLogin({
    bool preferEncrypt = true,
    bool enableRace = true,
  }) async {
    try {
      _logger.info('浠庣櫥褰曟暟鎹幏鍙栧姞瀵嗚闃?);

      // 1. 鑾峰彇璁㈤槄淇℃伅锛堟敞鎰忥細杩欓噷鑾峰彇鐨勬槸璁㈤槄鏁版嵁锛屼笉鏄疉uth Token锛?
      final subscriptionData = await XBoardSDK.instance.subscription.getSubscription();
      
      if (subscriptionData == null) {
        return SubscriptionResult.failure('鏈幏鍙栧埌璁㈤槄淇℃伅');
      }

      final subscribeUrl = subscriptionData.subscribeUrl;
      if (subscribeUrl == null || subscribeUrl.isEmpty) {
        return SubscriptionResult.failure('璁㈤槄URL涓虹┖');
      }

      _logger.info('鑾峰彇鍒拌闃匲RL: $subscribeUrl');

      // 2. 浠庤闃匲RL涓彁鍙栬闃卼oken锛堜笉鏄疉uth Token锛侊級
      final token = _extractTokenFromSubscriptionUrl(subscribeUrl);
      
      if (token == null || token.isEmpty) {
        return SubscriptionResult.failure('鏃犳硶浠庤闃匲RL涓彁鍙杢oken: $subscribeUrl');
      }

      _logger.info('浠庤闃匲RL鎻愬彇鍒拌闃卼oken: ${token.substring(0, 8)}...');

      // 3. 浣跨敤璁㈤槄token鑾峰彇鍔犲瘑璁㈤槄
      return await getEncryptedSubscription(
        token, 
        preferEncrypt: preferEncrypt,
        enableRace: enableRace,
      );

    } catch (e) {
      _logger.error('浠庣櫥褰曟暟鎹幏鍙栬闃呭け璐?, e);
      return SubscriptionResult.failure('浠庣櫥褰曟暟鎹幏鍙栬闃呭け璐? $e');
    }
  }

  /// 浠庤闃匲RL涓彁鍙杢oken
  /// 
  /// 鏀寔澶氱鏍煎紡锛?
  /// - https://domain.com/s/abc123...
  /// - https://domain.com/api/v1/client/subscribe?token=abc123...
  static String? _extractTokenFromSubscriptionUrl(String url) {
    try {
      final uri = Uri.parse(url);
      
      // 鏂瑰紡1: 鏌ヨ鍙傛暟涓殑token
      if (uri.queryParameters.containsKey('token')) {
        return uri.queryParameters['token'];
      }
      
      // 鏂瑰紡2: 璺緞涓殑鏈€鍚庝竴娈典綔涓簍oken (濡?/s/xxx)
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        final lastSegment = pathSegments.last;
        // 楠岃瘉鏄惁鍍弔oken锛堜竴鑸槸16浣嶆垨鏇撮暱鐨勫瓧绗︿覆锛?
        if (lastSegment.length >= 16) {
          return lastSegment;
        }
      }
      
      return null;
    } catch (e) {
      _logger.error('鎻愬彇璁㈤槄token澶辫触', e);
      return null;
    }
  }

  /// 鑾峰彇骞惰В瀵嗗姞瀵嗙殑璁㈤槄鏁版嵁锛堜娇鐢ㄥ凡鐭oken锛?
  /// 
  /// [token] 鐢ㄦ埛鐨勮闃卼oken
  /// [preferEncrypt] 鏄惁浼樺厛浣跨敤鍔犲瘑绔偣锛岄粯璁rue
  /// [enableRace] 鏄惁鍚敤璁㈤槄URL绔為€燂紝榛樿true
  /// 
  /// 杩斿洖瑙ｅ瘑鍚庣殑Clash閰嶇疆鍐呭
  static Future<SubscriptionResult> getEncryptedSubscription(
    String token, {
    bool preferEncrypt = true,
    bool enableRace = true,
  }) async {
    try {
      _logger.info('寮€濮嬭幏鍙栧姞瀵嗚闃咃紝token: ${token.substring(0, 8)}..., 绔為€熸ā寮? $enableRace');

      // 1. 鑾峰彇璁㈤槄閰嶇疆
      final subscriptionInfo = XBoardConfig.subscriptionInfo;
      if (subscriptionInfo == null) {
        return SubscriptionResult.failure('鏈壘鍒拌闃呴厤缃俊鎭?);
      }

      // 2. 鏋勫缓璁㈤槄URL锛堜娇鐢ㄧ珵閫熸垨鍗曚竴URL锛?
      String? subscriptionUrl;
      
      if (enableRace && (subscriptionInfo.urls.length > 1)) {
        _logger.info('[璁㈤槄绔為€焆 妫€娴嬪埌 ${subscriptionInfo.urls.length} 涓闃呮簮锛屽惎鍔ㄧ珵閫熼€夋嫨...');
        subscriptionUrl = await XBoardConfig.getFastestSubscriptionUrl(
          token,
          preferEncrypt: preferEncrypt,
        );
        _logger.info('[璁㈤槄绔為€焆 馃弳 绔為€熷畬鎴愶紝鏈€蹇玌RL: $subscriptionUrl');
      } else {
        subscriptionUrl = subscriptionInfo.buildSubscriptionUrl(
          token, 
          forceEncrypt: preferEncrypt
        );
        _logger.debug('[璁㈤槄鏈嶅姟] 浣跨敤榛樿URL锛堟棤闇€绔為€燂級: $subscriptionUrl');
      }
      
      if (subscriptionUrl == null) {
        return SubscriptionResult.failure('鏃犳硶鏋勫缓璁㈤槄URL');
      }

      _logger.debug('[璁㈤槄鏈嶅姟] 鏈€缁堜娇鐢║RL: $subscriptionUrl');

      // 3. 鑾峰彇鍔犲瘑鏁版嵁
      final encryptedData = await _fetchEncryptedData(subscriptionUrl);
      if (!encryptedData.success) {
        return SubscriptionResult.failure(encryptedData.error!);
      }

      _logger.debug('[璁㈤槄鏈嶅姟] 鑾峰彇鍒板姞瀵嗘暟鎹紝闀垮害: ${encryptedData.data!.length}');

      // 4. 瑙ｅ瘑鏁版嵁
      _logger.info('[璁㈤槄鏈嶅姟] 馃攼 寮€濮嬭В瀵嗚幏鍙栧埌鐨勫姞瀵嗘暟鎹?..');
      final decryptKey = await ConfigFileLoaderHelper.getDecryptKey();
      final decryptResult = XBoardDecryptHelper.smartDecrypt(
        encryptedData.data!,
        configuredKey: decryptKey,
        tryFallback: true, // 鍏佽灏濊瘯澶囩敤瀵嗛挜
      );
      if (!decryptResult.success) {
        _logger.error('[璁㈤槄鏈嶅姟] 馃挜 瑙ｅ瘑澶辫触: ${decryptResult.message}');
        return SubscriptionResult.failure('瑙ｅ瘑澶辫触: ${decryptResult.message}');
      }

      _logger.info('[璁㈤槄鏈嶅姟] 馃帀 瑙ｅ瘑鎴愬姛锛佷娇鐢ㄥ瘑閽? ${decryptResult.keyUsed?.substring(0, 8)}..., 瑙ｅ瘑鍐呭闀垮害: ${decryptResult.content.length}');

      // 璁板綍瑙ｅ瘑鍐呭鐨勫熀鏈粺璁′俊鎭?
      final lines = decryptResult.content.split('\n');
      final nonEmptyLines = lines.where((line) => line.trim().isNotEmpty).length;
      _logger.debug('[璁㈤槄鏈嶅姟] 瑙ｅ瘑鍐呭缁熻: 鎬昏鏁?${lines.length}, 闈炵┖琛屾暟 $nonEmptyLines');

      return SubscriptionResult.success(
        content: decryptResult.content,
        encryptionUsed: true,
        keyUsed: decryptResult.keyUsed,
        originalUrl: subscriptionUrl,
        subscriptionUserInfo: encryptedData.subscriptionUserInfo,
      );

    } catch (e) {
      _logger.error('澶勭悊杩囩▼寮傚父', e);
      return SubscriptionResult.failure('鑾峰彇鍔犲瘑璁㈤槄寮傚父: $e');
    }
  }

  /// 鑾峰彇鍔犲瘑鏁版嵁锛堟敮鎸侀噸璇曪級
  /// 
  /// [url] 璁㈤槄URL
  /// 杩斿洖鍔犲瘑鐨勬暟鎹唴瀹瑰拰璁㈤槄淇℃伅
  static Future<DataResult> _fetchEncryptedData(String url) async {
    _logger.info('[鏁版嵁鑾峰彇] 寮€濮嬭幏鍙栧姞瀵嗘暟鎹紝鏈€澶ч噸璇曟鏁? $maxRetries');

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        _logger.debug('[鏁版嵁鑾峰彇] 绗?$attempt/$maxRetries 娆¤姹? $url');

        final client = HttpClient();
        client.connectionTimeout = requestTimeout;
        
        final uri = Uri.parse(url);
        final request = await client.getUrl(uri);
        
        // 璁剧疆璇锋眰澶达紙鏈嶅姟绔渶瑕丗lClash鏍囪瘑閰嶅悎瀵嗛挜鑾峰彇Clash閰嶇疆鏍煎紡锛?
        final userAgent = await UserAgentConfig.get(UserAgentScenario.subscription);
        request.headers.set(HttpHeaders.userAgentHeader, userAgent);
        request.headers.set(HttpHeaders.acceptHeader, '*/*');
        
        final response = await request.close().timeout(requestTimeout);
        
        _logger.debug('[鏁版嵁鑾峰彇] HTTP鐘舵€佺爜: ${response.statusCode}');

        if (response.statusCode == 200) {
          final responseBody = await response.transform(utf8.decoder).join();
          final subscriptionUserInfo = response.headers.value('subscription-userinfo');
          client.close();

          _logger.debug('[鏁版嵁鑾峰彇] 鉁?鍝嶅簲鎴愬姛锛屾暟鎹暱搴? ${responseBody.length}');
          if (subscriptionUserInfo != null) {
            _logger.debug('[鏁版嵁鑾峰彇] 馃搳 鑾峰彇鍒拌闃呬俊鎭? $subscriptionUserInfo');
          }

          // 灏濊瘯瑙ｆ瀽JSON鍝嶅簲
          try {
            final jsonData = jsonDecode(responseBody);
            if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
              _logger.debug('[鏁版嵁鑾峰彇] 馃搫 妫€娴嬪埌JSON鏍煎紡鍝嶅簲锛屾彁鍙杁ata瀛楁');
              final dataContent = jsonData['data'] as String;
              _logger.debug('[鏁版嵁鑾峰彇] 馃攼 鎻愬彇鍒板姞瀵嗘暟鎹暱搴? ${dataContent.length}');
              return DataResult.success(dataContent, subscriptionUserInfo: subscriptionUserInfo);
            }
          } catch (e) {
            _logger.debug('[鏁版嵁鑾峰彇] 馃搫 闈濲SON鏍煎紡鍝嶅簲锛岀洿鎺ヨ繑鍥炲師濮嬪唴瀹?);
            // 濡傛灉涓嶆槸JSON锛岀洿鎺ヨ繑鍥炲搷搴斾綋
          }

          _logger.debug('[鏁版嵁鑾峰彇] 馃攼 杩斿洖鍘熷鍝嶅簲鍐呭浣滀负鍔犲瘑鏁版嵁');
          return DataResult.success(responseBody, subscriptionUserInfo: subscriptionUserInfo);
          
        } else {
          client.close();
          
          if (attempt < maxRetries) {
            _logger.warning('[鏁版嵁鑾峰彇] 鈿狅笍 璇锋眰澶辫触锛岀姸鎬佺爜: ${response.statusCode}锛?{attempt * 2}绉掑悗杩涜绗?{attempt + 1}娆￠噸璇?..');
            await Future.delayed(Duration(seconds: attempt * 2));
            continue;
          } else {
            _logger.error('[鏁版嵁鑾峰彇] 馃挜 璇锋眰鏈€缁堝け璐ワ紝鐘舵€佺爜: ${response.statusCode}锛屽凡杈惧埌鏈€澶ч噸璇曟鏁?);
            return DataResult.failure('HTTP璇锋眰澶辫触: ${response.statusCode}');
          }
        }
        
      } on TimeoutException {
        if (attempt < maxRetries) {
          _logger.warning('[鏁版嵁鑾峰彇] 鈴?璇锋眰瓒呮椂锛?{attempt * 2}绉掑悗杩涜绗?{attempt + 1}娆￠噸璇?..');
          await Future.delayed(Duration(seconds: attempt * 2));
          continue;
        } else {
          _logger.error('[鏁版嵁鑾峰彇] 馃挜 璇锋眰鏈€缁堣秴鏃讹紝宸茶揪鍒版渶澶ч噸璇曟鏁?);
          return DataResult.failure('璇锋眰瓒呮椂');
        }
      } catch (e) {
        if (attempt < maxRetries) {
          _logger.warning('[鏁版嵁鑾峰彇] 鈿狅笍 璇锋眰寮傚父: $e锛?{attempt * 2}绉掑悗杩涜绗?{attempt + 1}娆￠噸璇?..');
          await Future.delayed(Duration(seconds: attempt * 2));
          continue;
        } else {
          _logger.error('[鏁版嵁鑾峰彇] 馃挜 璇锋眰鏈€缁堝紓甯? $e锛屽凡杈惧埌鏈€澶ч噸璇曟鏁?);
          return DataResult.failure('璇锋眰寮傚父: $e');
        }
      }
    }

    _logger.error('[鏁版嵁鑾峰彇] 馃挜 鎵€鏈夐噸璇曢兘澶辫触浜嗭紝宸插皾璇?$maxRetries 娆?);
    return DataResult.failure('鎵€鏈夐噸璇曢兘澶辫触浜?);
  }

  /// 鍥為€€鍒版櫘閫氳闃呰幏鍙?
  /// 
  /// [token] 鐢ㄦ埛token
  /// [enableRace] 鏄惁鍚敤璁㈤槄URL绔為€?
  /// 褰撳姞瀵嗚闃呭け璐ユ椂鐨勫鐢ㄦ柟妗?
  static Future<SubscriptionResult> fallbackToNormalSubscription(
    String token, {
    bool enableRace = true,
  }) async {
    try {
      _logger.info('鍥為€€鍒版櫘閫氳闃呮ā寮?);

      final subscriptionInfo = XBoardConfig.subscriptionInfo;
      if (subscriptionInfo == null) {
        return SubscriptionResult.failure('鏈壘鍒拌闃呴厤缃俊鎭?);
      }

      // 灏濊瘯鑾峰彇鏅€氱鐐癸紙浣跨敤绔為€熸垨鍗曚竴URL锛?
      String? normalUrl;
      
      if (enableRace && (subscriptionInfo.urls.length > 1)) {
        _logger.info('[鏅€氳闃呯珵閫焆 鍚姩绔為€熼€夋嫨鏅€氱鐐?..');
        normalUrl = await XBoardConfig.getFastestSubscriptionUrl(
          token,
          preferEncrypt: false,
        );
      } else {
        normalUrl = subscriptionInfo.buildSubscriptionUrl(token, forceEncrypt: false);
      }
      
      if (normalUrl == null) {
        return SubscriptionResult.failure('鏃犳硶鏋勫缓鏅€氳闃匲RL');
      }

      final result = await _fetchEncryptedData(normalUrl);
      if (!result.success) {
        return SubscriptionResult.failure(result.error!);
      }

      return SubscriptionResult.success(
        content: result.data!,
        encryptionUsed: false,
        keyUsed: null,
        originalUrl: normalUrl,
        subscriptionUserInfo: result.subscriptionUserInfo,
      );

    } catch (e) {
      return SubscriptionResult.failure('鏅€氳闃呰幏鍙栧け璐? $e');
    }
  }

  /// 鑾峰彇璁㈤槄锛堟櫤鑳介€夋嫨鍔犲瘑鎴栨櫘閫氾級
  /// 
  /// [token] 鍙€夌殑鐢ㄦ埛token锛屽鏋滀笉鎻愪緵鍒欎粠鐧诲綍鏁版嵁鑾峰彇
  /// [preferEncrypt] 鏄惁浼樺厛浣跨敤鍔犲瘑锛岄粯璁rue
  /// [enableRace] 鏄惁鍚敤璁㈤槄URL绔為€燂紝榛樿true
  /// 
  /// 鍏堝皾璇曞姞瀵嗚闃咃紝澶辫触鍚庤嚜鍔ㄥ洖閫€鍒版櫘閫氳闃?
  static Future<SubscriptionResult> getSubscriptionSmart(
    String? token, {
    bool preferEncrypt = true,
    bool enableRace = true,
  }) async {
    try {
      // 濡傛灉娌℃湁鎻愪緵token锛屼紭鍏堜粠鐧诲綍鏁版嵁鑾峰彇
      if (token == null || token.isEmpty) {
        _logger.info('鏈彁渚泃oken锛屼粠鐧诲綍鏁版嵁鑾峰彇');
        return await getEncryptedSubscriptionFromLogin(
          preferEncrypt: preferEncrypt,
          enableRace: enableRace,
        );
      }

      // 浣跨敤鎻愪緵鐨則oken
      if (preferEncrypt) {
        // 鍏堝皾璇曞姞瀵嗚闃?
        final encryptedResult = await getEncryptedSubscription(
          token,
          preferEncrypt: true,
          enableRace: enableRace,
        );
        if (encryptedResult.success) {
          return encryptedResult;
        }
        
        _logger.warning('鍔犲瘑璁㈤槄澶辫触锛屽皾璇曟櫘閫氳闃? ${encryptedResult.error}');
        
        // 鍥為€€鍒版櫘閫氳闃?
        return await fallbackToNormalSubscription(token, enableRace: enableRace);
      } else {
        // 鐩存帴浣跨敤鏅€氳闃?
        return await fallbackToNormalSubscription(token, enableRace: enableRace);
      }
    } catch (e) {
      return SubscriptionResult.failure('鏅鸿兘璁㈤槄鑾峰彇澶辫触: $e');
    }
  }

  // ========== 鏂板锛氬苟鍙戠珵閫熻闃呰幏鍙栨柟娉?==========

  /// 骞跺彂绔為€熻幏鍙栧姞瀵嗚闃咃紙浠庣櫥褰曟暟鎹紝鎺ㄨ崘鏂规硶锛?
  /// 
  /// 浣跨敤澶氫釜璁㈤槄婧愬苟鍙戣姹傦紝绗竴涓垚鍔熺殑鑾疯儨锛岃嚜鍔ㄥ彇娑堝叾浠栬姹?
  /// 
  /// [preferEncrypt] 鏄惁浼樺厛浣跨敤鍔犲瘑绔偣锛岄粯璁rue
  /// [enableRace] 鏄惁鍚敤绔為€熸ā寮忥紝濡傛灉false鍒欏洖閫€鍒版爣鍑嗗崟涓€璇锋眰锛岄粯璁rue
  /// 
  /// 杩斿洖鏈€蹇垚鍔熺殑璁㈤槄缁撴灉
  static Future<SubscriptionResult> getRaceEncryptedSubscriptionFromLogin({
    bool preferEncrypt = true,
    bool enableRace = true,
  }) async {
    try {
      _logger.info('[绔為€熷寮篯 鑾峰彇鍔犲瘑璁㈤槄锛岀珵閫熸ā寮? $enableRace');

      // 濡傛灉鏈惎鐢ㄧ珵閫熸ā寮忥紝鍥為€€鍒板師濮嬫柟娉?
      if (!enableRace) {
        _logger.info('[绔為€熷寮篯 绔為€熸ā寮忓凡绂佺敤锛屼娇鐢ㄦ爣鍑嗚幏鍙栨柟寮?);
        return await getEncryptedSubscriptionFromLogin(preferEncrypt: preferEncrypt);
      }

      // 浣跨敤骞跺彂绔為€熸湇鍔?
      return await ConcurrentSubscriptionService.raceGetEncryptedSubscriptionFromLogin(
        preferEncrypt: preferEncrypt,
      );
    } catch (e) {
      _logger.error('[绔為€熷寮篯 绔為€熻幏鍙栧け璐ワ紝鍥為€€鍒版爣鍑嗘柟寮?, e);
      
      // 绔為€熷け璐ユ椂鍥為€€鍒版爣鍑嗘柟寮?
      return await getEncryptedSubscriptionFromLogin(preferEncrypt: preferEncrypt);
    }
  }

  /// 骞跺彂绔為€熻幏鍙栧姞瀵嗚闃咃紙浣跨敤token锛?
  /// 
  /// [token] 鐢ㄦ埛鐨勮闃卼oken
  /// [preferEncrypt] 鏄惁浼樺厛浣跨敤鍔犲瘑绔偣锛岄粯璁rue
  /// [enableRace] 鏄惁鍚敤绔為€熸ā寮忥紝榛樿true
  /// 
  /// 杩斿洖鏈€蹇垚鍔熺殑璁㈤槄缁撴灉
  static Future<SubscriptionResult> getRaceEncryptedSubscription(
    String token, {
    bool preferEncrypt = true,
    bool enableRace = true,
  }) async {
    try {
      _logger.info('[绔為€熷寮篯 鑾峰彇鍔犲瘑璁㈤槄锛宼oken: ${token.substring(0, 8)}..., 绔為€熸ā寮? $enableRace');

      // 濡傛灉鏈惎鐢ㄧ珵閫熸ā寮忥紝鍥為€€鍒板師濮嬫柟娉?
      if (!enableRace) {
        return await getEncryptedSubscription(token, preferEncrypt: preferEncrypt);
      }

      // 浣跨敤骞跺彂绔為€熸湇鍔?
      return await ConcurrentSubscriptionService.raceGetEncryptedSubscription(
        token, 
        preferEncrypt: preferEncrypt,
      );
    } catch (e) {
      _logger.error('[绔為€熷寮篯 绔為€熻幏鍙栧け璐ワ紝鍥為€€鍒版爣鍑嗘柟寮?, e);
      
      // 绔為€熷け璐ユ椂鍥為€€鍒版爣鍑嗘柟寮?
      return await getEncryptedSubscription(token, preferEncrypt: preferEncrypt);
    }
  }
}

/// 鏁版嵁鑾峰彇缁撴灉
class DataResult {
  final bool success;
  final String? data;
  final String? subscriptionUserInfo;
  final String? error;

  const DataResult._({required this.success, this.data, this.subscriptionUserInfo, this.error});

  factory DataResult.success(String data, {String? subscriptionUserInfo}) => 
    DataResult._(success: true, data: data, subscriptionUserInfo: subscriptionUserInfo);
  factory DataResult.failure(String error) => DataResult._(success: false, error: error);
}

/// 璁㈤槄鑾峰彇缁撴灉
class SubscriptionResult {
  final bool success;
  final String? content;
  final bool encryptionUsed;
  final String? keyUsed;
  final String? originalUrl;
  final String? subscriptionUserInfo;
  final String? error;

  const SubscriptionResult._({
    required this.success,
    this.content,
    this.encryptionUsed = false,
    this.keyUsed,
    this.originalUrl,
    this.subscriptionUserInfo,
    this.error,
  });

  factory SubscriptionResult.success({
    required String content,
    required bool encryptionUsed,
    String? keyUsed,
    String? originalUrl,
    String? subscriptionUserInfo,
  }) => SubscriptionResult._(
    success: true,
    content: content,
    encryptionUsed: encryptionUsed,
    keyUsed: keyUsed,
    originalUrl: originalUrl,
    subscriptionUserInfo: subscriptionUserInfo,
  );

  factory SubscriptionResult.failure(String error) => 
    SubscriptionResult._(success: false, error: error);

  @override
  String toString() {
    return 'SubscriptionResult(success: $success, encryption: $encryptionUsed, keyUsed: $keyUsed)';
  }
}