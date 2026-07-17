import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/adapter/initialization/sdk_provider.dart';

part 'generated/plan_state.g.dart';

/// 濂楅鐘舵€佺鐞?

/// 鑾峰彇濂楅鍒楄〃
@riverpod
Future<List<PlanModel>> getPlans(Ref ref) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.plan.getPlans();
}

/// 鑾峰彇鍗曚釜濂楅
@riverpod
Future<PlanModel?> getPlan(Ref ref, int id) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.plan.getPlan(id);
}
