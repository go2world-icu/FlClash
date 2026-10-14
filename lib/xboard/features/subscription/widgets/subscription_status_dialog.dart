import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/icons/icons.dart';
import 'package:material_ui/material_ui.dart';
import '../services/subscription_status_service.dart';
import 'package:fl_clash/l10n/l10n.dart';
class SubscriptionStatusDialog extends StatelessWidget {
  final SubscriptionStatusResult statusResult;
  final VoidCallback? onPurchase;
  final VoidCallback? onRefresh;
  const SubscriptionStatusDialog({
    super.key,
    required this.statusResult,
    this.onPurchase,
    this.onRefresh,
  });
  static Future<String?> show(
    BuildContext context,
    SubscriptionStatusResult statusResult, {
    VoidCallback? onPurchase,
    VoidCallback? onRefresh,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // 防止点击外部关闭
      builder: (context) => SubscriptionStatusDialog(
        statusResult: statusResult,
        onPurchase: onPurchase,
        onRefresh: onRefresh,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: AppShape.md,
      icon: _buildIcon(),
      title: Text(
        _getTitle(context),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              statusResult.getDetailMessage(context) ?? statusResult.getMessage(context),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            if (_shouldShowFeatureList()) ...[
              const SizedBox(height: 16),
              _buildFeatureList(context),
            ],
          ],
        ),
      ),
      actions: [
        // 使用Column实现竖排按钮，右对齐
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: _buildActions(context),
          ),
        ),
      ],
    );
  }
  Widget _buildIcon() {
    Color iconColor;
    Glyph iconData;
    Color backgroundColor;
    switch (statusResult.type) {
      case SubscriptionStatusType.noSubscription:
        iconColor = Colors.blue.shade600;
        iconData = AppGlyphs.giftCard;
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        break;
      case SubscriptionStatusType.expired:
        iconColor = Colors.red.shade600;
        iconData = AppGlyphs.clock;
        backgroundColor = Colors.red.withValues(alpha: 0.1);
        break;
      case SubscriptionStatusType.exhausted:
        iconColor = Colors.orange.shade600;
        iconData = AppGlyphs.dataUsage;
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        break;
      default:
        iconColor = Colors.green.shade600;
        iconData = AppGlyphs.checkCircle;
        backgroundColor = Colors.green.withValues(alpha: 0.1);
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: AppShape.all(12),
      ),
      child: GlyphIcon(
        iconData,
        color: iconColor,
        size: 32,
      ),
    );
  }
  String _getTitle(BuildContext context) {
    switch (statusResult.type) {
      case SubscriptionStatusType.noSubscription:
        return AppLocalizations.of(context).xboardNoAvailablePlan;
      case SubscriptionStatusType.expired:
        return AppLocalizations.of(context).xboardSubscriptionHasExpired;
      case SubscriptionStatusType.exhausted:
        return AppLocalizations.of(context).xboardTrafficUsedUp;
      default:
        return AppLocalizations.of(context).xboardSubscriptionStatus;
    }
  }
  bool _shouldShowFeatureList() {
    return statusResult.type == SubscriptionStatusType.noSubscription;
  }
  Widget _buildFeatureList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        shape: AppShape.all(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).xboardAfterPurchasingPlan,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          _buildFeatureItem(
            context,
            AppGlyphs.speed,
            AppLocalizations.of(context).xboardHighSpeedNetwork,
            AppLocalizations.of(context).xboardEnjoyFastNetworkExperience,
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            context,
            AppGlyphs.shieldCheck,
            AppLocalizations.of(context).xboardSecureEncryption,
            AppLocalizations.of(context).xboardProtectNetworkPrivacy,
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            context,
            AppGlyphs.globe,
            AppLocalizations.of(context).xboardGlobalNodes,
            AppLocalizations.of(context).xboardConnectGlobalQualityNodes,
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            context,
            AppGlyphs.supportAgent,
            AppLocalizations.of(context).xboardProfessionalSupport,
            AppLocalizations.of(context).xboard24HourCustomerService,
          ),
        ],
      ),
    );
  }
  Widget _buildFeatureItem(
    BuildContext context,
    Glyph icon,
    String title,
    String description,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            shape: AppShape.all(6),
          ),
          child: GlyphIcon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (statusResult.type == SubscriptionStatusType.expired ||
        statusResult.type == SubscriptionStatusType.exhausted) {
      actions.add(
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop('refresh');
              onRefresh?.call();
            },
            child: Text(
              AppLocalizations.of(context).xboardRefreshStatus,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      );
      actions.add(const SizedBox(height: 8));
    }
    actions.add(
      SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () => Navigator.of(context).pop('later'),
          child: Text(
            AppLocalizations.of(context).xboardHandleLater,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
    actions.add(const SizedBox(height: 8));
    actions.add(
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () {
            Navigator.of(context).pop('purchase');
            onPurchase?.call();
          },
          style: FilledButton.styleFrom(
            backgroundColor: _getPrimaryButtonColor(),
            foregroundColor: Colors.white,
          ),
          child: Text(_getPrimaryButtonText(context)),
        ),
      ),
    );
    return actions;
  }
  Color _getPrimaryButtonColor() {
    switch (statusResult.type) {
      case SubscriptionStatusType.noSubscription:
        return Colors.blue.shade600;
      case SubscriptionStatusType.expired:
        return Colors.red.shade600;
      case SubscriptionStatusType.exhausted:
        return Colors.orange.shade600;
      default:
        return Colors.green.shade600;
    }
  }
  String _getPrimaryButtonText(BuildContext context) {
    switch (statusResult.type) {
      case SubscriptionStatusType.noSubscription:
        return AppLocalizations.of(context).xboardPurchasePlan;
      case SubscriptionStatusType.expired:
        return AppLocalizations.of(context).xboardRenewPlan;
      case SubscriptionStatusType.exhausted:
        return AppLocalizations.of(context).xboardPurchaseTraffic;
      default:
        return AppLocalizations.of(context).xboardConfirmAction;
    }
  }
}