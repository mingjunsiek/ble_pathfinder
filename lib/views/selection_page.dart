import 'package:ble_pathfinder/controllers/beacon_controller.dart';
import 'package:ble_pathfinder/models/poi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SelectionPage extends StatelessWidget {
  final beaconController = Get.put(BeaconController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => beaconController.fetchingBeacons == true.obs
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: beaconController.haveCurrentLocation == false.obs
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  "Not nearby POI, please move to the nearest POI"),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DropdownSearch<POI>(
                                label: 'Starting Point',
                                items: beaconController.poiList,
                                itemAsString: (POI poi) => poi.name,
                                selectedItem: beaconController.currentLocation,
                                enabled: false,
                              ),
                              Divider(),
                              DropdownSearch<POI>(
                                label: 'Destination',
                                items: beaconController.poiList,
                                itemAsString: (POI poi) => poi.name,
                              ),
                              Text(beaconController.beaconResult.value),
                            ],
                          ),
                  ),
                ),
        ),
      ),
    );
  }
}
