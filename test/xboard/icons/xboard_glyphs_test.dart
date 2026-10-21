import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fl_clash/ui/icons/glyph.dart';
import 'package:fl_clash/ui/icons/glyph_painter.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

// The panel's own glyphs, drawn with upstream's painter. They moved out of
// upstream's `app_glyphs.dart` so a merge cannot conflict on them; these are
// the same rendering checks upstream runs over its own set.
const _scale = 3;
const _side = 24 * _scale;

final _glyphs = {
  'email': XBoardGlyphs.email,
  'person': XBoardGlyphs.person,
  'people': XBoardGlyphs.people,
  'shieldCheck': XBoardGlyphs.shieldCheck,
  'logout': XBoardGlyphs.logout,
  'wallet': XBoardGlyphs.wallet,
  'coin': XBoardGlyphs.coin,
  'bank': XBoardGlyphs.bank,
  'creditCard': XBoardGlyphs.creditCard,
  'giftCard': XBoardGlyphs.giftCard,
  'shoppingBag': XBoardGlyphs.shoppingBag,
  'percent': XBoardGlyphs.percent,
  'swapHoriz': XBoardGlyphs.swapHoriz,
  'home': XBoardGlyphs.home,
  'calendar': XBoardGlyphs.calendar,
  'hourglass': XBoardGlyphs.hourglass,
  'cloudOff': XBoardGlyphs.cloudOff,
  'megaphone': XBoardGlyphs.megaphone,
  'globe': XBoardGlyphs.globe,
  'router': XBoardGlyphs.router,
  'bug': XBoardGlyphs.bug,
  'supportAgent': XBoardGlyphs.supportAgent,
  'accountBox': XBoardGlyphs.accountBox,
  'signalFull': XBoardGlyphs.signalFull,
  'signalWeak': XBoardGlyphs.signalWeak,
  'signalNone': XBoardGlyphs.signalNone,
};

Future<Uint8List> _render(
  Glyph glyph,
  double fill, {
  Color color = const Color(0xFF000000),
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(_scale.toDouble());
  GlyphPainter(
    glyph: glyph,
    fill: fill,
    color: color,
  ).paint(canvas, const Size.square(24));
  final image = await recorder.endRecording().toImage(_side, _side);
  final bytes = await image.toByteData();
  image.dispose();
  return bytes!.buffer.asUint8List();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final MapEntry(key: name, value: glyph) in _glyphs.entries) {
    test('$name fills into a different shape than its outline', () async {
      final outline = await _render(glyph, 0);
      final filled = await _render(glyph, 1);

      expect(outline.any((channel) => channel != 0), isTrue);
      if (glyph.shapes.any((shape) => !shape.solid)) {
        expect(filled, isNot(outline));
      } else {
        expect(filled, outline, reason: 'solid shapes are already filled');
      }
    });

    test('$name shows no detail midway', () async {
      final bodies = Glyph([
        for (final shape in glyph.shapes)
          if (shape.role != GlyphRole.detail) shape,
      ]);

      expect(await _render(glyph, 0.5), await _render(bodies, 0.5));
    });
  }
}
