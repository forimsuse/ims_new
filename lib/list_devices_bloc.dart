import 'dart:async';
import 'beacon_des_model.dart';
import 'list_devices_repository.dart';

class ListDevicesBloc {

  final ListDevicesRepository _listDevicesRepository = ListDevicesRepository();

  Stream<List<DeviceDesc>> get streamDeviceDescList => _listDevicesRepository.streamDeviceDescList;

  Future<String?> fetchDevices() => _listDevicesRepository.fetchDevices();
  clearDevices() => _listDevicesRepository.clearDevice();

  startToListenToDevicesScan() => _listDevicesRepository.listenToDeviceScan();

  Map<String,String?>? get allDevices => _listDevicesRepository.allDevices;

  Map<String,String?>? get devicesWithoutCommunication => _listDevicesRepository.devicesWithoutCommunication;

  dispose(){
    _listDevicesRepository.dispose();
  }
}
