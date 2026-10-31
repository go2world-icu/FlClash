import 'dart:convert';

import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/plugins/ios_service.dart';
import 'package:fl_clash/plugins/service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _Listener with ServiceListener, IosServiceListener {
  final statuses = <(String, int)>[];
  final crashes = <String>[];
  final events = <CoreEvent>[];

  @override
  void onServiceStatus(String status, int runTime) =>
      statuses.add((status, runTime));

  @override
  void onServiceCrash(String message) => crashes.add(message);

  @override
  void onServiceEvent(CoreEvent event) => events.add(event);
}

class _ThrowingListener with ServiceListener, IosServiceListener {
  @override
  void onServiceStatus(String status, int runTime) =>
      throw StateError('status');

  @override
  void onServiceCrash(String message) => throw StateError('crash');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('$packageName/service');
  const codec = StandardMethodCodec();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  Future<void> emit(String method, Object? arguments) =>
      messenger.handlePlatformMessage(
        channel.name,
        codec.encodeMethodCall(MethodCall(method, arguments)),
        null,
      );

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('iOS status and shared Core events use the same handler', () async {
    final listener = _Listener();
    Service().addListener(listener);
    addTearDown(() => Service().removeListener(listener));

    await emit('status', jsonEncode({'status': 'connected', 'runTime': 123}));
    await emit(
      'event',
      Uint8List.fromList(
        utf8.encode(
          jsonEncode(
            const CoreMethodCall(
              method: CoreMethod.message,
              arguments: {'type': 'log', 'data': 'core log'},
            ).toJson(),
          ),
        ),
      ),
    );
    await emit('crash', 'tunnel failed');

    expect(listener.statuses, [('connected', 123)]);
    expect(listener.events.single.data, 'core log');
    expect(listener.crashes, ['tunnel failed']);
  });

  test(
    'malformed status and a failing observer leave delivery usable',
    () async {
      final throwing = _ThrowingListener();
      final listener = _Listener();
      Service().addListener(throwing);
      Service().addListener(listener);
      addTearDown(() {
        Service().removeListener(throwing);
        Service().removeListener(listener);
      });

      await emit('status', '{');
      await emit('status', jsonEncode({'status': 'connected', 'runTime': 123}));
      await emit('crash', 'tunnel failed');
      expect(listener.statuses, [('connected', 123)]);
      expect(listener.crashes, ['tunnel failed']);
      expect(dispatchIosServiceCall(const MethodCall('unknown'), []), isFalse);
    },
  );

  for (final bytes in [false, true]) {
    test(
      'core diagnostics decode ${bytes ? 'bytes' : 'legacy strings'}',
      () async {
        messenger.setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'invokeMethod');
          expect(
            jsonDecode(call.arguments as String)['method'],
            'getCoreState',
          );
          final data = jsonEncode({
            'coreBooted': true,
            'tunStarted': false,
            'error': 'TUN unavailable',
          });
          return bytes ? Uint8List.fromList(utf8.encode(data)) : data;
        });
        final state = await Service().coreState();
        expect(state?.booted, isTrue);
        expect(state?.tunStarted, isFalse);
        expect(state?.error, 'TUN unavailable');
      },
    );
  }

  test('unanswered and malformed diagnostics remain unavailable', () async {
    for (final response in [null, '{}', '{', 3]) {
      messenger.setMockMethodCallHandler(channel, (_) async => response);
      expect(await Service().coreState(), isNull);
    }
    messenger.setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'disconnected');
    });
    expect(await Service().coreState(), isNull);
    expect(await Service().ping(), isFalse);
    expect(await Service().setXboardDirectAddresses(['203.0.113.10']), isFalse);
  });

  test('headless state uses the existing shared-state JSON contract', () async {
    const state = SharedState(
      stopTip: 'stopTip',
      startTip: 'startTip',
      localNetworkTip: 'localNetworkTip',
      currentProfileName: 'profile',
      stopText: 'stop',
      onlyStatisticsProxy: true,
    );
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'saveState');
      expect(jsonDecode(call.arguments as String), state.toJson());
      return '';
    });
    expect(await Service().saveState(state), isEmpty);
  });
}
