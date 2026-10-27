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
    final uri = Uri.parse(url);
    if (uri.scheme != 'https') {
      throw const FormatException('Subscription URL must use HTTPS');
    }
    final active = cancellation ?? SubscriptionCancellation();
    final proxies = enableRacing ? XBoardConfig.allProxyUrls : <String>[];
    final routes = <String?>[null, ...proxies];
    final winner = Completer<_Downloaded>();
    var next = 0;
    var finished = 0;
    Object? firstError;

    Future<void> worker() async {
      while (!winner.isCompleted &&
          !active.isCancelled &&
          next < routes.length) {
        final proxy = routes[next++];
        try {
          final candidate = await _download(uri, proxy, active);
          if (!winner.isCompleted && !active.isCancelled) {
            winner.complete(candidate);
            active.cancel();
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
      final result = await winner.future.timeout(_timeout);
      final profile = Profile.normal(url: url);
      final saved = await profile.saveFile(
        utf8.encode(result.content),
        validate: xboardValidateProfile,
      );
      return saved.copyWith(
        label: result.label ?? saved.id.toString(),
        subscriptionInfo: result.subscriptionInfo,
        lastUpdateDate: DateTime.now(),
      );
    } finally {
      active.cancel();
      unawaited(Future.wait(workers));
    }
  }

  static Future<_Downloaded> _download(
    Uri uri,
    String? proxy,
    SubscriptionCancellation cancellation,
  ) async {
    final client = await XBoardTransport.create(uri, proxyUrl: proxy);
    cancellation.attach(client);
    client.connectionTimeout = _timeout;
    try {
      if (cancellation.isCancelled) {
        throw const HttpException('Subscription import cancelled');
      }
      final request = await client.getUrl(uri).timeout(_timeout);
      request.followRedirects = false;
      request.headers.set(HttpHeaders.userAgentHeader, globalState.ua);
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
      final content = utf8.decode(builder.takeBytes());
      final localError = xboardValidateConfigContent(content);
      if (localError.isNotEmpty) throw FormatException(localError);
      final coreError = await xboardValidateConfigData(content);
      if (coreError.isNotEmpty) throw FormatException(coreError);
      final disposition = response.headers.value('content-disposition');
      final match = disposition == null
          ? null
          : RegExp(r'filename="?([^";\n]+)"?').firstMatch(disposition);
      final userInfo = response.headers.value('subscription-userinfo');
      return _Downloaded(
        content,
        match?.group(1)?.trim(),
        userInfo == null ? null : SubscriptionInfo.formHString(userInfo),
      );
    } finally {
      cancellation.detach(client);
      client.close(force: true);
    }
  }
}

class _Downloaded {
  final String content;
  final String? label;
  final SubscriptionInfo? subscriptionInfo;

  _Downloaded(this.content, this.label, this.subscriptionInfo);
}
