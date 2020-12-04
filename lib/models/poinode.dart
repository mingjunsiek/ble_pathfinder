class POINode {
  int nodeID;
  int level;
  int heuristic;
  int nearestStairs;
  int nextLevelStairs;
  String nodeName;
  String nodeESP32ID;
  var neighbourArray;
  String name;

  POINode(
      {this.nodeID,
      this.level,
      this.nearestStairs,
      this.nextLevelStairs,
      this.nodeName,
      this.nodeESP32ID,
      this.neighbourArray,
      this.name});
}
