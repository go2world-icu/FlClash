import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/adapter/initialization/sdk_provider.dart';

part 'generated/order_state.g.dart';

/// 璁㈠崟鐘舵€佺鐞?

/// 鑾峰彇璁㈠崟鍒楄〃
@riverpod
Future<List<OrderModel>> getOrders(Ref ref) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.order.getOrders();
}

/// 鑾峰彇鍗曚釜璁㈠崟
@riverpod
Future<OrderModel?> getOrder(Ref ref, String tradeNo) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.order.getOrder(tradeNo);
}

/// 鑾峰彇璁㈠崟鏀粯鏂瑰紡
@riverpod
Future<List<PaymentMethodModel>> getOrderPaymentMethods(Ref ref, String tradeNo) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.order.getPaymentMethods(tradeNo);
}

/// 妫€鏌ヤ紭鎯犲埜
@riverpod
Future<CouponModel?> checkCoupon(Ref ref, {required String code, required int planId}) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.order.checkCoupon(code, planId);
}
