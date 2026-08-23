import 'dart:convert';
import 'dart:io';

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
  static Future<DomainRacingResult?> load() async {
    try {
      final file = await _file();
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final domain = json['domain'] as String?;
      if (domain == null || domain.isEmpty) return null;
      return DomainRacingResult(
        domain: domain,
        useProxy: json['useProxy'] == true,
        proxyUrl: json['proxyUrl'] as String?,
        responseTime: (json['responseTime'] as num?)?.toInt() ?? 0,
      );
    } catch (e) {
      XBoardLogger.info('[RacingResultCache] 读取缓存失败: $e');
      return null;
    }
  }

  /// 保存竞速结果。写入失败静默忽略。
  static Future<void> save(DomainRacingResult result) async {
    try {
      final file = await _file();
      await file.writeAsString(jsonEncode({
        'domain': result.domain,
        'useProxy': result.useProxy,
        'proxyUrl': result.proxyUrl,
        'responseTime': result.responseTime,
      }));
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
