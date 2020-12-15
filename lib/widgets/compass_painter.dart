import 'dart:math';

import 'package:ble_pathfinder/controllers/compass_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompassPainter extends CustomPainter {
  CompassPainter({
    @required this.currentBearing,
    @required this.locationBearing,
  }) : super();

  final double currentBearing, locationBearing;
  final compassController = Get.find<CompassController>();
  double get rotation => ((currentBearing ?? 0) * (pi / 180));

  // double get rotation {
  //   if (compassController.currentBearingSnapshot == null) {
  //     compassController.currentBearingSnapshot = currentBearing;
  //     compassController.locationBearingSnapshot = locationBearing;
  //     return locationBearing;
  //   } else {
  //     return ((currentBearing - compassController.currentBearingSnapshot) *
  //             -1) *
  //         (pi / 180);
  //   }
  //   // var currentRotation = ((currentBearing ?? 0) * (pi / 180));
  //   // var offsetRotation = (currentBearing - locationBearing).abs() * (pi / 180);
  //   // return currentRotation + offsetRotation;

  //   // return (angle - bearingDiff).abs() * (pi / 180);
  // }

  Paint get _brush => new Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = _brush..color = Colors.indigo[400].withOpacity(0.6);

    Paint needle = _brush..color = Colors.red[400];

    double radius = min(size.width / 2.6, size.height / 2.6);
    Offset center = Offset(size.width / 2, size.height / 2);
    Offset start = Offset.lerp(Offset(center.dx, radius), center, 0.4);
    Offset end = Offset.lerp(Offset(center.dx, radius), center, -0.1);

    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawLine(start, end, needle);
    canvas.drawCircle(center, radius, circle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
