import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/xboard/features/subscription/widgets/log_upload_row.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/xboard_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => AppLocalizations.load(const Locale('en')));

  group('LogUploadRow', () {
    testWidgets('renders the idle prompt', (tester) async {
      await pumpXboard(tester, const Scaffold(body: LogUploadRow()));
      expect(find.text('遇到问题？'), findsOneWidget);
      expect(find.text('日志上报'), findsOneWidget);
    });

    testWidgets('shows a snackbar when logging is disabled', (tester) async {
      await pumpXboard(tester, const Scaffold(body: LogUploadRow()));
      await tester.tap(find.text('日志上报'));
      await tester.pump();
      expect(find.text('日志未启用'), findsOneWidget);
    });
  });
}
