import 'dart:math';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:ble_pathfinder/controllers/compass_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARCoreController extends GetxController {
  ArCoreController arCoreController;

  Widget initArCoreview() {
    return ArCoreView(
      onArCoreViewCreated: _onArCoreViewCreated,
      enableTapRecognizer: true,
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => onTapHandler(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  Future _addSphere(ArCoreHitTestResult hit) async {
    final moonMaterial = ArCoreMaterial(color: Colors.grey);

    final moonShape = ArCoreSphere(
      materials: [moonMaterial],
      radius: 0.03,
    );

    final moon = ArCoreNode(
      shape: moonShape,
      position: vector.Vector3(0.2, 0, 0),
      rotation: vector.Vector4(0, 0, 0, 0),
    );

    final ByteData textureBytes =
        await rootBundle.load('assets/images/ar_images/earth.jpg');

    final earthMaterial = ArCoreMaterial(
        color: Color.fromARGB(120, 66, 134, 244),
        textureBytes: textureBytes.buffer.asUint8List());

    final earthShape = ArCoreSphere(
      materials: [earthMaterial],
      radius: 0.1,
    );

    final earth = ArCoreNode(
        shape: earthShape,
        children: [moon],
        position: hit.pose.translation + vector.Vector3(0.0, 1.0, 0.0),
        rotation: hit.pose.rotation);

    arCoreController.addArCoreNodeWithAnchor(earth);
  }

  void addArrow(ArCoreHitTestResult hit) {
    final compassController = Get.find<CompassController>();
    final v3 = hit.pose.translation + vector.Vector3(0.0, 0, 0.5);
    final arrow = ArCoreReferenceNode(
        name: 'blue_arrow.sfb',
        object3DFileName: 'blue_arrow.sfb',
        position: v3,
        rotation: vector.Vector4(
          v3.x,
          v3.y,
          v3.z, 180 * (pi / 180),
          // ((360 - 180) + compassController.heading.value),
        ));
    arCoreController.addArCoreNodeWithAnchor(arrow);
  }

  void addArrowWithPosition(vector.Vector3 modelPos) {
    final compassController = Get.find<CompassController>();
    print("AR DEBUG: " + arCoreController.trackingState);
    final arrow = ArCoreReferenceNode(
      name: 'blue_arrow.sfb',
      object3DFileName: 'blue_arrow.sfb',
      position: modelPos,
      rotation: vector.Vector4(
        modelPos.x, modelPos.y, modelPos.z,
        // modelHeading * (pi / 180),
        ((360 - 180) + compassController.heading.value),
      ),
    );

    arCoreController.addArCoreNode(arrow);
  }

  void addDestinationPin() {
    final arrow = ArCoreReferenceNode(
      name: 'location_pin.sfb',
      object3DFileName: 'location_pin.sfb',
      position: vector.Vector3(0, 0, -5),
    );
    arCoreController.addArCoreNode(arrow);
  }

  void addDestinationPinWithPosition(vector.Vector3 modelPos) {
    final arrow = ArCoreReferenceNode(
      name: 'location_pin.sfb',
      object3DFileName: 'location_pin.sfb',
      position: modelPos,
    );
    arCoreController.addArCoreNode(arrow);
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    addArrow(hit);
    // _addSphere(hit);
    // _addArrow(hit);
  }

  void onTapHandler(String name) {
    print("Flutter: onNodeTap");
    Get.defaultDialog(
      content: Text('onNodeTap on $name'),
    );
  }

  void _addSphere2() {
    final material = ArCoreMaterial(color: Color.fromARGB(120, 66, 134, 244));
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(0, 0, -1.5),
    );
    arCoreController.addArCoreNode(node);
  }

  void _addCylindre() {
    final material = ArCoreMaterial(
      color: Colors.red,
      reflectance: 1.0,
    );
    final cylindre = ArCoreCylinder(
      materials: [material],
      radius: 0.5,
      height: 0.3,
    );
    final node = ArCoreNode(
      shape: cylindre,
      position: vector.Vector3(0.0, -0.5, -2.0),
    );
    arCoreController.addArCoreNode(node);
  }

  void _addCube() {
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(-0.5, 0.5, -3.5),
    );
    arCoreController.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
