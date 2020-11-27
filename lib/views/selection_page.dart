import 'package:ble_pathfinder/controllers/selection_controller.dart';
import 'package:ble_pathfinder/models/poi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SelectionPage extends StatelessWidget {
  final selectionController = Get.put(SelectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => selectionController.fetchedStartingPoint == false.obs
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownSearch<POI>(
                          label: 'Starting Point',
                          items: selectionController.poiList,
                          itemAsString: (POI poi) => poi.name,
                          selectedItem: selectionController.startingPoint,
                          enabled: false,
                        ),
                        Divider(),
                        DropdownSearch<POI>(
                          label: 'Destination',
                          items: selectionController.poiList,
                          itemAsString: (POI poi) => poi.name,
                        ),
                        Text(selectionController.beaconResult.value),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
