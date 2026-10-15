import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/core.dart';
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
