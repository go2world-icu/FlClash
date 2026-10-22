import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/plugins/service.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:yaml/yaml.dart';

const _logger = FileLogger('xboard_core_validation.dart');

/// 面板的配置校验，iOS 上核心不可达时怎么做。
///
/// iOS 的 Go core 只链接进 PacketTunnel 扩展（`Mobile.xcframework` 不在 Runner
/// 的 Frameworks phase 里），应用进程问它的每一次调用都要经
/// `ServiceChannel` → `sendProviderMessage` 转给扩展，而扩展只在隧道
/// `.connected` 时才转发。于是「登录后自动导入订阅」「手动加订阅」这类
/// **隧道还没开时的校验**必然拿不到答案：上游 v0.9.1 起
/// `CoreHandlerInterface._invokeMessage` 把空回复抛成
/// `CoreMethodException('Core did not answer validateConfig')`，
/// 导入就此失败——而 `login()` 并不 await 这次导入，用户只看到「无可用套餐」。
///
/// （v0.8.96 之所以「能用」，是因为当时 null 被 `?? ''` 读成「配置没问题」，
/// 校验其实没做。）
///
/// 所以 iOS 上分两步：
/// 1. 先探 core 是否可达。`ping` / `getCoreState` 由扩展自己回答、不经过 core，
///    这正是它们存在的理由（见 `lib/core/ios_lifecycle.dart`）；
/// 2. 不可达就**跳过 core 校验、先把配置存下来**，改做本地结构校验兜底。
///    权威校验推迟到用户点连接、隧道真的起来之后——那时 `applyProfile` 会把
///    这份配置交给 core，起不来会以 core 的错误呈现，不会静默。
///
/// 其余平台（Android 的 core 在应用内、桌面走 socket）行为完全不变。

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
}) async {
  if (ageSecretKey.isNotEmpty) {
    return core.validateProfile(path, ageSecretKey);
  }
  if (await reachable()) {
    return core.validateConfig(path);
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
}) async {
  if (await reachable()) {
    return core.validateConfigWithData(data);
  }
  _logger.info('iOS core 不可达，跳过 core 校验，先保存配置');
  return xboardValidateConfigContent(data);
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
