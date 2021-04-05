import 'dart:math';

import 'package:ble_pathfinder/models/neighbour_node.dart';
import 'package:ble_pathfinder/models/poinode.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  Map<int, POINode> nodesHashMap;
  List<POINode> poiPriorityQueue = [];
  List<POINode> expandedNodes = [];
  Comparator<POINode> heuristicComparator =
      (a, b) => a.fValue.compareTo(b.fValue);

  int startingNodeId, destinationNodeId;
  List<NeighbourNode> pathArray = <NeighbourNode>[];
  final directionDegree = 0.0.obs;
  final reachedDestination = false.obs;
  final pathArrayLength = 'Loading...'.obs;
  // final beaconController = Get.find<BeaconController>();
  // final beaconList = <BeaconData>[].obs;
  bool isNavigating = false;
  var tempDistanceTo = 0.0;
  final levelNavigation = LevelNavigation.empty.obs;
  final currentNode = POINode(
          level: null,
          name: '',
          nearestLift: null,
          neighbourArray: [],
          nodeESP32ID: '',
          nodeID: null,
          nodeName: '',
          poiType: null,
          section: '',
          x: null,
          y: null)
      .obs;
  void setNavigationSettings(
    Map<int, POINode> hashMap,
    List<POINode> priorityQueue,
    int currentId,
    int destinationId,
  ) {
    print("Setting Navigation Settings");
    reachedDestination.value = false;
    nodesHashMap = {...hashMap};
    poiPriorityQueue = [...priorityQueue];
    startingNodeId = currentId;
    destinationNodeId = destinationId;
  }

  void printList() {
    print("Current Node: ${currentNode.value.nodeID}");
    var tempString = "";
    pathArray.forEach((element) {
      tempString +=
          "${element.nodeID} : ${element.heading} : ${element.levelNavigation} \n";
    });
    print(tempString);
    return null;
  }

  String get directionString {
    return 'Walk towards ${directionDegree.value}';
  }

  void setCurrentLocation(POINode node) {
    currentNode.value = node;
    if (isNavigating) {
      if (pathArray.isNotEmpty) {
        print('List Length: ${pathArray.length}');
        print(pathArray.toString());
        if (pathArray.first.nodeID == node.nodeID) {
          if (pathArray.length != 1) {
            pathArray.removeAt(0);
            switch (pathArray.first.levelNavigation) {
              case LevelNavigation.go_down:
                levelNavigation.value = LevelNavigation.go_down;
                break;
              case LevelNavigation.go_up:
                levelNavigation.value = LevelNavigation.go_up;
                break;
              default:
                if (levelNavigation.value != LevelNavigation.same_level)
                  levelNavigation.value = LevelNavigation.same_level;
                break;
            }

            directionDegree.value = pathArray.first.heading;
          } else {
            pathArray.removeAt(0);
            isNavigating = false;
            print("Reached Destination");
            reachedDestination.value = true;
            levelNavigation.value = LevelNavigation.reach_destination;
          }
        }

        pathArrayLength.value = pathArray.length.toString();
      }
    }
  }

  double getHeuristic(double x1, double x2, double y1, double y2) {
    return sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2));
  }

  Future<void> findPathToDestination() {
    for (var i = 1; i <= poiPriorityQueue.length; i++) {
      nodesHashMap[i].fValue = 9999999;
      nodesHashMap[i].heuristic = 9999999;
      nodesHashMap[i].from = null;
      nodesHashMap[i].distanceTo = 0;

      poiPriorityQueue[i - 1].fValue = 9999999;
      poiPriorityQueue[i - 1].heuristic = 9999999;
      poiPriorityQueue[i - 1].from = null;
      poiPriorityQueue[i - 1].distanceTo = 0;
    }

    var currentNode = nodesHashMap[startingNodeId];
    var destinationNode = nodesHashMap[destinationNodeId];
    var sameLevel = true;
    var reachedLift = false;
    var nextLevelDestinationNode;

    if (currentNode.level != destinationNode.level) {
      sameLevel = false;
      nextLevelDestinationNode = destinationNode;
      destinationNode = nodesHashMap[currentNode.nearestLift];
    }
    if (currentNode.nodeID == destinationNode.nodeID) {
      reachedLift = true;
    }

    pathArray.clear();
    expandedNodes.clear();
    int count = 0;
    while (currentNode.nodeID != destinationNode.nodeID || reachedLift) {
      print("Counting: ${count++}");
      if (!sameLevel && reachedLift) {
        reachedLift = false;
        sameLevel = true;
        destinationNode = nextLevelDestinationNode;

        POINode neighbourPOI = poiPriorityQueue.firstWhere(
            (element) => element.nodeID == currentNode.nextLevelLift);
        neighbourPOI.from = currentNode.nodeID;

        expandedNodes.add(poiPriorityQueue
            .firstWhere((element) => element.nodeID == currentNode.nodeID));
        poiPriorityQueue
            .removeWhere((element) => element.nodeID == currentNode.nodeID);
        currentNode = poiPriorityQueue
            .firstWhere((element) => element.nodeID == neighbourPOI.nodeID);
      } else {
        print('Neighbour Array: ${currentNode.neighbourArray}');
        for (NeighbourNode neighbour in currentNode.neighbourArray) {
          var index = expandedNodes
              .indexWhere((element) => element.nodeID == neighbour.nodeID);
          if (index == -1) {
            POINode neighbourPOI = poiPriorityQueue
                .firstWhere((element) => element.nodeID == neighbour.nodeID);

            neighbourPOI.heuristic = getHeuristic(destinationNode.x,
                neighbourPOI.x, destinationNode.y, neighbourPOI.y);

            tempDistanceTo = currentNode.distanceTo + neighbour.distanceTo;
            if (neighbourPOI.distanceTo > tempDistanceTo ||
                neighbourPOI.distanceTo == 0) {
              neighbourPOI.distanceTo = tempDistanceTo;
              neighbourPOI.from = currentNode.nodeID;
            }

            neighbourPOI.fValue =
                neighbourPOI.distanceTo + neighbourPOI.heuristic;
          }
        }
        expandedNodes.add(poiPriorityQueue
            .firstWhere((element) => element.nodeID == currentNode.nodeID));
        poiPriorityQueue
            .removeWhere((element) => element.nodeID == currentNode.nodeID);
        poiPriorityQueue.sort(heuristicComparator);
        print('Queue: ${poiPriorityQueue.toString()}');
        currentNode = poiPriorityQueue.first;
        if (currentNode.nodeID == currentNode.nearestLift && !sameLevel)
          reachedLift = true;
      }
    }
    //Reached Destination, Add to expandedNodes
    expandedNodes.add(poiPriorityQueue
        .firstWhere((element) => element.nodeID == destinationNodeId));
    var retraceNode = expandedNodes
        .firstWhere((element) => element.nodeID == destinationNodeId);

    while (retraceNode.nodeID != startingNodeId) {
      var neighbourNode = nodesHashMap[retraceNode.from]
          .neighbourArray
          .firstWhere((element) => element.nodeID == retraceNode.nodeID);
      pathArray.add(neighbourNode);
      retraceNode = nodesHashMap[retraceNode.from];
    }

    pathArray.add(NeighbourNode(nodeID: startingNodeId));

    pathArray = pathArray.reversed.toList();
    print('Path: ${pathArray.toString()}');

    return null;
  }
}
