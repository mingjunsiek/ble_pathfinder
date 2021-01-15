import 'package:ble_pathfinder/controllers/image_controller.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DestinationWidget extends StatelessWidget {
  const DestinationWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageController = Get.find<ImageController>();

    return Container(
      alignment: Alignment(0, 0),
      key: UniqueKey(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: imageController.gifDestinationPin.image,
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
