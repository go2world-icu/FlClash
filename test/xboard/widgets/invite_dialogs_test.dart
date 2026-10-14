import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:fl_clash/xboard/features/invite/dialogs/commission_history_dialog.dart';
import 'package:fl_clash/xboard/features/invite/dialogs/withdraw_dialog.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/xboard_support.dart';
import '../support/xboard_provider_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => AppLocalizations.load(const Locale('en')));

  DomainInvite inviteWith({double available = 12.5}) => DomainInvite(
    codes: const [DomainInviteCode(code: 'ABC', status: 0)],
    stats: InviteStats(
      invitedCount: 3,
      availableCommission: available,
      totalCommission: 20,
      pendingCommission: 4,
    ),
  );

  group('WithdrawDialog', () {
    Future<void> pump(WidgetTester tester, {InviteState? state}) async {
      await pumpXboard(
        tester,
        Scaffold(body: WithdrawDialog()),
        overrides: [
          ...xboardBaseOverrides(),
          inviteProvider.overrideWith(
            () => FakeInviteNotifier(
              state ?? InviteState(inviteData: inviteWith()),
            ),
          ),
        ],
      );
    }

    testWidgets('shows the available amount and form', (tester) async {
      await pump(tester);
      expect(find.textContaining('12.50'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('selects a withdrawal method', (tester) async {
      await pump(tester);
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('银行卡').last);
      await tester.pumpAndSettle();
      expect(find.text('银行卡'), findsOneWidget);
    });

    testWidgets('warns when submitting without a method', (tester) async {
      await pump(tester);
      await tester.tap(find.text('提交申请'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('cancels the dialog', (tester) async {
      await pump(tester);
      await tester.tap(
        find.text(
          AppLocalizations.of(
            tester.element(find.byType(WithdrawDialog)),
          ).cancel,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(WithdrawDialog), findsNothing);
    });
  });

  group('CommissionHistoryDialog', () {
    Future<void> pump(
      WidgetTester tester, {
      List<DomainCommission> history = const [],
    }) async {
      await pumpXboard(
        tester,
        Scaffold(body: CommissionHistoryDialog()),
        overrides: [
          ...xboardBaseOverrides(),
          inviteProvider.overrideWith(
            () => FakeInviteNotifier(
              InviteState(inviteData: inviteWith(), commissionHistory: history),
            ),
          ),
        ],
      );
    }

    testWidgets('shows the empty state', (tester) async {
      await pump(tester);
      expect(find.textContaining('0'), findsWidgets);
    });

    testWidgets('renders commission rows', (tester) async {
      await pump(
        tester,
        history: [
          DomainCommission(
            id: 1,
            tradeNo: 'TRADE-1',
            amount: 8.88,
            createdAt: DateTime(2024, 5, 6),
          ),
        ],
      );
      expect(find.text('¥8.88'), findsOneWidget);
      expect(find.textContaining('TRADE-1'), findsOneWidget);
      expect(find.textContaining('2024-05-06'), findsOneWidget);
    });
  });
}
