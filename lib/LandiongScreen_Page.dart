import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Homepage2.dart';
import 'Student_Landing_Page.dart';
import 'homepage.dart';

class Landing_Screen_Page extends StatefulWidget {
  const Landing_Screen_Page({Key? key}) : super(key: key);

  @override
  State<Landing_Screen_Page> createState() => _Landing_Screen_PageState();
}

class _Landing_Screen_PageState extends State<Landing_Screen_Page> {

@override
  void initState() {


    // TODO: implement initState
    super.initState();
  }

String _deviceId =" ";


/*initPlatformState() async {
  String? deviceId;
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    deviceId = await PlatformDeviceId.getDeviceId;
  } on PlatformException {
    deviceId = 'Failed to get deviceId.';
  }

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // setState to update our non-existent appearance.
  if (!mounted) return;

  setState(() {
    _deviceId = deviceId!;
    print("deviceId->$_deviceId");

  });
  if(_deviceId.isNotEmpty){
    var device=await FirebaseFirestore.instance.collection("deviceid").get();

    for(int i=0;i<device.docs.length;i++){
      if(_deviceId==device.docs[i]['id']&&device.docs[i]["type"]=="Student"){

        Navigator.push(context, MaterialPageRoute(builder: (context) =>Student_landing_Page() ,));

      }
      if(_deviceId==device.docs[i]['id']&&device.docs[i]["type"]=="Teacher"){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>Homepage() ,));
      }


    }



  }



}*/


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 50,
              width: 50,
              child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}
