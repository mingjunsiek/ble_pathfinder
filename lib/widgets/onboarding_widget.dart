import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);

  final String text;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            "Pathfinder",
            style: TextStyle(
              fontSize: getDefaultProportionateScreenWidth(),
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Expanded(
            flex: 3,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getDefaultProportionateScreenWidth(),
              ),
            ),
          ),
          Spacer(),
          Image.asset(
            image,
            height: getProportionateScreenHeight(265),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
