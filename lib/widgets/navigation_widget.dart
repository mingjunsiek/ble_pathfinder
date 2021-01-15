import 'package:ble_pathfinder/controllers/compass_controller.dart';
import 'package:ble_pathfinder/controllers/image_controller.dart';
import 'package:ble_pathfinder/controllers/navigation_controller.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
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
    return Container(
      alignment: Alignment(0, 0),
      key: UniqueKey(),
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: rotation,
              child: Image(
                image: imageController.gifNavigation.image,
                height: displayHeight(context) * 0.4,
              ),
            ),
            SizedBox(
              height: displayHeight(context) * 0.02,
            ),
            Text(
              'Walk towards the arrow',
              style: TextStyle(
                fontSize: getDefaultProportionateScreenWidth(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
