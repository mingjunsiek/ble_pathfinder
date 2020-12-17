import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/views/splash_screen_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/image_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  print('ARCORE IS AVAILABLE?');
  print(await ArCoreController.checkArCoreAvailability());
  print('AR SERVICES INSTALLED?');
  print(await ArCoreController.checkIsArCoreInstalled());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final imageController = Get.put(ImageController());

  @override
  void initState() {
    imageController.vectorPermission =
        Image.asset('assets/images/vectors/vector_permission.png');
    imageController.vectorShadow =
        Image.asset('assets/images/vectors/vector_shadow.png');
    imageController.vectorLoading =
        Image.asset('assets/images/vectors/vector_loading.png');
    imageController.gifNavigation =
        Image.asset('assets/images/arrow_animation.gif');
    imageController.gifDestinationPin =
        Image.asset('assets/images/location_pin.gif');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(imageController.vectorPermission.image, context);
    precacheImage(imageController.vectorShadow.image, context);
    precacheImage(imageController.vectorLoading.image, context);
    precacheImage(imageController.gifNavigation.image, context);
    precacheImage(imageController.gifDestinationPin.image, context);
  }

  @override
  Widget build(BuildContext context) {
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
      home: SplashScreenPage(),
    );
  }
}
