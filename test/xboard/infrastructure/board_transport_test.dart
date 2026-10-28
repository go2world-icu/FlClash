import 'dart:async';
import 'dart:io';

import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/infrastructure/http/ios_board_resolver.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _RealHttpOverrides extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.follow.clash/service');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('physical addresses are routed before they reach the client', () async {
    final calls = <MethodCall>[];
    final applied = Completer<bool>();
    final installing = Completer<void>();
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      if (call.method == 'resolveXboardHost') {
        return ['203.0.113.10', '2001:db8::10'];
      }
      installing.complete();
      return applied.future;
    });
    var completed = false;
    final lookup = IosBoardResolver.resolve('panel.invalid').then((addresses) {
      completed = true;
      return addresses;
    });
    await installing.future;
    expect(completed, isFalse);
    expect(calls.map((call) => call.method), [
      'resolveXboardHost',
      'setXboardDirectAddresses',
    ]);
    expect(calls.first.arguments, 'panel.invalid');
    expect(calls.last.arguments, ['203.0.113.10', '2001:db8::10']);
    applied.complete(true);
    expect((await lookup).map((address) => address.address), [
      '203.0.113.10',
      '2001:db8::10',
    ]);
  });

  test('IP endpoints skip DNS and still install a physical route', () async {
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return true;
    });
    await IosBoardResolver.resolve('203.0.113.10');
    expect(calls.single.method, 'setXboardDirectAddresses');
    expect(calls.single.arguments, ['203.0.113.10']);
  });

  test('physical DNS failure cannot fall back to tunnel DNS', () async {
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return <String>[];
    });
    await expectLater(
      IosBoardResolver.resolve('panel.invalid'),
      throwsA(isA<SocketException>()),
    );
    expect(calls.single.method, 'resolveXboardHost');
  });

  test('a failed route update does not block the next request', () async {
    var updates = 0;
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'resolveXboardHost') return ['203.0.113.10'];
      return ++updates > 1;
    });
    await expectLater(
      IosBoardResolver.resolve('panel.invalid'),
      throwsA(isA<SocketException>()),
    );
    expect(await IosBoardResolver.resolve('panel.invalid'), hasLength(1));
  });

  test('HTTP dials the resolved IP while preserving the URL host', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    final received = Completer<String?>();
    final subscription = server.listen((request) async {
      received.complete(request.headers.value(HttpHeaders.hostHeader));
      request.response.statusCode = HttpStatus.noContent;
      await request.response.close();
    });
    addTearDown(subscription.cancel);
    final hosts = <String>[];
    final client = await HttpOverrides.runWithHttpOverrides(
      () => BoardHttpClient.create(
        host: 'panel.invalid',
        config: HttpConfig(
          addressResolver: (host) async {
            hosts.add(host);
            return [InternetAddress.loopbackIPv4];
          },
        ),
      ),
      _RealHttpOverrides(),
    );
    addTearDown(() => client.close(force: true));
    final request = await client.getUrl(
      Uri.parse('http://panel.invalid:${server.port}/api/v1/user/info'),
    );
    final response = await request.close();
    await response.drain<void>();
    expect(response.statusCode, HttpStatus.noContent);
    expect(await received.future, 'panel.invalid:${server.port}');
    expect(hosts, ['panel.invalid']);
  });

  test('SOCKS routes resolve the proxy through the same resolver', () async {
    final hosts = <String>[];
    final config = HttpConfig(
      addressResolver: (host) async {
        hosts.add(host);
        return [InternetAddress.loopbackIPv4];
      },
    ).copyWith().withProxy('socks5://proxy.invalid:1080');
    final client = await BoardHttpClient.create(
      host: 'panel.invalid',
      config: config,
    );
    addTearDown(() => client.close(force: true));
    expect(hosts, ['proxy.invalid']);
  });
}
