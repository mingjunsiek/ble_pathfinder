import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/views/selection_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      // backgroundColor: Theme.of(context).primaryColor,
      splash: './assets/images/splash/ic_splash.png',
      splashTransition: SplashTransition.rotationTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      nextScreen: SelectionPage(),
      duration: 2000,
      splashIconSize: getProportionateScreenWidth(200),
    );
  }
}
