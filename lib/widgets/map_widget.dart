import 'package:ble_pathfinder/controllers/beacon_controller.dart';
import 'package:ble_pathfinder/controllers/map_controller.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/image_constants.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapWidget extends StatelessWidget {
  MapWidget({Key key, this.mapType}) : super(key: key);
  final MapType mapType;
  final beaconController = Get.find<BeaconController>();
  final mapController = Get.find<MapController>();

  @override
  Widget build(BuildContext context) {
    String mapPath;
    if (mapType == MapType.onboard)
      mapPath = gifNodeAll;
    else
      mapPath =
          mapController.getMap(beaconController.currentLocation.value.nodeID);

    return Container(
      height: displayHeight(context) * 0.7,
      width: displayWidth(context) * 0.9,
      child: ClipRRect(
        child: InteractiveViewer(
          minScale: 0.2,
          maxScale: 3.5,
          child: Image.asset(
            mapPath,
          ),
        ),
      ),
    );
  }
}
