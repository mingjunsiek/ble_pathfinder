import 'package:ble_pathfinder/controllers/ar_core_controller.dart';
import 'package:ble_pathfinder/models/beacon_data.dart';
import 'package:ble_pathfinder/models/neighbour_node.dart';
import 'package:ble_pathfinder/models/poinode.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:collection';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  HashMap<int, POINode> nodesHashMap;
  List<POINode> poiPriorityQueue;
  Comparator<POINode> heuristicComparator =
      (a, b) => a.heuristic.compareTo(b.heuristic);

  int startingNodeId, destinationNodeId;
  final currentNode = POINode().obs;

  final visitedArray = <NeighbourNode>[].obs;
  final directionDegree = 0.0.obs;
  final reachedDestination = false.obs;
  final beaconList = <BeaconData>[].obs;
  bool isNavigating = false;
  final levelNavigation = LevelNavigation.empty.obs;

  void setNavigationSettings(
    HashMap<int, POINode> hashMap,
    List<POINode> priorityQueue,
    int currentId,
    int destinationId,
  ) {
    visitedArray.clear();
    reachedDestination.value = false;
    nodesHashMap = HashMap.from(hashMap);
    poiPriorityQueue = List.from(priorityQueue);
    startingNodeId = currentId;
    destinationNodeId = destinationId;
  }

  String get printList {
    var tempString = "";
    visitedArray.forEach((element) {
      tempString += "${element.nodeID} : ${element.heading}\n";
    });
    return tempString;

    // var tempString = "";
    // beaconList.forEach((element) {
    //   tempString += "${element.name} : ${element.rssi}\n";
    // });
    // return tempString;
  }

  String get directionString {
    return 'Walk towards ${directionDegree.value}';
  }

  void setCurrentLocation(POINode node) {
    currentNode.value = node;
    if (isNavigating) {
      // final arController = Get.find<ARCoreController>();
      if (visitedArray.isNotEmpty) {
        print('List Length: ${visitedArray.length}');
        if (visitedArray.first.nodeID == node.nodeID) {
          if (visitedArray.length != 1) {
            visitedArray.removeAt(0);

            switch (visitedArray.first.levelNavigation) {
              case LevelNavigation.go_down:
                levelNavigation.value = LevelNavigation.go_down;
                break;
              case LevelNavigation.go_up:
                levelNavigation.value = LevelNavigation.go_up;
                break;
              default:
                levelNavigation.value = LevelNavigation.same_level;
                break;
            }

            directionDegree.value = visitedArray.first.heading;

            // arController.addArrowWithPosition(
            //   vector.Vector3(0, 0, -1),
            //   visitedArray.first.heading,
            // );
          } else {
            print("Reached Destination");
            // arController.addDestinationPin();
            reachedDestination.value = true;
          }
        }
      }
    }
  }

  Future<void> findPathToDestination() {
    var currentNode = nodesHashMap[startingNodeId];
    var destinationNode = nodesHashMap[destinationNodeId];
    var sameLevel = true;
    var reachedStairs = false;
    var startAtStairs = false;
    var nextLevelDestinationNode;
    POINode nextLevelStairNode;

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

    visitedArray.add(NeighbourNode(
      nodeID: currentNode.nodeID,
      isStartingNode: true,
    ));

    while (currentNode.nodeID != destinationNode.nodeID || startAtStairs) {
      poiPriorityQueue.removeWhere((item) => item.nodeID == currentNode.nodeID);
      // visitedArray.add(currentNode.nodeID);

      if (!sameLevel && startAtStairs) {
        reachedStairs = true;
        startAtStairs = false;
        nextLevelStairNode = nodesHashMap[currentNode.nextLevelStairs];
      } else {
        for (NeighbourNode neighbour in currentNode.neighbourArray) {
          var index = visitedArray
              .indexWhere((element) => element.nodeID == neighbour.nodeID);
          if (index == -1) {
            var neighourNode = nodesHashMap[neighbour.nodeID];
            var currentIndex = poiPriorityQueue
                .indexWhere((item) => item.nodeID == neighourNode.nodeID);

            if (neighourNode.nodeID == destinationNode.nodeID) {
              poiPriorityQueue[currentIndex].heuristic = 0;
              if (!sameLevel) {
                reachedStairs = true;
                nextLevelStairNode = nodesHashMap[neighourNode.nextLevelStairs];
                poiPriorityQueue
                    .removeWhere((item) => item.nodeID == neighourNode.nodeID);
                visitedArray.add(neighbour);
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
        LevelNavigation tempLevel = LevelNavigation.same_level;
        if (currentNode.nodeID >= 8)
          tempLevel = LevelNavigation.go_down;
        else
          tempLevel = LevelNavigation.go_up;

        visitedArray.add(NeighbourNode(
          nodeID: currentNode.nodeID,
          levelNavigation: tempLevel,
        ));

        destinationNode = nextLevelDestinationNode;
        for (POINode node in poiPriorityQueue) {
          node.heuristic = 10000;
        }
      } else {
        poiPriorityQueue.sort(heuristicComparator);
        var neighbourNode = currentNode.neighbourArray.firstWhere(
            (element) => element.nodeID == poiPriorityQueue[0].nodeID);
        visitedArray.add(neighbourNode);
        //printQueue(poiPriorityQueue);
        currentNode = poiPriorityQueue[0];
      }
    }
    // Reached destination
    // visitedArray.add(currentNode.nodeID);
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
