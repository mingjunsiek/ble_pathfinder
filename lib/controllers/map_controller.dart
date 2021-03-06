import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/image_constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:ble_pathfinder/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapController extends GetxController {
  String currentMap = gifNodeAll;

  Future<Dialog> getAllPOIDialog(
      String title, BuildContext context, MapType mapType) {
    return Get.defaultDialog(
        title: title,
        titleStyle: Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: getDefaultProportionateScreenWidth(),
            ),
        content: MapWidget(
          mapType: mapType,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pinch to Zoom',
                style: TextStyle(
                  fontSize: getDefaultProportionateScreenWidth(),
                ),
              ),
              Image.asset(
                gifMapPinch,
                width: displayWidth(context) * 0.1,
              ),
            ],
          ),
        ]);
  }

  String getMap(int nodeID) {
    switch (nodeID) {
      case 1:
        currentMap = gifNode1;
        break;
      case 2:
        currentMap = gifNode2;
        break;
      case 3:
        currentMap = gifNode3;
        break;
      case 4:
        currentMap = gifNode4;
        break;
      case 5:
        currentMap = gifNode5;
        break;
      case 6:
        currentMap = gifNode6;
        break;
      case 7:
        currentMap = gifNode7;
        break;
      case 8:
        currentMap = gifNode8;
        break;
      case 9:
        currentMap = gifNode9;
        break;
      case 10:
        currentMap = gifNode10;
        break;
      case 11:
        currentMap = gifNode11;
        break;
      case 12:
        currentMap = gifNode12;
        break;
      case 13:
        currentMap = gifNode13;
        break;
      case 14:
        currentMap = gifNode14;
        break;
      default:
        currentMap = gifNodeAll;
        break;
    }
    return currentMap;
  }
}
