import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/infrastructure/http/ios_board_resolver.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _RealHttpOverrides extends HttpOverrides {}

final class _StalledIPv6Overrides extends IOOverrides {
  final attempted = <InternetAddress>[];
  bool cancelled = false;

  @override
  Future<ConnectionTask<Socket>> socketStartConnect(
    dynamic host,
    int port, {
    dynamic sourceAddress,
    int sourcePort = 0,
  }) async {
    attempted.add(host as InternetAddress);
    if (host == InternetAddress.loopbackIPv6) {
      final pending = Completer<Socket>();
      return ConnectionTask.fromSocket(pending.future, () {
        cancelled = true;
        pending.completeError(
          const SocketException('cancelled by test client'),
        );
      });
    }
    return super.socketStartConnect(
      host,
      port,
      sourceAddress: sourceAddress,
      sourcePort: sourcePort,
    );
  }
}

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

  test('HTTP falls back to IPv4 while preserving the URL host', () async {
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
            return [InternetAddress.loopbackIPv6, InternetAddress.loopbackIPv4];
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

  test('a stalled IPv6 attempt is cancelled when IPv4 connects', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    server.listen((request) => request.response.close());
    final overrides = _StalledIPv6Overrides();
    final client = await HttpOverrides.runWithHttpOverrides(
      () => BoardHttpClient.create(
        host: 'panel.invalid',
        config: HttpConfig(
          connectTimeoutSeconds: 3,
          addressResolver: (_) async => [
            InternetAddress.loopbackIPv6,
            InternetAddress.loopbackIPv4,
          ],
        ),
      ),
      _RealHttpOverrides(),
    );
    addTearDown(() => client.close(force: true));
    await IOOverrides.runWithIOOverrides(() async {
      final request = await client.getUrl(
        Uri.parse('http://panel.invalid:${server.port}/'),
      );
      final response = await request.close();
      await response.drain<void>();
      expect(response.statusCode, HttpStatus.ok);
      expect(overrides.attempted, [
        InternetAddress.loopbackIPv6,
        InternetAddress.loopbackIPv4,
      ]);
      expect(overrides.cancelled, isTrue);
    }, overrides);
  });

  test('HTTPS starts TLS with the URL host on the resolved socket', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);
    final peerFuture = server.first;
    final client = await HttpOverrides.runWithHttpOverrides(
      () => BoardHttpClient.create(
        host: 'panel.invalid',
        config: HttpConfig(
          addressResolver: (_) async => [InternetAddress.loopbackIPv4],
        ),
      ),
      _RealHttpOverrides(),
    );
    addTearDown(() => client.close(force: true));
    client.connectionTimeout = const Duration(seconds: 3);
    final request = client
        .getUrl(Uri.parse('https://panel.invalid:${server.port}/'))
        .then((request) => request.close());
    final failedHandshake = expectLater(
      request,
      throwsA(isA<HandshakeException>()),
    );
    final peer = await peerFuture;
    addTearDown(peer.destroy);
    final hello = <int>[];
    await for (final chunk in peer.timeout(const Duration(seconds: 3))) {
      hello.addAll(chunk);
      expect(hello.first, 0x16);
      if (hello.length >= 5 && hello.length >= 5 + (hello[3] << 8) + hello[4]) {
        break;
      }
    }
    expect(ascii.decode(hello, allowInvalid: true), contains('panel.invalid'));
    peer.destroy();
    await failedHandshake;
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
