import 'package:ble_pathfinder/controllers/ar_core_controller.dart';
import 'package:ble_pathfinder/controllers/beacon_controller.dart';
import 'package:ble_pathfinder/controllers/compass_controller.dart';
import 'package:ble_pathfinder/controllers/navigation_controller.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:ble_pathfinder/widgets/compass_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationPage extends StatelessWidget {
  final navigationController = Get.find<NavigationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => Text(
                  navigationController.currentNodeId.value.toString(),
                ),
              ),
              Obx(
                () => Text(
                  navigationController.printList,
                ),
              ),
              Container(
                height: displayHeight(context) * 0.40,
                child: GetBuilder<ARCoreController>(
                  init: ARCoreController(),
                  builder: (controller) => controller.initArCoreview(),
                ),
              ),
              Container(
                height: displayHeight(context) * 0.40,
                child: GetX<CompassController>(
                    init: CompassController(),
                    builder: (controller) {
                      return CustomPaint(
                        foregroundPainter:
                            CompassPainter(angle: controller.heading.value),
                        child: Center(
                          child: Text(controller.readout),
                        ),
                      );
                    }),
              ),
              Obx(
                () => navigationController.reachedDestination.value
                    ? Text("Reached Destination")
                    : Text(
                        navigationController.directionString,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
