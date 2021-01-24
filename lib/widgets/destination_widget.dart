import 'package:ble_pathfinder/utils/image_constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:flutter/material.dart';

class DestinationWidget extends StatelessWidget {
  const DestinationWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, 0),
      key: UniqueKey(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            gifDestinationPin,
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          Text(
            'Destination Reached',
            style: TextStyle(
              fontSize: getDefaultProportionateScreenWidth(),
            ),
          ),
        ],
      ),
    );
  }
}
