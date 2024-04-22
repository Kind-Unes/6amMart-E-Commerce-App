import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class TriangleWidget extends StatelessWidget {
  const TriangleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(25, 25), // Set the size of the triangle
      painter: TrianglePainter(),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.shader = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(size.width, size.height),
      [
        Theme.of(Get.context!).primaryColor.withOpacity(0.01),
        Theme.of(Get.context!).cardColor,
      ],
    );

    Path path = Path();
    path = Path();
    path.lineTo(size.width * 0.95, size.height * 0.22);
    path.cubicTo(size.width * 1.02, size.height * 0.23, size.width * 1.05, size.height * 0.32, size.width, size.height * 0.37);
    path.cubicTo(size.width, size.height * 0.37, size.width * 0.44, size.height, size.width * 0.44, size.height);
    path.cubicTo(size.width * 0.39, size.height * 1.06, size.width * 0.31, size.height * 1.04, size.width * 0.28, size.height * 0.97);
    path.cubicTo(size.width * 0.28, size.height * 0.97, size.width * 0.03, size.height * 0.16, size.width * 0.03, size.height * 0.16);
    path.cubicTo(size.width * 0.01, size.height * 0.09, size.width * 0.07, size.height * 0.02, size.width * 0.13, size.height * 0.04);
    path.cubicTo(size.width * 0.13, size.height * 0.04, size.width * 0.95, size.height * 0.22, size.width * 0.95, size.height * 0.22);
    path.cubicTo(size.width * 0.95, size.height * 0.22, size.width * 0.95, size.height * 0.22, size.width * 0.95, size.height * 0.22);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
