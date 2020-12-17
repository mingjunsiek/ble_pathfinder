import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ble_pathfinder/controllers/ar_core_controller.dart';
import 'package:ble_pathfinder/controllers/beacon_controller.dart';
import 'package:ble_pathfinder/controllers/compass_controller.dart';
import 'package:ble_pathfinder/controllers/navigation_controller.dart';
import 'package:ble_pathfinder/controllers/permission_controller.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/views/permission_page.dart';
import 'package:ble_pathfinder/views/selection_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreenPage extends StatelessWidget {
  final beaconController = Get.put(BeaconController(), permanent: true);
  final permissionController = Get.put(PermissionController(), permanent: true);
  final compassController = Get.put(CompassController());
  final navigationController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    beaconController.beaconInitPlatformState();
    SizeConfig().init(context);

    return AnimatedSplashScreen(
      splash: './assets/images/splash/ic_splash.png',
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.fade,
      nextScreen: Obx(
        () => permissionController.locationPermissionGranted.value == false ||
                permissionController.bluetoothStatus.value == false

            // || permissionController.cameraPermissionGranted.value == false
            ? PermissionPage()
            : SelectionPage(),
      ),
      duration: 1,
      splashIconSize: getProportionateScreenWidth(300),
    );
  }
}
