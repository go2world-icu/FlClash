/// XBoard 配置模块 - 主入口
///
/// 这是重构后的XBoard配置模块，提供清晰的分层架构和统一的API接口
library;

// ========== 公共API导出 ==========
// 只导出外部需要使用的类和接口

// 配置接口（关键！允许SDK层依赖接口而非实现）
export 'interface/config_provider_interface.dart';

// 核心配置设置（外部可能需要自定义配置）
export 'core/config_settings.dart'
    show ConfigSettings, RemoteConfigSettings, LogSettings, RemoteSourceConfig;

// 数据模型（外部需要访问配置数据）
export 'models/config_entry.dart';
export 'models/proxy_info.dart';
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
import 'dart:convert';

import 'package:fl_clash/xboard/core/core.dart';

import 'core/module_initializer.dart';
import 'core/config_settings.dart';
import 'internal/xboard_config_accessor.dart';
import 'models/config_entry.dart';
import 'models/proxy_info.dart';
import 'models/subscription_info.dart';
import '../infrastructure/infrastructure.dart';
import '../infrastructure/http/board_transport.dart';
import '../infrastructure/storage/file_storage.dart';
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
  String? getReportLogUrl() => accessor.getFirstReportLogUrl();

  @override
  SubscriptionInfo? getSubscriptionInfo() => accessor.getSubscriptionInfo();

  @override
  String? getSubscriptionUrl() => getSubscriptionInfo()?.firstUrl;

  @override
  String? buildSubscriptionUrl(String token, {bool preferEncrypt = true}) {
    return getSubscriptionInfo()?.buildSubscriptionUrl(
      token,
      forceEncrypt: preferEncrypt,
    );
  }

  @override
  Future<String?> getFastestPanelUrl() => XBoardConfig.getFastestPanelUrl();

  @override
  List<String> getAllPanelUrls() =>
      accessor.getPanelConfigList().map((e) => e.url).toList();

  @override
  List<String> getAllProxyUrls() =>
      accessor.getProxyConfigList().map((e) => e.url).toList();

  @override
  Future<void> refresh() async {
    await XBoardConfig.refresh();
  }

  @override
  Future<void> refreshFromSource(String source) async {
    await XBoardConfig.refreshFromSource(source);
  }

  @override
  Stream<void> get configChangeStream => accessor.configStream.map((_) {});
}

/// XBoard配置模块主入口类
///
/// 这是唯一的公共API入口，外部应该只通过这个类访问配置功能
class XBoardConfig {
  static const String _remoteConfigCacheKey = 'xboard_remote_panel_config';
  static XBoardConfigAccessor? _instance;
  static _XBoardConfigProvider? _provider;

  // 缓存最后一次竞速结果
  static DomainRacingResult? _lastRacingResult;
  static bool _usingPersistedConfig = false;

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
      _usingPersistedConfig = false;
      final config = settings ?? await ConfigFileLoader.loadFromFile();
      final storage = await FileStorage.shared();
      final cachedJson = (await storage.getString(
        _remoteConfigCacheKey,
      )).dataOrNull;
      final cached = _decodeCachedConfiguration(cachedJson);
      if (cachedJson != null && cached == null) {
        await storage.remove(_remoteConfigCacheKey);
      }
      final accessor = await ModuleInitializer.createConfigAccessor(
        settings: config,
        autoWarmUp: false,
      );
      if (cached != null) {
        _usingPersistedConfig = await accessor.loadCachedConfiguration(cached);
        if (!_usingPersistedConfig) {
          await storage.remove(_remoteConfigCacheKey);
        }
      }
      if (!_usingPersistedConfig) {
        await _prepareRemoteConfigRoutes(config);
        await accessor.refreshConfiguration();
      }
      if (!accessor.isReady || accessor.getPanelConfigList().isEmpty) {
        throw StateError(
          accessor.lastError ?? 'No usable XBoard panel configuration',
        );
      }
      _instance = accessor;
      _provider = _XBoardConfigProvider(accessor);
    } finally {
      _initializeFuture = null;
    }
  }

  static Map<String, dynamic>? _decodeCachedConfiguration(String? value) {
    if (value == null) return null;
    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> _prepareRemoteConfigRoutes(ConfigSettings config) async {
    for (final source in config.remoteConfig.sources) {
      final uri = Uri.tryParse(source.url);
      if (uri != null && uri.scheme == 'https' && uri.host.isNotEmpty) {
        await XBoardTransport.ensureDirectRoute(uri);
      }
    }
  }

  static Future<void> persistRemoteConfiguration() async {
    final data = _instance?.remoteConfigData;
    if (data == null) return;
    final saved = await (await FileStorage.shared()).setString(
      _remoteConfigCacheKey,
      jsonEncode(data),
    );
    if (saved.dataOrNull != true) {
      throw StateError('Unable to save XBoard remote configuration');
    }
    _usingPersistedConfig = true;
  }

  static Future<void> clearPersistedRemoteConfiguration() async {
    final removed = await (await FileStorage.shared()).remove(
      _remoteConfigCacheKey,
    );
    if (removed.dataOrNull != true) {
      throw StateError('Unable to clear XBoard remote configuration');
    }
    _usingPersistedConfig = false;
  }

  /// 获取配置提供者接口（供SDK层使用）
  ///
  /// 返回实现了ConfigProviderInterface的实例
  static ConfigProviderInterface get provider {
    if (_provider == null) {
      throw StateError(
        'XBoardConfig not initialized. Call initialize() first.',
      );
    }
    return _provider!;
  }

  /// 检查是否已初始化
  static bool get isInitialized => _instance?.isReady == true;

  /// 获取最后一次竞速结果
  static DomainRacingResult? get lastRacingResult => _lastRacingResult;

  /// 重置模块
  static void reset() {
    _instance?.dispose();
    _instance = null;
    _provider = null;
    _lastRacingResult = null;
    _usingPersistedConfig = false;
    _racingFuture = null;
    ModuleInitializer.reset();
  }

  // ========== 内部访问器（受保护） ==========

  /// 获取内部配置访问器（仅供内部使用）
  ///
  /// 注意：这个方法主要用于高级用户，一般情况下使用便捷方法即可
  static XBoardConfigAccessor get _accessor {
    if (_instance == null) {
      throw StateError(
        'XBoardConfig not initialized. Call initialize() first.',
      );
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
  static Future<DomainRacingResult?>? _racingFuture;

  /// 返回通过探测的 HTTPS 面板地址，全部失败时返回 null。
  static Future<String?> getFastestPanelUrl() async =>
      (await (_racingFuture ?? _trackRace(_selectPanelRoute())))?.domain;

  static Future<DomainRacingResult?> _selectPanelRoute() async {
    final panelUrls = allPanelUrls;
    if (panelUrls.isEmpty) return null;

    // 冷启动快路径：本进程还没跑过竞速，先用持久化的上次竞速结果，
    // 避免每次启动都等一轮网络竞速（每域名 5s 连接 / 8s 响应）。
    if (_lastRacingResult == null) {
      final cached = await RacingResultCache.load(
        panelUrls: panelUrls,
        proxyUrls: allProxyUrls,
      );
      if (cached != null && cached.domain.isNotEmpty) {
        // 探活：缓存域名还活着才信任它；死了就清掉缓存走正常竞速（回退）。
        if (await DomainRacingService.probeDomain(
          cached.domain,
          proxyUrl: cached.proxyUrl,
        )) {
          XBoardLogger.info('[XBoardConfig] 使用缓存域名: ${cached.domain}');
          _lastRacingResult = cached;
          return cached;
        } else {
          XBoardLogger.info('[XBoardConfig] 缓存域名失效，回退到竞速: ${cached.domain}');
          await RacingResultCache.clear();
        }
      }
    }

    return _raceSelectFastest();
  }

  /// 执行完整竞速并持久化结果。
  static Future<DomainRacingResult?> _raceSelectFastest({
    (String, String?)? excludedRoute,
  }) async {
    final panelUrls = allPanelUrls;
    if (panelUrls.isEmpty) return null;

    // 获取所有代理
    final proxyUrls = allProxyUrls;

    final result = await DomainRacingService.raceSelectFastestDomain(
      panelUrls,
      forceHttpsResult: true,
      proxyUrls: proxyUrls,
      excludedRoute: excludedRoute,
    );
    _lastRacingResult = result;
    if (result != null) {
      await RacingResultCache.save(result, proxyUrls: proxyUrls);
    }
    return result;
  }

  static Future<DomainRacingResult?> _trackRace(
    Future<DomainRacingResult?> selection,
  ) {
    late final Future<DomainRacingResult?> pending;
    pending = selection.whenComplete(() {
      if (identical(_racingFuture, pending)) _racingFuture = null;
    });
    return _racingFuture = pending;
  }

  static Future<DomainRacingResult?> recoverPanelRoute(
    String failedDomain,
    String? failedProxy,
  ) => _trackRace(
    _recoverPanelRoute(_racingFuture, (failedDomain, failedProxy)),
  );

  static Future<DomainRacingResult?> _recoverPanelRoute(
    Future<DomainRacingResult?>? pending,
    (String, String?) excludedRoute,
  ) async {
    if (pending != null) await pending;
    _lastRacingResult = null;
    await RacingResultCache.clear();
    final result = await _raceSelectFastest(excludedRoute: excludedRoute);
    if (result != null || _usingPersistedConfig) return result;
    await _accessor.refreshConfiguration();
    return _raceSelectFastest(excludedRoute: excludedRoute);
  }

  /// 获取第一个代理URL
  static String? get proxyUrl => _instance?.getFirstProxyUrl();

  /// 获取第一个报告日志URL
  static String? get reportLogUrl => _instance?.getFirstReportLogUrl();

  /// 获取面板配置列表
  static List<ConfigEntry> get panelList =>
      _instance?.getPanelConfigList() ?? const [];

  /// 获取代理配置列表
  static List<ProxyInfo> get proxyList =>
      _instance?.getProxyConfigList() ?? const [];

  /// 获取订阅配置信息
  static SubscriptionInfo? get subscriptionInfo =>
      _instance?.getSubscriptionInfo();

  /// 获取订阅URL列表
  static List<SubscriptionUrlInfo> get subscriptionUrlList =>
      subscriptionInfo?.urls ?? [];

  /// 获取第一个订阅URL
  static String? get subscriptionUrl => subscriptionInfo?.firstUrl;

  /// 获取第一个支持加密的订阅URL
  static String? get encryptSubscriptionUrl =>
      subscriptionInfo?.firstEncryptUrl?.url;

  /// 构建订阅URL（带token）
  static String? buildSubscriptionUrl(
    String token, {
    bool preferEncrypt = true,
  }) {
    return subscriptionInfo?.buildSubscriptionUrl(
      token,
      forceEncrypt: preferEncrypt,
    );
  }

  /// 构建可用的订阅URL；实际订阅竞速由下载服务完成。
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
      final url = urlInfo.buildSubscriptionUrl(
        token,
        preferEncrypt: preferEncrypt,
      );
      if (url.isNotEmpty) {
        subscriptionUrls.add(url);
      }
    }

    if (subscriptionUrls.isEmpty) return null;

    return subscriptionUrls.first;
  }

  /// 获取所有面板URL列表
  static List<String> get allPanelUrls => panelList.map((e) => e.url).toList();

  /// 获取所有代理URL列表
  static List<String> get allProxyUrls => proxyList.map((e) => e.url).toList();

  /// 获取所有订阅URL列表
  static List<String> get allSubscriptionUrls =>
      subscriptionUrlList.map((e) => e.url).toList();

  /// 获取所有支持加密的订阅URL列表
  static List<String> get allEncryptSubscriptionUrls => subscriptionUrlList
      .where((e) => e.supportEncrypt)
      .map((e) => e.url)
      .toList();

  /// 刷新配置
  static Future<void> refresh() async {
    if (_usingPersistedConfig) return;
    if (!isInitialized) {
      await initialize();
    } else {
      await _accessor.refreshConfiguration();
      _lastRacingResult = null;
      await RacingResultCache.clear();
    }
  }

  /// 从指定源刷新配置
  static Future<void> refreshFromSource(String source) async {
    if (_usingPersistedConfig) return;
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
  static Stream<ConfigAccessorState> get stateChangeStream =>
      _accessor.stateStream;
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
