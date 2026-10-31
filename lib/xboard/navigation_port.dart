import 'package:fl_clash/common/app_ports.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/ui/icons/app_glyphs.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/views/navigation.dart';
import 'package:fl_clash/xboard/bridge.dart';
import 'package:fl_clash/xboard/config_check.dart';
import 'package:fl_clash/xboard/features/dashboard/dashboard.dart';
import 'package:material_ui/material_ui.dart';

class XBoardNavigationPort implements NavigationPort {
  const XBoardNavigationPort({NavigationPort? upstream, bool? hasPanel})
    : _upstream = upstream,
      _hasPanel = hasPanel;

  final NavigationPort? _upstream;
  final bool? _hasPanel;

  @override
  List<NavigationItem> getItems({
    bool openLogs = false,
    bool hasProxies = false,
  }) {
    final hasPanel = _hasPanel ?? hasXboardConfig;
    final items = (_upstream ?? navigation).getItems(
      openLogs: openLogs,
      hasProxies: hasProxies,
    );
    return [
      for (final item in items)
        if (item.label == PageLabel.dashboard)
          item.copyWith(
            builder: (_) => const XBoardDashboardView(
              key: GlobalObjectKey(PageLabel.dashboard),
            ),
          )
        else if (!hasPanel || item.label != PageLabel.profiles)
          item,
      if (hasPanel)
        NavigationItem(
          glyph: AppGlyphs.account,
          label: PageLabel.xboard,
          builder: (_) => const XBoardPage(),
        ),
    ];
  }
}
