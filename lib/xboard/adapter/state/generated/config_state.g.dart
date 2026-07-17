// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../config_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 閰嶇疆鐘舵€佺鐞?
/// 鑾峰彇閰嶇疆

@ProviderFor(getConfig)
final getConfigProvider = GetConfigProvider._();

/// 閰嶇疆鐘舵€佺鐞?
/// 鑾峰彇閰嶇疆

final class GetConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConfigModel>,
          ConfigModel,
          FutureOr<ConfigModel>
        >
    with $FutureModifier<ConfigModel>, $FutureProvider<ConfigModel> {
  /// 閰嶇疆鐘舵€佺鐞?
  /// 鑾峰彇閰嶇疆
  GetConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getConfigHash();

  @$internal
  @override
  $FutureProviderElement<ConfigModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ConfigModel> create(Ref ref) {
    return getConfig(ref);
  }
}

String _$getConfigHash() => r'2aec82194052903c04d301e756524c0f47652eb3';
