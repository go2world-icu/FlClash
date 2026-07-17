import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/adapter/initialization/sdk_provider.dart';

part 'generated/payment_state.g.dart';

/// 鏀粯鐘舵€佺鐞?

/// 鑾峰彇鏀粯鏂瑰紡鍒楄〃
@riverpod
Future<List<PaymentMethodModel>> getPaymentMethods(Ref ref) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.payment.getPaymentMethods();
}
