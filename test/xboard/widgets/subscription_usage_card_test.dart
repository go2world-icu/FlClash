import 'package:fl_clash/models/models.dart' as fl_models;
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:fl_clash/xboard/features/auth/models/auth_state.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/subscription/widgets/subscription_usage_card.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/xboard_support.dart';
import '../support/xboard_provider_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => AppLocalizations.load(const Locale('en')));

  final subscription = DomainSubscription(
    subscribeUrl: 'https://s',
    email: 'a@b.com',
    uuid: 'u',
    planId: 1,
    planName: 'Gold Plan',
    transferLimit: 1000,
    uploadedBytes: 100,
    downloadedBytes: 100,
    expiredAt: DateTime.now().add(const Duration(days: 365)),
  );

  Future<void> pumpCard(
    WidgetTester tester,
    SubscriptionUsageCard card, {
    UserAuthState? auth,
    bool settle = true,
  }) async {
    await pumpXboard(
      tester,
      Scaffold(body: card),
      overrides: [
        ...xboardBaseOverrides(),
        if (auth != null)
          xboardUserProvider.overrideWith(() => FakeUserAuthNotifier(auth)),
      ],
      settle: settle,
    );
  }

  group('SubscriptionUsageCard', () {
    testWidgets('shows the empty card when nothing is known', (tester) async {
      await pumpCard(tester, const SubscriptionUsageCard());
      expect(find.text('Gold Plan'), findsNothing);
    });

    // The usage and status branches paint a `ShapeDecoration` with a gradient.
    // ShapeDecoration forbids also passing `color`, so these render only if the
    // decoration stays gradient-only.
    void expectRenders(WidgetTester tester) {
      expect(tester.takeException(), isNull);
      expect(find.byType(Text), findsWidgets);
    }

    testWidgets('renders the usage branch', (tester) async {
      await pumpCard(
        tester,
        SubscriptionUsageCard(subscriptionInfo: subscription),
      );
      expectRenders(tester);
    });

    testWidgets('renders the user-transfer-limit usage branch', (tester) async {
      await pumpCard(
        tester,
        SubscriptionUsageCard(
          userInfo: DomainUser(
            email: 'a@b.com',
            uuid: 'u',
            avatarUrl: '',
            transferLimit: 2048,
            uploadedBytes: 0,
            downloadedBytes: 0,
            balanceInCents: 0,
            commissionBalanceInCents: 0,
          ),
        ),
      );
      expectRenders(tester);
    });

    testWidgets('renders the near-exhausted renew branch', (tester) async {
      await pumpCard(
        tester,
        const SubscriptionUsageCard(
          profileSubscriptionInfo: fl_models.SubscriptionInfo(
            upload: 90,
            download: 10,
            total: 100,
          ),
        ),
      );
      expectRenders(tester);
    });

    testWidgets('renders the expired status branch', (tester) async {
      await pumpCard(
        tester,
        SubscriptionUsageCard(
          subscriptionInfo: subscription,
          profileSubscriptionInfo: fl_models.SubscriptionInfo(
            upload: 0,
            download: 0,
            total: 1000,
            expire: DateTime.now()
                    .subtract(const Duration(days: 2))
                    .millisecondsSinceEpoch ~/
                1000,
          ),
        ),
        auth: const UserAuthState(isAuthenticated: true, isInitialized: true),
      );
      expectRenders(tester);
    });

    testWidgets('renders the no-subscription status branch', (tester) async {
      await pumpCard(
        tester,
        SubscriptionUsageCard(subscriptionInfo: subscription),
        auth: const UserAuthState(isAuthenticated: true, isInitialized: true),
      );
      expectRenders(tester);
    });
  });
}
