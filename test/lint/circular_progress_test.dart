import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Normalise the platform separator: `file.path` is `lib\views\...` on Windows,
/// while the allow list below is written with `/`.
String _posix(String path) => p.posix.joinAll(p.split(path));

final _circularProgress = RegExp(r'\bCircularProgressIndicator\b');

/// The panel's own widgets were drawn before this rule existed and still use
/// the spinners they shipped with. Fixing them is the panel module's work, not
/// something a merge should silently rewrite.
const _panelWidgets = 'lib/xboard/';

void main() {
  test('lib shows circular loading with CommonCircleLoading', () {
    final offenders = <String>[];

    for (final entity in Directory('lib').listSync(recursive: true)) {
      final path = _posix(p.relative(entity.path));
      if (entity is! File ||
          !path.endsWith('.dart') ||
          path.contains('/generated/') ||
          path.startsWith(_panelWidgets)) {
        continue;
      }
      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (_circularProgress.hasMatch(lines[i])) {
          offenders.add(
            '$path:${i + 1} — use CommonCircleLoading, sized as the '
            'glyph it stands in for.',
          );
        }
      }
    }

    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
