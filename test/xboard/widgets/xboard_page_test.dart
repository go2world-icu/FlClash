import 'dart:async';

import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/xboard/adapter/initialization/sdk_provider.dart';
import 'package:fl_clash/xboard/bridge.dart';
import 'package:fl_clash/xboard/features/auth/models/auth_state.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/initialization/initialization.dart';
import 'package:fl_clash/xboard/features/subscription/pages/xboard_home_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/xboard_provider_fakes.dart';
import '../support/xboard_support.dart';

class _Initialization extends XBoardInitializationNotifier {
  Completer<void>? _retry;
  int refreshes = 0;

  @override
  InitializationState build() =>
      const InitializationState(status: InitializationStatus.checkingDomain);

  @override
  Future<void> refresh() {
    refreshes++;
    state = const InitializationState(
      status: InitializationStatus.checkingDomain,
    );
    final retry = _retry = Completer<void>();
    return retry.future;
  }

  void fail(String message) {
    state = InitializationState(
      status: InitializationStatus.failed,
      errorMessage: message,
    );
    _retry?.completeError(StateError(message));
    _retry = null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => AppLocalizations.load(const Locale('en')));

  late _Initialization initialization;
  late int sdkReads;

  Future<void> pumpPage(WidgetTester tester) async {
    initialization = _Initialization();
    sdkReads = 0;
    await pumpXboard(
      tester,
      const XBoardPage(),
      overrides: [
        ...xboardBaseOverrides(ready: false),
        xboardUserProvider.overrideWith(
          () => FakeUserAuthNotifier(
            const UserAuthState(isAuthenticated: true, isInitialized: true),
          ),
        ),
        initializationProvider.overrideWith(() => initialization),
        xboardSdkProvider.overrideWith((ref) {
          sdkReads++;
          throw StateError('SDK is not ready');
        }),
      ],
      settle: false,
    );
  }

  testWidgets(
    'a restored account waits for initialization before rendering its home',
    (tester) async {
      await pumpPage(tester);
      final strings = AppLocalizations.of(
        tester.element(find.byType(XBoardPage)),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(strings.loading), findsOneWidget);
      expect(find.byType(XBoardHomePage), findsNothing);
      expect(sdkReads, 0);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'failure replaces loading with details and retry waits for readiness',
    (tester) async {
      await pumpPage(tester);
      final strings = AppLocalizations.of(
        tester.element(find.byType(XBoardPage)),
      );
      initialization.fail('Configuration request timed out');
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Configuration request timed out'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, strings.retry), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, strings.retry));
      await tester.pump();
      expect(initialization.refreshes, 1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Configuration request timed out'), findsNothing);
      expect(find.byType(XBoardHomePage), findsNothing);
      expect(sdkReads, 0);

      initialization.fail('Configuration source unavailable');
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Configuration source unavailable'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, strings.retry), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
