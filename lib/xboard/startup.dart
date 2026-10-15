import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/xboard/config_check.dart';
import 'package:rust_api/rust_api.dart';

/// Everything `lib/main.dart` has to do before `bootstrap.init()`.
///
/// The config probe is the panel's; the guard around the Rust bridge is the
/// fork's, because upstream has no iOS and calls `RustLib.init()`
/// unconditionally. Both live here so a merge that takes upstream's line
/// cannot drop them quietly — the invariants test checks main.dart still calls
/// this.
Future<void> xboardStartup() async {
  await resolveXboardConfig();
  // rust_api has no iOS build — rquickjs-sys publishes no bindings for it — and
  // nothing on iOS reaches the bridge.
  if (system.isDesktop) {
    await RustLib.init();
  }
}
