import 'package:get/state_manager.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';

import 'beacon_controller.dart';

class PermissionController extends GetxController {
  var permissionGranted = false.obs;
  final beaconController = Get.put(BeaconController());

  @override
  void onInit() {
    super.onInit();
    getPermissionStatus();
  }

  void getPermissionStatus() async {
    var status = await Permission.location.status;
    print("Permission Status: " + status.toString());

    setPermission(status);
  }

  void setPermission(PermissionStatus status) async {
    switch (status) {
      case PermissionStatus.granted:
        permissionGranted.value = true;
        beaconController.beaconInitPlatformState();
        break;

      default:
        permissionGranted.value = false;
      // PermissionStatus permission =
      //     await LocationPermissions().requestPermissions();
      // setPermission(permission);
    }
  }
}
