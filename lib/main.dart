import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/views/onboarding_page.dart';
import 'package:ble_pathfinder/views/splash_screen_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/compass_controller.dart';
import 'controllers/image_controller.dart';
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
    // Get.put(BeaconController(), permanent: true);
    Get.put(PermissionController());
    Get.put(CompassController());
    Get.put(NavigationController());
    return this;
  }
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
        Image.asset('assets/images/vectors/vector_permission.gif');
    imageController.vectorShadow =
        Image.asset('assets/images/vectors/vector_shadow.png');
    imageController.vectorLoading =
        Image.asset('assets/images/vectors/vector_loading.gif');
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
      // home: SplashScreenPage(),
      home: OnboardingPage(),
    );
  }
}
