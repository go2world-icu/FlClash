// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../invite_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 閭€璇风姸鎬佺鐞?
/// 鑾峰彇閭€璇蜂俊鎭?

@ProviderFor(getInviteInfo)
final getInviteInfoProvider = GetInviteInfoProvider._();

/// 閭€璇风姸鎬佺鐞?
/// 鑾峰彇閭€璇蜂俊鎭?

final class GetInviteInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<InviteInfoModel>,
          InviteInfoModel,
          FutureOr<InviteInfoModel>
        >
    with $FutureModifier<InviteInfoModel>, $FutureProvider<InviteInfoModel> {
  /// 閭€璇风姸鎬佺鐞?
  /// 鑾峰彇閭€璇蜂俊鎭?
  GetInviteInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getInviteInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getInviteInfoHash();

  @$internal
  @override
  $FutureProviderElement<InviteInfoModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<InviteInfoModel> create(Ref ref) {
    return getInviteInfo(ref);
  }
}

String _$getInviteInfoHash() => r'74c10a237ebcd8842fec1d4ea506bea75c40423a';

/// 鑾峰彇閭€璇风爜鍒楄〃

@ProviderFor(getInviteCodes)
final getInviteCodesProvider = GetInviteCodesProvider._();

/// 鑾峰彇閭€璇风爜鍒楄〃

final class GetInviteCodesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InviteCodeModel>>,
          List<InviteCodeModel>,
          FutureOr<List<InviteCodeModel>>
        >
    with
        $FutureModifier<List<InviteCodeModel>>,
        $FutureProvider<List<InviteCodeModel>> {
  /// 鑾峰彇閭€璇风爜鍒楄〃
  GetInviteCodesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getInviteCodesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getInviteCodesHash();

  @$internal
  @override
  $FutureProviderElement<List<InviteCodeModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<InviteCodeModel>> create(Ref ref) {
    return getInviteCodes(ref);
  }
}

String _$getInviteCodesHash() => r'676cbfe101ebba153b35db651d763f4fefdcafd2';

/// 鑾峰彇浣ｉ噾璇︽儏

@ProviderFor(getCommissionDetails)
final getCommissionDetailsProvider = GetCommissionDetailsFamily._();

/// 鑾峰彇浣ｉ噾璇︽儏

final class GetCommissionDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CommissionDetailModel>>,
          List<CommissionDetailModel>,
          FutureOr<List<CommissionDetailModel>>
        >
    with
        $FutureModifier<List<CommissionDetailModel>>,
        $FutureProvider<List<CommissionDetailModel>> {
  /// 鑾峰彇浣ｉ噾璇︽儏
  GetCommissionDetailsProvider._({
    required GetCommissionDetailsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getCommissionDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getCommissionDetailsHash();

  @override
  String toString() {
    return r'getCommissionDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CommissionDetailModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CommissionDetailModel>> create(Ref ref) {
    final argument = this.argument as int;
    return getCommissionDetails(ref, page: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCommissionDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getCommissionDetailsHash() =>
    r'346bcab5827cfa18d54c25999ee34d21ab15b315';

/// 鑾峰彇浣ｉ噾璇︽儏

final class GetCommissionDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CommissionDetailModel>>, int> {
  GetCommissionDetailsFamily._()
    : super(
        retry: null,
        name: r'getCommissionDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 鑾峰彇浣ｉ噾璇︽儏

  GetCommissionDetailsProvider call({int page = 1}) =>
      GetCommissionDetailsProvider._(argument: page, from: this);

  @override
  String toString() => r'getCommissionDetailsProvider';
}
