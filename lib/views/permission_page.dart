import 'package:ble_pathfinder/controllers/image_controller.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/controllers/permission_controller.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:ble_pathfinder/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPage extends StatelessWidget {
  final permissionController = Get.put(PermissionController());
  final imageController = Get.put(ImageController());

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
                  width: displayWidth(context) * 0.8,
                ),
                Spacer(),
                RoundedButton(
                  btnColor: kSecondaryColor,
                  btnText: 'GO TO SETTINGS',
                  btnFunction: () {
                    openAppSettings();
                  },
                ),
                SizedBox(
                  height: displayHeight(context) * 0.02,
                ),
                RoundedButton(
                  btnColor: kPrimaryColor,
                  btnText: 'NEXT',
                  btnFunction: () {
                    permissionController.checkPermissionStatus();
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
