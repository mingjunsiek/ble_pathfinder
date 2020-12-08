import 'dart:collection';
import 'dart:async';
import 'package:ble_pathfinder/models/beacon_data.dart';
import 'package:ble_pathfinder/models/neighbour_node.dart';
import 'package:ble_pathfinder/models/poinode.dart';
import 'package:get/get.dart';

//BLE Library Imports
import 'package:beacons_plugin/beacons_plugin.dart';

import '../models/poinode.dart';
import 'navigation_controller.dart';

class BeaconController extends GetxController {
  var poiNodes = HashMap<int, POINode>();
  var poiList = List<POINode>();
  final currentLocation = POINode().obs;
  var fetchingBeacons = true.obs;
  var haveCurrentLocation = false.obs;
  var beaconResult = ''.obs;
  int beaconRssiCutoff = 80;
  Timer _timer;
  int _timerTime;

  POINode destinationLocation;

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  Comparator<BeaconData> rssiComparator = (a, b) => a.rssi.compareTo(b.rssi);
  List<BeaconData> beaconDataPriorityQueue = [];

  @override
  void onInit() {
    super.onInit();
    fetchPoiNodes();
  }

  @override
  void dispose() {
    print('Disposing Controller');
    super.dispose();
    _timer.cancel();
    beaconEventsController.close();
  }

  List<POINode> getSelectionList(String currLocation) {
    return poiList
        .where((element) =>
            element.name != 'Intersection' && element.name != currLocation)
        .toList();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timerTime = 5;
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_timerTime < 1) {
        timer.cancel();
        fetchingBeacons.value = false;
      } else {
        _timerTime = _timerTime - 1;
      }
    });
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void resetScanner() {
    fetchingBeacons.value = true;
    startTimer();
  }

  Future<void> beaconInitPlatformState() async {
    BeaconsPlugin.listenToBeacons(beaconEventsController);
    print('listenToBeacons Init');

    for (var node in poiNodes.entries) {
      await BeaconsPlugin.addRegion(
          node.value.nodeName, node.value.nodeESP32ID);
    }
    print('addRegion Init');

    startTimer();
    beaconEventsController.stream.listen((data) {
      if (data.isNotEmpty) {
        fetchingBeacons.value = false;

        cancelTimer();
        // print(data);
        BeaconData beaconData = BeaconData.fromJson(data);
        addToListAndSort(beaconData);
      } else {
        if (_timer == null) {
          startTimer();
        }
        print("Not nearby beacon");
      }
    }, onDone: () {
      print("beaconEventsController: onDone");
    }, onError: (error) {
      print("beaconEventsController Error: $error");
    });
  }

  void startMonitoring() async {
    await BeaconsPlugin.startMonitoring;
  }

  void addToListAndSort(BeaconData beaconData) {
    var beaconIndexInList =
        poiList.indexWhere((beacon) => beacon.nodeESP32ID == beaconData.uuid);

    if (beaconIndexInList != -1) {
      print("Index: $beaconIndexInList");
      var beaconIndexInQueue = beaconDataPriorityQueue
          .indexWhere((beacon) => beacon.uuid == beaconData.uuid);

      if (beaconIndexInQueue == -1)
        beaconDataPriorityQueue.add(beaconData);
      else {
        beaconDataPriorityQueue[beaconIndexInQueue] = beaconData;
      }

      beaconDataPriorityQueue.removeWhere((item) {
        var diff = DateTime.now().difference(item.dateTime);
        if (diff.inSeconds >= 1) return true;
        return false;
      });

      beaconDataPriorityQueue.sort(rssiComparator);
      var tempString = '';
      for (var item in beaconDataPriorityQueue) {
        tempString += item.name + " : " + item.rssi + '\n';
      }
      beaconResult.value = tempString;
      print(tempString);
      if (int.parse(beaconDataPriorityQueue.first.rssi) < beaconRssiCutoff)
        setCurrentLocation(beaconDataPriorityQueue.first.uuid);
    }
  }

  void setCurrentLocation(String uuid) {
    final navController = Get.find<NavigationController>();
    currentLocation.value =
        poiList.firstWhere((element) => element.nodeESP32ID == uuid);
    navController.setCurrentLocation(currentLocation.value.nodeID);
    haveCurrentLocation.value = true;
    print("Set Current location: " + currentLocation.value.nodeID.toString());
  }

  void fetchPoiNodes() {
    var node1 = POINode(
        nodeID: 1,
        level: 1,
        nearestStairs: 3,
        nodeName: 'POI Node 1',
        nodeESP32ID: '1510eae0-be73-451f-8faf-6b622f92ac5f',
        neighbourArray: [
          NeighbourNode(
            nodeID: 2,
            direction: 270,
          ),
        ],
        name: 'Hardware Project Lab');

    var node2 = POINode(
        nodeID: 2,
        level: 1,
        nearestStairs: 3,
        nodeName: 'POI Node 2',
        nodeESP32ID: '5f0868e1-a25a-4213-8d81-66d2517fa79e',
        neighbourArray: [
          NeighbourNode(
            nodeID: 1,
            direction: 90,
          ),
          NeighbourNode(
            nodeID: 3,
            direction: 0,
          ),
          NeighbourNode(
            nodeID: 4,
            direction: 270,
          ),
        ],
        name: 'Intersection');

    var node3 = POINode(
        nodeID: 3,
        level: 1,
        nearestStairs: 3,
        nextLevelStairs: 10,
        nodeName: 'POI Node 3',
        nodeESP32ID: '91551886-569b-4993-aa64-1ae9739a46b4',
        neighbourArray: [
          NeighbourNode(
            nodeID: 2,
            direction: 180,
          ),
        ],
        name: 'Software Lab 2');

    var node4 = POINode(
        nodeID: 4,
        level: 1,
        nearestStairs: 3,
        nodeName: 'POI Node 4',
        nodeESP32ID: '89206b21-ec85-4487-a051-c20819b40833',
        neighbourArray: [
          NeighbourNode(
            nodeID: 2,
            direction: 90,
          ),
          NeighbourNode(
            nodeID: 5,
            direction: 270,
          ),
        ],
        name: 'Hardware Lab 2');

    var node5 = POINode(
        nodeID: 5,
        level: 1,
        nearestStairs: 6,
        nodeName: 'POI Node 5',
        nodeESP32ID: '9f3442b9-5672-4501-9459-c74d7ce4e5dd',
        neighbourArray: [
          NeighbourNode(
            nodeID: 4,
            direction: 90,
          ),
          NeighbourNode(
            nodeID: 6,
            direction: 0,
          ),
          NeighbourNode(
            nodeID: 7,
            direction: 270,
          ),
        ],
        name: 'Intersection');

    var node6 = POINode(
        nodeID: 6,
        level: 1,
        nearestStairs: 6,
        nextLevelStairs: 14,
        nodeName: 'POI Node 6',
        nodeESP32ID: '1ba53596-0322-4cac-a3a1-af2135008c2e',
        neighbourArray: [
          NeighbourNode(
            nodeID: 5,
            direction: 180,
          ),
        ],
        name: 'Hardware Lab 1');

    var node7 = POINode(
        nodeID: 7,
        level: 1,
        nearestStairs: 6,
        nodeName: 'POI Node 7',
        nodeESP32ID: 'cbe5998b-842e-4b48-b3a2-dbd6f1f2c015',
        neighbourArray: [
          NeighbourNode(
            nodeID: 5,
            direction: 90,
          ),
        ],
        name: 'SCSE Lounge / Software Lab 1');

    var node8 = POINode(
        nodeID: 8,
        level: 2,
        nearestStairs: 10,
        nodeName: 'POI Node 8',
        nodeESP32ID: 'ae558d63-13f3-4efb-a78a-c8f279d11f9c',
        neighbourArray: [
          NeighbourNode(
            nodeID: 9,
            direction: 270,
          ),
        ],
        name: 'Software Lab 3');

    var node9 = POINode(
        nodeID: 9,
        level: 2,
        nearestStairs: 10,
        nodeName: 'POI Node 9',
        nodeESP32ID: 'e7b4f5ea-2b25-4ba8-9a6f-ed0786436c80',
        neighbourArray: [
          NeighbourNode(
            nodeID: 8,
            direction: 90,
          ),
          NeighbourNode(
            nodeID: 10,
            direction: 180,
          ),
        ],
        name: 'Intersection');

    var node10 = POINode(
        nodeID: 10,
        level: 2,
        nearestStairs: 10,
        nextLevelStairs: 3,
        nodeName: 'POI Node 10',
        nodeESP32ID: 'f92fb96a-19c0-4a91-9d63-1d77520d63bd',
        neighbourArray: [
          NeighbourNode(
            nodeID: 9,
            direction: 0,
          ),
          NeighbourNode(
            nodeID: 11,
            direction: 180,
          ),
        ],
        name: 'Intersection');

    var node11 = POINode(
        nodeID: 11,
        level: 2,
        nearestStairs: 10,
        nodeName: 'POI Node 11',
        nodeESP32ID: 'b40b5dbb-4a36-4226-b80f-bcd4139c77e3',
        neighbourArray: [
          NeighbourNode(
            nodeID: 10,
            direction: 0,
          ),
          NeighbourNode(
            nodeID: 12,
            direction: 270,
          ),
        ],
        name: 'Intersection');

    var node12 = POINode(
        nodeID: 12,
        level: 2,
        nearestStairs: 10,
        nodeName: 'POI Node 12',
        nodeESP32ID: '38471efb-f2a4-427b-92db-aa6e5401df0e',
        neighbourArray: [
          NeighbourNode(
            nodeID: 11,
            direction: 90,
          ),
          NeighbourNode(
            nodeID: 13,
            direction: 270,
          ),
        ],
        name: 'Software Project Lab');

    var node13 = POINode(
        nodeID: 13,
        level: 2,
        nearestStairs: 14,
        nextLevelStairs: 6,
        nodeName: 'POI Node 13',
        nodeESP32ID: 'a1005b84-1da4-4e12-8663-7bc3194787b4',
        neighbourArray: [
          NeighbourNode(
            nodeID: 12,
            direction: 90,
          ),
          NeighbourNode(
            nodeID: 14,
            direction: 0,
          ),
        ],
        name: 'Intersection');

    var node14 = POINode(
        nodeID: 14,
        level: 2,
        nearestStairs: 14,
        nextLevelStairs: 6,
        nodeName: 'POI Node 14',
        nodeESP32ID: 'ac39d55e-8d33-49be-9da1-5a960cf66ba9',
        neighbourArray: [
          NeighbourNode(
            nodeID: 13,
            direction: 180,
          ),
        ],
        name: 'Hardware Lab 3');

    poiList = [
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
      poiNodes[i] = poiList[i - 1];
    }
  }
}
