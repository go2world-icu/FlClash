import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/adapter/initialization/sdk_provider.dart';

part 'generated/config_state.g.dart';

/// 閰嶇疆鐘舵€佺鐞?

/// 鑾峰彇閰嶇疆
@riverpod
Future<ConfigModel> getConfig(Ref ref) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.config.getConfig();
}
