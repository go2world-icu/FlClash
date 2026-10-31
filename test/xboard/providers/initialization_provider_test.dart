import 'dart:async';

import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/adapter/initialization/sdk_provider.dart';
import 'package:fl_clash/xboard/features/auth/models/auth_state.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/domain_status/models/domain_status_state.dart';
import 'package:fl_clash/xboard/features/domain_status/providers/domain_status_provider.dart';
import 'package:fl_clash/xboard/features/initialization/providers/initialization_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Sdk extends Mock implements XBoardSDK {}

class _Session extends XBoardUserAuthNotifier {
  Completer<void>? restoration;
  int restores = 0;
  int authentications = 0;

  @override
  UserAuthState build() => const UserAuthState(isInitialized: true);

  @override
  Future<void> restoreLocalSession() async {
    restores++;
    await restoration?.future;
  }

  @override
  Future<bool> autoAuth() async {
    authentications++;
    return false;
  }
}

class _Domains extends DomainStatusNotifier {
  int checks = 0;
  bool available = true;

  @override
  DomainStatusState build() => const DomainStatusState();

  @override
  Future<void> checkDomain() async {
    checks++;
    state = available
        ? const DomainStatusState(
            status: DomainStatus.success,
            currentDomain: 'https://panel.invalid',
            isInitialized: true,
          )
        : const DomainStatusState(
            status: DomainStatus.failed,
            errorMessage: 'configuration offline',
          );
  }
}

void main() {
  late _Session session;
  late _Domains domains;
  late ProviderContainer container;
  late Future<XBoardSDK> Function() initializeSdk;
  late int sdkInitializations;

  setUp(() {
    session = _Session();
    domains = _Domains();
    sdkInitializations = 0;
    initializeSdk = () async => _Sdk();
    container = ProviderContainer(
      overrides: [
        xboardUserAuthProvider.overrideWith(() => session),
        domainStatusProvider.overrideWith(() => domains),
        xboardSdkProvider.overrideWith((ref) {
          sdkInitializations++;
          return initializeSdk();
        }),
      ],
    );
  });

  tearDown(() => container.dispose());

  test(
    'startup and refresh join the same operation while local session restores',
    () async {
      final restored = session.restoration = Completer<void>();
      final notifier = container.read(initializationProvider.notifier);
      final first = notifier.initialize();
      final second = notifier.initialize();
      final refreshed = notifier.refresh();
      expect(second, same(first));
      expect(refreshed, same(first));
      await Future<void>.delayed(Duration.zero);
      expect(container.read(initializationProvider).isInitializing, isTrue);
      expect(session.restores, 1);
      expect(domains.checks, 0);

      restored.complete();
      await Future.wait([first, second, refreshed]);
      expect(domains.checks, 1);
      expect(sdkInitializations, 1);
      expect(session.authentications, 1);
      expect(container.read(initializationProvider).isReady, isTrue);
      await notifier.initialize();
      expect(session.restores, 1);
    },
  );

  test(
    'readiness waits for SDK completion and refresh does not replace it',
    () async {
      final ready = Completer<XBoardSDK>();
      initializeSdk = () => ready.future;
      final notifier = container.read(initializationProvider.notifier);
      final pending = notifier.initialize();
      await Future<void>.delayed(Duration.zero);
      expect(container.read(initializationProvider).isInitializing, isTrue);
      expect(container.read(initializationProvider).isReady, isFalse);
      expect(notifier.refresh(), same(pending));
      expect(sdkInitializations, 1);
      expect(session.authentications, 0);

      ready.complete(_Sdk());
      await pending;
      expect(container.read(initializationProvider).isReady, isTrue);
      expect(sdkInitializations, 1);
    },
  );

  test(
    'configuration failure reaches failed state without initializing SDK',
    () async {
      domains.available = false;
      final notifier = container.read(initializationProvider.notifier);
      await expectLater(notifier.initialize(), throwsA(isA<Exception>()));
      final failed = container.read(initializationProvider);
      expect(failed.isFailed, isTrue);
      expect(failed.isInitializing, isFalse);
      expect(failed.errorMessage, contains('configuration offline'));
      expect(domains.checks, 1);
      expect(sdkInitializations, 0);

      domains.available = true;
      await notifier.refresh();
      expect(container.read(initializationProvider).isReady, isTrue);
      expect(container.read(initializationProvider).errorMessage, isNull);
      expect(domains.checks, 2);
      expect(sdkInitializations, 1);
    },
  );

  test('SDK failure can be retried through a new SDK initialization', () async {
    initializeSdk = () => Future.error(StateError('SDK offline'));
    final notifier = container.read(initializationProvider.notifier);
    await expectLater(notifier.initialize(), throwsA(isA<StateError>()));
    expect(container.read(initializationProvider).isFailed, isTrue);

    initializeSdk = () async => _Sdk();
    await notifier.initialize();
    expect(container.read(initializationProvider).isReady, isTrue);
    expect(sdkInitializations, 2);
  });

  test('disposal during restoration does not advance startup', () async {
    final restored = session.restoration = Completer<void>();
    final pending = container
        .read(initializationProvider.notifier)
        .initialize();
    await Future<void>.delayed(Duration.zero);
    container.dispose();
    restored.complete();
    await pending;
    expect(domains.checks, 0);
    expect(sdkInitializations, 0);
  });
}
