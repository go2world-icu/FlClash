// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 鐢ㄦ埛鐘舵€佺鐞?
/// 鑾峰彇鐢ㄦ埛淇℃伅

@ProviderFor(getUserInfo)
final getUserInfoProvider = GetUserInfoProvider._();

/// 鐢ㄦ埛鐘舵€佺鐞?
/// 鑾峰彇鐢ㄦ埛淇℃伅

final class GetUserInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserModel>,
          UserModel,
          FutureOr<UserModel>
        >
    with $FutureModifier<UserModel>, $FutureProvider<UserModel> {
  /// 鐢ㄦ埛鐘舵€佺鐞?
  /// 鑾峰彇鐢ㄦ埛淇℃伅
  GetUserInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getUserInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getUserInfoHash();

  @$internal
  @override
  $FutureProviderElement<UserModel> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserModel> create(Ref ref) {
    return getUserInfo(ref);
  }
}

String _$getUserInfoHash() => r'9f2d7f5a10b72d23ba4f0010b04b842a132dcf0f';
