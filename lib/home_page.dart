import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ims_app_new/drawer.dart';
import '/monitoring_mode_widget.dart';
import '/ims_app_bar.dart';
import '/charge_event_model.dart';
import '/logger_service.dart';
import '/root_navigation.dart';
import '/device_bloc.dart';
//import '/drawer.dart';                            TODO add this back later for menu maybe
//import '/setting_model.dart';                     TODO do i need this??
//import '/list_title_ims.dart';                    TODO do i need this??

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.deviceId, required this.deviceBloc});

  final String deviceId;
  final DeviceBloc deviceBloc;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  //var scaffoldKey = GlobalKey<ScaffoldState>();
  //final myColor = AppColors.black;

  bool reconnect = false;
  String? msgError;

  StreamSubscription? streamDeviceIdConnect;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    streamDeviceIdConnect =
        widget.deviceBloc.deviceIdConnectedStream.listen((event) {}, onError: (ex, stack) {
          if (mounted) {
            RootNavigation.popToFirst();
          }
        });
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (mounted) {
          LoggerService.log("HomePage resumed");
          setState(() {
            reconnect = true;
          });
          msgError = await widget.deviceBloc.connectToDevice(widget.deviceId, force: true);
          if (mounted) {
            setState(() {
              reconnect = false;
            });
          }
        }
        break;
      default:
        LoggerService.log("HomePage $state");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.deviceBloc.stop();
        return true;
      },
      child: Scaffold(
        //key: scaffoldKey,
        drawer: SettingsDrawer(
          deviceBloc: widget.deviceBloc,
        ),
        appBar: ImsAppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              //scaffoldKey.currentState?.openDrawer();
            },
            padding: EdgeInsets.zero,
          ),
          titleWidget: const Text('Some title here'),//_buildTagId(),
          title: '',
        ),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .secondaryContainer,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: widget.deviceBloc.chargeEventModelStream,
                builder: (context, AsyncSnapshot<ChargeEventModel?> snapshot) {
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          msgError == null
                              ? const SizedBox()
                              : Tooltip(
                            message: msgError,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.warning_rounded),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MonitoringMode(deviceBloc: widget.deviceBloc),
                                ElevatedButton(
                                  onPressed: () {
                                    print('pressed meas');
                                  },
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(3.0),
                                  ),
                                  child: const Text(
                                    'for writing meas',
                                  ),
                                ),
                              ], //roBabies
                            ),
                          ),

                        ], //coBabies
                      ),
                    ], //liBabies
                  );
                }, //stBabies
              ),
            ),
          ], //coBabies
        ),
      ),
    );
  }

  /*_buildTagId() {
    return StreamBuilder(
        stream: widget.deviceBloc.settingStream,
        builder: (context, AsyncSnapshot<SettingModel?> snapshot) {
          return ListItemIMS()
              .build("Tag Id: ", snapshot.data?.tagId.toString(), boldContent: true);
        });
  }*/
}