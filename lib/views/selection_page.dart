import 'package:ble_pathfinder/controllers/beacon_controller.dart';
import 'package:ble_pathfinder/controllers/image_controller.dart';
import 'package:ble_pathfinder/controllers/navigation_controller.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:ble_pathfinder/widgets/selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectionPage extends StatelessWidget {
  final beaconController = Get.find<BeaconController>();
  final imageController = Get.find<ImageController>();

  @override
  Widget build(BuildContext context) {
    beaconController.startMonitoring();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Obx(
            () => AnimatedSwitcher(
              duration: Duration(milliseconds: 1000),
              switchOutCurve: Curves.fastOutSlowIn,
              switchInCurve: Curves.fastOutSlowIn,
              child: beaconController.fetchingBeacons == true.obs
                  ? Container(
                      key: UniqueKey(),
                      alignment: Alignment(0, 0),
                      // height: displayWidth(context) * 0.7,
                      child: Image(
                        image: imageController.vectorLoading.image,
                      ),
                    )
                  : beaconController.haveCurrentLocation == false.obs
                      ? Center(
                          key: UniqueKey(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You are not near a Point Of Interest",
                                style: TextStyle(
                                  fontSize:
                                      getDefaultProportionateScreenWidth(),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: displayHeight(context) * 0.02,
                              ),
                              Text(
                                "Please move to the nearest Point Of Interest",
                                style: TextStyle(
                                  fontSize:
                                      getDefaultProportionateScreenWidth(),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          key: UniqueKey(),
                          child: SelectionWidget(),
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
