import 'package:flutter/material.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/models/models.dart' as fl_models;
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/xboard/features/auth/auth.dart';
enum SubscriptionStatusType {
  valid,
  noSubscription,
  expired,
  exhausted,
  notLoggedIn,
}
class SubscriptionStatusResult {
  final SubscriptionStatusType type;
  final String Function(BuildContext) messageBuilder;
  final String? Function(BuildContext)? detailMessageBuilder;
  final DateTime? expiredAt;
  final int? remainingDays;
  final bool needsDialog;
  const SubscriptionStatusResult({
    required this.type,
    required this.messageBuilder,
    this.detailMessageBuilder,
    this.expiredAt,
    this.remainingDays,
    this.needsDialog = false,
  });
  String getMessage(BuildContext context) => messageBuilder(context);
  String? getDetailMessage(BuildContext context) => detailMessageBuilder?.call(context);
  bool get shouldShowDialog => needsDialog;
}
class SubscriptionStatusService {
  static const SubscriptionStatusService _instance = SubscriptionStatusService._internal();
  factory SubscriptionStatusService() => _instance;
  const SubscriptionStatusService._internal();
  SubscriptionStatusResult checkSubscriptionStatus({
    required UserAuthState userState,
    fl_models.SubscriptionInfo? profileSubscriptionInfo,
    bool isRefreshing = false,
  }) {
    // 馃敡 DEBUG: 寮哄埗鏄剧ず杩囨湡鎻愰啋瀵硅瘽妗嗭紝鏂逛究璋冭瘯
    const bool debugForceExpired = false;
    if (debugForceExpired && userState.isAuthenticated) {
      return SubscriptionStatusResult(
        type: SubscriptionStatusType.expired,
        messageBuilder: (context) => AppLocalizations.of(context).subscriptionExpired,
        detailMessageBuilder: (context) => AppLocalizations.of(context).subscriptionExpiredDetail('2024-11-01'),
        expiredAt: DateTime.now().subtract(const Duration(days: 3)),
        remainingDays: -3,
        needsDialog: true,
      );
    }
    
    if (!userState.isAuthenticated) {
      return SubscriptionStatusResult(
        type: SubscriptionStatusType.notLoggedIn,
        messageBuilder: (context) => AppLocalizations.of(context).subscriptionNotLoggedIn,
        detailMessageBuilder: (context) => AppLocalizations.of(context).subscriptionNotLoggedInDetail,
        needsDialog: false,
      );
    }
    
    // 鍙娇鐢?profileSubscriptionInfo 浣滀负鏁版嵁婧?
    if (profileSubscriptionInfo == null) {
      // 濡傛灉姝ｅ湪鍒锋柊璁㈤槄锛岃繑鍥?鍒锋柊涓?鐘舵€佽€岄潪"鏃犺闃?锛岄伩鍏?UI 鐭殏鏄剧ず璐拱璁㈤槄
      if (isRefreshing) {
        return SubscriptionStatusResult(
          type: SubscriptionStatusType.valid,
          messageBuilder: (context) => AppLocalizations.of(context).subscriptionValid,
          detailMessageBuilder: null,
          needsDialog: false,
        );
      }
      return SubscriptionStatusResult(
        type: SubscriptionStatusType.noSubscription,
        messageBuilder: (context) => AppLocalizations.of(context).subscriptionNoSubscription,
        detailMessageBuilder: (context) => AppLocalizations.of(context).subscriptionNoSubscriptionDetail,
        needsDialog: true,
      );
    }
    
    // 妫€鏌ヨ繃鏈熸椂闂?
    final expiredAt = _getExpiredAt(profileSubscriptionInfo);
    if (expiredAt != null) {
      final now = DateTime.now();
      final isExpired = now.isAfter(expiredAt);
      final remainingDays = expiredAt.difference(now).inDays;
      if (isExpired || remainingDays < 0) {
        return SubscriptionStatusResult(
          type: SubscriptionStatusType.expired,
          messageBuilder: (context) => AppLocalizations.of(context).subscriptionExpired,
          detailMessageBuilder: (context) => AppLocalizations.of(context).subscriptionExpiredDetail(_formatDate(expiredAt)),
          expiredAt: expiredAt,
          remainingDays: remainingDays,
          needsDialog: true,
        );
      }
      if (remainingDays == 0) {
        return SubscriptionStatusResult(
          type: SubscriptionStatusType.expired,
          messageBuilder: (context) => AppLocalizations.of(context).subscriptionExpiresToday,
          detailMessageBuilder: (context) => AppLocalizations.of(context).subscriptionExpiresTodayDetail,
          expiredAt: expiredAt,
          remainingDays: remainingDays,
          needsDialog: true,
        );
      }
      if (remainingDays <= 3) {
        return SubscriptionStatusResult(
          type: SubscriptionStatusType.valid,
          messageBuilder: (context) => AppLocalizations.of(context).subscriptionExpiringInDays,
          detailMessageBuilder: (context) => AppLocalizations.of(context).subscriptionExpiringInDaysDetail(remainingDays),
          expiredAt: expiredAt,
          remainingDays: remainingDays,
          needsDialog: false, // 鍗冲皢杩囨湡涓嶅己鍒跺脊绐?
        );
      }
    }
    
    // 妫€鏌ユ祦閲忕姸鎬?
    final trafficStatus = _checkTrafficStatus(profileSubscriptionInfo);
    if (trafficStatus != null) {
      return trafficStatus;
    }
    
    final remainingDays = expiredAt?.difference(DateTime.now()).inDays;
    return SubscriptionStatusResult(
      type: SubscriptionStatusType.valid,
      messageBuilder: (context) => AppLocalizations.of(context).subscriptionValid,
      detailMessageBuilder: remainingDays != null 
        ? (context) => AppLocalizations.of(context).subscriptionValidDetail(remainingDays)
        : null,
      expiredAt: expiredAt,
      remainingDays: remainingDays,
      needsDialog: false,
    );
  }
  DateTime? _getExpiredAt(
    fl_models.SubscriptionInfo? profileSubscriptionInfo,
  ) {
    if (profileSubscriptionInfo?.expire != null && profileSubscriptionInfo!.expire != 0) {
      return DateTime.fromMillisecondsSinceEpoch(profileSubscriptionInfo.expire * 1000);
    }
    return null;
  }
  SubscriptionStatusResult? _checkTrafficStatus(
    fl_models.SubscriptionInfo? profileSubscriptionInfo,
  ) {
    if (profileSubscriptionInfo == null || profileSubscriptionInfo.total <= 0) {
      return null;
    }
    
    final usedTraffic = (profileSubscriptionInfo.upload + profileSubscriptionInfo.download).toDouble();
    final totalTraffic = profileSubscriptionInfo.total.toDouble();
    final usageRatio = usedTraffic / totalTraffic;
    
    if (usageRatio >= 0.95) {
      return SubscriptionStatusResult(
        type: SubscriptionStatusType.exhausted,
        messageBuilder: (context) => AppLocalizations.of(context).subscriptionTrafficExhausted,
        detailMessageBuilder: (context) => AppLocalizations.of(context).subscriptionTrafficExhaustedDetail,
        needsDialog: true,
      );
    }
    return null;
  }
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  bool shouldShowStartupDialog(SubscriptionStatusResult result) {
    // 棣栭〉濂楅鍗＄墖宸茬粡灞曠ず浜嗘墍鏈夎闃呯姸鎬侊紝杩欓噷涓嶅啀寮硅闃呯姸鎬佸脊绐?
    return false;
  }
}
final subscriptionStatusService = SubscriptionStatusService();