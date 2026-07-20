import 'package:board_sdk/flutter_xboard_sdk.dart';

/// 配置设置
///
/// 包含模块的各种配置参数
class ConfigSettings {
  final String currentProvider;
  final RemoteConfigSettings remoteConfig;
  final SubscriptionSettings subscription;
  final LogSettings log;
  final String appTitle;
  final String website;

  const ConfigSettings({
    this.currentProvider = 'Flclash',
    this.remoteConfig = const RemoteConfigSettings(),
    this.subscription = const SubscriptionSettings(),
    this.log = const LogSettings(),
    this.appTitle = 'ToWorld',
    this.website = '',
  });

  /// 从JSON创建配置
  factory ConfigSettings.fromJson(Map<String, dynamic> json) {
    return ConfigSettings(
      currentProvider: json['currentProvider'] as String? ?? 'Flclash',
      remoteConfig: RemoteConfigSettings(
        sources: (json['sources'] as List<dynamic>? ?? [])
            .map((e) => RemoteSourceConfig.fromJson(e as Map<String, dynamic>))
            .toList(),
        maxRetries: json['maxRetries'] as int? ?? 3,
        timeout: Duration(seconds: json['timeoutSeconds'] as int? ?? 10),
        retryDelay: Duration(seconds: json['retryDelaySeconds'] as int? ?? 2),
      ),
      subscription: SubscriptionSettings.fromJson(
          json['subscription'] as Map<String, dynamic>? ?? {}),
      log: LogSettings.fromJson(json['log'] as Map<String, dynamic>? ?? {}),
      website: json['website'] as String? ?? '',
      appTitle: json['appTitle'] as String? ?? 'ToWorld',
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'currentProvider': currentProvider,
      'sources': remoteConfig.sources.map((s) => s.toJson()).toList(),
      'maxRetries': remoteConfig.maxRetries,
      'timeoutSeconds': remoteConfig.timeout.inSeconds,
      'retryDelaySeconds': remoteConfig.retryDelay.inSeconds,
      'subscription': subscription.toJson(),
      'log': log.toJson(),
      'website': website,
      'appTitle': appTitle,
    };
  }

  /// 验证配置
  bool validate() {
    // 移除 provider 硬编码限制，允许使用任意 provider
    // 只要远程配置 JSON 中有对应的键名即可
    return remoteConfig.validate() && subscription.validate() && log.validate();
  }

  /// 获取验证错误
  List<String> getValidationErrors() {
    final errors = <String>[];

    // 移除 provider 硬编码限制
    // provider 仅作为 key 从远程配置的 panels 对象中选择数据

    errors.addAll(remoteConfig.getValidationErrors()); // 来自 RemoteConfigSettingsValidation 扩展
    errors.addAll(subscription.getValidationErrors());
    errors.addAll(log.getValidationErrors());

    return errors;
  }

  @override
  String toString() {
    return 'ConfigSettings(provider: $currentProvider, subscription: $subscription)';
  }
}

/// 远程设置验证扩展
extension RemoteConfigSettingsValidation on RemoteConfigSettings {
  bool validate() {
    return sources.isNotEmpty &&
        maxRetries > 0 &&
        timeout.inSeconds > 0 &&
        retryDelay.inSeconds >= 0;
  }

  List<String> getValidationErrors() {
    final errors = <String>[];
    if (sources.isEmpty) errors.add('Remote config sources cannot be empty');
    if (maxRetries <= 0) errors.add('Max retries must be greater than 0');
    if (timeout.inSeconds <= 0) errors.add('Timeout must be greater than 0');
    for (int i = 0; i < sources.length; i++) {
      final src = sources[i];
      if (src.name.isEmpty) errors.add('sources[$i]: Source name cannot be empty');
      if (src.url.isEmpty) {
        errors.add('sources[$i]: Source URL cannot be empty');
      } else {
        final uri = Uri.tryParse(src.url);
        if (uri == null || !uri.hasScheme || !uri.host.isNotEmpty) {
          errors.add('sources[$i]: Invalid URL format: ${src.url}');
        }
      }
    }
    return errors;
  }
}

/// 订阅设置
class SubscriptionSettings {
  final bool preferEncrypt;

  const SubscriptionSettings({
    this.preferEncrypt = false,
  });

  /// 是否启用竞速（自动跟随加密选项）
  bool get enableRace => preferEncrypt;

  factory SubscriptionSettings.fromJson(Map<String, dynamic> json) {
    return SubscriptionSettings(
      preferEncrypt: json['preferEncrypt'] as bool? ??
          json['prefer_encrypt'] as bool? ??
          false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferEncrypt': preferEncrypt,
    };
  }

  bool validate() {
    // 布尔值总是有效的
    return true;
  }

  List<String> getValidationErrors() {
    // 没有验证错误
    return [];
  }

  @override
  String toString() {
    return 'SubscriptionSettings(preferEncrypt: $preferEncrypt, enableRace: $enableRace)';
  }
}

/// 日志设置
class LogSettings {
  final bool enabled;
  final String level;
  final String prefix;

  const LogSettings({
    this.enabled = true,
    this.level = 'info',
    this.prefix = '[XBoardConfig]',
  });

  factory LogSettings.fromJson(Map<String, dynamic> json) {
    return LogSettings(
      enabled: json['enabled'] as bool? ?? true,
      level: json['level'] as String? ?? 'info',
      prefix: json['prefix'] as String? ?? '[XBoardConfig]',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'level': level,
      'prefix': prefix,
    };
  }

  bool validate() {
    const validLevels = ['debug', 'info', 'warning', 'error'];
    return validLevels.contains(level.toLowerCase()) && prefix.isNotEmpty;
  }

  List<String> getValidationErrors() {
    final errors = <String>[];

    const validLevels = ['debug', 'info', 'warning', 'error'];
    if (!validLevels.contains(level.toLowerCase())) {
      errors.add('Invalid log level: $level');
    }

    if (prefix.isEmpty) {
      errors.add('Log prefix cannot be empty');
    }

    return errors;
  }
}
