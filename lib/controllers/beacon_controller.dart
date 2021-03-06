import 'dart:async';
import 'package:ble_pathfinder/models/beacon_data.dart';
import 'package:ble_pathfinder/models/location.dart';
import 'package:ble_pathfinder/models/neighbour_node.dart';
import 'package:ble_pathfinder/models/poinode.dart';
import 'package:ble_pathfinder/utils/constants.dart';
import 'package:get/get.dart';

//BLE Library Imports
import 'package:beacons_plugin/beacons_plugin.dart';

import '../models/poinode.dart';
import 'navigation_controller.dart';

class BeaconController extends GetxController {
  var poiNodes = Map<int, POINode>();
  var poiList = List<POINode>.empty();
  var locationList = List<LocationInfo>.empty();
  final currentLocation = POINode(
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
    y: null,
  ).obs;
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
  final beaconDataPriorityQueue = List<BeaconData>.empty().obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocationInfo();
    fetchPoiNodes();
  }

  @override
  void dispose() {
    print('Disposing Controller');
    super.dispose();
    _timer.cancel();
    beaconEventsController.close();
  }

  // List<POINode> getSelectionList(String currLocation) {
  //   return poiList
  //       .where((element) =>
  //           element.poiType != POIType.intersection &&
  //           element.name != currLocation)
  //       .toList();
  // }

  void setDestination(int nodeID) {
    destinationLocation =
        poiList.firstWhere((element) => element.nodeID == nodeID);
  }

  Future<List<LocationInfo>> onSearch(String filter) async {
    return locationList
        .where((element) =>
            element.nodeID != currentLocation.value.nodeID &&
            element.name.contains(filter))
        .toList();
  }

  void startTimer(int timeSet) {
    const oneSec = const Duration(seconds: 1);
    _timerTime = timeSet;
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_timerTime < 1) {
        timer.cancel();
        _timer = null;
        fetchingBeacons.value = false;
        haveCurrentLocation.value = false;
        print("Not nearby beacon");
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

  Future<void> beaconInitPlatformState() async {
    BeaconsPlugin.setDebugLevel(0);

    BeaconsPlugin.listenToBeacons(beaconEventsController);
    print('listenToBeacons Init');

    for (var node in poiNodes.entries) {
      BeaconsPlugin.addRegion(node.value.nodeName, node.value.nodeESP32ID);
    }
    print('addRegion Init');

    startTimer(5);
    beaconEventsController.stream.listen((data) {
      // print('DATA: $data');
      if (data.isNotEmpty) {
        fetchingBeacons.value = false;

        cancelTimer();
        // print(data);
        BeaconData beaconData = BeaconData.fromJson(data);
        addToListAndSort(beaconData);
      }
    }, onDone: () {
      print("beaconEventsController: onDone");
    }, onError: (error) {
      print("beaconEventsController Error: $error");
    });

    await BeaconsPlugin.startMonitoring;
  }

  Future<void> startMonitoring() async {
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
        if (diff.inSeconds >= 3) return true;
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
    navController.setCurrentLocation(currentLocation.value);
    // navController.beaconList.assignAll(beaconDataPriorityQueue);
    haveCurrentLocation.value = true;
    if (_timer == null) {
      startTimer(5);
    }

    print("Set Current location: " + currentLocation.value.nodeID.toString());
  }

  String get printList {
    var tempString = "";
    beaconDataPriorityQueue.forEach((element) {
      tempString += "${element.name} : ${element.rssi}\n";
    });
    return tempString;
  }

  void fetchLocationInfo() {
    var loc1 = LocationInfo(
      name: 'Hardware Project Lab',
      nodeID: 1,
    );
    var loc2 = LocationInfo(
      name: 'Software Lab 2',
      nodeID: 3,
    );
    var loc3 = LocationInfo(
      name: 'Hardware Lab 2',
      nodeID: 4,
    );
    var loc4 = LocationInfo(
      name: 'Hardware Lab 1',
      nodeID: 6,
    );
    var loc5 = LocationInfo(
      name: 'SCSE Lounge',
      nodeID: 7,
    );
    var loc6 = LocationInfo(
      name: 'Software Lab 1',
      nodeID: 7,
    );
    var loc7 = LocationInfo(
      name: 'Software Lab 3',
      nodeID: 8,
    );
    var loc8 = LocationInfo(
      name: 'Software Project Lab',
      nodeID: 12,
    );
    var loc9 = LocationInfo(
      name: 'Hardware Lab 3',
      nodeID: 14,
    );

    locationList = [
      loc1,
      loc2,
      loc3,
      loc4,
      loc5,
      loc6,
      loc7,
      loc8,
      loc9,
    ];
  }

  void fetchPoiNodes() {
    var node1 = POINode(
      nodeID: 1,
      level: 1,
      nearestLift: 3,
      nodeName: 'POI Node 1',
      nodeESP32ID: '1510eae0-be73-451f-8faf-6b622f92ac5f',
      neighbourArray: [
        NeighbourNode(
          nodeID: 2,
          heading: 270,
          distanceTo: 5,
        ),
      ],
      section: 'C',
      x: 11,
      y: 21,
      name: 'Hardware Project Lab',
      poiType: POIType.poi,
    );

    var node2 = POINode(
      nodeID: 2,
      level: 1,
      nearestLift: 3,
      nodeName: 'POI Node 2',
      nodeESP32ID: '5f0868e1-a25a-4213-8d81-66d2517fa79e',
      neighbourArray: [
        NeighbourNode(
          nodeID: 1,
          heading: 90,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 3,
          heading: 0,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 4,
          heading: 270,
          distanceTo: 5,
        ),
      ],
      name: 'Intersection',
      section: 'B-C',
      x: 11,
      y: 16,
      poiType: POIType.intersection,
    );

    var node3 = POINode(
      nodeID: 3,
      level: 1,
      nearestLift: 3,
      nextLevelLift: 10,
      nodeName: 'POI Node 3',
      nodeESP32ID: '91551886-569b-4993-aa64-1ae9739a46b4',
      neighbourArray: [
        NeighbourNode(
          nodeID: 2,
          heading: 180,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 10,
          levelNavigation: LevelNavigation.go_down,
        ),
      ],
      name: 'Software Lab 2',
      section: 'B-C',
      x: 6,
      y: 16,
      poiType: POIType.poi,
    );

    var node4 = POINode(
      nodeID: 4,
      level: 1,
      nearestLift: 3,
      nodeName: 'POI Node 4',
      nodeESP32ID: '89206b21-ec85-4487-a051-c20819b40833',
      neighbourArray: [
        NeighbourNode(
          nodeID: 2,
          heading: 90,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 5,
          heading: 270,
          distanceTo: 5,
        ),
      ],
      name: 'Hardware Lab 2',
      section: 'B',
      x: 11,
      y: 11,
      poiType: POIType.poi,
    );

    var node5 = POINode(
      nodeID: 5,
      level: 1,
      nearestLift: 6,
      nodeName: 'POI Node 5',
      nodeESP32ID: '9f3442b9-5672-4501-9459-c74d7ce4e5dd',
      neighbourArray: [
        NeighbourNode(
          nodeID: 4,
          heading: 90,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 6,
          heading: 0,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 7,
          heading: 270,
          distanceTo: 5,
        ),
      ],
      name: 'Intersection',
      section: 'A-B',
      x: 11,
      y: 6,
      poiType: POIType.intersection,
    );

    var node6 = POINode(
      nodeID: 6,
      level: 1,
      nearestLift: 6,
      nextLevelLift: 14,
      nodeName: 'POI Node 6',
      nodeESP32ID: '1ba53596-0322-4cac-a3a1-af2135008c2e',
      neighbourArray: [
        NeighbourNode(
          nodeID: 5,
          heading: 180,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 14,
          levelNavigation: LevelNavigation.go_down,
        ),
      ],
      name: 'Hardware Lab 1',
      section: 'A-B',
      x: 6,
      y: 6,
      poiType: POIType.poi,
    );

    var node7 = POINode(
      nodeID: 7,
      level: 1,
      nearestLift: 6,
      nodeName: 'POI Node 7',
      nodeESP32ID: 'cbe5998b-842e-4b48-b3a2-dbd6f1f2c015',
      neighbourArray: [
        NeighbourNode(
          nodeID: 5,
          heading: 90,
          distanceTo: 5,
        ),
      ],
      name: 'SCSE Lounge / Software Lab 1',
      section: 'A',
      x: 11,
      y: 1,
      poiType: POIType.poi,
    );

    var node8 = POINode(
      nodeID: 8,
      level: 0,
      nearestLift: 10,
      nodeName: 'POI Node 8',
      nodeESP32ID: 'ae558d63-13f3-4efb-a78a-c8f279d11f9c',
      neighbourArray: [
        NeighbourNode(
          nodeID: 9,
          heading: 270,
          distanceTo: 5,
        ),
      ],
      name: 'Software Lab 3',
      section: 'C',
      x: 1,
      y: 21,
      poiType: POIType.poi,
    );

    var node9 = POINode(
      nodeID: 9,
      level: 0,
      nearestLift: 10,
      nodeName: 'POI Node 9',
      nodeESP32ID: 'e7b4f5ea-2b25-4ba8-9a6f-ed0786436c80',
      neighbourArray: [
        NeighbourNode(
          nodeID: 8,
          heading: 90,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 10,
          heading: 180,
          distanceTo: 5,
        ),
      ],
      name: 'Intersection',
      section: 'B-C',
      x: 1,
      y: 16,
      poiType: POIType.intersection,
    );

    var node10 = POINode(
      nodeID: 10,
      level: 0,
      nearestLift: 10,
      nextLevelLift: 3,
      nodeName: 'POI Node 10',
      nodeESP32ID: 'f92fb96a-19c0-4a91-9d63-1d77520d63bd',
      neighbourArray: [
        NeighbourNode(
          nodeID: 9,
          heading: 0,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 11,
          heading: 180,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 3,
          levelNavigation: LevelNavigation.go_up,
        ),
      ],
      name: 'Intersection',
      section: 'B-C',
      x: 6,
      y: 16,
      poiType: POIType.intersection,
    );

    var node11 = POINode(
      nodeID: 11,
      level: 0,
      nearestLift: 10,
      nodeName: 'POI Node 11',
      nodeESP32ID: 'b40b5dbb-4a36-4226-b80f-bcd4139c77e3',
      neighbourArray: [
        NeighbourNode(
          nodeID: 10,
          heading: 0,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 12,
          heading: 270,
          distanceTo: 5,
        ),
      ],
      name: 'Intersection',
      section: 'B-C',
      x: 11,
      y: 16,
      poiType: POIType.intersection,
    );

    var node12 = POINode(
      nodeID: 12,
      level: 0,
      nearestLift: 14,
      nodeName: 'POI Node 12',
      nodeESP32ID: '38471efb-f2a4-427b-92db-aa6e5401df0e',
      neighbourArray: [
        NeighbourNode(
          nodeID: 11,
          heading: 90,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 13,
          heading: 270,
          distanceTo: 5,
        ),
      ],
      name: 'Software Project Lab',
      section: 'B',
      x: 11,
      y: 11,
      poiType: POIType.poi,
    );

    var node13 = POINode(
      nodeID: 13,
      level: 0,
      nearestLift: 14,
      nextLevelLift: 6,
      nodeName: 'POI Node 13',
      nodeESP32ID: 'a1005b84-1da4-4e12-8663-7bc3194787b4',
      neighbourArray: [
        NeighbourNode(
          nodeID: 12,
          heading: 90,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 14,
          heading: 0,
          distanceTo: 5,
        ),
      ],
      name: 'Intersection',
      section: 'A-B',
      x: 11,
      y: 6,
      poiType: POIType.intersection,
    );

    var node14 = POINode(
      nodeID: 14,
      level: 0,
      nearestLift: 14,
      nextLevelLift: 6,
      nodeName: 'POI Node 14',
      nodeESP32ID: 'ac39d55e-8d33-49be-9da1-5a960cf66ba9',
      neighbourArray: [
        NeighbourNode(
          nodeID: 13,
          heading: 180,
          distanceTo: 5,
        ),
        NeighbourNode(
          nodeID: 6,
          levelNavigation: LevelNavigation.go_up,
        ),
      ],
      name: 'Hardware Lab 3',
      section: 'A-B',
      x: 6,
      y: 6,
      poiType: POIType.poi,
    );

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
