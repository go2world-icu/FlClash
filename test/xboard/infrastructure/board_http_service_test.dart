import 'dart:async';
import 'dart:io';

import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:board_sdk/src/core/http/http_service.dart';
import 'package:board_sdk/src/panels/xboard/apis/xboard_login_api.dart';
import 'package:flutter_test/flutter_test.dart';

const _login = '/api/v1/passport/auth/login';
const _checkout = '/api/v1/user/order/checkout';

Future<String> _serve(Future<void> Function(HttpRequest) handler) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.listen(handler);
  addTearDown(() => server.close(force: true));
  return 'http://127.0.0.1:${server.port}';
}

Future<void> _reply(HttpRequest request) async {
  request.response.write('{"data":{"token":"test"}}');
  await request.response.close();
}

Future<void> _disconnect(HttpRequest request) async {
  final socket = await request.response.detachSocket(writeHeaders: false);
  socket.destroy();
}

void main() {
  test(
    'parallel reads share recovery while an active write finishes',
    () async {
      final receivedWrite = Completer<void>();
      final releaseWrite = Completer<void>();
      final receivedReads = Completer<void>();
      var reads = 0;
      final primary = await _serve((request) async {
        if (request.method == 'POST') {
          await request.drain<void>();
          receivedWrite.complete();
          await releaseWrite.future;
          await _reply(request);
        } else {
          if (++reads == 2) receivedReads.complete();
          await _disconnect(request);
        }
      });
      final alternateMethods = <String>[];
      final alternate = await _serve((request) {
        alternateMethods.add(request.method);
        return _reply(request);
      });
      final failedRoutes = <ApiRoute>[];
      final http = await HttpService.create(
        primary,
        routeRecovery: (failed) async {
          failedRoutes.add(failed);
          await receivedReads.future;
          return ApiRoute(alternate, null);
        },
      );
      addTearDown(http.dispose);
      final write = http.postRequest(_checkout, {'trade_no': 'test'});
      await receivedWrite.future;
      try {
        final results = await Future.wait([
          http.getRequest('/first'),
          http.getRequest('/second'),
        ]);
        expect(results.map((result) => result['data']), [
          {'token': 'test'},
          {'token': 'test'},
        ]);
        expect(failedRoutes.single.baseUrl, primary);
        expect(failedRoutes.single.proxyUrl, isNull);
        expect(alternateMethods, ['GET', 'GET']);
      } finally {
        releaseWrite.complete();
        expect((await write)['data'], {'token': 'test'});
      }
    },
  );

  test('a truncated login response only changes the next attempt', () async {
    var originalLogins = 0;
    final primary = await _serve((request) async {
      await request.drain<void>();
      originalLogins++;
      await _disconnect(request);
    });
    final recovered = Completer<ApiRoute?>();
    final alternatePaths = <String>[];
    final alternate = await _serve((request) async {
      alternatePaths.add(request.uri.path);
      await request.drain<void>();
      await _reply(request);
    });
    final http = await HttpService.create(
      primary,
      routeRecovery: (_) => recovered.future,
    );
    addTearDown(http.dispose);
    final login = XBoardLoginApi(http);
    await expectLater(
      login.login('test', 'test'),
      throwsA(isA<NetworkException>()),
    );
    expect(originalLogins, 1);
    expect(alternatePaths, isEmpty);
    recovered.complete(ApiRoute(alternate, null));
    expect((await login.login('test', 'test')).token, 'test');
    expect(alternatePaths, [_login]);
  });

  test(
    'a failed connection can retry login before the request is sent',
    () async {
      var logins = 0;
      final alternate = await _serve((request) async {
        expect(request.uri.path, _login);
        expect(request.method, 'POST');
        logins++;
        await request.drain<void>();
        await _reply(request);
      });
      final http = await HttpService.create(
        'http://primary.invalid',
        httpConfig: HttpConfig(
          addressResolver: (host) async => host == 'primary.invalid'
              ? throw const SocketException('simulated DNS failure')
              : [InternetAddress.loopbackIPv4],
        ),
        routeRecovery: (_) async => ApiRoute(alternate, null),
      );
      addTearDown(http.dispose);
      expect((await XBoardLoginApi(http).login('test', 'test')).token, 'test');
      expect(logins, 1);
    },
  );

  test('a checkout without a response does not try another route', () async {
    var checkouts = 0;
    final primary = await _serve((request) async {
      await request.drain<void>();
      checkouts++;
      await _disconnect(request);
    });
    var recoveries = 0;
    final http = await HttpService.create(
      primary,
      routeRecovery: (_) async {
        recoveries++;
        return null;
      },
    );
    addTearDown(http.dispose);
    await expectLater(
      http.postRequest(_checkout, {'trade_no': 'test'}),
      throwsA(isA<NetworkException>()),
    );
    expect(checkouts, 1);
    expect(recoveries, 0);
  });

  test(
    'a read tries one replacement even when the replacement fails',
    () async {
      final primary = await _serve(_disconnect);
      final alternate = await _serve(_disconnect);
      final failedRoutes = <String>[];
      final http = await HttpService.create(
        primary,
        routeRecovery: (failed) async {
          failedRoutes.add(failed.baseUrl);
          return ApiRoute(alternate, null);
        },
      );
      addTearDown(http.dispose);
      await expectLater(
        http.getRequest('/read'),
        throwsA(isA<NetworkException>()),
      );
      expect(failedRoutes, [primary]);
    },
  );
}
