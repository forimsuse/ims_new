import 'package:permission_handler/permission_handler.dart';

class PermissionProvider {
  static Future<void> request() async {
    await [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request();
  }

  Future<String?> checkServiceStatusLocation() async {
    final status = await Permission.location.serviceStatus;
    return status == ServiceStatus.disabled
        ? 'To use IMS app, please turn on device location'
        : status == ServiceStatus.notApplicable
        ? 'Current platform does not have location services'
        : null;
  }
}
