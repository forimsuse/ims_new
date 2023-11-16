import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../location_error_message.dart';
import '../permission_service_repository.dart';

class BluetoothOffScreen extends StatefulWidget {
  const BluetoothOffScreen({Key? key, required this.permissionServiceRepository}) : super(key: key);
  final PermissionServiceRepository permissionServiceRepository;

  @override
  State<BluetoothOffScreen> createState() => _BluetoothOffScreenState();
}

class _BluetoothOffScreenState extends State<BluetoothOffScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool isLoadingLocation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
            stream: widget.permissionServiceRepository.bluetoothStream,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    snapshot.data == true ? Icons.bluetooth : Icons.bluetooth_disabled,
                    size: 200.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    'Bluetooth is ${snapshot.data == true ? 'on' : 'off'}.',
                  ),
                  snapshot.data != true
                      ? ElevatedButton(
                          onPressed: Platform.isAndroid ? () => FlutterBluePlus.turnOn() : null,
                          child: const Text('Turn bluetooth ON'),
                        )
                      : const SizedBox(),
                ],
              );
            }),
      ),
      bottomSheet: StreamBuilder(
          stream: widget.permissionServiceRepository.checkStateLocationStream,
          builder: (context, AsyncSnapshot<String?> snapshot) {
            return LocationErrorMessage(
              visible: snapshot.data == null,
              onlyContent: true,
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
