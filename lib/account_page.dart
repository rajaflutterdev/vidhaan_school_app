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
  bool loading=false;

  final List<String> items = ["Student","Teacher"];
  String? selectedValue;
  bool Student= true;
  bool teacher= false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
      body:
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 190.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width/5.22666667,
                  height: height/19.575,
                  decoration: BoxDecoration(
                      color: Color(0xff0271c5
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10),
                      )
                  ),
                  child: Center(
                    child: Text(
                      "Support",style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: width/28,
                        fontWeight: FontWeight.w500,
                        backgroundColor: Colors.transparent,

                    ),

                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(

                  width: width/5.22666667,
                  height: height/19.575,
                  decoration: BoxDecoration(
                    color: Color(0xff0271c5
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    )
                  ),
                  child: Center(
                    child: Text(
                      "T&C",style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: width/24.5,
                        fontWeight: FontWeight.w500,
                        backgroundColor: Colors.transparent
                    ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: height/6.80869565),
                  child: Container(
                      width: width/3.01538462,
                      height: height/6.02307692,
                      child: Image.asset("assets/VIDHAAN LOGO-3.png")),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height/14.23636364),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: width/9.8,),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ActionChip(
                          disabledColor: Colors.transparent,
                          side: BorderSide(
                            color: student==false?Colors.black12 : Color(0xff3D8CF8)
                          ),


                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),

                          ),
                          shadowColor: Color(0xff3D8CF8),
                          color: MaterialStateProperty.all<Color>(Color(0xff3D8CF8)),
                          backgroundColor: student==false?Colors.transparent: Color(0xff3D8CF8).withOpacity(0.10),
                          avatar: Icon(student ? Icons.task_alt_rounded : Icons.task_alt_rounded,

                              color: student? Color(0xff3D8CF8): Colors.black38
                          ),
                          label:  Text('Student',style: GoogleFonts.poppins(
                            color: student? Colors.black: Colors.black,
                            fontSize: 15,
                            fontWeight: student? FontWeight.w500 :FontWeight.w500,
                            backgroundColor: Colors.transparent
                          ),),
                          onPressed: () {
                            setState(() {
                              if(student==false) {
                                student = !student;
                                teacher=false;
                                _backgroundColor="Student";
                              }
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ActionChip(
                          disabledColor: Colors.transparent,
                          side: BorderSide(
                            color: teacher==false?Colors.black12 : Color(0xff3D8CF8)
                          ),


                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),

                          ),
                          shadowColor: Color(0xff3D8CF8),
                          color: MaterialStateProperty.all<Color>(Color(0xff3D8CF8)),
                          backgroundColor: teacher==false?Colors.transparent: Color(0xff3D8CF8).withOpacity(0.10),
                          avatar: Icon(teacher ? Icons.task_alt_rounded : Icons.task_alt_rounded,

                              color: teacher? Color(0xff3D8CF8): Colors.black38
                          ),
                          label:  Text('Staff    ',style: GoogleFonts.poppins(
                            color: teacher? Colors.black: Colors.black,
                            fontSize: width/26.13333333,
                            fontWeight: teacher? FontWeight.w500 :FontWeight.w500,
                            backgroundColor: Colors.transparent
                          ),),
                          onPressed: () {
                            setState(() {
                              if(teacher==false) {
                                teacher = !teacher;
                                student=false;
                                _backgroundColor="Teacher";
                              }

                            });
                          },
                        ),
                      ),
                      SizedBox(width: width/9.8,),
                    ],
                  ),
                ),
                SizedBox(
                  height: height/11.18571429,
                ),

                Container(
                  width: width/1.30666667,
                  height: height/7.83,
                  child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(


                      label: Text("Phone Number",style: GoogleFonts.poppins(
                          color: Color(0xff3D8CF8),
                          fontSize: width/23.05882353,
                          fontWeight: FontWeight.w500,
                          backgroundColor: Colors.transparent
                      ),)
                    ),

                  ),
                ),
                SizedBox(
                  height: height/26.1,
                ),

                Material(
                  borderRadius: BorderRadius.circular(15),
                  shadowColor: Color(0xff0271c5).withOpacity(0.80),
                  elevation: 4,

                  child: GestureDetector(
                    onTap: (){
                      updatestaff();
                    },
                    child: Container(
                      width: width/1.225,
                      height: height/13.05,
                      decoration: BoxDecoration(color: Color(0xff0271c5).withOpacity(0.80),

                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Color(0xff0271c5).withOpacity(0.80),)
                      ),
                      child: Center(
                          child: Text("Login Now", style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: size.width/20.84,
                              color: Colors.white
                          ),)
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height/7.83,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width/26.13333333),
                  child: Text("Powered by",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: size.width/35.84,
                        color: Colors.black38
                    ),

                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Vidhaan Educare Pvt Ltd",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: size.width/35.84,
                            color: Color(0xff0271c5)
                        ),

                      ),
                    )
                  ],
                )
              ],
            ),
          ),
         loading ==true? Center(
            child: CircularProgressIndicator(
              color: Color(0xff3D8CF8),
            ),
          ): SizedBox()
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
      loading=true;
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

      btnOkOnPress: () {
        setState(() {
          loading=false;
        });

      },
    )..show();
  }
}

FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);
