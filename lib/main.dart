import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:ble_pathfinder/controllers/permission_controller.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/views/permission_page.dart';
import 'package:ble_pathfinder/views/splash_screen_page.dart';
import 'package:flutter/services.dart';
import 'package:ble_pathfinder/views/selection_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  print('ARCORE IS AVAILABLE?');
  print(await ArCoreController.checkArCoreAvailability());
  print('AR SERVICES INSTALLED?');
  print(await ArCoreController.checkIsArCoreInstalled());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final permissionController = Get.put(PermissionController());
  @override
  Widget build(BuildContext context) {
    permissionController.checkPermissionStatus();

    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Mulish",
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: kTextColor,
          ),
          bodyText2: TextStyle(
            color: kTextColor,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home:
      home:
          // NavigationPage(),
          Obx(
        () => permissionController.locationPermissionGranted.value == false ||
                permissionController.bluetoothStatus.value == false ||
                permissionController.cameraPermissionGranted.value == false
            ? PermissionPage()
            : SelectionPage(),
      ),
    );
  }
}
