import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'ble_provider.dart';
import 'local_storage.dart';
import 'beacon_des_model.dart';

class ListDevicesRepository {
  final BleProvider _bleProvider = BleProvider();

  final BehaviorSubject<List<DeviceDesc>> _deviceDescList =
  BehaviorSubject<List<DeviceDesc>>();
  Stream<List<DeviceDesc>> get streamDeviceDescList => _deviceDescList.stream;

  Stream<bool> get scanningStream => _bleProvider.scanningStream;

  StreamSubscription? _deviceDetectedSubscription;

  Map<String,String?>? get allDevices => LocalStorage().getMapDevices();


  Future<String?> fetchDevices() => _bleProvider.fetchDevice();

  Future<List<DeviceDesc>> fetchConnectedSystemDevices() => _bleProvider.fetchConnectedSystemDevices();
  fetchConnectedSystemDevices2() => _bleProvider.fetchConnectedSystemDevices2();

  Map<String,String?>? devicesWithoutCommunication;


  clearDevice(){
    devicesWithoutCommunication = allDevices;
    _deviceDescList.sink.add([]);
  }

  listenToDeviceScan(){
    devicesWithoutCommunication ??= (allDevices ?? {});
    _deviceDetectedSubscription = _bleProvider.deviceDetectedStream.listen((event) {
      final listTemp = _deviceDescList.valueOrNull ?? [];
      if(!listTemp.any((element) => element.deviceId == event.deviceId)){
        LocalStorage().saveDeviceID(event.deviceId,event.name);
        listTemp.add(event);
        _deviceDescList.sink.add(listTemp);
      }
      devicesWithoutCommunication!.remove(event.deviceId);
    },onError:(ex){

    });
  }

  dispose(){
    _deviceDetectedSubscription?.cancel();
  }
}
