import 'dart:async';

import 'package:fl_clash/xboard/features/domain_status/models/domain_status_state.dart';
import 'package:fl_clash/xboard/features/domain_status/providers/domain_status_provider.dart';
import 'package:fl_clash/xboard/features/domain_status/services/domain_status_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _DomainService extends DomainStatusService {
  Completer<void>? initialization;
  StateError? initializationError;
  int initializations = 0;
  int checks = 0;
  bool available = true;

  @override
  Future<void> initialize() async {
    initializations++;
    if (initializationError != null) throw initializationError!;
    await initialization?.future;
  }

  @override
  Future<Map<String, dynamic>> checkDomainStatus() async {
    checks++;
    return {
      'success': available,
      'domain': available ? 'https://panel.invalid' : null,
      'latency': 10,
      'availableDomains': ['https://panel.invalid'],
      'message': available ? null : 'No reachable panel',
    };
  }

  @override
  void dispose() {}
}

void main() {
  late _DomainService service;
  late ProviderContainer container;

  setUp(() {
    service = _DomainService();
    container = ProviderContainer(
      overrides: [domainStatusServiceProvider.overrideWithValue(service)],
    );
  });

  tearDown(() => container.dispose());

  test('observing domain state does not start remote initialization', () {
    expect(container.read(domainStatusProvider).isInitialized, isFalse);
    expect(service.initializations, 0);
    expect(service.checks, 0);
  });

  test('concurrent domain checks share initialization and result', () async {
    final initialized = service.initialization = Completer<void>();
    final notifier = container.read(domainStatusProvider.notifier);
    final first = notifier.checkDomain();
    final second = notifier.checkDomain();
    expect(second, same(first));
    await Future<void>.delayed(Duration.zero);
    expect(service.initializations, 1);
    expect(service.checks, 0);

    initialized.complete();
    await Future.wait([first, second]);
    expect(service.checks, 1);
    expect(container.read(domainStatusProvider).isReady, isTrue);
  });

  test(
    'initialization failure ends the attempt and a later retry can succeed',
    () async {
      service.initializationError = StateError('configuration offline');
      final notifier = container.read(domainStatusProvider.notifier);
      await notifier.checkDomain();

      final failed = container.read(domainStatusProvider);
      expect(failed.status, DomainStatus.failed);
      expect(failed.isInitialized, isFalse);
      expect(failed.errorMessage, contains('configuration offline'));
      expect(service.initializations, 1);
      expect(service.checks, 0);

      service.initializationError = null;
      await notifier.checkDomain();
      final ready = container.read(domainStatusProvider);
      expect(ready.isReady, isTrue);
      expect(ready.errorMessage, isNull);
      expect(service.initializations, 2);
      expect(service.checks, 1);
    },
  );

  test(
    'failed domain probe can retry without repeating service initialization',
    () async {
      service.available = false;
      final notifier = container.read(domainStatusProvider.notifier);
      await notifier.checkDomain();
      expect(
        container.read(domainStatusProvider).errorMessage,
        'No reachable panel',
      );

      service.available = true;
      await notifier.checkDomain();
      expect(container.read(domainStatusProvider).isReady, isTrue);
      expect(container.read(domainStatusProvider).errorMessage, isNull);
      expect(service.initializations, 1);
      expect(service.checks, 2);
    },
  );

  test(
    'disposing while initialization waits does not publish a stale result',
    () async {
      final initialized = service.initialization = Completer<void>();
      final pending = container
          .read(domainStatusProvider.notifier)
          .checkDomain();
      await Future<void>.delayed(Duration.zero);
      container.dispose();
      initialized.complete();
      await pending;
      expect(service.checks, 0);
    },
  );

  test('copyWith distinguishes keeping an error from clearing it', () {
    const failed = DomainStatusState(errorMessage: 'offline');
    expect(failed.copyWith(isInitialized: true).errorMessage, 'offline');
    expect(failed.copyWith(errorMessage: null).errorMessage, isNull);
  });
}
