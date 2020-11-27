import 'package:ble_pathfinder/views/selection_page.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplash(
        imagePath: 'assets/splashicon.png',
        customFunction: () {},
        home: SelectionPage(),
        type: AnimatedSplashType.BackgroundProcess,
      ),
    );
  }
}
