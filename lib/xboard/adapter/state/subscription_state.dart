import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/adapter/initialization/sdk_provider.dart';

part 'generated/subscription_state.g.dart';

/// 璁㈤槄鐘舵€佺鐞?

/// 鑾峰彇璁㈤槄淇℃伅
@riverpod
Future<SubscriptionModel> getSubscription(Ref ref) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.subscription.getSubscription();
}

/// 鑾峰彇璁㈤槄閾炬帴
@riverpod
Future<String> getSubscribeUrl(Ref ref) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.subscription.getSubscribeUrl();
}
