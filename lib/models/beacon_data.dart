import 'dart:convert';

class BeaconData {
  String name;
  String uuid;
  String macAddress;
  String major;
  String minor;
  String distance;
  String proximity;
  String scanTime;
  String rssi;
  String txPower;
  DateTime dateTime;

  BeaconData({
    this.name,
    this.uuid,
    this.macAddress,
    this.major,
    this.minor,
    this.distance,
    this.proximity,
    this.scanTime,
    this.rssi,
    this.txPower,
    this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uuid': uuid,
      'macAddress': macAddress,
      'major': major,
      'minor': minor,
      'distance': distance,
      'proximity': proximity,
      'scanTime': scanTime,
      'rssi': rssi,
      'txPower': txPower,
      'dateTime': dateTime?.millisecondsSinceEpoch,
    };
  }

  factory BeaconData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return BeaconData(
      name: map['name'],
      uuid: map['uuid'],
      macAddress: map['macAddress'],
      major: map['major'],
      minor: map['minor'],
      distance: map['distance'],
      proximity: map['proximity'],
      scanTime: map['scanTime'],
      rssi: map['rssi'],
      txPower: map['txPower'],
      dateTime: DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory BeaconData.fromJson(String source) =>
      BeaconData.fromMap(json.decode(source));
}
