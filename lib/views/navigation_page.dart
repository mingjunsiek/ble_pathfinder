import 'package:ble_pathfinder/controllers/ar_core_controller.dart';
import 'package:ble_pathfinder/controllers/beacon_controller.dart';
import 'package:ble_pathfinder/controllers/compass_controller.dart';
import 'package:ble_pathfinder/controllers/navigation_controller.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:ble_pathfinder/widgets/compass_painter.dart';
import 'package:ble_pathfinder/widgets/compass_parent_painter.dart';
import 'package:ble_pathfinder/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationPage extends StatelessWidget {
  final navigationController = Get.find<NavigationController>();
  final compassController = Get.put(CompassController());
  final arController = Get.put(ARCoreController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Current Location: '),
                      Text(
                        navigationController.currentNode.value.name,
                        style: TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Text(
                    navigationController.printList,
                  ),
                ),
                // AR Navigation
                // Container(
                //   height: displayHeight(context) * 0.70,
                //   child: GetBuilder<ARCoreController>(
                //     init: ARCoreController(),
                //     builder: (controller) => controller.initArCoreview(),
                //   ),
                // ),
                // Obx(
                //   () => Text(
                //     'Position: ${arController.modelPosition.value}',
                //   ),
                // ),
                // Compass Navigation
                Container(
                  height: displayHeight(context) * 0.7,
                  child: Obx(
                    () => CustomPaint(
                      foregroundPainter: CompassParentPainter(
                        locationAngle:
                            navigationController.directionDegree.value,
                      ),
                      child: CustomPaint(
                        foregroundPainter: CompassPainter(
                          angle: compassController.heading.value,
                        ),
                        child: Center(
                          child: Text(compassController.readout),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: displayHeight(context) * 0.1,
                  alignment: Alignment(0, 0),
                  child: Obx(
                    () => navigationController.reachedDestination.value
                        ? Column(
                            children: [
                              Text("Reached Destination"),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: displayWidth(context) * 0.2,
                                ),
                                child: RoundedButton(
                                    btnColor: Color(0xFF42CF1F),
                                    btnText: 'DONE',
                                    btnFunction: () {
                                      Get.back();
                                    }),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Text(
                                navigationController.directionString,
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: displayWidth(context) * 0.2,
                                ),
                                child: RoundedButton(
                                  btnColor: Color(0xFFCF1F1F),
                                  btnText: 'CANCEL',
                                  btnFunction: () {
                                    Get.back();
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
