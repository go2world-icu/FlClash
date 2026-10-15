import 'dart:io';

import 'package:test/test.dart';

/// This fork adds a panel module (`lib/xboard/`) and iOS support on top of
/// upstream, which has neither. Both are wired into upstream-owned files, so a
/// merge that takes upstream's side wholesale silently drops the wiring — it
/// has happened twice already: `main.dart` lost the desktop guard on
/// `RustLib.init()`, and the CI lost the explicit iOS core build.
///
/// These are the invariants that must survive every upstream merge. They are a
/// test rather than a checklist so a dropped line fails the build instead of
/// reaching a release.

String _read(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    fail(
      '$path is gone; the fork-specific entry it provides may have been '
      'dropped by a merge.',
    );
  }
  return file.readAsStringSync();
}

/// The build tag expression a Go file declares, without the `//go:build`
/// prefix — or `null` when it has none.
String? _goBuildTag(String path) {
  for (final line in _read(path).split('\n').take(3)) {
    final trimmed = line.trim();
    if (trimmed.startsWith('//go:build')) {
      return trimmed.substring('//go:build'.length).trim();
    }
  }
  return null;
}

void main() {
  group('iOS: the app only reaches the Rust bridge on desktop', () {
    test('main.dart guards RustLib.init() and resolves the xboard config', () {
      final source = _read('lib/main.dart');

      expect(
        source,
        contains('resolveXboardConfig()'),
        reason: 'the xboard config must be resolved before bootstrap',
      );

      final guarded = RegExp(
        r'if\s*\(\s*system\.isDesktop\s*\)\s*\{\s*await\s+RustLib\.init\(\)',
        multiLine: true,
      );
      expect(
        guarded.hasMatch(source),
        isTrue,
        reason:
            'upstream calls RustLib.init() unconditionally because it has '
            'no iOS; the fork must keep the isDesktop guard, or iOS fails at '
            'startup.',
      );
    });

    test('rust_api skips its build on iOS', () {
      final source = _read('plugins/rust_api/hook/build.dart');
      expect(
        RegExp(r'targetOS\s*==\s*OS\.iOS').hasMatch(source),
        isTrue,
        reason:
            'rquickjs-sys publishes no iOS bindings, so the hook has to '
            'return early for iOS rather than fail the whole build.',
      );
    });
  });

  group('iOS: the Core build tags', () {
    // Built for both mobile targets; upstream tags these android-only.
    const mobile = [
      'core/bride.go',
      'core/bride.c',
      'core/lib.go',
      'core/main_cgo.go',
      'core/tun/tun.go',
    ];

    // Excluded on iOS; upstream excludes only Android.
    const desktop = ['core/main.go', 'core/server.go', 'core/exit.go'];

    for (final path in mobile) {
      test('$path is built for iOS too', () {
        expect(_goBuildTag(path), '(android || ios) && cgo');
      });
    }

    for (final path in desktop) {
      test('$path is excluded on iOS', () {
        expect(_goBuildTag(path), '!((android || ios) && cgo)');
      });
    }

    test('core/dial_socket.go is excluded on iOS', () {
      expect(
        _goBuildTag('core/dial_socket.go'),
        '!((android || ios) && cgo) && !windows',
      );
    });
  });

  group('upstream files the fork keeps clean', () {
    test('core/hub.go carries no fork-specific code', () {
      expect(
        _read('core/hub.go'),
        isNot(contains('handleSuspend')),
        reason:
            'it moved to handle_suspend.go precisely so that hub.go has no '
            'fork diff to resolve on every merge',
      );
    });
  });

  group('fork identity', () {
    test('the app is branded ToWorld', () {
      final source = _read('lib/common/constant.dart');
      expect(source, contains("const appName = 'ToWorld';"));
      expect(source, contains("'go2world-icu/FlClash-Publish'"));
    });

    test('the fork-specific entry points still exist', () {
      for (final path in const [
        'lib/xboard/bridge.dart',
        'lib/xboard/config_check.dart',
        'lib/manager/ios_manager.dart',
        'plugins/setup/setup_hooks/bin/build_ios.dart',
      ]) {
        expect(File(path).existsSync(), isTrue, reason: '$path is missing');
      }
    });
  });
}
