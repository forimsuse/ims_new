import 'package:flutter/cupertino.dart';

class RootNavigation {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void pop( [dynamic result]) {
    if (navigatorKey.currentState == null && !Navigator.canPop(navigatorKey.currentState!.context)) {
      return;
    }
    Navigator.pop(navigatorKey.currentState!.context, result);
  }

  static void popToFirst() {
    if (navigatorKey.currentState == null && !Navigator.canPop(navigatorKey.currentState!.context)) {
      return;
    }

    Navigator.of(navigatorKey.currentState!.context).popUntil((route) => route.isFirst);
  }

  static Future<dynamic> push(
      String name, {
        Map<String, dynamic>? arguments,
      }) async {
    if (navigatorKey.currentState == null) {
      return;
    }
    FocusScope.of(navigatorKey.currentState!.context).unfocus();
    return Navigator.of(navigatorKey.currentState!.context).pushNamed(name, arguments: arguments);
  }

  static void present( Widget widget,
      {Map<String, dynamic>? arguments}) {
    if (navigatorKey.currentState == null) {
      return;
    }
    FocusScope.of(navigatorKey.currentState!.context).unfocus();
    arguments == null
        ? Navigator.of(navigatorKey.currentState!.context).push(CupertinoPageRoute(
        fullscreenDialog: true, builder: (context) => widget))
        : Navigator.of(navigatorKey.currentState!.context).push(CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => widget,
        settings: RouteSettings(arguments: arguments)));
  }

  static void presentWithAnimate( Widget widget,
      {Map<String, dynamic>? arguments, int milliseconds = 300}) {
    if (navigatorKey.currentState == null) {
      return;
    }
    FocusScope.of(navigatorKey.currentState!.context).unfocus();
    arguments == null
        ? Navigator.push(
      navigatorKey.currentState!.context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (c, a1, a2) => widget,
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: milliseconds),
      ),
    )
        : Navigator.push(
        navigatorKey.currentState!.context,
        PageRouteBuilder(
            opaque: false,
            pageBuilder: (c, a1, a2) => widget,
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: milliseconds),
            settings: RouteSettings(arguments: arguments)));
  }
}
