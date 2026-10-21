/// The panel's dashboard: the page shell and its mount table.
///
/// The cards and `DashboardWidgetMetrics` stay in `lib/views/dashboard/` —
/// a second `DashboardWidgetMetrics` would be a different inherited type, and
/// every card would silently fall back to its minimum height. What lives here
/// is only what the fork wants to lay out differently from upstream.
library;

export 'dashboard_widget_registry.dart';
export 'widgets/node_selector_chip.dart';
export 'xboard_dashboard_view.dart';
