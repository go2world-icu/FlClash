import 'package:fl_clash/common/string.dart';

final _flag = RegExp(r'[\u{1F1E6}-\u{1F1FF}]{2}', unicode: true);
final _countries = {
  'HK': RegExp(
    r'香港|港區|港区|\bhong[ -]?kong\b|\bhk(?=\b|\d)',
    caseSensitive: false,
  ),
  'TW': RegExp(
    r'台湾|台灣|臺灣|台北|新北|\btaiwan\b|\btaipei\b|\btw(?=\b|\d)',
    caseSensitive: false,
  ),
  'MO': RegExp(r'澳门|澳門|\bmaca[ou]\b|\bmo(?=\b|\d)', caseSensitive: false),
  'JP': RegExp(
    r'日本|东京|東京|大阪|\bjapan\b|\btokyo\b|\bosaka\b|\bjp(?=\b|\d)',
    caseSensitive: false,
  ),
  'SG': RegExp(r'新加坡|狮城|獅城|\bsingapore\b|\bsg(?=\b|\d)', caseSensitive: false),
  'US': RegExp(
    r'美国|美國|洛杉矶|洛杉磯|硅谷|矽谷|纽约|紐約|\bunited states\b|\busa\b|\blos angeles\b|\bnew york\b|\bus(?=\b|\d)',
    caseSensitive: false,
  ),
  'GB': RegExp(
    r'英国|英國|伦敦|倫敦|\bunited kingdom\b|\bbritain\b|\blondon\b|\b(?:uk|gb)(?=\b|\d)',
    caseSensitive: false,
  ),
  'KR': RegExp(
    r'韩国|韓國|首尔|首爾|\b(?:south )?korea\b|\bseoul\b|\bkr(?=\b|\d)',
    caseSensitive: false,
  ),
  'DE': RegExp(
    r'德国|德國|法兰克福|法蘭克福|\bgermany\b|\bfrankfurt\b|\bde(?=\b|\d)',
    caseSensitive: false,
  ),
  'FR': RegExp(
    r'法国|法國|巴黎|\bfrance\b|\bparis\b|\bfr(?=\b|\d)',
    caseSensitive: false,
  ),
  'CA': RegExp(
    r'加拿大|\bcanada\b|\btoronto\b|\bvancouver\b|\bca(?=\b|\d)',
    caseSensitive: false,
  ),
  'AU': RegExp(
    r'澳大利亚|澳大利亞|悉尼|雪梨|\baustralia\b|\bsydney\b|\bau(?=\b|\d)',
    caseSensitive: false,
  ),
  'NL': RegExp(
    r'荷兰|荷蘭|\bnetherlands\b|\bamsterdam\b|\bnl(?=\b|\d)',
    caseSensitive: false,
  ),
  'RU': RegExp(
    r'俄罗斯|俄羅斯|\brussia\b|\bmoscow\b|\bru(?=\b|\d)',
    caseSensitive: false,
  ),
  'IN': RegExp(
    r'印度(?!尼)|\bindia\b|\bmumbai\b|\bin(?=\b|\d)',
    caseSensitive: false,
  ),
  'TH': RegExp(
    r'泰国|泰國|曼谷|\bthailand\b|\bbangkok\b|\bth(?=\b|\d)',
    caseSensitive: false,
  ),
  'VN': RegExp(r'越南|\bvietnam\b|\bvn(?=\b|\d)', caseSensitive: false),
  'MY': RegExp(r'马来西亚|馬來西亞|\bmalaysia\b|\bmy(?=\b|\d)', caseSensitive: false),
  'PH': RegExp(r'菲律宾|菲律賓|\bphilippines\b|\bph(?=\b|\d)', caseSensitive: false),
  'ID': RegExp(
    r'印度尼西亚|印度尼西亞|印尼|\bindonesia\b|\bid(?=\b|\d)',
    caseSensitive: false,
  ),
  'CN': RegExp(r'中国|中國|大陆|大陸|\bchina\b|\bcn(?=\b|\d)', caseSensitive: false),
};

String? iosLineCountryFlag(String name) {
  final flag = _flag.firstMatch(name)?.group(0);
  if (flag != null) return flag;
  for (final country in _countries.entries) {
    if (country.value.hasMatch(name)) return country.key.countryFlagEmoji;
  }
  return null;
}
