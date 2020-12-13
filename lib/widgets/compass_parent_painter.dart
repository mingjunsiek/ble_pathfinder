import 'dart:math';

import 'package:ble_pathfinder/utils/constants.dart';
import 'package:flutter/material.dart';

class CompassParentPainter extends CustomPainter {
  CompassParentPainter({@required this.locationAngle}) : super();

  final double locationAngle;
  double get rotation => ((locationAngle ?? 0) * (pi / 180));

  Paint get _brush => new Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = _brush
      ..color = kSecondaryColor; // Colors.indigo[400].withOpacity(0.6);

    Paint needle = _brush..color = kPrimaryColor;

    double radius = min(size.width / 2.2, size.height / 2.2);
    Offset center = Offset(size.width / 2, size.height / 2);
    Offset start = Offset.lerp(Offset(center.dx, radius), center, -0.4);
    Offset end = Offset.lerp(Offset(center.dx, radius), center, -0.65);

    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawLine(start, end, needle);
    canvas.drawCircle(center, radius, circle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
