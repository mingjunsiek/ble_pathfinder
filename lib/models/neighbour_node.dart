import 'dart:convert';

class NeighbourNode {
  int nodeID;
  double direction;

  NeighbourNode({
    this.nodeID,
    this.direction,
  });

  Map<String, dynamic> toMap() {
    return {
      'nodeID': nodeID,
      'direction': direction,
    };
  }

  factory NeighbourNode.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return NeighbourNode(
      nodeID: map['nodeID'],
      direction: map['direction'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NeighbourNode.fromJson(String source) =>
      NeighbourNode.fromMap(json.decode(source));
}
