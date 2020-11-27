import 'dart:collection';
import 'package:ble_pathfinder/models/beacon_data.dart';
import 'package:ble_pathfinder/models/poi.dart';
import 'package:ble_pathfinder/models/poinode.dart';
import 'package:get/state_manager.dart';

//BLE Library Imports
import 'dart:async';
import 'package:beacons_plugin/beacons_plugin.dart';

class SelectionController extends GetxController {
  var poiNodes = HashMap<int, POINode>();
  var poiList = List<POI>();
  var startingPoint;
  var fetchedStartingPoint = false.obs;
  var beaconResult = ''.obs;

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  Comparator<BeaconData> rssiComparator = (a, b) => a.rssi.compareTo(b.rssi);
  List<BeaconData> beaconDataPriorityQueue = [];

  @override
  void dispose() {
    super.dispose();
    beaconEventsController.close();
  }

  Future<void> initializeBeaconScanning() async {
    poiNodes = fetchPoiNodes();
    fetchPoiList();
    await beaconInitPlatformState();
  }

  void fetchPoiList() {
    var lists = [
      POI(poiID: 1, level: 1, name: ' SCSE Lounge', nodeID: 7),
      POI(poiID: 2, level: 1, name: ' Software Lab 1', nodeID: 7),
      POI(poiID: 3, level: 1, name: ' Hardware Lab 1', nodeID: 6),
      POI(poiID: 4, level: 1, name: ' Hardware Lab 2', nodeID: 4),
      POI(poiID: 5, level: 1, name: ' Software Lab 2', nodeID: 3),
      POI(poiID: 6, level: 1, name: ' Hardware Project Lab', nodeID: 1),
      POI(poiID: 7, level: 2, name: ' Software Lab 3', nodeID: 8),
      POI(poiID: 8, level: 2, name: ' Software Project Lab', nodeID: 12),
      POI(poiID: 9, level: 2, name: ' Hardware Lab 3', nodeID: 14),
    ];
    poiList = lists;
  }

  Future<void> beaconInitPlatformState() async {
    BeaconsPlugin.listenToBeacons(beaconEventsController);
    print('listenToBeacons Init');

    for (var node in poiNodes.entries) {
      await BeaconsPlugin.addRegion(
          node.value.nodeName, node.value.nodeESP32ID);
    }
    print('addRegion Init');

    beaconEventsController.stream.listen(
        (data) {
          if (data.isNotEmpty) {
            BeaconData beaconData = BeaconData.fromJson(data);
            addToListAndSort(beaconData);
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        });

    //await BeaconsPlugin.runInBackground(false);
    print('runInBackground Init');
    await BeaconsPlugin.startMonitoring;
  }

  void addToListAndSort(BeaconData beaconData) {
    var beaconIndex = beaconDataPriorityQueue
        .indexWhere((beacon) => beacon.uuid == beaconData.uuid);

    if (beaconIndex == -1)
      beaconDataPriorityQueue.add(beaconData);
    else {
      beaconDataPriorityQueue[beaconIndex] = beaconData;
    }
    beaconDataPriorityQueue.sort(rssiComparator);
    var tempString = '';
    for (var item in beaconDataPriorityQueue) {
      tempString += item.name + " : " + item.rssi + '\n';
    }
    beaconResult.value = tempString;
  }

  void setCurrentLocation() async {
    print('Setting current location');
    print('Beacon init');
    print('Beacon Monitoring');

    startingPoint = poiList[0];
    fetchedStartingPoint.value = true;
    print("Set Current location");
  }

  HashMap<int, POINode> fetchPoiNodes() {
    var node1 = POINode(
        nodeID: 1,
        level: 1,
        nearestStairs: 3,
        nodeName: 'POI Node 1',
        nodeESP32ID: '1510eae0-be73-451f-8faf-6b622f92ac5f',
        neighbourArray: [2],
        nodeLocationArray: ['Hardware Project Lab']);

    var node2 = POINode(
        nodeID: 2,
        level: 1,
        nearestStairs: 3,
        nodeName: 'POI Node 2',
        nodeESP32ID: '5f0868e1-a25a-4213-8d81-66d2517fa79e',
        neighbourArray: [1, 3, 4],
        nodeLocationArray: ['Intersection']);

    var node3 = POINode(
        nodeID: 3,
        level: 1,
        nearestStairs: 3,
        nextLevelStairs: 10,
        nodeName: 'POI Node 3',
        nodeESP32ID: '91551886-569b-4993-aa64-1ae9739a46b4',
        neighbourArray: [2],
        nodeLocationArray: ['Software Lab 2']);

    var node4 = POINode(
        nodeID: 4,
        level: 1,
        nearestStairs: 3,
        nodeName: 'POI Node 4',
        nodeESP32ID: '89206b21-ec85-4487-a051-c20819b40833',
        neighbourArray: [2, 5],
        nodeLocationArray: ['Hardware Lab 2']);

    var node5 = POINode(
        nodeID: 5,
        level: 1,
        nearestStairs: 6,
        nodeName: 'POI Node 5',
        nodeESP32ID: '9f3442b9-5672-4501-9459-c74d7ce4e5dd',
        neighbourArray: [4, 6, 7],
        nodeLocationArray: ['Intersection']);

    var node6 = POINode(
        nodeID: 6,
        level: 1,
        nearestStairs: 6,
        nextLevelStairs: 14,
        nodeName: 'POI Node 6',
        nodeESP32ID: '1ba53596-0322-4cac-a3a1-af2135008c2e',
        neighbourArray: [5],
        nodeLocationArray: ['Hardware Lab 1']);

    var node7 = POINode(
        nodeID: 7,
        level: 1,
        nearestStairs: 6,
        nodeName: 'POI Node 7',
        nodeESP32ID: 'cbe5998b-842e-4b48-b3a2-dbd6f1f2c015',
        neighbourArray: [5],
        nodeLocationArray: ['SCSE Lounge', 'Software Lab 1']);

    var node8 = POINode(
        nodeID: 8,
        level: 2,
        nearestStairs: 10,
        nodeName: 'POI Node 8',
        nodeESP32ID: 'ae558d63-13f3-4efb-a78a-c8f279d11f9c',
        neighbourArray: [9],
        nodeLocationArray: ['Software Lab 3']);

    var node9 = POINode(
        nodeID: 9,
        level: 2,
        nearestStairs: 10,
        nodeName: 'POI Node 9',
        nodeESP32ID: 'e7b4f5ea-2b25-4ba8-9a6f-ed0786436c80',
        neighbourArray: [8, 10],
        nodeLocationArray: ['Intersection']);

    var node10 = POINode(
        nodeID: 10,
        level: 2,
        nearestStairs: 10,
        nextLevelStairs: 3,
        nodeName: 'POI Node 10',
        nodeESP32ID: 'f92fb96a-19c0-4a91-9d63-1d77520d63bd',
        neighbourArray: [9, 11],
        nodeLocationArray: ['Intersection']);

    var node11 = POINode(
        nodeID: 11,
        level: 2,
        nearestStairs: 10,
        nodeName: 'POI Node 11',
        nodeESP32ID: 'b40b5dbb-4a36-4226-b80f-bcd4139c77e3',
        neighbourArray: [10, 12],
        nodeLocationArray: ['Intersection']);

    var node12 = POINode(
        nodeID: 12,
        level: 2,
        nearestStairs: 10,
        nodeName: 'POI Node 12',
        nodeESP32ID: '38471efb-f2a4-427b-92db-aa6e5401df0e',
        neighbourArray: [11, 13],
        nodeLocationArray: ['Software Projecet Lab']);

    var node13 = POINode(
        nodeID: 13,
        level: 2,
        nearestStairs: 14,
        nextLevelStairs: 6,
        nodeName: 'POI Node 13',
        nodeESP32ID: 'a1005b84-1da4-4e12-8663-7bc3194787b4',
        neighbourArray: [12, 14],
        nodeLocationArray: ['Intersection']);

    var node14 = POINode(
        nodeID: 14,
        level: 2,
        nearestStairs: 14,
        nextLevelStairs: 6,
        nodeName: 'POI Node 14',
        nodeESP32ID: 'ac39d55e-8d33-49be-9da1-5a960cf66ba9',
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
}
