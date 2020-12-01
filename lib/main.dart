import 'package:ble_pathfinder/controllers/permission_controller.dart';
import 'package:flutter/services.dart';
import 'package:ble_pathfinder/views/selection_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final permissionController = Get.put(PermissionController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF1976d2),
        primaryColorLight: Color(0xFF63a4ff),
        primaryColorDark: Color(0x004ba0),
        accentColor: Color(0xFF0077d1),
        backgroundColor: Color(0xFF1976d2),
        // scaffoldBackgroundColor: Color(0xFF1976d2),
      ),
      // home: AnimatedSplashScreen(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   splash: './assets/images/ic_splash.png',
      //   splashTransition: SplashTransition.rotationTransition,
      //   pageTransitionType: PageTransitionType.leftToRightWithFade,
      //   nextScreen: SelectionPage(),
      // ),
      home: Obx(
        () => permissionController.permissionGranted.value == false ||
                permissionController.bluetoothStatus.value == false
            ? Scaffold(
                body: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          Text(
                              "Please ensure the following are enabled or turned on:"),
                          if (permissionController.permissionGranted.value ==
                              false)
                            Text("Allow Location Permission"),
                          if (permissionController.bluetoothStatus.value ==
                              false)
                            Text("Turn on Bluetooth"),
                          RaisedButton.icon(
                            icon: const Icon(Icons.settings),
                            label: Text("Settings"),
                            onPressed: () async {
                              openAppSettings();
                            },
                          ),
                          RaisedButton.icon(
                            icon: const Icon(Icons.done),
                            label: Text("Completed"),
                            onPressed: () async {
                              permissionController.checkPermissionStatus();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : SelectionPage(),
      ),
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
