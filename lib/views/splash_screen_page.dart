import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ble_pathfinder/controllers/permission_controller.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/views/permission_page.dart';
import 'package:ble_pathfinder/views/selection_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenPage extends StatelessWidget {
  final permissionController = Get.find<PermissionController>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return AnimatedSplashScreen.withScreenFunction(
      splash: './assets/images/splash/ic_splash.png',
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.fade,
      screenFunction: () async {
        await permissionController.checkPermissionStatus();
        if (permissionController.locationPermissionGranted.value == false ||
            permissionController.bluetoothStatus.value == false)
          return PermissionPage();
        else {
          return SelectionPage();
        }
      },
      splashIconSize: getProportionateScreenWidth(300),
    );
  }
}
