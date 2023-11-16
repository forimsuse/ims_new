import 'package:flutter/material.dart';
import '/list_devices.dart';
import '/ims_app_bar.dart';
import '/permission_service_repository.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key, required this.permissionServiceRepository});

  final PermissionServiceRepository permissionServiceRepository;

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ImsAppBar(title: "Devices list"),
      body: ListBatteries(
        permissionServiceRepository: widget.permissionServiceRepository,
      ),
    );
  }
}
