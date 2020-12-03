import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:ble_pathfinder/controllers/permission_controller.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/views/navigation_page.dart';
import 'package:ble_pathfinder/views/permission_page.dart';
import 'package:flutter/services.dart';
import 'package:ble_pathfinder/views/selection_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Mulish",
        textTheme: TextTheme(
          bodyText1: TextStyle(color: kTextColor),
          bodyText2: TextStyle(color: kTextColor),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: AnimatedSplashScreen(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   splash: './assets/images/ic_splash.png',
      //   splashTransition: SplashTransition.rotationTransition,
      //   pageTransitionType: PageTransitionType.leftToRightWithFade,
      //   nextScreen: SelectionPage(),
      // ),
      home:
          // NavigationPage(),
          Obx(() => permissionController.locationPermissionGranted.value ==
                      false ||
                  permissionController.bluetoothStatus.value == false ||
                  permissionController.cameraPermissionGranted.value == false
              ? PermissionPage()
              : SelectionPage()),
    );
  }
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final beaconController = Get.put(BeaconController());

//   @override
//   void initState() {
//     super.initState();
//     beaconController.beaconInitPlatformState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primaryColor: Color(0xFF1976d2),
//         primaryColorLight: Color(0xFF63a4ff),
//         primaryColorDark: Color(0x004ba0),
//         accentColor: Color(0xFF0077d1),
//         backgroundColor: Color(0xFF1976d2),
//         // scaffoldBackgroundColor: Color(0xFF1976d2),
//       ),
//       // home: AnimatedSplashScreen(
//       //   backgroundColor: Theme.of(context).primaryColor,
//       //   splash: './assets/images/ic_splash.png',
//       //   splashTransition: SplashTransition.rotationTransition,
//       //   pageTransitionType: PageTransitionType.leftToRightWithFade,
//       //   nextScreen: SelectionPage(),
//       // ),
//       home: Obx(
//         () => permissionController.permissionGranted.value == false
//             ? Scaffold(
//                 body: Center(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 20,
//                       ),
//                       child: Column(
//                         children: [
//                           Text(
//                               "Please turn on Bluetooth and allow Location Permission to continue using this app"),
//                           RaisedButton.icon(
//                             icon: const Icon(Icons.settings),
//                             label: Text("Settings"),
//                             onPressed: () async {
//                               openAppSettings();
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             : SelectionPage(),
//       ),
//     );
//   }
// }
