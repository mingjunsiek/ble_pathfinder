import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';
import 'package:ble_pathfinder/utils/constants.dart';

class CompassController extends GetxController {
  final heading = 0.0.obs;
  final accuracy = 'Unknown'.obs;
  double currentBearingSnapshot;
  double locationBearingSnapshot;
  String get readout => heading.toStringAsFixed(0) + '°';

  @override
  void onInit() {
    super.onInit();
    FlutterCompass.events.listen(_onData);
  }

  void _onData(CompassEvent compassEvent) {
    print(compassEvent);
    heading.value = compassEvent.heading;

    if (compassEvent.accuracy == 15.0)
      accuracy.value = 'High';
    else if (compassEvent.accuracy == 30.0)
      accuracy.value = 'Medium';
    else if (compassEvent.accuracy == 45.0)
      accuracy.value = 'Low';
    else
      accuracy.value = 'Unknown';
  }
}
