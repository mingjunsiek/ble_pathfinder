import 'package:flutter/material.dart';

import 'package:ble_pathfinder/models/neighbour_node.dart';

import '../utils/constants.dart';

class POINode {
  int nodeID;
  int level;
  String section;
  double heuristic;
  double distanceTo;
  double fValue;
  int from;
  int nearestLift;
  int nextLevelLift;
  String nodeName;
  String nodeESP32ID;
  List<NeighbourNode> neighbourArray;
  String name;
  POIType poiType;
  double x;
  double y;

  POINode({
    @required this.nodeID,
    @required this.level,
    @required this.section,
    this.heuristic = 0,
    this.distanceTo = 0,
    this.fValue = 0,
    this.from,
    @required this.nearestLift,
    this.nextLevelLift = 0,
    @required this.nodeName,
    @required this.nodeESP32ID,
    @required this.neighbourArray,
    @required this.name,
    @required this.poiType,
    @required this.x,
    @required this.y,
  });

  @override
  String toString() {
    return '{ Node ID: ${this.nodeID}, fValue: ${this.fValue}, heuristic: ${this.heuristic}, from: ${this.from}, nArray: $neighbourArray}';
  }
}
