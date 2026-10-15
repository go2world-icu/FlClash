import 'package:fl_clash/common/app_ports.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/icons/app_glyphs.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/xboard/config_check.dart';
import 'package:fl_clash/xboard/navigation_port.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Mirrors the shape of upstream's `Navigation`: dashboard, proxies (whose
/// modes upstream keys off `hasProxies`), profiles, tools.
class _UpstreamishPort implements NavigationPort {
  const _UpstreamishPort();

  @override
  List<NavigationItem> getItems({
    bool openLogs = false,
    bool hasProxies = false,
  }) {
    return [
      const NavigationItem(
        glyph: AppGlyphs.dashboard,
        label: PageLabel.dashboard,
        builder: _unbuilt,
      ),
      NavigationItem(
        glyph: AppGlyphs.proxies,
        label: PageLabel.proxies,
        builder: _unbuilt,
        modes: hasProxies
            ? const [NavigationItemMode.mobile, NavigationItemMode.desktop]
            : const [],
      ),
      const NavigationItem(
        glyph: AppGlyphs.profiles,
        label: PageLabel.profiles,
        builder: _unbuilt,
      ),
      const NavigationItem(
        glyph: AppGlyphs.tools,
        label: PageLabel.tools,
        builder: _unbuilt,
      ),
    ];
  }
}

Widget _unbuilt(BuildContext context) => const SizedBox.shrink();

List<PageLabel> _labels(List<NavigationItem> items) =>
    items.map((item) => item.label).toList();

void main() {
  // rootBundle, for the asset probe in resolveXboardConfig below.
  TestWidgetsFlutterBinding.ensureInitialized();

  const port = XBoardNavigationPort(_UpstreamishPort());

  test('with no panel config it keeps upstream\'s item set', () {
    expect(hasXboardConfig, isFalse, reason: 'resolveXboardConfig has not run');
    final items = port.getItems(openLogs: false, hasProxies: true);
    expect(_labels(items), [
      PageLabel.dashboard,
      PageLabel.proxies,
      PageLabel.profiles,
      PageLabel.tools,
    ]);
  });

  test('the proxies tab loses its modes either way', () {
    for (final hasProxies in [false, true]) {
      final proxies = port
          .getItems(openLogs: false, hasProxies: hasProxies)
          .firstWhere((item) => item.label == PageLabel.proxies);
      expect(proxies.modes, isEmpty);
    }
  });

  group('with a panel config', () {
    setUpAll(resolveXboardConfig);

    test('the profiles tab gives way to the account tab', () {
      expect(hasXboardConfig, isTrue);
      final items = port.getItems(openLogs: false, hasProxies: true);
      expect(_labels(items), [
        PageLabel.dashboard,
        PageLabel.proxies,
        PageLabel.tools,
        PageLabel.xboard,
      ]);
      expect(items.last.glyph, AppGlyphs.account);
    });

    test('the account tab keeps the route and toolbar defaults', () {
      final account = port
          .getItems(openLogs: false, hasProxies: false)
          .firstWhere((item) => item.label == PageLabel.xboard);
      expect(account.keep, isTrue);
      expect(account.modes, contains(NavigationItemMode.mobile));
    });
  });
}
