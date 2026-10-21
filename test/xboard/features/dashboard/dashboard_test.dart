import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/widget_metrics.dart';
import 'package:fl_clash/views/dashboard/widgets/start_button.dart';
import 'package:fl_clash/widgets/super_grid.dart';
import 'package:fl_clash/xboard/features/dashboard/dashboard.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

/// The panel's dashboard is a copy of upstream's page shell, so these are the
/// checks that keep the copy honest: the same band breakpoints, the same edit
/// toggle, and the panel's own floating action button.
void main() {
  ProviderContainer makeContainer({bool hasProfile = false}) {
    final container = ProviderContainer(
      overrides: [
        dashboardStateProvider.overrideWithValue(
          const DashboardState(dashboardWidgets: []),
        ),
        suspendProvider.overrideWithValue(false),
        if (hasProfile)
          profilesProvider.overrideWithValue([
            const Profile(id: 1, autoUpdateDuration: Duration.zero),
          ]),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    return container;
  }

  Future<ProviderContainer> pumpView(
    WidgetTester tester, {
    Size size = const Size(511, 1000),
    bool hasProfile = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = makeContainer(hasProfile: hasProfile);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: XBoardDashboardView()),
      ),
    );
    await tester.pump();
    return container;
  }

  testWidgets('the grid follows upstream\'s band breakpoints', (tester) async {
    await pumpView(tester);

    final grid = find.byType(SuperGrid);
    expect(tester.widget<SuperGrid>(grid).crossAxisCount, 8);

    tester.view.physicalSize = const Size(512, 1000);
    await tester.pump();
    expect(tester.widget<SuperGrid>(grid).crossAxisCount, 12);

    tester.view.physicalSize = const Size(1600, 1000);
    await tester.pump();
    expect(tester.widget<SuperGrid>(grid).crossAxisCount, 16);
    expect(tester.getSize(grid).width, 1120);
    expect(tester.takeException(), null);
  });

  testWidgets('the edit toggle flips the grid and saves on exit', (
    tester,
  ) async {
    await pumpView(tester);

    final grid = find.byType(SuperGrid);
    expect(tester.widget<SuperGrid>(grid).editing, isFalse);

    await tester.tap(find.byKey(const ValueKey('edit-icon')));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byKey(const ValueKey('save-icon')), findsOneWidget);
    expect(tester.widget<SuperGrid>(grid).editing, isTrue);

    // The switch is a fade/rotation/scale transition; let it finish before
    // tapping what it revealed.
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.byKey(const ValueKey('save-icon')));
    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(const ValueKey('edit-icon')), findsOneWidget);
    expect(tester.widget<SuperGrid>(grid).editing, isFalse);
  });

  testWidgets('the floating button waits for a profile', (tester) async {
    await pumpView(tester);
    expect(find.byType(StartButton), findsNothing);
    expect(find.byType(NodeSelectorChip), findsNothing);
  });

  testWidgets('a profile brings the node selector and the start button', (
    tester,
  ) async {
    await pumpView(tester, hasProfile: true);

    expect(find.byType(StartButton), findsOneWidget);
    // With no core running there are no groups, so the chip renders nothing —
    // but it is still the widget the panel mounts beside the start button.
    expect(find.byType(NodeSelectorChip), findsOneWidget);
  });

  testWidgets('the grid is handed a unit height for its width', (tester) async {
    await pumpView(tester, size: const Size(360, 1000));

    final metrics = find.byType(DashboardWidgetMetrics);
    expect(tester.widget<DashboardWidgetMetrics>(metrics).unitHeight, 80);
  });
}
