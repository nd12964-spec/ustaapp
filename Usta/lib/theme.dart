import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Цвета приложения: чертёжная бумага, тёмно-синий, сигнально-оранжевый, зелёный для статусов.
class C {
  C._();
  static const ink = Color(0xFF13284D);
  static const paper = Color(0xFFF3F6FA);
  static const line = Color(0xFFDCE3EC);
  static const muted = Color(0xFF56657D);
  static const orange = Color(0xFFFF6A13);
  static const orangeTint = Color(0xFFFFF1E8);
  static const orangeBorder = Color(0xFFFFCCAD);
  static const green = Color(0xFF1F9D55);
  static const greenText = Color(0xFF12663A);
  static const greenTint = Color(0xFFE6F4EC);
  static const hatchBg = Color(0xFFEBF0F6);
  static const inkTint = Color(0xFFE9EEF6);
  static const tile = Color(0xFFF7F9FC);
  static const white = Color(0xFFFFFFFF);
  static const ink50 = Color(0x8013284D);
  static const ink38 = Color(0x6113284D);
  static const grid = Color(0x0B13284D);
}

/// Текстовый стиль. Шрифты переменные, поэтому толщина задаётся осью wght.
TextStyle ts(
  double size, {
  double w = 400,
  Color color = C.ink,
  double? h,
  double ls = 0,
  bool display = false,
}) {
  return TextStyle(
    fontFamily: display ? 'Unbounded' : 'Onest',
    fontSize: size,
    color: color,
    height: h,
    letterSpacing: ls,
    fontVariations: <ui.FontVariation>[ui.FontVariation('wght', w)],
  );
}

const List<BoxShadow> softShadow = [
  BoxShadow(color: Color(0x0F13284D), blurRadius: 2, offset: Offset(0, 1)),
  BoxShadow(color: Color(0x1413284D), blurRadius: 30, offset: Offset(0, 10)),
];

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: C.ink,
    primary: C.ink,
    secondary: C.orange,
    surface: C.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: C.paper,
    fontFamily: 'Onest',
    snackBarTheme: SnackBarThemeData(
      backgroundColor: C.ink,
      contentTextStyle: ts(14, color: C.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}

/// Тонкая чертёжная сетка.
class GridPainter extends CustomPainter {
  const GridPainter({required this.color, this.step = 24});
  final Color color;
  final double step;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x + 0.5, 0), Offset(x + 0.5, size.height), p);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y + 0.5), Offset(size.width, y + 0.5), p);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.step != step;
}

/// Штриховка, как на разрезах в чертежах. Место под фото.
class HatchPainter extends CustomPainter {
  const HatchPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = C.hatchBg);
    final p = Paint()
      ..color = const Color(0x1413284D)
      ..strokeWidth = 1;
    const gap = 9.0;
    for (double d = -size.height; d < size.width; d += gap) {
      canvas.drawLine(Offset(d, size.height), Offset(d + size.height, 0), p);
    }
  }

  @override
  bool shouldRepaint(covariant HatchPainter oldDelegate) => false;
}

/// Горизонтальная пунктирная линия.
class HDashPainter extends CustomPainter {
  const HDashPainter({this.color = C.line});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1;
    final y = size.height / 2;
    for (double x = 0; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, y), Offset(math.min(x + 4, size.width), y), p);
    }
  }

  @override
  bool shouldRepaint(covariant HDashPainter oldDelegate) => oldDelegate.color != color;
}

/// Пунктирная рамка со скруглёнными углами.
class DashedRRectPainter extends CustomPainter {
  const DashedRRectPainter({required this.radius, required this.color});
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(0.75);
    final path = Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, math.min(d + 6, metric.length)), p);
        d += 11;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedRRectPainter oldDelegate) =>
      oldDelegate.radius != radius || oldDelegate.color != color;
}
