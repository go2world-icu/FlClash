import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/edit.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:fl_clash/views/dashboard/widget_registry.dart';
import 'package:fl_clash/views/dashboard/widgets/core_status_button.dart';
import 'package:fl_clash/views/dashboard/widgets/widgets.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../ios_shell/ios_core_status.dart';
import 'widgets/start_button.dart';

// Narrower columns leave the service grid's cells too tight for a status, so
// the grid takes the memory card's column instead.
const _memoryColumnMin = 290.0;

const _maxColumnWidth = 440.0;

/// Cards the panel leaves out on iOS.
///
/// The dashboard's filter (`DashboardWidget.platforms`) is upstream's, and the
/// enum is an upstream file the fork keeps clean. These two are useless inside
/// the packet tunnel rather than unsupported, so they are dropped here instead:
/// the service probe runs HTTP out of the core (down whenever the tunnel is),
/// and there is no inbound listener for the intranet address to name. Filtered
/// at render rather than at the save, because the phones that already have them
/// saved would otherwise keep drawing them.
const _iosHiddenWidgets = {
  DashboardWidget.serviceStatus,
  DashboardWidget.intranetIp,
};

/// The panel's dashboard: upstream's page, with the panel's own action laid
/// over the bottom corner.
///
/// The layout, the cards and their density all stay upstream's — this file is
/// a copy of `lib/views/dashboard/dashboard.dart` rather than a wrapper, so the
/// fork can rearrange the page without every change landing in a file the next
/// merge has to reconcile. When upstream moves the page again, re-copy it and
/// re-apply the two marked spots below.
class XBoardDashboardView extends ConsumerStatefulWidget {
  const XBoardDashboardView({super.key, this.platform});

  /// The host's platform when null.
  final SupportPlatform? platform;

  @override
  ConsumerState<XBoardDashboardView> createState() =>
      _XBoardDashboardViewState();
}

class _XBoardDashboardViewState extends ConsumerState<XBoardDashboardView> {
  var _editing = false;
  final _cardKeys = <DashboardWidget, GlobalKey>{};

  void _setEditing(bool editing) {
    setState(() => _editing = editing);
  }

  GlobalKey _cardKeyOf(DashboardWidget widget) =>
      _cardKeys.putIfAbsent(widget, GlobalKey.new);

  @override
  Widget build(BuildContext context) {
    final platform = widget.platform ?? SupportPlatform.currentPlatform;
    final isIOS = platform == SupportPlatform.IOS;
    final viewSize = ref.watch(viewSizeProvider);
    final sideWidth = ref.watch(sideWidthProvider);
    final scale = math.max(1.0, MediaQuery.textScalerOf(context).scale(1));
    final size = Size(viewSize.width - sideWidth, viewSize.height) / scale;
    final editable = !DashboardDensity.of(size).isDesktop;
    if (!editable) {
      _editing = false;
    }
    final editing = _editing;
    final gap = cardSpacingOf(context, ref.watch(viewModeProvider));
    final appLocalizations = context.appLocalizations;
    return CommonScaffold(
      backgroundColor: DashboardColors.of(context).page,
      title: editing
          ? appLocalizations.editDashboard
          : appLocalizations.dashboard,
      backAction: editing ? () => _setEditing(false) : null,
      actions: [
        // The iOS shell used to carry these dots in its bar; with one shell
        // everywhere they live here, where the tunnel is switched — dots only,
        // because this bar also holds the title.
        if (!editing && isIOS) const IosCoreStatus(compact: true),
        if (!editing && coreLib == null) const CoreStatusButton(),
      ],
      confirmationAction: editing
          ? IconButtonData(
              glyph: AppGlyphs.check,
              tooltip: appLocalizations.done,
              onPressed: () => _setEditing(false),
            )
          : null,
      iconActions: [
        if (editable && !editing)
          IconButtonData(
            glyph: AppGlyphs.edit,
            tooltip: appLocalizations.editDashboard,
            onPressed: () => _setEditing(true),
          ),
      ],
      // The providers learn a resize a frame late, too late for the cards.
      body: LayoutBuilder(
        builder: (context, constraints) {
          final room = constraints.biggest / scale;
          final layout = DashboardDensity.of(room);
          return DashboardDensityScope(
            density: layout,
            scale: scale,
            child: Stack(
              children: [
                Positioned.fill(
                  child: layout.isDesktop
                      ? _DesktopDashboard(
                          platform: platform,
                          columns: dashboardColumnsOf(room.width),
                          gap: gap,
                          showServiceStatus: !isIOS,
                          showIntranetIp: !isIOS,
                        )
                      : _MobileDashboard(
                          platform: platform,
                          gap: gap,
                          editing: editing,
                          cardKeyOf: _cardKeyOf,
                          onDone: () => _setEditing(false),
                        ),
                ),
                // Fork seam: upstream keeps the start toggle in the outbound
                // card; the panel lifts it to the corner, or hands it to the
                // dock's row on a phone (see `lib/xboard/home_shell.dart`).
                if (!editing)
                  PositionedDirectional(
                    end: layout.isDesktop ? 24 : 16,
                    bottom: layout.isDesktop
                        ? 24
                        : 16 + BottomInsetScope.of(context),
                    child: const _XBoardDashboardAction(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// The panel's page-level action: the start button, until a profile exists.
///
/// On a phone with the floating dock the shell lays it out beside the bar, so
/// the page draws nothing there rather than a second copy above the corner.
class _XBoardDashboardAction extends ConsumerWidget {
  const _XBoardDashboardAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasProfile = ref.watch(
      profilesProvider.select((state) => state.isNotEmpty),
    );
    if (!hasProfile) {
      return const SizedBox.shrink();
    }
    final inDock =
        ref.watch(isMobileViewProvider) &&
        ref.watch(
          appSettingProvider.select((state) => state.floatingNavigationBar),
        );
    if (inDock) {
      return const SizedBox.shrink();
    }
    // The node picker is parked; its chip still lives in
    // `widgets/node_selector_chip.dart` for whenever it comes back — uncomment
    // it and the import above together.
    // return const Row(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [NodeSelectorChip(), SizedBox(width: 6), StartButton()],
    // );
    return const StartButton();
  }
}

/// Four columns fill the window, the tables taking what the rows above them
/// leave. A window too short for the tables, and every two column one, gets
/// the summary cards instead, so no list scrolls inside a page that scrolls.
class _DesktopDashboard extends StatelessWidget {
  const _DesktopDashboard({
    required this.platform,
    required this.columns,
    required this.gap,
    this.showServiceStatus = true,
    this.showIntranetIp = true,
  });

  final SupportPlatform platform;
  final int columns;
  final double gap;

  /// iOS lays the page out without these two; see [_iosHiddenWidgets].
  final bool showServiceStatus;
  final bool showIntranetIp;

  @override
  Widget build(BuildContext context) {
    final density = DashboardDensityScope.of(context);
    final compact = density.isCompact;
    final scale = DashboardDensityScope.scaleOf(context);
    final base = EdgeInsetsDirectional.fromSTEB(
      16,
      MediaQuery.paddingOf(context).top,
      24,
      24 + MediaQuery.paddingOf(context).bottom,
    );
    final topHeight = (compact ? 176 : 208) * scale;
    final controlHeight = (compact ? 56 : 64) * scale;
    final middleHeight = (compact ? 152 : 176) * scale;
    final tablesHeight = connectionsTableMinHeight(density, scale);
    final summaryHeight = (compact ? 112 : 120) * scale;
    return LayoutBuilder(
      builder: (context, constraints) {
        final room =
            constraints.maxWidth - base.horizontal - gap * (columns - 1);
        final column = math.min(room / columns, _maxColumnWidth * scale);
        final inset = (room - column * columns) / 2;
        final padding = base.copyWith(
          start: base.start + inset,
          end: base.end + inset,
        );
        double span(int columns) => column * columns + gap * (columns - 1);
        Widget row(List<(int, Widget)> cards) => Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: gap,
          children: [
            for (final (columns, card) in cards)
              SizedBox(
                width: span(columns),
                child: RepaintBoundary(child: card),
              ),
          ],
        );
        Widget sized(double height, Widget child) =>
            SizedBox(height: height, child: child);
        final switches =
            DashboardWidget.networkTakeover.platforms.contains(platform)
            ? const [
                (1, NetworkTakeoverTile(TakeoverSwitch.systemProxy)),
                (1, NetworkTakeoverTile(TakeoverSwitch.tun)),
              ]
            : const [(2, VpnTile())];
        final half = columns ~/ 2;
        final summaries = row([
          (half, const ConnectionStatsCard()),
          (half, const ProxyGroupsSummaryCard()),
        ]);
        // Fork seam: iOS drops one card from each of these pairs; the card that
        // stays takes the row rather than leaving half of it empty.
        final intranetRow = showIntranetIp
            ? const [(1, IntranetIpCard()), (1, ProfilesCard())]
            : const [(2, ProfilesCard())];
        final serviceRow = showServiceStatus
            ? const [(1, ServiceStatusCard()), (1, MemoryInfo())]
            : const [(2, MemoryInfo())];
        if (columns == 2) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: padding,
            child: Column(
              spacing: gap,
              children: [
                sized(
                  topHeight,
                  const RepaintBoundary(child: CurrentOutboundCard()),
                ),
                sized(
                  topHeight,
                  row(const [
                    (1, SpeedCard(direction: TrafficDirection.upload)),
                    (1, SpeedCard(direction: TrafficDirection.download)),
                  ]),
                ),
                sized(
                  controlHeight,
                  const RepaintBoundary(child: OutboundModeBar()),
                ),
                sized(controlHeight, row(switches)),
                sized(middleHeight, row(intranetRow)),
                sized(middleHeight, row(serviceRow)),
                sized(summaryHeight, summaries),
              ],
            ),
          );
        }
        final rows = [
          sized(
            topHeight,
            row(const [
              (2, CurrentOutboundCard()),
              (1, SpeedCard(direction: TrafficDirection.upload)),
              (1, SpeedCard(direction: TrafficDirection.download)),
            ]),
          ),
          sized(
            controlHeight,
            row([(2, const OutboundModeBar()), ...switches]),
          ),
          sized(
            middleHeight,
            // Fork seam: with both cards shown this is upstream's row; a window
            // iOS lays out has two, and they split it rather than leave halves
            // of it empty.
            showIntranetIp && showServiceStatus
                ? row([
                    (1, const IntranetIpCard()),
                    (1, const ProfilesCard()),
                    if (column >= _memoryColumnMin * scale) ...[
                      (1, const ServiceStatusCard()),
                      (1, const MemoryInfo()),
                    ] else
                      (2, const ServiceStatusCard()),
                  ])
                : row([(2, const ProfilesCard()), (2, const MemoryInfo())]),
          ),
        ];
        final rowsHeight =
            padding.vertical +
            topHeight +
            controlHeight +
            middleHeight +
            gap * 3;
        final tablesFit = constraints.maxHeight >= rowsHeight + tablesHeight;
        final fills = constraints.maxHeight >= rowsHeight + summaryHeight;
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: fills ? constraints.maxHeight : null,
            child: Padding(
              padding: padding,
              child: Column(
                spacing: gap,
                children: [
                  ...rows,
                  if (tablesFit)
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: gap,
                        children: const [
                          Expanded(
                            flex: 3,
                            child: RepaintBoundary(
                              child: ConnectionsTableCard(),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: RepaintBoundary(child: ProxyGroupsCard()),
                          ),
                        ],
                      ),
                    )
                  else if (fills)
                    Expanded(child: summaries)
                  else
                    sized(summaryHeight, summaries),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MobileDashboard extends ConsumerWidget {
  const _MobileDashboard({
    required this.platform,
    required this.gap,
    required this.editing,
    required this.cardKeyOf,
    required this.onDone,
  });

  final SupportPlatform platform;
  final double gap;
  final bool editing;
  final GlobalKey Function(DashboardWidget widget) cardKeyOf;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(
      dashboardStateProvider.select((state) => state.dashboardWidgets),
    );
    final top = MediaQuery.paddingOf(context).top + 4;
    final bottom = 16 + BottomInsetScope.of(context);
    return CustomScrollView(
      // A viewport per card lays them all out and holds the scroll end still.
      scrollCacheExtent: editing
          ? ScrollCacheExtent.viewport(DashboardWidget.values.length.toDouble())
          : null,
      slivers: [
        SliverLayoutBuilder(
          builder: (context, constraints) {
            final side = dashboardMobileSideOf(constraints.crossAxisExtent);
            final widgets = [
              for (final widget in saved)
                if (widget.platforms.contains(platform) &&
                    !(platform == SupportPlatform.IOS &&
                        _iosHiddenWidgets.contains(widget)))
                  widget,
            ];
            if (editing) {
              return DashboardEditor(
                platform: platform,
                widgets: widgets,
                cardKeyOf: cardKeyOf,
                padding: EdgeInsets.fromLTRB(side, top, side, bottom),
                gap: gap,
                onDone: onDone,
              );
            }
            return SliverPadding(
              padding: EdgeInsets.fromLTRB(side, top, side, bottom),
              // A lazy list estimates the cards it has not laid out from the
              // ones it has; cards this uneven move the scroll end as it goes.
              sliver: SliverToBoxAdapter(
                child: Column(
                  spacing: gap,
                  children: [
                    for (final widget in widgets)
                      RepaintBoundary(
                        key: cardKeyOf(widget),
                        child: widget.card,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
