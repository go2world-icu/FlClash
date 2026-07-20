import 'dart:io';
import 'dart:typed_data';

const sourceDir = 'assets_source/images/icon';
const outputDir = 'assets/images/icon';
const statusIconNames = ['status_1', 'status_2', 'status_3'];

Future<void> main() async {
  final rsvgConvert = await _findExecutable('rsvg-convert');
  if (rsvgConvert == null) {
    stderr.writeln(
      'rsvg-convert is required. Install librsvg before generating icons.',
    );
    exitCode = 1;
    return;
  }

  await Directory(outputDir).create(recursive: true);
  final tempDir = await Directory.systemTemp.createTemp('status_icons_');
  try {
    for (final name in statusIconNames) {
      final source = File('$sourceDir/$name.svg');
      if (!source.existsSync()) {
        stderr.writeln('Missing source SVG: ${source.path}');
        exitCode = 1;
        return;
      }

      final png = File('$outputDir/$name.png');
      final icoPng = File('${tempDir.path}/$name-32.png');
      final ico = File('$outputDir/$name.ico');

      await _renderSvg(
        rsvgConvert: rsvgConvert,
        sourcePath: source.path,
        output: png,
        width: 108,
        height: 108,
      );
      await _renderSvg(
        rsvgConvert: rsvgConvert,
        sourcePath: source.path,
        output: icoPng,
        width: 32,
        height: 32,
      );
      await ico.writeAsBytes(_buildIco(await icoPng.readAsBytes()));

      stdout.writeln('Generated ${png.path} and ${ico.path}');
    }
  } finally {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  }
}

Future<String?> _findExecutable(String executable) async {
  final result = await Process.run('which', [executable]);
  if (result.exitCode != 0) {
    return null;
  }
  return (result.stdout as String).trim();
}

Future<void> _renderSvg({
  required String rsvgConvert,
  required String sourcePath,
  required File output,
  required int width,
  required int height,
}) async {
  final rounded = _wrapRounded(sourcePath, width, height);
  final result = await Process.run(rsvgConvert, [
    '-w',
    '$width',
    '-h',
    '$height',
    '-o',
    output.path,
    rounded,
  ]);
  if (result.exitCode != 0) {
    stderr
      ..writeln('Failed to render $sourcePath -> ${output.path}')
      ..writeln(result.stderr);
    exit(result.exitCode);
  }
}

/// Inject a rounded-rect clip-path into the source SVG.  The clip rect uses
/// the SVG's own coordinate space, not the output pixel size.
String _wrapRounded(String src, int w, int h) {
  var raw = File(src).readAsStringSync();
  final vb = RegExp(r'viewBox="\S+\s+\S+\s+(\S+)\s+(\S+)"', multiLine: true).firstMatch(raw);
  final svgW = int.tryParse(vb?.group(1) ?? '') ?? int.tryParse(
      RegExp(r'width="(\d+)"', multiLine: true).firstMatch(raw)?.group(1) ?? '') ?? w;
  final svgH = int.tryParse(vb?.group(2) ?? '') ?? int.tryParse(
      RegExp(r'height="(\d+)"', multiLine: true).firstMatch(raw)?.group(1) ?? '') ?? h;
  final r = (svgW * 0.22).round().clamp(4, svgW ~/ 2);
  raw = raw.replaceFirstMapped(
    RegExp(r'(<svg[^>]*>)', multiLine: true),
    (m) => '${m[1]}\n<defs><clipPath id="_round"><rect width="$svgW" height="$svgH" rx="$r" ry="$r"/></clipPath></defs>\n<g clip-path="url(#_round)">',
  );
  raw = raw.replaceFirst('</svg>', '</g>\n</svg>');
  final tmp = File('${Directory.systemTemp.path}/rounded_${w}x$h.svg');
  tmp.writeAsStringSync(raw);
  return tmp.path;
}

Uint8List _buildIco(List<int> pngBytes) {
  const headerSize = 6;
  const directoryEntrySize = 16;
  const imageOffset = headerSize + directoryEntrySize;

  final bytes = BytesBuilder(copy: false)
    ..add(_uint16(0))
    ..add(_uint16(1))
    ..add(_uint16(1))
    ..add([32, 32, 0, 0])
    ..add(_uint16(1))
    ..add(_uint16(32))
    ..add(_uint32(pngBytes.length))
    ..add(_uint32(imageOffset))
    ..add(pngBytes);

  return bytes.toBytes();
}

Uint8List _uint16(int value) {
  return (ByteData(2)..setUint16(0, value, Endian.little)).buffer.asUint8List();
}

Uint8List _uint32(int value) {
  return (ByteData(4)..setUint32(0, value, Endian.little)).buffer.asUint8List();
}
