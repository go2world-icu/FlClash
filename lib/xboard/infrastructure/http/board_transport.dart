import 'dart:io';

import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/config/utils/config_file_loader.dart';
import 'package:fl_clash/xboard/infrastructure/http/user_agent_config.dart';

import 'ios_board_resolver.dart';

class XBoardTransport {
  static Future<void> ensureDirectRoute(Uri url) async {
    if (Platform.isIOS) await IosBoardResolver.resolve(url.host);
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
      addressResolver: Platform.isIOS ? IosBoardResolver.resolve : null,
    );
  }

  static Future<HttpClient> create(Uri url, {String? proxyUrl}) async {
    if (url.scheme != 'https') {
      throw const FormatException('XBoard endpoint must use HTTPS');
    }
    return BoardHttpClient.create(
      host: url.host,
      config: await config(proxyUrl: proxyUrl),
    );
  }
}
