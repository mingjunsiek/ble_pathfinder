import 'package:ble_pathfinder/controllers/map_controller.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:ble_pathfinder/views/calibration_page.dart';
import 'package:ble_pathfinder/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment(0, -0.5),
                  child: Text(
                    'Settings',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: getDefaultProportionateScreenWidth(),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  alignment: Alignment(0, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Compass',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getDefaultProportionateScreenWidth(),
                            ),
                          ),
                          Container(
                            width: displayWidth(context) * 0.4,
                            child: OutlinedButton(
                              child: Text(
                                'Calibrate',
                                style: TextStyle(
                                  fontSize:
                                      getDefaultProportionateScreenWidth(),
                                  color: kTextColor,
                                ),
                              ),
                              onPressed: () {
                                Get.to(CalibrationPage(
                                  caliType: CaliType.setting,
                                ));
                              },
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'View POIs',
                            style: TextStyle(
                              fontSize: getDefaultProportionateScreenWidth(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: displayWidth(context) * 0.4,
                            child: OutlinedButton(
                              child: Text(
                                'View',
                                style: TextStyle(
                                  fontSize:
                                      getDefaultProportionateScreenWidth(),
                                  color: kTextColor,
                                ),
                              ),
                              onPressed: () {
                                mapController.getAllPOIDialog(
                                  context,
                                  MapType.onboard,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              RoundedButton(
                btnColor: kPrimaryColor,
                btnText: 'BACK',
                btnFunction: () {
                  Get.back();
                },
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
