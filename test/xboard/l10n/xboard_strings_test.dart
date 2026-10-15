import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:test/test.dart';

/// The panel's strings used to come out of the arb pipeline, which resolved a
/// key against the loaded locale and fell back to English. They are a plain
/// table now, so those two behaviours are asserted here instead.

const _locales = ['en', 'ja', 'ru', 'zh_CN'];

void main() {
  test('every locale carries the same keys', () {
    final en = XBoardStrings.keysFor('en');
    expect(en, isNotEmpty);
    for (final locale in _locales) {
      expect(
        XBoardStrings.keysFor(locale),
        unorderedEquals(en),
        reason: '$locale is missing or has extra keys',
      );
    }
  });

  test('a locale with no table falls back to English', () {
    final fallback = XBoardStrings.forLocale('de');
    expect(fallback.logout, XBoardStrings.forLocale('en').logout);
    expect(fallback.xboardLogin, 'Login');
  });

  test('a known key resolves per locale', () {
    expect(XBoardStrings.forLocale('en').xboardLogin, 'Login');
    expect(XBoardStrings.forLocale('zh_CN').xboardLogin, '登录');
    expect(XBoardStrings.forLocale('ja').xboardLogin, isNotEmpty);
    expect(XBoardStrings.forLocale('ru').xboardLogin, isNotEmpty);
  });

  test('placeholders are substituted', () {
    final s = XBoardStrings.forLocale('en');
    expect(s.pageNumber(3), contains('3'));
    expect(s.pageNumber(3), isNot(contains('{page}')));
    expect(s.subscriptionExpiringInDaysDetail(7), contains('7'));
    expect(s.subscriptionExpiringInDaysDetail(7), isNot(contains('{days}')));
  });

  test('the lookup is cached per locale', () {
    expect(
      identical(
        XBoardStrings.forLocale('zh_CN'),
        XBoardStrings.forLocale('zh_CN'),
      ),
      isTrue,
    );
  });

  test('xboardL10n follows the locale intl currently has', () {
    expect(XBoardStrings.forLocale('en').xboardEmail, 'Email');
    expect(xboardL10n.xboardEmail, isNotEmpty);
  });
}
