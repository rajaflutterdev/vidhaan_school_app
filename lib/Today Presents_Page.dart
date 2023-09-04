

import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class Today_Presents_Page extends StatefulWidget {
String name;
String regno;
  Today_Presents_Page(this.name,this.regno);
  @override
  State<Today_Presents_Page> createState() => _Today_Presents_PageState();
}

class _Today_Presents_PageState extends State<Today_Presents_Page> {


  double venderlatitude = 0;
  double venderlongitude = 0;
  double latitude = 0;
  double longitude = 0;


  String _scanBarcode = '';

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;

  late Position position;

  bool attendance=false;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;
  double classlongtitude = 0;
  double classlattitude = 0;
  String section = "";

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



    var document = await _firestore2db.collection("Qrscan").doc(_scanBarcode).get();
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
          setState(() {


          });
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
      return Padding(
        padding: const EdgeInsets.only(top: 180.0,bottom: 180),
        child: AlertDialog(
          content: Column(
            children: [
              SizedBox(height: height/50.4,),

              Text("Out Of range",style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),),

              SizedBox(height: height/75.6,),

              Text("Please Make Sure Valid Location Point",style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,fontSize: width/36.0),),

              SizedBox(height: height/50.4,),

              SizedBox(
                height: height/7.56,
                width: width/3.60,
                child: Center(child: Lottie.asset("assets/animation_lk2m7oge.json")),
              ),

              SizedBox(height: height/32.85,),

              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Material(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100),
                  elevation: 50,
                  animationDuration: Duration(seconds: 2),
                  child: Container(
                    height:height/16.425,
                    width:width/3,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Center(
                      child: Text("okay",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                    ),
                  ),
                ),
              ),

              SizedBox(height: height/50.4,),

            ],
          ),
        ),
      );
    },);
  }

  inoufield(){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(context: context, builder:(context) {
      return Padding(
        padding:  EdgeInsets.only(top: height/4.2,bottom: height/4.2),
        child: AlertDialog(

          content: Column(
            children: [
              SizedBox(height: height/46.92,),
              Text("Attendance marked SuccessFully",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),),
              SizedBox(height: height/32.85,),
              //Text("Satff Name:${widget.name}" ,style: GoogleFonts.montserrat()),
              //Text("Satff Regno:${widget.regno}" ,style: GoogleFonts.montserrat()),

              SizedBox(
                height: height/6.56,
              width: width/0.41,
                child: Center(
                  child: Lottie.asset("assets/animation_lk3vmbvu.json",fit: BoxFit.cover),
                ),
              ),

              SizedBox(height: height/32.85,),
              GestureDetector(
                onTap: (){

                  Marktheattendancefun();

                },
                child: Material(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100),
                  elevation: 50,
                  animationDuration: Duration(seconds: 2),
                  shadowColor: Colors.black12,
                  child: Container(
                    height:height/16.425,
                    width:width/3,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Center(
                      child: Text("okay",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                    ),
                  ),
                ),
              ),

            ],
          ),

        ),
      );
    },);
  }

  Marktheattendancefun(){
    _firestore2db.collection("Staffs").
    doc(staffid).
    update(
        {
          "absent":false,
        }
        );

    _firestore2db.collection("Staffs").doc(staffid).
    collection("Attendance").doc("${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}").
    set(
        {
          "Staffattendance":true,
          "Class":section,
          "Date":"${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          "Time":DateFormat("h:mma").format(DateTime.now()),
          "timstamp":DateTime.now().millisecondsSinceEpoch,
        }
        );

    _firestore2db.collection("Staff_attendance").
    doc("${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}").
    collection("Staffs").doc(staffid).
    set(
        {
          "Staffattendance":true,
          "Staffname":staffname,
          "Staffregno":staffregno,
          "Staffid":staffid,
          "Class":section,
          "Date":"${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          "Time":DateFormat("h:mma").format(DateTime.now()),
          "timstamp":DateTime.now().millisecondsSinceEpoch,
        }

        );


  }

  String staffid="";
  String staffname="";
  String staffregno="";
  String staffimg="";
  int status=0;


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
      if(staffid.isNotEmpty){
        var staffdocument= await _firestore2db.collection("Staffs").doc(staffid).get();
        Map<String,dynamic>?staffvalue=staffdocument.data();
        var document2 = await  _firestore2db.collection("Staffs").doc(staffid).
        collection("Attendance").where("Date",isEqualTo: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}").get();

        setState(() {
          staffname=staffvalue!['stname'];
          staffregno=staffvalue['regno'];
          staffimg=staffvalue['imgurl'];
          if(document2.docs.length>0){
            status = 3;
          }
          else {
            if (staffvalue['faceid'] == true) {
              status = 1;
            }
            else {
              status = 2;
            }
          }
        });
      }
    };



    print("staffname stff id staff img");
    print(staffname);
    print(staffregno);
    print(staffimg);
  }


  @override
  void initState() {
    setState(() {
      attendance=false;
    });
    getstaffdetails();
    // TODO: implement initState
    super.initState();
  }
  File? _pickedFile2;
  verfiy() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.front).then((xFile) {
      if (xFile != null) {
        setState(() {
          _pickedFile2 = File(xFile.path);
        });
      }
    });
    print("fun one completed");
    print(_pickedFile2!.path);
    print("Fun 2 Starteddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableTracking: true,
      ),
    );

    // Detect faces in an image.

    final inputImage = InputImage.fromFile(_pickedFile2!);
    final faces = await faceDetector.processImage(inputImage);

    // Get the face data as a string.
    final faceData = faces.map((face) {
      final leftEyeLandmark = face.landmarks[FaceLandmarkType.leftEye];
      final leftEyePosition = leftEyeLandmark?.position;
      final rightEyeLandmark = face.landmarks[FaceLandmarkType.rightEye];
      final rightEyePosition = rightEyeLandmark?.position;
      final bottommouthLandmark = face.landmarks[FaceLandmarkType.bottomMouth];
      final bottommouthPosition = bottommouthLandmark?.position;
      final rightmouthLandmark = face.landmarks[FaceLandmarkType.rightMouth];
      final rightmouthPosition = rightmouthLandmark?.position;
      final leftmouthLandmark = face.landmarks[FaceLandmarkType.leftMouth];
      final leftmouthPosition = leftmouthLandmark?.position;
      final nouseLandmark = face.landmarks[FaceLandmarkType.noseBase];
      final nousePosition = nouseLandmark?.position;

      return 'Face id: ${leftEyePosition!.x},${rightEyePosition!.x},${bottommouthPosition!.x},${rightmouthPosition!.x},${leftmouthPosition!.x},${nousePosition!.x},';
    }).join('\n');
    final faceData2 = faces.map((face) async {
      final leftEyeLandmark = face.landmarks[FaceLandmarkType.leftEye];
      final leftEyePosition = leftEyeLandmark?.position;
      final rightEyeLandmark = face.landmarks[FaceLandmarkType.rightEye];
      final rightEyePosition = rightEyeLandmark?.position;
      final bottommouthLandmark = face.landmarks[FaceLandmarkType.bottomMouth];
      final bottommouthPosition = bottommouthLandmark?.position;
      final rightmouthLandmark = face.landmarks[FaceLandmarkType.rightMouth];
      final rightmouthPosition = rightmouthLandmark?.position;
      final leftmouthLandmark = face.landmarks[FaceLandmarkType.leftMouth];
      final leftmouthPosition = leftmouthLandmark?.position;
      final nouseLandmark = face.landmarks[FaceLandmarkType.noseBase];
      final nousePosition = nouseLandmark?.position;
      var documet = await _firestore2db.collection("Staffs").doc(staffid).collection("Facedate").doc(staffid).get();
      Map<String, dynamic>?  value= documet.data();
      int i =0;
      setState(() {
        i=0;
      });
      if(value!["leftEyePositionx"]<=leftEyePosition!.x+100&&value!["leftEyePositionx"]>=leftEyePosition!.x-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["rightEyePositionx"]<=rightEyePosition!.x+100&&value!["rightEyePositionx"]>=rightEyePosition!.x-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["bottommouthPositionx"]<=bottommouthPosition!.x+100&&value!["bottommouthPositionx"]>=bottommouthPosition!.x-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["rightmouthPositionx"]<=rightmouthPosition!.x+100&&value!["rightmouthPositionx"]>=rightmouthPosition!.x-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["leftmouthPositionx"]<=leftmouthPosition!.x+100&&value!["leftmouthPositionx"]>=leftmouthPosition!.x-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["nousePositionx"]<=nousePosition!.x+100&&value!["nousePositionx"]>=nousePosition!.x-100){
        setState(() {
          i=i+1;
        });
      }

      if(value!["leftEyePositiony"]<=leftEyePosition!.y+100&&value!["leftEyePositiony"]>=leftEyePosition!.y-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["rightEyePositiony"]<=rightEyePosition!.y+100&&value!["rightEyePositiony"]>=rightEyePosition!.y-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["bottommouthPositiony"]<=bottommouthPosition!.y+100&&value!["bottommouthPositiony"]>=bottommouthPosition!.y-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["rightmouthPositiony"]<=rightmouthPosition!.y+100&&value!["rightmouthPositiony"]>=rightmouthPosition!.y-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["leftmouthPositiony"]<=leftmouthPosition!.y+100&&value!["leftmouthPositiony"]>=leftmouthPosition!.y-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["nousePositiony"]<=nousePosition!.y+100&&value!["nousePositiony"]>=nousePosition!.y-100){
        setState(() {
          i=i+1;
        });
      }
      if(i==12){
        Marktheattendancefun();
        showmarked();
      }
      else{
        showwwaring2();
      }
      return 'Face id: ${leftEyePosition!.y},${rightEyePosition!.y},${bottommouthPosition!.y},${rightmouthPosition!.y},${leftmouthPosition!.y},${nousePosition!.y},';
    }).join('\n');
    getstaffdetails();

    // Print the face data.
    print(faceData);
    print(faceData2);

    print("Fun 2 Completedddddddddddddddddddddddddddddddddddddddddddddd");
  }
  enroll() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.front,).then((xFile) {
      if (xFile != null) {
        setState(() {
          _pickedFile2 = File(xFile.path);
        });
      }
    });
    print("fun one completed");
    print(_pickedFile2!.path);
    print("Fun 2 Starteddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
    final faceDetector = FaceDetector(    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableTracking: true,
    ),);

    // Detect faces in an image.

    final inputImage = InputImage.fromFile(_pickedFile2!);
    final faces = await faceDetector.processImage(inputImage);

    // Get the face data as a string.
    final faceData = faces.map((face) {
      final leftEyeLandmark = face.landmarks[FaceLandmarkType.leftEye];
      final leftEyePosition = leftEyeLandmark?.position;
      final rightEyeLandmark = face.landmarks[FaceLandmarkType.rightEye];
      final rightEyePosition = rightEyeLandmark?.position;
      final bottommouthLandmark = face.landmarks[FaceLandmarkType.bottomMouth];
      final bottommouthPosition = bottommouthLandmark?.position;
      final rightmouthLandmark = face.landmarks[FaceLandmarkType.rightMouth];
      final rightmouthPosition = rightmouthLandmark?.position;
      final leftmouthLandmark = face.landmarks[FaceLandmarkType.leftMouth];
      final leftmouthPosition = leftmouthLandmark?.position;
      final nouseLandmark = face.landmarks[FaceLandmarkType.noseBase];
      final nousePosition = nouseLandmark?.position;

      return 'Face id: ${leftEyePosition!.x},${rightEyePosition!.x},${bottommouthPosition!.x},${rightmouthPosition!.x},${leftmouthPosition!.x},${nousePosition!.x},';
    }).join('\n');
    final faceData2 = faces.map((face) async {
      final leftEyeLandmark = face.landmarks[FaceLandmarkType.leftEye];
      final leftEyePosition = leftEyeLandmark?.position;
      final rightEyeLandmark = face.landmarks[FaceLandmarkType.rightEye];
      final rightEyePosition = rightEyeLandmark?.position;
      final bottommouthLandmark = face.landmarks[FaceLandmarkType.bottomMouth];
      final bottommouthPosition = bottommouthLandmark?.position;
      final rightmouthLandmark = face.landmarks[FaceLandmarkType.rightMouth];
      final rightmouthPosition = rightmouthLandmark?.position;
      final leftmouthLandmark = face.landmarks[FaceLandmarkType.leftMouth];
      final leftmouthPosition = leftmouthLandmark?.position;
      final nouseLandmark = face.landmarks[FaceLandmarkType.noseBase];
      final nousePosition = nouseLandmark?.position;
      _firestore2db.collection("Staffs").doc(staffid).collection("Facedate").doc(staffid).set({
        "leftEyePositionx":leftEyePosition!.x,
        "rightEyePositionx":rightEyePosition!.x,
        "bottommouthPositionx":bottommouthPosition!.x,
        "rightmouthPositionx":rightmouthPosition!.x,
        "leftmouthPositionx":leftmouthPosition!.x,
        "nousePositionx":nousePosition!.x,
        "leftEyePositiony":leftEyePosition!.y,
        "rightEyePositiony":rightEyePosition!.y,
        "bottommouthPositiony":bottommouthPosition!.y,
        "rightmouthPositiony":rightmouthPosition!.y,
        "leftmouthPositiony":leftmouthPosition!.y,
        "nousePositiony":nousePosition!.y,
      });


      return 'Face id: ${leftEyePosition!.y},${rightEyePosition!.y},${bottommouthPosition!.y},${rightmouthPosition!.y},${leftmouthPosition!.y},${nousePosition!.y},';
    }).join('\n');


    _firestore2db.collection("Staffs").doc(staffid).update({
      "faceid":true
    });
    showsucess();
    // Print the face data.
    print(faceData);
    print(faceData2);
    getstaffdetails();

    print("Fun 2 Completedddddddddddddddddddddddddddddddddddddddddddddd");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Mark Today Attendance"),
      ),
      body: status==1?

      Column(

        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Hi,${staffname}",style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w800,
              fontSize: 25
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Mark your Daily Attendance \nFor Today Now",style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 20,
            ),textAlign: TextAlign.center,),
          ),
         Lottie.asset("assets/faceidd.json"),
          SizedBox(height: 50,),

          GestureDetector(
            onTap: (){
              verfiy();

            },
            child: Container(
              height: 50,
            width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Color(0xff0271C5),
              ),
              child: Center(child: Text("Mark Attendance",style: GoogleFonts.montserrat(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 19),)),
            ),
          ),
          SizedBox(height: 20,),
        /*  GestureDetector(
            onTap: (){
              verfiy();
            },
            child: Container(
              height: 50,
            width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Color(0xff0271C5),
              ),
              child: Center(child: Text("Mark Now",style: GoogleFonts.montserrat(color: Colors.white,fontWeight: FontWeight.bold),)),
            ),
          ),*/


          


        ],
      ) :status==2?
      Column(

        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Hi,${staffname}",style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w800,
                fontSize: 25
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Enroll your Face now to \nMark your Daily Attendance",style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),textAlign: TextAlign.center,),
          ),
          Lottie.asset("assets/saveface.json"),
          SizedBox(height: 50,),

          GestureDetector(
            onTap: (){
              showwwaring();
            },
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Color(0xff0271C5),
              ),
              child: Center(child: Text("Enroll Face",style: GoogleFonts.montserrat(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 19),)),
            ),
          ),
          SizedBox(height: 20,),
          /*  GestureDetector(
            onTap: (){
              verfiy();
            },
            child: Container(
              height: 50,
            width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Color(0xff0271C5),
              ),
              child: Center(child: Text("Mark Now",style: GoogleFonts.montserrat(color: Colors.white,fontWeight: FontWeight.bold),)),
            ),
          ),*/





        ],
      ) : status==3?
      Column(

        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Thanks,${staffname}",style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w800,
                fontSize: 25
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Your attendance is marked \nFor Today",style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),textAlign: TextAlign.center,),
          ),
          Lottie.asset("assets/done.json"),
          SizedBox(height: 50,),

          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Color(0xff0271C5),
              ),
              child: Center(child: Text("OK",style: GoogleFonts.montserrat(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 19),)),
            ),
          ),
          SizedBox(height: 20,),
          /*  GestureDetector(
            onTap: (){
              verfiy();
            },
            child: Container(
              height: 50,
            width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Color(0xff0271C5),
              ),
              child: Center(child: Text("Mark Now",style: GoogleFonts.montserrat(color: Colors.white,fontWeight: FontWeight.bold),)),
            ),
          ),*/





        ],
      ) :
      Center(child: CircularProgressIndicator())
    );
  }


  showwwaring(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/0.8,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Please make sure',
      desc: "Don't wear Eye glasses \nBe in bright area \nDon't wear mask \nBe in the school area",

      btnCancelOnPress: () {

      },
        descTextStyle: TextStyle(

        ),

      btnOkOnPress: () {
        enroll();
      },
      btnOkText: "Continue"
    )..show();


  }
  showwwaring2(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/0.8,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Sorry wrong face,Try Again',


      btnCancelOnPress: () {

      },
        descTextStyle: TextStyle(

        ),

      btnOkOnPress: () {
       verfiy();
      },
      btnOkText: "Try Again"
    )..show();


  }
  showsucess(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/0.8,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Face Enrolled Successfully',
      desc: "",
      btnOkOnPress: () {},
      btnOkText: "Ok"
    )..show();
  }
  showmarked(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/0.8,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Attendance Marked Successfully',
      desc: "",
      btnOkOnPress: () {},
      btnOkText: "Ok"
    )..show();
  }

}

FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);