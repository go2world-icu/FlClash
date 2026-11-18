import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'sources.dart';

final _circularProgress = RegExp(r'\bCircularProgressIndicator\b');

void main() {
  test('lib shows circular loading with ActivityIndicator', () {
    final offenders = <String>[];

    for (final entity in sourceEntities()) {
      final path = p.posix.joinAll(p.split(p.relative(entity.path)));
      if (entity is! File ||
          !entity.path.endsWith('.dart') ||
          path.contains('/generated/') ||
          path.startsWith('lib/xboard/')) {
        continue;
      }
      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (_circularProgress.hasMatch(lines[i])) {
          offenders.add(
            '${entity.path}:${i + 1} — use ActivityIndicator, sized as the '
            'glyph it stands in for.',
          );
        }
      }
    }

    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
