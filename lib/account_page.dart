import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vidhaan_school_app/otp_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Accountpage extends StatefulWidget {
  const Accountpage({Key? key}) : super(key: key);

  @override
  State<Accountpage> createState() => _AccountpageState();
}
List<String> mot=<String>["Student","Teacher"];
class _AccountpageState extends State<Accountpage> {
  bool isSelected = false;


  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  double targetValue = 240;
  bool anim=false;

  @override
  void initState() {
    setState(() {
      anim=true;
      hide=false;
    });

    // TODO: implement initState
    super.initState();
  }
  bool hide=false;

  final List<String> items = ["Student","Teacher"];
  String? selectedValue;
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(

      body:
      Stack(
        children: [
          FlutterLogin(

            loginProviders: [],

            logo: "assets/TextWhitelogo.png",
            logoTag: "Educare",
            titleTag:"",userType: LoginUserType.name,


            onLogin: (LoginData) {
              setState(() {
                phoneController.text=LoginData.password;

              });
              updatestaff();
              print("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
              print(phoneController.text);
              print(nameController.text );
              print(_backgroundColor);
              print(LoginData.name);
              print(LoginData.password);
            },
            onRecoverPassword: (String ) {  },
            additionalSignupFields: [

            ],

          ),
          hide==false?
          Padding(
        padding:  EdgeInsets.only(left:width/ 6,top: height/2.7),
        child: Row(
          children: [
            RadioMenuButton(value: "Student", groupValue: _backgroundColor, onChanged: (val){
              setState(() {
                _backgroundColor="Student";
              });

            }, child: Text("Student")),
            RadioMenuButton(
              style: ButtonStyle(

              ),

                value: "Teacher", groupValue: _backgroundColor, onChanged: (val){
              setState(() {
                _backgroundColor="Teacher";
              });

            }, child: Text("Teacher"))
          ],
        ),
      ):SizedBox()
        ],
      )



    );
  }

  String _backgroundColor = "Student";
  String studentid="";
  bool student=true;
  int studentlength=0;

  String staffid="";
  int staffidlength=0;
  updatestaff() async {
    setState(() {
      studentid='';
      staffid='';
      studentlength=0;
      staffidlength=0;
    });
   if(_backgroundColor=="Teacher"){
     var document = await _firestore2db.collection("Staffs").get();
     for(int i=0;i<document.docs.length;i++){
       if(document.docs[i]["mobile"]==phoneController.text){
         setState(() {
           staffid=document.docs[i].id;
           staffidlength=staffidlength+1;
         });
       }
     };
     if(staffidlength<1){
        errordialog();
     }
     else{
       await Future.delayed(Duration(milliseconds: 850),(){
         setState(() {
           hide=true;
         });
       });
       await  Future.delayed(Duration(milliseconds: 2400),(){

         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Otppage(
           phoneController.text,
           _backgroundColor,
           staffid,
         )));
       });
     }
  }
    else{
     print("Student enter");
     var document2 = await _firestore2db.collection("Students").orderBy("stname").get();
     print(document2.docs.length);
     for(int j=0;j<document2.docs.length;j++){

       if(document2.docs[j]["mobile"]==phoneController.text){
         setState(() {
           studentid=document2.docs[j].id;
           studentlength=studentlength+1;
         });
       }
     };
     if(studentlength<1){
       errordialog();

     }
     else{
       await Future.delayed(Duration(milliseconds: 850),(){
         setState(() {
           hide=true;
         });
       });
       await Future.delayed(Duration(milliseconds: 2400),(){
         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Otppage(
           phoneController.text,
           _backgroundColor,
           studentid,
         )));
       });
     }
   }
  }

  errordialog(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/0.8,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Invalid Phone Number',
      desc: 'Sorry, Could not find your phone number',

      btnCancelOnPress: () {

      },
      btnOkOnPress: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Accountpage()));

      },
    )..show();
  }
}

FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);