import 'dart:io';

import 'package:test/test.dart';

import 'package:fl_clash/enum/enum.dart';

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
    test('main.dart starts the panel and the desktop-only Rust bridge', () {
      expect(
        _read('lib/main.dart'),
        contains('await xboardStartup();'),
        reason:
            'upstream calls RustLib.init() unconditionally because it has no '
            'iOS. A merge that takes their line drops the config probe and the '
            'desktop guard together, and iOS then fails at startup.',
      );

      final startup = _read('lib/xboard/startup.dart');
      expect(startup, contains('resolveXboardConfig()'));
      expect(
        RegExp(
          r'if\s*\(\s*system\.isDesktop\s*\)\s*\{\s*await\s+RustLib\.init\(\)',
          multiLine: true,
        ).hasMatch(startup),
        isTrue,
        reason:
            'rust_api has no iOS build, so the bridge must stay behind the '
            'isDesktop guard',
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
    const mobile = ['core/lib.go', 'core/tun/tun.go'];

    // Excluded on iOS; upstream excludes only Android.
    const desktop = ['core/cmd/core/main.go', 'core/server.go', 'core/exit.go'];

    for (final path in mobile) {
      test('$path is built for iOS too', () {
        expect(_goBuildTag(path), 'android || ios');
      });
    }

    for (final path in desktop) {
      test('$path is excluded on iOS', () {
        expect(_goBuildTag(path), '!android && !ios');
      });
    }

    test('core/dial_socket.go is excluded on iOS', () {
      expect(
        _goBuildTag('core/dial_socket.go'),
        '!android && !ios && !windows',
      );
    });
  });

  group('iOS: the Core is bound with gomobile', () {
    test('the binding package has an iOS half', () {
      expect(_read('core/mobile/mobile_ios.go'), contains('package mobile'));
      expect(
        _read('core/mobile/mobile_ios.go'),
        contains('func Suspend('),
        reason:
            'the packet tunnel provider parks the tunnel from sleep()/wake()',
      );
    });

    test('the bound package is what the iOS slices build', () {
      expect(
        _read('plugins/setup/setup_hooks/lib/src/go_builder.dart'),
        contains("'./mobile'"),
        reason:
            'the iOS slices come from `gomobile bind ./mobile`; the '
            '`./cmd/core` binary is desktop-only',
      );
    });
  });

  group('iOS: the channels the shared Dart code opens', () {
    // Upstream split core calls onto their own channel in 2201c199 and named
    // the Android half there. The iOS half lives only in this fork, so a merge
    // that re-copies it — or a new channel upstream adds — is invisible until
    // a phone throws `MissingPluginException` on subscribe.
    const channels = {
      'lib/plugins/service.dart': [
        r"'$packageName/core'",
        r"'$packageName/service'",
      ],
      'lib/plugins/app.dart': [r"'$packageName/app'"],
    };

    for (final MapEntry(key: path, value: names) in channels.entries) {
      test('$path has a handler for every channel it opens', () {
        final source = _read(path);
        final swift =
            _read('ios/Runner/Channels/ServiceChannel.swift') +
            _read('ios/Runner/Channels/AppChannel.swift');
        for (final name in names) {
          expect(
            source,
            contains(name),
            reason: '$path no longer opens $name; update this list',
          );
          final literal = name
              .replaceAll(r"'$packageName/", 'com.follow.clash/')
              .replaceAll("'", '');
          expect(
            swift,
            contains('"$literal"'),
            reason:
                'nothing on the Swift side answers `$literal`, so every call '
                'on it throws MissingPluginException',
          );
        }
      });
    }
  });

  group('platform differences live behind a build-tag pair', () {
    // CI compiles the Android side; nothing compiles the iOS side before a
    // release tag, so these are otherwise unguarded.
    const hooks = {
      'loadConfigForPlatform': ('core/config_ios.go', 'core/config_default.go'),
      'recreateTunOnReload': ('core/config_ios.go', 'core/config_default.go'),
      'handleUpdateDns': ('core/dns_ios.go', 'core/dns_android.go'),
      'applyPlatformTunOptions': (
        'core/tun/options_ios.go',
        'core/tun/options_android.go',
      ),
      'ShouldBlockConnection': (
        'core/platform/limit_ios.go',
        'core/platform/limit.go',
      ),
    };

    for (final MapEntry(key: hook, value: (ios, other)) in hooks.entries) {
      test('$hook is defined on both sides', () {
        expect(_read(ios), contains(hook));
        expect(_read(other), contains(hook));
      });
    }

    test('config.go names the hook instead of branching on GOOS', () {
      final source = _read('core/config.go');
      expect(source, contains('loadConfigForPlatformLimits('));
      expect(source, isNot(contains('runtime.GOOS == "ios"')));
    });

    test('setup without a base uses the platform config loader', () {
      final source = _read('core/config.go');
      final loader = RegExp(
        r'func loadSetupConfig\([^\n]+\{([\s\S]*?)\n\}',
      ).firstMatch(source)?.group(1);
      expect(loader, isNotNull);
      expect(
        loader,
        contains('return loadConfigForPlatform(path)'),
        reason: 'iOS must bootstrap before the app writes config.yaml',
      );
    });

    test('lifecycle.go names the hook too', () {
      final source = _read('core/lifecycle.go');
      expect(source, contains('recreateTunOnReload'));
      expect(source, isNot(contains('features.Android')));
    });

    test('tun.go leaves the fd options to the hook', () {
      final source = _read('core/tun/tun.go');
      expect(source, contains('applyPlatformTunOptions(&options)'));
      expect(source, isNot(contains('RecvMsgX')));
    });
  });

  group('upstream files the fork keeps clean', () {
    test('the tunnel park lives in its own file', () {
      expect(
        _read('core/handle_suspend.go'),
        contains('func Suspend('),
        reason:
            'iOS parks the tunnel from the packet tunnel provider\'s '
            'sleep()/wake(); keeping it out of any upstream file is what stops '
            'a merge from dropping it',
      );
      expect(
        _read('core/mobile/mobile_ios.go'),
        contains('core.Suspend('),
        reason: 'the packet tunnel reaches it through the gomobile binding',
      );
    });

    test('NavigationPort carries no fork-facing parameter', () {
      expect(
        _read('lib/common/app_ports.dart'),
        isNot(contains('hasXboard')),
        reason:
            'the panel builds the whole item list itself in '
            'XBoardNavigationPort; adding a parameter here would drag both '
            'this interface and lib/views/navigation.dart into every merge',
      );
      expect(_read('lib/views/navigation.dart'), isNot(contains('hasXboard')));
    });

    test('the fork\'s glyphs stay out of AppGlyphs', () {
      expect(
        _read('lib/ui/icons/app_glyphs.dart'),
        isNot(contains('static const email')),
        reason:
            'the panel\'s 26 glyphs live in lib/xboard/icons/xboard_glyphs.dart; '
            'a merge that brings the block back conflicts on every upstream '
            'glyph added around it',
      );
    });

    test('the dashboard\'s floating button stays upstream\'s', () {
      expect(
        _read('lib/views/dashboard/dashboard.dart'),
        isNot(contains('NodeSelectorChip')),
        reason:
            'the panel draws its own dashboard in '
            'lib/xboard/features/dashboard/; putting the chip back in '
            'upstream\'s page restores the conflict it was moved out of',
      );
      expect(
        _read('lib/views/dashboard/widgets/widgets.dart'),
        isNot(contains('node_selector_chip')),
        reason:
            'the chip is the panel\'s widget, so it is exported from '
            'lib/xboard/features/dashboard/dashboard.dart instead',
      );
      // The copy is only worth its weight while it keeps the seam: upstream
      // v0.9.1 moved the start toggle into the current-outbound card, and the
      // panel puts it back in the corner. A merge that re-copies the page over
      // this file drops the seam without failing anything else.
      final page = _read(
        'lib/xboard/features/dashboard/xboard_dashboard_view.dart',
      );
      expect(
        page,
        contains('_XBoardDashboardAction'),
        reason: 'the panel action',
      );
      expect(page, contains('StartButton'));
      // The node picker is parked, so only the comment may name it — a merge
      // that uncomments it puts the chip back, which is not what this file
      // should be doing on its own.
      final live = page
          .split('\n')
          .where((line) => !line.trimLeft().startsWith('//'))
          .join('\n');
      expect(
        live,
        isNot(contains('NodeSelectorChip')),
        reason:
            'the node picker is parked; see widgets/node_selector_chip.dart',
      );
    });

    test(
      'the start button sits at the dock\'s end from a fork-owned shell',
      () {
        // The dock's trailing slot is upstream's own code, deleted in v0.9.1.
        // The fork does not put it back: `lib/pages/home.dart` and
        // `lib/ui/navigation_dock.dart` stay byte-for-byte upstream's, and the
        // panel lays the two out in its own copy of the shell.
        for (final path in const [
          'lib/pages/home.dart',
          'lib/ui/navigation_dock.dart',
        ]) {
          final source = _read(path);
          expect(
            source,
            isNot(contains('trailing')),
            reason:
                '$path is upstream\'s; the dock\'s trailing slot lives in '
                'lib/xboard/home_shell.dart',
          );
          expect(source, isNot(contains('StartButton')));
          expect(source, isNot(contains('xboard')));
        }
        final shell = _read('lib/xboard/home_shell.dart');
        expect(shell, contains('class XBoardShellHome'));
        expect(shell, contains('StartButton'));
        expect(
          _read('lib/xboard/bridge.dart'),
          contains('XBoardShellHome()'),
          reason: 'buildXBoardHome is the anchor lib/application.dart names',
        );
      },
    );

    test('application.dart names the panel seams, not its internals', () {
      final source = _read('lib/application.dart');
      expect(source, contains('buildXBoardHome()'));
      expect(source, contains('preloadXBoard(ref)'));
      expect(source, contains('mobileManagerStack(state)'));
      for (final internal in const [
        'XBoardIosShell',
        'NodeSelectorBar',
        'hasXboardConfig',
        'warmUpXBoardStorage',
      ]) {
        expect(
          source,
          isNot(contains(internal)),
          reason:
              'the shell decision belongs to lib/xboard/bridge.dart; inlining '
              'it here is what made this file a 38-line conflict',
        );
      }
    });

    test('iOS drops the two cards the tunnel has no use for', () {
      // Filtered in the fork's dashboard rather than in `DashboardWidget`'s
      // `platforms`: the enum is upstream's, and the phone's saved list must be
      // filtered at render or a phone that already has them keeps drawing them.
      final dashboard = _read(
        'lib/xboard/features/dashboard/xboard_dashboard_view.dart',
      );
      for (final card in const ['serviceStatus', 'intranetIp']) {
        expect(
          dashboard,
          contains('DashboardWidget.$card'),
          reason: '$card is one of the two the panel hides on iOS',
        );
      }
      expect(dashboard, contains('_iosHiddenWidgets'));
      // Upstream's filter lets iOS have them, which is why the fork needs one.
      expect(
        DashboardWidget.serviceStatus.platforms,
        contains(SupportPlatform.IOS),
        reason:
            'if upstream ever excludes them on iOS, drop the fork\'s filter '
            'rather than hiding the same card twice',
      );
    });

    test('one shell serves every platform', () {
      // iOS used to open on its own shell (`features/ios_shell/`), which is
      // parked, not deleted: the files are still there for when it comes back.
      final bridge = _read('lib/xboard/bridge.dart');
      final live = bridge
          .split('\n')
          .where((line) => !line.trimLeft().startsWith('//'))
          .join('\n');
      expect(live, contains('XBoardShellHome()'));
      expect(
        live,
        isNot(contains('XBoardIosShell')),
        reason:
            'iOS opens on the same shell as Android now; the iOS shell is '
            'reached only through the commented-out branch beside it',
      );
      expect(
        live,
        isNot(contains('ios_shell')),
        reason: 'its barrel export is parked with it',
      );
      for (final path in const [
        'lib/xboard/features/ios_shell/ios_shell_page.dart',
        'lib/xboard/features/ios_shell/ios_home_tab.dart',
      ]) {
        expect(
          File(path).existsSync(),
          isTrue,
          reason:
              '$path is parked, not gone — deleting it throws away the iOS '
              'shell the fork may put back',
        );
      }
      // The startup dots moved out of that shell's bar into the dashboard's,
      // which is the only place they can be seen now.
      final dashboard = _read(
        'lib/xboard/features/dashboard/xboard_dashboard_view.dart',
      );
      expect(
        dashboard,
        contains('IosCoreStatus'),
        reason:
            'with one shell the tunnel/channel/core dots have no other home; '
            'losing them is losing the only view of startup the panel has',
      );
    });
  });

  group('the panel keeps its strings out of upstream\'s arb', () {
    test('no arb file carries a panel key', () {
      for (final file in Directory('arb').listSync().whereType<File>()) {
        final name = file.path.replaceAll(r'\', '/');
        if (!name.endsWith('.arb')) continue;
        final source = _read(name);
        expect(
          RegExp(r'^\s+"xboard[A-Z]', multiLine: true).hasMatch(source),
          isFalse,
          reason:
              '$name has a panel key again. They made lib/l10n/l10n.dart the '
              'largest conflict in the repository; they live in '
              'lib/xboard/l10n/xboard_strings.dart now.',
        );
      }
    });

    test('the panel string table is what the call sites use', () {
      expect(File('lib/xboard/l10n/xboard_strings.dart').existsSync(), isTrue);
      expect(_read('lib/xboard/bridge.dart'), contains("export 'l10n/"));
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
