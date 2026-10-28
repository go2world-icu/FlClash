import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/infrastructure/http/board_transport.dart';
import 'package:fl_clash/xboard/core/core.dart';

part 'generated/sdk_provider.g.dart';

final _logger = FileLogger('sdk_provider');

/// XBoard SDK Provider
///
/// 负责SDK的初始化和生命周期管理
/// - 等待 InitializationProvider 完成域名检查
/// - 使用已缓存的域名竞速结果
/// - 自动加载HTTP配置
/// - 缓存SDK实例
///
/// 注意：不要直接调用此 Provider，应该通过 InitializationProvider.initialize() 触发初始化
@Riverpod(keepAlive: true)
Future<XBoardSDK> xboardSdk(Ref ref) async {
  try {
    _logger.info('[XBoardSdkProvider] 开始初始化SDK');

    // 1. 优先使用已缓存的域名竞速结果
    // InitializationProvider 会确保域名检查完成后才调用此 Provider
    String? fastestUrl = XBoardConfig.lastRacingResult?.domain;

    if (fastestUrl != null) {
      _logger.info('[XBoardSdkProvider] 使用缓存的竞速结果: $fastestUrl');
    } else {
      // 冷启动时外壳可能提前触发本 Provider（如公告拉取），此时 XBoardConfig
      // 尚未初始化、域名竞速也还没跑。先确保 XBoardConfig 初始化完成再竞速，
      // 避免拿到空列表直接失败。
      if (!XBoardConfig.isInitialized) {
        await XBoardConfig.initialize();
      }
      fastestUrl = await XBoardConfig.getFastestPanelUrl();
    }

    if (fastestUrl == null) {
      throw Exception('域名竞速失败：所有面板域名都无法连接');
    }

    _logger.info('[XBoardSdkProvider] 使用域名: $fastestUrl');

    // 2. 获取面板类型（通过provider接口）
    final panelType = XBoardConfig.provider.getPanelType();
    if (panelType.isEmpty) {
      throw Exception('无法获取面板类型，请检查配置');
    }

    _logger.info('[XBoardSdkProvider] 面板类型: $panelType');

    // 3. 根据竞速结果决定是否使用代理
    String? proxyUrl;
    final racingResult = XBoardConfig.lastRacingResult;
    if (racingResult != null && racingResult.useProxy) {
      proxyUrl = racingResult.proxyUrl;
      _logger.info('[XBoardSdkProvider] 使用代理: $proxyUrl');
    } else {
      _logger.info('[XBoardSdkProvider] 使用直连');
    }

    // 4. 加载HTTP配置
    _logger.info('[XBoardSdkProvider] 加载HTTP配置...');
    if (proxyUrl == null || proxyUrl.isEmpty) {
      await XBoardTransport.ensureDirectRoute(Uri.parse(fastestUrl));
    }
    final httpConfig = await XBoardTransport.config(proxyUrl: proxyUrl);
    _logger.info('[XBoardSdkProvider] HTTP配置加载完成');

    // 5. 初始化SDK
    final sdk = XBoardSDK.instance;
    await sdk.initialize(
      fastestUrl,
      panelType: panelType,
      proxyUrl: proxyUrl,
      httpConfig: httpConfig,
      routeResolver: () async {
        final route = await XBoardConfig.recoverPanelRoute();
        if (route != null && !route.useProxy) {
          await XBoardTransport.ensureDirectRoute(Uri.parse(route.domain));
        }
        return route == null
            ? null
            : ApiRoute(route.domain, route.useProxy ? route.proxyUrl : null);
      },
      enableLogging: false,
      logOutput: (line) => XBoardLogger.info('[SDK] $line'),
    );

    _logger.info('[XBoardSdkProvider] SDK初始化成功');
    return sdk;
  } catch (e, stackTrace) {
    _logger.error('[XBoardSdkProvider] SDK初始化失败', e, stackTrace);
    rethrow;
  }
}
