
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:vidhaan_school_app/exam.dart';
import 'package:vidhaan_school_app/excel.sheet.dart';
import 'package:vidhaan_school_app/records.dart';
import 'const_file.dart';
import 'package:vidhaan_school_app/profile_page.dart';
import 'Homepage2.dart';



class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {


  PageController _pageController = PageController();

  int _currentIndex = 0;


  double venderlatitude = 0;
  double venderlongitude = 0;
  double latitude = 0;
  double longitude = 0;


  String _scanBarcode = '';

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;

  late Position position;

  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  barcodeScan() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    print("scan qr codeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    print(_scanBarcode);

    double classlongtitude = 0;
    double classlattitude = 0;
    String section = "";

    var document = await _firestore2db.collection("Qrscan").doc(
        _scanBarcode).get();
    Map<String, dynamic>?valuses = document.data();
    setState(() {
      classlongtitude = double.parse(valuses!["longtitude"]);
      classlattitude = double.parse(valuses['lattitude']);
      section =valuses['Class'];
    });
    print(classlongtitude);
    print(classlattitude);
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
      if (haspermission) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
        print(position.latitude);
        print(position.longitude);
        var _distanceInMeters = await Geolocator.distanceBetween(
          classlattitude,
          classlongtitude,
          latitude,
          longitude,
        );
        print("Kilometers");
        print(_distanceInMeters);
        print((_distanceInMeters * 0.001).round());
        if(_distanceInMeters<60){
          inoufield();
        }
        else{
          outoufield();
        }
      }
    }

    /// For Continuous scan
    startBarcodeScanStream() async {
      FlutterBarcodeScanner.getBarcodeStreamReceiver(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE)!.listen((barcode) => print(barcode));
    }
  }

  outoufield(){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(context: context, builder:(context) {
      return AlertDialog(
        content: Column(
          children: [
            SizedBox(height:height/50.4,),
            Text("out of range"),
            SizedBox(height:height/50.4,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height:height/18.9,
                width:width/3,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Center(
                  child: Text("okay",style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
            SizedBox(height:height/50.4,),


          ],
        ),
      );
    },);
  }

  inoufield(){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(context: context, builder:(context) {
      return AlertDialog(
        content: Column(
          children: [
            SizedBox(height:height/50.4,),
            Text("Attendance marked"),
            SizedBox(height:height/50.4,),

            GestureDetector(
              onTap: (){
                Marktheattendancefun();

              },
              child: Container(
                height:height/18.9,
                width:width/3,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Center(
                  child: Text("okay",style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
            SizedBox(height:height/50.4,),

          ],
        ),

      );
    },);
  }

  String staffid="";
  String staffname="";
  String staffregno="";
  String staffimg="";

  getstaffdetails() async {

    var document = await _firestore2db.collection("Staffs").get();
    for(int i=0;i<document.docs.length;i++){
      if(document.docs[i]["userid"]==_firebaseauth2db.currentUser!.uid){
        setState(() {
          staffid=document.docs[i].id;
        });
        print("Saffid:${staffid}");
        print(staffid);
      }

    };

      var staffdocument= await _firestore2db.collection("Staffs").doc(staffid).get();
      Map<String,dynamic>?staffvalue=staffdocument.data();
      setState(() {
        staffname=staffvalue!['stname'];
        staffregno=staffvalue['regno'];
        staffimg=staffvalue['imgurl'];
      });


    print("staffname stff id staff img");
    print(staffname);
    print(staffregno);
    print(staffimg);
  }

  Marktheattendancefun(){
    _firestore2db.collection("Staff_attendance").doc("${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}").
    set(
        {
          "Staffattendance":true,
          "Staffname":staffname,
          "Staffregno":staffregno,
          "Date":"${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}",
          "Time":DateFormat("h:mma").format(DateTime.now()),
          "timstamp":DateTime.now().millisecondsSinceEpoch,
        });

    Navigator.pop(context);
  }


    @override
    void initState() {

      getstaffdetails();
      print(new DateFormat.yMMMd().format(new DateTime.now()));
      super.initState();
      _pageController = PageController();
    }




    String page = 'Home';
    final GlobalKey <ScaffoldState> key = GlobalKey();

    @override
    Widget build(BuildContext context) {
      double height = MediaQuery
          .of(context)
          .size
          .height;

      double width = MediaQuery
          .of(context)
          .size
          .width;

      return Scaffold(

        backgroundColor: Color(0xff0873C4),

        body:
        selectedIndexvalue == 0 ?
        Frontpage(staffid) :
        selectedIndexvalue == 1 ?
        Records(staffregno) :
        selectedIndexvalue == 2 ?
        Exams():
        selectedIndexvalue == 3 ?
        Profile() :
        SizedBox(),

        bottomNavigationBar: CreateBottombar(),

      );
    }

    Container CreateBottombar() {
      double height = MediaQuery
          .of(context)
          .size
          .height;
      double width = MediaQuery
          .of(context)
          .size
          .width;
      return Container(
        color: Colors.white,
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),

            child: Container(
              height: height / 10.8,
              child:

              GNav(
                  backgroundColor: Color(0xff0873C4),
                  haptic: true,
                  tabBorderRadius: 18,
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 600),
                  gap: 8,
                  color: Colors.white,
                  activeColor: Color(0xff0873C4),
                  iconSize: 26,
                  tabBackgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: width / 36, vertical: height / 151.2),
                  tabs: [
                    GButton(
                      margin: EdgeInsets.only(left: width / 36),
                      icon: Icons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.file_copy_sharp,
                      text: 'R & R',
                    ),
                    GButton(
                      icon: Icons.assignment,
                      text: 'Exams',
                    ),
                    GButton(
                      margin: EdgeInsets.only(right: width / 36),
                      icon: Icons.person_outline,
                      text: 'Profile',
                    )
                  ],
                  selectedIndex: selectedIndexvalue,
                  onTabChange: onTabTapped
              ),
            )


        ),
      );
    }

    void onTabTapped(int index) {
      setState(() {
        selectedIndexvalue = index;
      });
      setState(() {

      });
    }

  }
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);