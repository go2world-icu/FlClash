/// One-shot script: all platform app icons from a single source.
///
/// Prerequisites:  brew install librsvg  (provides rsvg-convert)
///
/// Usage:
///   dart tool/generate_app_icons.dart
///
/// Source (place before running):
///   assets_source/icon.svg   or   assets_source/icon.png  (≥1024×1024)
///
/// Tray icons are handled separately by:
///   dart tool/generate_status_icons.dart
library;

import 'dart:io';
import 'dart:typed_data';

const sourceAppIcon = 'assets_source/images/icon/status_3';

// ---- iOS ----
const iosIconDir = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';
const iosSizes = {
  'Icon-App-20x20@1x.png': 20,
  'Icon-App-20x20@2x.png': 40,
  'Icon-App-20x20@3x.png': 60,
  'Icon-App-29x29@1x.png': 29,
  'Icon-App-29x29@2x.png': 58,
  'Icon-App-29x29@3x.png': 87,
  'Icon-App-40x40@1x.png': 40,
  'Icon-App-40x40@2x.png': 80,
  'Icon-App-40x40@3x.png': 120,
  'Icon-App-60x60@2x.png': 120,
  'Icon-App-60x60@3x.png': 180,
  'Icon-App-76x76@1x.png': 76,
  'Icon-App-76x76@2x.png': 152,
  'Icon-App-83.5x83.5@2x.png': 167,
  'Icon-App-1024x1024@1x.png': 1024,
};

// ---- macOS ----
const macOSIconDir = 'macos/Runner/Assets.xcassets/AppIcon.appiconset';
const macOSSizes = [16, 32, 64, 128, 256, 512, 1024];

// ---- Windows ----
const windowsIcoPath = 'windows/runner/resources/app_icon.ico';
const titleBarIcon = 'assets/images/icon.png';

// ---- Android ----
const androidResDir = 'android/app/src/main/res';
const androidPlayStore = 'android/app/src/main/ic_launcher-playstore.png';

const androidDensities = {
  'mdpi': 1.0,
  'hdpi': 1.5,
  'xhdpi': 2.0,
  'xxhdpi': 3.0,
  'xxxhdpi': 4.0,
};

Future<void> main() async {
  final rsvg = await _findExecutable('rsvg-convert');
  if (rsvg == null) {
    stderr.writeln('rsvg-convert is required.  brew install librsvg');
    exitCode = 1;
    return;
  }

  final source = _findSource(sourceAppIcon);
  if (source == null) {
    stderr.writeln('Missing source: $sourceAppIcon.svg or $sourceAppIcon.png');
    exitCode = 1;
    return;
  }
  final isSvg = source.endsWith('.svg');

  // ---- iOS (OS applies squircle mask — keep square) ----
  await Directory(iosIconDir).create(recursive: true);
  for (final entry in iosSizes.entries) {
    await _render(rsvg, source, '$iosIconDir/${entry.key}', entry.value, entry.value);
  }
  stdout.writeln('[iOS] ${iosSizes.length} icons');

  // ---- macOS (85% content, padded for Dock) ----
  await Directory(macOSIconDir).create(recursive: true);
  for (final size in macOSSizes) {
    await _render(rsvg, source, '$macOSIconDir/app_icon_$size.png', size, size, isSvg: isSvg, scale: 0.8);
  }
  stdout.writeln('[macOS] ${macOSSizes.length} icons');

  // ---- Windows ----
  final icoPngs = <Uint8List>[];
  for (final size in [256, 128, 64, 48, 32, 16]) {
    final tmp = File('${Directory.systemTemp.path}/ico_$size.png');
    await _render(rsvg, source, tmp.path, size, size, isSvg: isSvg);
    icoPngs.add(await tmp.readAsBytes());
    await tmp.delete();
  }
  await File(windowsIcoPath).writeAsBytes(_multiIco(icoPngs));
  stdout.writeln('[Windows] $windowsIcoPath');
  await _render(rsvg, source, titleBarIcon, 68, 68, isSvg: isSvg);
  stdout.writeln('[Windows] title bar $titleBarIcon');

  // ---- Android ----
  const adaptiveDp = 108;
  const legacyDp = 48;
  for (final entry in androidDensities.entries) {
    final density = entry.key;
    final scale = entry.value;
    final dir = '$androidResDir/mipmap-$density';
    await Directory(dir).create(recursive: true);

    final adaptivePx = (adaptiveDp * scale).round();
    final legacyPx = (legacyDp * scale).round();

    for (final name in ['ic_launcher_foreground', 'ic_launcher', 'ic_launcher_round']) {
      final size = name == 'ic_launcher_foreground' ? adaptivePx : legacyPx;
      final png = File('$dir/$name.png');
      await _render(rsvg, source, png.path, size, size, isSvg: isSvg);
      // Android adaptive icons: foreground should NOT be pre-rounded
      // (OS crops the adaptive icon shape). Legacy icons: OS also crops.
      await _toWebP(png.path, '$dir/$name.webp');
      await png.delete();
    }
  }
  await _render(rsvg, source, androidPlayStore, 512, 512, isSvg: isSvg);
  stdout.writeln('[Android] ${androidDensities.length} densities + playstore');

  stdout.writeln('\nDone.');
}

// ---- helpers ----

String? _findSource(String base) {
  for (final ext in ['.svg', '.png']) {
    if (File('$base$ext').existsSync()) return '$base$ext';
  }
  return null;
}

Future<String?> _findExecutable(String exe) async {
  final r = await Process.run('which', [exe]);
  return r.exitCode == 0 ? (r.stdout as String).trim() : null;
}

/// Render to PNG.  When [isSvg] is true the source SVG is wrapped in a
/// clip-path so the output has rounded corners (~22% radius, roughly
/// Apple's squircle).  For small icons the radius is clamped so the
/// icon stays readable.
Future<void> _render(
  String rsvg,
  String src,
  String out,
  int w,
  int h, {
  bool isSvg = false,
  double scale = 1.0,
}) async {
  final renderSrc = isSvg ? _wrapRounded(src, w, h, scale) : src;
  try {
    final r = await Process.run(
      rsvg,
      ['-w', '$w', '-h', '$h', '-o', out, renderSrc],
    );
    if (r.exitCode != 0) {
      stderr.writeln('rsvg-convert failed: $src → $out\n${r.stderr}');
      exit(r.exitCode);
    }
  } finally {
    if (isSvg && renderSrc != src) File(renderSrc).deleteSync();
  }
}

/// Inject a rounded-rect clip-path into the source SVG plus an optional
/// uniform scale transform (centered).  [scale] &lt; 1.0 adds padding.
String _wrapRounded(String src, int w, int h, [double scale = 1.0]) {
  var raw = File(src).readAsStringSync();
  final vb = RegExp(r'viewBox="\S+\s+\S+\s+(\S+)\s+(\S+)"', multiLine: true).firstMatch(raw);
  final svgW = int.tryParse(vb?.group(1) ?? '') ?? int.tryParse(
      RegExp(r'width="(\d+)"', multiLine: true).firstMatch(raw)?.group(1) ?? '') ?? w;
  final svgH = int.tryParse(vb?.group(2) ?? '') ?? int.tryParse(
      RegExp(r'height="(\d+)"', multiLine: true).firstMatch(raw)?.group(1) ?? '') ?? h;
  final r = (svgW * 0.22).round().clamp(4, svgW ~/ 2);
  final xf = scale < 1.0
      ? '\n<g transform="translate(${svgW * (1 - scale) / 2}, ${svgH * (1 - scale) / 2}) scale($scale, $scale)">'
      : '';
  final xfClose = scale < 1.0 ? '</g>' : '';
  raw = raw.replaceFirstMapped(
    RegExp(r'(<svg[^>]*>)', multiLine: true),
    (m) => '${m[1]}\n<defs><clipPath id="_round"><rect width="$svgW" height="$svgH" rx="$r" ry="$r"/></clipPath></defs>$xf\n<g clip-path="url(#_round)">',
  );
  raw = raw.replaceFirst('</svg>', '$xfClose</g>\n</svg>');
  final tmp = File('${Directory.systemTemp.path}/rounded_${w}x$h.svg');
  tmp.writeAsStringSync(raw);
  return tmp.path;
}

Uint8List _multiIco(List<Uint8List> pngs) {
  const hdr = 6, ent = 16;
  final n = pngs.length;
  var off = hdr + ent * n;
  final b = BytesBuilder(copy: false);
  b.add(_u16(0));
  b.add(_u16(1));
  b.add(_u16(n));
  for (final p in pngs) {
    final w = _dim(p, 16), h = _dim(p, 20);
    b.add([w == 256 ? 0 : w, h == 256 ? 0 : h, 0, 0]);
    b.add(_u16(1));
    b.add(_u16(32));
    b.add(_u32(p.length));
    b.add(_u32(off));
    off += p.length;
  }
  for (final p in pngs) {
    b.add(p);
  }
  return b.toBytes();
}

int _dim(Uint8List p, int o) => (ByteData.sublistView(p, o, o + 4)).getUint32(0);

Future<void> _toWebP(String png, String webp) async {
  final r = await Process.run('cwebp', ['-q', '90', png, '-o', webp]);
  if (r.exitCode != 0) stderr.writeln('cwebp failed: $png → $webp');
}

Uint8List _u16(int v) => (ByteData(2)..setUint16(0, v, Endian.little)).buffer.asUint8List();
Uint8List _u32(int v) => (ByteData(4)..setUint32(0, v, Endian.little)).buffer.asUint8List();
