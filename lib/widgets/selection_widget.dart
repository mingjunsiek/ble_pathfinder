import 'package:ble_pathfinder/controllers/beacon_controller.dart';
import 'package:ble_pathfinder/controllers/navigation_controller.dart';
import 'package:ble_pathfinder/models/location.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/image_constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:ble_pathfinder/views/navigation_page.dart';
import 'package:ble_pathfinder/widgets/rounded_button.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../utils/constants.dart';
import '../utils/size_helpers.dart';
import 'map_widget.dart';

class SelectionWidget extends StatelessWidget {
  final beaconController = Get.find<BeaconController>();
  final navigationController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      child: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: displayHeight(context) * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            OMIcons.settings,
                            color: kSecondaryColor,
                            size: displayWidth(context) * 0.08,
                          ),
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'Beacon List',
                              content: Obx(
                                () => Text(beaconController.printList),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            OMIcons.map,
                            color: kSecondaryColor,
                            size: displayWidth(context) * 0.08,
                          ),
                          onPressed: () {
                            Get.defaultDialog(
                                title: 'Current Location',
                                titleStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          getDefaultProportionateScreenWidth(),
                                    ),
                                content: MapWidget(
                                  mapType: MapType.view_map,
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Pinch to Zoom',
                                        style: TextStyle(
                                          fontSize:
                                              getDefaultProportionateScreenWidth(),
                                        ),
                                      ),
                                      Image.asset(
                                        gifMapPinch,
                                        width: displayWidth(context) * 0.1,
                                      ),
                                    ],
                                  ),
                                ]);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.03,
                    ),
                    Text(
                      'Current Location:',
                      style: TextStyle(
                        fontSize: getDefaultProportionateScreenWidth(),
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Section: ',
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(18),
                              ),
                            ),
                            Text(
                              beaconController.currentLocation.value.section,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: getProportionateScreenWidth(18),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Level: ',
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(18),
                              ),
                            ),
                            Text(
                              beaconController.currentLocation.value.level == 0
                                  ? 'B1'
                                  : beaconController.currentLocation.value.level
                                      .toString(),
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: getProportionateScreenWidth(18),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                                Image.asset(
                                  'assets/images/vectors/vector_shadow.png',
                                  width: displayWidth(context) * 0.8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    // Obx(
                    //   () =>
                    DropdownSearch<LocationInfo>(
                      label: 'Select Destination',
                      mode: Mode.BOTTOM_SHEET,
                      // items: beaconController.getSelectionList(
                      //     beaconController.currentLocation.value.name),
                      itemAsString: (LocationInfo loc) => loc.name,
                      onChanged: (value) {
                        beaconController.setDestination(value.nodeID);
                        print(beaconController.destinationLocation.name);
                      },
                      showSearchBox: true,
                      searchBoxDecoration: InputDecoration(
                        prefixIcon: Icon(OMIcons.search),
                        labelText: 'Search POI',
                      ),
                      onFind: (String filter) =>
                          beaconController.onSearch(filter),
                    ),
                    // ),
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
                          );
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
