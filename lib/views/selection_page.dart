import 'package:ble_pathfinder/controllers/beacon_controller.dart';
import 'package:ble_pathfinder/controllers/image_controller.dart';
import 'package:ble_pathfinder/controllers/navigation_controller.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:ble_pathfinder/views/navigation_page.dart';
import 'package:ble_pathfinder/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../models/poinode.dart';

class SelectionPage extends StatelessWidget {
  final beaconController = Get.put(BeaconController());
  final navigationController = Get.put(NavigationController());
  final imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    beaconController.startMonitoring();

    return Scaffold(
      body: Obx(
        () => beaconController.fetchingBeacons == true.obs
            ? Center(
                child: CircularProgressIndicator(),
              )
            : beaconController.haveCurrentLocation == false.obs
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You are not near a Point Of Interest",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(20),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: displayHeight(context) * 0.02,
                          ),
                          Text(
                            "Please move to the nearest Point Of Interest",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(20),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
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
                                      fontSize: getProportionateScreenWidth(20),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: getProportionateScreenHeight(130),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          beaconController
                                              .currentLocation.value.name,
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(36),
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Image(
                                          image: imageController
                                              .vectorShadow.image,
                                          width: displayWidth(context) * 0.8,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  DropdownSearch<POINode>(
                                    label: 'Select Destination',
                                    mode: Mode.BOTTOM_SHEET,
                                    items: beaconController.getSelectionList(
                                        beaconController
                                            .currentLocation.value.name),
                                    itemAsString: (POINode poi) => poi.name,
                                    onChanged: (value) {
                                      beaconController.destinationLocation =
                                          value;
                                      print(beaconController
                                          .destinationLocation.name);
                                    },
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.02,
                                  ),
                                  RoundedButton(
                                    btnText: 'Continue',
                                    btnColor: kPrimaryColor,
                                    btnFunction: () {
                                      navigationController
                                          .setNavigationSettings(
                                              beaconController.poiNodes,
                                              beaconController.poiList,
                                              beaconController
                                                  .currentLocation.value.nodeID,
                                              beaconController
                                                  .destinationLocation.nodeID);
                                      navigationController
                                          .findPathToDestination();
                                      Get.to(NavigationPage());
                                    },
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                            // Expanded(
                            //   flex: 3,
                            //   child: Column(
                            //     children: [
                            //       Spacer(),
                            //       Text('Your Current Location'),
                            //       Text(
                            //         beaconController.currentLocation.value.name,
                            //         style: TextStyle(
                            //           fontSize: getProportionateScreenWidth(36),
                            //           color: kPrimaryColor,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),

      // Center(
      //   child: Obx(
      //     () => beaconController.fetchingBeacons == true.obs
      //         ? CircularProgressIndicator()
      //         : SingleChildScrollView(
      //             child: Padding(
      //               padding: EdgeInsets.symmetric(
      //                 horizontal: 20,
      //               ),
      //               child: beaconController.haveCurrentLocation == false.obs
      //                   ? Column(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       children: [
      //                         Text(
      //                             "Not nearby POI, please move to the nearest POI"),
      //                       ],
      //                     )
      //                   : Column(
      //                       // mainAxisAlignment: MainAxisAlignment.center,
      //                       children: [

      //                         Expanded(
      //                           child: ,
      //                         ),
      //                         Text(
      //                           beaconController.currentLocation.value.name,
      //                           textAlign: TextAlign.end,
      //                           // style: TextStyle(s),
      //                         ),
      //                         DropdownSearch<POI>(
      //                           label: 'Destination',
      //                           items: beaconController.poiList,
      //                           itemAsString: (POI poi) => poi.name,
      //                         ),
      //                         // Text(beaconController.beaconResult.value),
      //                         SizedBox(
      //                           width: double.infinity,
      //                           height: getProportionateScreenHeight(56),
      //                           child: FlatButton(
      //                             shape: RoundedRectangleBorder(
      //                               borderRadius: BorderRadius.circular(20),
      //                             ),
      //                             color: kPrimaryColor,
      //                             onPressed: () {},
      //                             child: Text(
      //                               "Continue",
      //                               style: TextStyle(
      //                                 fontSize: getProportionateScreenWidth(18),
      //                                 color: Colors.white,
      //                               ),
      //                             ),
      //                           ),
      //                         )
      //                       ],
      //                     ),
      //             ),
      //           ),
      //   ),
      // ),
    );
  }
}
