import 'dart:convert';

class NeighbourNode {
  int nodeID;
  double direction;
  bool isStartingNode;

  NeighbourNode({
    this.nodeID,
    this.direction = 0.0,
    this.isStartingNode = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'nodeID': nodeID,
      'direction': direction,
      'isStartingNode': isStartingNode,
    };
  }

  factory NeighbourNode.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return NeighbourNode(
      nodeID: map['nodeID'],
      direction: map['direction'],
      isStartingNode: map['isStartingNode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NeighbourNode.fromJson(String source) =>
      NeighbourNode.fromMap(json.decode(source));
}
