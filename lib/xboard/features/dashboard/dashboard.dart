/// The panel's dashboard: the page shell and the two widgets the desktop page
/// no longer carries.
///
/// The cards, `DashboardDensityScope` and the editor stay in
/// `lib/views/dashboard/` — a second copy of the density scope would be a
/// different inherited type, and every card would silently fall back to the
/// mobile metrics. What lives here is only what the fork lays out differently.
library;

export 'widgets/node_selector_chip.dart';
export 'widgets/start_button.dart';
export 'xboard_dashboard_view.dart';
