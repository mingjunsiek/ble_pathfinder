import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  var locationPermissionGranted = false.obs;
  var bluetoothStatus = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await checkPermissionStatus();
  }

  void askPermission() async {
    var locStatus = await Permission.location.request();
    locationPermissionGranted.value = locStatus.isGranted;
    checkPermissionStatus();
  }

  // TODO: Unknown bug in checkPermissionStatus, when permission is not allowed, when user
  // click on "open settings" and enabled permission and goes back to app,
  // beaconController.beaconInitPlatformState() does not work properly
  Future<void> checkPermissionStatus() async {
    var locationStatus = await Permission.location.status;

    if (locationStatus == PermissionStatus.granted) {
      locationPermissionGranted.value = true;
    } else {
      var locStatus = await Permission.location.request();
      locationPermissionGranted.value = locStatus.isGranted;
    }

    bluetoothStatus.value = await FlutterBlue.instance.isOn;
    print("Permission Status: " + locationPermissionGranted.value.toString());
    print("Bluetooth Status: " + bluetoothStatus.value.toString());
  }
}
