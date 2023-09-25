// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class SellCustomPainter extends CustomPainter {
  final Color color;
  SellCustomPainter(this.color);
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(size.width * 0.4769585, size.height * 0.05797105);
    path_0.lineTo(size.width * 0.7337189, size.height * 0.1207733);
    path_0.lineTo(size.width * 0.8855253, size.height * 0.1739128);
    path_0.lineTo(size.width * 0.9586175, size.height * 0.2512081);
    path_0.lineTo(size.width * 0.9792627, size.height * 0.3333337);
    path_0.lineTo(size.width * 0.9930876, size.height * 0.4202895);
    path_0.lineTo(size.width, size.height * 0.5893721);
    path_0.lineTo(size.width, size.height * 0.8067628);
    path_0.lineTo(size.width * 0.9979724, size.height);
    path_0.lineTo(0, size.height * 0.9855070);
    path_0.lineTo(0, 0);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = color;
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
