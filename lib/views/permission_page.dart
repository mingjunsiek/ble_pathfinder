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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Image.asset(
                        'assets/images/Location.png',
                        width: displayWidth(context) * 0.2,
                      ),
                      SizedBox(),
                      Image.asset(
                        'assets/images/Camera.png',
                        width: displayWidth(context) * 0.25,
                      ),
                      SizedBox(),
                      Image.asset(
                        'assets/images/Bluetooth.png',
                        width: displayWidth(context) * 0.2,
                      ),
                      SizedBox(),
                    ],
                  ),
                  Spacer(),
                  Text(
                    "Please allow / enable the following:",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(20),
                    ),
                  ),
                  if (permissionController.locationPermissionGranted.value ==
                      false)
                    Text(
                      "Location Permission",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (permissionController.cameraPermissionGranted.value ==
                      false)
                    Text(
                      "Camera Permission",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (permissionController.bluetoothStatus.value == false)
                    Text(
                      "Bluetooth",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Spacer(),
                  RoundedButton(
                    btnColor: Color(0xFF757575),
                    btnText: 'Go to settings',
                    btnFunction: () {
                      openAppSettings();
                    },
                  ),
                  SizedBox(
                    height: displayHeight(context) * 0.02,
                  ),
                  RoundedButton(
                    btnColor: kPrimaryColor,
                    btnText: 'Completed',
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
      ),
    );
  }
}
