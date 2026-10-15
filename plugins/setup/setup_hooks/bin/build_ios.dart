import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:setup_hooks/setup_hooks.dart';

/// Builds every iOS Core slice and bundles them into
/// `libclash/ios/Mobile.xcframework`.
///
/// The Flutter code-asset hook cannot stand in for this on iOS: `Runner` links
/// the xcframework, so it has to exist before `flutter build ios` reaches
/// Xcode's link step. The hook's output is only reported once the build it is
/// attached to has already been laid out.
///
/// Run from this package: `dart run bin/build_ios.dart`.
Future<void> main(List<String> args) async {
  // The builder reports through package:logging, and a failing gomobile or
  // xcodebuild writes the only copy of its reason there. With no listener
  // configured those lines are dropped and the failure reads as a bare exit
  // code — which is exactly how the first CI run of this script failed.
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    stderr.writeln('${record.level.name}: ${record.message}');
  });

  final index = args.indexOf('--root');
  final repoRoot = index >= 0 && args.length > index + 1
      ? p.normalize(args[index + 1])
      : p.normalize(
          p.join(
            p.dirname(Platform.script.toFilePath()),
            '..',
            '..',
            '..',
            '..',
          ),
        );

  if (!File(p.join(repoRoot, 'pubspec.yaml')).existsSync()) {
    stderr.writeln('No pubspec.yaml at $repoRoot; pass --root <repo>.');
    exitCode = 1;
    return;
  }

  for (final target in Target.forPlatform('ios')) {
    stdout.writeln('Building iOS core: $target');
    await buildPlatform(BuildRequest(rootDir: repoRoot, target: target));
  }

  stdout.writeln(
    'Built ${p.join(repoRoot, 'libclash', 'ios', 'Mobile.xcframework')}',
  );
}
