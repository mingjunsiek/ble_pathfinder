import 'package:ble_pathfinder/controllers/beacon_controller.dart';
import 'package:ble_pathfinder/controllers/image_controller.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/controllers/permission_controller.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:ble_pathfinder/views/selection_page.dart';
import 'package:ble_pathfinder/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPage extends StatelessWidget {
  // final permissionController = Get.find<PermissionController>();
  final imageController = Get.find<ImageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  "Please Allow / Enable The Following Permissions",
                  style: TextStyle(
                    fontSize: getDefaultProportionateScreenWidth(),
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Image(
                  image: imageController.vectorPermission.image,
                ),
                Spacer(),
                Text(
                  "Restart app after enabling permission",
                  style: TextStyle(
                    fontSize: getDefaultProportionateScreenWidth(),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: displayHeight(context) * 0.02,
                ),
                RoundedButton(
                  btnColor: kSecondaryColor,
                  btnText: 'GO TO SETTINGS',
                  btnFunction: () {
                    openAppSettings();
                  },
                ),
                // RoundedButton(
                //   btnColor: kPrimaryColor,
                //   btnText: 'NEXT',
                //   btnFunction: () async {
                //     await permissionController.checkPermissionStatus();
                //     if (permissionController.locationPermissionGranted.value ==
                //             true &&
                //         permissionController.bluetoothStatus.value == true) {
                //       Get.off(SelectionPage());
                //     } else {
                //       Get.rawSnackbar(
                //         titleText: Text(
                //           'Error',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.w800,
                //             fontSize: 16,
                //           ),
                //         ),
                //         messageText: Text(
                //           'Please allow the permissions above.',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 16,
                //           ),
                //         ),
                //         // snackPosition: SnackPosition.BOTTOM,
                //         // snackStyle: SnackStyle.FLOATING,
                //       );
                //     }
                //   },
                // ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
