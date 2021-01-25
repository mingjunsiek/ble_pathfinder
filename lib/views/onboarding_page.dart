import 'package:ble_pathfinder/controllers/beacon_controller.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/image_constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:ble_pathfinder/views/tutorial_page.dart';
import 'package:ble_pathfinder/widgets/map_widget.dart';
import 'package:ble_pathfinder/widgets/onboarding_widget.dart';
import 'package:ble_pathfinder/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentPage = 0;
  bool lastPage = false;
  final beaconController = Get.find<BeaconController>();

  List<Map<String, String>> onboardingData = [
    {
      'text': 'Welcome to Pathfinder, a new way to navigate indoors!',
      'image': 'assets/images/onboarding/onboarding_1.png',
    },
    {
      'text': 'We are able to navigate indoors with the power of beacons!',
      'image': 'assets/images/onboarding/onboarding_2.png',
    },
    {
      'text':
          'Beacons are placed in key Points of Interests. Being near them helps us find you!',
      'image': 'assets/images/onboarding/onboarding_3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child: PageView.builder(
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) => OnboardingWidget(
                    text: onboardingData[index]['text'],
                    image: onboardingData[index]['image'],
                  ),
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                      if (value == onboardingData.length - 1)
                        lastPage = true;
                      else
                        lastPage = false;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => buildDot(index: index),
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Spacer(),
                  if (lastPage)
                    RoundedButton(
                      btnColor: Color(0xFFBD8570),
                      btnText: 'VIEW POINT OF INTERESTS',
                      btnFunction: () {
                        Get.defaultDialog(
                            title: 'Point of Interests',
                            titleStyle:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          getDefaultProportionateScreenWidth(),
                                    ),
                            content: MapWidget(
                              mapType: MapType.onboard,
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Pinch to Zoom',
                                    style: TextStyle(
                                      fontSize:
                                          getDefaultProportionateScreenWidth(),
                                    ),
                                  ),
                                  Image.asset(
                                    gifMapPinch,
                                    width: displayWidth(context) * 0.1,
                                  ),
                                ],
                              ),
                            ]);
                      },
                    ),
                  SizedBox(
                    height: displayHeight(context) * 0.02,
                  ),
                  RoundedButton(
                    btnColor: kPrimaryColor,
                    btnText: 'CONTINUE',
                    btnFunction: () {
                      Get.to(TutorialPage());
                    },
                  ),
                  Spacer(),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
