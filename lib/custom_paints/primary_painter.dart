// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class PrimaryCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * -0.002421308, size.height * 0.07382883);
    path_0.cubicTo(
        size.width * -0.002421308,
        size.height * 0.03916233,
        size.width * -0.002421308,
        size.height * 0.02182896,
        size.width * 0.01756920,
        size.height * 0.01117193);
    path_0.cubicTo(
        size.width * 0.02038845,
        size.height * 0.009668957,
        size.width * 0.02345332,
        size.height * 0.008289399,
        size.width * 0.02673099,
        size.height * 0.007047963);
    path_0.cubicTo(
        size.width * 0.04997215,
        size.height * -0.001754564,
        size.width * 0.08393850,
        size.height * 0.0002897509,
        size.width * 0.1518709,
        size.height * 0.004378393);
    path_0.lineTo(size.width * 0.7094431, size.height * 0.03793693);
    path_0.lineTo(size.width * 0.8450363, size.height * 0.05027104);
    path_0.lineTo(size.width * 0.9003438, size.height * 0.05838037);
    path_0.cubicTo(
        size.width * 0.9456998,
        size.height * 0.06503031,
        size.width * 0.9683777,
        size.height * 0.06835521,
        size.width * 0.9824939,
        size.height * 0.07669423);
    path_0.cubicTo(
        size.width * 0.9845254,
        size.height * 0.07789521,
        size.width * 0.9864044,
        size.height * 0.07916135,
        size.width * 0.9881162,
        size.height * 0.08048479);
    path_0.cubicTo(size.width, size.height * 0.08967423, size.width,
        size.height * 0.1016373, size.width, size.height * 0.1255632);
    path_0.lineTo(size.width, size.height * 0.9300613);
    path_0.cubicTo(
        size.width,
        size.height * 0.9612000,
        size.width,
        size.height * 0.9767706,
        size.width * 0.9825956,
        size.height * 0.9870957);
    path_0.cubicTo(
        size.width * 0.9801259,
        size.height * 0.9885632,
        size.width * 0.9774286,
        size.height * 0.9899288,
        size.width * 0.9745351,
        size.height * 0.9911804);
    path_0.cubicTo(size.width * 0.9541598, size.height, size.width * 0.9234334,
        size.height, size.width * 0.8619855, size.height);
    path_0.lineTo(size.width * 0.1355932, size.height);
    path_0.cubicTo(
        size.width * 0.07414431,
        size.height,
        size.width * 0.04341985,
        size.height,
        size.width * 0.02304252,
        size.height * 0.9911804);
    path_0.cubicTo(
        size.width * 0.02014891,
        size.height * 0.9899288,
        size.width * 0.01745400,
        size.height * 0.9885632,
        size.width * 0.01498262,
        size.height * 0.9870957);
    path_0.cubicTo(
        size.width * -0.002421308,
        size.height * 0.9767706,
        size.width * -0.002421308,
        size.height * 0.9612000,
        size.width * -0.002421308,
        size.height * 0.9300613);
    path_0.lineTo(size.width * -0.002421308, size.height * 0.07382883);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xff353935).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
