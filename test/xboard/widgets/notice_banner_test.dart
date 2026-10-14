import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:fl_clash/xboard/features/notice/providers/notice_provider.dart';
import 'package:fl_clash/xboard/features/shared/widgets/notice_banner.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/xboard_support.dart';
import '../support/xboard_provider_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => AppLocalizations.load(const Locale('en')));

  DomainNotice notice(int id, String title, String content) => DomainNotice(
    id: id,
    title: title,
    content: content,
    createdAt: DateTime(2024, 1, 2, 3, 4),
  );

  group('NoticeBanner', () {
    testWidgets('renders nothing without notices', (tester) async {
      await pumpXboard(
        tester,
        const Scaffold(body: NoticeBanner()),
        overrides: [
          ...xboardBaseOverrides(),
          noticeProvider.overrideWith(
            () => FakeNoticeNotifier(const NoticeState()),
          ),
        ],
      );
      expect(find.byType(MarkdownBody), findsNothing);
    });

    testWidgets('renders a single notice title', (tester) async {
      await pumpXboard(
        tester,
        const Scaffold(body: NoticeBanner()),
        overrides: [
          ...xboardBaseOverrides(),
          noticeProvider.overrideWith(
            () => FakeNoticeNotifier(
              NoticeState(notices: [notice(1, 'Hello Notice', 'body')]),
            ),
          ),
        ],
      );
      expect(find.text('Hello Notice'), findsOneWidget);
    });

    testWidgets('opens the detail dialog on tap', (tester) async {
      await pumpXboard(
        tester,
        const Scaffold(body: NoticeBanner()),
        overrides: [
          ...xboardBaseOverrides(),
          noticeProvider.overrideWith(
            () => FakeNoticeNotifier(
              NoticeState(
                notices: [
                  notice(1, 'Title One', 'Content one'),
                  notice(2, 'Title Two', 'Content two'),
                ],
              ),
            ),
          ),
        ],
      );
      await tester.tap(find.text('Title One'));
      await tester.pumpAndSettle();
      expect(find.byType(NoticeDetailDialog), findsOneWidget);
      expect(find.text('Title One'), findsWidgets);
    });
  });

  group('NoticeDetailDialog', () {
    Widget dialogWith(List<DomainNotice> notices, {int initialIndex = 0}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.delegate.supportedLocales,
        home: Scaffold(
          body: NoticeDetailDialog(
            notices: notices,
            initialIndex: initialIndex,
          ),
        ),
      );
    }

    testWidgets('renders markdown content for a single notice', (tester) async {
      await tester.pumpWidget(
        dialogWith([notice(1, 'Only', '# Heading\n\nsome **markdown**')]),
      );
      await tester.pumpAndSettle();
      expect(find.text('Only'), findsOneWidget);
      expect(find.text('1/1'), findsNothing);
    });

    testWidgets('paginates multiple notices', (tester) async {
      await tester.pumpWidget(
        dialogWith([notice(1, 'First', 'a'), notice(2, 'Second', 'b')]),
      );
      await tester.pumpAndSettle();
      // Multi-notice header shows the page counter.
      expect(find.text('1/2'), findsOneWidget);

      await tester.tap(find.text('下一条'));
      await tester.pumpAndSettle();
      expect(find.text('2/2'), findsOneWidget);

      await tester.tap(find.text('上一条'));
      await tester.pumpAndSettle();
      expect(find.text('1/2'), findsOneWidget);
    });

    testWidgets('detects html content', (tester) async {
      await tester.pumpWidget(
        dialogWith([notice(1, 'Html', '<p>hello <strong>world</strong></p>')]),
      );
      await tester.pumpAndSettle();
      expect(find.text('Html'), findsOneWidget);
    });

    testWidgets('uses a fallback title when the notice title is missing', (
      tester,
    ) async {
      final noTitle = DomainNotice(
        id: 3,
        title: '',
        content: 'c',
        createdAt: DateTime(2024, 1, 1),
      );
      await tester.pumpWidget(dialogWith([noTitle]));
      await tester.pumpAndSettle();
      expect(find.text(''), findsWidgets);
    });
  });
}
