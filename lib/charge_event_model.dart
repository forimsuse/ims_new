import 'dart:typed_data';
import 'bytes_utils.dart';
import 'logger_service.dart';
import 'charging_data.dart';

class ChargeEventModel {
  String? chargeDuration;
  int? mainCurrent;
  ChargingData? chargingData;
  int? packetNumber;

  ChargeEventModel(this.chargeDuration, this.mainCurrent, this.chargingData,this.packetNumber);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map["chargeDuration"] = chargeDuration;
    map["mainCurrent"] = mainCurrent;
    map["chargingData"] = chargingData?.toJson();
    map["packetNumber"] = packetNumber;

    return map;
  }

  ChargeEventModel.fromJson(Map<String, dynamic> json) {
    chargeDuration = json["chargeDuration"];
    mainCurrent = json["mainCurrent"];
    packetNumber = json["packetNumber"];
    chargingData = json["chargingData"] != null
        ? ChargingData.fromJson(json["chargingData"])
        : null;
  }

  ChargeEventModel.fromUint16Bites(List<int> list) {
    var bytes = Uint8List.fromList(list);
    chargeDuration = list[19].toString();
    packetNumber = bytes.buffer.asByteData().getUint16(2, Endian.little);
    LoggerService.log(bytes.buffer.asByteData().getUint16(2, Endian.little));
    var batteryTemperature3 =
    bytes.buffer.asByteData().getUint16(10, Endian.little);
    var batteryTemperature2 =
    bytes.buffer.asByteData().getUint16(8, Endian.little);
    var batteryTemperature1 =
    bytes.buffer.asByteData().getUint16(6, Endian.little);
    var batteryVoltage = bytes.buffer.asByteData().getUint16(4, Endian.little);
    var mainVoltage = bytes.buffer.asByteData().getUint16(14, Endian.little);
    var mainTemperature =
    bytes.buffer.asByteData().getUint16(16, Endian.little);
    mainCurrent = bytes.buffer.asByteData().getUint16(12, Endian.little);

    chargingData = ChargingData(
      batteryVoltage: batteryVoltage,
      batteryTemperature1: batteryTemperature1,
      batteryTemperature2: batteryTemperature2,
      batteryTemperature3: batteryTemperature3,
      mainVoltage: mainVoltage,
      mainTemperature: mainTemperature,
    );
  }

  ChargeEventModel.fromBytesUtil(BytesUtil bytesUtil) {
    chargeDuration = formatTime(
        bytesUtil.getFrom16bit(18)); //bytesUtil.getFrom16bit(18).toDouble();
    LoggerService.log(bytesUtil.getFrom16bit(2));
    var batteryTemperature3 = bytesUtil.getFrom16bit(10);
    var batteryTemperature2 = bytesUtil.getFrom16bit(8);
    var batteryTemperature1 = bytesUtil.getFrom16bit(6);
    var batteryVoltage = bytesUtil.getFrom16bit(4);
    var mainVoltage = bytesUtil.getFrom16bit(14);
    var mainTemperature = bytesUtil.getFrom16bit(16);
    mainCurrent = bytesUtil.getFrom16bit(12);
    packetNumber = bytesUtil.getFrom16bit(2);
    chargingData = ChargingData(
      batteryVoltage: batteryVoltage,
      batteryTemperature1: batteryTemperature1,
      batteryTemperature2: batteryTemperature2,
      batteryTemperature3: batteryTemperature3,
      mainVoltage: mainVoltage,
      mainTemperature: mainTemperature,
    );
  }

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }
}
