import 'package:flutter/material.dart';
import '../size_config.dart';

class DeviceFrame extends StatelessWidget {
  final Widget child;

  const DeviceFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 329 * SizeConfig.screenWidthProportion,
          padding: EdgeInsetsDirectional.only(
              top: 7 * SizeConfig.screenHeightProportion,
              bottom: 7 * SizeConfig.screenHeightProportion,
              start: 12 * SizeConfig.screenWidthProportion),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(6 * SizeConfig.screenWidthProportion),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                  padding: EdgeInsetsDirectional.only(start: 4 * SizeConfig.screenWidthProportion),
                  child: child),
              PositionedDirectional(
                start: 0,
                top: 4 * SizeConfig.screenHeightProportion,
                bottom: 4 * SizeConfig.screenHeightProportion,
                child: Container(
                  color: Theme.of(context).primaryColor,
                  width: 4 * SizeConfig.screenWidthProportion,
                ),
              )
            ],
          ),
        ),
        Container(
          width: 12 * SizeConfig.screenWidthProportion,
          height: 55 * SizeConfig.screenHeightProportion,
          decoration: ShapeDecoration(
            color: const Color(0xFFD9D9D9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(3 * SizeConfig.screenWidthProportion),
                bottomRight: Radius.circular(3 * SizeConfig.screenWidthProportion),
              ),
            ),
          ),
        )
      ],
    );
  }
}
