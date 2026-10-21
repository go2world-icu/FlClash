import 'dart:math' as math;

import 'package:fl_clash/ui/icons/glyph.dart';

/// The glyphs the panel draws itself.
///
/// They live here rather than in upstream's [AppGlyphs] because that file is
/// the first thing a merge conflicts on: adding one glyph next to upstream's
/// moves the whole block. Nothing outside `lib/xboard/` draws these.
abstract final class XBoardGlyphs {
  static const email = Glyph([
    GlyphBox(3, 5.5, 21, 18.5, 2.4),
    GlyphPolyline([
      GlyphVertex(4.6, 7.7),
      GlyphVertex(12, 13.3, 0.8),
      GlyphVertex(19.4, 7.7),
    ], role: GlyphRole.detail),
  ]);

  static const person = Glyph([
    GlyphCircle(12, 8, 4.1),
    GlyphArc(12, 21, 7.3, math.pi * 1.09, math.pi * 0.82),
  ]);

  static const people = Glyph([
    GlyphCircle(9.6, 8, 3.9),
    GlyphArc(9.6, 20.4, 6.9, math.pi * 1.09, math.pi * 0.82),
    GlyphCircle(17.6, 8.6, 3, role: GlyphRole.detail),
    GlyphArc(
      17.8,
      20.6,
      5.2,
      math.pi * 1.22,
      math.pi * 0.56,
      role: GlyphRole.detail,
    ),
  ]);

  static const shieldCheck = Glyph([
    GlyphPolyline([
      GlyphVertex(12, 3),
      GlyphVertex(19.6, 6, 2.2),
      GlyphVertex(19.6, 12, 2.2),
      GlyphVertex(12, 21, 2.2),
      GlyphVertex(4.4, 12, 2.2),
      GlyphVertex(4.4, 6, 2.2),
    ], closed: true),
    GlyphPolyline([
      GlyphVertex(8.4, 12.2),
      GlyphVertex(11, 14.8, 0.8),
      GlyphVertex(15.8, 9.6, 0.8),
    ], role: GlyphRole.detail),
  ]);

  static const logout = Glyph([
    GlyphPolyline([
      GlyphVertex(13.5, 4.5),
      GlyphVertex(6.5, 4.5, 2),
      GlyphVertex(4.5, 6.5, 2),
      GlyphVertex(4.5, 17.5, 2),
      GlyphVertex(6.5, 19.5, 2),
      GlyphVertex(13.5, 19.5),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(10.5, 12),
      GlyphVertex(20, 12),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(16.5, 8.5, 1),
      GlyphVertex(20, 12, 1),
      GlyphVertex(16.5, 15.5, 1),
    ], role: GlyphRole.line),
  ]);

  static const wallet = Glyph([
    GlyphPolyline([
      GlyphVertex(4, 6.5, 2.4),
      GlyphVertex(20, 6.5, 2.4),
      GlyphVertex(20, 18.5, 2.4),
      GlyphVertex(4, 18.5, 2.4),
    ], closed: true),
    GlyphCircle(16.9, 12.5, 1.4, role: GlyphRole.detail, solid: true),
  ]);

  static const coin = Glyph([
    GlyphCircle(12, 12, 8.8),
    GlyphPolyline([
      GlyphVertex(12, 7.4),
      GlyphVertex(12, 16.6),
    ], role: GlyphRole.detail),
    GlyphPolyline([
      GlyphVertex(9.2, 10.6),
      GlyphVertex(14.8, 10.6),
    ], role: GlyphRole.detail),
    GlyphPolyline([
      GlyphVertex(9.2, 13.4),
      GlyphVertex(14.8, 13.4),
    ], role: GlyphRole.detail),
  ]);

  static const bank = Glyph([
    GlyphPolyline([
      GlyphVertex(12, 3),
      GlyphVertex(21, 8.2),
      GlyphVertex(3, 8.2),
    ], closed: true),
    GlyphPolyline([
      GlyphVertex(5.8, 10.4),
      GlyphVertex(5.8, 16.6),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(12, 10.4),
      GlyphVertex(12, 16.6),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(18.2, 10.4),
      GlyphVertex(18.2, 16.6),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(3.2, 19),
      GlyphVertex(20.8, 19),
    ], role: GlyphRole.line),
  ]);

  static const creditCard = Glyph([
    GlyphBox(3, 5.5, 21, 18.5, 2.4),
    GlyphPolyline([
      GlyphVertex(3.6, 9.6),
      GlyphVertex(20.4, 9.6),
    ], role: GlyphRole.detail),
    GlyphCircle(7.4, 14.8, 1.5, role: GlyphRole.detail, solid: true),
  ]);

  static const giftCard = Glyph([
    GlyphBox(3, 8.4, 21, 19.4, 2.2),
    GlyphPolyline([
      GlyphVertex(12, 8.4),
      GlyphVertex(12, 19.4),
    ], role: GlyphRole.detail),
    GlyphOval(6.6, 3.2, 11.4, 8.4, role: GlyphRole.detail),
    GlyphOval(12.6, 3.2, 17.4, 8.4, role: GlyphRole.detail),
  ]);

  static const shoppingBag = Glyph([
    GlyphPolyline([
      GlyphVertex(5, 8.6),
      GlyphVertex(19, 8.6),
      GlyphVertex(20.2, 20),
      GlyphVertex(3.8, 20),
    ], closed: true),
    GlyphArc(12, 8.8, 3.6, math.pi, math.pi, role: GlyphRole.line),
  ]);

  static const percent = Glyph([
    GlyphCircle(7.6, 7.6, 3.4),
    GlyphCircle(16.4, 16.4, 3.4),
    GlyphPolyline([
      GlyphVertex(5.2, 19.2),
      GlyphVertex(18.8, 4.8),
    ], role: GlyphRole.line),
  ]);

  static const swapHoriz = Glyph([
    GlyphPolyline([
      GlyphVertex(3.5, 9),
      GlyphVertex(18, 9),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(15, 5.6, 1),
      GlyphVertex(18.4, 9, 1),
      GlyphVertex(15, 12.4, 1),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(20.5, 15),
      GlyphVertex(6, 15),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(9, 11.6, 1),
      GlyphVertex(5.6, 15, 1),
      GlyphVertex(9, 18.4, 1),
    ], role: GlyphRole.line),
  ]);

  static const home = Glyph([
    GlyphPolyline([
      GlyphVertex(3.2, 11.2),
      GlyphVertex(12, 3.6, 1.6),
      GlyphVertex(20.8, 11.2),
    ], role: GlyphRole.line),
    GlyphBox(5.6, 10.4, 18.4, 20.4, 2),
    GlyphPolyline([
      GlyphVertex(9.8, 20.4),
      GlyphVertex(9.8, 15, 1),
      GlyphVertex(14.2, 15, 1),
      GlyphVertex(14.2, 20.4),
    ], role: GlyphRole.detail),
  ]);

  static const calendar = Glyph([
    GlyphBox(3.2, 5.2, 20.8, 20.4, 2.4),
    GlyphPolyline([
      GlyphVertex(3.6, 9.8),
      GlyphVertex(20.4, 9.8),
    ], role: GlyphRole.detail),
    GlyphPolyline([
      GlyphVertex(8, 3.2),
      GlyphVertex(8, 6.8),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(16, 3.2),
      GlyphVertex(16, 6.8),
    ], role: GlyphRole.line),
    GlyphCircle(12, 15.4, 2.2, role: GlyphRole.detail, solid: true),
  ]);

  static const hourglass = Glyph([
    GlyphPolyline([
      GlyphVertex(6.2, 3.4, 1.2),
      GlyphVertex(17.8, 3.4, 1.2),
      GlyphVertex(17.8, 5.6, 1.2),
      GlyphVertex(12, 12, 1.2),
      GlyphVertex(17.8, 18.4, 1.2),
      GlyphVertex(17.8, 20.6, 1.2),
      GlyphVertex(6.2, 20.6, 1.2),
      GlyphVertex(6.2, 18.4, 1.2),
      GlyphVertex(12, 12, 1.2),
      GlyphVertex(6.2, 5.6, 1.2),
    ], closed: true),
  ]);

  static const cloudOff = Glyph([
    GlyphPath(
      'M7 19.4A4.2 4.2 0 0 1 5.06 11.47A6 6 0 1 1 16.95 9.83A4.8 4.8 0 0 1 16.4 19.4Z',
    ),
    GlyphPolyline([
      GlyphVertex(4.6, 3.6),
      GlyphVertex(20, 19.6),
    ], role: GlyphRole.line),
  ]);

  static const megaphone = Glyph([
    GlyphPolyline([
      GlyphVertex(3.6, 9.2, 1.6),
      GlyphVertex(8.6, 8, 1.6),
      GlyphVertex(17.4, 3.2, 1.6),
      GlyphVertex(17.4, 15.2, 1.6),
      GlyphVertex(8.6, 10.4, 1.6),
    ], closed: true),
    GlyphArc(
      18.2,
      9.2,
      3.6,
      math.pi * -0.4,
      math.pi * 0.8,
      role: GlyphRole.line,
    ),
  ]);

  static const globe = Glyph([
    GlyphCircle(12, 12, 8.8),
    GlyphOval(8.2, 3.2, 15.8, 20.8, role: GlyphRole.detail),
    GlyphPolyline([
      GlyphVertex(3.4, 12),
      GlyphVertex(20.6, 12),
    ], role: GlyphRole.detail),
  ]);

  static const router = Glyph([
    GlyphBox(3, 13.6, 21, 20.4, 2.2),
    GlyphPolyline([
      GlyphVertex(7.6, 3.2),
      GlyphVertex(7.6, 13.6),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(16.4, 4.4),
      GlyphVertex(16.4, 13.6),
    ], role: GlyphRole.line),
    GlyphCircle(7.4, 17, 1.3, role: GlyphRole.detail, solid: true),
    GlyphCircle(11.4, 17, 1.3, role: GlyphRole.detail, solid: true),
  ]);

  static const bug = Glyph([
    GlyphOval(7.6, 8, 16.4, 20.4),
    GlyphArc(12, 8.2, 3.2, math.pi, math.pi, role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(9.4, 3.4),
      GlyphVertex(11.2, 6.2),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(14.6, 3.4),
      GlyphVertex(12.8, 6.2),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(4.6, 11),
      GlyphVertex(7.8, 12.6),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(19.4, 11),
      GlyphVertex(16.2, 12.6),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(4.6, 17.4),
      GlyphVertex(7.7, 16.6),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(19.4, 17.4),
      GlyphVertex(16.3, 16.6),
    ], role: GlyphRole.line),
  ]);

  static const supportAgent = Glyph([
    GlyphArc(12, 12.6, 7.8, math.pi, math.pi, role: GlyphRole.line),
    GlyphBox(3.2, 11.4, 6.8, 17.4, 1.8, role: GlyphRole.line),
    GlyphBox(17.2, 11.4, 20.8, 17.4, 1.8, role: GlyphRole.line),
    GlyphPath('M18.4 17.6C18.4 19.9 15.4 20.9 12.6 20.9', role: GlyphRole.line),
  ]);

  static const accountBox = Glyph([
    GlyphBox(3, 3, 21, 21, 2.6),
    GlyphCircle(12, 10.4, 3, role: GlyphRole.detail),
    GlyphArc(
      12,
      21.8,
      6,
      math.pi * -0.8087,
      math.pi * 0.6173,
      role: GlyphRole.detail,
    ),
  ]);

  static const signalFull = Glyph([
    GlyphBox(2.6, 15.2, 6.2, 20.8, 1.2),
    GlyphBox(7.4, 12.2, 11, 20.8, 1.2),
    GlyphBox(12.2, 9.2, 15.8, 20.8, 1.2),
    GlyphBox(17, 6.2, 20.6, 20.8, 1.2),
  ]);

  static const signalWeak = Glyph([
    GlyphBox(2.6, 15.2, 6.2, 20.8, 1.2),
    GlyphBox(7.4, 12.2, 11, 20.8, 1.2),
    GlyphBox(12.2, 9.2, 15.8, 20.8, 1.2, role: GlyphRole.line),
    GlyphBox(17, 6.2, 20.6, 20.8, 1.2, role: GlyphRole.line),
  ]);

  static const signalNone = Glyph([
    GlyphBox(2.6, 15.2, 6.2, 20.8, 1.2, role: GlyphRole.line),
    GlyphBox(7.4, 12.2, 11, 20.8, 1.2, role: GlyphRole.line),
    GlyphBox(12.2, 9.2, 15.8, 20.8, 1.2, role: GlyphRole.line),
    GlyphBox(17, 6.2, 20.6, 20.8, 1.2, role: GlyphRole.line),
  ]);

  // Upstream v0.9.1 redrew its glyph set and dropped these five, which the
  // panel's invite and network cards still draw. They are upstream's own
  // former shapes, kept here so those cards do not change.
  static const history = Glyph([
    GlyphArc(12, 12, 9, math.pi * 1.25, math.pi * 1.65, role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(5.6, 5.6),
      GlyphVertex(4.1, 7.1),
    ], role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(4.1, 3.5),
      GlyphVertex(4.1, 7.1, 0.4),
      GlyphVertex(7.7, 7.1),
    ], role: GlyphRole.line),
    GlyphCircle(12.4, 12.4, 4.6),
    GlyphPolyline([
      GlyphVertex(12.4, 10.2),
      GlyphVertex(12.4, 12.4, 0.4),
      GlyphVertex(14, 13.4),
    ], role: GlyphRole.detail),
  ]);

  static const save = Glyph([
    GlyphPolyline([
      GlyphVertex(4.5, 4.5, 2.2),
      GlyphVertex(15.5, 4.5, 1),
      GlyphVertex(19.5, 8.5, 1),
      GlyphVertex(19.5, 19.5, 2.2),
      GlyphVertex(4.5, 19.5, 2.2),
    ], closed: true),
    GlyphPolyline([
      GlyphVertex(8, 4.5),
      GlyphVertex(8, 8.8, 1),
      GlyphVertex(13.3, 8.8, 1),
      GlyphVertex(13.3, 4.5),
    ], role: GlyphRole.detail),
    GlyphPolyline([
      GlyphVertex(7.6, 19.5),
      GlyphVertex(7.6, 13.8, 1.3),
      GlyphVertex(16.4, 13.8, 1.3),
      GlyphVertex(16.4, 19.5),
    ], role: GlyphRole.detail),
  ]);

  static const moon = Glyph([
    GlyphPath(
      'M9.4 3.59A8.8 8.8 0 1 0 20.41 14.6A0.8 0.8 0 0 0 19.32 13.63A6.8 6.8 0 0 1 10.37 4.68A0.8 0.8 0 0 0 9.4 3.59Z',
    ),
  ]);

  static const themeAuto = Glyph([
    GlyphCircle(12, 12, 8.8),
    GlyphPath(
      'M12 3.2A8.8 8.8 0 0 0 12 20.8Z',
      role: GlyphRole.detail,
      solid: true,
    ),
  ]);

  static const networkCheck = Glyph([
    GlyphPath('M3.32 8.56 A13.5 13.5 0 0 1 20.68 8.56', role: GlyphRole.line),
    GlyphPath('M6.54 12.39 A8.5 8.5 0 0 1 17.46 12.39', role: GlyphRole.line),
    GlyphPolyline([
      GlyphVertex(8.6, 16.8),
      GlyphVertex(11, 19.2, 0.5),
      GlyphVertex(15.2, 15),
    ], role: GlyphRole.line),
  ]);
}
