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
