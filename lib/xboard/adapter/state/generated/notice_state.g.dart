// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../notice_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 鍏憡鐘舵€佺鐞?
/// 鑾峰彇鍏憡鍒楄〃

@ProviderFor(getNotices)
final getNoticesProvider = GetNoticesProvider._();

/// 鍏憡鐘舵€佺鐞?
/// 鑾峰彇鍏憡鍒楄〃

final class GetNoticesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NoticeModel>>,
          List<NoticeModel>,
          FutureOr<List<NoticeModel>>
        >
    with
        $FutureModifier<List<NoticeModel>>,
        $FutureProvider<List<NoticeModel>> {
  /// 鍏憡鐘舵€佺鐞?
  /// 鑾峰彇鍏憡鍒楄〃
  GetNoticesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getNoticesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getNoticesHash();

  @$internal
  @override
  $FutureProviderElement<List<NoticeModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NoticeModel>> create(Ref ref) {
    return getNotices(ref);
  }
}

String _$getNoticesHash() => r'ece1b2f2ee8ea6b4d0199a0b816cea51777382b0';
