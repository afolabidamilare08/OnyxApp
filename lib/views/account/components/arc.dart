

import 'package:flutter/material.dart';

class AccountArc extends StatelessWidget {
  final double diameter;

  const AccountArc({Key? key, this.diameter = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      size: Size(diameter, diameter),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xff252725);
    canvas.drawArc(
      Rect.fromCenter(
        center: const Offset(380, 130),
        height: size.width,
        width: size.height,
      ),
      60,
      60,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
