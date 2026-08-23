import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/l10n/l10n.dart';

/// 出站模式选择器（仅「规则」/「全局」两种）。
///
/// 对齐主应用出站模式：切换规则/全局，切到全局时自动选中一个有效节点。
/// 相比 [XBoardOutboundMode]，去掉了 TUN 开关和直连选项，专供 iOS 外壳首页使用。
class XBoardOutboundModeSelector extends ConsumerWidget {
  const XBoardOutboundModeSelector({super.key});

  void _handleModeChange(WidgetRef ref, Mode mode) {
    ref.read(setupActionProvider.notifier).changeMode(mode);
    if (mode == Mode.global) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _selectValidProxyForGlobalMode(ref);
      });
    }
  }

  void _selectValidProxyForGlobalMode(WidgetRef ref) {
    final groups = ref.read(groupsProvider);
    if (groups.isEmpty) return;
    final globalGroup = groups.firstWhere(
      (group) => group.name == GroupName.GLOBAL.name,
      orElse: () => groups.first,
    );
    if (globalGroup.all.isEmpty) return;
    Proxy? validProxy;
    for (final proxy in globalGroup.all) {
      final name = proxy.name.toUpperCase();
      if (name != 'DIRECT' && name != 'REJECT') {
        validProxy = proxy;
        break;
      }
    }
    if (validProxy != null) {
      ref.read(proxiesActionProvider.notifier).changeProxy(
        groupName: globalGroup.name,
        proxyName: validProxy.name,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    final mode = ref.watch(
      patchClashConfigProvider.select((state) => state.mode),
    );
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tune,
                color: theme.colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                appLocalizations.outboundMode,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildModeChip(
                  theme: theme,
                  label: appLocalizations.rule,
                  selected: mode == Mode.rule,
                  onSelected: () => _handleModeChange(ref, Mode.rule),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeChip(
                  theme: theme,
                  label: appLocalizations.global,
                  selected: mode == Mode.global,
                  onSelected: () => _handleModeChange(ref, Mode.global),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeChip({
    required ThemeData theme,
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return Center(
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        selectedColor: theme.colorScheme.primaryContainer,
        checkmarkColor: theme.colorScheme.onPrimaryContainer,
        labelStyle: TextStyle(
          fontSize: 13,
          color: selected ? theme.colorScheme.onPrimaryContainer : null,
        ),
      ),
    );
  }
}
