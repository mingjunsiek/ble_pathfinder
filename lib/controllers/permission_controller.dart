import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';

import 'beacon_controller.dart';

class PermissionController extends GetxController {
  var locationPermissionGranted = false.obs;
  var cameraPermissionGranted = false.obs;
  var bluetoothStatus = false.obs;
  final beaconController = Get.put(BeaconController());

  @override
  void onInit() {
    super.onInit();
    checkPermissionStatus();
  }

  void askForPermission() async {
    locationPermissionGranted.value =
        await Permission.location.status.isGranted;
    cameraPermissionGranted.value = await Permission.camera.request().isGranted;
    bluetoothStatus.value = await FlutterBlue.instance.isOn;
  }

  // TODO: Unknown bug in checkPermissionStatus, when permission is not allowed, when user
  // click on "open settings" and enabled permission and goes back to app,
  // beaconController.beaconInitPlatformState() does not work properly
  void checkPermissionStatus() async {
    // var locationStatus = await Permission.location.status;
    // var cameraStatus = await Permission.camera.status;

    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
    ].request();

    if (statuses[Permission.location] != PermissionStatus.granted) {
      var locStatus = await Permission.location.request();
      locationPermissionGranted.value = locStatus.isGranted;
    } else {
      locationPermissionGranted.value = true;
    }

    if (statuses[Permission.camera] != PermissionStatus.granted) {
      var camStatus = await Permission.camera.request();
      cameraPermissionGranted.value = camStatus.isGranted;
    } else {
      cameraPermissionGranted.value = true;
    }

    bluetoothStatus.value = await FlutterBlue.instance.isOn;
    print("Permission Status: " + locationPermissionGranted.value.toString());
    print("Bluetooth Status: " + bluetoothStatus.value.toString());
    print("Camera Status: " + cameraPermissionGranted.value.toString());
  }
}
