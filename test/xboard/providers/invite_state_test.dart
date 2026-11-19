import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:board_sdk/src/adapters/v2board/v2board_invite_adapter.dart';
import 'package:board_sdk/src/core/http/http_service.dart';
import 'package:board_sdk/src/panels/v2board/apis/v2board_invite_api.dart';
import 'package:fl_clash/xboard/adapter/initialization/sdk_provider.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class _Http extends Mock implements HttpService {}

class _Sdk extends Mock implements XBoardSDK {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'panel status zero stays available after loading and generating',
    () async {
      final http = _Http();
      final sdk = _Sdk();
      var generated = false;
      Map<String, dynamic> code(String value, int status) => {
        'user_id': 1,
        'code': value,
        'pv': 0,
        'status': status,
        'created_at': 1700000000,
        'updated_at': 1700000000,
      };
      when(() => http.getRequest('/api/v1/user/invite/fetch')).thenAnswer(
        (_) async => {
          'data': {
            'codes': [
              if (generated) code('NEW', 0),
              code('EXISTING', 0),
              code('USED', 1),
            ],
            'stat': [2, 1000, 200, 20, 800],
          },
        },
      );
      when(() => http.getRequest('/api/v1/user/invite/save')).thenAnswer((
        _,
      ) async {
        generated = true;
        return {'data': true};
      });
      when(
        () => sdk.invite,
      ).thenReturn(V2BoardInviteAdapter(V2BoardInviteApi(http)));
      final container = ProviderContainer(
        overrides: [xboardSdkProvider.overrideWith((_) async => sdk)],
      );
      addTearDown(container.dispose);
      final notifier = container.read(inviteProvider.notifier);
      await notifier.loadInviteData();
      final loaded = container.read(inviteProvider);
      expect(loaded.inviteData!.codes.first.isAvailable, isTrue);
      expect(loaded.inviteData!.codes.last.isAvailable, isFalse);
      expect(loaded.availableCommission, 8);
      expect((await notifier.generateInviteCode())!.code, 'NEW');
      expect(
        container.read(inviteProvider).inviteData!.codes.first.code,
        'NEW',
      );
      expect(container.read(inviteProvider).isGenerating, isFalse);
      when(
        () => http.getRequest('/api/v1/user/invite/save'),
      ).thenThrow(Exception('generation refused'));
      expect(await notifier.generateInviteCode(), isNull);
      expect(container.read(inviteProvider).isGenerating, isFalse);
      expect(
        container.read(inviteProvider).errorMessage,
        contains('generation refused'),
      );
      expect(
        container.read(inviteProvider).inviteData!.codes.first.code,
        'NEW',
      );
    },
  );

  DomainInvite invite({
    int invitedCount = 0,
    double total = 0,
    double pending = 0,
    double available = 0,
    double rate = 0,
    int activeCodes = 0,
  }) {
    return DomainInvite(
      codes: List.generate(
        activeCodes,
        (i) => DomainInviteCode(code: 'c$i', status: 0),
      ),
      stats: InviteStats(
        invitedCount: invitedCount,
        totalCommission: total,
        pendingCommission: pending,
        availableCommission: available,
        commissionRate: rate,
      ),
    );
  }

  group('InviteState', () {
    test('defaults report no data', () {
      const state = InviteState();
      expect(state.hasInviteData, isFalse);
      expect(state.hasActiveCodes, isFalse);
      expect(state.totalInvites, 0);
      expect(state.walletBalance, 0);
    });

    test('exposes invite stats through getters', () {
      final state = InviteState(
        inviteData: invite(
          invitedCount: 4,
          total: 100,
          pending: 10,
          available: 30,
          rate: 0.2,
          activeCodes: 2,
        ),
      );
      expect(state.hasInviteData, isTrue);
      expect(state.hasActiveCodes, isTrue);
      expect(state.totalInvites, 4);
      expect(state.totalCommission, 100);
      expect(state.pendingCommission, 10);
      expect(state.availableCommission, 30);
      expect(state.commissionRate, 0.2);
    });

    test('hasActiveCodes is false when every code is used', () {
      final state = InviteState(
        inviteData: DomainInvite(
          codes: const [DomainInviteCode(code: 'used', status: 1)],
          stats: const InviteStats(),
        ),
      );
      expect(state.hasActiveCodes, isFalse);
    });

    test('formats commission amounts below and above 1000', () {
      final small = InviteState(
        inviteData: invite(total: 12.345, pending: 1.5, available: 5),
      );
      expect(small.formattedCommission, '¥12.35');
      expect(small.formattedPendingCommission, '¥1.50');
      expect(small.formattedAvailableCommission, '¥5.00');

      final big = InviteState(inviteData: invite(total: 2500, available: 1000));
      expect(big.formattedCommission, '¥2.5k');
      expect(big.formattedAvailableCommission, '¥1.0k');
    });

    test('wallet balance derives from the user cents', () {
      final state = InviteState(
        userInfo: DomainUser(
          email: 'a@b.com',
          uuid: 'u',
          avatarUrl: '',
          transferLimit: 0,
          uploadedBytes: 0,
          downloadedBytes: 0,
          balanceInCents: 1234,
          commissionBalanceInCents: 0,
        ),
      );
      expect(state.walletBalance, 12.34);
      expect(state.formattedWalletBalance, '¥12.34');
    });

    test('copyWith replaces fields and clears errors', () {
      const state = InviteState(errorMessage: 'boom');
      final cleared = state.copyWith(errorMessage: null);
      expect(cleared.errorMessage, isNull);
      final withHistory = state.copyWith(
        commissionHistory: [
          DomainCommission(
            id: 1,
            tradeNo: 'T',
            amount: 1,
            createdAt: DateTime(2024),
          ),
        ],
        currentHistoryPage: 3,
        hasMoreHistory: false,
      );
      expect(withHistory.commissionHistory.length, 1);
      expect(withHistory.currentHistoryPage, 3);
      expect(withHistory.hasMoreHistory, isFalse);
    });
  });
}
