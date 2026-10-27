import 'dart:async';
import 'dart:io';

import 'package:fl_clash/xboard/infrastructure/http/board_transport.dart';

class DomainRacingService {
  static const _timeout = Duration(seconds: 8);
  static const _parallelism = 3;

  static Future<DomainRacingResult?> raceSelectFastestDomain(
    List<String> domains, {
    String testPath = '',
    bool forceHttpsResult = false,
    List<String>? proxyUrls,
  }) async {
    if (domains.isEmpty) return null;
    final routes = <(String, String?)>[
      for (final domain in domains)
        for (final proxy in <String?>[null, ...?proxyUrls]) (domain, proxy),
    ];
    final tokens = List.generate(routes.length, (_) => CancelToken());
    final winner = Completer<DomainRacingResult?>();
    var next = 0;
    var finished = 0;

    Future<void> worker() async {
      while (!winner.isCompleted && next < routes.length) {
        final index = next++;
        final (domain, proxy) = routes[index];
        final result = await _testSingleDomain(
          domain,
          testPath,
          tokens[index],
          proxyUrl: proxy,
        );
        finished++;
        if (winner.isCompleted) return;
        if (result.success) {
          winner.complete(
            DomainRacingResult(
              domain: _endpoint(domain).origin,
              useProxy: proxy != null,
              proxyUrl: proxy,
              responseTime: result.responseTime,
            ),
          );
          for (var i = 0; i < tokens.length; i++) {
            if (i != index) tokens[i].cancel();
          }
        } else if (finished == routes.length) {
          winner.complete(null);
        }
      }
    }

    final workers = [
      for (var i = 0; i < _parallelism && i < routes.length; i++) worker(),
    ];
    try {
      return await winner.future.timeout(
        const Duration(seconds: 24),
        onTimeout: () => null,
      );
    } finally {
      for (final token in tokens) {
        token.cancel();
      }
      unawaited(Future.wait(workers));
    }
  }

  static Future<bool> probeDomain(
    String domain, {
    String? proxyUrl,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    final result = await _testSingleDomain(
      domain,
      '',
      CancelToken(),
      proxyUrl: proxyUrl,
      timeout: timeout,
    );
    return result.success;
  }

  static Future<List<DomainTestResult>> testAllDomains(
    List<String> domains, {
    String testPath = '',
  }) async {
    final results = <DomainTestResult>[];
    for (var i = 0; i < domains.length; i += _parallelism) {
      results.addAll(
        await Future.wait([
          for (final domain in domains.skip(i).take(_parallelism))
            _testSingleDomain(domain, testPath, CancelToken()),
        ]),
      );
    }
    results.sort((a, b) {
      if (a.success != b.success) return a.success ? -1 : 1;
      return a.responseTime.compareTo(b.responseTime);
    });
    return results;
  }

  static Future<DomainTestResult> _testSingleDomain(
    String domain,
    String testPath,
    CancelToken token, {
    String? proxyUrl,
    Duration timeout = _timeout,
  }) async {
    final watch = Stopwatch()..start();
    HttpClient? client;
    try {
      final endpoint = _endpoint(domain);
      final path = testPath.isEmpty
          ? '/api/v1/guest/comm/config'
          : (testPath.startsWith('/') ? testPath : '/$testPath');
      final uri = endpoint.replace(path: path, query: null, fragment: null);
      client = await XBoardTransport.create(uri, proxyUrl: proxyUrl);
      token.attach(client);
      client.connectionTimeout = timeout;
      if (token.isCancelled) throw const HttpException('Cancelled');
      final request = await client.getUrl(uri).timeout(timeout);
      request.followRedirects = false;
      final response = await request.close().timeout(timeout);
      if (token.isCancelled) throw const HttpException('Cancelled');
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('HTTP ${response.statusCode}');
      }
      var size = 0;
      await response
          .forEach((chunk) {
            size += chunk.length;
            if (token.isCancelled || size > 64 * 1024) {
              throw const HttpException('Invalid health response');
            }
          })
          .timeout(timeout);
      return DomainTestResult.success(
        domain,
        watch.elapsedMilliseconds,
        useProxy: proxyUrl != null,
        proxyUrl: proxyUrl,
      );
    } catch (error) {
      return DomainTestResult.failure(
        domain,
        error.toString(),
        watch.elapsedMilliseconds,
        useProxy: proxyUrl != null,
        proxyUrl: proxyUrl,
      );
    } finally {
      client?.close(force: true);
      watch.stop();
    }
  }

  static Uri _endpoint(String value) {
    final uri = Uri.parse(value.contains('://') ? value : 'https://$value');
    if (uri.host.isEmpty) throw const FormatException('Invalid panel URL');
    return uri.replace(scheme: 'https');
  }
}

class DomainRacingResult {
  final String domain;
  final bool useProxy;
  final String? proxyUrl;
  final int responseTime;

  const DomainRacingResult({
    required this.domain,
    required this.useProxy,
    this.proxyUrl,
    required this.responseTime,
  });

  @override
  String toString() =>
      'DomainRacingResult(domain: $domain, useProxy: $useProxy, responseTime: ${responseTime}ms)';
}

class DomainTestResult {
  final String domain;
  final bool success;
  final int responseTime;
  final String? error;
  final bool useProxy;
  final String? proxyUrl;

  const DomainTestResult._({
    required this.domain,
    required this.success,
    required this.responseTime,
    this.error,
    this.useProxy = false,
    this.proxyUrl,
  });

  factory DomainTestResult.success(
    String domain,
    int responseTime, {
    bool useProxy = false,
    String? proxyUrl,
  }) => DomainTestResult._(
    domain: domain,
    success: true,
    responseTime: responseTime,
    useProxy: useProxy,
    proxyUrl: proxyUrl,
  );

  factory DomainTestResult.failure(
    String domain,
    String error,
    int responseTime, {
    bool useProxy = false,
    String? proxyUrl,
  }) => DomainTestResult._(
    domain: domain,
    success: false,
    responseTime: responseTime,
    error: error,
    useProxy: useProxy,
    proxyUrl: proxyUrl,
  );

  @override
  String toString() =>
      'DomainTestResult(domain: $domain, success: $success, responseTime: ${responseTime}ms)';
}

class CancelToken {
  bool _isCancelled = false;
  HttpClient? _client;

  bool get isCancelled => _isCancelled;

  void attach(HttpClient client) {
    _client = client;
    if (_isCancelled) client.close(force: true);
  }

  void cancel() {
    _isCancelled = true;
    _client?.close(force: true);
  }
}
