// import 'package:ble_pathfinder/controllers/ar_core_controller.dart';
// import 'package:ble_pathfinder/controllers/beacon_controller.dart';
import 'package:ble_pathfinder/controllers/navigation_controller.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationPage extends StatelessWidget {
  final navigationController = Get.find<NavigationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  navigationController.currentNodeId.value.toString(),
                ),
                Text(
                  navigationController.visitedArray.toString(),
                ),
              ],
            ),
          ),
          // Column(
          //   children: [
          //     Container(
          //       height: displayHeight(context) * 0.80,
          //       child: GetBuilder<ARCoreController>(
          //         init: ARCoreController(),
          //         builder: (controller) => controller.initArCoreview(),
          //       ),
          //     ),
          //     SizedBox(
          //         // height: displayHeight(context) * 0.20,
          //         ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
