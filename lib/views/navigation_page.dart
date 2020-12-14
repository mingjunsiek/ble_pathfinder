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
  final compassController = Get.find<CompassController>();
  // final arController = Get.put(ARCoreController());

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
                Text(
                  'Current Location: ',
                  style: TextStyle(
                    fontSize: getDefaultProportionateScreenWidth(),
                  ),
                ),
                Obx(
                  () => Text(
                    navigationController.currentNode.value.name,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: getDefaultProportionateScreenWidth(),
                    ),
                  ),
                ),
                // Obx(
                //   () => Text(
                //     navigationController.printList,
                //   ),
                // ),
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
                  alignment: Alignment(0, 0),
                  child: Obx(
                    () => AnimatedSwitcher(
                      duration: Duration(milliseconds: 1000),
                      transitionBuilder: (widget, animation) => ScaleTransition(
                        scale: animation,
                        child: widget,
                      ),
                      switchOutCurve: Curves.easeOutExpo,
                      switchInCurve: Curves.easeInExpo,
                      child: navigationController.levelNavigation.value ==
                              LevelNavigation.go_down
                          ? Container(
                              alignment: Alignment(0, 0),
                              height: displayHeight(context) * 0.35,
                              key: UniqueKey(),
                              child: Text(
                                'Go Up One Level',
                                style: TextStyle(
                                  fontSize:
                                      getDefaultProportionateScreenWidth(),
                                ),
                              ),
                            )
                          : navigationController.levelNavigation.value ==
                                  LevelNavigation.go_up
                              ? Container(
                                  alignment: Alignment(0, 0),
                                  height: displayHeight(context) * 0.35,
                                  key: UniqueKey(),
                                  child: Text(
                                    'Go Down One Level',
                                    style: TextStyle(
                                      fontSize:
                                          getDefaultProportionateScreenWidth(),
                                    ),
                                  ),
                                )
                              : navigationController.levelNavigation.value ==
                                      LevelNavigation.same_level
                                  ? Container(
                                      alignment: Alignment(0, 0),
                                      key: UniqueKey(),
                                      child: CustomPaint(
                                        foregroundPainter: CompassParentPainter(
                                          locationAngle: navigationController
                                              .directionDegree.value,
                                        ),
                                        child: CustomPaint(
                                          foregroundPainter: CompassPainter(
                                            angle:
                                                compassController.heading.value,
                                          ),
                                          child: Center(
                                            child:
                                                Text(compassController.readout),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment(0, 0),
                                      height: displayHeight(context) * 0.35,
                                      key: UniqueKey(),
                                      child: Text(
                                        'Finding Path to Destination',
                                        style: TextStyle(
                                          fontSize:
                                              getDefaultProportionateScreenWidth(),
                                        ),
                                      ),
                                    ),
                    ),
                  ),
                ),
                Container(
                  height: displayHeight(context) * 0.1,
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
