import 'package:fl_clash/xboard/features/latency/widgets/latency_indicator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/xboard_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LatencyIndicator', () {
    testWidgets('shows a spinner while testing (delay == 0)', (tester) async {
      await pumpXboard(
        tester,
        const LatencyIndicator(delayValue: 0),
        settle: false,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('测试中'), findsOneWidget);
    });

    testWidgets('compact testing shows only the spinner', (tester) async {
      await pumpXboard(
        tester,
        const LatencyIndicator(delayValue: 0, isCompact: true),
        settle: false,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('测试中'), findsNothing);
    });

    testWidgets('shows the untested hint for a null delay', (tester) async {
      await pumpXboard(tester, const LatencyIndicator(delayValue: null));
      expect(find.text('自动测试中'), findsOneWidget);
    });

    testWidgets('renders the tested delay in ms', (tester) async {
      await pumpXboard(tester, const LatencyIndicator(delayValue: 120));
      expect(find.text('120ms'), findsOneWidget);
    });

    testWidgets('renders timeout for a negative delay', (tester) async {
      await pumpXboard(tester, const LatencyIndicator(delayValue: -1));
      expect(find.text('Timeout'), findsOneWidget);
    });

    testWidgets('compact tested state uses the short form', (tester) async {
      await pumpXboard(
        tester,
        const LatencyIndicator(delayValue: 88, isCompact: true),
      );
      expect(find.text('88'), findsOneWidget);
    });

    testWidgets('compact timeout uses the short label', (tester) async {
      await pumpXboard(
        tester,
        const LatencyIndicator(delayValue: -1, isCompact: true),
      );
      expect(find.text('超时'), findsOneWidget);
    });

    testWidgets('fires onTap', (tester) async {
      var taps = 0;
      await pumpXboard(
        tester,
        LatencyIndicator(delayValue: 30, onTap: () => taps++),
      );
      await tester.tap(find.text('30ms'));
      await tester.pump();
      expect(taps, 1);
    });
  });

  group('LatencyQuality', () {
    test('classifies delay levels', () {
      expect(LatencyQuality.getQualityLevel(-1), '超时');
      expect(LatencyQuality.getQualityLevel(10), '优秀');
      expect(LatencyQuality.getQualityLevel(80), '良好');
      expect(LatencyQuality.getQualityLevel(150), '一般');
      expect(LatencyQuality.getQualityLevel(300), '较差');
      expect(LatencyQuality.getQualityLevel(1000), '很差');
    });

    test('describes each level', () {
      expect(LatencyQuality.getQualityDescription(-1), '连接超时，请检查网络');
      expect(LatencyQuality.getQualityDescription(10), contains('优秀'));
      expect(LatencyQuality.getQualityDescription(80), contains('良好'));
      expect(LatencyQuality.getQualityDescription(150), contains('一般'));
      expect(LatencyQuality.getQualityDescription(300), contains('较差'));
      expect(LatencyQuality.getQualityDescription(1000), contains('很差'));
    });

    test('maps a quality icon per level', () {
      expect(LatencyQuality.getQualityIcon(-1), isNotNull);
      expect(LatencyQuality.getQualityIcon(10), isNotNull);
      expect(LatencyQuality.getQualityIcon(1000), isNotNull);
      expect(
        LatencyQuality.getQualityIcon(-1),
        LatencyQuality.getQualityIcon(1000),
      );
    });
  });
}
