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
  });
}
