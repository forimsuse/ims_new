import 'dart:async';
import 'dart:typed_data';
import 'package:rxdart/subjects.dart';
import 'list_commands.dart';
import 'record_model.dart';
//import 'package:watchdog/modules/models/setting.model.dart';
import 'tag_model.dart';
import 'ble_provider.dart';
import 'bytes_utils.dart';
import 'local_storage.dart';
import 'logger_service.dart';
import 'charge_event_model.dart';
import 'command_model.dart';

enum EnStatusScan { requestingData, waiting, monitor, error, dfuTarg }

class DeviceRepository {
  final BleProvider _bleProvider = BleProvider();

  String? _deviceId;

  StreamSubscription? _listStreamSubscription;
  StreamSubscription? _deviceIdConnectedStreamSubscription;

  final BehaviorSubject<ChargeEventModel?> _chargeEventModel =
  BehaviorSubject<ChargeEventModel?>();
  Stream<ChargeEventModel?> get chargeEventModelStream =>
      _chargeEventModel.stream;

  final BehaviorSubject<RecordModel> _recordModel =
  BehaviorSubject<RecordModel>();
  Stream<RecordModel> get recordModelStream => _recordModel.stream;

  final BehaviorSubject<EnErrorTypeTemp> _errorTypeTemp =
  BehaviorSubject<EnErrorTypeTemp>();
  Stream<EnErrorTypeTemp> get errorTypeTempStream => _errorTypeTemp.stream;

  /*final BehaviorSubject<SettingModel?> _setting =
  BehaviorSubject<SettingModel?>();
  Stream<SettingModel?> get settingStream => _setting.stream;*/

  final BehaviorSubject<EnStatusScan?> _statusScan =
  BehaviorSubject<EnStatusScan?>();
  Stream<EnStatusScan?> get statusScanStream => _statusScan.stream;

  Stream<String?> get deviceIdConnectedStream =>
      _bleProvider.deviceIdConnectedStream;

  RecordModel _lastRecordModel = RecordModel();
  final LocalStorage _localStorage = LocalStorage();

  RecordModel? get getLocalRecord =>
      _deviceId != null ? _localStorage.getRecord(_deviceId!) : null;

  /*SettingModel? get getLocalSetting =>
      _deviceId != null ? _localStorage.getSetting(_deviceId!) : null;*/

  ChargeEventModel? get getLocalEndChanging =>
      _deviceId != null ? _localStorage.getEndChanging(_deviceId!) : null;

  final List<CommandModel> _listCommands = [];
  CommandModel? _continuousSample;

  TagModel? get tagData => _tagData;

  int? tagId;

  TagModel? _tagData;

  bool _sendCommand = false;

  startListenToDeviceConnect() {
    _deviceIdConnectedStreamSubscription =
        _bleProvider.deviceIdConnectedStream.listen((event) async {
          if (event == null) {
            _deviceId = null;
            _tagData = null;
            _chargeEventModel.sink.add(null);
            await cancelOnEvent();
          } else {
            await _startEvents(required: true);
          }
        });
  }

  Future<void> _startEvents({bool required = false}) async {
    _listCommands.clear();
    await cancelOnEvent();
    await onEvent();
    await getSettings(required: required);
    // await getRecord();
    getId();
    continuousSample();
  }

  Future<String?> connectToDevice(String newDeviceId,
      {bool force = false}) async {
    tagId = null;
    String? msg = await _bleProvider.connectToMyDevice(
        deviceId: newDeviceId, disConnectDeviceId: _deviceId, force: force);
    if (_deviceId == msg) {
      //// same device;
      try {
        // getSettings(required: true);
        // getRecord();
        // continuousSample();
        _deviceId = newDeviceId;
        return null;
      } catch (ex) {
        msg = ex.toString();
      }
    } else if (msg == newDeviceId) {
      _deviceId = newDeviceId;
      return null;
    }
    return msg;
  }

  onEvent() async {
    _statusScan.sink.add(EnStatusScan.waiting);
    _listStreamSubscription = _bleProvider.listStream?.listen((event) {
      if (event.length == 20) {
        _parseEventData(event);
      }
    });
  }

  Future<void> checkIfContinuousSample(int? packetNumber) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    // LoggerService.log("_sendCommand is $_sendCommand, now: ${_chargeEventModel.valueOrNull!.packetNumber} before: $packetNumber");
    if (_chargeEventModel.valueOrNull?.packetNumber != null &&
        packetNumber != null &&
        _chargeEventModel.valueOrNull!.packetNumber! <= packetNumber) {
      if (_sendCommand) {
        _statusScan.sink.add(EnStatusScan.requestingData);
      } else {
        _statusScan.sink.add(EnStatusScan.error);
        _chargeEventModel.sink.add(null);
      }
    } else {
      _statusScan.sink.add(EnStatusScan.monitor);
    }
  }

  cancelOnEvent() async {
    if (_listStreamSubscription != null) {
      await _listStreamSubscription?.cancel();
      _listStreamSubscription = null;
    }
  }

  _parseEventData(List<int> event) {
    final BytesUtil bytesUtil = BytesUtil(list: event);
    switchCommand(_getHeader(bytesUtil), bytesUtil);
  }

  String _getHeader(BytesUtil bytesUtil) {
    final header =
        '0x${(bytesUtil.getFrom16bitBig(0).toRadixString(16).padLeft(4, '0')).toUpperCase()}';
    return header;
  }

  switchCommand(String header, BytesUtil bytesUtil) {
    LoggerService.log(bytesUtil.bytes);
    EnCommand? currentCommandResponse;

    if (header == EnCommand.idle.header) {
      currentCommandResponse = EnCommand.idle;
    } else if (header == EnCommand.continuousSample.header) {
      currentCommandResponse = EnCommand.continuousSample;
      final ChargeEventModel chargeEventModel =
      ChargeEventModel.fromBytesUtil(bytesUtil);
      _chargeEventModel.sink.add(chargeEventModel);

      _localStorage.setEndChanging(_deviceId, chargeEventModel);
      checkIfContinuousSample(chargeEventModel.packetNumber).then((value) {
        if (chargeEventModel.packetNumber == 0 && _listCommands.isEmpty) {
          _sendCommand = false;
        }
      });
    } /*else if (header == EnCommand.continuousSample2.header) {
      final SettingModel settingModel =
      SettingModel.fromContinuousSample(bytesUtil.bytes[5], tagId);
      updateSetting(settingModel);
      _errorTypeTemp.sink.add(EnErrorTypeTemp.values[bytesUtil.getFrom8bit(4)]);
    }*/ else if (header == EnCommand.updateRTC.header) {
      currentCommandResponse = EnCommand.updateRTC;
    } else if (header == EnCommand.getID.header) {
      _tagData = TagModel.fromBytesUtil(bytesUtil);
      currentCommandResponse = EnCommand.getID;
    } else if (header == EnCommand.stop.header) {
      currentCommandResponse = EnCommand.stop;
    } else if (header == EnCommand.getRTC.header) {
      currentCommandResponse = EnCommand.getRTC;
      // LoggerService.log("RTC.");
      var _ = DateTime.fromMillisecondsSinceEpoch(
          bytesUtil.getFrom32bit(2) * 1000,
          isUtc: true);
    } /*else if (header == EnCommand.setSettings.header) {
      currentCommandResponse = EnCommand.setSettings;
    }*/ else if (header == EnCommand.getSettings.header) {
      ///Get settings
      currentCommandResponse = EnCommand.getSettings;
      // LoggerService.log("Get settings.");
      /*final SettingModel settingModel = SettingModel.fromBytesUtil(bytesUtil);
      updateSetting(settingModel);*/
    } else if (header == EnCommand.deleteRecord.header) {
      currentCommandResponse = EnCommand.deleteRecord;
    } else if (header == EnCommand.startDFU.header) {
      _statusScan.sink.add(EnStatusScan.dfuTarg);
      currentCommandResponse = EnCommand.startDFU;
    } else if (header == EnCommand.hardReset.header) {
      currentCommandResponse = EnCommand.hardReset;
    } else if (header == EnCommand.selfTest.header) {
      currentCommandResponse = EnCommand.selfTest;
    } else if (header == EnCommand.getRecord.header) {
      ///Get Record
      // LoggerService.log("Record.");
      if (bytesUtil.getFrom16bit(2) == 0) {
        _lastRecordModel = RecordModel();
        _lastRecordModel.setFirstPacket(bytesUtil);
      } else if (bytesUtil.getFrom16bit(2) == 1) {
        _lastRecordModel.setSecondPacket(bytesUtil);
      } else if (bytesUtil.getFrom16bit(2) == 2) {
        _lastRecordModel.setThirdPacket(bytesUtil);
        _recordModel.sink.add(_lastRecordModel);
        if (_deviceId != null) {
          _localStorage.setRecord(_deviceId!, _lastRecordModel);
        }
        currentCommandResponse = EnCommand.getRecord;
      }
    } else if (header == EnCommand.nack.header) {
      // LoggerService.log("ACK.");
      currentCommandResponse = EnCommand.nack;
    } else if (header == EnCommand.ack.header) {
      // LoggerService.log("ASK ?. "); ///Stop.
      currentCommandResponse = EnCommand.ack;
      if (bytesUtil.bytes[2] == EnCommand.setSettings.code) {
        getSettings();
        currentCommandResponse = EnCommand.setSettings;
      } else if (bytesUtil.bytes[2] == EnCommand.startDFU.code) {
        currentCommandResponse = EnCommand.startDFU;
      }
    }
    // LoggerService.log(bytesUtil.bytes);
    final removing = _removeFirstCommand(currentCommandResponse);
    if (removing) {
      _playNextCommand();
    }
  }


  Future<void> idle() async {
    await _addCommand(CommandModel(data: [0], command: EnCommand.idle));
  }

  Future<void> continuousSample() async {
    // LoggerService.log("start Continuous sample");
    _continuousSample =
        CommandModel(data: [1], command: EnCommand.continuousSample);
    if (_listCommands.isEmpty) {
      _playNextCommand();
    }
    // await _addCommand(
    //     CommandModel(data: [1], command: EnCommand.continuousSample));
  }

  Future<void> stop() async {
    // LoggerService.log("stop Continuous sample");
    _continuousSample = null;
    await _addCommand(CommandModel(data: [8], command: EnCommand.stop));
  }

  Future<void> getSettings({bool required = false}) async {
    LoggerService.log("get setting");
    await _addCommand(
        CommandModel(data: [12], required: required, command: EnCommand.getSettings));

  }
  Future<String?> setSettings(bool isHealth) async {
    // LoggerService.log("setSettings");
    if (tagId != null) {
      var sendValueBytes = ByteData(8);
      sendValueBytes.setInt8(0, 11); //command code
      sendValueBytes.setInt8(1, isHealth ? 1 : 0);
      sendValueBytes.setInt32(2, tagId!, Endian.little);
      sendValueBytes.setInt8(6, 0x60);
      sendValueBytes.setInt8(7, 0x45);
      // LoggerService.log("setSettings");
      // LoggerService.log(sendValueBytes.buffer.asUint8List());
      await _addCommand(CommandModel(
          data: sendValueBytes.buffer.asUint8List(),
          command: EnCommand.setSettings));
      return null;
    }
    {
      return "No tog detected";
    }
  }

  Future<void> getRecord() async {
    // LoggerService.log("getRecord");
    await _addCommand(CommandModel(data: [4], command: EnCommand.getRecord));
  }

  Future<void> getRTC() async {
    // LoggerService.log("getRTC");
    await _addCommand(CommandModel(data: [9], command: EnCommand.getRTC));
  }

  Future<void> updateRTC(DateTime dateTime) async {
    // LoggerService.log("updateRTC");
    var sendValueBytes = ByteData(5);
    sendValueBytes.setInt8(0, 2); //command code
    sendValueBytes.setInt32(
        1, dateTime.millisecondsSinceEpoch ~/ 1000, Endian.little);
    // LoggerService.log(sendValueBytes.buffer.asUint8List());
  }

  Future<void> startDFU() async {
    _continuousSample = null;
    await _addCommand(CommandModel(
        data: [0xB1, 0x44, 0x46, 0x55, 0x57, 0x44],
        command: EnCommand.startDFU));
  }

  Future<void> getId() async {
    _continuousSample = null;
    await _addCommand(CommandModel(data:[3],
        command: EnCommand.getID));
  }

  bool _removeFirstCommand(EnCommand? command) {
    LoggerService.log("_removeFirstCommand ${_listCommands.toString()} (need to remove: ${command.toString()})" );
    // LoggerService.log("prevCommand $command" );
    // LoggerService.log("listCommand ${_listCommands.toString()}" );
    if (_listCommands.isNotEmpty && _listCommands.first.command == command) {
      // LoggerService.log("remove $command" );
      _listCommands.removeAt(0);
      return true;
    }
    return false;
  }

  _addCommand(CommandModel command) async {
    LoggerService.log("_addCommand ${command.toString()}");
    _sendCommand = true;
    _listCommands.add(command);
    final g = _listCommands.toString();

    LoggerService.log("_addCommand $g" );

    if (_listCommands.length == 1) {
      await _playNextCommand();
    }
  }


  _playNextCommand() async {
    LoggerService.log("_playNextCommand ${_listCommands.toString()}");
    if (_listCommands.isNotEmpty) {
      final command = _listCommands[0];
      await _bleProvider.sendTransparentData(command.data,
          required: command.required);
    } else if (_continuousSample != null) {
      await _bleProvider.sendTransparentData(_continuousSample!.data,
          required: _continuousSample!.required);
    }
  }

  Future<void> resumeApp() => _bleProvider.resumeApp();

  dispose() async {
    await _listStreamSubscription?.cancel();
    await _chargeEventModel.close();
    await _deviceIdConnectedStreamSubscription?.cancel();
  }

  /*updateSetting(SettingModel settingModel) {
    tagId =
        settingModel.tagId; // if tagId from setting is null don't change tagId;
    _setting.sink.add(settingModel);
    if (_deviceId != null) {
      _localStorage.setSetting(_deviceId!, settingModel);
    }
  }*/
}
