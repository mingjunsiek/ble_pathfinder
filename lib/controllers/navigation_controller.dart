import 'package:ble_pathfinder/models/poinode.dart';
import 'dart:collection';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  HashMap<int, POINode> nodesHashMap;
  List<POINode> poiPriorityQueue;
  Comparator<POINode> heuristicComparator =
      (a, b) => a.heuristic.compareTo(b.heuristic);

  int startingNodeId, destinationNodeId;
  final currentNodeId = 0.obs;

  var visitedArray = [].obs;

  void setNavigationSettings(
    HashMap<int, POINode> hashMap,
    List<POINode> priorityQueue,
    int currentId,
    int destinationId,
  ) {
    nodesHashMap = hashMap;
    poiPriorityQueue = List.from(priorityQueue);
    startingNodeId = currentId;
    destinationNodeId = destinationId;
    // findPathToDestination();
  }

  Future<void> findPathToDestination() {
    var currentNode = nodesHashMap[startingNodeId];
    var destinationNode = nodesHashMap[destinationNodeId];
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
        //printQueue(poiPriorityQueue);
        currentNode = poiPriorityQueue[0];
      }
    }
    // Reached destination
    visitedArray.add(currentNode.nodeID);
    return null;
  }

  void printQueue(List queue) {
    print('Starting Queue');
    for (POINode t in queue) {
      print(t.nodeID.toString() + ' : ' + t.heuristic.toString());
    }
    print('End Queue');
  }
}
