import '../bytes_utils.dart';
import 'charging_data.dart';
import 'tag_id_and_sn.dart';

/*    PROBABLY DON'T NEED THIS?   */

/// Record type: type of alert that created the record:
/// Over temperature (Alarm)
/// Over temperature while charging (after 3 times in last hour)
/// Charge too long
/// Charge too fast

// ignore: unused_field
enum EnRecordType{_,overTemperature,overTemperatureWhileCharging, chargeTooLong, chargeTooFast}
// ignore: unused_field
enum EnErrorTypeTemp{_,noError,
  overTemperatureWithAlert,
  chargeTemperatureIsOverMaximumChargeTemperatureFor3TimesWithinAnHour,
  theChargeIsTooLong,
  theChargeIsTooFast,
  batteryVoltageDropsAfterCharge,
  selfTestChargerVoltageIsTooLow,
  selfTestChargerVoltageIsTooHigh,
  selfTestZeroCurrentIsTooHigh,
  selfTestDeviceTemperatureIsTooLow,
  selfTestDeviceTemperatureIsTooHigh,
  selfTestNotDoneStillRunningSelfTest
}

class RecordModel{
  TagIdAndSN? tagIdAndSN;
  EnRecordType? recordType;
  ChargingData chargingData = ChargingData.init();
  DateTime? RTC;
  DateTime? chargeStartTime;
  int? scooterModel;
  double? _batteryMaxTemperature;

  RecordModel();

  RecordModel.fromJson(Map<String,dynamic> json){
    tagIdAndSN = json["tagIdAndSN"] != null ? TagIdAndSN.fromJson(json["tagIdAndSN"]) : null;
    recordType = json["recordType"] != null ? EnRecordType.values[json["recordType"]] : null;
    chargingData = json["chargingData"] != null ? ChargingData.fromJson(json["chargingData"]) : ChargingData.init();

  }


  setFirstPacket(BytesUtil bytesUtil){
    recordType = EnRecordType.values[bytesUtil.getFrom8bit(5)];
    tagIdAndSN = TagIdAndSN(tagId: bytesUtil.getFrom32bit(6),serialNumber: bytesUtil.getFrom32bit(10).toString());
    scooterModel = bytesUtil.getFrom16bit(14);
    //RTC = bytesUtil.getFrom32bit(16)
  }
  setSecondPacket(BytesUtil bytesUtil){
    //chargeStartTime = bytesUtil.getFrom32bit(4)
    chargingData.mainVoltage = bytesUtil.getFrom16bit(8).toDouble();
    batteryMaxTemperature = bytesUtil.getFrom16bit(10).toDouble();
    chargingData.batteryTemperature1 = bytesUtil.getFrom16bit(12).toDouble();
    chargingData.batteryTemperature2 = bytesUtil.getFrom16bit(14).toDouble();
    chargingData.batteryTemperature3 = bytesUtil.getFrom16bit(16).toDouble();
    chargingData.mainTemperature = bytesUtil.getFrom16bit(18).toDouble();


  }
  setThirdPacket(BytesUtil bytesUtil){
    chargingData.batteryVoltage = bytesUtil.getFrom16bit(4).toDouble();
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> map = {};
    map["tagIdAndSN"] = tagIdAndSN  != null ? tagIdAndSN!.toJson() : null;
    map["recordType"] = recordType  != null ? recordType!.index : null;
    map["chargingData"] = chargingData.toJson();
    return map;
  }

  double? get batteryMaxTemperature => _batteryMaxTemperature;

  set batteryMaxTemperature(double? value) {
    _batteryMaxTemperature = value != null ? value/100 : null;
  }

  String getWarningMessage(){
    switch (recordType) {
      case EnRecordType.overTemperature :
        return "Over temperature";
      case EnRecordType.overTemperatureWhileCharging :
        return "Over temperature while charging";
      case EnRecordType.chargeTooLong :
        return "Charge too long";
      case EnRecordType.chargeTooFast :
        return "Charge too fast";
      default:
        return "";
    }
  }
}