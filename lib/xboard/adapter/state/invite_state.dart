import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/adapter/initialization/sdk_provider.dart';

part 'generated/invite_state.g.dart';

/// 閭€璇风姸鎬佺鐞?

/// 鑾峰彇閭€璇蜂俊鎭?
@riverpod
Future<InviteInfoModel> getInviteInfo(Ref ref) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.invite.getInviteInfo();
}

/// 鑾峰彇閭€璇风爜鍒楄〃
@riverpod
Future<List<InviteCodeModel>> getInviteCodes(Ref ref) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.invite.getInviteCodes();
}

/// 鑾峰彇浣ｉ噾璇︽儏
@riverpod
Future<List<CommissionDetailModel>> getCommissionDetails(Ref ref, {int page = 1}) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.invite.getCommissionDetails(page: page);
}
