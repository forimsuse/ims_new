import 'package:flutter/material.dart';
import '/home_page.dart';

var routes = <String, WidgetBuilder>{
};

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  final arguments = settings.arguments;
  final Map mapArguments = arguments is Map ? arguments : {};
  switch (settings.name) {
    case '/battery':
      return MaterialPageRoute(
          builder: (context) => HomePage(
            deviceId: mapArguments["deviceId"], deviceBloc: mapArguments["deviceBloc"],
          ),
          settings: settings);
    default:
      return null;
  }
}
