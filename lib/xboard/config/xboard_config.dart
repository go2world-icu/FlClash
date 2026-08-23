/// XBoard 配置模块 - 主入口
/// 
/// 这是重构后的XBoard配置模块，提供清晰的分层架构和统一的API接口
library;

// ========== 公共API导出 ==========
// 只导出外部需要使用的类和接口

// 配置接口（关键！允许SDK层依赖接口而非实现）
export 'interface/config_provider_interface.dart';

// 核心配置设置（外部可能需要自定义配置）
export 'core/config_settings.dart' show 
  ConfigSettings,
  RemoteConfigSettings,
  LogSettings,
  RemoteSourceConfig;

// 数据模型（外部需要访问配置数据）
export 'models/config_entry.dart';
export 'models/proxy_info.dart';
export 'models/websocket_info.dart';
export 'models/update_info.dart';
// 注意：SubscriptionInfo与SDK中的同名，这里只导出SubscriptionUrlInfo
export 'models/subscription_info.dart' show SubscriptionUrlInfo;

// 状态枚举（外部需要监听状态）
export 'internal/xboard_config_accessor.dart' show ConfigAccessorState;

// 日志工具已移至core
// export 'utils/logger.dart' show ConfigLogger;

// 配置文件加载器（开源友好）
export 'utils/config_file_loader.dart';

// ========== 便捷API ==========

import 'dart:async';

import 'package:fl_clash/xboard/core/core.dart';

import 'core/module_initializer.dart';
import 'core/config_settings.dart';
import 'internal/xboard_config_accessor.dart';
import 'models/config_entry.dart';
import 'models/proxy_info.dart';
import 'models/websocket_info.dart';
import 'models/update_info.dart';
import 'models/subscription_info.dart';
import '../infrastructure/infrastructure.dart';
import 'utils/config_file_loader.dart';

import 'interface/config_provider_interface.dart';

/// 内部配置提供者实现
/// 
/// 实现ConfigProviderInterface接口，供SDK层使用
class _XBoardConfigProvider implements ConfigProviderInterface {
  final XBoardConfigAccessor accessor;
  
  _XBoardConfigProvider(this.accessor);
  
  @override
  String getPanelType() => accessor.getPanelType();
  
  @override
  String? getPanelUrl() => accessor.getFirstPanelUrl();
  
  @override
  String? getProxyUrl() => accessor.getFirstProxyUrl();
  
  @override
  String? getWebSocketUrl() => accessor.getFirstWebSocketUrl();
  
  @override
  String? getUpdateUrl() => accessor.getFirstUpdateUrl();

  @override
  String? getReportLogUrl() => accessor.getFirstReportLogUrl();

  @override
  SubscriptionInfo? getSubscriptionInfo() => accessor.getSubscriptionInfo();
  
  @override
  String? getSubscriptionUrl() => getSubscriptionInfo()?.firstUrl;
  
  @override
  String? buildSubscriptionUrl(String token, {bool preferEncrypt = true}) {
    return getSubscriptionInfo()?.buildSubscriptionUrl(token, forceEncrypt: preferEncrypt);
  }
  
  @override
  Future<String?> getFastestPanelUrl() async {
    final panelUrls = getAllPanelUrls();
    if (panelUrls.isEmpty) return null;
    
    // 获取所有代理配置
    final proxyUrls = getAllProxyUrls();
    
    // 始终使用竞速，即使只有一个域名（竞速会直接返回该域名）
    // 每个域名会测试：直连 + 所有代理
    final racingResult = await DomainRacingService.raceSelectFastestDomain(
      panelUrls,
      forceHttpsResult: true,
      proxyUrls: proxyUrls,
    );
    
    // 竞速失败直接返回 null，不回退
    if (racingResult == null) return null;
    
    // 保存竞速结果中的代理配置（供 SDK 使用）
    XBoardConfig._lastRacingResult = racingResult;
    
    return racingResult.domain;
  }
  
  @override
  List<String> getAllPanelUrls() => accessor.getPanelConfigList().map((e) => e.url).toList();
  
  @override
  List<String> getAllProxyUrls() => accessor.getProxyConfigList().map((e) => e.url).toList();
  
  @override
  List<String> getAllWebSocketUrls() => accessor.getWebSocketConfigList().map((e) => e.url).toList();
  
  @override
  Future<void> refresh() async {
    await accessor.refreshConfiguration();
  }
  
  @override
  Future<void> refreshFromSource(String source) async {
    await accessor.refreshFromSource(source);
  }
  
  @override
  Stream<void> get configChangeStream => accessor.configStream.map((_) {});
}

/// XBoard配置模块主入口类
/// 
/// 这是唯一的公共API入口，外部应该只通过这个类访问配置功能
class XBoardConfig {
  static XBoardConfigAccessor? _instance;
  static _XBoardConfigProvider? _provider;
  
  // 缓存最后一次竞速结果
  static DomainRacingResult? _lastRacingResult;
  
  // 私有构造函数，防止外部实例化
  XBoardConfig._();
  
  /// 初始化模块
  /// 
  /// [provider] 当前使用的提供商 (Flclash/Flclash)
  /// [settings] 可选的详细配置设置
  /// 
  /// 这是初始化模块的唯一方式
  static Future<void> initialize({
    String provider = 'Flclash',
    ConfigSettings? settings,
  }) {
    // 请求合并：冷启动时 domainStatusService 与 SDK Provider 的兜底初始化
    // 可能并发触发，合并成一次真正的初始化，避免重复创建配置访问器。
    return _initializeFuture ??= _doInitialize(settings: settings);
  }

  static Future<void>? _initializeFuture;

  static Future<void> _doInitialize({ConfigSettings? settings}) async {
    try {
      final config = settings ?? await ConfigFileLoader.loadFromFile();

      _instance = await ModuleInitializer.createConfigAccessor(
        settings: config,
        autoWarmUp: true,
      );

      // 创建配置提供者实例
      _provider = _XBoardConfigProvider(_instance!);
    } finally {
      _initializeFuture = null;
    }
  }
  
  /// 获取配置提供者接口（供SDK层使用）
  /// 
  /// 返回实现了ConfigProviderInterface的实例
  static ConfigProviderInterface get provider {
    if (_provider == null) {
      throw StateError('XBoardConfig not initialized. Call initialize() first.');
    }
    return _provider!;
  }
  
  /// 检查是否已初始化
  static bool get isInitialized => _instance != null;
  
  /// 获取最后一次竞速结果
  static DomainRacingResult? get lastRacingResult => _lastRacingResult;
  
  /// 重置模块
  static void reset() {
    _instance?.dispose();
    _instance = null;
    _provider = null;
    ModuleInitializer.reset();
  }
  
  // ========== 内部访问器（受保护） ==========
  
  /// 获取内部配置访问器（仅供内部使用）
  /// 
  /// 注意：这个方法主要用于高级用户，一般情况下使用便捷方法即可
  static XBoardConfigAccessor get _accessor {
    if (_instance == null) {
      throw StateError('XBoardConfig not initialized. Call initialize() first.');
    }
    return _instance!;
  }
  
  // ========== 公共API方法 ==========
  
  /// 获取第一个面板URL
  ///
  /// 冷启动时配置可能尚未初始化（外壳已因本地 token 进入首页，而
  /// XBoardConfig.initialize 在后台域名检查里执行），此时返回 null，
  /// 由 UI 侧按「无配置」降级展示，而不是抛 StateError 打断构建。
  static String? get panelUrl => _instance?.getFirstPanelUrl();

  /// 应用标题（本地YAML兜底，远程base覆盖）
  static String get appTitle => _instance?.appTitle ?? '';

  /// 应用网站（本地YAML兜底，远程base覆盖）
  static String get appWebsite => _instance?.appWebsite ?? '';

  // 缓存正在进行的竞速任务
  static Future<String?>? _racingFuture;

  /// 并发竞速获取最快的面板URL
  ///
  /// 对当前所有可用的面板URL进行并发测试，返回响应最快的URL
  /// 如果所有URL都失败，则返回null
  /// 注意：返回的URL会强制转换为HTTPS格式，以适配SDK的私有证书配置
  static Future<String?> getFastestPanelUrl() async {
    // 如果已经有正在进行的竞速，直接返回该结果（请求合并）
    if (_racingFuture != null) {
      return _racingFuture;
    }

    final panelUrls = allPanelUrls;
    if (panelUrls.isEmpty) return null;

    // 冷启动快路径：本进程还没跑过竞速，先用持久化的上次竞速结果，
    // 避免每次启动都等一轮网络竞速（每域名 5s 连接 / 8s 响应）。
    if (_lastRacingResult == null) {
      final cached = await RacingResultCache.load();
      if (cached != null && cached.domain.isNotEmpty) {
        // 探活：缓存域名还活着才信任它；死了就清掉缓存走正常竞速（回退）。
        if (await DomainRacingService.probeDomain(
          cached.domain,
          proxyUrl: cached.proxyUrl,
        )) {
          XBoardLogger.info('[XBoardConfig] 使用缓存域名: ${cached.domain}');
          _lastRacingResult = cached;
          // 后台异步竞速刷新缓存，跑赢的结果留给下次启动（SDK 基地址不可热切）。
          unawaited(_raceSelectFastest());
          return cached.domain;
        } else {
          XBoardLogger.info('[XBoardConfig] 缓存域名失效，回退到竞速: ${cached.domain}');
          await RacingResultCache.clear();
        }
      }
    }

    return _raceSelectFastest();
  }

  /// 执行完整竞速并持久化结果。
  static Future<String?> _raceSelectFastest() async {
    final panelUrls = allPanelUrls;
    if (panelUrls.isEmpty) return null;

    // 获取所有代理
    final proxyUrls = allProxyUrls;

    // 创建新的竞速任务
    _racingFuture = DomainRacingService.raceSelectFastestDomain(
      panelUrls,
      forceHttpsResult: true, // 强制返回HTTPS格式，适配SDK私有证书
      proxyUrls: proxyUrls,
    ).then((result) {
      if (result != null) {
        // 保存竞速结果
        _lastRacingResult = result;
        // 持久化，供下次冷启动快路径使用
        unawaited(RacingResultCache.save(result));
        return result.domain;
      }
      return null;
    }).whenComplete(() {
      // 任务完成后清除缓存，允许下一次新的竞速
      _racingFuture = null;
    });

    return _racingFuture;
  }
  
  /// 获取第一个代理URL
  static String? get proxyUrl => _instance?.getFirstProxyUrl();

  /// 获取第一个WebSocket URL
  static String? get wsUrl => _instance?.getFirstWebSocketUrl();

  /// 获取第一个更新URL
  static String? get updateUrl => _instance?.getFirstUpdateUrl();

  /// 获取第一个报告日志URL
  static String? get reportLogUrl => _instance?.getFirstReportLogUrl();

  /// 获取面板配置列表
  static List<ConfigEntry> get panelList => _instance?.getPanelConfigList() ?? const [];

  /// 获取代理配置列表
  static List<ProxyInfo> get proxyList => _instance?.getProxyConfigList() ?? const [];

  /// 获取WebSocket配置列表
  static List<WebSocketInfo> get webSocketList => _instance?.getWebSocketConfigList() ?? const [];

  /// 获取更新配置列表
  static List<UpdateInfo> get updateList => _instance?.getUpdateConfigList() ?? const [];

  /// 获取订阅配置信息
  static SubscriptionInfo? get subscriptionInfo => _instance?.getSubscriptionInfo();

  /// 获取订阅URL列表
  static List<SubscriptionUrlInfo> get subscriptionUrlList => subscriptionInfo?.urls ?? [];

  /// 获取第一个订阅URL
  static String? get subscriptionUrl => subscriptionInfo?.firstUrl;

  /// 获取第一个支持加密的订阅URL
  static String? get encryptSubscriptionUrl => subscriptionInfo?.firstEncryptUrl?.url;

  /// 构建订阅URL（带token）
  static String? buildSubscriptionUrl(String token, {bool preferEncrypt = true}) {
    return subscriptionInfo?.buildSubscriptionUrl(token, forceEncrypt: preferEncrypt);
  }

  /// 并发竞速获取最快的订阅URL
  /// 
  /// 对所有订阅URL进行并发测试，返回第一个成功（200响应）的URL
  /// [token] 用户订阅token
  /// [preferEncrypt] 是否优先使用加密端点
  /// 
  /// 返回最快响应成功的订阅URL，如果都失败则返回第一个URL
  static Future<String?> getFastestSubscriptionUrl(
    String token, {
    bool preferEncrypt = true,
  }) async {
    final subInfo = subscriptionInfo;
    if (subInfo == null || subInfo.urls.isEmpty) return null;
    
    // 构建所有可能的订阅URL
    final List<String> subscriptionUrls = [];
    
    for (final urlInfo in subInfo.urls) {
      final url = urlInfo.buildSubscriptionUrl(token, preferEncrypt: preferEncrypt);
      if (url.isNotEmpty) {
        subscriptionUrls.add(url);
      }
    }
    
    if (subscriptionUrls.isEmpty) return null;
    
    // 获取所有代理
    final proxyUrls = allProxyUrls;
    
    // 使用竞速服务选择最快的订阅URL
    final racingResult = await DomainRacingService.raceSelectFastestDomain(
      subscriptionUrls,
      forceHttpsResult: false, // 订阅URL保持原始格式
      proxyUrls: proxyUrls,
    );
    
    return racingResult?.domain;
  }
  
  /// 获取所有面板URL列表
  static List<String> get allPanelUrls => panelList.map((e) => e.url).toList();
  
  /// 获取所有代理URL列表
  static List<String> get allProxyUrls => proxyList.map((e) => e.url).toList();
  
  /// 获取所有WebSocket URL列表
  static List<String> get allWsUrls => webSocketList.map((e) => e.url).toList();
  
  /// 获取所有更新URL列表
  static List<String> get allUpdateUrls => updateList.map((e) => e.url).toList();

  /// 获取所有订阅URL列表
  static List<String> get allSubscriptionUrls => subscriptionUrlList.map((e) => e.url).toList();

  /// 获取所有支持加密的订阅URL列表
  static List<String> get allEncryptSubscriptionUrls => 
      subscriptionUrlList.where((e) => e.supportEncrypt).map((e) => e.url).toList();
  
  /// 刷新配置
  static Future<void> refresh() async {
    await _accessor.refreshConfiguration();
  }
  
  /// 从指定源刷新配置
  static Future<void> refreshFromSource(String source) async {
    await _accessor.refreshFromSource(source);
  }
  
  /// 获取配置统计信息
  static Map<String, dynamic> get stats => _accessor.getConfigStats();
  
  /// 获取当前配置状态
  static ConfigAccessorState get state => _accessor.state;
  
  /// 获取最后的错误信息
  static String? get lastError => _accessor.lastError;
  
  /// 监听配置变化
  static Stream<Map<String, dynamic>> get configChangeStream => 
      _accessor.configStream.map((config) => _accessor.getConfigStats());
  
  /// 监听状态变化
  static Stream<ConfigAccessorState> get stateChangeStream => _accessor.stateStream;
}

/// 使用示例：
/// 
/// ```dart
/// // 1. 初始化模块（唯一的初始化方式）
/// await XBoardConfig.initialize(provider: 'Flclash');
/// 
/// // 2. 使用公共API获取配置
/// final panelUrl = XBoardConfig.panelUrl;
/// final proxyUrl = XBoardConfig.proxyUrl;
/// final panelList = XBoardConfig.panelList;
/// final proxyList = XBoardConfig.proxyList;
/// 
/// // 3. 监听配置变化
/// XBoardConfig.configChangeStream.listen((stats) {
///   print('配置已更新: ${stats['panels']} 个面板');
/// });
/// 
/// // 4. 刷新配置
/// await XBoardConfig.refresh();
/// await XBoardConfig.refreshFromSource('redirect');
/// ```
/// 
/// 注意：外部代码不应该直接访问内部类，所有功能都通过XBoardConfig提供
