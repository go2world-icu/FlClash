import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/xboard/features/invite/widgets/qr_code_widget.dart';
import 'package:fl_clash/xboard/features/shared/widgets/language_selector.dart';
import 'package:fl_clash/xboard/features/shared/widgets/xb_container.dart';
import 'package:fl_clash/xboard/features/shared/widgets/xb_input_field.dart';
import 'package:fl_clash/icons/icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/xboard_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => AppLocalizations.load(const Locale('en')));

  group('XBContainer', () {
    testWidgets('renders its child without a safe area', (tester) async {
      await pumpXboard(
        tester,
        const Scaffold(
          body: XBContainer(
            safeArea: false,
            padding: EdgeInsets.all(8),
            child: Text('inside'),
          ),
        ),
      );
      expect(find.text('inside'), findsOneWidget);
    });

    testWidgets('applies a safe area by default', (tester) async {
      await pumpXboard(
        tester,
        const Scaffold(
          body: XBContainer(
            maintainBottomViewPadding: true,
            child: Text('safe'),
          ),
        ),
      );
      expect(find.text('safe'), findsOneWidget);
    });
  });

  group('XBInputField', () {
    testWidgets('renders label, hint and prefix icon', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await pumpXboard(
        tester,
        Scaffold(
          body: XBInputField(
            controller: controller,
            labelText: 'Email',
            hintText: 'you@example.com',
            prefixIcon: AppGlyphs.email,
          ),
        ),
      );
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('you@example.com'), findsOneWidget);
    });

    testWidgets('surfaces a validator error', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final formKey = GlobalKey<FormState>();
      await pumpXboard(
        tester,
        Scaffold(
          body: Form(
            key: formKey,
            child: XBInputField(
              controller: controller,
              labelText: 'Email',
              validator: (v) => (v == null || v.isEmpty) ? 'required' : null,
            ),
          ),
        ),
      );
      formKey.currentState!.validate();
      await tester.pumpAndSettle();
      expect(find.text('required'), findsOneWidget);
    });
  });

  group('LanguageSelector', () {
    testWidgets('shows the current language and lists options', (tester) async {
      await pumpXboard(tester, const Scaffold(body: LanguageSelector()));
      // Defaults to Chinese in the app settings.
      expect(find.text('中'), findsOneWidget);
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      expect(find.text('English'), findsOneWidget);
      expect(find.text('中文'), findsOneWidget);
    });
  });

  group('QrCodeWidget', () {
    testWidgets('shows the empty placeholder for blank data', (tester) async {
      await pumpXboard(tester, const Scaffold(body: QrCodeWidget(data: '')));
      expect(find.text('No invitation data'), findsOneWidget);
    });

    testWidgets('renders a QR image for non-empty data', (tester) async {
      await pumpXboard(
        tester,
        const Scaffold(body: QrCodeWidget(data: 'https://example.com/invite')),
      );
      expect(find.text('No invitation data'), findsNothing);
    });
  });
}
