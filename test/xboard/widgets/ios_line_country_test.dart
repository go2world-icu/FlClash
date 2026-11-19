import 'package:fl_clash/xboard/features/ios_shell/ios_line_country.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('recognizes explicit flags before names and regional aliases', () {
    for (final (name, flag) in [
      ('🇯🇵 Tokyo via Hong Kong', '🇯🇵'),
      ('香港 01', '🇭🇰'),
      ('Hong Kong 01', '🇭🇰'),
      ('HK01', '🇭🇰'),
      ('Taipei 02', '🇹🇼'),
      ('台灣 03', '🇹🇼'),
      ('SG-01', '🇸🇬'),
      ('Singapore 01', '🇸🇬'),
      ('美国 01', '🇺🇸'),
      ('日本 01', '🇯🇵'),
      ('印度尼西亚 01', '🇮🇩'),
      ('India 01', '🇮🇳'),
      ('London 01', '🇬🇧'),
      ('Australia relay', '🇦🇺'),
    ]) {
      expect(iosLineCountryFlag(name), flag, reason: name);
    }
  });

  test('leaves ambiguous names without a guessed country', () {
    for (final name in ['', 'ToWorld', 'Fastest', 'Premium 01']) {
      expect(iosLineCountryFlag(name), isNull, reason: name);
    }
  });
}
