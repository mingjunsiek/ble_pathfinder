import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:ble_pathfinder/views/calibration_page.dart';
import 'package:ble_pathfinder/widgets/rounded_button.dart';
import 'package:ble_pathfinder/widgets/tutorial_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialPage extends StatefulWidget {
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  int currentPage = 0;

  List<Map<String, String>> tutorialData = [
    {},
    {
      'image': 'assets/images/tutorial/tutorial_1.png',
    },
    {
      'image': 'assets/images/tutorial/tutorial_2.png',
    },
    {
      'image': 'assets/images/tutorial/tutorial_3.png',
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
            children: [
              Expanded(
                flex: 4,
                child: PageView.builder(
                  itemCount: tutorialData.length,
                  itemBuilder: (context, index) => TutorialWidget(
                    index: index,
                    image: tutorialData[index]['image'],
                  ),
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      tutorialData.length,
                      (index) => buildDot(index: index),
                    ),
                  ),
                  Spacer(),
                  RoundedButton(
                    btnColor: kPrimaryColor,
                    btnText: 'CONTINUE',
                    btnFunction: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('initial', true);
                      Get.off(CalibrationPage());
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
