import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/plugins/service.dart';
import 'package:fl_clash/plugins/ios_service.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

const _logger = FileLogger('xboard_core_validation.dart');

// PacketTunnel 无法访问 Runner 缓存，在线校验文件必须放在 App Group。

/// 探一次 core 是否可达。默认问本平台的 [service]。
typedef XBoardCoreReachability = Future<bool> Function();

/// iOS 上 core 现在能不能被问到。其余平台恒为 true。
///
/// 隧道 `connected` 但 core 还没 boot（扩展刚起来）同样算不可达：
/// `ping` 能到扩展，`getCoreState` 才说明 core 在不在。
Future<bool> xboardCoreReachable({Service? probe}) async {
  if (!system.isIOS) return true;
  final channel = probe ?? service;
  if (channel == null) return false;
  if (await channel.ping() != true) return false;
  return (await channel.coreState())?.booted ?? false;
}

/// 面板交给 `Profile.saveFile(validate:)` 的校验函数。
Future<String> xboardValidateProfile(String path, String ageSecretKey) =>
    xboardValidateProfileWith(
      path,
      ageSecretKey,
      core: coreController,
      reachable: xboardCoreReachable,
    );

/// [xboardValidateProfile] 的可注入版本，便于测试。
///
/// 带 age 密钥时一律走 core：解密是 core 的事，拿不到 key 的错误也要原样抛出。
Future<String> xboardValidateProfileWith(
  String path,
  String ageSecretKey, {
  required CoreController core,
  required XBoardCoreReachability reachable,
  bool? isIOS,
}) async {
  if (ageSecretKey.isNotEmpty || await reachable()) {
    Future<String> validate(String corePath) => ageSecretKey.isNotEmpty
        ? core.validateProfile(corePath, ageSecretKey)
        : core.validateConfig(corePath);
    if (!(isIOS ?? system.isIOS)) return validate(path);
    return _withSharedValidationFile((file) async {
      await File(path).copy(file.path);
      final message = await validate(file.path);
      if (message.isEmpty && ageSecretKey.isNotEmpty) {
        await file.copy(path);
      }
      return message;
    });
  }
  _logger.info('iOS core 不可达，跳过 core 校验，先保存配置: $path');
  return xboardValidateConfigFile(path);
}

/// `CoreController.validateConfigWithData` 的替代，语义相同、只在 core 不可达
/// 时降级为本地校验。
Future<String> xboardValidateConfigData(String data) =>
    xboardValidateConfigDataWith(
      data,
      core: coreController,
      reachable: xboardCoreReachable,
    );

/// [xboardValidateConfigData] 的可注入版本，便于测试。
Future<String> xboardValidateConfigDataWith(
  String data, {
  required CoreController core,
  required XBoardCoreReachability reachable,
  bool? isIOS,
}) async {
  if (await reachable()) {
    if (isIOS ?? system.isIOS) {
      return _withSharedValidationFile((file) async {
        await file.writeAsString(data, flush: true);
        return core.validateConfig(file.path);
      });
    }
    return core.validateConfigWithData(data);
  }
  _logger.info('iOS core 不可达，跳过 core 校验，先保存配置');
  return xboardValidateConfigContent(data);
}

Future<String> _withSharedValidationFile(
  Future<String> Function(File) validate,
) async {
  final root = Directory(p.join(await appPath.homeDirPath, '.validation'));
  await root.create(recursive: true);
  final directory = await root.createTemp('profile-');
  try {
    return await validate(File(p.join(directory.path, 'config.yaml')));
  } finally {
    await directory.delete(recursive: true);
  }
}

/// 文件版的本地校验，用于 [xboardValidateProfile]。
Future<String> xboardValidateConfigFile(String path) async {
  try {
    return xboardValidateConfigContent(await File(path).readAsString());
  } on FileSystemException catch (error) {
    return '无法读取配置文件: $error';
  }
}

/// 本地结构校验：这份内容像不像一份能交给 mihomo 的 Clash 配置。
///
/// 它检查的是「值不值得先存下来」，不是「mihomo 会不会接受」——后者仍然只有
/// core 说了算，而 core 会在隧道起来时看到它。
String xboardValidateConfigContent(String content) {
  final Object? document;
  try {
    document = loadYaml(content);
  } catch (error) {
    return '配置不是合法的 YAML: $error';
  }
  if (document is! Map) {
    // 空回复、纯文本、HTML 错误页都落在这里。
    return '配置内容不是一个 YAML 映射';
  }
  if (document['panels'] is Map && !document.containsKey('proxies')) {
    // 面板的远程配置（`lib/xboard/config/` 里那份）也是 YAML，别把两者看混。
    return '订阅内容是一份面板配置，不是代理配置';
  }
  final hasProxies = document['proxies'] is List;
  final hasProviders = document['proxy-providers'] is Map;
  if (!hasProxies && !hasProviders) {
    return '配置里没有 proxies 或 proxy-providers 段落';
  }
  if (hasProxies && !hasProviders && (document['proxies'] as List).isEmpty) {
    return '配置里没有节点';
  }
  return '';
}
