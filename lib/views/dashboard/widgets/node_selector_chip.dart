import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/views/proxies/proxies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NodeSelectorChip extends ConsumerWidget {
  const NodeSelectorChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Same visibility condition as StartButton
    final hasProfile = ref.watch(
      profilesProvider.select((state) => state.isNotEmpty),
    );
    if (!hasProfile) {
      return const SizedBox.shrink();
    }

    final groups = ref.watch(groupsProvider);
    final selectedMap = ref.watch(selectedMapProvider);
    final mode = ref.watch(
      patchClashConfigProvider.select((state) => state.mode),
    );

    if (groups.isEmpty) {
      return const SizedBox.shrink();
    }

    // Find the most relevant group and its currently selected proxy
    Group? currentGroup;
    if (mode == Mode.global) {
      currentGroup = groups.firstWhere(
        (group) => group.name == GroupName.GLOBAL.name,
        orElse: () => groups.first,
      );
    } else if (mode == Mode.rule) {
      // Find first non-global, non-hidden group that has a selection
      for (final group in groups) {
        if (group.hidden == true) continue;
        if (group.name == GroupName.GLOBAL.name) continue;
        currentGroup = group;
        break;
      }
      currentGroup ??= groups.firstWhere(
        (group) => group.hidden != true && group.name != GroupName.GLOBAL.name,
        orElse: () => groups.first,
      );
    }

    if (currentGroup == null || currentGroup.all.isEmpty) {
      return const SizedBox.shrink();
    }
    final group = currentGroup;

    final selectedProxyName = selectedMap[group.name] ?? '';
    final realNodeName = group.type.isComputedSelected
        ? (group.now ?? '')
        : group.getCurrentSelectedName(selectedProxyName);

    final currentProxy = realNodeName.isNotEmpty
        ? group.all.firstWhere(
            (proxy) => proxy.name == realNodeName,
            orElse: () => group.all.first,
          )
        : group.all.first;

    return _buildChip(context, ref, currentProxy);
  }

  Widget _buildChip(BuildContext context, WidgetRef ref, Proxy proxy) {
    final delay = ref.watch(
      delayProvider(
        proxyName: proxy.name,
        testUrl: ref.read(appSettingProvider).testUrl,
      ),
    );
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.3),
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const ProxiesView()));
        },
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100),
                  child: Text(
                    proxy.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _LatencyDot(theme: theme, delay: delay),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LatencyDot extends StatelessWidget {
  const _LatencyDot({required this.theme, required this.delay});

  final ThemeData theme;
  final int? delay;

  @override
  Widget build(BuildContext context) {
    final hasDelay = delay != null && delay! > 0;
    final color = utils.getDelayColor(delay) ?? theme.colorScheme.outline;
    final text = hasDelay ? '$delay ms' : '--';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
