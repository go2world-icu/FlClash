import 'dart:io';

import 'package:fl_clash/common/path.dart';

/// Resolves every directory [appPath] hands out to [root], and returns the
/// home directory that comes out of it.
///
/// That is not [root]: the fork keeps its data in an `<appName>` subdirectory
/// of the support directory (see `lib/common/data_dir.dart`), so a test that
/// writes where it thinks home is has to use the returned path.
Future<Directory> useAppPaths(Directory root) async {
  Future<Directory> resolve() async => root;
  AppPath.supportDirectory = resolve;
  AppPath.temporaryDirectory = resolve;
  AppPath.cacheDirectory = resolve;
  AppPath.downloadDirectory = resolve;
  await appPath.rebind();
  return Directory(await appPath.homeDirPath);
}
