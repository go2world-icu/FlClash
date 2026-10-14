import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:fl_clash/xboard/features/invite/dialogs/commission_history_dialog.dart';
import 'package:fl_clash/xboard/features/invite/dialogs/withdraw_dialog.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:fl_clash/xboard/features/invite/widgets/commission_history_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/error_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/invite_rules_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/invite_stats_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/stat_item_widget.dart';
import 'package:fl_clash/xboard/features/invite/widgets/wallet_details_card.dart';
import 'package:fl_clash/icons/icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/xboard_support.dart';
import '../support/xboard_provider_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => AppLocalizations.load(const Locale('en')));

  DomainInvite invite({double available = 12.5, double total = 99}) =>
      DomainInvite(
        codes: const [DomainInviteCode(code: 'CODE', status: 0)],
        stats: InviteStats(
          invitedCount: 7,
          commissionRate: 20,
          availableCommission: available,
          totalCommission: total,
          pendingCommission: 1.0,
        ),
      );

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    InviteState? state,
    bool settle = true,
  }) async {
    await pumpXboard(
      tester,
      Scaffold(body: SingleChildScrollView(child: child)),
      overrides: [
        ...xboardBaseOverrides(),
        inviteProvider.overrideWith(
          () => FakeInviteNotifier(state ?? InviteState(inviteData: invite())),
        ),
      ],
      textScale: 0.7,
      settle: settle,
    );
  }

  group('StatItemWidget', () {
    testWidgets('renders title and value', (tester) async {
      await pumpXboard(
        tester,
        const Scaffold(
          body: StatItemWidget(
            title: 'Invites',
            value: '3',
            icon: AppGlyphs.people,
          ),
        ),
      );
      expect(find.text('Invites'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });
  });

  group('InviteStatsCard', () {
    testWidgets('renders the stat row', (tester) async {
      await pump(tester, const InviteStatsCard());
      expect(find.text('7'), findsOneWidget);
      expect(find.text('20.0%'), findsOneWidget);
      expect(find.text('¥99.00'), findsOneWidget);
    });

    testWidgets('shows a spinner while loading without data', (tester) async {
      await pump(
        tester,
        const InviteStatsCard(),
        state: const InviteState(isLoading: true),
        settle: false,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('WalletDetailsCard', () {
    testWidgets('renders balances and opens the withdraw dialog', (
      tester,
    ) async {
      await pump(tester, const WalletDetailsCard());
      expect(find.text('¥12.50'), findsOneWidget);
      await tester.tap(find.text('提现'));
      await tester.pumpAndSettle();
      expect(find.byType(WithdrawDialog), findsOneWidget);
    });

    testWidgets('shows a spinner while loading without data', (tester) async {
      await pump(
        tester,
        const WalletDetailsCard(),
        state: const InviteState(isLoading: true),
        settle: false,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('CommissionHistoryCard', () {
    testWidgets('shows the empty state', (tester) async {
      await pump(tester, const CommissionHistoryCard());
      expect(find.textContaining('commission'), findsWidgets);
    });

    testWidgets('renders history rows and the withdraw action', (tester) async {
      await pump(
        tester,
        const CommissionHistoryCard(),
        state: InviteState(
          inviteData: invite(),
          commissionHistory: [
            DomainCommission(
              id: 1,
              tradeNo: 'T1',
              amount: 3.5,
              createdAt: DateTime(2024, 2, 3),
            ),
          ],
        ),
      );
      expect(find.text('¥3.50'), findsOneWidget);
      expect(find.textContaining('T1'), findsOneWidget);
    });

    testWidgets('shows the view-history action with 5+ records', (
      tester,
    ) async {
      await pump(
        tester,
        const CommissionHistoryCard(),
        state: InviteState(
          inviteData: invite(),
          commissionHistory: List.generate(
            5,
            (i) => DomainCommission(
              id: i,
              tradeNo: 'T$i',
              amount: 1,
              createdAt: DateTime(2024, 1, i + 1),
            ),
          ),
        ),
      );
      await tester.tap(find.textContaining('History').last);
      await tester.pumpAndSettle();
      expect(find.byType(CommissionHistoryDialog), findsOneWidget);
    });
  });

  group('ErrorCard', () {
    testWidgets('renders nothing without an error', (tester) async {
      await pump(tester, const ErrorCard());
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('renders the error and clears it', (tester) async {
      await pump(
        tester,
        const ErrorCard(),
        state: const InviteState(errorMessage: 'boom'),
      );
      expect(find.text('boom'), findsOneWidget);
    });
  });

  group('InviteRulesCard', () {
    testWidgets('renders the rules list', (tester) async {
      await pump(tester, const InviteRulesCard());
      expect(find.byType(Card), findsOneWidget);
    });
  });
}
