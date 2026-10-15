import 'dart:async';
import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/plugins/app.dart';
import 'package:path/path.dart';

/// Resolves the app's home directory into [dataDir].
///
/// On iOS the core runs inside the PacketTunnel extension, which shares no
/// sandbox with the app, so config.yaml, geodata and profiles have to live in
/// the App Group container — the one place both processes can read.
///
/// Everything else is the fork's own choice to keep a per-app subdirectory
/// (see the merge runbook's deliberate divergences). `lib/common/path.dart` —
/// an upstream file — keeps one call instead of all of this.
void initDataDir(
  Completer<Directory> dataDir,
  Future<Directory> Function() supportDirectory,
) {
  if (system.isIOS) {
    app!.getContainerPath().then((containerPath) async {
      if (containerPath == null) {
        // App Group entitlement missing/not signed — the NE extension will
        // NOT be able to see profiles written here.
        commonPrint.log(
          'App Group container unavailable, falling back to sandbox',
          logLevel: LogLevel.error,
        );
        final dir = Directory(join((await supportDirectory()).path, appName));
        await dir.create(recursive: true);
        dataDir.complete(dir);
        return;
      }
      final dir = Directory(join(containerPath, appName));
      await dir.create(recursive: true);
      commonPrint.log('homeDir: ${dir.path}');
      dataDir.complete(dir);
    });
    return;
  }
  supportDirectory().then((value) async {
    final dir = Directory(join(value.path, appName));
    await dir.create(recursive: true);
    dataDir.complete(dir);
  });
}
