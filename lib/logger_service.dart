import 'package:flutter/foundation.dart';

class LoggerService {
  static log(dynamic data) {
    if (kDebugMode) {
      print(data);
    } else if (kReleaseMode) {}
  }
}