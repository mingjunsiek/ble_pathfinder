import 'package:ble_pathfinder/views/selection_page.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';
import 'package:get/get.dart';

import 'controllers/selection_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final selectionController = Get.put(BeaconController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplash(
        imagePath: './assets/splashicon.png',
        customFunction: () {
          selectionController.initializeBeaconScanning();
          return 1;
        },
        duration: 1000,
        home: SelectionPage(),
        type: AnimatedSplashType.BackgroundProcess,
        outputAndHome: {
          1: SelectionPage(),
        },
      ),
    );
  }
}
