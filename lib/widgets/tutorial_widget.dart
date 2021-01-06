import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:flutter/material.dart';

class TutorialWidget extends StatelessWidget {
  const TutorialWidget({
    Key key,
    this.image,
    this.index,
  }) : super(key: key);

  final String image;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tutorial",
              style: TextStyle(
                fontSize: getDefaultProportionateScreenWidth(),
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: displayHeight(context) * 0.02,
            ),
            Text(
              "Hold up there! Before you start navigating, allow me to teach you how to use Pathfinder effectively!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getDefaultProportionateScreenWidth(),
                color: kSecondaryColor,
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              "Tutorial",
              style: TextStyle(
                fontSize: getDefaultProportionateScreenWidth(),
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(flex: 2),
            Image.asset(
              image,
              height: getProportionateScreenHeight(550),
            ),
          ],
        ),
      );
    }
  }
}
