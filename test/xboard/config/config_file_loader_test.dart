import 'dart:convert';

import 'package:fl_clash/xboard/config/core/config_settings.dart';
import 'package:fl_clash/xboard/config/utils/config_file_loader.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// The panel document, in the shape the shipped
/// `assets/config/xboard.config.yaml` has, plus the optional blocks the loader
/// knows how to read. Stubbed over the asset channel rather than bundled: these
/// tests are about how the loader reacts to a document, not about what today's
/// document happens to say.
const _document = '''
xboard:
  provider: "go2world"
  remote_config:
    sources:
      - name: redirect
        priority: 100
        url: https://dwc.example.com/gdc_conf/go2world_client.gdjson
        auth:
          type: TypeA
      - name: mirror
        url: https://mirror.example.com/config
        timeout_seconds: 8
        encryption_key: secret
        headers:
          X-Trace: on
        auth:
          type: TypeD
          pkey: pinned
    max_retries: 5
    timeout_seconds: 12
    retry_delay_seconds: 3
  app:
    title: 达世界
    website: https://toworld.uk
  subscription:
    prefer_encrypt: false
    decrypt_key: your_secret_decrypt_key_here
  latency_test:
    test_url: http://example.com/generate_204
  log:
    enabled: false
    level: debug
    prefix: '[T]'
  sdk:
    timeout: 5
  security:
    obfuscation_prefix: YOUR_OBFS_PREFIX_
    user_agents:
      api_encrypted: Mozilla/5.0
''';

void main() {
  // rootBundle, for the asset channel below.
  TestWidgetsFlutterBinding.ensureInitialized();

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  /// Serves [yaml] as the panel config asset; `null` makes the asset missing.
  void stubAsset(String? yaml) {
    // loadString caches per key, so a stubbed document would otherwise leak
    // into the next test.
    rootBundle.evict(ConfigFileLoader.configPath);
    messenger.setMockMessageHandler('flutter/assets', (message) async {
      // The asset channel carries the key as raw UTF-8, not as a codec frame.
      final key = utf8.decode(message!.buffer.asUint8List());
      if (yaml == null || key != ConfigFileLoader.configPath) {
        return null;
      }
      return ByteData.sublistView(Uint8List.fromList(utf8.encode(yaml)));
    });
    addTearDown(() {
      messenger.setMockMessageHandler('flutter/assets', null);
      rootBundle.evict(ConfigFileLoader.configPath);
    });
  }

  group('loadFromFile', () {
    test('reads every block of the panel document', () async {
      stubAsset(_document);

      final settings = await ConfigFileLoader.loadFromFile();

      expect(settings.currentProvider, 'go2world');
      expect(settings.appTitle, '达世界');
      expect(settings.website, 'https://toworld.uk');
      expect(settings.subscription.preferEncrypt, isFalse);
      expect(settings.log.enabled, isFalse);
      expect(settings.log.level, 'debug');
      expect(settings.log.prefix, '[T]');
      expect(settings.remoteConfig.maxRetries, 5);
      expect(settings.remoteConfig.timeout, const Duration(seconds: 12));
      expect(settings.remoteConfig.retryDelay, const Duration(seconds: 3));
      expect(settings.validate(), isTrue);
    });

    test('a source without a pkey inherits the provider', () async {
      stubAsset(_document);

      final sources =
          (await ConfigFileLoader.loadFromFile()).remoteConfig.sources;

      expect(sources, hasLength(2));
      final redirect = sources.first;
      expect(redirect.name, 'redirect');
      expect(
        redirect.url,
        'https://dwc.example.com/gdc_conf/go2world_client.gdjson',
      );
      expect(redirect.auth?.type, 'TypeA');
      expect(redirect.auth?.pkey, 'go2world');
      expect(redirect.timeout, isNull);
      expect(redirect.headers, isNull);
      expect(redirect.encryptionKey, isNull);
    });

    test('a pinned pkey and the optional source fields survive', () async {
      stubAsset(_document);

      final mirror =
          (await ConfigFileLoader.loadFromFile()).remoteConfig.sources.last;

      expect(mirror.auth?.pkey, 'pinned');
      expect(mirror.auth?.type, 'TypeD');
      expect(mirror.timeout, const Duration(seconds: 8));
      expect(mirror.encryptionKey, 'secret');
      expect(mirror.headers, {'X-Trace': 'on'});
    });

    test('a missing document falls back to the defaults', () async {
      stubAsset(null);

      final settings = await ConfigFileLoader.loadFromFile();

      expect(settings.currentProvider, 'Flclash');
      expect(settings.appTitle, 'ToWorld');
      expect(settings.website, '');
      expect(settings.remoteConfig.sources, isEmpty);
      expect(settings.subscription.preferEncrypt, isFalse);
      expect(settings.log.level, 'info');
      expect(settings.log.prefix, '[XBoardConfig]');
    });

    test(
      'a document with no xboard block falls back to the defaults',
      () async {
        stubAsset('other:\n  enabled: true\n');

        final settings = await ConfigFileLoader.loadFromFile();

        expect(settings.currentProvider, 'Flclash');
        expect(settings.appTitle, 'ToWorld');
        expect(settings.remoteConfig.sources, isEmpty);
      },
    );

    test('malformed YAML falls back to the defaults', () async {
      stubAsset('xboard: [unclosed\n');

      final settings = await ConfigFileLoader.loadFromFile();

      expect(settings.currentProvider, 'Flclash');
      expect(settings.remoteConfig.sources, isEmpty);
    });
  });

  group('loadExtendedConfig', () {
    test('returns the xboard block', () async {
      stubAsset(_document);

      final extended = await ConfigFileLoader.loadExtendedConfig();

      expect(extended['provider'], 'go2world');
      expect(extended['sdk'], {'timeout': 5});
    });

    test('returns an empty map when the document is missing', () async {
      stubAsset(null);

      expect(await ConfigFileLoader.loadExtendedConfig(), isEmpty);
    });
  });

  group('ConfigFileLoaderHelper', () {
    setUp(() => stubAsset(_document));

    test('subscription settings drive the encryption options', () async {
      final settings = await ConfigFileLoaderHelper.getSubscriptionSettings();
      expect(settings.preferEncrypt, isFalse);
      expect(await ConfigFileLoaderHelper.getPreferEncrypt(), isFalse);
      expect(await ConfigFileLoaderHelper.getEnableRace(), isFalse);
      expect(
        await ConfigFileLoaderHelper.getDecryptKey(),
        'your_secret_decrypt_key_here',
      );
    });

    test('the latency probe reads its own block', () async {
      expect(
        await ConfigFileLoaderHelper.getLatencyTestUrl(),
        'http://example.com/generate_204',
      );
    });

    test('the raw blocks are handed back as maps', () async {
      expect(await ConfigFileLoaderHelper.getSdkConfig(), {'timeout': 5});
      expect(
        await ConfigFileLoaderHelper.getAppConfig(),
        containsPair('website', 'https://toworld.uk'),
      );
      expect(
        await ConfigFileLoaderHelper.getSecurityConfig(),
        containsPair('obfuscation_prefix', 'YOUR_OBFS_PREFIX_'),
      );
    });

    test('the user agents are flattened to strings', () async {
      expect(await ConfigFileLoaderHelper.getUserAgents(), {
        'api_encrypted': 'Mozilla/5.0',
      });
    });

    test('the title and website come from the app block', () async {
      expect(await ConfigFileLoaderHelper.getAppTitle(), '达世界');
      expect(
        await ConfigFileLoaderHelper.getAppWebsite(),
        'https://toworld.uk',
      );
    });

    test('the obfuscation prefix is the configured one', () async {
      expect(
        await ConfigFileLoaderHelper.getObfuscationPrefix(),
        'YOUR_OBFS_PREFIX_',
      );
    });

    test('the certificate is pinned to the bundled one', () async {
      expect(await ConfigFileLoaderHelper.getCertificateConfig(), {
        'path': 'assets/cer/client-cert.crt',
        'enabled': true,
      });
    });
  });

  group('ConfigFileLoaderHelper without a document', () {
    setUp(() => stubAsset(null));

    test('every getter answers with its fallback', () async {
      expect(
        (await ConfigFileLoaderHelper.getSubscriptionSettings()).preferEncrypt,
        isFalse,
      );
      expect(await ConfigFileLoaderHelper.getPreferEncrypt(), isFalse);
      expect(
        await ConfigFileLoaderHelper.getLatencyTestUrl(),
        'http://www.gstatic.com/generate_204',
      );
      expect(await ConfigFileLoaderHelper.getSdkConfig(), isEmpty);
      expect(await ConfigFileLoaderHelper.getDecryptKey(), '');
      expect(await ConfigFileLoaderHelper.getUserAgents(), isEmpty);
      expect(await ConfigFileLoaderHelper.getAppTitle(), 'XBoard');
      expect(await ConfigFileLoaderHelper.getAppWebsite(), 'example.com');
      expect(await ConfigFileLoaderHelper.getObfuscationPrefix(), isNull);
    });
  });

  group('ConfigFileLoaderHelper with an empty panel block', () {
    setUp(
      () => stubAsset('xboard:\n  security:\n    obfuscation_prefix: ""\n'),
    );

    test('an empty prefix is treated as unset', () async {
      expect(await ConfigFileLoaderHelper.getObfuscationPrefix(), isNull);
    });

    test('missing blocks still answer', () async {
      expect(await ConfigFileLoaderHelper.getAppTitle(), 'XBoard');
      expect(
        await ConfigFileLoaderHelper.getLatencyTestUrl(),
        'http://www.gstatic.com/generate_204',
      );
      expect(await ConfigFileLoaderHelper.getUserAgents(), isEmpty);
    });
  });

  test('a config settings round trip keeps the panel document', () async {
    stubAsset(_document);

    final settings = await ConfigFileLoader.loadFromFile();
    final restored = ConfigSettings.fromJson(settings.toJson());

    expect(restored.currentProvider, settings.currentProvider);
    expect(restored.appTitle, settings.appTitle);
    expect(restored.subscription.preferEncrypt, isFalse);
    expect(
      restored.remoteConfig.sources
          .singleWhere((s) => s.name == 'redirect')
          .url,
      settings.remoteConfig.sources.first.url,
    );
  });
}
