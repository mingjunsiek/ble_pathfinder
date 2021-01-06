import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';
import 'package:ble_pathfinder/utils/constants.dart';

class CompassController extends GetxController {
  final heading = 0.0.obs;
  final accuracy = CompassAccuracy.unknown.obs;
  double currentBearingSnapshot;
  double locationBearingSnapshot;
  String get readout => heading.toStringAsFixed(0) + '°';

  @override
  void onInit() {
    super.onInit();
    FlutterCompass.events.listen(_onData);
  }

  void _onData(CompassEvent compassEvent) {
    heading.value = compassEvent.heading;

    if (compassEvent.heading == 15)
      accuracy.value = CompassAccuracy.high;
    else if (compassEvent.heading == 30)
      accuracy.value = CompassAccuracy.medium;
    else if (compassEvent.heading == 45)
      accuracy.value = CompassAccuracy.low;
    else
      accuracy.value = CompassAccuracy.unknown;
  }
}
