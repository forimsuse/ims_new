class ChargingData{
  double? _batteryVoltage;
  double? _batteryTemperature1;
  double? _batteryTemperature2;
  double? _batteryTemperature3;
  double? _mainVoltage;
  double? _mainTemperature;
  static bool degreeTypeC = true;

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> map = {};
    map["batteryVoltage"] = _batteryVoltage;
    map["batteryTemperature1"] = _batteryTemperature1;
    map["batteryTemperature2"] = _batteryTemperature2;
    map["batteryTemperature3"] = _batteryTemperature3;
    map["mainVoltage"] = _mainVoltage;
    map["mainTemperature"] = _mainTemperature;
    return map;
  }

  ChargingData.fromJson(Map<String,dynamic> json){
    _batteryVoltage = json["batteryVoltage"];
    _batteryTemperature1 = json["batteryTemperature1"];
    _batteryTemperature2 = json["batteryTemperature2"];
    _batteryTemperature3 = json["batteryTemperature3"];
    _mainVoltage = json["mainVoltage"];
    _mainTemperature = json["mainTemperature"];
  }

  ChargingData({required int batteryVoltage,required int batteryTemperature1,required int batteryTemperature2,
    required int batteryTemperature3,required int mainVoltage,required int mainTemperature}){

    this.batteryVoltage = batteryVoltage.toDouble();
    this.batteryTemperature1 = batteryTemperature1.toDouble();
    this.batteryTemperature2 = batteryTemperature2.toDouble();
    this.batteryTemperature3 = batteryTemperature3.toDouble();
    this.mainVoltage = mainVoltage.toDouble();
    this.mainTemperature = mainTemperature.toDouble();
  }

  ChargingData.init();

  double? get batteryTemperature1 => getDegreeByType(_batteryTemperature1);

  set batteryTemperature1(double? value) {
    _batteryTemperature1 = value != null ? value/100 : null;
  }

  double? get batteryTemperature2 => getDegreeByType(_batteryTemperature2);

  set batteryTemperature2(double? value) {
    _batteryTemperature2 = value != null ? value/100 : null;
  }

  double? get batteryTemperature3 => getDegreeByType(_batteryTemperature3);

  set batteryTemperature3(double? value) {
    _batteryTemperature3 = value != null ? value/100 : null;
  }

  double? get mainVoltage => _mainVoltage;

  set mainVoltage(double? value) {
    _mainVoltage = value != null ? value/100 : null;
  }

  double? get mainTemperature => getDegreeByType(_mainTemperature);

  set mainTemperature(double? value) {
    _mainTemperature = value != null ? value/100 : null;
  }

  double? get batteryVoltage => _batteryVoltage;

  set batteryVoltage(double? value) {
    _batteryVoltage = value != null ? value/100 : null;
  }

  double? getMaxTemperature() {
    double? largest;
    if (batteryTemperature1 != null &&
        (batteryTemperature2 == null || batteryTemperature1! >= batteryTemperature2!) &&
        (batteryTemperature3 == null || batteryTemperature1! >= batteryTemperature3!)) {
      largest = batteryTemperature1;
    } else if (batteryTemperature2 != null && (batteryTemperature3 == null || batteryTemperature2! >= batteryTemperature3!)) {
      largest = batteryTemperature2;
    } else {
      largest = batteryTemperature3;
    }
    return largest;
  }

  bool? dangerousTemperature() {
    final max = getMaxTemperature();
    return max == null ? null : max >= (degreeTypeC ? 45 : 113) || max <= (degreeTypeC ? 0 : 32);
  }

  double? getDegreeByType(double? temperature){
    return degreeTypeC || temperature == null ? temperature : (temperature*1.8) + 32;
  }

}

