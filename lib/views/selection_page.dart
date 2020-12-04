import 'package:ble_pathfinder/controllers/beacon_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

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
                        horizontal: 20,
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
                        horizontal: 20,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Your Current Location:',
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(20),
                                    ),
                                  ),
                                  Text(
                                    beaconController.currentLocation.value.name,
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(36),
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  DropdownSearch<POINode>(
                                    label: 'Destination',
                                    items: beaconController.poiList,
                                    itemAsString: (POINode poi) => poi.name,
                                    onChanged: (value) {
                                      beaconController.destinationLocation =
                                          value;
                                      print(beaconController
                                          .destinationLocation.name);
                                    },
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
                                  )
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
