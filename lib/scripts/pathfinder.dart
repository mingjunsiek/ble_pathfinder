import 'dart:collection';

import 'package:ble_pathfinder/models/poinode.dart';

void pathfinder() {
  HashMap<int, POINode> nodesHashMap = initializeNodes();
  Comparator<POINode> heuristicComparator =
      (a, b) => a.heuristic.compareTo(b.heuristic);

  List<POINode> poiPriorityQueue = updatePriorityQueue(nodesHashMap);

  var currentNode = nodesHashMap[8];
  var destinationNode = nodesHashMap[1];
  var sameLevel = true;
  var reachedStairs = false;
  var startAtStairs = false;
  var nextLevelDestinationNode;
  var nextLevelStairNode;

  if (currentNode.level != destinationNode.level) {
    sameLevel = false;
    nextLevelDestinationNode = destinationNode;
    destinationNode = nodesHashMap[currentNode.nearestStairs];
  }
  if (currentNode.nodeID == destinationNode.nodeID) {
    startAtStairs = true;
  }
  var visitedArray = [];

  // Initialize heuristic
  for (var i = 1; i <= 14; i++) {
    nodesHashMap[i].heuristic = 10000;
  }

  while (currentNode.nodeID != destinationNode.nodeID || startAtStairs) {
    poiPriorityQueue.removeWhere((item) => item.nodeID == currentNode.nodeID);
    visitedArray.add(currentNode.nodeID);

    if (!sameLevel && startAtStairs) {
      reachedStairs = true;
      startAtStairs = false;
      nextLevelStairNode = nodesHashMap[currentNode.nextLevelStairs];
    } else {
      for (var neighbour in currentNode.neighbourArray) {
        if (!visitedArray.contains(neighbour)) {
          var neighourNode = nodesHashMap[neighbour];
          var currentIndex = poiPriorityQueue
              .indexWhere((item) => item.nodeID == neighourNode.nodeID);

          if (neighourNode.nodeID == destinationNode.nodeID) {
            poiPriorityQueue[currentIndex].heuristic = 0;
            if (!sameLevel) {
              reachedStairs = true;
              nextLevelStairNode = nodesHashMap[neighourNode.nextLevelStairs];
              poiPriorityQueue
                  .removeWhere((item) => item.nodeID == neighourNode.nodeID);
              visitedArray.add(neighourNode.nodeID);
            }
            break;
          } else {
            var nodeHeuristic =
                (destinationNode.nodeID - neighourNode.nodeID).abs();

            poiPriorityQueue[currentIndex].heuristic = nodeHeuristic;
          }
        }
      }
    }
    if (reachedStairs) {
      reachedStairs = false;
      sameLevel = true;
      currentNode = nextLevelStairNode;
      destinationNode = nextLevelDestinationNode;
      for (POINode node in poiPriorityQueue) {
        node.heuristic = 10000;
      }
    } else {
      poiPriorityQueue.sort(heuristicComparator);
      printQueue(poiPriorityQueue);
      currentNode = poiPriorityQueue[0];
    }
  }
  // Reached destination
  visitedArray.add(currentNode.nodeID);

  print('Fastest Path');
  for (var item in visitedArray) {
    print(item);
  }
}

void printQueue(List queue) {
  print('Starting Queue');
  for (POINode t in queue) {
    print(t.nodeID.toString() + ' : ' + t.heuristic.toString());
  }
  print('End Queue');
}

List updatePriorityQueue(HashMap<int, POINode> temp) {
  List<POINode> aList = [];
  temp.forEach((key, value) => aList.add(value));
  return aList;
}

HashMap initializeNodes() {
  var node1 = POINode(
      nodeID: 1,
      level: 1,
      nearestStairs: 3,
      nodeESP32ID: 'xyz',
      neighbourArray: [2],
      nodeLocationArray: ['Hardware Project Lab']);

  var node2 = POINode(
      nodeID: 2,
      level: 1,
      nearestStairs: 3,
      nodeESP32ID: 'xyz',
      neighbourArray: [1, 3, 4],
      nodeLocationArray: ['Intersection']);

  var node3 = POINode(
      nodeID: 3,
      level: 1,
      nearestStairs: 3,
      nextLevelStairs: 10,
      nodeESP32ID: 'xyz',
      neighbourArray: [2],
      nodeLocationArray: ['Software Lab 2']);

  var node4 = POINode(
      nodeID: 4,
      level: 1,
      nearestStairs: 3,
      nodeESP32ID: 'xyz',
      neighbourArray: [2, 5],
      nodeLocationArray: ['Hardware Lab 2']);

  var node5 = POINode(
      nodeID: 5,
      level: 1,
      nearestStairs: 6,
      nodeESP32ID: 'xyz',
      neighbourArray: [4, 6, 7],
      nodeLocationArray: ['Intersection']);

  var node6 = POINode(
      nodeID: 6,
      level: 1,
      nearestStairs: 6,
      nextLevelStairs: 14,
      nodeESP32ID: 'xyz',
      neighbourArray: [5],
      nodeLocationArray: ['Hardware Lab 1']);

  var node7 = POINode(
      nodeID: 7,
      level: 1,
      nearestStairs: 6,
      nodeESP32ID: 'xyz',
      neighbourArray: [5],
      nodeLocationArray: ['SCSE Lounge', 'Software Lab 1']);

  var node8 = POINode(
      nodeID: 8,
      level: 2,
      nearestStairs: 10,
      nodeESP32ID: 'xyz',
      neighbourArray: [9],
      nodeLocationArray: ['Software Lab 3']);

  var node9 = POINode(
      nodeID: 9,
      level: 2,
      nearestStairs: 10,
      nodeESP32ID: 'xyz',
      neighbourArray: [8, 10],
      nodeLocationArray: ['Intersection']);

  var node10 = POINode(
      nodeID: 10,
      level: 2,
      nearestStairs: 10,
      nextLevelStairs: 3,
      nodeESP32ID: 'xyz',
      neighbourArray: [9, 11],
      nodeLocationArray: ['Intersection']);

  var node11 = POINode(
      nodeID: 11,
      level: 2,
      nearestStairs: 10,
      nodeESP32ID: 'xyz',
      neighbourArray: [10, 12],
      nodeLocationArray: ['Intersection']);

  var node12 = POINode(
      nodeID: 12,
      level: 2,
      nearestStairs: 10,
      nodeESP32ID: 'xyz',
      neighbourArray: [11, 13],
      nodeLocationArray: ['Software Projecet Lab']);

  var node13 = POINode(
      nodeID: 13,
      level: 2,
      nearestStairs: 14,
      nextLevelStairs: 6,
      nodeESP32ID: 'xyz',
      neighbourArray: [12, 14],
      nodeLocationArray: ['Intersection']);

  var node14 = POINode(
      nodeID: 14,
      level: 2,
      nearestStairs: 14,
      nextLevelStairs: 6,
      nodeESP32ID: 'xyz',
      neighbourArray: [13],
      nodeLocationArray: ['Hardware Lab 3']);

  HashMap poiHashMap = HashMap<int, POINode>();
  var poiNodeArray = [
    node1,
    node2,
    node3,
    node4,
    node5,
    node6,
    node7,
    node8,
    node9,
    node10,
    node11,
    node12,
    node13,
    node14
  ];
  for (var i = 1; i <= 14; i++) {
    poiHashMap[i] = poiNodeArray[i - 1];
  }
  return poiHashMap;
}
