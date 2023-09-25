import 'package:flutter/material.dart';

class BlackCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * -0.002421308, size.height * 0.08531353);
    path_0.cubicTo(
        size.width * -0.002421308,
        size.height * 0.04620426,
        size.width * -0.002421308,
        size.height * 0.02664971,
        size.width * 0.01609046,
        size.height * 0.01408701);
    path_0.cubicTo(
        size.width * 0.01871148,
        size.height * 0.01230832,
        size.width * 0.02156586,
        size.height * 0.01066175,
        size.width * 0.02462542,
        size.height * 0.009163515);
    path_0.cubicTo(
        size.width * 0.04623511,
        size.height * -0.001418178,
        size.width * 0.07838886,
        size.height * -0.0004117265,
        size.width * 0.1426966,
        size.height * 0.001601176);
    path_0.lineTo(size.width * 0.7179177, size.height * 0.01960618);
    path_0.lineTo(size.width * 0.8547215, size.height * 0.02712206);
    path_0.lineTo(size.width * 0.8851622, size.height * 0.03027176);
    path_0.cubicTo(
        size.width * 0.9370073,
        size.height * 0.03563603,
        size.width * 0.9629298,
        size.height * 0.03831809,
        size.width * 0.9794528,
        size.height * 0.04864338);
    path_0.cubicTo(
        size.width * 0.9818184,
        size.height * 0.05012265,
        size.width * 0.9840121,
        size.height * 0.05170088,
        size.width * 0.9860145,
        size.height * 0.05336647);
    path_0.cubicTo(size.width, size.height * 0.06499279, size.width,
        size.height * 0.08096353, size.width, size.height * 0.1129049);
    path_0.lineTo(size.width, size.height * 0.9558824);
    path_0.cubicTo(size.width, size.height * 0.9932029, size.width,
        size.height * 1.011865, size.width * 0.9825956, size.height * 1.024240);
    path_0.cubicTo(
        size.width * 0.9801259,
        size.height * 1.025997,
        size.width * 0.9774286,
        size.height * 1.027635,
        size.width * 0.9745351,
        size.height * 1.029135);
    path_0.cubicTo(
        size.width * 0.9541598,
        size.height * 1.039706,
        size.width * 0.9234334,
        size.height * 1.039706,
        size.width * 0.8619855,
        size.height * 1.039706);
    path_0.lineTo(size.width * 0.1355932, size.height * 1.039706);
    path_0.cubicTo(
        size.width * 0.07414431,
        size.height * 1.039706,
        size.width * 0.04341985,
        size.height * 1.039706,
        size.width * 0.02304252,
        size.height * 1.029135);
    path_0.cubicTo(
        size.width * 0.02014891,
        size.height * 1.027635,
        size.width * 0.01745400,
        size.height * 1.025997,
        size.width * 0.01498262,
        size.height * 1.024240);
    path_0.cubicTo(
        size.width * -0.002421308,
        size.height * 1.011865,
        size.width * -0.002421308,
        size.height * 0.9932029,
        size.width * -0.002421308,
        size.height * 0.9558824);
    path_0.lineTo(size.width * -0.002421308, size.height * 0.08531353);
    path_0.close();

    // ignore: non_constant_identifier_names
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xff1A1C1A).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
