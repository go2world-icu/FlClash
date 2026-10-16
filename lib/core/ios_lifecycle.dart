import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/plugins/service.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether an apply has to wait because the iOS core is not reachable yet.
///
/// iOS keeps the core inside the PacketTunnel: it only accepts calls once the
/// tunnel reaches `.connected`. `isStartProvider` flips optimistically the
/// moment the user toggles the switch — still `connecting` — so it is not
/// enough on its own; the core is asked directly via `isInit`, which stays
/// false until the tunnel is up.
///
/// The apply is deferred, not dropped: `IosManager.onServiceStatus` runs it
/// again when the tunnel connects. [isBoot] is the initialize path, which
/// brings the core up itself and so must never be deferred.
Future<bool> shouldDeferApply(Ref ref, {required bool isBoot}) async {
  if (!system.isIOS || isBoot) return false;
  if (!ref.read(isStartProvider)) return true;
  return !await coreController.isInit;
}

/// Whether the core inside the packet tunnel answers at all.
///
/// The shell's status line needs the two halves apart: the tunnel being up says
/// nothing about the core, and `CoreStatus` cannot stand in for it either — on
/// iOS `CoreLib.start()` completes its own gate, so it reports connected even
/// with nothing listening on the other side.
final iosCoreReachableProvider = FutureProvider<bool>((ref) async {
  if (!ref.watch(isStartProvider)) return false;
  return coreController.isInit;
});

/// Whether the app can reach the packet tunnel provider at all.
///
/// Every core call goes through the provider, so a dead channel and a dead core
/// both read as "the core answered nothing". `ping` is answered by the provider
/// itself, so this tells them apart — which is the whole reason the shell shows
/// it beside the other two.
final iosCoreChannelProvider = FutureProvider<bool>((ref) async {
  if (!system.isIOS) return false;
  return await service?.ping() ?? false;
});
