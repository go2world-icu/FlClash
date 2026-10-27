import 'dart:io';

import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/plugins/service.dart';
import 'package:fl_clash/xboard/config/utils/config_file_loader.dart';
import 'package:fl_clash/xboard/core/logger/logger.dart';
import 'package:fl_clash/xboard/infrastructure/http/user_agent_config.dart';

class XBoardTransport {
  /// Bumped whenever a new physical route is asked for, so a result that
  /// arrives after someone else has since succeeded is not treated as a
  /// failure.
  static int _routeGeneration = 0;

  /// Time to hold off before trying the tunnel again after it refused.
  static const _routeBackoff = Duration(seconds: 30);

  static Future<void> _directRouteQueue = Future.value();

  static Future<bool>? _routePending;
  static DateTime? _routeFailedAt;

  /// Tells the tunnel to send the panel's address around the proxy instead of
  /// through it, so the panel stays reachable while the VPN is up.
  ///
  /// Every caller treats this as an optimisation, never a prerequisite: the
  /// panel is reachable through the tunnel too, just via the proxy. A tunnel
  /// that is still connecting, or one whose extension iOS is holding on to
  /// without having booted its core, answers `false` — reported here as
  /// `false` and logged, never thrown into the caller's own try block.
  static Future<bool> ensureDirectRoute(Uri url) {
    if (!Platform.isIOS) return Future.value(false);
    final failedAt = _routeFailedAt;
    if (failedAt != null &&
        DateTime.now().difference(failedAt) < _routeBackoff) {
      return Future.value(false);
    }
    return _routePending ??= _addDirectAddresses(
      url,
    ).whenComplete(() => _routePending = null);
  }

  static Future<bool> _addDirectAddresses(Uri url) {
    final generation = _routeGeneration;
    final update = _directRouteQueue.then((_) async {
      final literal = InternetAddress.tryParse(url.host);
      final addresses = literal == null
          ? await InternetAddress.lookup(
              url.host,
            ).timeout(const Duration(seconds: 4))
          : [literal];
      if (addresses.isEmpty) {
        throw const SocketException('XBoard panel host did not resolve');
      }
      return Service()
          .setXboardDirectAddresses(
            addresses.map((address) => address.address).toList(),
          )
          .timeout(const Duration(seconds: 3), onTimeout: () => false);
    });
    // The queue only serialises; it must not carry one failure into the next.
    _directRouteQueue = update.catchError((Object _) => false);
    return update
        .then((applied) {
          if (applied) {
            _routeFailedAt = null;
            _routeGeneration = generation + 1;
          } else if (generation == _routeGeneration) {
            _routeFailedAt = DateTime.now();
          }
          return applied;
        })
        .catchError((Object error) {
          // Only hold off if nothing has succeeded since this attempt started.
          if (generation == _routeGeneration) {
            _routeFailedAt = DateTime.now();
          }
          XBoardLogger.warning(
            '[XBoardTransport] direct route unavailable: $error',
          );
          return false;
        });
  }

  static Future<HttpConfig> config({String? proxyUrl}) async {
    final certificate = await ConfigFileLoaderHelper.getCertificateConfig();
    final enabled = certificate['enabled'] == true;
    final path = certificate['path'] as String?;
    if (enabled && (path == null || path.isEmpty)) {
      throw StateError('XBoard certificate path is missing');
    }
    return HttpConfig(
      userAgent: await UserAgentConfig.get(UserAgentScenario.apiEncrypted),
      obfuscationPrefix: await ConfigFileLoaderHelper.getObfuscationPrefix(),
      certificatePath: enabled ? path : null,
      enableCertificatePinning: enabled,
      proxyUrl: proxyUrl,
    );
  }

  static Future<HttpClient> create(Uri url, {String? proxyUrl}) async {
    if (url.scheme != 'https') {
      throw const FormatException('XBoard endpoint must use HTTPS');
    }
    if (proxyUrl == null || proxyUrl.isEmpty) {
      await ensureDirectRoute(url);
    }
    return BoardHttpClient.create(
      host: url.host,
      config: await config(proxyUrl: proxyUrl),
    );
  }
}
