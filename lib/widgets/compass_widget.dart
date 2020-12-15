import 'package:ble_pathfinder/controllers/compass_controller.dart';
import 'package:ble_pathfinder/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'compass_painter.dart';
import 'compass_parent_painter.dart';

class CompassWidget extends StatelessWidget {
  final navigationController = Get.find<NavigationController>();
  final compassController = Get.find<CompassController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomPaint(
        foregroundPainter: CompassParentPainter(
          currentBearing: compassController.heading.value,
          locationBearing: navigationController.directionDegree.value,
        ),
        child: CustomPaint(
          foregroundPainter: CompassPainter(
            currentBearing: compassController.heading.value,
            locationBearing: navigationController.directionDegree.value,
          ),
          child: Center(
            child: Text(compassController.readout),
          ),
        ),
      ),
    );
  }
}
