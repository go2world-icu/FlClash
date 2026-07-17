import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/infrastructure/http/user_agent_config.dart';
import 'package:fl_clash/xboard/core/core.dart';

part 'generated/sdk_provider.g.dart';

final _logger = FileLogger('sdk_provider');

/// XBoard SDK Provider
/// 
/// 璐熻矗SDK鐨勫垵濮嬪寲鍜岀敓鍛藉懆鏈熺鐞?
/// - 绛夊緟 InitializationProvider 瀹屾垚鍩熷悕妫€鏌?
/// - 浣跨敤宸茬紦瀛樼殑鍩熷悕绔為€熺粨鏋?
/// - 鑷姩鍔犺浇HTTP閰嶇疆
/// - 缂撳瓨SDK瀹炰緥
/// 
/// 娉ㄦ剰锛氫笉瑕佺洿鎺ヨ皟鐢ㄦ Provider锛屽簲璇ラ€氳繃 InitializationProvider.initialize() 瑙﹀彂鍒濆鍖?
@Riverpod(keepAlive: true)
Future<XBoardSDK> xboardSdk(Ref ref) async {
  try {
    _logger.info('[XBoardSdkProvider] 寮€濮嬪垵濮嬪寲SDK');
    
    // 1. 浼樺厛浣跨敤宸茬紦瀛樼殑鍩熷悕绔為€熺粨鏋?
    // InitializationProvider 浼氱‘淇濆煙鍚嶆鏌ュ畬鎴愬悗鎵嶈皟鐢ㄦ Provider
    String? fastestUrl = XBoardConfig.lastRacingResult?.domain;
    
    if (fastestUrl != null) {
      _logger.info('[XBoardSdkProvider] 浣跨敤缂撳瓨鐨勭珵閫熺粨鏋? $fastestUrl');
    } else {
      // 濡傛灉娌℃湁缂撳瓨锛岃鏄庢病鏈夐€氳繃 InitializationProvider 鍒濆鍖?
      // 浣滀负闄嶇骇鏂规锛岃嚜宸辨墽琛屽煙鍚嶇珵閫?
      _logger.warning('[XBoardSdkProvider] 鈿狅笍 缂撳瓨鏈懡涓紝鎵ц闄嶇骇鏂规锛氳嚜琛岀珵閫?);
      _logger.warning('[XBoardSdkProvider] 寤鸿閫氳繃 InitializationProvider.initialize() 瑙﹀彂鍒濆鍖?);
      
      fastestUrl = await XBoardConfig.getFastestPanelUrl();
    }
    
    if (fastestUrl == null) {
      throw Exception('鍩熷悕绔為€熷け璐ワ細鎵€鏈夐潰鏉垮煙鍚嶉兘鏃犳硶杩炴帴');
    }
    
    _logger.info('[XBoardSdkProvider] 浣跨敤鍩熷悕: $fastestUrl');
    
    // 2. 鑾峰彇闈㈡澘绫诲瀷锛堥€氳繃provider鎺ュ彛锛?
    final panelType = XBoardConfig.provider.getPanelType();
    if (panelType.isEmpty) {
      throw Exception('鏃犳硶鑾峰彇闈㈡澘绫诲瀷锛岃妫€鏌ラ厤缃?);
    }
    
    _logger.info('[XBoardSdkProvider] 闈㈡澘绫诲瀷: $panelType');
    
    // 3. 鏍规嵁绔為€熺粨鏋滃喅瀹氭槸鍚︿娇鐢ㄤ唬鐞?
    String? proxyUrl;
    final racingResult = XBoardConfig.lastRacingResult;
    if (racingResult != null && racingResult.useProxy) {
      proxyUrl = racingResult.proxyUrl;
      _logger.info('[XBoardSdkProvider] 浣跨敤浠ｇ悊: $proxyUrl');
    } else {
      _logger.info('[XBoardSdkProvider] 浣跨敤鐩磋繛');
    }
    
    // 4. 鍔犺浇HTTP閰嶇疆
    _logger.info('[XBoardSdkProvider] 鍔犺浇HTTP閰嶇疆...');
    final httpConfig = await _loadHttpConfig();
    _logger.info('[XBoardSdkProvider] HTTP閰嶇疆鍔犺浇瀹屾垚');
    
    // 5. 鍒濆鍖朣DK
    final sdk = XBoardSDK.instance;
    await sdk.initialize(
      fastestUrl,
      panelType: panelType,
      proxyUrl: proxyUrl,
      httpConfig: httpConfig,
    );
    
    _logger.info('[XBoardSdkProvider] SDK鍒濆鍖栨垚鍔?);
    return sdk;
    
  } catch (e, stackTrace) {
    _logger.error('[XBoardSdkProvider] SDK鍒濆鍖栧け璐?, e, stackTrace);
    rethrow;
  }
}

/// 鍔犺浇HTTP閰嶇疆
/// 
/// 浠庨厤缃枃浠惰鍙栵細
/// - User-Agent
/// - 娣锋穯鍓嶇紑
/// - 璇佷功閰嶇疆
Future<HttpConfig> _loadHttpConfig() async {
  try {
    // 浠庨厤缃枃浠惰幏鍙栧姞瀵?UA锛堢敤浜?API 璇锋眰鍜?Caddy 璁よ瘉锛?
    final userAgent = await UserAgentConfig.get(
      UserAgentScenario.apiEncrypted,
    );
    
    // 浠庨厤缃枃浠惰幏鍙栨贩娣嗗墠缂€
    final obfuscationPrefix = await ConfigFileLoaderHelper.getObfuscationPrefix();
    
    // 浠庨厤缃枃浠惰幏鍙栬瘉涔﹂厤缃?
    final certConfig = await ConfigFileLoaderHelper.getCertificateConfig();
    final certPath = certConfig['path'] as String?;
    final certEnabled = certConfig['enabled'] as bool? ?? true;
    
    // 鏋勫缓 HttpConfig
    return HttpConfig(
      userAgent: userAgent,
      obfuscationPrefix: obfuscationPrefix,
      enableAutoDeobfuscation: obfuscationPrefix != null,
      certificatePath: certEnabled ? certPath : null,
      enableCertificatePinning: certEnabled && certPath != null,
    );
  } catch (e) {
    _logger.error('[XBoardSdkProvider] 鍔犺浇HTTP閰嶇疆澶辫触锛屼娇鐢ㄩ粯璁ら厤缃?, e);
    return HttpConfig.defaultConfig();
  }
}
