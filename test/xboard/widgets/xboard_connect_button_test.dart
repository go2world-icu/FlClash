import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/xboard/features/subscription/widgets/xboard_connect_button.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/xboard_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => AppLocalizations.load(const Locale('en')));

  final profile = Profile(id: 1, autoUpdateDuration: Duration.zero);

  Future<void> pump(WidgetTester tester, {bool floating = false}) async {
    await pumpXboard(
      tester,
      Scaffold(
        body: Center(child: XBoardConnectButton(isFloating: floating)),
      ),
      overrides: [
        ...xboardBaseOverrides(),
        initProvider.overrideWithBuild((_, _) => true),
        currentProfileProvider.overrideWithValue(profile),
      ],
    );
  }

  group('XBoardConnectButton', () {
    testWidgets('renders nothing before init/profile is ready', (tester) async {
      await pumpXboard(
        tester,
        const Scaffold(body: XBoardConnectButton()),
        overrides: [
          ...xboardBaseOverrides(),
          initProvider.overrideWithBuild((_, _) => false),
          currentProfileProvider.overrideWithValue(null),
        ],
      );
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('renders the inline start button', (tester) async {
      await pump(tester);
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('renders the floating button', (tester) async {
      await pump(tester, floating: true);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
