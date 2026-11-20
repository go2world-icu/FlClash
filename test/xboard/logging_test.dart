import 'dart:async';
import 'dart:convert';

import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/common/print.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/xboard/adapter/sdk_logging.dart';
import 'package:fl_clash/xboard/bridge.dart' show preloadXBoard;
import 'package:fl_clash/xboard/config_check.dart';
import 'package:fl_clash/xboard/core/logger/log_report.dart';
import 'package:fl_clash/xboard/core/logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late DebugPrintCallback originalPrint;
  late List<String> console;

  setUp(() {
    container = ProviderContainer();
    globalState.container = container;
    globalState.isAttach = true;
    XBoardLogger.flushPending();
    container.read(logsProvider).clear();
    XBoardLogger.configure(enabled: true, minLevel: LogLevel.debug);
    originalPrint = debugPrint;
    console = [];
    debugPrint = (message, {wrapWidth}) => console.add(message ?? '');
  });

  tearDown(() {
    globalState.isAttach = true;
    XBoardLogger.flushPending();
    globalState.isAttach = false;
    container.dispose();
    debugPrint = originalPrint;
    XBoardLogger.configure(enabled: true, minLevel: LogLevel.info);
    SdkLogger.enable(enabled: false);
  });

  test(
    'startup logs flush once before later records without printing twice',
    () async {
      globalState.isAttach = false;
      XBoardLogger.error('early failure', StateError('offline'));
      SdkLogger.enable(eventOutput: forwardSdkLog);
      SdkLogger.w('early retry');
      expect(container.read(logsProvider).length, 0);
      expect(console.length, 2);
      globalState.isAttach = true;
      XBoardLogger.info('attached');
      await Future<void>.value();
      XBoardLogger.flushPending();
      final logs = container.read(logsProvider).list;
      expect(logs.map((log) => log.logLevel), [
        LogLevel.error,
        LogLevel.warning,
        LogLevel.info,
      ]);
      expect(logs.first.payload, contains('early failure\nBad state: offline'));
      expect(logs[1].payload, contains('[XBoardSDK] early retry'));
      expect(logs.last.payload, contains('attached'));
      expect(console.length, 3);
    },
  );

  test('startup buffer retains at most the log list limit', () {
    globalState.isAttach = false;
    for (var i = 0; i <= maxLogsLength; i++) {
      XBoardLogger.debug('startup $i');
    }
    globalState.isAttach = true;
    XBoardLogger.flushPending();
    final logs = container.read(logsProvider).list;
    expect(logs.length, maxLogsLength);
    expect(logs.first.payload, '[APP] [XBoard] startup 1');
    expect(logs.last.payload, '[APP] [XBoard] startup $maxLogsLength');
    expect(console.length, maxLogsLength + 1);
  });

  testWidgets('preload flushes startup logs even without a panel config', (
    tester,
  ) async {
    try {
      expect(hasXboardConfig, isFalse);
      globalState.isAttach = false;
      XBoardLogger.error('startup failure');
      globalState.isAttach = true;
      late WidgetRef attachedRef;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, child) {
              attachedRef = ref;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      preloadXBoard(attachedRef);
      XBoardLogger.flushPending();
      expect(
        container.read(logsProvider).list.single.payload,
        contains('startup failure'),
      );
      expect(console.length, 1);
    } finally {
      debugPrint = originalPrint;
    }
  });

  test(
    'provider initialization can log without mutating another provider',
    () async {
      SdkLogger.enable(eventOutput: forwardSdkLog);
      final sdk = FutureProvider<String>((ref) async {
        const logger = FileLogger('sdk_provider');
        logger.info('initializing');
        SdkLogger.e(
          'diagnostic',
          StateError('offline'),
          StackTrace.fromString('sdk:8'),
        );
        return 'ready';
      });
      expect(await container.read(sdk.future), 'ready');
      await Future<void>.value();
      final logs = container.read(logsProvider).list;
      expect(logs.map((log) => log.logLevel), [LogLevel.info, LogLevel.error]);
      expect(logs.first.payload, contains('[sdk_provider] initializing'));
      expect(logs.last.payload, contains('sdk:8'));
    },
  );

  testWidgets('logging while a widget builds updates its log view afterwards', (
    tester,
  ) async {
    try {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, child) {
              final logs = ref.watch(logsProvider);
              if (logs.length == 0) XBoardLogger.info('building');
              return Text('${logs.length}', textDirection: TextDirection.ltr);
            },
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text('1'), findsOneWidget);
      expect(console.length, 1);
    } finally {
      debugPrint = originalPrint;
    }
  });

  test(
    'deferred logs do not write to a disposed or replacement container',
    () async {
      final previous = ProviderContainer();
      globalState.container = previous;
      XBoardLogger.error('previous container');
      previous.dispose();
      await Future<void>.value();
      globalState.container = container;
      final replaced = ProviderContainer();
      globalState.container = replaced;
      XBoardLogger.info('replaced container');
      globalState.container = container;
      await Future<void>.value();
      expect(container.read(logsProvider).length, 0);
      expect(replaced.read(logsProvider).length, 0);
      expect(console, isEmpty);
      replaced.dispose();
    },
  );

  test(
    'file logs retain severity, exception and stack with redaction',
    () async {
      const logger = FileLogger('profile.dart');
      logger.error(
        'Import failed https://user:pass@example.test/path?token=hidden',
        StateError('password=hidden'),
        StackTrace.fromString('importProfile (profile.dart:42)'),
      );
      await Future<void>.value();
      final log = container.read(logsProvider).list.single;
      expect(log.logLevel, LogLevel.error);
      expect(
        log.payload,
        contains('[APP] [XBoard] [profile.dart] Import failed'),
      );
      expect(log.payload, contains('Bad state: [redacted]'));
      expect(log.payload, contains('importProfile (profile.dart:42)'));
      expect(log.payload, contains('https://example.test'));
      expect(log.payload, isNot(contains('hidden')));
      expect(console, [log.payload]);
    },
  );

  test('SDK forwards every level once and preserves error details', () async {
    SdkLogger.enable(eventOutput: forwardSdkLog);
    final rawConsole = <String>[];
    runZoned(
      () {
        SdkLogger.d('request');
        SdkLogger.i('initialized');
        SdkLogger.w('retry');
        SdkLogger.e(
          'failed',
          StateError('offline'),
          StackTrace.fromString('sdk:8'),
        );
      },
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) => rawConsole.add(line),
      ),
    );
    await Future<void>.value();
    final logs = container.read(logsProvider).list;
    expect(logs.map((log) => log.logLevel), [
      LogLevel.debug,
      LogLevel.info,
      LogLevel.warning,
      LogLevel.error,
    ]);
    expect(logs.last.payload, contains('[XBoardSDK] failed'));
    expect(logs.last.payload, contains('offline'));
    expect(logs.last.payload, contains('sdk:8'));
    expect(console.length, 4);
    expect(rawConsole, isEmpty);
  });

  test('configured level and disabled SDK suppress matching records', () async {
    XBoardLogger.configure(enabled: true, minLevel: LogLevel.warning);
    SdkLogger.enable(eventOutput: forwardSdkLog);
    SdkLogger.i('filtered');
    SdkLogger.w('visible');
    SdkLogger.enable(enabled: false, eventOutput: forwardSdkLog);
    SdkLogger.e('disabled');
    await Future<void>.value();
    expect(
      container.read(logsProvider).list.single.payload,
      contains('visible'),
    );
    XBoardLogger.configure(enabled: false, minLevel: LogLevel.debug);
    XBoardLogger.error('disabled');
    expect(container.read(logsProvider).length, 1);
  });

  test(
    'report includes app, Core, XBoard and SDK logs from a stable snapshot',
    () async {
      commonPrint.log('app ready');
      container
          .read(logsProvider.notifier)
          .add(
            const Log(
              payload: '[TCP] connection',
              dateTime: '2026-11-20 10:00:00',
            ),
          );
      XBoardLogger.warning('panel retry');
      SdkLogger.enable(eventOutput: forwardSdkLog);
      SdkLogger.e('network failed', StateError('offline'));
      commonPrint.log('https://example.test/private?token=hidden');
      await Future<void>.value();
      final snapshot = container.read(logsProvider).list;
      final report = encodeLogReport(snapshot);
      commonPrint.log('after snapshot');
      final text = utf8.decode(await report);
      expect(text, contains('app ready'));
      expect(text, contains('[TCP] connection'));
      expect(text, contains('panel retry'));
      expect(text, contains('[XBoardSDK] network failed'));
      expect(text, contains('offline'));
      expect(text, contains('LogLevel.error'));
      expect(text, isNot(contains('hidden')));
      expect(text, isNot(contains('after snapshot')));
    },
  );
}
