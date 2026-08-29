import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 网络检测（出口 IP 与归属地），供 iOS 外壳首页使用。
///
/// 复用主应用的 [networkDetectionProvider]，仅做展示层适配；
/// 视觉风格对齐 [XBoardOutboundModeSelector]。
class XBoardNetworkDetection extends ConsumerStatefulWidget {
  const XBoardNetworkDetection({super.key});

  @override
  ConsumerState<XBoardNetworkDetection> createState() =>
      _XBoardNetworkDetectionState();
}

class _XBoardNetworkDetectionState
    extends ConsumerState<XBoardNetworkDetection> {
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    // 主应用的检测触发依赖仪表盘配置里是否包含 networkDetection 组件；
    // iOS 外壳首页不渲染仪表盘网格，这里兜底触发一次，保证组件独立可用。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_triggered || !mounted) return;
      _triggered = true;
      final state = ref.read(networkDetectionProvider);
      if (state.ipInfo == null && !state.isLoading) {
        ref.read(networkDetectionProvider.notifier).startCheck();
      }
    });
  }

  String _countryCodeToEmoji(String countryCode) {
    final String code = countryCode.toUpperCase();
    if (code.length != 2) {
      return countryCode;
    }
    final int firstLetter = code.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = code.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    final state = ref.watch(networkDetectionProvider);
    final ipInfo = state.ipInfo;
    final isLoading = state.isLoading;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(
            Icons.network_check,
            color: theme.colorScheme.primary,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            appLocalizations.networkDetection,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (isLoading)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.primary,
              ),
            )
          else if (ipInfo != null)
            Row(
              children: [
                Text(
                  _countryCodeToEmoji(ipInfo.countryCode),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  ipInfo.ip,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            )
          else
            Text(
              appLocalizations.timeout,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}
