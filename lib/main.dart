import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/views/splash_screen_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/beacon_controller.dart';
import 'controllers/compass_controller.dart';
import 'controllers/navigation_controller.dart';
import 'controllers/permission_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Get.putAsync(() => InitializeService().init());
  runApp(MyApp());
}

class InitializeService extends GetxService {
  Future<InitializeService> init() async {
    Get.put(PermissionController());
    Get.put(CompassController());
    Get.put(NavigationController());
    Get.put(BeaconController());
    return this;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: SplashScreenPage(),
    );
  }
}
