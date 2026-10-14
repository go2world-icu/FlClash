import 'package:fl_clash/xboard/config/core/config_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConfigSettings', () {
    test('defaults are sensible', () {
      const settings = ConfigSettings();
      expect(settings.currentProvider, 'Flclash');
      expect(settings.appTitle, 'ToWorld');
      expect(settings.website, '');
      expect(settings.remoteConfig.sources, isEmpty);
      expect(settings.subscription.preferEncrypt, isFalse);
      expect(settings.log.enabled, isTrue);
      expect(settings.log.level, 'info');
    });

    test('fromJson parses nested settings', () {
      final settings = ConfigSettings.fromJson(const {
        'currentProvider': 'Other',
        'appTitle': 'MyApp',
        'website': 'example.com',
        'maxRetries': 5,
        'timeoutSeconds': 30,
        'retryDelaySeconds': 4,
        'sources': [
          {'name': 'redirect', 'url': 'https://r'},
        ],
        'subscription': {'preferEncrypt': true},
        'log': {'enabled': false, 'level': 'debug', 'prefix': '[X]'},
      });
      expect(settings.currentProvider, 'Other');
      expect(settings.appTitle, 'MyApp');
      expect(settings.website, 'example.com');
      expect(settings.remoteConfig.maxRetries, 5);
      expect(settings.remoteConfig.timeout, const Duration(seconds: 30));
      expect(settings.remoteConfig.retryDelay, const Duration(seconds: 4));
      expect(settings.remoteConfig.sources.single.name, 'redirect');
      expect(settings.subscription.preferEncrypt, isTrue);
      expect(settings.log.enabled, isFalse);
      expect(settings.log.level, 'debug');
    });

    test('fromJson falls back to defaults for missing fields', () {
      final settings = ConfigSettings.fromJson(const {});
      expect(settings.currentProvider, 'Flclash');
      expect(settings.appTitle, 'ToWorld');
      expect(settings.remoteConfig.maxRetries, 3);
      expect(settings.remoteConfig.timeout, const Duration(seconds: 10));
    });

    test('round-trips through json', () {
      final settings = ConfigSettings.fromJson(const {
        'currentProvider': 'P',
        'appTitle': 'A',
        'website': 'w',
        'sources': [
          {'name': 'redirect', 'url': 'https://r'},
        ],
        'subscription': {'preferEncrypt': true},
        'log': {'enabled': true, 'level': 'warning', 'prefix': '[A]'},
      });
      final json = settings.toJson();
      expect(json['currentProvider'], 'P');
      expect(json['appTitle'], 'A');
      expect(json['timeoutSeconds'], 10);
      expect((json['sources'] as List).length, 1);
      expect((json['subscription'] as Map)['preferEncrypt'], isTrue);
      expect((json['log'] as Map)['level'], 'warning');
      expect(settings.toString(), contains('provider: P'));
    });

    test('validate fails with empty sources', () {
      const settings = ConfigSettings();
      expect(settings.validate(), isFalse);
      expect(
        settings.getValidationErrors(),
        contains('Remote config sources cannot be empty'),
      );
    });

    test('validate passes with a well formed source', () {
      const settings = ConfigSettings(
        remoteConfig: RemoteConfigSettings(
          sources: [
            RemoteSourceConfig(name: 'redirect', url: 'https://r'),
          ],
        ),
      );
      expect(settings.validate(), isTrue);
      expect(settings.getValidationErrors(), isEmpty);
    });
  });

  group('RemoteConfigSettingsValidation', () {
    test('flags bad retries and timeout', () {
      const settings = RemoteConfigSettings(maxRetries: 0, timeout: Duration.zero);
      final errors = settings.getValidationErrors();
      expect(errors, contains('Max retries must be greater than 0'));
      expect(errors, contains('Timeout must be greater than 0'));
    });

    test('flags source without name or with malformed url', () {
      const settings = RemoteConfigSettings(
        sources: [
          RemoteSourceConfig(name: '', url: 'not-a-url'),
        ],
      );
      final errors = settings.getValidationErrors();
      expect(errors, contains('sources[0]: Source name cannot be empty'));
      expect(errors, contains('sources[0]: Invalid URL format: not-a-url'));
    });

    test('flags source with empty url', () {
      const settings = RemoteConfigSettings(
        sources: [
          RemoteSourceConfig(name: 'base', url: ''),
        ],
      );
      expect(
        settings.getValidationErrors(),
        contains('sources[0]: Source URL cannot be empty'),
      );
    });
  });

  group('SubscriptionSettings', () {
    test('fromJson reads snake and camel case keys', () {
      expect(
        SubscriptionSettings.fromJson(const {'preferEncrypt': true}).preferEncrypt,
        isTrue,
      );
      expect(
        SubscriptionSettings.fromJson(const {'prefer_encrypt': true}).preferEncrypt,
        isTrue,
      );
      expect(SubscriptionSettings.fromJson(const {}).preferEncrypt, isFalse);
    });

    test('enableRace mirrors preferEncrypt', () {
      expect(const SubscriptionSettings(preferEncrypt: true).enableRace, isTrue);
      expect(const SubscriptionSettings().enableRace, isFalse);
    });

    test('is always valid and serializes', () {
      const settings = SubscriptionSettings(preferEncrypt: true);
      expect(settings.validate(), isTrue);
      expect(settings.getValidationErrors(), isEmpty);
      expect(settings.toJson(), {'preferEncrypt': true});
      expect(settings.toString(), contains('preferEncrypt: true'));
    });
  });

  group('LogSettings', () {
    test('defaults', () {
      const settings = LogSettings();
      expect(settings.enabled, isTrue);
      expect(settings.level, 'info');
      expect(settings.prefix, '[XBoardConfig]');
      expect(settings.validate(), isTrue);
    });

    test('rejects an unknown level', () {
      const settings = LogSettings(level: 'verbose');
      expect(settings.validate(), isFalse);
      expect(settings.getValidationErrors(), contains('Invalid log level: verbose'));
    });

    test('accepts levels case-insensitively', () {
      expect(const LogSettings(level: 'DEBUG').validate(), isTrue);
    });

    test('rejects an empty prefix', () {
      const settings = LogSettings(prefix: '');
      expect(settings.validate(), isFalse);
      expect(settings.getValidationErrors(), contains('Log prefix cannot be empty'));
    });

    test('fromJson and toJson round-trip', () {
      final settings = LogSettings.fromJson(const {
        'enabled': false,
        'level': 'error',
        'prefix': '[P]',
      });
      expect(settings.toJson(), {'enabled': false, 'level': 'error', 'prefix': '[P]'});
    });
  });
}
