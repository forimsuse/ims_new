import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rxdart/rxdart.dart';
import '../logger_service.dart';
import '../config.dart';
import '../beacon_des_model.dart';

class BleProvider {
  static final BleProvider _instance = BleProvider._internal();
  factory BleProvider() {
    return _instance;
  }
  BleProvider._internal();

  static const UUIDSTR_ISSC_TRANS_TX = "00001239";
  static const UUIDSTR_ISSC_TRANS_RX = "00001236";

  BluetoothCharacteristic? c;
  Stream<List<int>>? listStream;
  BluetoothConnectionState? deviceState;
  final Map<String, ScanResult> _scanResultMap = {};
  StreamSubscription? _connectSubscription;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _stateBluetoothSubscription;
  final PublishSubject<DeviceDesc> _deviceDetected =
  PublishSubject<DeviceDesc>();
  Stream<DeviceDesc> get deviceDetectedStream => _deviceDetected.stream;

  final PublishSubject<bool> _scanning = PublishSubject<bool>();
  Stream<bool> get scanningStream => _scanning.stream;

  final BehaviorSubject<String?> _deviceIdConnected =
  BehaviorSubject<String?>();
  Stream<String?> get deviceIdConnectedStream => _deviceIdConnected.stream;

  final BehaviorSubject<bool> _bluePlusState = BehaviorSubject<bool>();
  Stream<bool> get bluePlusStateStream => _bluePlusState.stream;

  void listenStateBluetooth() {
    _stateBluetoothSubscription = FlutterBluePlus.adapterState.listen((event) {
      if (event == BluetoothAdapterState.on) {
        _bluePlusState.sink.add(true);
      } else {
        _bluePlusState.sink.add(false);
        _deviceIdConnected.sink.add(null);
      }
    });
  }

  /// **** Scan and Stop Bluetooth Methods  ***** /////
  Future<String?> fetchDevice() async {
    final Completer<String?> completer = Completer<String?>();
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    _scanning.sink.add(true);
    _scanSubscription = Scan.scan(
        timeout: const Duration(seconds: 5),
        withServices: [Guid(CONFIG.get("ServiceUUID"))])
        .listen((scanResult) async {
      if (scanResult.device.platformName.startsWith("IMS-CR")) {
        LoggerService.log("find device: ${scanResult.device.platformName}");
        _deviceDetected.sink.add(DeviceDesc(
            scanResult.device.remoteId.str, scanResult.device.platformName));
        _scanResultMap.remove(scanResult.device.remoteId.str);
        _scanResultMap[scanResult.device.remoteId.str] = scanResult;
        LoggerService.log("found device");
        !completer.isCompleted ? completer.complete(null) : null;
      }
    })
      ..onError((error) {
        LoggerService.log("\x1B[36mERROR\x1B[0m");
        LoggerService.log(error);
        _deviceDetected.sink.addError(error);
        _scanning.sink.add(false);
        !completer.isCompleted ? completer.complete(error.toString()) : null;
      })
      ..onDone(() {
        _scanning.sink.add(false);
        _scanSubscription?.cancel();
        _scanSubscription = null;
        !completer.isCompleted ? completer.complete("") : null;
      });
    return completer.future;
  }

  Future<void> resumeApp() async {
                /*    HADASA    */
    // if(_deviceIdConnected.valueOrNull != null){
    //   try {
    //     if (_deviceIdConnected.valueOrNull != null) {
    //       connectToMyDevice(deviceId: _deviceIdConnected.valueOrNull!, force: true);
    //     }
    //   } catch (ex) {
    //     LoggerService.log(ex);
    //   }
    // }
  }

  Future<List<DeviceDesc>> fetchConnectedSystemDevices() async {
    try {
      final list = await FlutterBluePlus.connectedSystemDevices;
      return list.map((e) {
        return DeviceDesc(e.remoteId.str, e.platformName);
      }).toList();
    } catch (ex) {
      rethrow;
    }
  }

  fetchConnectedSystemDevices2() async {
    try {
      FlutterBluePlus.connectedSystemDevices.asStream().listen((paired) async {
        print('paired device: $paired');
        for (var device in paired) {
          LoggerService.log(device.platformName);
        }
      });
    } catch (ex) {
      rethrow;
    }
  }

  Future stopScan() => FlutterBluePlus.stopScan();

  Future<String> connectToMyDevice(
      {required String deviceId,
        String? disConnectDeviceId,
        bool force = false}) async {
    final Completer<String> completer = Completer<String>();
    if (_scanResultMap[deviceId] != null) {
      if (deviceId != disConnectDeviceId) {
        await _disConnectPrevDevice(
            deviceId: deviceId, disConnectDeviceId: disConnectDeviceId);
      }
      if (true /*deviceId != disConnectDeviceId || force*/) {
        try {
          final String deviceID = await _connectToDevice(deviceId);
          if (!completer.isCompleted) {
            completer.complete(deviceID);
          }
        } catch (ex) {
          if (!completer.isCompleted) {
            completer.complete(ex.toString());
          }
        }
        if (!completer.isCompleted) {
          _connectSubscription = _scanResultMap[deviceId]!
              .device
              .connectionState
              .listen((BluetoothConnectionState state) async {
            if (state == BluetoothConnectionState.disconnected) {
              LoggerService.log(
                  "state is BluetoothConnectionState.disconnected");
              try {
                final String deviceID = await _connectToDevice(deviceId);
                if (!completer.isCompleted) {
                  completer.complete(deviceID);
                }
              } catch (ex) {
                if (!completer.isCompleted) {
                  completer.complete(ex.toString());
                }
              }
            } else if (state == BluetoothConnectionState.connected) {
              LoggerService.log("connected!");
                    /*    HADASA    */
              // try {
              //   await _discoverServices(_scanResultMap[deviceId]!.device);
              //   _deviceIdConnected.sink.add(deviceId);
              //   if (!completer.isCompleted) {
              //     completer.complete(deviceId);
              //   }
              // } catch (ex,stack) {
              //   LoggerService.log(ex);
              //   LoggerService.log(stack);
              // }
              // if (!completer.isCompleted) {
              //   completer.complete(deviceId);
              // }
            }
          });
        }
      } /*else {
        if (!completer.isCompleted) {
          completer.complete(deviceId);
        }
      }*/
    } else {
      if (!completer.isCompleted) {
        completer.complete("Did not find a device to connect");
      }
    }
    return completer.future;
  }

  _disConnectPrevDevice(
      {required String deviceId, String? disConnectDeviceId}) async {
    _deviceIdConnected.sink.add(null);
    if (_connectSubscription != null) {
      await _connectSubscription?.cancel();
      _connectSubscription = null;
    }
    if (listStream != null) {
      listStream = null;
    }
    try {
      await _scanResultMap[disConnectDeviceId]?.device.disconnect();
    } catch (ex) {
      LoggerService.log("disConnectError: ${ex.toString()}");
    }
  }

  Future<String> _connectToDevice(String deviceId) async {
    _deviceIdConnected.sink.add(null);
    int count = 0;
    bool finish = false;
    const int maxCount = 8;
    while (count < maxCount && !finish) {
      try {
        await _scanResultMap[deviceId]!.device.connect();
        finish = true;
      } catch (ex, stack) {
        count++;
        LoggerService.log("connectToDeviceError: ${ex.toString()}");
        LoggerService.log(stack);
        if (count >= maxCount) {
          _deviceIdConnected.sink.addError(ex);
          rethrow;
        }
      }
    }

    LoggerService.log("finish While try to connect!");
    try {
      await _discoverServices(_scanResultMap[deviceId]!.device);
      _deviceIdConnected.sink.add(deviceId);
      return deviceId;
    } catch (ex, stack) {
      LoggerService.log(ex);
      LoggerService.log(stack);
      _deviceIdConnected.sink.addError(ex);
      rethrow;
    }
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        if (service.uuid == Guid(CONFIG.get("ServiceUUID"))) {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid
                .toString()
                .startsWith(UUIDSTR_ISSC_TRANS_RX)) {
              c = characteristic;
            } else if (characteristic.uuid
                .toString()
                .startsWith(UUIDSTR_ISSC_TRANS_TX)) {
              listStream = characteristic.onValueReceived;
              if(characteristic.isNotifying == false){
                await characteristic
                    .setNotifyValue(true);}
            }
          }
        }
      }
    } catch (ex) {
      rethrow;
    }
  }

  sendTransparentData(List<int> data, {bool required = false}) async {
    try {
      await c?.write(data);
    } catch (ex, stack) {
      if (ex is FlutterBluePlusException) {
        //133 - unknown gatt error
        if ((ex).code == 133) {
          LoggerService.log(data);
        }
      }
      if (ex is PlatformException) {
        //writeCharacteristic
        if ((ex).message == 'device is disconnected') {
          LoggerService.log(data);
        }
      }
      if (required) {
        _deviceIdConnected.sink.addError(ex);
      }
      LoggerService.log("sendTransparentDataError:");
      LoggerService.log(ex);
      LoggerService.log(stack);
    }
  }

  dispose() async {
    if (!_deviceIdConnected.isClosed) {
      _deviceIdConnected.close();
    }
    _scanSubscription?.cancel();
    _scanSubscription = null;
    await _stateBluetoothSubscription?.cancel();
    await _connectSubscription?.cancel();
    _connectSubscription = null;
  }
}
extension Scan on FlutterBluePlus {
  static Stream<ScanResult> scan({
    List<Guid> withServices = const [],
    Duration? timeout,
    bool androidUsesFineLocation = false,
  }) {
    if (FlutterBluePlus.isScanningNow) {
      throw Exception("Another scan is already in progress");
    }

    final controller = StreamController<ScanResult>();

    var subscription = FlutterBluePlus.scanResults.listen(
          (r) => r.isEmpty?(){} :controller.add(r.first),
      onError: (e, stackTrace) => controller.addError(e, stackTrace),
    );

    FlutterBluePlus.startScan(
      //withServices: withServices,
      timeout: timeout,
      removeIfGone: null,
      oneByOne: true,
      androidUsesFineLocation: androidUsesFineLocation,
    );

    Future scanComplete = FlutterBluePlus.isScanning.where((e) => e == false).first;

    scanComplete.whenComplete(() {
      subscription.cancel();
      controller.close();
    });

    return controller.stream;
  }
}