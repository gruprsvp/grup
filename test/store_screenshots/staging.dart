import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// Illustrated avatars for the demo members, drawn here so the store images
/// show faces without licensing photos. The screens load member pictures as
/// [NetworkImage]s; [seedAvatars] answers those from the image cache.

typedef _Look = ({
  Color background,
  Color skin,
  Color hair,
  Color shirt,
  _Hair style,
});

enum _Hair { short, long, bun, curly, buzz, bob }

const _skin = [
  Color(0xFFF6D5B8),
  Color(0xFFEAC09A),
  Color(0xFFD39B6B),
  Color(0xFFB97A4E),
  Color(0xFF8D5A3B),
  Color(0xFF5E3A26),
];

final _looks = <String, _Look>{
  'me': (
    background: const Color(0xFFC9D8F2),
    skin: _skin[1],
    hair: const Color(0xFF4A3426),
    shirt: const Color(0xFF34558B),
    style: _Hair.short,
  ),
  'marta': (
    background: const Color(0xFFFFD9C7),
    skin: _skin[1],
    hair: const Color(0xFF2B1C14),
    shirt: const Color(0xFFE0614F),
    style: _Hair.long,
  ),
  'kwame': (
    background: const Color(0xFFCDEBD3),
    skin: _skin[5],
    hair: const Color(0xFF1A1310),
    shirt: const Color(0xFF2E7D32),
    style: _Hair.buzz,
  ),
  'lena': (
    background: const Color(0xFFE6DDF7),
    skin: _skin[0],
    hair: const Color(0xFFD9A55B),
    shirt: const Color(0xFF6E56B8),
    style: _Hair.bun,
  ),
  'diego': (
    background: const Color(0xFFFFE8B0),
    skin: _skin[2],
    hair: const Color(0xFF2A1A12),
    shirt: const Color(0xFF00A4B8),
    style: _Hair.curly,
  ),
  'aiko': (
    background: const Color(0xFFFFD6E2),
    skin: _skin[1],
    hair: const Color(0xFF15110F),
    shirt: const Color(0xFFD9467A),
    style: _Hair.bob,
  ),
  'sam': (
    background: const Color(0xFFD3E9F5),
    skin: _skin[4],
    hair: const Color(0xFF1A1310),
    shirt: const Color(0xFFEF8C2B),
    style: _Hair.curly,
  ),
  'chloe': (
    background: const Color(0xFFDDEFE0),
    skin: _skin[0],
    hair: const Color(0xFF8A4B2A),
    shirt: const Color(0xFF3F8F6B),
    style: _Hair.long,
  ),
  'ravi': (
    background: const Color(0xFFF7E3CF),
    skin: _skin[3],
    hair: const Color(0xFF17110D),
    shirt: const Color(0xFF8E5BC9),
    style: _Hair.short,
  ),
};

String avatarUrl(String memberId) => 'https://store.test/avatar/$memberId.png';

/// Draws every demo avatar at [size] px. Call inside `tester.runAsync`.
Future<Map<String, ui.Image>> drawAvatars({int size = 384}) async => {
  for (final MapEntry(key: id, value: look) in _looks.entries)
    id: await _draw(look, size),
};

/// Puts [avatars] in the image cache under the [NetworkImage] keys the
/// screens ask for. The cache is cleared between tests: seed each one.
void seedAvatars(Map<String, ui.Image> avatars) {
  final cache = PaintingBinding.instance.imageCache;
  for (final MapEntry(key: id, value: image) in avatars.entries) {
    cache.putIfAbsent(
      NetworkImage(avatarUrl(id)),
      () => OneFrameImageStreamCompleter(
        SynchronousFuture(ImageInfo(image: image.clone())),
      ),
    );
  }
}

Future<ui.Image> _draw(_Look look, int px) {
  final recorder = ui.PictureRecorder();
  final c = Canvas(recorder)..scale(px / 256);
  Paint fill(Color color) => Paint()
    ..color = color
    ..isAntiAlias = true;
  final shade = Color.lerp(look.skin, Colors.black, 0.12)!;
  final hairShade = Color.lerp(look.hair, Colors.white, 0.08)!;

  c.drawCircle(const Offset(128, 128), 128, fill(look.background));
  c.save();
  c.clipPath(
    Path()
      ..addOval(Rect.fromCircle(center: const Offset(128, 128), radius: 128)),
  );

  // Hair that falls behind the shoulders.
  switch (look.style) {
    case _Hair.long:
      c.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(62, 70, 132, 150),
          const Radius.circular(60),
        ),
        fill(look.hair),
      );
    case _Hair.bob:
      c.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(64, 66, 128, 104),
          const Radius.circular(48),
        ),
        fill(look.hair),
      );
    default:
  }

  // Shoulders and neck.
  c.drawOval(const Rect.fromLTWH(40, 186, 176, 150), fill(look.shirt));
  c.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(110, 150, 36, 50),
      const Radius.circular(14),
    ),
    fill(shade),
  );
  // Collar.
  c.drawPath(
    Path()
      ..moveTo(108, 190)
      ..quadraticBezierTo(128, 214, 148, 190)
      ..close(),
    fill(shade),
  );

  // Ears and head.
  c.drawCircle(const Offset(72, 120), 12, fill(shade));
  c.drawCircle(const Offset(184, 120), 12, fill(shade));
  c.drawOval(const Rect.fromLTWH(74, 62, 108, 118), fill(look.skin));

  // Hair on top.
  final cap = Path()
    ..moveTo(72, 116)
    ..cubicTo(64, 52, 116, 38, 132, 42)
    ..cubicTo(170, 40, 196, 70, 184, 116)
    ..cubicTo(170, 92, 150, 82, 128, 86)
    ..cubicTo(108, 84, 86, 94, 72, 116)
    ..close();
  switch (look.style) {
    case _Hair.buzz:
      c.drawPath(
        Path()
          ..moveTo(76, 104)
          ..cubicTo(76, 56, 180, 56, 180, 104)
          ..cubicTo(160, 84, 96, 84, 76, 104)
          ..close(),
        fill(look.hair),
      );
    case _Hair.curly:
      final p = fill(look.hair);
      for (var i = 0; i <= 8; i++) {
        final a = math.pi * (1.05 + 0.9 * i / 8);
        c.drawCircle(
          Offset(128 + 56 * math.cos(a), 104 + 50 * math.sin(a)),
          22,
          p,
        );
      }
      c.drawCircle(const Offset(128, 64), 30, p);
    case _Hair.bun:
      c.drawCircle(const Offset(128, 40), 24, fill(look.hair));
      c.drawPath(cap, fill(look.hair));
    case _Hair.short || _Hair.long || _Hair.bob:
      c.drawPath(cap, fill(look.hair));
  }
  // A soft highlight on the hair (not on a buzz cut or curls).
  if (look.style case _Hair.short || _Hair.long || _Hair.bun || _Hair.bob) {
    c.drawArc(
      const Rect.fromLTWH(96, 50, 64, 30),
      math.pi * 1.1,
      math.pi * 0.5,
      false,
      Paint()
        ..color = hairShade
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  // Face: eyes, cheeks, smile.
  final ink = fill(const Color(0xFF2A211C));
  c.drawOval(const Rect.fromLTWH(102, 112, 10, 13), ink);
  c.drawOval(const Rect.fromLTWH(144, 112, 10, 13), ink);
  final blush = fill(const Color(0x33E0614F));
  c.drawCircle(const Offset(98, 140), 10, blush);
  c.drawCircle(const Offset(158, 140), 10, blush);
  c.drawPath(
    Path()
      ..moveTo(112, 146)
      ..quadraticBezierTo(128, 162, 144, 146),
    Paint()
      ..color = const Color(0xFF2A211C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round,
  );
  c.restore();

  return recorder.endRecording().toImage(px, px);
}

/// A clean iOS status bar (9:41, full signal, Wi-Fi and battery), as Apple's
/// marketing guidelines ask of device images. Fills the top inset.
class IosStatusBar extends StatelessWidget {
  const IosStatusBar({super.key});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _StatusBarPainter());
}

class _StatusBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const ink = Color(0xFF111111);
    // iPhone insets are ~62pt, iPad's 24pt: scale the bar to the inset.
    final s = size.height > 40 ? 1.0 : 0.72;
    final cy = size.height / 2;
    final time = TextPainter(
      text: TextSpan(
        text: '9:41',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 17 * s,
          fontWeight: FontWeight.w600,
          color: ink,
          letterSpacing: -0.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    time.paint(
      canvas,
      Offset(size.width * (s == 1 ? 0.13 : 0.03), cy - time.height / 2),
    );

    final paint = Paint()..color = ink;
    var x = size.width - (s == 1 ? 34 : 18);
    // Battery: outline, fill, nub.
    final battery = Rect.fromLTWH(x - 27 * s, cy - 6.5 * s, 25 * s, 13 * s);
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(battery, Radius.circular(4 * s)),
        Paint()
          ..color = ink.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1 * s,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          battery.deflate(2 * s),
          Radius.circular(2.5 * s),
        ),
        paint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(battery.right + 1 * s, cy - 2 * s, 1.6 * s, 4 * s),
          Radius.circular(1 * s),
        ),
        Paint()..color = ink.withValues(alpha: 0.4),
      );
    x = battery.left - 7 * s;
    // Wi-Fi: three arcs and a dot.
    final wifi = Offset(x - 8.5 * s, cy + 5 * s);
    for (final r in [12.5, 8.0]) {
      canvas.drawArc(
        Rect.fromCircle(center: wifi, radius: r * s),
        math.pi * 1.25,
        math.pi * 0.5,
        false,
        Paint()
          ..color = ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4 * s
          ..strokeCap = StrokeCap.round,
      );
    }
    canvas.drawCircle(wifi.translate(0, -1.6 * s), 2.2 * s, paint);
    x = wifi.dx - 13 * s;
    // Signal: four bars.
    for (var i = 0; i < 4; i++) {
      final h = (4 + 2.7 * i) * s;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - (17 - 4.6 * i) * s, cy + 6 * s - h, 3.2 * s, h),
          Radius.circular(1 * s),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
