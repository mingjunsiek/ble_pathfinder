import 'package:ble_pathfinder/utils/constants.dart';

class NeighbourNode {
  int nodeID;
  double heading;
  bool isStartingNode;
  LevelNavigation levelNavigation;
  double distanceTo;

  NeighbourNode({
    this.nodeID,
    this.heading = 0,
    this.isStartingNode = false,
    this.levelNavigation = LevelNavigation.same_level,
    this.distanceTo = 0,
  });

  @override
  String toString() {
    return '{ ${this.nodeID}, ${this.levelNavigation} }';
  }
}
