import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:ble_pathfinder/controllers/ar_core_controller.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: displayHeight(context) * 0.80,
              child: GetBuilder<ARCoreController>(
                init: ARCoreController(),
                builder: (controller) => controller.initArCoreview(),
              ),
            ),
            SizedBox(
                // height: displayHeight(context) * 0.20,
                ),
          ],
        ),
      ),
    );
  }
}
