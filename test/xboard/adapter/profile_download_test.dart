import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/xboard/adapter/profile_download.dart';
import 'package:fl_clash/xboard/domain/models/subscription.dart';
import 'package:fl_clash/xboard/features/auth/providers/subscription_info_provider.dart';
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
  final uri = Uri.parse('https://subscription.invalid/config?token=private');
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
    globalState.container = container;
    globalState.packageInfo = PackageInfo(
      appName: 'ToWorld',
      packageName: 'test',
      version: '1.0.0',
      buildNumber: '1',
    );
  });

  Future<Response<Uint8List>?> download(_Client client) =>
      downloadXBoardProfile(
        uri,
        headers: const {HttpHeaders.authorizationHeader: 'Basic credentials'},
        isIOS: true,
        subscriptionUrls: const ['https://subscription.invalid/'],
        proxyUrls: const [],
        createClient: (_, _) async => client,
      );

  test('non-panel URLs and non-iOS downloads keep the upstream path', () async {
    for (final candidate in [
      'http://subscription.invalid/config',
      'https://subscription.invalid:444/config',
      'https://other.invalid/config',
      'https://subscription.invalid.evil.invalid/config',
    ]) {
      expect(
        await downloadXBoardProfile(
          Uri.parse(candidate),
          isIOS: true,
          subscriptionUrls: const ['https://subscription.invalid/'],
          createClient: (_, _) => throw StateError('must use upstream'),
        ),
        isNull,
      );
    }
    expect(
      await downloadXBoardProfile(
        uri,
        isIOS: false,
        read: <T>(_) => throw StateError('must not read panel state'),
        createClient: (_, _) => throw StateError('must use upstream'),
      ),
      isNull,
    );
  });

  test(
    'the cached account URL is recognized outside configured origins',
    () async {
      final account = Uri.parse(
        'https://raw-panel.invalid/subscribe?token=private',
      );
      container
          .read(subscriptionInfoProvider.notifier)
          .state = DomainSubscription(
        subscribeUrl: account.toString(),
        email: 'test@example.com',
        uuid: 'id',
        planId: 1,
        transferLimit: 100,
        uploadedBytes: 0,
        downloadedBytes: 0,
      );
      final client = _Client([1, 2, 3]);
      final response = await downloadXBoardProfile(
        account,
        read: container.read,
        isIOS: true,
        subscriptionUrls: const ['https://configured-source.invalid/'],
        proxyUrls: const [],
        createClient: (_, _) async => client,
      );
      expect(response!.data, [1, 2, 3]);
      expect(client.urls, [account]);
      expect(
        await downloadXBoardProfile(
          account.replace(query: 'token=other'),
          read: container.read,
          isIOS: true,
          subscriptionUrls: const [],
          createClient: (_, _) => throw StateError('must use upstream'),
        ),
        isNull,
      );
    },
  );

  test(
    'bytes and subscription metadata reach the original profile updater',
    () async {
      final bytes = [0x1f, 0x8b, 0, 255];
      final client = _Client(bytes);
      client.request.response.headers.values.addAll({
        'content-disposition': ['attachment; filename="profile.yaml"'],
        'subscription-userinfo': ['upload=1; download=2; total=3'],
      });
      final response = await download(client);
      expect(response!.data, bytes);
      expect(response.statusCode, 200);
      expect(
        response.headers.value('content-disposition'),
        'attachment; filename="profile.yaml"',
      );
      expect(
        response.headers.value('subscription-userinfo'),
        'upload=1; download=2; total=3',
      );
      expect(client.request.headers.values[HttpHeaders.authorizationHeader], [
        'Basic credentials',
      ]);
      expect(client.closes, greaterThanOrEqualTo(1));
      expect(client.forced, isTrue);
    },
  );

  test('HTTP failures propagate without replacing the profile', () async {
    await expectLater(
      download(_Client([], status: 503)),
      throwsA(isA<HttpException>()),
    );
  });

  testWidgets(
    'the shared deadline retains the typed timeout and closes late clients',
    (tester) async {
      final created = Completer<HttpClient>();
      final client = _Client([]);
      final outcome = expectLater(
        downloadXBoardProfile(
          uri,
          isIOS: true,
          subscriptionUrls: const ['https://subscription.invalid/'],
          proxyUrls: const [],
          createClient: (_, _) => created.future,
        ),
        throwsA(
          isA<DioException>().having(
            (error) => error.type,
            'type',
            DioExceptionType.receiveTimeout,
          ),
        ),
      );
      await tester.pump(downloadTimeoutDuration);
      await outcome;
      created.complete(client);
      await tester.pump();
      expect(client.closes, greaterThanOrEqualTo(1));
      expect(client.forced, isTrue);
      expect(client.urls, isEmpty);
    },
  );
}
