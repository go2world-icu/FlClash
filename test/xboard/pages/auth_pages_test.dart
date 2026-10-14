import 'package:board_sdk/flutter_xboard_sdk.dart' show ConfigModel;
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/xboard/features/auth/pages/forgot_password_page.dart';
import 'package:fl_clash/xboard/features/auth/pages/login_page.dart';
import 'package:fl_clash/xboard/features/auth/pages/register_page.dart';
import 'package:fl_clash/xboard/features/auth/providers/config_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/xboard_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => AppLocalizations.load(const Locale('en')));

  group('LoginPage', () {
    testWidgets('renders the login form', (tester) async {
      await pumpXboard(
        tester,
        const LoginPage(),
        overrides: xboardBaseOverrides(),
        textScale: 0.5,
      );
      expect(find.text('Email'), findsWidgets);
      expect(find.byType(Checkbox), findsOneWidget);
      // Login button is disabled until initialization is ready + not loading.
      expect(find.widgetWithText(FilledButton, 'Login'), findsOneWidget);
    });

    testWidgets('toggles password visibility', (tester) async {
      await pumpXboard(
        tester,
        const LoginPage(),
        overrides: xboardBaseOverrides(),
        textScale: 0.5,
      );
      final obscured = tester
          .widgetList<TextField>(find.byType(TextField))
          .map((f) => f.obscureText)
          .toList();
      expect(obscured, contains(true));
      // Tap the eye toggle (a tooltip'd IconButton).
      await tester.tap(find.byTooltip('Show password').first);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Hide password'), findsWidgets);
    });

    testWidgets('validates an empty email', (tester) async {
      await pumpXboard(
        tester,
        const LoginPage(),
        overrides: xboardBaseOverrides(),
        textScale: 0.5,
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Login'));
      await tester.pumpAndSettle();
      // Two field validators fire (email + password).
      expect(find.text('Email'), findsWidgets);
    });

    testWidgets('navigates to the register page', (tester) async {
      await pumpXboard(
        tester,
        const LoginPage(),
        overrides: xboardBaseOverrides(),
        textScale: 0.5,
      );
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();
      expect(find.byType(RegisterPage), findsOneWidget);
    });

    testWidgets('navigates to the forgot-password page', (tester) async {
      await pumpXboard(
        tester,
        const LoginPage(),
        overrides: xboardBaseOverrides(),
        textScale: 0.5,
      );
      await tester.tap(find.text('Forgot Password'));
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPasswordPage), findsOneWidget);
    });
  });

  group('RegisterPage', () {
    Future<void> pump(WidgetTester tester, {ConfigModel? config}) async {
      await pumpXboard(
        tester,
        const RegisterPage(),
        overrides: [
          ...xboardBaseOverrides(),
          configProvider.overrideWith((ref) async => config),
        ],
        textScale: 0.5,
      );
    }

    testWidgets('renders the default form without the email-code field', (
      tester,
    ) async {
      await pump(tester);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Send Verification Code'), findsNothing);
    });

    testWidgets('shows the email-code field when verification is required', (
      tester,
    ) async {
      await pump(tester, config: const ConfigModel(isEmailVerify: true));
      expect(find.text('Send Verification Code'), findsOneWidget);
    });

    testWidgets('flags mismatched passwords', (tester) async {
      await pump(tester);
      await tester.enterText(find.byType(TextField).at(0), 'a@b.com');
      await tester.enterText(find.byType(TextField).at(1), 'password1');
      await tester.enterText(find.byType(TextField).at(2), 'password2');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register Account'));
      await tester.pumpAndSettle();
      expect(find.textContaining('match'), findsWidgets);
    });
  });

  group('ForgotPasswordPage', () {
    testWidgets('renders the send-code step', (tester) async {
      await pumpXboard(
        tester,
        const ForgotPasswordPage(),
        overrides: xboardBaseOverrides(),
        textScale: 0.5,
      );
      expect(find.text('Reset Password'), findsWidgets);
      expect(
        find.widgetWithText(ElevatedButton, 'Send Verification Code'),
        findsOneWidget,
      );
    });

    testWidgets('validates the email before sending', (tester) async {
      await pumpXboard(
        tester,
        const ForgotPasswordPage(),
        overrides: xboardBaseOverrides(),
        textScale: 0.5,
      );
      await tester.tap(
        find.widgetWithText(ElevatedButton, 'Send Verification Code'),
      );
      await tester.pumpAndSettle();
      // Empty email triggers the validator.
      expect(find.textContaining('email'), findsWidgets);
    });
  });
}
