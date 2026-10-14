import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/xboard/features/subscription/services/subscription_status_service.dart';
import 'package:fl_clash/xboard/features/subscription/widgets/subscription_status_dialog.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/xboard_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => AppLocalizations.load(const Locale('en')));

  Future<void> pumpDialog(
    WidgetTester tester,
    SubscriptionStatusResult result, {
    VoidCallback? onPurchase,
    VoidCallback? onRefresh,
  }) async {
    await pumpXboard(
      tester,
      Scaffold(
        body: SubscriptionStatusDialog(
          statusResult: result,
          onPurchase: onPurchase,
          onRefresh: onRefresh,
        ),
      ),
    );
  }

  SubscriptionStatusResult resultOf(SubscriptionStatusType type) {
    return SubscriptionStatusResult(
      type: type,
      messageBuilder: (_) => 'message',
      detailMessageBuilder: (_) => 'detail',
      expiredAt: type == SubscriptionStatusType.expired ? DateTime.now() : null,
    );
  }

  group('SubscriptionStatusDialog', () {
    testWidgets('renders the no-subscription branch with the feature list', (
      tester,
    ) async {
      await pumpDialog(tester, resultOf(SubscriptionStatusType.noSubscription));
      expect(find.text('detail'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('renders the expired branch with a refresh button', (
      tester,
    ) async {
      await pumpDialog(tester, resultOf(SubscriptionStatusType.expired));
      expect(find.byType(TextButton), findsWidgets);
    });

    testWidgets('renders the exhausted branch', (tester) async {
      await pumpDialog(tester, resultOf(SubscriptionStatusType.exhausted));
      expect(find.text('detail'), findsOneWidget);
    });

    testWidgets('renders the valid default branch', (tester) async {
      await pumpDialog(tester, resultOf(SubscriptionStatusType.valid));
      expect(find.text('detail'), findsOneWidget);
    });

    testWidgets('invokes onPurchase when the primary button is tapped', (
      tester,
    ) async {
      var purchased = false;
      await pumpDialog(
        tester,
        resultOf(SubscriptionStatusType.noSubscription),
        onPurchase: () => purchased = true,
      );
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(purchased, isTrue);
    });

    testWidgets('invokes onRefresh when refresh is tapped', (tester) async {
      var refreshed = false;
      await pumpDialog(
        tester,
        resultOf(SubscriptionStatusType.expired),
        onRefresh: () => refreshed = true,
      );
      // First TextButton in the expired branch is "refresh".
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();
      expect(refreshed, isTrue);
    });

    testWidgets('falls back to the message when there is no detail', (
      tester,
    ) async {
      await pumpDialog(
        tester,
        SubscriptionStatusResult(
          type: SubscriptionStatusType.valid,
          messageBuilder: (_) => 'only-message',
        ),
      );
      expect(find.text('only-message'), findsOneWidget);
    });
  });
}
