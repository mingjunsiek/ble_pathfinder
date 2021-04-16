#include "sys/time.h"
#include "BLEDevice.h"
#include "BLEUtils.h"
#include "BLEServer.h"
#include "BLEBeacon.h"
#include "esp_sleep.h"

#define GPIO_DEEP_SLEEP_DURATION     10  // sleep x seconds and then wake up
RTC_DATA_ATTR static time_t last;        // remember last boot in RTC Memory
RTC_DATA_ATTR static uint32_t bootcount; // remember number of boots in RTC Memory

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/
BLEAdvertising *pAdvertising;   // BLE Advertisement type
struct timeval now;

#define BEACON_UUID "1510eae0-be73-451f-8faf-6b622f92ac5f" // Node 1
//#define BEACON_UUID "5f0868e1-a25a-4213-8d81-66d2517fa79e" // Node 2
//#define BEACON_UUID "91551886-569b-4993-aa64-1ae9739a46b4" // Node 3
//#define BEACON_UUID "89206b21-ec85-4487-a051-c20819b40833" // Node 4
//#define BEACON_UUID "9f3442b9-5672-4501-9459-c74d7ce4e5dd" // Node 5
//#define BEACON_UUID "1ba53596-0322-4cac-a3a1-af2135008c2e" // Node 6
//#define BEACON_UUID "cbe5998b-842e-4b48-b3a2-dbd6f1f2c015" // Node 7
//#define BEACON_UUID "ae558d63-13f3-4efb-a78a-c8f279d11f9c" // Node 8
//#define BEACON_UUID "e7b4f5ea-2b25-4ba8-9a6f-ed0786436c80" // Node 9
//#define BEACON_UUID "f92fb96a-19c0-4a91-9d63-1d77520d63bd" // Node 10
//#define BEACON_UUID "b40b5dbb-4a36-4226-b80f-bcd4139c77e3" // Node 11
//#define BEACON_UUID "38471efb-f2a4-427b-92db-aa6e5401df0e" // Node 12
//#define BEACON_UUID "a1005b84-1da4-4e12-8663-7bc3194787b4" // Node 13
//#define BEACON_UUID "ac39d55e-8d33-49be-9da1-5a960cf66ba9" / / Node 14

void setBeacon() {

//  BLEBeacon oBeacon = BLEBeacon();
//  oBeacon.setManufacturerId(0x4C00); // fake Apple 0x004C LSB (ENDIAN_CHANGE_U16!)
//  oBeacon.setProximityUUID(BLEUUID(BEACON_UUID));

// Reverse UUID
BLEBeacon oBeacon = BLEBeacon();
oBeacon.setManufacturerId(0x4C00);
BLEUUID bleUUID = BLEUUID(BEACON_UUID) ;
bleUUID = bleUUID.to128();
oBeacon.setProximityUUID(BLEUUID( bleUUID.getNative()->uuid.uuid128, 16, true ));
  
oBeacon.setMajor((bootcount & 0xFFFF0000) >> 16);
oBeacon.setMinor(bootcount & 0xFFFF);
BLEAdvertisementData oAdvertisementData = BLEAdvertisementData();
BLEAdvertisementData oScanResponseData = BLEAdvertisementData();

oAdvertisementData.setFlags(0x1A); // BR_EDR_NOT_SUPPORTED 0x04

std::string strServiceData = "";

strServiceData += (char)26;     // Len
strServiceData += (char)0xFF;   // Type
strServiceData += oBeacon.getData();
oAdvertisementData.addData(strServiceData);

pAdvertising->setAdvertisementData(oAdvertisementData);
pAdvertising->setScanResponseData(oScanResponseData);
}

void setup() {

  Serial.begin(115200);
  gettimeofday(&now, NULL);
  Serial.printf("start ESP32 %d\n", bootcount++);
  Serial.printf("deep sleep (%lds since last reset, %lds since last boot)\n", now.tv_sec, now.tv_sec - last);
  last = now.tv_sec;

  // Create the BLE Device
  BLEDevice::init("POI Node 1");
  // Create the BLE Server
  // BLEServer *pServer = BLEDevice::createServer(); // <-- no longer required to instantiate BLEServer, less flash and ram usage
  pAdvertising = BLEDevice::getAdvertising();
  BLEDevice::startAdvertising();
  setBeacon();
  // Start advertising
  pAdvertising->start();
  Serial.println("Advertizing started...");
  delay(100);
  pAdvertising->stop();
  Serial.printf("enter deep sleep\n");
  // void esp_deep_sleep(uint64_t time_in_us), time_in_us: deep-sleep time, unit: microsecond, 1000000 microsec = 1 sec
  esp_deep_sleep(1000000LL);
  Serial.printf("in deep sleep\n");
}

void loop() {
}
