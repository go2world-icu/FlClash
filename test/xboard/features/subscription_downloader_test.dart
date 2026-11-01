import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fl_clash/state.dart';
import 'package:fl_clash/xboard/features/subscription/services/subscription_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

class _Headers extends Fake implements HttpHeaders {
  final values = <String, List<String>>{};

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    values[name.toLowerCase()] = [value.toString()];
  }

  @override
  void forEach(void Function(String, List<String>) action) =>
      values.forEach(action);
}

class _Response extends Fake implements HttpClientResponse {
  _Response(List<int> bytes, {Stream<List<int>>? body, this.statusCode = 200})
    : body = body ?? Stream.value(bytes);

  final Stream<List<int>> body;

  @override
  final int statusCode;

  @override
  final _Headers headers = _Headers();

  @override
  Future<void> forEach(void Function(List<int>) action) => body.forEach(action);
}

class _Request extends Fake implements HttpClientRequest {
  _Request(this.response);

  final _Response response;

  @override
  final _Headers headers = _Headers();

  @override
  bool followRedirects = true;

  @override
  Future<HttpClientResponse> close() async => response;
}

class _Client extends Fake implements HttpClient {
  _Client(List<int> bytes, {Stream<List<int>>? body, int status = 200})
    : request = _Request(_Response(bytes, body: body, statusCode: status));

  final _Request request;
  Exception? error;
  var closes = 0;
  bool? forced;
  final urls = <Uri>[];

  @override
  Duration? connectionTimeout;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    urls.add(url);
    if (error case final error?) throw error;
    return request;
  }

  @override
  void close({bool force = false}) {
    forced = force;
    closes++;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const url = 'https://subscription.invalid/config?token=private';

  setUp(() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    globalState.container = container;
    globalState.packageInfo = PackageInfo(
      appName: 'ToWorld',
      packageName: 'test',
      version: '1.0.0',
      buildNumber: '1',
    );
  });

  test('returns raw bytes, headers and forwards credentials', () async {
    final bytes = [0x1f, 0x8b, 0, 255];
    final client = _Client(bytes);
    client.request.response.headers.values.addAll({
      'content-disposition': ['attachment; filename="profile.yaml"'],
      'subscription-userinfo': ['upload=1; download=2; total=3'],
    });
    final downloaded = await SubscriptionDownloader.fetchSubscription(
      url,
      proxyUrls: const [],
      headers: const {HttpHeaders.authorizationHeader: 'Basic credentials'},
      createClient: (_, _) async => client,
    );

    expect(downloaded.bytes, bytes);
    expect(downloaded.headers, client.request.response.headers.values);
    expect(client.request.headers.values[HttpHeaders.authorizationHeader], [
      'Basic credentials',
    ]);
    expect(client.request.followRedirects, isTrue);
    expect(client.closes, greaterThanOrEqualTo(1));
    expect(client.forced, isTrue);
  });

  test('a proxy can win when the direct route fails', () async {
    final direct = _Client([])..error = const SocketException('unreachable');
    final proxy = _Client([1, 2, 3]);
    final routes = <String?>[];
    final downloaded = await SubscriptionDownloader.fetchSubscription(
      url,
      proxyUrls: const ['socks5://proxy.invalid:1080'],
      createClient: (_, route) async {
        routes.add(route);
        return route == null ? direct : proxy;
      },
    );

    expect(downloaded.bytes, [1, 2, 3]);
    expect(routes, [null, 'socks5://proxy.invalid:1080']);
    expect(direct.closes, greaterThanOrEqualTo(1));
    expect(proxy.closes, greaterThanOrEqualTo(1));
  });

  test(
    'an invalid fast source cannot win the import validation race',
    () async {
      final direct = _Client([0]);
      final proxy = _Client([1]);
      final downloaded = await SubscriptionDownloader.fetchSubscription(
        url,
        proxyUrls: const ['socks5://proxy.invalid:1080'],
        createClient: (_, route) async => route == null ? direct : proxy,
        validate: (bytes) async {
          if (bytes.single == 0) throw const FormatException('invalid config');
        },
      );

      expect(downloaded.bytes, [1]);
      expect(direct.closes, greaterThanOrEqualTo(1));
      expect(proxy.closes, greaterThanOrEqualTo(1));
    },
  );

  test('limits racing workers and closes late losing clients', () async {
    final pendingClients = <String?, Completer<HttpClient>>{};
    final pending = SubscriptionDownloader.fetchSubscription(
      url,
      proxyUrls: const [
        'socks5://a:1080',
        'socks5://b:1080',
        'socks5://c:1080',
      ],
      createClient: (_, route) =>
          (pendingClients[route] = Completer<HttpClient>()).future,
    );
    expect(pendingClients.keys, [null, 'socks5://a:1080', 'socks5://b:1080']);
    final winner = _Client([1]);
    pendingClients['socks5://a:1080']!.complete(winner);
    expect((await pending).bytes, [1]);
    final direct = _Client([]);
    final loser = _Client([]);
    pendingClients[null]!.complete(direct);
    pendingClients['socks5://b:1080']!.complete(loser);
    await Future<void>.delayed(Duration.zero);

    expect(pendingClients, hasLength(3));
    expect(direct.closes, greaterThanOrEqualTo(1));
    expect(loser.closes, greaterThanOrEqualTo(1));
    expect(direct.urls, isEmpty);
    expect(loser.urls, isEmpty);
  });

  test('all HTTP failures propagate and close their clients', () async {
    final client = _Client([], status: 503);
    await expectLater(
      SubscriptionDownloader.fetchSubscription(
        url,
        proxyUrls: const [],
        createClient: (_, _) async => client,
      ),
      throwsA(
        isA<HttpException>().having(
          (error) => error.message,
          'message',
          'HTTP 503',
        ),
      ),
    );
    expect(client.closes, greaterThanOrEqualTo(1));
    expect(client.forced, isTrue);
  });

  test(
    'cancellation ends a pending creation and closes its late client',
    () async {
      final created = Completer<HttpClient>();
      final cancellation = SubscriptionCancellation();
      final pending = SubscriptionDownloader.fetchSubscription(
        url,
        cancellation: cancellation,
        proxyUrls: const [],
        createClient: (_, _) => created.future,
      );
      final outcome = expectLater(pending, throwsA(isA<HttpException>()));
      cancellation.cancel();
      await outcome;
      final client = _Client([]);
      created.complete(client);
      await Future<void>.delayed(Duration.zero);
      expect(client.closes, greaterThanOrEqualTo(1));
      expect(client.forced, isTrue);
      expect(client.urls, isEmpty);
    },
  );

  testWidgets('the total deadline includes creation and closes late clients', (
    tester,
  ) async {
    final created = Completer<HttpClient>();
    final outcome = expectLater(
      SubscriptionDownloader.fetchSubscription(
        url,
        proxyUrls: const [],
        timeout: const Duration(seconds: 20),
        createClient: (_, _) => created.future,
      ),
      throwsA(isA<TimeoutException>()),
    );
    await tester.pump(const Duration(seconds: 20));
    await outcome;
    final client = _Client([]);
    created.complete(client);
    await tester.pump();
    expect(client.closes, greaterThanOrEqualTo(1));
    expect(client.forced, isTrue);
    expect(client.urls, isEmpty);
  });

  testWidgets('the total deadline closes clients with a stalled body', (
    tester,
  ) async {
    final body = StreamController<List<int>>();
    final client = _Client([], body: body.stream);
    final outcome = expectLater(
      SubscriptionDownloader.fetchSubscription(
        url,
        proxyUrls: const [],
        timeout: const Duration(seconds: 20),
        createClient: (_, _) async => client,
      ),
      throwsA(isA<TimeoutException>()),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 20));
    await outcome;
    expect(client.closes, greaterThanOrEqualTo(1));
    expect(client.forced, isTrue);
    unawaited(body.close());
    await tester.pump();
  });

  test('responses larger than 8 MiB fail before validation', () async {
    final client = _Client(Uint8List(8 * 1024 * 1024 + 1));
    await expectLater(
      SubscriptionDownloader.fetchSubscription(
        url,
        proxyUrls: const [],
        createClient: (_, _) async => client,
        validate: (_) =>
            throw StateError('must not validate oversized content'),
      ),
      throwsA(isA<HttpException>()),
    );
    expect(client.closes, greaterThanOrEqualTo(1));
    expect(client.forced, isTrue);
  });
}
