import 'package:fl_clash/common/app_ports.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/icons/app_glyphs.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/xboard/bridge.dart';
import 'package:fl_clash/xboard/config_check.dart';

/// Wraps upstream's navigation with the panel's shape: the account tab, no
/// profiles tab while the panel owns the shell, and the proxies tab left to the
/// dashboard's node selector.
///
/// It exists so `lib/views/navigation.dart` stays byte-for-byte upstream. Every
/// line the fork adds to that file is a line to resolve on the next merge, and
/// a port is the seam upstream already offers for exactly this.
class XBoardNavigationPort implements NavigationPort {
  const XBoardNavigationPort(this._delegate);

  final NavigationPort _delegate;

  @override
  List<NavigationItem> getItems({
    bool openLogs = false,
    bool hasProxies = false,
  }) {
    final hasXboard = hasXboardConfig;
    return [
      for (final item in _delegate.getItems(
        openLogs: openLogs,
        hasProxies: hasProxies,
      ))
        if (!(hasXboard && item.label == PageLabel.profiles))
          if (item.label == PageLabel.proxies)
            item.copyWith(modes: const [])
          else
            item,
      if (hasXboard)
        NavigationItem(
          glyph: AppGlyphs.account,
          label: PageLabel.xboard,
          builder: (_) => const XBoardPage(),
        ),
    ];
  }
}
