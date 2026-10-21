import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Normalise the platform separator: `file.path` is `lib\views\...` on Windows,
/// while the allow list below is written with `/`.
String _posix(String path) => p.posix.joinAll(p.split(path));

final _passwordInputType = RegExp(
  r'\benableSuggestions:\s*false\b|\bTextInputType\.visiblePassword\b',
);

const _secretFields = {'lib/ui/input.dart', 'lib/features/form/form_row.dart'};

void main() {
  test('only secret fields ask Android for a password keyboard', () {
    final offenders = <String>[];

    for (final entity in Directory('lib').listSync(recursive: true)) {
      final path = _posix(p.relative(entity.path));
      if (entity is! File ||
          !path.endsWith('.dart') ||
          path.contains('/generated/') ||
          _secretFields.contains(path)) {
        continue;
      }
      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final match = _passwordInputType.firstMatch(lines[i]);
        if (match != null) {
          offenders.add(
            '$path:${i + 1} — ${match[0]} makes Android input '
            'methods treat the field as a password, with no clipboard or '
            'Chinese input; keep autocorrect: false alone.',
          );
        }
      }
    }

    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
