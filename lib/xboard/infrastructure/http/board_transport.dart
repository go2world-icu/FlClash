import 'dart:io';

import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/plugins/service.dart';
import 'package:fl_clash/xboard/config/utils/config_file_loader.dart';
import 'package:fl_clash/xboard/infrastructure/http/user_agent_config.dart';

class XBoardTransport {
  static Future<void> _directRouteQueue = Future.value();

  static Future<void> ensureDirectRoute(Uri url) {
    if (!Platform.isIOS) return Future.value();
    final update = _directRouteQueue.then((_) async {
      final literal = InternetAddress.tryParse(url.host);
      final addresses = literal == null
          ? await InternetAddress.lookup(
              url.host,
            ).timeout(const Duration(seconds: 4))
          : [literal];
      if (addresses.isEmpty ||
          !await Service()
              .setXboardDirectAddresses(
                addresses.map((address) => address.address).toList(),
              )
              .timeout(const Duration(seconds: 3), onTimeout: () => false)) {
        throw const SocketException('XBoard physical route unavailable');
      }
    });
    _directRouteQueue = update.catchError((Object _) {});
    return update;
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
