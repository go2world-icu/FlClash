import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/edit.dart';
import 'package:fl_clash/views/dashboard/widgets/widgets.dart';
import 'package:fl_clash/xboard/features/dashboard/dashboard.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_core_status.dart';
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

  group('iOS opens on the same page, with two cards fewer', () {
    testWidgets('a phone leaves out the service and intranet cards', (
      tester,
    ) async {
      await pumpDashboard(tester, _phoneSize, platform: SupportPlatform.IOS);

      // `defaultDashboardWidgets` saves both on every platform, so this is the
      // filter doing the work, not the list.
      expect(find.byType(ServiceStatusCard), findsNothing);
      expect(find.byType(IntranetIpCard), findsNothing);
      expect(find.byType(CurrentOutboundCard), findsOneWidget);
      // The startup dots came over from the iOS shell's bar.
      expect(find.byType(IosCoreStatus), findsOneWidget);
      expect(tester.takeException(), isNull);

      await teardown(tester);
    });

    testWidgets('the same two cards stay on Android', (tester) async {
      await pumpDashboard(
        tester,
        _phoneSize,
        platform: SupportPlatform.Android,
      );

      expect(find.byType(ServiceStatusCard), findsOneWidget);
      expect(find.byType(IntranetIpCard), findsOneWidget);

      await teardown(tester);
    });

    testWidgets('a two column window hands the dropped card\'s half over', (
      tester,
    ) async {
      const size = Size(700, 900);
      await pumpDashboard(tester, size, platform: SupportPlatform.IOS);

      expect(find.byType(ServiceStatusCard), findsNothing);
      expect(find.byType(IntranetIpCard), findsNothing);
      // What is left of each pair takes the whole row rather than half of it.
      expect(
        tester.getSize(find.byType(ProfilesCard)).width,
        tester.getSize(find.byType(MemoryInfo)).width,
      );
      expect(tester.takeException(), isNull);

      await teardown(tester);
    });

    testWidgets('a four column window keeps upstream\'s rows minus the two', (
      tester,
    ) async {
      await pumpDashboard(
        tester,
        const Size(1220, 824),
        platform: SupportPlatform.IOS,
      );

      expect(find.byType(ServiceStatusCard), findsNothing);
      expect(find.byType(IntranetIpCard), findsNothing);
      expect(find.byType(ProfilesCard), findsOneWidget);
      expect(find.byType(MemoryInfo), findsOneWidget);
      expect(tester.takeException(), isNull);

      await teardown(tester);
    });
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
    await pumpDashboard(tester, const Size(1220, 824));
    expect(find.byType(StartButton), findsNothing);
    expect(find.byType(NodeSelectorChip), findsNothing);

    await teardown(tester);
  });

  testWidgets('a profile brings the start button to the corner', (
    tester,
  ) async {
    await pumpDashboard(tester, const Size(1220, 824), withProfile: true);

    expect(find.byType(StartButton), findsOneWidget);
    expect(tester.takeException(), isNull);

    await teardown(tester);
  });

  testWidgets('a phone leaves the button to the dock, chip parked', (
    tester,
  ) async {
    await pumpDashboard(tester, _phoneSize, withProfile: true);

    // The page has no dock of its own, and on a phone the shell lays the
    // button out beside one, so the corner draws nothing here.
    expect(find.byType(StartButton), findsNothing);
    expect(find.byType(NodeSelectorChip), findsNothing);
    expect(tester.takeException(), isNull);

    await teardown(tester);
  });

  testWidgets('the panel action leaves the page alone while editing', (
    tester,
  ) async {
    // The editor is the phone's affordance, where the dock seats the button.
    await pumpDashboard(tester, _phoneSize, withProfile: true);

    await tester.tap(find.byTooltip('Edit dashboard'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(StartButton), findsNothing);

    await teardown(tester);
  });

  testWidgets('the action sits over the bottom corner', (tester) async {
    const size = Size(1220, 824);
    await pumpDashboard(tester, size, withProfile: true);

    final button = tester.getRect(find.byType(StartButton));
    expect(button.bottom, lessThanOrEqualTo(size.height));
    expect(button.right, lessThanOrEqualTo(size.width));
    expect(button.right, size.width - 24);
    expect(button.bottom, size.height - 24);

    await teardown(tester);
  });
}
