import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DomainUser makeUser({
    int transferLimit = 1000,
    int uploaded = 100,
    int downloaded = 200,
    DateTime? expiredAt,
    int balanceInCents = 500,
    int commissionBalanceInCents = 250,
  }) {
    return DomainUser(
      email: 'a@b.com',
      uuid: 'u',
      avatarUrl: '',
      transferLimit: transferLimit,
      uploadedBytes: uploaded,
      downloadedBytes: downloaded,
      balanceInCents: balanceInCents,
      commissionBalanceInCents: commissionBalanceInCents,
      expiredAt: expiredAt,
    );
  }

  group('DomainUser', () {
    test('computes traffic totals and remaining', () {
      final user = makeUser();
      expect(user.totalUsedBytes, 300);
      expect(user.remainingBytes, 700);
      expect(user.usagePercentage, 30.0);
      expect(user.isTrafficExhausted, isFalse);
    });

    test('clamps remaining at zero when over the limit', () {
      final user = makeUser(transferLimit: 100, uploaded: 80, downloaded: 80);
      expect(user.remainingBytes, 0);
      expect(user.usagePercentage, 100.0);
      expect(user.isTrafficExhausted, isTrue);
    });

    test('usage percentage is zero without a limit', () {
      expect(makeUser(transferLimit: 0).usagePercentage, 0);
    });

    test('formats bytes across units', () {
      final user = makeUser();
      expect(user.formatBytes(512), '512 B');
      expect(user.formatBytes(2048), '2.00 KB');
      expect(user.formatBytes(2 * 1024 * 1024), '2.00 MB');
      expect(user.formatBytes(2 * 1024 * 1024 * 1024), '2.00 GB');
      expect(user.remainingTraffic, isNotEmpty);
      expect(user.usedTraffic, isNotEmpty);
      expect(user.totalTraffic, isNotEmpty);
    });

    test('converts balances to yuan', () {
      final user = makeUser();
      expect(user.balanceInYuan, 5.0);
      expect(user.commissionBalanceInYuan, 2.5);
    });

    test('expiry getters react to the expiration date', () {
      final future = makeUser(
        expiredAt: DateTime.now().add(const Duration(days: 3)),
      );
      expect(future.isExpired, isFalse);
      expect(future.isExpiringSoon, isTrue);

      final past = makeUser(
        expiredAt: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(past.isExpired, isTrue);

      final farFuture = makeUser(
        expiredAt: DateTime.now().add(const Duration(days: 30)),
      );
      expect(farFuture.isExpiringSoon, isFalse);

      expect(makeUser().isExpired, isFalse);
      expect(makeUser().isExpiringSoon, isFalse);
    });

    test('fromJson round-trips through toJson', () {
      final user = DomainUser.fromJson(makeUser().toJson());
      expect(user.email, 'a@b.com');
      expect(user.transferLimit, 1000);
    });
  });

  group('DomainSubscription', () {
    DomainSubscription make({
      int transferLimit = 1000,
      int uploaded = 400,
      int downloaded = 500,
      DateTime? expiredAt,
    }) {
      return DomainSubscription(
        subscribeUrl: 'https://s',
        email: 'a@b.com',
        uuid: 'u',
        planId: 1,
        transferLimit: transferLimit,
        uploadedBytes: uploaded,
        downloadedBytes: downloaded,
        expiredAt: expiredAt,
      );
    }

    test('computes usage and remaining', () {
      final sub = make();
      expect(sub.totalUsedBytes, 900);
      expect(sub.remainingBytes, 100);
      expect(sub.usagePercentage, 90.0);
      expect(sub.isTrafficExhausted, isFalse);
    });

    test('exhausted when used reaches the limit', () {
      final sub = make(transferLimit: 100, uploaded: 60, downloaded: 60);
      expect(sub.remainingBytes, 0);
      expect(sub.isTrafficExhausted, isTrue);
    });

    test('daysRemaining and expiring soon', () {
      // daysRemaining truncates, so keep a margin: `now + 3d` alone reads back
      // as 2 unless both DateTime.now() calls land in the same millisecond.
      final sub = make(
        expiredAt: DateTime.now().add(const Duration(days: 3, hours: 12)),
      );
      expect(sub.daysRemaining, 3);
      expect(sub.isExpiringSoon, isTrue);
      expect(make().daysRemaining, isNull);
      expect(make().isExpiringSoon, isFalse);
    });

    test('formatted traffic getters', () {
      final sub = make();
      expect(sub.formattedRemainingTraffic, isNotEmpty);
      expect(sub.formattedUsedTraffic, isNotEmpty);
      expect(sub.formattedTotalTraffic, isNotEmpty);
      expect(sub.formattedUploadedTraffic, isNotEmpty);
      expect(sub.formattedDownloadedTraffic, isNotEmpty);
      expect(sub.formatBytes(2048), '2.00 KB');
    });

    test('fromJson round-trips', () {
      final sub = DomainSubscription.fromJson(make().toJson());
      expect(sub.subscribeUrl, 'https://s');
    });
  });

  group('DomainNotice', () {
    test('hasImages and isNew', () {
      final fresh = DomainNotice(
        id: 1,
        title: 't',
        content: 'c',
        createdAt: DateTime.now(),
        imageUrls: const ['https://img'],
      );
      expect(fresh.hasImages, isTrue);
      expect(fresh.isNew, isTrue);

      final old = DomainNotice(
        id: 2,
        title: 't',
        content: 'c',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );
      expect(old.hasImages, isFalse);
      expect(old.isNew, isFalse);
    });

    test('fromJson round-trips', () {
      final notice = DomainNotice.fromJson({
        'id': 1,
        'title': 't',
        'content': 'c',
        'imageUrls': const <String>[],
        'tags': const <String>[],
        'isVisible': true,
        'createdAt': DateTime.now().toIso8601String(),
      });
      expect(notice.id, 1);
      expect(notice.title, 't');
    });
  });

  group('DomainInvite', () {
    test('invite code state getters', () {
      const used = DomainInviteCode(code: 'a', status: 1);
      const available = DomainInviteCode(code: 'b', status: 0);
      expect(used.isUsed, isTrue);
      expect(used.isAvailable, isFalse);
      expect(available.isUsed, isFalse);
      expect(available.isAvailable, isTrue);
    });

    test('fromJson round-trips an invite', () {
      final invite = DomainInvite.fromJson({
        'codes': [
          {'code': 'a', 'status': 1, 'metadata': const <String, dynamic>{}},
        ],
        'stats': const {
          'invitedCount': 2,
          'commissionRate': 0.1,
          'pendingCommission': 1.0,
          'availableCommission': 2.0,
          'totalCommission': 3.0,
          'metadata': <String, dynamic>{},
        },
        'metadata': const <String, dynamic>{},
      });
      expect(invite.codes.single.isUsed, isTrue);
      expect(invite.stats.invitedCount, 2);
    });

    test('commission fromJson', () {
      final commission = DomainCommission.fromJson({
        'id': 1,
        'tradeNo': 'T',
        'amount': 9.9,
        'createdAt': DateTime.now().toIso8601String(),
      });
      expect(commission.amount, 9.9);
      expect(commission.tradeNo, 'T');
    });
  });
}
