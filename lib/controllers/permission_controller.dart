import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';

import 'beacon_controller.dart';

class PermissionController extends GetxController {
  var permissionGranted = false.obs;
  var bluetoothStatus = false.obs;
  final beaconController = Get.put(BeaconController());

  @override
  void onInit() {
    super.onInit();
    checkPermissionStatus();
  }

  void checkPermissionStatus() async {
    var status = await Permission.location.status;

    if (status != PermissionStatus.granted) {
      permissionGranted.value = await Permission.location.request().isGranted;
    } else {
      permissionGranted.value = true;
    }
    bluetoothStatus.value = await FlutterBlue.instance.isOn;
    print("Permission Status: " + permissionGranted.value.toString());
    print("Bluetooth Status: " + bluetoothStatus.value.toString());
    if (permissionGranted.value && bluetoothStatus.value) {
      beaconController.beaconInitPlatformState();
    }
  }

  void getPermissionStatus() async {
    var status = await Permission.location.status;

    if (status == PermissionStatus.granted) {
      permissionGranted.value = true;
    }
  }
}
