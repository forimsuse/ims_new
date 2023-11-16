import 'package:flutter/material.dart';

class Circle extends CustomPainter {
  final Color color;
  final double pointSize;
  final double xCoor;
  final double yCoor;
  final double blinkRadius;

  Circle({
    required this.color,
    required this.pointSize,
    required this.xCoor,
    required this.yCoor,
    required this.blinkRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the mid point
    Paint line = Paint();
    line.strokeCap = StrokeCap.round;
    line.color = color.withAlpha(180);
    line.strokeWidth = pointSize/1.5 ;
    Offset center = Offset(xCoor, yCoor / 2);
    double pointRadius = pointSize ;

    line.style = PaintingStyle.fill;
    canvas.drawCircle(center, pointRadius, line);

    line.style = PaintingStyle.stroke;
    canvas.drawCircle(center, blinkRadius, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}