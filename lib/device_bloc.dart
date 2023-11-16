import '../charge_event_model.dart';
import '../record_model.dart';
//import '../setting.model.dart';
import '../tag_model.dart';
import '../device_repository.dart';

class DeviceBloc{

  final DeviceRepository _deviceRepository = DeviceRepository();


  Stream<ChargeEventModel?> get chargeEventModelStream => _deviceRepository.chargeEventModelStream;

  Stream<RecordModel> get recordModelStream => _deviceRepository.recordModelStream;

  Stream<EnErrorTypeTemp> get errorTypeTempStream => _deviceRepository.errorTypeTempStream;

  //Stream<SettingModel?> get settingStream => _deviceRepository.settingStream;

  Stream<String?> get deviceIdConnectedStream => _deviceRepository.deviceIdConnectedStream;

  Stream<EnStatusScan?> get statusScanStream => _deviceRepository.statusScanStream;

  startListenToDeviceConnect() => _deviceRepository.startListenToDeviceConnect();

  Future<String?> connectToDevice(String newDeviceId, {bool force = false}) => _deviceRepository.connectToDevice(newDeviceId,force: force);

  ///commands
  Future<void> idle() => _deviceRepository.idle();

  Future<void> continuousSample() => _deviceRepository.continuousSample();

  Future<void> stop() => _deviceRepository.stop();

  Future<void> getSettings() => _deviceRepository.getSettings();

  Future<String?> setSettings(bool isHealth)  => _deviceRepository.setSettings(isHealth);

  Future<void> getRecord()  => _deviceRepository.getRecord();

  Future<void> getRTC()  => _deviceRepository.getRTC();

  Future<void> updateRTC(DateTime dateTime)  => _deviceRepository.updateRTC(dateTime);

  Future<void> resumeApp() => _deviceRepository.resumeApp();

  RecordModel? get getLocalRecord => _deviceRepository.getLocalRecord;

  //SettingModel? get getLocalSetting => _deviceRepository.getLocalSetting;

  ChargeEventModel? get getLocalEndChanging => _deviceRepository.getLocalEndChanging;

  Future<void> startDFU()  => _deviceRepository.startDFU();

  TagModel? get getTagData => _deviceRepository.tagData;


  dispose() {
    _deviceRepository.dispose();
  }


}