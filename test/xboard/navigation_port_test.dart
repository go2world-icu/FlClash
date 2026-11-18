import 'package:fl_clash/views/navigation.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/common/app_ports.dart';
import 'package:fl_clash/ui/icons/app_glyphs.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/xboard/features/dashboard/dashboard.dart';
import 'package:fl_clash/xboard/navigation_port.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

List<PageLabel> _labels(List<NavigationItem> items) =>
    items.map((item) => item.label).toList();

NavigationItem _item(List<NavigationItem> items, PageLabel label) =>
    items.firstWhere((item) => item.label == label);

class _UpstreamNavigation implements NavigationPort {
  final List<NavigationItem> items;
  bool? openLogs;
  bool? hasProxies;

  _UpstreamNavigation(this.items);

  @override
  List<NavigationItem> getItems({
    bool openLogs = false,
    bool hasProxies = false,
  }) {
    this.openLogs = openLogs;
    this.hasProxies = hasProxies;
    return items;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const port = XBoardNavigationPort(hasPanel: false);

  test('without a panel config it matches upstream\'s item set', () {
    final items = port.getItems(openLogs: true, hasProxies: true);
    expect(
      _labels(items),
      _labels(navigation.getItems(openLogs: true, hasProxies: true)),
    );
  });

  testWidgets('the dashboard is the panel\'s page', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      Builder(
        builder: (childContext) {
          context = childContext;
          return const SizedBox();
        },
      ),
    );

    final dashboard = _item(port.getItems(), PageLabel.dashboard);
    // Upstream v0.9.1 dropped `NavigationItem.keep`: every page is kept now,
    // by the `KeepScope` `_NavigationPage` wraps around the builder.
    expect(dashboard.glyph, AppGlyphs.dashboard);
    final built = dashboard.builder(context);
    expect(built, isA<XBoardDashboardView>());
    expect(
      built.key,
      const GlobalObjectKey(PageLabel.dashboard),
      reason: 'home.dart resolves the page by its label key for back handling',
    );
  });

  test('the proxies tab follows upstream\'s hasProxies gate', () {
    expect(_item(port.getItems(hasProxies: true), PageLabel.proxies).modes, [
      NavigationItemMode.mobile,
      NavigationItemMode.desktop,
    ]);
    expect(
      _item(port.getItems(hasProxies: false), PageLabel.proxies).modes,
      [],
    );
  });

  test('the logs tab follows the setting', () {
    expect(_item(port.getItems(openLogs: true), PageLabel.logs).modes, [
      NavigationItemMode.desktop,
      NavigationItemMode.more,
    ]);
    expect(_item(port.getItems(openLogs: false), PageLabel.logs).modes, []);
  });

  test('the secondary tabs keep their upstream modes', () {
    final upstream = navigation.getItems();
    final items = port.getItems();
    for (final label in [
      PageLabel.requests,
      PageLabel.dns,
      PageLabel.resources,
      PageLabel.tools,
      PageLabel.profiles,
    ]) {
      expect(_item(items, label).modes, _item(upstream, label).modes);
    }
  });

  group('with a panel config', () {
    const port = XBoardNavigationPort(hasPanel: true);

    test('the profiles tab gives way to the account tab', () {
      final items = port.getItems(openLogs: true, hasProxies: true);
      final upstream = navigation.getItems(openLogs: true, hasProxies: true);
      expect(_labels(items), [
        for (final item in upstream)
          if (item.label != PageLabel.profiles) item.label,
        PageLabel.xboard,
      ]);
    });

    test('the account tab is last, drawn with the account glyph', () {
      final account = _item(port.getItems(), PageLabel.xboard);
      expect(account.glyph, AppGlyphs.account);
      // The default modes, so it survives the iOS core-off filter in
      // lib/providers/state/navigation.dart.
      expect(account.modes, [
        NavigationItemMode.mobile,
        NavigationItemMode.desktop,
      ]);
    });
  });

  test('upstream additions, order and metadata survive decoration', () {
    final dashboard = NavigationItem(
      glyph: AppGlyphs.dashboard,
      label: PageLabel.dashboard,
      path: '/upstream-dashboard',
      modes: const [NavigationItemMode.more],
      builder: (_) => const SizedBox(),
    );
    final addition = dashboard.copyWith(label: PageLabel.tools);
    final upstream = _UpstreamNavigation([addition, dashboard]);
    final port = XBoardNavigationPort(upstream: upstream, hasPanel: true);

    final items = port.getItems(openLogs: true, hasProxies: true);
    expect(_labels(items), [
      PageLabel.tools,
      PageLabel.dashboard,
      PageLabel.xboard,
    ]);
    expect(items.first, same(addition));
    expect(items[1].path, dashboard.path);
    expect(items[1].modes, dashboard.modes);
    expect(upstream.openLogs, isTrue);
    expect(upstream.hasProxies, isTrue);
    expect(upstream.items, [addition, dashboard]);

    final laterAddition = addition.copyWith(label: PageLabel.requests);
    upstream.items.insert(0, laterAddition);
    expect(port.getItems().first, same(laterAddition));
  });
}
