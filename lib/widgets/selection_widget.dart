import 'package:ble_pathfinder/controllers/beacon_controller.dart';
import 'package:ble_pathfinder/controllers/image_controller.dart';
import 'package:ble_pathfinder/controllers/navigation_controller.dart';
import 'package:ble_pathfinder/models/poinode.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:ble_pathfinder/views/navigation_page.dart';
import 'package:ble_pathfinder/widgets/rounded_button.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectionWidget extends StatelessWidget {
  final beaconController = Get.find<BeaconController>();
  final navigationController = Get.find<NavigationController>();
  final imageController = Get.find<ImageController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    'Current Location:',
                    style: TextStyle(
                      fontSize: getDefaultProportionateScreenWidth(),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: getProportionateScreenHeight(130),
                    child: Obx(
                      () => AnimatedSwitcher(
                        duration: Duration(milliseconds: 2000),
                        transitionBuilder: (widget, animation) {
                          final offsetAnimation = Tween<Offset>(
                            begin: const Offset(1.5, 0.0),
                            end: Offset.zero,
                          ).animate(animation);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: widget,
                          );
                        },
                        switchOutCurve: Curves.elasticOut,
                        switchInCurve: Curves.elasticIn,
                        child: Container(
                          key: UniqueKey(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                beaconController.currentLocation.value.name,
                                key: UniqueKey(),
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(36),
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Image(
                                image: imageController.vectorShadow.image,
                                width: displayWidth(context) * 0.8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Obx(
                    () => DropdownSearch<POINode>(
                      label: 'Select Destination',
                      mode: Mode.BOTTOM_SHEET,
                      items: beaconController.getSelectionList(
                          beaconController.currentLocation.value.name),
                      itemAsString: (POINode poi) => poi.name,
                      onChanged: (value) {
                        beaconController.destinationLocation = value;
                        print(beaconController.destinationLocation.name);
                      },
                    ),
                  ),
                  SizedBox(
                    height: displayHeight(context) * 0.02,
                  ),
                  RoundedButton(
                    btnText: 'Continue',
                    btnColor: kPrimaryColor,
                    btnFunction: () {
                      if (beaconController.destinationLocation.isNull) {
                        Get.rawSnackbar(
                          titleText: Text(
                            'Error',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          messageText: Text(
                            'Please select a destination',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          // snackPosition: SnackPosition.BOTTOM,
                          // snackStyle: SnackStyle.FLOATING,
                        );
                        // Get.snackbar(
                        //   'Error',
                        //   null,
                        //   titleText: Text(
                        //     'Error',
                        //     style: TextStyle(
                        //       color: Colors.black,
                        //       fontWeight: FontWeight.w800,
                        //       fontSize: 16,
                        //     ),
                        //   ),
                        //   messageText: Text(
                        //       'Please select a destination'),
                        //   snackPosition: SnackPosition.BOTTOM,
                        //   snackStyle: SnackStyle.FLOATING,
                        // );
                      } else {
                        navigationController.setNavigationSettings(
                            beaconController.poiNodes,
                            beaconController.poiList,
                            beaconController.currentLocation.value.nodeID,
                            beaconController.destinationLocation.nodeID);
                        navigationController.findPathToDestination();
                        navigationController.isNavigating = true;
                        Get.to(NavigationPage());
                      }
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}