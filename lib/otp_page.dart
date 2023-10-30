import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'RiveFilr.dart';
import 'Student_Landing_Page.dart';
import 'app/modules/register_screen/controllers/register_screen_controller.dart';
import 'homepage.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Otppage extends StatefulWidget {

  String phoneController;
  String nameController;
  String staffid;

  Otppage(this.phoneController,this.nameController,this.staffid);
  @override
  State<Otppage> createState() => _OtppageState();
}


class _OtppageState extends State<Otppage> {

  TextEditingController otpController = TextEditingController();

  bool isSelected = false;



  String _deviceId =" ";
  String _deviceIdorg =" ";

  /*&initPlatformState() async {
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

  }

   */
  String usertoken="";
  final registercontroller = Get.put(RegisterScreenController());
  void getToken() async {
    registercontroller.getToken();
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        usertoken=token!;
      });


    });
  }
  @override
  void initState() {
    //initPlatformState();
    print(widget.phoneController);
    print(widget.nameController);
    print(widget.staffid);
    getToken();
    // TODO: implement initState
    super.initState();
    _verifyphone();
  }

  var _verificationCode;

  _verifyphone()async{
    print("Init Fun ction+++++++++++++");
    await _firebaseauth2db.verifyPhoneNumber(
        phoneNumber: "+91${widget.phoneController}" ,
        verificationCompleted:(PhoneAuthCredential credential)async{
          await _firebaseauth2db.signInWithCredential(credential).then((value)async{
            if(value.user!=null){
              print("Valied Otp");
            }
          });
        },
        verificationFailed:(FirebaseAuthException e){
          print(e.message);

          print("Vaerification failed");
        } ,
        codeSent:(String ?verificationid ,int ?resendtoken ){
          print(verificationid);
          print("This ver ID +++++++++++++++++++++++++++++");
          setState(() {
            _verificationCode=verificationid;
          });
        },
        codeAutoRetrievalTimeout:( String verificationid){
          print(verificationid);
          print("This ver ID 22222222 +++++++++++++++++++++++++++++");
          setState(() {
            _verificationCode=verificationid;
          });
        },timeout: Duration(seconds: 120) );

  }

  String otp="";

  bool loading=false;




  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(

      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child:SingleChildScrollView(
              child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(height:height*6/122.83),

                  SizedBox(
                      height:height/ 2.52,
                      width: width/1.2,
                      child: Rivefile()),

                  SizedBox(height:height*4/122.83),


                  Text("OTP Verification ",


                    style: GoogleFonts.montserrat(

                        color: Colors.black,
                        fontWeight: FontWeight.bold,fontSize: 24


                    ),),

                  SizedBox(height:height*4/122.83),


                  Text("Enter The OTP Sent To",


                    style: GoogleFonts.montserrat(

                        color: Colors.grey,
                        fontWeight: FontWeight.w400,fontSize: 18


                    ),),

                  SizedBox(height:height*3/222.83),


                  Text("+ 91 ${widget.phoneController}",


                    style: GoogleFonts.montserrat(

                        color: Colors.black,
                        fontWeight: FontWeight.w600,fontSize: 18


                    ),),

                  SizedBox(height:height*4/122.83),

/*
                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: Color(0xFF512DA8),
                  ),*/
                  Padding(
                    padding:  EdgeInsets.symmetric(
                      vertical: height/94.5,
                      horizontal: width/45
                    ),
                    child: SizedBox(
                      height:height/15.12,
                      child: Pinput(
                        isCursorAnimationEnabled: true,
                        pinContentAlignment: Alignment.center,
                        animationDuration: Duration(microseconds:300),
                        animationCurve: Curves.easeIn,
                        length: 6,
                        closeKeyboardWhenCompleted: true,
                        autofocus: true,
                        pinAnimationType: PinAnimationType.scale,
                        keyboardAppearance:Brightness.dark,
                        onCompleted: (value){
                        setState(() {
                          otp=value;
                        });
                        print(otp);
                      },
                        onSubmitted: (value){
                          setState(() {
                            otp=value;
                          });
                          print(otp);
                        },

                      ),
                    ),
                  ),

                  SizedBox(height:height*4/122.83),


                  Padding(
                    padding:  EdgeInsets.only(left: width/24,right: width/36,top: height/75.6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [


                        InkWell(
                          onTap: (){
                            _verifyphone();
                            Fluttertoast.showToast(
                                msg: "OTP Resent Successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          },
                          child: RichText(
                            text: TextSpan(

                                text:"Didn't You receive the OTP? ",
                                style: GoogleFonts.montserrat(
                                    color: Colors.grey.shade700,
                                    fontSize: 14

                                ),
                                children: <TextSpan>[

                                  TextSpan(text: "Resend OTP",
                                      style: GoogleFonts.montserrat(color: Color(0xff1D3BFF),
                                      fontSize: 14
                                  ),



                                  ),




                                ]


                            ),


                          ),
                        ),




                      ],
                    ),
                  ),

                  SizedBox(height:height*4/81.881 ),


                  Material(
                    borderRadius: BorderRadius.circular(15),
                    elevation: 5,
                    shadowColor: Color(0xff0873C4),

                    child: InkWell(
                      onTap: ()async{
                        print("Print 1");
                        setState(() {
                          loading=true;
                        });
                        print(_verificationCode);
                        print(otp);

                        _firebaseauth2db.signInWithCredential(
                            PhoneAuthProvider.credential(
                                verificationId: _verificationCode,
                                smsCode: otp)).then((value) => {
                          if(value.user!=null){

                            print("User not null+++++++++++++++++++++++"),
                            if(widget.nameController=="Teacher"){

                              print("Teacher login+++++++++++++++++++++++"),
                              print(_firebaseauth2db.currentUser!.uid),
                              print(usertoken),
                              _firestore2db.collection("Staffs").doc(widget.staffid).update({
                                "userid":_firebaseauth2db.currentUser!.uid,
                                "token":usertoken
                              }),
                              _firestore2db.collection('deviceid').doc(_firebaseauth2db.currentUser!.uid).set({
                                "id":_firebaseauth2db.currentUser!.uid,
                                "type":"Teacher",
                              }),
                        print("++++++++++++++++++++++++Push Successful"),
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context)=> Homepage()),(Route<dynamic> route) => false),
                            },

                            if(widget.nameController=="Student"){
                        print("Student login================================="),
                        print(_firebaseauth2db.currentUser!.uid),
                        print(usertoken),
                              _firestore2db.collection("Students").doc(widget.staffid).update({
                                "studentid":_firebaseauth2db.currentUser!.uid,
                                "token":usertoken
                              }),
                              _firestore2db.collection('deviceid').doc(_firebaseauth2db.currentUser!.uid).set({
                                "id":_firebaseauth2db.currentUser!.uid,
                                "type":"Student",
                              }),
                        print("++++++++++++++++++++++++Push Successful"),
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context)=> Student_landing_Page("",false)),(Route<dynamic> route) => false),
                            },


                          }
                          else{
                            print("User Null+++++++++++++++++++++++"),
                          }
                        });


                      },
                      child: Container(
                        height: height*7/92.125,
                        width: width*14/23.75,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff0873C4),
                              Color(0xff3786F7),
                            ]
                          ),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Verify",
                              style: GoogleFonts.montserrat(

                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,fontSize:24


                              ),),

                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height:height*3/222.83),


              Container(
                height: height*1/92.125,
                width: width*8/23.75,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(6)
                ),
              )
                ],
              ),
            ),
          ),
          loading==true?Container(
            height: height/2.52,
            width: width/1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),

          ),
            child: Lottie.asset("assets/Loadingvi.json")
          ):SizedBox()
        ],
      ),

    );
  }
  
  showpopup(){
    showDialog(context: context, builder: (context) {
      
      return AlertDialog(
        backgroundColor: Colors.white,
        content: SizedBox(
          child: Column(
            children: [
              Text("Please Wait Verifying Your Number",style: GoogleFonts.montserrat(),),

            ],
          ),
        ),
      );
    },);
  }
}

FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);