import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/ios_lifecycle.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// How far the shell's startup got, in two lines because it has two halves.
///
/// The tunnel and the Core inside it are separate: the switch flips the tunnel
/// immediately, while the Core only answers once the packet tunnel provider has
/// booted it. A screen that shows only the first says "connected" while the
/// node list stays empty, which is the failure this is meant to make visible —
/// so the Core line is probed through [iosCoreReachableProvider] rather than
/// read off `CoreStatus`, which cannot tell them apart on iOS.
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

  void _scheduleRetry({required bool tunnelUp, required bool coreReady}) {
    if (coreReady || !tunnelUp) {
      _wasReady = coreReady;
      _retry?.cancel();
      _retry = null;
      return;
    }
    if (_retry != null) return;
    _retry = Timer.periodic(_retryInterval, (_) {
      if (!mounted) return;
      ref.invalidate(iosCoreReachableProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tunnelUp = ref.watch(isStartProvider);
    final coreReady = ref.watch(iosCoreReachableProvider).value ?? false;
    if (coreReady != _wasReady) {
      _wasReady = coreReady;
      _retry?.cancel();
      _retry = null;
    }
    _scheduleRetry(tunnelUp: tunnelUp, coreReady: coreReady);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: _StatusLine(label: xboardL10n.iosTunnel, isUp: tunnelUp),
            ),
            Expanded(
              child: _StatusLine(label: xboardL10n.iosCore, isUp: coreReady),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.label, required this.isUp});

  final String label;
  final bool isUp;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Row(
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
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            '$label ${isUp ? xboardL10n.ready : xboardL10n.notReady}',
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelMedium?.copyWith(
              color: isUp
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
