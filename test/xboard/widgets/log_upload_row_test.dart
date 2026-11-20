import 'dart:async';

import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/xboard/features/subscription/services/log_report_service.dart';
import 'package:fl_clash/xboard/features/subscription/widgets/log_upload_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/xboard_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => AppLocalizations.load(const Locale('en')));

  group('LogUploadRow', () {
    var calls = 0;
    List<Log>? uploaded;
    setUp(() {
      calls = 0;
      uploaded = null;
    });
    testWidgets('renders the idle prompt', (tester) async {
      await pumpXboard(tester, const Scaffold(body: LogUploadRow()));
      expect(find.text('遇到问题？'), findsOneWidget);
      expect(find.text('日志上报'), findsOneWidget);
    });

    testWidgets('uploads the current snapshot once and shows success', (
      tester,
    ) async {
      final completion = Completer<bool>();
      final container = ProviderContainer(
        overrides: [
          logReportUploaderProvider.overrideWithValue((logs) {
            uploaded = logs;
            calls++;
            return completion.future;
          }),
        ],
      );
      addTearDown(container.dispose);
      final log = Log.app('[APP] connection failure');
      container.read(logsProvider.notifier).add(log);
      await pumpXboardWithContainer(
        tester,
        const Scaffold(body: LogUploadRow()),
        container,
      );
      await tester.tap(find.text('日志上报'));
      await tester.pump();
      expect(find.text('上传中...'), findsOneWidget);
      expect(uploaded, [log]);
      container.read(logsProvider.notifier).add(Log.app('later'));
      expect(uploaded, [log]);
      await tester.tap(find.text('上传中...'));
      expect(calls, 1);
      completion.complete(true);
      await tester.pumpAndSettle();
      expect(find.text('已上报'), findsOneWidget);
      await tester.tap(find.text('已上报'));
      expect(calls, 1);
    });

    for (final throws in [false, true]) {
      testWidgets(
        'allows retry after ${throws ? 'an exception' : 'a failed upload'}',
        (tester) async {
          await pumpXboard(
            tester,
            const Scaffold(body: LogUploadRow()),
            overrides: [
              logReportUploaderProvider.overrideWithValue((logs) async {
                calls++;
                if (throws) throw StateError('offline');
                return false;
              }),
            ],
          );
          await tester.tap(find.text('日志上报'));
          await tester.pumpAndSettle();
          expect(find.text('上传中...'), findsNothing);
          expect(find.text('日志上报'), findsOneWidget);
          await tester.tap(find.text('日志上报'));
          await tester.pumpAndSettle();
          expect(calls, 2);
        },
      );
    }

    testWidgets('finishes safely when the row is disposed during upload', (
      tester,
    ) async {
      final completion = Completer<bool>();
      await pumpXboard(
        tester,
        const Scaffold(body: LogUploadRow()),
        overrides: [
          logReportUploaderProvider.overrideWithValue(
            (logs) => completion.future,
          ),
        ],
      );
      await tester.tap(find.text('日志上报'));
      await tester.pump();
      await tester.pumpWidget(const SizedBox());
      completion.completeError(StateError('offline'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
