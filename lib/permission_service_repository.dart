import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:rxdart/subjects.dart';
import '../ble_provider.dart';
import '../permission_provider.dart';
import '../logger_service.dart';
import '../root_navigation.dart';

enum EnServicePermissionType { location, ble }

class PermissionServiceRepository {
  final BleProvider _bleProvider = BleProvider();
  final PermissionProvider _permissionProvider = PermissionProvider();

  StreamSubscription? _stateBluetoothSubscription;

  final BehaviorSubject<bool> _correctPermissions = BehaviorSubject<bool>();
  Stream<bool> get correctPermissionsStream => _correctPermissions.stream;

  Stream<bool> get bluetoothStream => _bleProvider.bluePlusStateStream;

  final BehaviorSubject<String> _locationStream = BehaviorSubject<String>();
  Stream<String> get locationStream => _locationStream.stream;

  final bool _requiredLocation = false;
  final bool _requiredBluetooth = true;

  bool _enableLocation = false;
  bool _enableBluetooth = false;

  bool? _androidVersionMustLocation;
  listenToState() {
    _bleProvider.listenStateBluetooth();
    _stateBluetoothSubscription =
        _bleProvider.bluePlusStateStream.listen((event) {
          if (event) {
            _enableBluetooth = true;
            checkCorrectPermissions();
          } else {
            RootNavigation.popToFirst();
            _enableBluetooth = false;
            checkCorrectPermissions();
          }
        });
  }

  Stream<String?> get checkStateLocationStream => Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
    return checkStateLocation();
  });

  Future<String?> checkStateLocation() async {
    LoggerService.log("checkStateLocation");
    _androidVersionMustLocation ??= await mustLocationActive();
    if (_androidVersionMustLocation == false) {
      return null;
    }
    final msgError = await _permissionProvider.checkServiceStatusLocation();
    return msgError;
  }

  Future<String?> checkStateLocation1() async {
    _androidVersionMustLocation ??= await mustLocationActive();
    if (_androidVersionMustLocation == false) {
      return null;
    }
    final msgError = await _permissionProvider.checkServiceStatusLocation();
    if (msgError == null && _enableLocation != true) {
      _enableLocation = true;
      checkCorrectPermissions();
    } else
    if(_enableLocation != false){
      _enableLocation = false;
      checkCorrectPermissions();
    }
    return msgError;
  }

  checkCorrectPermissions() {
    if (_requiredLocation) {
      if (!_enableLocation) {
        _correctPermissions.sink.add(false);
        return false;
      }
    }
    if (_requiredBluetooth) {
      if (!_enableBluetooth) {
        _correctPermissions.sink.add(false);
        return false;
      }
    }
    _correctPermissions.sink.add(true);
    return true;
  }

  dispose() {
    _stateBluetoothSubscription?.cancel();
  }

  Future<bool> mustLocationActive() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release.split('.')[0];
      return release == '11' || release == '10';
    }
    return false;
  }
}
