import 'package:vector_math/vector_math_64.dart' as vector;

import 'package:ble_pathfinder/models/neighbour_node.dart';

class POINode {
  int nodeID;
  int level;
  int heuristic;
  int nearestStairs;
  int nextLevelStairs;
  String nodeName;
  String nodeESP32ID;
  List<NeighbourNode> neighbourArray;
  String name;
  Map<int, vector.Vector3> otherNodesPosition;

  POINode({
    this.nodeID,
    this.level,
    this.heuristic,
    this.nearestStairs,
    this.nextLevelStairs,
    this.nodeName,
    this.nodeESP32ID,
    this.neighbourArray,
    this.name,
    this.otherNodesPosition,
  });
}
