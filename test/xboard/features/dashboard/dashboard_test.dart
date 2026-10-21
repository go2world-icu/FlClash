import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/edit.dart';
import 'package:fl_clash/views/dashboard/widgets/widgets.dart';
import 'package:fl_clash/xboard/features/dashboard/dashboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_profiles.dart';

const _phoneSize = Size(412, 915);

/// The panel's dashboard is a copy of upstream's page, so these are the checks
/// that keep the copy honest: the same density breakpoints, the same edit
/// toggle, and the panel's own action over the corner. The body itself is
/// covered by `test/views/dashboard/layout_test.dart`, which pumps upstream's
/// page — if the copy drifts, the shared cards are what break first.
void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(TestProfiles.new),
        dashboardStateProvider.overrideWithValue(
          // The phone lays out the saved widgets in the order they were
          // arranged, so it needs the shipped list; the desktop windows ignore
          // it and lay the page out themselves.
          const DashboardState(dashboardWidgets: defaultDashboardWidgets),
        ),
      ],
    );
    globalState.container = container;
  });

  tearDown(() => container.dispose());

  Future<void> pumpDashboard(
    WidgetTester tester,
    Size size, {
    SupportPlatform platform = SupportPlatform.MacOS,
    bool withProfile = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    container.read(viewSizeProvider.notifier).value = size;
    if (withProfile) {
      container
          .read(profilesProvider.notifier)
          .put(const Profile(id: 1, autoUpdateDuration: Duration.zero));
    }
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TestApp(child: XBoardDashboardView(platform: platform)),
      ),
    );
    await tester.pump();
  }

  Future<void> teardown(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 5));
  }

  testWidgets('a four column window lays out the cards upstream\'s way', (
    tester,
  ) async {
    await pumpDashboard(tester, const Size(1220, 824));

    expect(find.byType(CurrentOutboundCard), findsOneWidget);
    expect(find.byType(ConnectionsTableCard), findsOneWidget);
    expect(tester.getSize(find.byType(CurrentOutboundCard)).height, 208);
    expect(tester.takeException(), isNull);

    await teardown(tester);
  });

  testWidgets('a short window keeps the layout with compact rows', (
    tester,
  ) async {
    await pumpDashboard(tester, const Size(1220, 720));

    expect(tester.getSize(find.byType(CurrentOutboundCard)).height, 176);
    expect(tester.takeException(), isNull);

    await teardown(tester);
  });

  testWidgets('a phone shows the saved cards edge to edge', (tester) async {
    await pumpDashboard(
      tester,
      const Size(400, 900),
      platform: SupportPlatform.Android,
    );

    final card = tester.getRect(find.byType(CurrentOutboundCard));
    expect(card.left, 16);
    expect(card.right, 400 - 16);
    expect(find.byType(ConnectionsTableCard), findsNothing);
    expect(tester.takeException(), isNull);

    await teardown(tester);
  });

  testWidgets('the edit toggle opens the editor, which Done closes', (
    tester,
  ) async {
    await pumpDashboard(tester, const Size(400, 900));
    expect(find.byType(DashboardEditor), findsNothing);

    await tester.tap(find.byTooltip('Edit dashboard'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(DashboardEditor), findsOneWidget);

    await tester.tap(find.byTooltip('Done'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(DashboardEditor), findsNothing);
    expect(tester.takeException(), isNull);

    await teardown(tester);
  });

  testWidgets('the panel action waits for a profile', (tester) async {
    await pumpDashboard(tester, _phoneSize);
    expect(find.byType(StartButton), findsNothing);
    expect(find.byType(NodeSelectorChip), findsNothing);
  });

  testWidgets('a profile brings the node selector and the start button', (
    tester,
  ) async {
    await pumpDashboard(tester, _phoneSize, withProfile: true);

    expect(find.byType(StartButton), findsOneWidget);
    // With no core running there are no groups, so the chip renders nothing —
    // but it is still the widget the panel mounts beside the start button.
    expect(find.byType(NodeSelectorChip), findsOneWidget);
    expect(tester.takeException(), isNull);

    await teardown(tester);
  });

  testWidgets('the panel action leaves the page alone while editing', (
    tester,
  ) async {
    await pumpDashboard(tester, _phoneSize, withProfile: true);

    await tester.tap(find.byTooltip('Edit dashboard'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(StartButton), findsNothing);

    await teardown(tester);
  });

  testWidgets('the action sits over the bottom corner, clear of the dock', (
    tester,
  ) async {
    await pumpDashboard(tester, _phoneSize, withProfile: true);

    final button = tester.getRect(find.byType(StartButton));
    expect(button.bottom, lessThanOrEqualTo(_phoneSize.height));
    expect(button.right, lessThanOrEqualTo(_phoneSize.width));
    expect(find.byTooltip('Edit dashboard'), findsOneWidget);

    await teardown(tester);
  });
}
