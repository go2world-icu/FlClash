import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/plugins/service.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

class IosManager extends ConsumerStatefulWidget {
  final Widget child;

  const IosManager({super.key, required this.child});

  @override
  ConsumerState<IosManager> createState() => _IosContainerState();
}

class _IosContainerState extends ConsumerState<IosManager>
    with ServiceListener {
  @override
  void initState() {
    super.initState();
    ref.listenManual(sharedStateProvider, (prev, next) {
      if (prev != next) {
        if (prev?.needSyncSharedState != next.needSyncSharedState) {
          service?.syncState(next.needSyncSharedState);
        }
      }
    });
    service?.addListener(this);
    _dumpTunnelLog();
  }

  /// Print the PacketTunnel extension's captured stderr (Go panics, mihomo
  /// logs) from the last tunnel launch into the flutter console.
  Future<void> _dumpTunnelLog() async {
    try {
      final homeDir = await appPath.homeDirPath;
      final file = File(join(homeDir, 'ne_stderr.log'));
      if (!await file.exists()) return;
      final lines = await file.readAsLines();
      final tail = lines.length > 60
          ? lines.sublist(lines.length - 60)
          : lines;
      for (final line in tail) {
        commonPrint.log('[NE] $line');
      }
    } catch (_) {}
  }

  @override
  Future<void> dispose() async {
    service?.removeListener(this);
    super.dispose();
  }

  @override
  void onServiceEvent(CoreEvent event) {
    coreEventManager.sendEvent(event);
    super.onServiceEvent(event);
  }

  @override
  void onServiceCrash(String message) {
    coreEventManager.sendEvent(
      CoreEvent(type: CoreEventType.crash, data: message),
    );
    super.onServiceCrash(message);
  }

  @override
  void onServiceStatus(String status, int runTime) {
    commonPrint.log('vpn status: $status runTime: $runTime');
    // Reconcile UI state with NEVPNStatus — the tunnel can be toggled
    // outside the app (Settings, Shortcuts, on-demand rules, NE crash).
    final setupAction = ref.read(setupActionProvider.notifier);
    switch (status) {
      case 'connected':
        if (!setupAction.isStart) {
          setupAction.updateStatus(true, isInit: true);
        } else {
          // App-driven start: the core only became reachable now that the
          // tunnel is up — earlier RPCs were no-ops. Re-sync config so the
          // core fires `loaded` and groups/providers populate.
          setupAction.applyProfileDebounce(force: true, silence: true);
        }
      case 'disconnected':
        if (setupAction.isStart) {
          setupAction.updateStatus(false);
        }
    }
    super.onServiceStatus(status, runTime);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
