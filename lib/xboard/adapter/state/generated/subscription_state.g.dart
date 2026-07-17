// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../subscription_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 璁㈤槄鐘舵€佺鐞?
/// 鑾峰彇璁㈤槄淇℃伅

@ProviderFor(getSubscription)
final getSubscriptionProvider = GetSubscriptionProvider._();

/// 璁㈤槄鐘舵€佺鐞?
/// 鑾峰彇璁㈤槄淇℃伅

final class GetSubscriptionProvider
    extends
        $FunctionalProvider<
          AsyncValue<SubscriptionModel>,
          SubscriptionModel,
          FutureOr<SubscriptionModel>
        >
    with
        $FutureModifier<SubscriptionModel>,
        $FutureProvider<SubscriptionModel> {
  /// 璁㈤槄鐘舵€佺鐞?
  /// 鑾峰彇璁㈤槄淇℃伅
  GetSubscriptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSubscriptionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSubscriptionHash();

  @$internal
  @override
  $FutureProviderElement<SubscriptionModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SubscriptionModel> create(Ref ref) {
    return getSubscription(ref);
  }
}

String _$getSubscriptionHash() => r'd07a7f196c50dba9384d2417bdcb5b2367b5e968';

/// 鑾峰彇璁㈤槄閾炬帴

@ProviderFor(getSubscribeUrl)
final getSubscribeUrlProvider = GetSubscribeUrlProvider._();

/// 鑾峰彇璁㈤槄閾炬帴

final class GetSubscribeUrlProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 鑾峰彇璁㈤槄閾炬帴
  GetSubscribeUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSubscribeUrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSubscribeUrlHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return getSubscribeUrl(ref);
  }
}

String _$getSubscribeUrlHash() => r'77288d5b3b57d2f05763579e811864dd74923f59';
