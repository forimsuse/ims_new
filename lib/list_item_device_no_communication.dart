import 'package:flutter/material.dart';
import '../device_frame.dart';
import '../size_config.dart';

class ListItemDeviceNoCommunication extends StatefulWidget {
  const ListItemDeviceNoCommunication({
    super.key,
    required this.deviceId,
    this.name,
  });
  final String deviceId;
  final String? name;

  @override
  State<ListItemDeviceNoCommunication> createState() =>
      _ListItemDeviceNoCommunicationState();
}

class _ListItemDeviceNoCommunicationState
    extends State<ListItemDeviceNoCommunication> {

  @override
  Widget build(BuildContext context) {

    return DeviceFrame(
        child: Column(
          children: [
            Text(
              widget.deviceId,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18 * SizeConfig.screenWidthProportion,
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            Text(
              "No communication",
              style: TextStyle(
                fontSize: 16 * SizeConfig.screenWidthProportion,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ],  //coBabies
        ),
    );
  }
}
