class TagIdAndSN{
  int? tagID;
  String? serialNumber;

  TagIdAndSN({int? tagId,String? serialNumber});

  TagIdAndSN.fromJson(Map<String,dynamic> json){
    tagID = json["tagID"];
    serialNumber = json["serialNumber"];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> map = {};
    map["tagID"] = tagID;
    map["serialNumber"] = serialNumber;
    return map;
  }
}