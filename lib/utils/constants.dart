import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF3D3A61);
const kTextColor = Color(0xFF3D3A61);

const kAnimationDuration = Duration(milliseconds: 200);

enum LevelNavigation {
  same_level,
  go_up,
  go_down,
  empty,
  reach_destination,
}

enum POIType {
  poi,
  intersection,
  lift,
  entrance,
}

enum MapType {
  onboard,
  node1,
  node2,
  node3,
  node4,
  node5,
  node6,
  node7,
  node8,
  node9,
  node10,
  node11,
  node12,
  node13,
  node14,
}
