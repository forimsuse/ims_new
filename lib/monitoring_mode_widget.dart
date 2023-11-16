import 'package:flutter/material.dart';
import '/size_config.dart';
import '/device_bloc.dart';
import '/device_repository.dart';
import '/blinker_for_status.dart';

class MonitoringMode extends StatelessWidget {
  final DeviceBloc deviceBloc;

  const MonitoringMode({super.key, required this.deviceBloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: deviceBloc.statusScanStream,
        builder: (context, AsyncSnapshot<EnStatusScan?> snapshotEnStatusScan) {
          return snapshotEnStatusScan.data == null
              ? const SizedBox()
              : _buildIconStatusScan(snapshotEnStatusScan.data);
        });
  }

  Widget _buildIconStatusScan(EnStatusScan? enStatusScan) {
    const waiting = BlinkingPoint(
      xCoor: 20.0,
      yCoor: -0.0,
      pointColor: Colors.orange,
      stop: true,
      pointSize: 3.0,
    );
    const requestingData = BlinkingPoint(
      xCoor: 20.0,
      yCoor: -0.0,
      pointColor: Colors.blue,
      stop: true,
      pointSize: 3.0,
    );
    const monitor = BlinkingPoint(
      xCoor: 20.0,
      yCoor: -0.0,
      pointColor: Color(0xff81C783),
      pointSize: 3.0,
    );
    const dfuTarg = BlinkingPoint(
      xCoor: 20.0,
      yCoor: -0.0,
      pointColor: Colors.tealAccent,
      pointSize: 3.0,
    );
    const error = BlinkingPoint(
      xCoor: 20.0,
      yCoor: -0.0,
      pointColor: Colors.red,
      stop: true,
      pointSize: 3.0,
    );
    final String msg = enStatusScan == EnStatusScan.waiting
        ? "waiting for data"
        : enStatusScan == EnStatusScan.requestingData
        ? "request data"
        : enStatusScan == EnStatusScan.monitor
        ? "monitoring"
        : enStatusScan == EnStatusScan.error
        ? "data error"
        : enStatusScan == EnStatusScan.dfuTarg
        ? "DfuTarg"
        : "";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Opacity(
              opacity: enStatusScan == EnStatusScan.waiting ? 1 : 0,
              child: waiting,
            ),
            Opacity(
              opacity: enStatusScan == EnStatusScan.requestingData ? 1 : 0,
              child: requestingData,
            ),
            Opacity(
              opacity: enStatusScan == EnStatusScan.error ? 1 : 0,
              child: error,
            ),
            Opacity(
              opacity: enStatusScan == EnStatusScan.monitor ? 1 : 0,
              child: monitor,
            ),
            Opacity(
              opacity: enStatusScan == EnStatusScan.dfuTarg ? 1 : 0,
              child: monitor,
            ),
          ],
        ),
        const SizedBox(
          width: 38,
        ),
        Text(
          msg,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16 * SizeConfig.fontProportion,
            fontFamily: 'Khula',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
