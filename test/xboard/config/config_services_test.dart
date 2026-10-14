import 'package:fl_clash/xboard/config/models/online_support_info.dart';
import 'package:fl_clash/xboard/config/models/panel_configuration.dart';
import 'package:fl_clash/xboard/config/models/proxy_info.dart';
import 'package:fl_clash/xboard/config/models/update_info.dart';
import 'package:fl_clash/xboard/config/models/websocket_info.dart';
import 'package:fl_clash/xboard/config/services/online_support_service.dart';
import 'package:fl_clash/xboard/config/services/panel_service.dart';
import 'package:fl_clash/xboard/config/services/proxy_service.dart';
import 'package:fl_clash/xboard/config/services/update_service.dart';
import 'package:fl_clash/xboard/config/services/websocket_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PanelService', () {
    final config = PanelConfiguration.fromJson(const {
      'Flclash': [
        {'url': 'https://a', 'description': 'a'},
        {'url': 'https://b', 'description': 'b'},
      ],
      'Other': [
        {'url': 'https://c', 'description': 'c'},
      ],
    }, 'Flclash');
    final service = PanelService(config);

    test('exposes current provider panels and urls', () {
      expect(service.getCurrentProviderPanels().length, 2);
      expect(service.getFirstPanelUrl(), 'https://a');
      expect(service.getCurrentProviderPanelUrls(), ['https://a', 'https://b']);
      expect(service.getCurrentProvider(), 'Flclash');
    });

    test('queries providers', () {
      expect(service.getPanelsByProvider('Other').single.url, 'https://c');
      expect(service.getAllPanels().length, 3);
      expect(service.getAvailableProviders(), containsAll(['Flclash', 'Other']));
      expect(service.hasProvider('Flclash'), isTrue);
      expect(service.hasProvider('missing'), isFalse);
    });

    test('reports stats', () {
      final stats = service.getPanelStats();
      expect(stats['currentProvider'], 'Flclash');
      expect(stats['totalProviders'], 2);
      expect(stats['totalPanels'], 3);
      expect(stats['currentProviderPanels'], 2);
      expect((stats['providerCounts'] as Map)['Other'], 1);
      expect(service.toString(), contains('provider: Flclash'));
    });

    test('getFastestPanelUrl returns the only url without racing', () async {
      final single = PanelService(
        PanelConfiguration.fromJson(const {
          'Flclash': [
            {'url': 'https://only', 'description': 'a'},
          ],
        }, 'Flclash'),
      );
      expect(await single.getFastestPanelUrl(), 'https://only');
    });
  });

  group('ProxyService', () {
    final service = ProxyService(const [
      ProxyInfo(url: 'http://a', description: 'a', protocol: 'http', region: 'HK'),
      ProxyInfo(url: 'socks5://b', description: 'b', protocol: 'socks5', region: 'US'),
      ProxyInfo(url: 'http://c', description: 'c', protocol: 'http', region: 'HK'),
    ]);

    test('lists and picks the first proxy', () {
      expect(service.getAllProxies().length, 3);
      expect(service.getFirstProxy()!.url, 'http://a');
      expect(service.getFirstProxyUrl(), 'http://a');
    });

    test('filters by protocol and region', () {
      expect(service.getProxiesByProtocol('http').length, 2);
      expect(service.getProxiesByRegion('HK').length, 2);
      expect(service.getAvailableProtocols(), containsAll(['http', 'socks5']));
      expect(service.getAvailableRegions(), containsAll(['HK', 'US']));
      expect(service.hasProtocol('socks5'), isTrue);
      expect(service.hasRegion('CN'), isFalse);
    });

    test('reports stats and handles empty list', () {
      final stats = service.getProxyStats();
      expect(stats['totalProxies'], 3);
      expect((stats['protocolCounts'] as Map)['http'], 2);
      expect((stats['regionCounts'] as Map)['US'], 1);
      expect(service.toString(), contains('proxies: 3'));

      final empty = ProxyService(const []);
      expect(empty.getFirstProxy(), isNull);
      expect(empty.getFirstProxyUrl(), isNull);
    });
  });

  group('WebSocketService', () {
    final service = WebSocketService(const [
      WebSocketInfo(url: 'wss://a', description: 'a', region: 'HK'),
      WebSocketInfo(url: 'ws://b', description: 'b', supportsPing: false),
    ]);

    test('lists and picks the first websocket', () {
      expect(service.getAllWebSockets().length, 2);
      expect(service.getFirstWebSocketUrl(), 'wss://a');
      expect(service.getFirstWebSocket()!.url, 'wss://a');
    });

    test('filters by protocol, security and ping', () {
      expect(service.getWebSocketsByProtocol('wss').length, 1);
      expect(service.getSecureWebSockets().length, 1);
      expect(service.getInsecureWebSockets().length, 1);
      expect(service.getPingEnabledWebSockets().length, 1);
      expect(service.getAvailableRegions(), ['HK']);
      expect(service.hasSecureConnections(), isTrue);
      expect(service.hasRegion('HK'), isTrue);
    });

    test('reports stats and handles empty list', () {
      final stats = service.getWebSocketStats();
      expect(stats['totalWebSockets'], 2);
      expect((stats['protocolDistribution'] as Map)['wss'], 1);
      expect(service.toString(), contains('secure: 1'));

      final empty = WebSocketService(const []);
      expect(empty.getFirstWebSocket(), isNull);
      expect(empty.getFirstWebSocketUrl(), isNull);
    });
  });

  group('UpdateService', () {
    final service = UpdateService(const [
      UpdateInfo(
        url: 'https://a',
        description: 'a',
        version: '1.0',
        region: 'CN',
        fileSize: 100,
        checksum: 'x',
      ),
      UpdateInfo(url: 'http://b', description: 'b', version: '2.0', fileSize: 300),
    ]);

    test('lists sources and picks the first', () {
      expect(service.getAllUpdateSources().length, 2);
      expect(service.getFirstUpdateSource()!.url, 'https://a');
      expect(service.getFirstUpdateUrl(), 'https://a');
    });

    test('filters by region, version and security', () {
      expect(service.getUpdateSourcesByRegion('CN').length, 1);
      expect(service.getUpdateSourcesByVersion('2.0').length, 1);
      expect(service.getSecureUpdateSources().length, 1);
      expect(service.getInsecureUpdateSources().length, 1);
      expect(service.getUpdateSourcesWithChecksum().length, 1);
      expect(service.getUpdateSourcesWithFileSize().length, 2);
      expect(service.getAvailableVersions(), containsAll(['1.0', '2.0']));
      expect(service.getAvailableRegions(), ['CN']);
      expect(service.hasSecureConnections(), isTrue);
      expect(service.hasVersion('1.0'), isTrue);
      expect(service.hasRegion('US'), isFalse);
    });

    test('computes totals and averages', () {
      expect(service.getTotalFileSize(), 400);
      expect(service.getAverageFileSize(), 200.0);

      final empty = UpdateService(const []);
      expect(empty.getAverageFileSize(), 0.0);
      expect(empty.getFirstUpdateSource(), isNull);
      expect(empty.getFirstUpdateUrl(), isNull);
    });

    test('reports stats', () {
      final stats = service.getUpdateStats();
      expect(stats['totalUpdateSources'], 2);
      expect(stats['secureConnections'], 1);
      expect(stats['totalFileSize'], 400);
      expect((stats['versionCounts'] as Map)['1.0'], 1);
      expect((stats['regionCounts'] as Map)['CN'], 1);
      expect((stats['protocolDistribution'] as Map)['http'], 1);
      expect(service.toString(), contains('updateSources: 2'));
    });
  });

  group('OnlineSupportService', () {
    const valid = OnlineSupportInfo(
      url: 'u',
      description: 'd',
      apiBaseUrl: 'https://api',
      wsBaseUrl: 'wss://ws',
    );
    const invalid = OnlineSupportInfo(
      url: 'u2',
      description: 'd2',
      apiBaseUrl: '',
      wsBaseUrl: 'bad',
    );

    test('lists configs and picks the first', () {
      final service = OnlineSupportService(const [valid, invalid]);
      expect(service.getAllConfigs().length, 2);
      expect(service.getFirstAvailableConfig()!.apiBaseUrl, 'https://api');
      expect(service.getApiBaseUrl(), 'https://api');
      expect(service.getWebSocketBaseUrl(), 'wss://ws');
      expect(service.hasAvailableConfig(), isTrue);
    });

    test('handles an empty list', () {
      final empty = OnlineSupportService(const []);
      expect(empty.getFirstAvailableConfig(), isNull);
      expect(empty.getApiBaseUrl(), isNull);
      expect(empty.getWebSocketBaseUrl(), isNull);
      expect(empty.hasAvailableConfig(), isFalse);
      expect(empty.validateAllConfigs(), isTrue);
    });

    test('aggregates validation and stats', () {
      final service = OnlineSupportService(const [valid, invalid]);
      expect(service.validateAllConfigs(), isFalse);
      expect(service.getAllValidationErrors().length, 2);
      expect(service.getAllValidationErrors().first, startsWith('config[1]:'));
      final stats = service.getConfigStats();
      expect(stats['totalConfigs'], 2);
      expect((stats['protocolDistribution'] as Map)['https'], 1);
      expect((stats['protocolDistribution'] as Map)['wss'], 1);
      expect(service.toString(), contains('configs: 2'));
    });
  });
}
