// ignore_for_file: non_constant_identifier_names

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

//Copy this CustomPainter code to the Bottom of the File
class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.01911125, size.height * 0.9711062);
    path_0.lineTo(size.width * 0.1196294, size.height * 0.5709656);
    path_0.lineTo(size.width * 0.2665403, size.height * 0.8493250);
    path_0.lineTo(size.width * 0.3670583, size.height * 0.2578128);
    path_0.lineTo(size.width * 0.5912917, size.height * 0.5709656);
    path_0.lineTo(size.width * 0.8000611, size.height * 0.03164687);
    path_0.lineTo(size.width * 0.9856333, size.height * 0.6579531);

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01546431;
    paint_0_stroke.strokeCap = StrokeCap.round;
    paint_0_stroke.shader = ui.Gradient.linear(
        Offset(size.width * 0.7923278, size.height * 0.03164656),
        Offset(size.width * -49.12125, size.height * 1.510425),
        [const Color(0xff002FFE).withOpacity(1), const Color(0xff0834F4).withOpacity(0)],
        [0, 1]);
    canvas.drawPath(path_0, paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.transparent;
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
