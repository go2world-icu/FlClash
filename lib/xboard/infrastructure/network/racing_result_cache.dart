import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:path/path.dart';

import 'domain_racing_service.dart';

/// 域名竞速结果持久化缓存。
///
/// 冷启动时把上次竞速获胜的域名从磁盘读出来，避免每次启动都等一轮网络竞速
/// （每域名 5s 连接 / 8s 响应，是冷启动的主要耗时）。数据存到
/// `appPath.homeDirPath/xboard/` 下，与主应用配置同一位置。
///
/// 缓存只是「加速手段」，任何读写失败都静默降级 —— 不影响主流程走正常竞速。
class RacingResultCache {
  static Future<File> _file() async {
    final basePath = join(await appPath.homeDirPath, 'xboard');
    return File(join(basePath, 'racing_result.json'));
  }

  /// 读取上次竞速结果；无缓存 / 解析失败返回 null。
  static Future<DomainRacingResult?> load({
    required List<String> panelUrls,
    required List<String> proxyUrls,
  }) async {
    try {
      final file = await _file();
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final domain = json['domain'] as String?;
      if (domain == null || domain.isEmpty) return null;
      final saved = DateTime.tryParse(json['savedAt'] as String? ?? '');
      if (saved == null ||
          DateTime.now().difference(saved) > const Duration(hours: 12)) {
        return null;
      }
      final eligible = panelUrls.any((url) {
        final parsed = Uri.tryParse(url);
        return parsed != null &&
            parsed.host.isNotEmpty &&
            parsed.replace(scheme: 'https').origin == domain;
      });
      if (!eligible) return null;
      final useProxy = json['useProxy'] == true;
      String? proxy;
      if (useProxy) {
        final hash = json['proxyHash'] as String?;
        for (final configured in proxyUrls) {
          if (sha256.convert(utf8.encode(configured)).toString() == hash) {
            proxy = configured;
            break;
          }
        }
        if (proxy == null) return null;
      }
      return DomainRacingResult(
        domain: domain,
        useProxy: useProxy,
        proxyUrl: proxy,
        responseTime: (json['responseTime'] as num?)?.toInt() ?? 0,
      );
    } catch (e) {
      XBoardLogger.info('[RacingResultCache] 读取缓存失败: $e');
      return null;
    }
  }

  /// 保存竞速结果。写入失败静默忽略。
  static Future<void> save(
    DomainRacingResult result, {
    required List<String> proxyUrls,
  }) async {
    try {
      if (result.useProxy && !proxyUrls.contains(result.proxyUrl)) return;
      final file = await _file();
      await file.parent.create(recursive: true);
      await file.writeAsString(
        jsonEncode({
          'domain': result.domain,
          'useProxy': result.useProxy,
          if (result.useProxy)
            'proxyHash': sha256
                .convert(utf8.encode(result.proxyUrl!))
                .toString(),
          'responseTime': result.responseTime,
          'savedAt': DateTime.now().toUtc().toIso8601String(),
        }),
      );
    } catch (e) {
      XBoardLogger.info('[RacingResultCache] 保存缓存失败: $e');
    }
  }

  /// 清除缓存（缓存域名探活失败时调用）。
  static Future<void> clear() async {
    try {
      final file = await _file();
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }
}
