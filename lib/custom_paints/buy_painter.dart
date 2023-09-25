// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class BuyCustomPainter extends CustomPainter {
  final Color color;
  BuyCustomPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1116751, 0);
    path_0.lineTo(size.width, size.height * 0.1041667);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(0, size.height);
    path_0.lineTo(0, size.height * 0.4791667);
    path_0.lineTo(0, size.height * 0.1458333);
    path_0.lineTo(size.width * 0.1116751, 0);
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
