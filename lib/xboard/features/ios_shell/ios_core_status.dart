import 'dart:async';

import 'package:fl_clash/core/ios_lifecycle.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/color.dart';
import 'package:fl_clash/ui/context.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where the shell's startup got to, for the navigation bar's actions.
///
/// The tunnel and the Core inside it are separate: the switch flips the tunnel
/// immediately, while the Core only answers once the packet tunnel provider has
/// booted it. A screen that shows only the first says "connected" while the node
/// list stays empty, which is the failure this is meant to make visible — so the
/// Core line is probed through [iosCoreReachableProvider] rather than read off
/// `CoreStatus`, which cannot tell the two apart on iOS.
///
/// The state word only appears when something is down: at rest this is two
/// dots, and the sentence behind them lives in the tooltip, which keeps it from
/// growing wide enough to crowd the title in any locale.
class IosCoreStatus extends ConsumerStatefulWidget {
  const IosCoreStatus({super.key});

  @override
  ConsumerState<IosCoreStatus> createState() => _IosCoreStatusState();
}

class _IosCoreStatusState extends ConsumerState<IosCoreStatus> {
  /// The Core boots a moment after the tunnel does, and a one-shot probe taken
  /// in that window would read "not ready" forever.
  static const _retryInterval = Duration(seconds: 2);

  Timer? _retry;
  bool _wasReady = false;

  @override
  void dispose() {
    _retry?.cancel();
    super.dispose();
  }

  void _scheduleRetry({required bool tunnelUp, required bool allUp}) {
    if (allUp || !tunnelUp) {
      _retry?.cancel();
      _retry = null;
      return;
    }
    _retry ??= Timer.periodic(_retryInterval, (_) {
      if (!mounted) return;
      ref.invalidate(iosCoreChannelProvider);
      ref.invalidate(iosCoreBootProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tunnelUp = ref.watch(isStartProvider);
    final channelUp = ref.watch(iosCoreChannelProvider).value ?? false;
    final core = ref.watch(iosCoreBootProvider).value;
    final coreBooted = core?.booted ?? false;
    if (coreBooted != _wasReady) {
      _wasReady = coreBooted;
      _retry?.cancel();
      _retry = null;
    }
    _scheduleRetry(tunnelUp: tunnelUp, allUp: channelUp && coreBooted);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StatusLine(label: xboardL10n.iosTunnel, isUp: tunnelUp),
        const SizedBox(width: 10),
        _StatusLine(label: xboardL10n.iosChannel, isUp: channelUp),
        const SizedBox(width: 10),
        _StatusLine(
          label: xboardL10n.iosCore,
          isUp: coreBooted,
          // The extension's own account of what it did, which is what makes a
          // red dot actionable: boot failure and a silent call look the same
          // from here otherwise.
          detail: core == null
              ? null
              : 'booted=${core.booted} tun=${core.tunStarted}'
                    '${core.error.isEmpty ? '' : ' error=${core.error}'}',
        ),
      ],
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.label, required this.isUp, this.detail});

  final String label;
  final bool isUp;

  /// Extra facts for the tooltip, when the dot alone cannot say enough.
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    // The label never changes and never moves: the dot is the whole state, so
    // the row keeps its width when something goes down.
    return Tooltip(
      message:
          '$label: ${isUp ? xboardL10n.ready : xboardL10n.notReady}'
          '${detail == null ? '' : '\n$detail'}',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isUp ? colorScheme.success : colorScheme.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
