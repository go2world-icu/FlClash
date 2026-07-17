// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../order_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 璁㈠崟鐘舵€佺鐞?
/// 鑾峰彇璁㈠崟鍒楄〃

@ProviderFor(getOrders)
final getOrdersProvider = GetOrdersProvider._();

/// 璁㈠崟鐘舵€佺鐞?
/// 鑾峰彇璁㈠崟鍒楄〃

final class GetOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrderModel>>,
          List<OrderModel>,
          FutureOr<List<OrderModel>>
        >
    with $FutureModifier<List<OrderModel>>, $FutureProvider<List<OrderModel>> {
  /// 璁㈠崟鐘舵€佺鐞?
  /// 鑾峰彇璁㈠崟鍒楄〃
  GetOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getOrdersHash();

  @$internal
  @override
  $FutureProviderElement<List<OrderModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OrderModel>> create(Ref ref) {
    return getOrders(ref);
  }
}

String _$getOrdersHash() => r'0b73f63c2561fb60631461bf003a69a8b5763e91';

/// 鑾峰彇鍗曚釜璁㈠崟

@ProviderFor(getOrder)
final getOrderProvider = GetOrderFamily._();

/// 鑾峰彇鍗曚釜璁㈠崟

final class GetOrderProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrderModel?>,
          OrderModel?,
          FutureOr<OrderModel?>
        >
    with $FutureModifier<OrderModel?>, $FutureProvider<OrderModel?> {
  /// 鑾峰彇鍗曚釜璁㈠崟
  GetOrderProvider._({
    required GetOrderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getOrderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getOrderHash();

  @override
  String toString() {
    return r'getOrderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<OrderModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OrderModel?> create(Ref ref) {
    final argument = this.argument as String;
    return getOrder(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetOrderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getOrderHash() => r'a8e667020bec541831a1f387ca761c26752dee54';

/// 鑾峰彇鍗曚釜璁㈠崟

final class GetOrderFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<OrderModel?>, String> {
  GetOrderFamily._()
    : super(
        retry: null,
        name: r'getOrderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 鑾峰彇鍗曚釜璁㈠崟

  GetOrderProvider call(String tradeNo) =>
      GetOrderProvider._(argument: tradeNo, from: this);

  @override
  String toString() => r'getOrderProvider';
}

/// 鑾峰彇璁㈠崟鏀粯鏂瑰紡

@ProviderFor(getOrderPaymentMethods)
final getOrderPaymentMethodsProvider = GetOrderPaymentMethodsFamily._();

/// 鑾峰彇璁㈠崟鏀粯鏂瑰紡

final class GetOrderPaymentMethodsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PaymentMethodModel>>,
          List<PaymentMethodModel>,
          FutureOr<List<PaymentMethodModel>>
        >
    with
        $FutureModifier<List<PaymentMethodModel>>,
        $FutureProvider<List<PaymentMethodModel>> {
  /// 鑾峰彇璁㈠崟鏀粯鏂瑰紡
  GetOrderPaymentMethodsProvider._({
    required GetOrderPaymentMethodsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getOrderPaymentMethodsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getOrderPaymentMethodsHash();

  @override
  String toString() {
    return r'getOrderPaymentMethodsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<PaymentMethodModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PaymentMethodModel>> create(Ref ref) {
    final argument = this.argument as String;
    return getOrderPaymentMethods(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetOrderPaymentMethodsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getOrderPaymentMethodsHash() =>
    r'991ffc7c2b2ef49552bd40d4a83cbb1bc431a900';

/// 鑾峰彇璁㈠崟鏀粯鏂瑰紡

final class GetOrderPaymentMethodsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<PaymentMethodModel>>, String> {
  GetOrderPaymentMethodsFamily._()
    : super(
        retry: null,
        name: r'getOrderPaymentMethodsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 鑾峰彇璁㈠崟鏀粯鏂瑰紡

  GetOrderPaymentMethodsProvider call(String tradeNo) =>
      GetOrderPaymentMethodsProvider._(argument: tradeNo, from: this);

  @override
  String toString() => r'getOrderPaymentMethodsProvider';
}

/// 妫€鏌ヤ紭鎯犲埜

@ProviderFor(checkCoupon)
final checkCouponProvider = CheckCouponFamily._();

/// 妫€鏌ヤ紭鎯犲埜

final class CheckCouponProvider
    extends
        $FunctionalProvider<
          AsyncValue<CouponModel?>,
          CouponModel?,
          FutureOr<CouponModel?>
        >
    with $FutureModifier<CouponModel?>, $FutureProvider<CouponModel?> {
  /// 妫€鏌ヤ紭鎯犲埜
  CheckCouponProvider._({
    required CheckCouponFamily super.from,
    required ({String code, int planId}) super.argument,
  }) : super(
         retry: null,
         name: r'checkCouponProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$checkCouponHash();

  @override
  String toString() {
    return r'checkCouponProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<CouponModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CouponModel?> create(Ref ref) {
    final argument = this.argument as ({String code, int planId});
    return checkCoupon(ref, code: argument.code, planId: argument.planId);
  }

  @override
  bool operator ==(Object other) {
    return other is CheckCouponProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$checkCouponHash() => r'd314daeb0560c29653818075b4d8e3d5f6b66ebc';

/// 妫€鏌ヤ紭鎯犲埜

final class CheckCouponFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<CouponModel?>,
          ({String code, int planId})
        > {
  CheckCouponFamily._()
    : super(
        retry: null,
        name: r'checkCouponProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 妫€鏌ヤ紭鎯犲埜

  CheckCouponProvider call({required String code, required int planId}) =>
      CheckCouponProvider._(argument: (code: code, planId: planId), from: this);

  @override
  String toString() => r'checkCouponProvider';
}
