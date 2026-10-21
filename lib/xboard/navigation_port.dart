import 'package:fl_clash/common/app_ports.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/ui/icons/app_glyphs.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/views/views.dart';
import 'package:fl_clash/xboard/bridge.dart';
import 'package:fl_clash/xboard/config_check.dart';
import 'package:fl_clash/xboard/features/dashboard/dashboard.dart';
import 'package:material_ui/material_ui.dart';

/// The panel's navigation: the whole item list, owned by the fork.
///
/// Upstream's `lib/views/navigation.dart` still exists — it is byte-for-byte
/// upstream and must stay that way — but `bootstrap` installs this instead, so
/// what the menu shows changes without a line of diff in an upstream file.
///
/// Order and modes are upstream's, with two panel twists: the dashboard is the
/// fork's own page, and a configured panel trades the profiles tab for the
/// account tab.
class XBoardNavigationPort implements NavigationPort {
  const XBoardNavigationPort();

  @override
  List<NavigationItem> getItems({
    bool openLogs = false,
    bool hasProxies = false,
  }) {
    final hasXboard = hasXboardConfig;
    return [
      NavigationItem(
        glyph: AppGlyphs.dashboard,
        label: PageLabel.dashboard,
        builder: (_) => const XBoardDashboardView(
          key: GlobalObjectKey(PageLabel.dashboard),
        ),
      ),
      NavigationItem(
        glyph: AppGlyphs.proxies,
        label: PageLabel.proxies,
        builder: (_) =>
            const ProxiesView(key: GlobalObjectKey(PageLabel.proxies)),
        modes: hasProxies
            ? const [NavigationItemMode.mobile, NavigationItemMode.desktop]
            : const [],
      ),
      if (!hasXboard)
        NavigationItem(
          glyph: AppGlyphs.profiles,
          label: PageLabel.profiles,
          builder: (_) =>
              const ProfilesView(key: GlobalObjectKey(PageLabel.profiles)),
        ),
      NavigationItem(
        glyph: AppGlyphs.requests,
        label: PageLabel.requests,
        builder: (_) =>
            const RequestsView(key: GlobalObjectKey(PageLabel.requests)),
        modes: const [NavigationItemMode.moreFull],
      ),
      NavigationItem(
        glyph: AppGlyphs.connections,
        label: PageLabel.connections,
        builder: (_) =>
            const ConnectionsView(key: GlobalObjectKey(PageLabel.connections)),
        modes: const [NavigationItemMode.desktop, NavigationItemMode.moreFull],
      ),
      NavigationItem(
        glyph: AppGlyphs.dns,
        label: PageLabel.dns,
        builder: (_) =>
            const DnsQueriesView(key: GlobalObjectKey(PageLabel.dns)),
        modes: const [NavigationItemMode.moreFull],
      ),
      NavigationItem(
        glyph: AppGlyphs.resources,
        label: PageLabel.resources,
        builder: (_) =>
            const ResourcesView(key: GlobalObjectKey(PageLabel.resources)),
        modes: const [NavigationItemMode.more],
      ),
      NavigationItem(
        glyph: AppGlyphs.logs,
        label: PageLabel.logs,
        builder: (_) => const LogsView(key: GlobalObjectKey(PageLabel.logs)),
        modes: openLogs
            ? const [NavigationItemMode.desktop, NavigationItemMode.more]
            : const [],
      ),
      NavigationItem(
        glyph: AppGlyphs.tools,
        label: PageLabel.tools,
        builder: (_) => const ToolsView(key: GlobalObjectKey(PageLabel.tools)),
        modes: const [NavigationItemMode.desktop, NavigationItemMode.mobile],
      ),
      if (hasXboard)
        NavigationItem(
          glyph: AppGlyphs.account,
          label: PageLabel.xboard,
          builder: (_) => const XBoardPage(),
        ),
    ];
  }
}
