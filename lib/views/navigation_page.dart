import 'package:ble_pathfinder/controllers/compass_controller.dart';
import 'package:ble_pathfinder/controllers/image_controller.dart';
import 'package:ble_pathfinder/controllers/navigation_controller.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:ble_pathfinder/widgets/navigation_widget.dart';
import 'package:ble_pathfinder/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationPage extends StatelessWidget {
  final navigationController = Get.find<NavigationController>();
  final compassController = Get.find<CompassController>();
  final imageController = Get.find<ImageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  'Current Location: ',
                  style: TextStyle(
                    fontSize: getDefaultProportionateScreenWidth(),
                  ),
                ),
                Obx(
                  () => AnimatedSwitcher(
                    duration: Duration(milliseconds: 2000),
                    transitionBuilder: (widget, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(1.5, 0.0),
                        end: Offset.zero,
                      ).animate(animation);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: widget,
                      );
                    },
                    switchOutCurve: Curves.elasticOut,
                    switchInCurve: Curves.elasticIn,
                    child: Container(
                      height: displayHeight(context) * 0.1,
                      alignment: Alignment(0, 0),
                      key: UniqueKey(),
                      width: displayWidth(context) * 0.6,
                      child: Text(
                        navigationController.currentNode.value.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: getProportionateScreenWidth(25),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Compass Accuracy: ',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(
                          15,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        compassController.accuracy.value,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(15),
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  height: displayHeight(context) * 0.6,
                  alignment: Alignment(0, 0),
                  child: Obx(
                    () => AnimatedSwitcher(
                      duration: Duration(milliseconds: 1000),
                      transitionBuilder: (widget, animation) => ScaleTransition(
                        scale: animation,
                        child: widget,
                      ),
                      switchOutCurve: Curves.easeOutExpo,
                      switchInCurve: Curves.easeInExpo,
                      child: navigationController.levelNavigation.value ==
                              LevelNavigation.go_down
                          ? Container(
                              alignment: Alignment(0, 0),
                              key: UniqueKey(),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/elevator_down.gif',
                                    height: displayHeight(context) * 0.4,
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.02,
                                  ),
                                  Text(
                                    'Go Down One Level',
                                    style: TextStyle(
                                      fontSize:
                                          getDefaultProportionateScreenWidth(),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : navigationController.levelNavigation.value ==
                                  LevelNavigation.go_up
                              ? Container(
                                  alignment: Alignment(0, 0),
                                  key: UniqueKey(),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/elevator_up.gif',
                                        height: displayHeight(context) * 0.4,
                                      ),
                                      SizedBox(
                                        height: displayHeight(context) * 0.02,
                                      ),
                                      Text(
                                        'Go Up One Level',
                                        style: TextStyle(
                                          fontSize:
                                              getDefaultProportionateScreenWidth(),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : navigationController.levelNavigation.value ==
                                      LevelNavigation.same_level
                                  ? Container(
                                      alignment: Alignment(0, 0),
                                      key: UniqueKey(),
                                      child: NavigationWidget(),
                                    )
                                  : navigationController
                                              .levelNavigation.value ==
                                          LevelNavigation.empty
                                      ? Container(
                                          alignment: Alignment(0, 0),
                                          key: UniqueKey(),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Finding Path to Destination',
                                                style: TextStyle(
                                                  fontSize:
                                                      getDefaultProportionateScreenWidth(),
                                                ),
                                              ),
                                              SizedBox(
                                                height: displayHeight(context) *
                                                    0.1,
                                              ),
                                              CircularProgressIndicator(),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          alignment: Alignment(0, 0),
                                          key: UniqueKey(),
                                          child: Image(
                                            image: imageController
                                                .gifDestinationPin.image,
                                          ),
                                        ),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  height: displayHeight(context) * 0.06,
                  width: displayWidth(context) * 0.5,
                  child: Obx(
                    () => AnimatedSwitcher(
                      duration: Duration(milliseconds: 1000),
                      transitionBuilder: (widget, animation) => ScaleTransition(
                        scale: animation,
                        child: widget,
                      ),
                      switchOutCurve: Curves.easeOutExpo,
                      switchInCurve: Curves.easeInExpo,
                      child: navigationController.levelNavigation.value ==
                              LevelNavigation.reach_destination
                          ? RoundedButton(
                              btnColor: Color(0xFF42CF1F),
                              btnText: 'DONE',
                              btnFunction: () {
                                Get.back();
                              })
                          : RoundedButton(
                              btnColor: Color(0xFFCF1F1F),
                              btnText: 'CANCEL',
                              btnFunction: () {
                                Get.back();
                              },
                            ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
