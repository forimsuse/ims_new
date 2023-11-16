import 'dart:io';
import 'package:flutter/material.dart';
import '/pages/devices_page.dart';
import '/pages/bluetooth_off_page.dart';
import '/routes.dart';
import '/root_navigation.dart';
import '/size_config.dart';
import '/permission_provider.dart';
import '/permission_service_repository.dart';

void main() {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    PermissionProvider.request().then((status) {
      runApp(const MyApp());
    });
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final permission = PermissionServiceRepository();

  @override
  void initState() {
    permission.listenToState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: RootNavigation.navigatorKey,
      title: 'IMSnew',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      routes: routes,
      home: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation, context);
          return StreamBuilder<bool>(
              stream: permission.correctPermissionsStream,
              initialData: false,
              builder: (c, snapshot) {
                final state = snapshot.data;
                if (state == true) {
                  return DevicesPage(permissionServiceRepository: permission);
                }
                return BluetoothOffScreen(permissionServiceRepository: permission);
              });
        });
      }),
      onGenerateRoute: onGenerateRoute,
    );
  }
}
