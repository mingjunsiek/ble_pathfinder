import 'dart:convert';

import 'package:ble_pathfinder/utils/constants.dart';

class NeighbourNode {
  int nodeID;
  double heading;
  bool isStartingNode;
  LevelNavigation levelNavigation;

  NeighbourNode({
    this.nodeID,
    this.heading,
    this.isStartingNode = false,
    this.levelNavigation = LevelNavigation.same_level,
  });

  Map<String, dynamic> toMap() {
    return {
      'nodeID': nodeID,
      'heading': heading,
      'isStartingNode': isStartingNode,
    };
  }

  factory NeighbourNode.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return NeighbourNode(
      nodeID: map['nodeID'],
      heading: map['heading'],
      isStartingNode: map['isStartingNode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NeighbourNode.fromJson(String source) =>
      NeighbourNode.fromMap(json.decode(source));
}
