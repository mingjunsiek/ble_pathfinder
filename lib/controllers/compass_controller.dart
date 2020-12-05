import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';

class CompassController extends GetxController {
  final heading = 0.0.obs;
  String get readout => heading.toStringAsFixed(0) + '°';

  @override
  void onInit() {
    super.onInit();
    FlutterCompass.events.listen(_onData);
  }

  void _onData(double x) => heading.value = x;
}
