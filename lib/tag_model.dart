import 'bytes_utils.dart';
import 'tag_id_and_sn.dart';

class TagModel {
  int? HV;
  int? firmwareMinor;
  int? firmwareMajor;
  int? macAddress;
  TagIdAndSN? tagIdAndSN;

  TagModel();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map["HV"] = HV;
    map["firmwareMinor"] = firmwareMinor;
    map["firmwareMajor"] = firmwareMajor;
    map["macAddress"] = macAddress;
    if(tagIdAndSN != null){
      map["tagIdAndSN"] = tagIdAndSN!.toJson();}
    return map;
  }

  TagModel.fromJson(Map<String, dynamic> json) {
    HV = json["HV"];
    firmwareMinor = json["firmwareMinor"];
    firmwareMajor = json["firmwareMajor"];
    macAddress = json["macAddress"];
    tagIdAndSN = json["tagIdAndSN"] != null
        ? TagIdAndSN.fromJson(json["tagIdAndSN"])
        : null;
  }

  TagModel.fromBytesUtil(BytesUtil bytesUtil) {
    HV = bytesUtil.getFrom8bit(2);
    firmwareMinor = bytesUtil.getFrom8bit(3);
    firmwareMajor = bytesUtil.getFrom8bit(4);
    // macAddress = bytesUtil.getFrom16bit(2);
    tagIdAndSN = TagIdAndSN(tagId: bytesUtil.getFrom32bit(15),serialNumber: bytesUtil.getFrom32bit(5).toString());
  }
}