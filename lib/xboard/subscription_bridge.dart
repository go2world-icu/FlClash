import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/xboard/features/subscription/services/subscription_downloader.dart';
import 'config_check.dart';

/// 通过 xboard 竞速下载器导入订阅并保存到 profilesProvider
///
/// 返回 Profile 或 null（失败时）
Future<Profile?> xboardImportAndSave(Ref ref, String url) async {
  if (!ref.read(xboardEnabledProvider)) return null;

  try {
    final profile = await SubscriptionDownloader.downloadSubscription(
      url,
      enableRacing: true,
    );
    ref.read(profilesProvider.notifier).put(profile);
    return profile;
  } catch (e) {
    return null;
  }
}
