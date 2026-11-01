import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/infrastructure/http/board_transport.dart';
import 'package:fl_clash/xboard/utils/xboard_core_validation.dart';

class SubscriptionCancellation {
  bool _cancelled = false;
  final _clients = <HttpClient>{};
  final _cancelledSignal = Completer<void>();

  bool get isCancelled => _cancelled;
  Future<void> get whenCancelled => _cancelledSignal.future;

  void attach(HttpClient client) {
    _clients.add(client);
    if (_cancelled) client.close(force: true);
  }

  void detach(HttpClient client) => _clients.remove(client);

  void cancel() {
    if (_cancelled) return;
    _cancelled = true;
    _cancelledSignal.complete();
    for (final client in _clients) {
      client.close(force: true);
    }
  }
}

class SubscriptionDownloader {
  static const _timeout = Duration(seconds: 30);
  static const _maxBytes = 8 * 1024 * 1024;

  static Future<Profile> downloadSubscription(
    String url, {
    bool enableRacing = true,
    SubscriptionCancellation? cancellation,
  }) async {
    final result = await fetchSubscription(
      url,
      proxyUrls: enableRacing ? null : const [],
      cancellation: cancellation,
      validate: (bytes) async {
        final content = utf8.decode(bytes);
        final localError = xboardValidateConfigContent(content);
        if (localError.isNotEmpty) throw FormatException(localError);
        final coreError = await xboardValidateConfigData(content);
        if (coreError.isNotEmpty) throw FormatException(coreError);
      },
    );
    final profile = Profile.normal(url: url);
    final saved = await profile.saveFile(
      result.bytes,
      validate: xboardValidateProfile,
    );
    final disposition = result.headers['content-disposition'];
    final match = disposition == null
        ? null
        : RegExp(r'filename="?([^";\n]+)"?').firstMatch(disposition.join(';'));
    final userInfo = result.headers['subscription-userinfo']?.join(';');
    return saved.copyWith(
      label: match?.group(1)?.trim() ?? saved.id.toString(),
      subscriptionInfo: userInfo == null
          ? null
          : SubscriptionInfo.formHString(userInfo),
      lastUpdateDate: DateTime.now(),
    );
  }

  static Future<SubscriptionDownload> fetchSubscription(
    String url, {
    List<String>? proxyUrls,
    SubscriptionCancellation? cancellation,
    Duration timeout = _timeout,
    Map<String, Object> headers = const {},
    Future<void> Function(Uint8List)? validate,
    Future<HttpClient> Function(Uri, String?)? createClient,
  }) async {
    final uri = Uri.parse(url);
    if (uri.scheme != 'https') {
      throw const FormatException('Subscription URL must use HTTPS');
    }
    final active = cancellation ?? SubscriptionCancellation();
    final proxies = proxyUrls ?? XBoardConfig.allProxyUrls;
    final routes = <String?>[null, ...proxies];
    final winner = Completer<SubscriptionDownload>();
    var next = 0;
    var finished = 0;
    Object? firstError;

    Future<void> worker() async {
      while (!winner.isCompleted &&
          !active.isCancelled &&
          next < routes.length) {
        final proxy = routes[next++];
        try {
          final candidate = await _download(
            uri,
            proxy,
            active,
            headers: headers,
            validate: validate,
            createClient: createClient,
          );
          if (!winner.isCompleted && !active.isCancelled) {
            winner.complete(candidate);
            return;
          }
        } catch (error) {
          firstError ??= error;
        } finally {
          finished++;
          if (finished == routes.length && !winner.isCompleted) {
            winner.completeError(
              firstError ?? StateError('No usable subscription'),
            );
          }
        }
      }
    }

    final workers = [for (var i = 0; i < 3 && i < routes.length; i++) worker()];
    try {
      return await Future.any([
        winner.future,
        active.whenCancelled.then<SubscriptionDownload>(
          (_) => throw const HttpException('Subscription download cancelled'),
        ),
      ]).timeout(timeout);
    } finally {
      active.cancel();
      unawaited(Future.wait(workers));
    }
  }

  static Future<SubscriptionDownload> _download(
    Uri uri,
    String? proxy,
    SubscriptionCancellation cancellation, {
    required Map<String, Object> headers,
    required Future<void> Function(Uint8List)? validate,
    required Future<HttpClient> Function(Uri, String?)? createClient,
  }) async {
    final client = await (createClient != null
        ? createClient(uri, proxy)
        : XBoardTransport.create(uri, proxyUrl: proxy));
    cancellation.attach(client);
    client.connectionTimeout = _timeout;
    try {
      if (cancellation.isCancelled) {
        throw const HttpException('Subscription import cancelled');
      }
      final request = await client.getUrl(uri).timeout(_timeout);
      request.headers.set(HttpHeaders.userAgentHeader, globalState.ua);
      headers.forEach(request.headers.set);
      final response = await request.close().timeout(_timeout);
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('HTTP ${response.statusCode}');
      }
      final builder = BytesBuilder(copy: false);
      await response
          .forEach((chunk) {
            if (cancellation.isCancelled ||
                builder.length + chunk.length > _maxBytes) {
              throw const HttpException(
                'Subscription download cancelled or too large',
              );
            }
            builder.add(chunk);
          })
          .timeout(_timeout);
      final bytes = builder.takeBytes();
      await validate?.call(bytes);
      final responseHeaders = <String, List<String>>{};
      response.headers.forEach((name, values) {
        responseHeaders[name.toLowerCase()] = List.of(values);
      });
      return SubscriptionDownload(bytes, responseHeaders);
    } finally {
      cancellation.detach(client);
      client.close(force: true);
    }
  }
}

class SubscriptionDownload {
  final Uint8List bytes;
  final Map<String, List<String>> headers;

  SubscriptionDownload(this.bytes, this.headers);
}
