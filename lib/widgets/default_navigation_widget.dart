import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:flutter/material.dart';

class DefaultNavigationWidget extends StatelessWidget {
  const DefaultNavigationWidget({
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
          Text(
            'Finding Path to Destination',
            style: TextStyle(
              fontSize: getDefaultProportionateScreenWidth(),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.1,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
