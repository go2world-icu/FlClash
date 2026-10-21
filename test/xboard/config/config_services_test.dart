import 'package:fl_clash/xboard/config/models/panel_configuration.dart';
import 'package:fl_clash/xboard/config/models/proxy_info.dart';
import 'package:fl_clash/xboard/config/services/panel_service.dart';
import 'package:fl_clash/xboard/config/services/proxy_service.dart';
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
      expect(
        service.getAvailableProviders(),
        containsAll(['Flclash', 'Other']),
      );
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
      ProxyInfo(
        url: 'http://a',
        description: 'a',
        protocol: 'http',
        region: 'HK',
      ),
      ProxyInfo(
        url: 'socks5://b',
        description: 'b',
        protocol: 'socks5',
        region: 'US',
      ),
      ProxyInfo(
        url: 'http://c',
        description: 'c',
        protocol: 'http',
        region: 'HK',
      ),
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
}
