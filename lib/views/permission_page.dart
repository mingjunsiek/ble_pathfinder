import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/controllers/permission_controller.dart';
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Location.png',
                        width: getProportionateScreenWidth(60),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(60),
                      ),
                      Image.asset(
                        'assets/images/Bluetooth.png',
                        width: getProportionateScreenWidth(70),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    "Please allow / enable the following:",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(20),
                    ),
                  ),
                  if (permissionController.permissionGranted.value == false)
                    Text(
                      "Location Permission",
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
                    height: getProportionateScreenHeight(20),
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