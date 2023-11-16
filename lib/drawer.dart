import 'package:flutter/material.dart';
import '/device_bloc.dart';

class SettingsDrawer extends StatelessWidget{
  const SettingsDrawer({super.key, required this.deviceBloc});
  final DeviceBloc deviceBloc;
  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.22,
            padding: const EdgeInsets.only(bottom: 15),
            color: Colors.black.withOpacity(0.6),
            child:  Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.03),
                  child: const Text("Settings",style: TextStyle(fontFamily: 'arlrdbd',fontSize: 22),)
                //Image.asset("assets/images/logo2.png",color: Colors.black,width: MediaQuery.of(context).size.width * 0.4,),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children:  <Widget>[
                const ListTile(
                  title: Text("Update RTC",style: TextStyle(color: Colors.black),),
                ),
                const ListTile(
                  title: Text("Charging settings(85%)",style: TextStyle(color: Colors.black)),
                ),
                const ListTile(
                  title: Text("Hard reset",style: TextStyle(color: Colors.black)),
                ),
                const ListTile(
                  title: Text("Self-test",style: TextStyle(color: Colors.black)),
                ),
                const ListTile(
                  title: Text("Delete records",style: TextStyle(color: Colors.black)),
                ),
                ListTile(
                  title: const Text("Start DFU",style: TextStyle(color: Colors.black)),onTap: (){
                  deviceBloc.startDFU();
                },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}