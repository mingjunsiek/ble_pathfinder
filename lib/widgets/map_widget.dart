import 'package:ble_pathfinder/utils/constants.dart';
import 'package:ble_pathfinder/utils/image_constants.dart';
import 'package:ble_pathfinder/utils/size_helpers.dart';
import 'package:flutter/material.dart';

class MapWidget extends StatefulWidget {
  MapWidget({Key key, this.mapType}) : super(key: key);

  final MapType mapType;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: displayHeight(context) * 0.4,
      width: displayWidth(context) * 0.7,
      child: InteractiveViewer(
        minScale: 0.2,
        maxScale: 100.2,
        child: Image.asset(
          gifNodeAll,
        ),
      ),
    );
  }
}
