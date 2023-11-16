import 'package:flutter/foundation.dart';

enum EEnvironment { qa, live}

class CONFIG {
  static final Map<dynamic, dynamic> _config = {
    "clientVersion": '1.0.0',
    "environment": describeEnum(kReleaseMode ? EEnvironment.live : EEnvironment.qa),
    "androidStoreUrl":
    'http://play.google.com/store/apps/details?id=XXX.XXX.XXXX',
    "iosStoreUrl":
    'itms-apps://itunes.apple.com/app/apple-store/idXXXXXXXXX?mt=8',
    "iosITunesUrl": 'http://itunes.com/apps/XXXXXXXXX',
    "qa": {
      "baseUrl": "",
    },
    "live": {
      "baseUrl": "",
    },
    "googleApiKey" : "",
    "ServiceUUID" : "0000ABCD-0000-1000-8000-00805F9B34FB",
  };

  static get(String param) {
    return _config[param] ?? _config[_config["environment"]][param];
  }

  static setEnvironment(EEnvironment environment) {
    return _config["environment"] = describeEnum(environment);
  }

  static getEnvironment() {
    return _config["environment"];
  }

  static setBaseUrl(String baseUrl) {
    return _config[_config["environment"]]["baseUrl"] = baseUrl;
  }
}