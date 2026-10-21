import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/manager/app_manager.dart';
import 'package:fl_clash/models/common.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config_check.dart';
import 'features/dashboard/widgets/start_button.dart';

/// The gap the dock's trailing slot kept between the bar and the button.
const double _startButtonGap = 8;

/// The dock's own side margin, so the button ends where the bar would have.
/// Private to `lib/ui/navigation_dock.dart`, which the fork leaves untouched.
const double _dockEdgeMargin = 21;

/// The start button in the dock's shape: a circle as tall as the bar, flat on
/// the surface, rather than the 56 dp Material would give a floating action
/// button. Its press swelling and its icons are [StartButton]'s own.
class _DockedStartButton extends StatelessWidget {
  const _DockedStartButton({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      child: Theme(
        data: theme.copyWith(
          floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
            shape: AppShape.full,
            elevation: 0,
            focusElevation: 0,
            hoverElevation: 0,
            highlightElevation: 0,
            disabledElevation: 0,
            sizeConstraints: BoxConstraints.tightFor(
              width: height,
              height: height,
            ),
            iconSize: 28,
          ),
        ),
        child: const ElasticButton(child: StartButton()),
      ),
    );
  }
}

/// The panel's home: upstream's page, with the start button back at the end of
/// the floating dock.
///
/// v0.9.1 deleted the dock's trailing slot (its `trailing`, `_DockTrailing`
/// and `_SlotMaterialize` went with the Liquid Glass rewrite), which left the
/// start button floating over the corner of the page instead of sitting beside
/// the bar. The dock is upstream's now and stays untouched, so this file is a
/// copy of `lib/pages/home.dart` whose only difference is the row that lays the
/// two out together. When upstream moves the shell again, re-copy the page here
/// and re-apply the marked spots — the same rule the dashboard copy follows.
///
/// `lib/application.dart` reaches it through `buildXBoardHome()`, so upstream
/// never names this file.
class XBoardShellHome extends ConsumerWidget {
  const XBoardShellHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasViewSize = ref.watch(
      viewSizeProvider.select((size) => !size.isEmpty),
    );
    if (!hasViewSize) {
      return const SizedBox.shrink();
    }
    return XBoardShellBackScope(
      child: AppSidebarContainer(
        child: _HomeShell(
          child: Consumer(
            builder: (_, ref, _) {
              final navigationItems = ref
                  .watch(currentNavigationItemsStateProvider)
                  .value;
              final isMobile = ref.watch(isMobileViewProvider);
              return _HomePageView(
                navigationItems: navigationItems,
                pageBuilder: (_, index) {
                  final navigationItem = navigationItems[index];
                  return _NavigationPage(
                    key: ValueKey(navigationItem.label),
                    item: navigationItem,
                    isMobile: isMobile,
                    view: navigationItem.builder(context),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeShell extends ConsumerWidget {
  const _HomeShell({required this.child});

  final Widget child;

  void _handleToPage(PageLabel pageLabel, WidgetRef ref) {
    ref.read(currentPageLabelProvider.notifier).toPage(pageLabel);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(navigationStateProvider);
    final isMobile = state.viewMode == ViewMode.mobile;
    final navigationItems = state.navigationItems;
    final floating = ref.watch(
      appSettingProvider.select((state) => state.floatingNavigationBar),
    );
    // The panel draws its own dashboard only when the panel is configured; the
    // upstream page keeps its own start toggle inside the outbound card.
    final panelDashboard =
        ref.watch(
          shownPageLabelProvider.select(
            (label) => label == PageLabel.dashboard,
          ),
        ) &&
        hasXboardConfig;
    final docked = isMobile && floating && panelDashboard;
    final dockHeight = NavigationDock.heightOf(context);
    return Material(
      color: SurfaceLevel.page.colorOf(context.colorScheme),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: FocusTraversalGroup(
                    policy: PageTraversalPolicy(),
                    child: BottomInsetScope(
                      inset: isMobile && floating
                          ? NavigationDock.insetOf(context)
                          : 0,
                      child: _BodyPadding(isMobile: isMobile, child: child),
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  bottom: 0,
                  child: AnimatedVisibility.bottomNavigation(
                    visible: isMobile && floating,
                    child: _NavigationPadding(
                      // Fork seam: the dock alone is centred; the start button
                      // takes its place at the row's end beside it.
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: NavigationDock(
                              destinations: [
                                for (final item in navigationItems)
                                  NavigationDockDestination(
                                    glyph: item.glyph,
                                    label: item.label.label,
                                  ),
                              ],
                              selectedIndex: state.currentIndex,
                              onSelected: (index) {
                                _handleToPage(
                                  navigationItems[index].label,
                                  ref,
                                );
                              },
                            ),
                          ),
                          if (docked)
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: _startButtonGap,
                                end: _dockEdgeMargin,
                                // The dock's own foot: the safe area its pill
                                // rests above, so the two bottoms line up.
                                bottom:
                                    NavigationDock.insetOf(context) -
                                    dockHeight,
                              ),
                              child: _DockedStartButton(height: dockHeight),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedVisibility.bottomNavigation(
            visible: isMobile && !floating,
            child: _NavigationPadding(
              child: NavigationBar(
                destinations: [
                  for (final (index, item) in navigationItems.indexed)
                    NavigationDestination(
                      icon: AnimatedGlyph(
                        glyph: item.glyph,
                        filled: index == state.currentIndex,
                      ),
                      label: item.label.label,
                    ),
                ],
                selectedIndex: state.currentIndex,
                onDestinationSelected: (index) {
                  _handleToPage(navigationItems[index].label, ref);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyPadding extends StatelessWidget {
  const _BodyPadding({required this.isMobile, required this.child});

  final bool isMobile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: false,
      removeBottom: isMobile,
      removeLeft: isMobile,
      removeRight: isMobile,
      context: context,
      child: child,
    );
  }
}

class _NavigationPadding extends StatelessWidget {
  const _NavigationPadding({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      removeBottom: false,
      removeLeft: true,
      removeRight: true,
      context: context,
      child: child,
    );
  }
}

class _NavigationPage extends StatelessWidget {
  const _NavigationPage({
    super.key,
    required this.item,
    required this.isMobile,
    required this.view,
  });

  final NavigationItem item;
  final bool isMobile;
  final Widget view;

  @override
  Widget build(BuildContext context) {
    final scopedView = PageFocusScope(child: view);
    final keptView = KeepScope(
      key: ValueKey(item.label),
      child: isMobile
          ? scopedView
          : Navigator(
              key: ValueKey('${item.label.name}_navigator'),
              pages: [MaterialPage(child: scopedView)],
              onDidRemovePage: (_) {},
            ),
    );
    return Consumer(
      builder: (_, ref, child) {
        final isActive = ref.watch(
          shownPageLabelProvider.select((label) => label == item.label),
        );
        // A kept-alive page off screen still ticks its animations, and
        // each tick asks for a frame.
        return PageActivityScope(
          isActive: isActive,
          child: TickerMode(
            enabled: isActive,
            child: ExcludeFocus(
              excluding: !isActive,
              child: KeyboardInsetHold(child: child!),
            ),
          ),
        );
      },
      child: keptView,
    );
  }
}

class _HomePageView extends ConsumerStatefulWidget {
  final IndexedWidgetBuilder pageBuilder;
  final List<NavigationItem> navigationItems;

  const _HomePageView({
    required this.pageBuilder,
    required this.navigationItems,
  });

  @override
  ConsumerState createState() => _HomePageViewState();
}

class _HomePageViewState extends ConsumerState<_HomePageView> {
  late PageController _pageController;

  List<int>? _order;
  int _slide = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
    ref.listenManual(currentPageLabelProvider, (prev, next) {
      if (prev != next) {
        _toPage(next);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _HomePageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(
      _labelsOf(oldWidget.navigationItems),
      _labelsOf(widget.navigationItems),
    )) {
      _order = null;
      _updatePageController();
    }
  }

  static List<PageLabel> _labelsOf(List<NavigationItem> items) => [
    for (final item in items) item.label,
  ];

  int get _pageIndex => _indexOf(ref.read(currentPageLabelProvider));

  int _indexOf(PageLabel pageLabel) {
    final shown = shownPageLabelOf(pageLabel, widget.navigationItems);
    return widget.navigationItems.indexWhere((item) => item.label == shown);
  }

  Future<void> _toPage(
    PageLabel pageLabel, [
    bool ignoreAnimateTo = false,
  ]) async {
    if (!mounted) {
      return;
    }
    final index = _indexOf(pageLabel);
    if (index == -1) {
      return;
    }
    final tabAnimation = ref.read(appSettingProvider).tabAnimation;
    final isMobile = ref.read(isMobileViewProvider);
    final slide = ++_slide;
    final page = _pageController.hasClients
        ? _pageController.page?.round() ?? index
        : index;
    final current = _order?[page] ?? page;
    if (_order != null) {
      setState(() => _order = null);
      _pageController.jumpToPage(current);
    }
    if (!isMobile || ignoreAnimateTo) {
      _pageController.jumpToPage(index);
      return;
    }
    // As TabBarView does, so no page between is built and painted on the way.
    if ((index - current).abs() > 1) {
      final adjacent = index > current ? index - 1 : index + 1;
      setState(() {
        _order = List.generate(widget.navigationItems.length, (item) => item)
          ..[adjacent] = current
          ..[current] = adjacent;
      });
      _pageController.jumpToPage(adjacent);
    }
    final fade = tabAnimation == TabAnimation.fade;
    await _pageController.animateToPage(
      index,
      duration: fade ? fadeTabDuration : kTabScrollDuration,
      curve: fade ? fadeTabCurve : Curves.easeOut,
    );
    if (mounted && slide == _slide && _order != null) {
      setState(() => _order = null);
    }
  }

  void _updatePageController() {
    final pageLabel = ref.read(currentPageLabelProvider);
    _toPage(pageLabel, true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = ref.watch(
      currentNavigationItemsStateProvider.select((state) => state.value.length),
    );
    final fade = ref.watch(
      appSettingProvider.select(
        (state) => state.tabAnimation == TabAnimation.fade,
      ),
    );
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      findChildIndexCallback: (key) {
        if (key is! ValueKey<PageLabel>) {
          return null;
        }
        final index = widget.navigationItems.indexWhere(
          (item) => item.label == key.value,
        );
        if (index == -1) {
          return null;
        }
        return _order?.indexOf(index) ?? index;
      },
      itemBuilder: (context, index) {
        final page = widget.pageBuilder(context, _order?[index] ?? index);
        return _FadeTabPage(
          key: page.key,
          controller: _pageController,
          position: index,
          enabled: fade,
          child: page,
        );
      },
    );
  }
}

/// Cancels the page view's slide so a tab switch cross-fades in place, and
/// wraps every page even when off so switching the setting keeps their state.
class _FadeTabPage extends StatelessWidget {
  const _FadeTabPage({
    super.key,
    required this.controller,
    required this.position,
    required this.enabled,
    required this.child,
  });

  final PageController controller;
  final int position;
  final bool enabled;
  final Widget child;

  double get _delta {
    if (!controller.hasClients || !controller.position.hasContentDimensions) {
      return 0;
    }
    final page = controller.page ?? position.toDouble();
    return (position - page).clamp(-1.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        final offset = _delta;
        final delta = enabled ? offset : 0.0;
        return FractionalTranslation(
          translation: Offset(-delta, 0),
          child: Opacity(opacity: 1 - delta.abs(), child: child),
        );
      },
      child: child,
    );
  }
}

class XBoardShellBackScope extends ConsumerWidget {
  final Widget child;

  const XBoardShellBackScope({super.key, required this.child});

  @override
  Widget build(BuildContext context, ref) {
    return CommonPopScope(
      onPop: (context) async {
        final pageLabel = ref.read(shownPageLabelProvider);
        final realContext =
            GlobalObjectKey(pageLabel).currentContext ?? context;
        final canPop = Navigator.canPop(realContext);
        if (canPop) {
          Navigator.of(realContext).pop();
        } else if (system.isTV && pageLabel != PageLabel.dashboard) {
          ref
              .read(currentPageLabelProvider.notifier)
              .toPage(PageLabel.dashboard);
        } else {
          await ref.read(systemActionProvider.notifier).handleClose();
        }
        return false;
      },
      child: child,
    );
  }
}
