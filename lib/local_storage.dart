import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'charge_event_model.dart';
import 'record_model.dart';
//import 'package:watchdog/modules/models/setting.model.dart';
import 'logger_service.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();
  //Must init
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences? _prefs;

  /*setSetting(String deviceId, SettingModel settingModel) async {
    await _prefs?.setString(
        "setting_$deviceId", json.encode(settingModel.toJson()));
  }

  SettingModel? getSetting(String deviceId) {
    final strData = _prefs?.getString("setting_$deviceId");
    if (strData != null) {
      return SettingModel.fromJson(json.decode(strData));
    }
    return null;
  }*/

  setStartChanging(String deviceId, ChargeEventModel chargeEventModel) async {
    await _prefs?.setString(
        "startChanging_$deviceId", json.encode(chargeEventModel.toJson()));
  }

  ChargeEventModel? getStartChanging(String deviceId) {
    final strData = _prefs?.getString("startChanging_$deviceId");
    if (strData != null) {
      return ChargeEventModel.fromJson(json.decode(strData));
    }
    return null;
  }

  setEndChanging(String? deviceId, ChargeEventModel chargeEventModel) async {
    if (deviceId != null) {
      try {
        await _prefs?.setString(
            "endChanging_$deviceId", json.encode(chargeEventModel.toJson()));
      } catch (ex) {
        LoggerService.log("error setEndChanging: $ex");
      }
    }
  }

  ChargeEventModel? getEndChanging(String deviceId) {
    final strData = _prefs?.getString("endChanging_$deviceId");
    if (strData != null) {
      return ChargeEventModel.fromJson(json.decode(strData));
    }
    return null;
  }

  setRecord(String deviceId, RecordModel recordModel) async {
    await _prefs?.setString(
        "record_$deviceId", json.encode(recordModel.toJson()));
  }

  RecordModel? getRecord(String deviceId) {
    final strData = _prefs?.getString("record_$deviceId");
    if (strData != null) {
      return RecordModel.fromJson(json.decode(strData));
    }
    return null;
  }

  saveDeviceID(String? deviceID, String? name) async {
    if (deviceID != null) {
      final tempMap = getMapDevices() ?? <String,String?>{};
      if (tempMap[deviceID] == null) {
        try {
          tempMap[deviceID] = name;
          await _prefs?.setString("devicesID", json.encode(tempMap));
        } catch (ex) {
          LoggerService.log("error saveDeviceID $deviceID: $ex");
        }
      }
    }
  }

  Map<String, String?>? getMapDevices() {
    try {
      String? encodedMap = _prefs?.getString('devicesID');
      if (encodedMap == null) {
        return null;
      } else {
        Map<String, String?> decodedMap =
        (json.decode(encodedMap) as Map<String,dynamic>).map((key, value) => MapEntry(key, value != null ? value!.toString() : null));
        return decodedMap;
      }
    } catch (ex) {
      LoggerService.log("error getMapDevices: $ex");
      return {};
    }
  }

      /*    HADASA    */

//   // Save an integer value to 'counter' key.
//   await prefs.setInt('counter', 10);
// // Save an boolean value to 'repeat' key.
//   await prefs.setBool('repeat', true);
// // Save an double value to 'decimal' key.
//   await prefs.setDouble('decimal', 1.5);
// // Save an String value to 'action' key.
//   await prefs.setString('action', 'Start');
// // Save an list of strings to 'items' key.
//   await prefs.setStringList('items', <String>['Earth', 'Moon', 'Sun']);

//   // Try reading data from the 'counter' key. If it doesn't exist, returns null.
//   final int? counter = prefs.getInt('counter');
// // Try reading data from the 'repeat' key. If it doesn't exist, returns null.
//   final bool? repeat = prefs.getBool('repeat');
// // Try reading data from the 'decimal' key. If it doesn't exist, returns null.
//   final double? decimal = prefs.getDouble('decimal');
// // Try reading data from the 'action' key. If it doesn't exist, returns null.
//   final String? action = prefs.getString('action');
// // Try reading data from the 'items' key. If it doesn't exist, returns null.
//   final List<String>? items = prefs.getStringList('items');

// await prefs.remove('counter');
}
