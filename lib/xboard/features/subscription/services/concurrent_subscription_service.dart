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
import 'encrypted_subscription_service.dart';

// 鍒濆鍖栨枃浠剁骇鏃ュ織鍣?
final _logger = FileLogger('concurrent_subscription_service.dart');

/// 骞跺彂绔為€熻闃呰幏鍙栨湇鍔?
/// 
/// 瀹炵幇澶氭簮骞跺彂璇锋眰锛屽厛鍒板厛鐢ㄧ殑绔為€熸満鍒?
class ConcurrentSubscriptionService {
  static const Duration requestTimeout = Duration(seconds: 30);
  
  /// 骞跺彂绔為€熻幏鍙栧姞瀵嗚闃咃紙浠庣櫥褰曟暟鎹級
  /// 
  /// [preferEncrypt] 鏄惁浼樺厛浣跨敤鍔犲瘑绔偣
  /// 
  /// 杩斿洖鏈€蹇垚鍔熺殑璁㈤槄缁撴灉
  static Future<SubscriptionResult> raceGetEncryptedSubscriptionFromLogin({
    bool preferEncrypt = true,
  }) async {
    try {
      _logger.info('[绔為€熻闃匽 浠庣櫥褰曟暟鎹紑濮嬪苟鍙戣幏鍙?);

      // 1. 鑾峰彇璁㈤槄淇℃伅鍜宼oken
      final subscriptionData = await XBoardSDK.instance.subscription.getSubscription();
      if (subscriptionData == null) {
        return SubscriptionResult.failure('鏈幏鍙栧埌璁㈤槄淇℃伅');
      }
      
      final token = subscriptionData.token;
      if (token == null || token.isEmpty) {
        return SubscriptionResult.failure('璁㈤槄token鏃犳晥');
      }

      _logger.info('[绔為€熻闃匽 鑾峰彇鍒皌oken: ${token.substring(0, 8)}...');

      // 2. 浣跨敤token杩涜绔為€熻幏鍙?
      return await raceGetEncryptedSubscription(token, preferEncrypt: preferEncrypt);

    } catch (e) {
      _logger.error('[绔為€熻闃匽 浠庣櫥褰曟暟鎹幏鍙栧け璐?, e);
      return SubscriptionResult.failure('浠庣櫥褰曟暟鎹幏鍙栬闃呭け璐? $e');
    }
  }

  /// 骞跺彂绔為€熻幏鍙栧姞瀵嗚闃咃紙浣跨敤token锛?
  /// 
  /// [token] 鐢ㄦ埛鐨勮闃卼oken
  /// [preferEncrypt] 鏄惁浼樺厛浣跨敤鍔犲瘑绔偣
  /// 
  /// 杩斿洖鏈€蹇垚鍔熺殑璁㈤槄缁撴灉
  static Future<SubscriptionResult> raceGetEncryptedSubscription(
    String token, {
    bool preferEncrypt = true,
  }) async {
    try {
      _logger.info('[绔為€熻闃匽 寮€濮嬪苟鍙戠珵閫熻幏鍙栵紝token: ${token.substring(0, 8)}...');

      // 1. 鑾峰彇鎵€鏈夊彲鐢ㄧ殑璁㈤槄URL淇℃伅
      final subscriptionUrlInfos = _getAllSubscriptionUrlInfos();
      if (subscriptionUrlInfos.isEmpty) {
        _logger.warning('[绔為€熻闃匽 娌℃湁鎵惧埌鍙敤鐨勮闃匲RL閰嶇疆');
        // 鍥為€€鍒板崟涓€璁㈤槄鑾峰彇
        return await EncryptedSubscriptionService.getEncryptedSubscription(
          token, 
          preferEncrypt: preferEncrypt
        );
      }

      _logger.info('[绔為€熻闃匽 鎵惧埌 ${subscriptionUrlInfos.length} 涓闃匲RL锛屽紑濮嬪苟鍙戣姹?);

      // 2. 涓烘瘡涓猆RL鏋勫缓瀹屾暣鐨勮姹俇RL
      final requestUrls = <String>[];
      for (final urlInfo in subscriptionUrlInfos) {
        final fullUrl = urlInfo.buildSubscriptionUrl(token, preferEncrypt: preferEncrypt);
        if (fullUrl.isNotEmpty) {
          requestUrls.add(fullUrl);
          _logger.debug('[绔為€熻闃匽 娣诲姞璇锋眰URL: $fullUrl');
        }
      }

      if (requestUrls.isEmpty) {
        return SubscriptionResult.failure('鏃犳硶鏋勫缓鏈夋晥鐨勮闃呰姹俇RL');
      }

      // 3. 鎵ц骞跺彂绔為€熻姹?
      final result = await _raceMultipleRequests(requestUrls, token);
      
      _logger.info('[绔為€熻闃匽 绔為€熻姹傚畬鎴愶紝鎴愬姛: ${result.success}');
      return result;

    } catch (e) {
      _logger.error('[绔為€熻闃匽 骞跺彂鑾峰彇寮傚父', e);
      return SubscriptionResult.failure('骞跺彂绔為€熻幏鍙栧け璐? $e');
    }
  }

  /// 鑾峰彇鎵€鏈夎闃匲RL淇℃伅
  static List<SubscriptionUrlInfo> _getAllSubscriptionUrlInfos() {
    try {
      if (!XBoardConfig.isInitialized) {
        _logger.warning('[绔為€熻闃匽 XBoardConfig 鏈垵濮嬪寲');
        return [];
      }
      
      return XBoardConfig.subscriptionUrlList;
    } catch (e) {
      _logger.error('[绔為€熻闃匽 鑾峰彇璁㈤槄URL鍒楄〃澶辫触', e);
      return [];
    }
  }

  /// 鎵ц骞跺彂绔為€熻姹?
  /// 
  /// [urls] 瑕佽姹傜殑URL鍒楄〃
  /// [originalToken] 鍘熷token锛堢敤浜庢棩蹇楋級
  /// 
  /// 杩斿洖鏈€蹇垚鍔熺殑缁撴灉
  static Future<SubscriptionResult> _raceMultipleRequests(
    List<String> urls, 
    String originalToken,
  ) async {
    if (urls.isEmpty) {
      return SubscriptionResult.failure('娌℃湁鍙敤鐨勮姹俇RL');
    }

    if (urls.length == 1) {
      // 鍙湁涓€涓猆RL锛岀洿鎺ヨ姹?
      _logger.info('[绔為€熻闃匽 鍙湁涓€涓猆RL锛岀洿鎺ヨ姹?);
      return await _fetchSingleSubscription(urls.first, originalToken);
    }

    _logger.info('[绔為€熻闃匽 寮€濮嬪苟鍙戠珵閫熻姹?${urls.length} 涓猆RL');

    // 鍒涘缓骞跺彂璇锋眰浠诲姟
    final List<Future<SubscriptionResult>> futures = [];
    final List<CancelToken> cancelTokens = [];

    for (int i = 0; i < urls.length; i++) {
      final url = urls[i];
      final cancelToken = CancelToken();
      cancelTokens.add(cancelToken);
      
      futures.add(_fetchSingleSubscriptionWithCancel(url, originalToken, cancelToken, i));
    }

    try {
      // 浣跨敤 Future.any 瀹炵幇绔為€燂紝绗竴涓垚鍔熺殑鑾疯儨
      SubscriptionResult? winner;
      
      // 鍒涘缓涓€涓?Completer 鏉ュ鐞嗙珵閫熼€昏緫
      final completer = Completer<SubscriptionResult>();
      int completedCount = 0;
      final errors = <String>[];
      
      for (int i = 0; i < futures.length; i++) {
        futures[i].then((result) {
          if (!completer.isCompleted && result.success) {
            // 绗竴涓垚鍔熺殑鑾疯儨
            _logger.info('[绔為€熻闃匽 璇锋眰 #$i 鑾疯儨锛?);
            completer.complete(result);
            
            // 鍙栨秷鍏朵粬璇锋眰
            for (int j = 0; j < cancelTokens.length; j++) {
              if (j != i) cancelTokens[j].cancel();
            }
          } else {
            completedCount++;
            if (result.error != null) {
              errors.add('璇锋眰#$i: ${result.error}');
            }
            
            // 濡傛灉鎵€鏈夎姹傞兘瀹屾垚涓旈兘澶辫触浜?
            if (completedCount == futures.length && !completer.isCompleted) {
              completer.complete(SubscriptionResult.failure(
                '鎵€鏈夊苟鍙戣姹傞兘澶辫触: ${errors.join('; ')}'
              ));
            }
          }
        }).catchError((e) {
          completedCount++;
          errors.add('璇锋眰#$i寮傚父: $e');
          
          if (completedCount == futures.length && !completer.isCompleted) {
            completer.complete(SubscriptionResult.failure(
              '鎵€鏈夊苟鍙戣姹傞兘澶辫触: ${errors.join('; ')}'
            ));
          }
        });
      }
      
      winner = await completer.future;
      return winner;

    } catch (e) {
      // 鎵€鏈夎姹傞兘澶辫触浜嗭紝灏濊瘯绛夊緟骞舵敹闆嗛敊璇俊鎭?
      _logger.warning('[绔為€熻闃匽 鎵€鏈夊苟鍙戣姹傚彲鑳介兘澶辫触浜嗭紝绛夊緟鏀堕泦閿欒淇℃伅');
      
      final results = await Future.wait(
        futures.map((future) => future.catchError((e) => 
          SubscriptionResult.failure('璇锋眰澶辫触: $e')
        )),
      );

      // 妫€鏌ユ槸鍚︽湁鎴愬姛鐨勭粨鏋?
      final successResults = results.where((r) => r.success);
      if (successResults.isNotEmpty) {
        _logger.info('[绔為€熻闃匽 鍦ㄩ敊璇鐞嗕腑鍙戠幇鎴愬姛缁撴灉');
        return successResults.first;
      }

      // 鎵€鏈夐兘澶辫触浜嗭紝杩斿洖缁煎悎閿欒淇℃伅
      final errors = results.map((r) => r.error ?? '鏈煡閿欒').toList();
      return SubscriptionResult.failure(
        '鎵€鏈夊苟鍙戣姹傞兘澶辫触浜? ${errors.join('; ')}'
      );
    }
  }

  /// 鑾峰彇鍗曚釜璁㈤槄锛堝甫鍙栨秷鏀寔锛?
  static Future<SubscriptionResult> _fetchSingleSubscriptionWithCancel(
    String url, 
    String originalToken, 
    CancelToken cancelToken, 
    int index,
  ) async {
    try {
      _logger.debug('[绔為€熻闃匽 璇锋眰 #$index 寮€濮? ${url.length > 50 ? '${url.substring(0, 50)}...' : url}');
      
      final result = await _fetchSingleSubscription(url, originalToken)
          .timeout(requestTimeout)
          .catchError((e) {
            if (cancelToken.isCancelled) {
              _logger.debug('[绔為€熻闃匽 璇锋眰 #$index 琚彇娑?);
              throw CancellationException('Request cancelled');
            }
            throw e;
          });

      if (cancelToken.isCancelled) {
        _logger.debug('[绔為€熻闃匽 璇锋眰 #$index 瀹屾垚浣嗗凡琚彇娑?);
        throw CancellationException('Request cancelled after completion');
      }

      if (result.success) {
        _logger.info('[绔為€熻闃匽 璇锋眰 #$index 鑾疯儨! 鐢ㄦ椂: ${result.originalUrl}');
      }

      return result;
    } catch (e) {
      if (e is CancellationException) {
        _logger.debug('[绔為€熻闃匽 璇锋眰 #$index 琚甯稿彇娑?);
        return SubscriptionResult.failure('璇锋眰琚彇娑?);
      }
      
      _logger.debug('[绔為€熻闃匽 璇锋眰 #$index 澶辫触: $e');
      return SubscriptionResult.failure('璇锋眰澶辫触: $e');
    }
  }

  /// 鑾峰彇鍗曚釜璁㈤槄锛堝鐢ㄧ幇鏈夐€昏緫锛?
  static Future<SubscriptionResult> _fetchSingleSubscription(
    String url, 
    String originalToken,
  ) async {
    try {
      // 1. 鍙戣捣HTTP璇锋眰
      final dataResult = await _fetchEncryptedData(url);
      if (!dataResult.success) {
        return SubscriptionResult.failure(dataResult.error!);
      }

      _logger.debug('[绔為€熻闃匽 鑾峰彇鍒版暟鎹紝闀垮害: ${dataResult.data!.length}');

      // 2. 瑙ｅ瘑鏁版嵁
      final decryptKey = await ConfigFileLoaderHelper.getDecryptKey();
      final decryptResult = XBoardDecryptHelper.smartDecrypt(
        dataResult.data!,
        configuredKey: decryptKey,
        tryFallback: true,
      );
      if (!decryptResult.success) {
        return SubscriptionResult.failure('瑙ｅ瘑澶辫触: ${decryptResult.message}');
      }

      return SubscriptionResult.success(
        content: decryptResult.content,
        encryptionUsed: true,
        keyUsed: decryptResult.keyUsed,
        originalUrl: url,
        subscriptionUserInfo: dataResult.subscriptionUserInfo,
      );

    } catch (e) {
      return SubscriptionResult.failure('鍗曚釜璇锋眰澶辫触: $e');
    }
  }

  /// 鍙戣捣HTTP璇锋眰鑾峰彇鏁版嵁锛堝鐢‥ncryptedSubscriptionService鐨勯€昏緫锛?
  static Future<DataResult> _fetchEncryptedData(String url) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = requestTimeout;
      
      final uri = Uri.parse(url);
      final request = await client.getUrl(uri);
      
      // 璁剧疆璇锋眰澶?
      final userAgent = await UserAgentConfig.get(UserAgentScenario.subscriptionRacing);
      request.headers.set(HttpHeaders.userAgentHeader, userAgent);
      request.headers.set(HttpHeaders.acceptHeader, '*/*');
      
      final response = await request.close().timeout(requestTimeout);
      
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final subscriptionUserInfo = response.headers.value('subscription-userinfo');
        client.close();
        
        // 灏濊瘯瑙ｆ瀽JSON鍝嶅簲
        try {
          final jsonData = jsonDecode(responseBody);
          if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
            return DataResult.success(jsonData['data'] as String, subscriptionUserInfo: subscriptionUserInfo);
          }
        } catch (e) {
          // 濡傛灉涓嶆槸JSON锛岀洿鎺ヨ繑鍥炲搷搴斾綋
        }
        
        return DataResult.success(responseBody, subscriptionUserInfo: subscriptionUserInfo);
        
      } else {
        client.close();
        return DataResult.failure('HTTP璇锋眰澶辫触: ${response.statusCode}');
      }
      
    } on TimeoutException {
      return DataResult.failure('璇锋眰瓒呮椂');
    } catch (e) {
      return DataResult.failure('璇锋眰寮傚父: $e');
    }
  }
}

/// 鍙栨秷浠ょ墝
class CancelToken {
  bool _isCancelled = false;
  
  bool get isCancelled => _isCancelled;
  
  void cancel() {
    _isCancelled = true;
  }
}

/// 鍙栨秷寮傚父
class CancellationException implements Exception {
  final String message;
  
  const CancellationException(this.message);
  
  @override
  String toString() => 'CancellationException: $message';
}