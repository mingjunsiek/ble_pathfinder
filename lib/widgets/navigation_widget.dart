import 'package:ble_pathfinder/controllers/compass_controller.dart';
import 'package:ble_pathfinder/controllers/image_controller.dart';
import 'package:ble_pathfinder/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:math';

class NavigationWidget extends StatelessWidget {
  final navigationController = Get.find<NavigationController>();
  final compassController = Get.find<CompassController>();
  final imageController = Get.find<ImageController>();

  // final double currentBearing, locationBearing;

  double get rotation {
    double direction = navigationController.directionDegree.value -
        compassController.heading.value;
    if (direction < 0) direction += 360;
    return direction * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Transform.rotate(
        angle: rotation,
        child: Image(
          image: imageController.gifNavigation.image,
        ),
      ),
    );
    // Obx(
    //   () => CustomPaint(
    //     foregroundPainter: CompassParentPainter(
    //       currentBearing: compassController.heading.value,
    //       locationBearing: navigationController.directionDegree.value,
    //     ),
    //     child: CustomPaint(
    //       foregroundPainter: CompassPainter(
    //         currentBearing: compassController.heading.value,
    //         locationBearing: navigationController.directionDegree.value,
    //       ),
    //       child: Center(
    //         child: Text(compassController.readout),
    //       ),
    //     ),
    //   ),
    // );
  }
}
