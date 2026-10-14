import 'package:fl_clash/xboard/config/models/config_entry.dart';
import 'package:fl_clash/xboard/config/models/online_support_info.dart';
import 'package:fl_clash/xboard/config/models/panel_configuration.dart';
import 'package:fl_clash/xboard/config/models/parsed_configuration.dart';
import 'package:fl_clash/xboard/config/models/proxy_info.dart';
import 'package:fl_clash/xboard/config/models/subscription_info.dart';
import 'package:fl_clash/xboard/config/models/update_info.dart';
import 'package:fl_clash/xboard/config/models/websocket_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConfigEntry', () {
    test('reads url and description with defaults', () {
      final entry = ConfigEntry.fromJson(const {'url': 'https://a.com'});
      expect(entry.url, 'https://a.com');
      expect(entry.description, '');
      expect(entry.metadata, isNull);
    });

    test('round-trips to json including metadata', () {
      final entry = ConfigEntry.fromJson(const {
        'url': 'https://a.com',
        'description': 'desc',
        'metadata': {'k': 1},
      });
      expect(entry.toJson(), {
        'url': 'https://a.com',
        'description': 'desc',
        'metadata': {'k': 1},
      });
      expect(entry.toString(), 'ConfigEntry(url: https://a.com, description: desc)');
    });

    test('equality is based on url and description', () {
      const a = ConfigEntry(url: 'u', description: 'd');
      const b = ConfigEntry(url: 'u', description: 'd');
      const c = ConfigEntry(url: 'u', description: 'other');
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
    });
  });

  group('ProxyInfo', () {
    test('fromJson applies defaults', () {
      final proxy = ProxyInfo.fromJson(const {'url': 'http://p'});
      expect(proxy.protocol, 'http');
      expect(proxy.port, isNull);
      expect(proxy.username, isNull);
    });

    test('fromJson parses all fields and round-trips', () {
      final proxy = ProxyInfo.fromJson(const {
        'url': 'socks5://h:1080',
        'description': 'd',
        'protocol': 'socks5',
        'username': 'user',
        'password': 'pass',
        'host': 'h',
        'port': 1080,
        'region': 'HK',
        'metadata': {'x': 'y'},
      });
      expect(proxy.region, 'HK');
      expect(proxy.toJson(), {
        'url': 'socks5://h:1080',
        'description': 'd',
        'metadata': {'x': 'y'},
        'protocol': 'socks5',
        'username': 'user',
        'password': 'pass',
        'host': 'h',
        'port': 1080,
        'region': 'HK',
      });
      expect(proxy.toString(), 'ProxyInfo(url: socks5://h:1080, protocol: socks5, host: h, port: 1080)');
    });

    test('fromUrl parses credentials and port', () {
      final proxy = ProxyInfo.fromUrl('http://user:pass@example.com:8080', 'd');
      expect(proxy.protocol, 'http');
      expect(proxy.username, 'user');
      expect(proxy.password, 'pass');
      expect(proxy.host, 'example.com');
      expect(proxy.port, 8080);
    });

    test('fromUrl keeps info when no scheme is present', () {
      final proxy = ProxyInfo.fromUrl('example.com:3128', 'd');
      expect(proxy.protocol, 'http');
      expect(proxy.host, 'example.com');
      expect(proxy.port, 3128);
    });

    test('omits optional fields from json when absent', () {
      const proxy = ProxyInfo(url: 'u', description: 'd', protocol: 'http');
      expect(proxy.toJson(), {'url': 'u', 'description': 'd', 'protocol': 'http'});
    });
  });

  group('WebSocketInfo', () {
    test('fromJson defaults supportsPing to true', () {
      final ws = WebSocketInfo.fromJson(const {'url': 'wss://a'});
      expect(ws.supportsPing, isTrue);
      expect(ws.timeout, isNull);
    });

    test('parses headers, timeout and derived getters', () {
      final ws = WebSocketInfo.fromJson(const {
        'url': 'wss://a/b',
        'headers': {'X': '1'},
        'timeout': 1500,
        'region': 'US',
        'supportsPing': false,
      });
      expect(ws.headers, {'X': '1'});
      expect(ws.timeout, const Duration(milliseconds: 1500));
      expect(ws.isSecure, isTrue);
      expect(ws.protocol, 'wss');
      expect(ws.toJson()['timeout'], 1500);
      expect(ws.toJson()['supportsPing'], isFalse);
      expect(ws.toString(), contains('protocol: wss'));
    });

    test('reports insecure protocol for ws url', () {
      final ws = WebSocketInfo.fromJson(const {'url': 'ws://a'});
      expect(ws.isSecure, isFalse);
      expect(ws.protocol, 'ws');
    });
  });

  group('UpdateInfo', () {
    test('formats file sizes across units', () {
      expect(const UpdateInfo(url: 'u', description: 'd').fileSizeFormatted, 'Unknown');
      expect(
        const UpdateInfo(url: 'u', description: 'd', fileSize: 512).fileSizeFormatted,
        '512.0 B',
      );
      expect(
        const UpdateInfo(url: 'u', description: 'd', fileSize: 2048).fileSizeFormatted,
        '2.0 KB',
      );
      expect(
        const UpdateInfo(
          url: 'u',
          description: 'd',
          fileSize: 3 * 1024 * 1024,
        ).fileSizeFormatted,
        '3.0 MB',
      );
    });

    test('isSecure depends on https scheme', () {
      expect(const UpdateInfo(url: 'https://u', description: 'd').isSecure, isTrue);
      expect(const UpdateInfo(url: 'http://u', description: 'd').isSecure, isFalse);
    });

    test('fromJson and toJson preserve optional fields', () {
      final update = UpdateInfo.fromJson(const {
        'url': 'https://u',
        'description': 'd',
        'version': '1.2.3',
        'checksum': 'abc',
        'region': 'CN',
        'fileSize': 10,
      });
      expect(update.version, '1.2.3');
      expect(update.toJson(), {
        'url': 'https://u',
        'description': 'd',
        'version': '1.2.3',
        'checksum': 'abc',
        'region': 'CN',
        'fileSize': 10,
      });
    });
  });

  group('OnlineSupportInfo', () {
    test('validate succeeds for valid http/ws urls', () {
      const info = OnlineSupportInfo(
        url: 'u',
        description: 'd',
        apiBaseUrl: 'https://api.example.com',
        wsBaseUrl: 'wss://ws.example.com',
      );
      expect(info.validate(), isTrue);
      expect(info.getValidationErrors(), isEmpty);
      expect(info.toJson()['apiBaseUrl'], 'https://api.example.com');
    });

    test('reports each empty or malformed url', () {
      const info = OnlineSupportInfo(
        url: 'u',
        description: 'd',
        apiBaseUrl: '',
        wsBaseUrl: 'http://not-ws',
      );
      expect(info.validate(), isFalse);
      final errors = info.getValidationErrors();
      expect(errors, contains('API base URL cannot be empty'));
      expect(
        errors,
        contains('WebSocket base URL must use ws or wss protocol: http://not-ws'),
      );
    });

    test('reports http scheme violations explicitly', () {
      const info = OnlineSupportInfo(
        url: 'u',
        description: 'd',
        apiBaseUrl: 'ftp://api.example.com',
        wsBaseUrl: 'ws://ws.example.com',
      );
      expect(
        info.getValidationErrors(),
        contains('API base URL must use http or https protocol: ftp://api.example.com'),
      );
    });
  });

  group('PanelConfiguration', () {
    final panels = PanelConfiguration.fromJson(const {
      'Flclash': [
        {'url': 'https://a.com', 'description': 'a'},
        {'url': 'https://b.com', 'description': 'b'},
      ],
      'Other': [
        {'url': 'https://c.com', 'description': 'c'},
      ],
      'bad': 'not-a-list',
    }, 'Flclash');

    test('selects the current provider panels', () {
      expect(panels.currentProviderPanels.length, 2);
      expect(panels.firstUrl, 'https://a.com');
      expect(panels.currentProvider, 'Flclash');
      expect(panels.currentProviderUrls, ['https://a.com', 'https://b.com']);
    });

    test('skips non-list providers and exposes the rest', () {
      expect(panels.availableProviders, containsAll(['Flclash', 'Other']));
      expect(panels.getByProvider('missing'), isEmpty);
      expect(panels.getAll().length, 3);
    });

    test('returns null first url for unknown provider', () {
      final other = PanelConfiguration.fromJson(const {}, 'Flclash');
      expect(other.firstUrl, isNull);
    });

    test('getFastestUrl returns the only url without racing', () async {
      final single = PanelConfiguration.fromJson(const {
        'Flclash': [
          {'url': 'https://only.com', 'description': 'a'},
        ],
      }, 'Flclash');
      expect(await single.getFastestUrl(), 'https://only.com');
    });

    test('getFastestUrl returns null for empty panels', () async {
      final empty = PanelConfiguration.fromJson(const {}, 'Flclash');
      expect(await empty.getFastestUrl(), isNull);
    });

    test('toJson serializes providers', () {
      final json = panels.toJson();
      expect((json['Flclash'] as List).length, 2);
      expect(json['Flclash'][0], {'url': 'https://a.com', 'description': 'a'});
      expect(panels.toString(), contains('currentProvider: Flclash'));
    });
  });

  group('SubscriptionUrlInfo', () {
    test('fromJson parses endpoints', () {
      final info = SubscriptionUrlInfo.fromJson(const {
        'url': 'https://sub.com',
        'description': 'sub',
        'supportEncrypt': true,
        'endpoints': {
          'v1': {'path': '/api/v1/{token}', 'requiresToken': true, 'method': 'GET'},
          'v2': {
            'path': '/api/v2/encrypt/{token}',
            'method': 'GET',
            'isEncrypt': true,
          },
        },
      });
      expect(info.endpoints.length, 2);
      expect(info.supportEncrypt, isTrue);
      expect(info.encryptEndpoint!.isEncrypt, isTrue);
      expect(info.normalEndpoint!.isEncrypt, isFalse);
      expect(info.preferredEndpoint!.isEncrypt, isTrue);
    });

    test('falls back to v1/v2 keys when flags are missing', () {
      final info = SubscriptionUrlInfo.fromJson(const {
        'url': 'https://sub.com',
        'endpoints': {
          'v1': {'path': '/v1/{token}'},
          'v2': {'path': '/v2/{token}'},
        },
      });
      expect(info.encryptEndpoint!.path, '/v2/{token}');
      expect(info.normalEndpoint!.path, '/v1/{token}');
    });

    test('endpoint getters return null when there are no endpoints', () {
      final info = SubscriptionUrlInfo.fromJson(const {'url': 'https://sub.com'});
      expect(info.encryptEndpoint, isNull);
      expect(info.normalEndpoint, isNull);
      expect(info.preferredEndpoint, isNull);
    });

    test('buildSubscriptionUrl replaces token and adds flag', () {
      final info = SubscriptionUrlInfo.fromJson(const {
        'url': 'https://sub.com',
        'endpoints': {
          'v2': {'path': 'api/v2/{token}', 'isEncrypt': true},
        },
      });
      expect(
        info.buildSubscriptionUrl('abc'),
        'https://sub.com/api/v2/abc?flag=flclash',
      );
    });

    test('buildSubscriptionUrl keeps slash handling consistent', () {
      final info = SubscriptionUrlInfo.fromJson(const {
        'url': 'https://sub.com/',
        'endpoints': {
          'v2': {'path': '/api/v2/{token}', 'isEncrypt': true},
        },
      });
      expect(
        info.buildSubscriptionUrl('abc'),
        'https://sub.com/api/v2/abc?flag=flclash',
      );
    });

    test('buildSubscriptionUrl returns raw url without endpoints', () {
      final info = SubscriptionUrlInfo.fromJson(const {'url': 'https://sub.com'});
      expect(info.buildSubscriptionUrl('abc'), 'https://sub.com');
    });

    test('toJson includes endpoints and supportEncrypt', () {
      final info = SubscriptionUrlInfo.fromJson(const {
        'url': 'https://sub.com',
        'supportEncrypt': true,
        'endpoints': {
          'v1': {'path': '/v1'},
        },
      });
      final json = info.toJson();
      expect(json['supportEncrypt'], isTrue);
      expect((json['endpoints'] as Map)['v1'], {
        'path': '/v1',
        'requiresToken': false,
        'method': 'GET',
        'description': '',
        'isEncrypt': false,
      });
      expect(info.toString(), contains('encrypt: true'));
    });
  });

  group('SubscriptionInfo', () {
    test('fromJson parses urls and defaults', () {
      final info = SubscriptionInfo.fromJson(const {
        'urls': [
          {'url': 'https://a', 'supportEncrypt': true},
          {'url': 'https://b'},
        ],
      });
      expect(info.urls.length, 2);
      expect(info.enableEncrypt, isTrue);
      expect(info.preferredEncryptVersion, 'v2');
      expect(info.firstUrl, 'https://a');
      expect(info.firstEncryptUrl!.url, 'https://a');
      expect(info.encryptUrls.length, 1);
    });

    test('firstEncryptUrl falls back to first url', () {
      final info = SubscriptionInfo.fromJson(const {
        'urls': [{'url': 'https://a'}],
      });
      expect(info.firstEncryptUrl!.url, 'https://a');
    });

    test('firstUrl is null with no urls', () {
      final info = SubscriptionInfo.fromJson(const {});
      expect(info.firstUrl, isNull);
      expect(info.firstEncryptUrl, isNull);
      expect(info.buildSubscriptionUrl('t'), isNull);
    });

    test('buildSubscriptionUrl prefers the encrypt-flagged url', () {
      final info = SubscriptionInfo.fromJson(const {
        'urls': [
          {'url': 'https://plain', 'endpoints': {'v1': {'path': 'a/{token}'}}},
          {
            'url': 'https://secure',
            'supportEncrypt': true,
            'endpoints': {
              'v2': {'path': 'b/{token}', 'isEncrypt': true},
            },
          },
        ],
      });
      expect(
        info.buildSubscriptionUrl('tok'),
        'https://secure/b/tok?flag=flclash',
      );
    });

    test('buildSubscriptionUrl falls back to first url non-encrypt', () {
      final info = SubscriptionInfo.fromJson(const {
        'urls': [
          {'url': 'https://plain', 'endpoints': {'v1': {'path': 'a/{token}'}}},
        ],
        'enableEncrypt': false,
      });
      expect(info.buildSubscriptionUrl('tok'), 'https://plain/a/tok?flag=flclash');
    });

    test('toJson round-trips', () {
      final info = SubscriptionInfo.fromJson(const {
        'urls': [
          {'url': 'https://a'},
        ],
      });
      final json = info.toJson();
      expect(json['enableEncrypt'], isTrue);
      expect((json['urls'] as List).length, 1);
      expect(info.toString(), contains('urls: 1'));
    });
  });

  group('ParsedConfiguration', () {
    final json = {
      'panelType': 'xboard',
      'panels': {
        'Flclash': [
          {'url': 'https://panel.com', 'description': 'p'},
        ],
      },
      'proxy': [
        {'url': 'http://proxy', 'description': 'd', 'protocol': 'http'},
      ],
      'ws': [
        {'url': 'wss://ws', 'description': 'd'},
      ],
      'update': [
        {'url': 'https://u', 'description': 'd', 'version': '1.0'},
      ],
      'onlineSupport': [
        {
          'url': 'u',
          'description': 'd',
          'apiBaseUrl': 'https://api',
          'wsBaseUrl': 'wss://ws2',
        },
      ],
      'report_log': [
        {'url': 'https://log', 'description': 'd'},
      ],
      'subscription': {
        'urls': [
          {'url': 'https://sub', 'supportEncrypt': true, 'endpoints': {'v2': {'path': 's/{token}', 'isEncrypt': true}}},
        ],
      },
      'metadata': {
        'sources': ['a'],
        'lastUpdated': '2024-01-01T00:00:00.000Z',
        'version': '2.0.0',
        'statistics': {'x': 1},
      },
    };

    test('parses every section', () {
      final config = ParsedConfiguration.fromJson(json, 'Flclash');
      expect(config.panelType, 'xboard');
      expect(config.proxies.length, 1);
      expect(config.webSockets.length, 1);
      expect(config.updates.length, 1);
      expect(config.onlineSupport.length, 1);
      expect(config.reportLog.length, 1);
      expect(config.subscription!.urls.length, 1);
      expect(config.metadata.version, '2.0.0');
    });

    test('exposes first-* convenience getters', () {
      final config = ParsedConfiguration.fromJson(json, 'Flclash');
      expect(config.firstPanelUrl, 'https://panel.com');
      expect(config.firstProxyUrl, 'http://proxy');
      expect(config.firstWsUrl, 'wss://ws');
      expect(config.firstUpdateUrl, 'https://u');
      expect(config.firstReportLogUrl, 'https://log');
      expect(config.firstOnlineSupportApiUrl, 'https://api');
      expect(config.firstOnlineSupportWsUrl, 'wss://ws2');
      expect(config.firstSubscriptionUrl, 'https://sub');
      expect(config.firstEncryptSubscriptionUrl, 'https://sub');
      expect(config.buildSubscriptionUrl('tok'), 'https://sub/s/tok?flag=flclash');
    });

    test('throws when panelType is missing', () {
      expect(
        () => ParsedConfiguration.fromJson(const {'panels': {}}, 'Flclash'),
        throwsA(isA<Exception>()),
      );
    });

    test('handles empty json sections', () {
      final config = ParsedConfiguration.fromJson(const {'panelType': 'v2board'}, 'Flclash');
      expect(config.firstWsUrl, isNull);
      expect(config.firstProxyUrl, isNull);
      expect(config.firstUpdateUrl, isNull);
      expect(config.firstReportLogUrl, isNull);
      expect(config.firstOnlineSupportApiUrl, isNull);
      expect(config.firstSubscriptionUrl, isNull);
      expect(config.subscription, isNull);
      expect(config.buildSubscriptionUrl('t'), isNull);
    });

    test('toJson serializes sections', () {
      final config = ParsedConfiguration.fromJson(json, 'Flclash');
      final out = config.toJson();
      expect((out['proxy'] as List).length, 1);
      expect((out['subscription'] as Map)['urls'], isA<List>());
      expect(config.toString(), contains('proxies: 1'));
    });
  });

  group('ConfigMetadata', () {
    test('fromJson uses defaults for missing fields', () {
      final meta = ConfigMetadata.fromJson(const {});
      expect(meta.sources, isEmpty);
      expect(meta.version, '1.0.0');
      expect(meta.statistics, isEmpty);
    });

    test('fromJson parses provided fields and round-trips', () {
      final meta = ConfigMetadata.fromJson(const {
        'sources': ['a', 'b'],
        'lastUpdated': '2024-05-06T07:08:09.000Z',
        'version': '3.1.4',
        'statistics': {'k': 'v'},
      });
      expect(meta.sources, ['a', 'b']);
      expect(meta.version, '3.1.4');
      expect(meta.statistics, {'k': 'v'});
      expect(meta.toJson()['version'], '3.1.4');
    });
  });
}
