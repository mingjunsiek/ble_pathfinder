import 'dart:convert';

import 'package:vector_math/vector_math_64.dart' as vector;

class NeighbourNode {
  int nodeID;
  double heading;
  bool isStartingNode;
  vector.Vector3 modelPosition;

  NeighbourNode({
    this.nodeID,
    this.heading,
    this.isStartingNode = false,
    this.modelPosition,
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
