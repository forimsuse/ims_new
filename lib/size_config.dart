import 'package:flutter/material.dart';

class SizeConfig {
  final double _screenWidthInit = 390;
  final double _screenHeightInit = 844;
  static late double screenWidthProportion;
  static late double screenHeightProportion;
  static double fontProportion = 1;
  static late double screenWidth;
  static late double screenHeight;
  static bool? isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation, BuildContext context) {
    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      screenWidthProportion = screenWidth / _screenWidthInit;
      screenHeightProportion = screenHeight / _screenHeightInit;
      isPortrait = true;
      if (screenWidth < 1000) {
        isMobilePortrait = true;
      }
    } else {
      screenWidth = constraints.maxHeight;
      screenHeight = constraints.maxWidth;
      screenWidthProportion = screenWidth / _screenWidthInit;
      screenHeightProportion = screenHeight / _screenHeightInit;
      isPortrait = false;
      isMobilePortrait = false;
    }
    fontProportion = screenHeightProportion;
  }

  static getHeightStatusBar(BuildContext context) => MediaQuery.of(context).padding.top;

  static getHeightAppBar(BuildContext context) =>
      AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
}
