import 'dart:async';

import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/adapter/board_auth_gateway.dart';
import 'package:fl_clash/xboard/adapter/initialization/sdk_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Auth extends Mock implements AuthApi {}

class _Sdk extends Mock implements XBoardSDK {}

void main() {
  test(
    'auth waits for initialization and reads the current SDK after refresh',
    () async {
      final ready = Completer<XBoardSDK>();
      final first = _Sdk();
      final next = _Sdk();
      final firstAuth = _Auth();
      final nextAuth = _Auth();
      when(() => first.auth).thenReturn(firstAuth);
      when(() => next.auth).thenReturn(nextAuth);
      when(
        () => firstAuth.sendEmailVerifyCode(
          'user@example.com',
          isPasswordReset: true,
        ),
      ).thenAnswer((_) async => true);
      when(
        () => nextAuth.sendEmailVerifyCode(
          'user@example.com',
          isPasswordReset: true,
        ),
      ).thenAnswer((_) async => false);
      var initialization = ready.future;
      final container = ProviderContainer(
        overrides: [xboardSdkProvider.overrideWith((ref) => initialization)],
      );
      addTearDown(container.dispose);
      final gateway = container.read(boardAuthGatewayProvider);
      final pending = gateway.sendEmailVerifyCode(
        'user@example.com',
        isPasswordReset: true,
      );
      verifyNever(
        () => firstAuth.sendEmailVerifyCode(any(), isPasswordReset: true),
      );
      ready.complete(first);
      expect(await pending, isTrue);

      initialization = Future.value(next);
      container.invalidate(xboardSdkProvider);
      expect(
        await gateway.sendEmailVerifyCode(
          'user@example.com',
          isPasswordReset: true,
        ),
        isFalse,
      );
    },
  );

  test('SDK initialization failure is delivered to the caller', () async {
    final container = ProviderContainer(
      overrides: [
        xboardSdkProvider.overrideWith(
          (ref) => throw StateError('unavailable'),
        ),
      ],
    );
    addTearDown(container.dispose);
    await expectLater(
      container
          .read(boardAuthGatewayProvider)
          .register('user@example.com', 'secret'),
      throwsA(isA<StateError>()),
    );
  });

  test(
    'registration options and password-reset failures reach the caller',
    () async {
      final auth = _Auth();
      final gateway = BoardAuthGateway(() async => auth);
      when(
        () => auth.register(
          'user@example.com',
          'secret',
          inviteCode: 'invite',
          emailCode: '1234',
        ),
      ).thenAnswer((_) async => false);
      expect(
        await gateway.register(
          'user@example.com',
          'secret',
          inviteCode: 'invite',
          emailCode: '1234',
        ),
        isFalse,
      );
      when(
        () => auth.forgotPassword('user@example.com', '1234', 'new secret'),
      ).thenThrow(StateError('request failed'));
      await expectLater(
        gateway.forgotPassword('user@example.com', '1234', 'new secret'),
        throwsA(isA<StateError>()),
      );
    },
  );
}
