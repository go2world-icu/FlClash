import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'service_locator.dart';
import 'config_settings.dart';
import '../parsers/configuration_parser.dart';
import '../internal/xboard_config_accessor.dart';
import '../services/online_support_service.dart';
import '../../core/core.dart';

// 初始化文件级日志器
final _logger = FileLogger('module_initializer.dart');

/// 模块初始化器（内部类）
/// 
/// 负责初始化所有模块和依赖注入
/// 注意：这个类不应该被外部直接使用，请使用XBoardConfig
class ModuleInitializer {
  static bool _isInitialized = false;

  /// 初始化模块
  static Future<void> initialize({ConfigSettings? settings}) async {
    if (_isInitialized) {
      _logger.warning('Module already initialized');
      return;
    }

    final config = settings ?? const ConfigSettings();
    
    try {
      // 验证配置
      if (!config.validate()) {
        final errors = config.getValidationErrors();
        throw Exception('Invalid configuration: ${errors.join(', ')}');
      }

      // 配置日志（以 currentProvider 作为加密密钥）
      await _configureLogger(config.log, config.currentProvider);

      _logger.info('Initializing XBoard Config Module V2');
      _logger.info('Current provider: ${config.currentProvider}');

      // 注册服务
      await _registerServices(config);

      // 标记为已初始化
      ServiceLocator.markInitialized();
      _isInitialized = true;

      _logger.info('Module initialization completed');
    } catch (e) {
      _logger.error('Module initialization failed', e);
      rethrow;
    }
  }

  /// 重置模块
  static void reset() {
    _logger.info('Resetting module');
    ServiceLocator.reset();
    _isInitialized = false;
  }

  /// 检查是否已初始化
  static bool get isInitialized => _isInitialized;

  /// 获取初始化状态
  static Map<String, dynamic> getInitializationStatus() {
    return {
      'initialized': _isInitialized,
      'serviceLocator': ServiceLocator.getStats(),
    };
  }

  /// 配置日志
  static Future<void> _configureLogger(LogSettings logSettings, [String provider = 'xboard_default_key']) async {
    if (!logSettings.enabled) {
      _logger.debug('Logger 已禁用，仅保留控制台输出');
      XBoardLogger.reset();
      return;
    }

    final level = _parseLogLevel(logSettings.level);

    await XBoardLogger.configure(
      LoggerConfig(
        minLevel: level,
        enableConsole: true,
        enableFile: true,
        encryptionKey: provider,
        consoleColors: true,
      ),
    );

    _logger.info(
      'Logger 初始化完成  |  级别: ${logSettings.level}  '
      '|  加密文件: 已启用  |  保留期限: 1 天',
    );
  }

  /// 将字符串日志级别转为 LogLevel 枚举
  static LogLevel _parseLogLevel(String level) {
    return switch (level.toLowerCase()) {
      'debug' => LogLevel.debug,
      'info' => LogLevel.info,
      'warning' => LogLevel.warning,
      'error' => LogLevel.error,
      _ => LogLevel.info,
    };
  }

  /// 注册服务
  static Future<void> _registerServices(ConfigSettings config) async {
    _logger.debug('Registering services');

    // 注册配置设置
    ServiceLocator.registerSingleton<ConfigSettings>(config);

    // 注册远程配置管理器
    ServiceLocator.registerLazySingleton<RemoteConfigManager>(() {
      _logger.info('Creating RemoteConfigManager with ${config.remoteConfig.sources.length} sources');
      return RemoteConfigManager.fromSettings(config.remoteConfig, website: config.website);
    });

    // 本地配置功能已移除，只使用远程数据

    // 缓存功能已移除，使用实时数据

    // 注册配置解析器
    ServiceLocator.registerLazySingleton<ConfigurationParser>(() {
      return ConfigurationParser();
    });

    // 注册配置访问器
    ServiceLocator.registerLazySingleton<XBoardConfigAccessor>(() {
      return XBoardConfigAccessor(
        remoteManager: ServiceLocator.get<RemoteConfigManager>(),
        parser: ServiceLocator.get<ConfigurationParser>(),
        currentProvider: config.currentProvider,
        appTitle: config.appTitle,
        appWebsite: config.website,
        logSettings: config.log,
      );
    });

    // 注册在线客服服务
    ServiceLocator.registerLazySingleton<OnlineSupportService>(() {
      try {
        final accessor = ServiceLocator.get<XBoardConfigAccessor>();
        final configs = accessor.getOnlineSupportConfigs();
        return OnlineSupportService(configs);
      } catch (e) {
        _logger.warning('Failed to initialize OnlineSupportService, using empty config', e);
        return OnlineSupportService([]);
      }
    });

    _logger.debug('Services registered successfully');
  }

  /// 预热服务
  static Future<void> warmUp() async {
    if (!_isInitialized) {
      throw StateError('Module not initialized');
    }

    _logger.info('Warming up services');

    try {
      // 预热配置访问器
      final accessor = ServiceLocator.get<XBoardConfigAccessor>();
      await accessor.refreshConfiguration();

      _logger.info('Services warmed up successfully');
    } catch (e) {
      _logger.warning('Service warm-up failed', e);
      // 不抛出异常，允许模块继续工作
    }
  }

  /// 创建配置访问器实例
  static Future<XBoardConfigAccessor> createConfigAccessor({
    ConfigSettings? settings,
    bool autoWarmUp = true,
  }) async {
    await initialize(settings: settings);
    
    final accessor = ServiceLocator.get<XBoardConfigAccessor>();
    
    if (autoWarmUp) {
      await accessor.refreshConfiguration();
    }
    
    return accessor;
  }
}