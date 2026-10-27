import 'dart:convert';

import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:fl_clash/xboard/services/storage/xboard_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/xboard_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('XBoardStorageService', () {
    late FakeStorage fake;
    late XBoardStorageService service;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      fake = FakeStorage();
      service = XBoardStorageService(fake);
    });

    test('saves and reads the user email', () async {
      await service.saveUserEmail('a@b.com');
      expect((await service.getUserEmail()).dataOrNull, 'a@b.com');
    });

    test('round-trips the domain user', () async {
      final user = DomainUser(
        email: 'a@b.com',
        uuid: 'uuid',
        avatarUrl: '',
        transferLimit: 100,
        uploadedBytes: 1,
        downloadedBytes: 2,
        balanceInCents: 0,
        commissionBalanceInCents: 0,
      );
      expect((await service.saveDomainUser(user)).dataOrNull, isTrue);
      final restored = (await service.getDomainUser()).dataOrNull;
      expect(restored!.email, 'a@b.com');
      expect(restored.uuid, 'uuid');
    });

    test('getDomainUser returns null when unset', () async {
      expect((await service.getDomainUser()).dataOrNull, isNull);
    });

    test('getDomainUser reports a parse failure on corrupt json', () async {
      fake.cache['xboard_domain_user'] = '{not json}';
      final result = await service.getDomainUser();
      expect(result.isFailure, isTrue);
      expect(result.exceptionOrNull!.code, 'PARSE_ERROR');
    });

    test('round-trips the domain subscription', () async {
      final sub = DomainSubscription(
        subscribeUrl: 'https://s',
        email: 'a@b.com',
        uuid: 'uuid',
        planId: 1,
        transferLimit: 100,
        uploadedBytes: 1,
        downloadedBytes: 2,
      );
      expect((await service.saveDomainSubscription(sub)).dataOrNull, isTrue);
      expect(
        (await service.getDomainSubscription()).dataOrNull!.subscribeUrl,
        'https://s',
      );
    });

    test('getDomainSubscription returns null when unset', () async {
      expect((await service.getDomainSubscription()).dataOrNull, isNull);
    });

    test(
      'getDomainSubscription reports a parse failure on corrupt json',
      () async {
        fake.cache['xboard_domain_subscription'] = '{not json}';
        final result = await service.getDomainSubscription();
        expect(result.isFailure, isTrue);
        expect(result.exceptionOrNull!.code, 'PARSE_ERROR');
      },
    );

    test('clears auth data', () async {
      await service.saveUserEmail('a@b.com');
      await service.saveDomainUser(
        DomainUser(
          email: 'a@b.com',
          uuid: 'u',
          avatarUrl: '',
          transferLimit: 0,
          uploadedBytes: 0,
          downloadedBytes: 0,
          balanceInCents: 0,
          commissionBalanceInCents: 0,
        ),
      );
      final result = await service.clearAuthData();
      expect(result.dataOrNull, isTrue);
      expect((await service.getUserEmail()).dataOrNull, isNull);
    });

    test('tracks the TUN first-use flag', () async {
      expect((await service.hasTunFirstUseShown()).dataOrNull, isFalse);
      await service.markTunFirstUseShown();
      expect((await service.hasTunFirstUseShown()).dataOrNull, isTrue);
    });

    test('saves and reads credentials', () async {
      await service.saveCredentials('a@b.com', 'pw', true);
      final creds = (await service.getSavedCredentials()).dataOrNull!;
      expect(creds['email'], 'a@b.com');
      expect(creds['password'], 'pw');
      expect(creds['rememberPassword'], isTrue);
      expect(await service.getSavedEmail(), 'a@b.com');
      expect(await service.getSavedPassword(), 'pw');
      expect(await service.getRememberPassword(), isTrue);
    });

    test('does not persist the password when remember is off', () async {
      await service.saveCredentials('a@b.com', 'pw', false);
      expect(await service.getSavedPassword(), '');
      expect(await service.getRememberPassword(), isFalse);
    });

    test('clears saved credentials', () async {
      await service.saveCredentials('a@b.com', 'pw', true);
      await service.clearSavedCredentials();
      expect(await service.getSavedEmail(), isNull);
      expect(await service.getRememberPassword(), isFalse);
    });

    test('getDomainUser round-trips through json', () async {
      final user = DomainUser(
        email: 'e',
        uuid: 'u',
        avatarUrl: 'a',
        transferLimit: 5,
        uploadedBytes: 1,
        downloadedBytes: 1,
        balanceInCents: 10,
        commissionBalanceInCents: 2,
      );
      fake.cache['xboard_domain_user'] = jsonEncode(user.toJson());
      expect((await service.getDomainUser()).dataOrNull!.balanceInCents, 10);
    });
  });
}
