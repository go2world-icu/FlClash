import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/common/provider_reader.dart';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/subscription/services/subscription_downloader.dart';

Future<Response<Uint8List>?> downloadXBoardProfile(
  Uri uri, {
  ProviderReader? read,
  Map<String, Object> headers = const {},
  bool? isIOS,
  Iterable<String>? subscriptionUrls,
  List<String>? proxyUrls,
  Future<HttpClient> Function(Uri, String?)? createClient,
}) async {
  if (!(isIOS ?? Platform.isIOS) || uri.scheme != 'https') return null;
  final current = read?.call(subscriptionInfoProvider)?.subscribeUrl;
  final configured =
      subscriptionUrls ??
      (XBoardConfig.isInitialized
          ? XBoardConfig.allSubscriptionUrls
          : const <String>[]);
  final matches =
      current != null && Uri.tryParse(current) == uri ||
      configured.any((url) {
        final endpoint = Uri.tryParse(url);
        return endpoint?.scheme == uri.scheme &&
            endpoint?.host == uri.host &&
            endpoint?.port == uri.port;
      });
  if (!matches) return null;
  final options = RequestOptions(path: uri.toString(), headers: headers);
  try {
    final result = await SubscriptionDownloader.fetchSubscription(
      uri.toString(),
      headers: headers,
      proxyUrls:
          proxyUrls ??
          (XBoardConfig.isInitialized ? XBoardConfig.allProxyUrls : const []),
      timeout: downloadTimeoutDuration,
      createClient: createClient,
    );
    return Response<Uint8List>(
      data: result.bytes,
      headers: Headers.fromMap(result.headers),
      requestOptions: options,
      statusCode: HttpStatus.ok,
    );
  } on TimeoutException {
    throw DioException.receiveTimeout(
      timeout: downloadTimeoutDuration,
      requestOptions: options,
    );
  }
}
