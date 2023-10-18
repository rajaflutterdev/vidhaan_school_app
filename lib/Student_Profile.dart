import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Profile_More_Page.dart';
import 'Profileview.dart';
import 'Today Presents_Page.dart';

class Student_Profile extends StatefulWidget {
String ?stuid;
Student_Profile(this.stuid);

  @override
  State<Student_Profile> createState() => _Student_ProfileState();
}

class _Student_ProfileState extends State<Student_Profile> {
  int selectedMenu=0;

  String stuname='';
  String sturegno='';
  String stuimg='';

  getstaffdetails() async {
    print(widget.stuid);
    var document2 =  await _firestore2db.collection("Students").doc(widget.stuid).get();
    Map<String,dynamic>? value = document2.data();
    setState(() {
      stuname=value!["stname"];
      sturegno=value["regno"];
    });
    print(stuname);
  }

  @override
  void initState() {
    getstaffdetails();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return
      Scaffold(body: FutureBuilder<dynamic>(
          future: _firestore2db.collection("Students").doc(widget.stuid.toString()).get(),
          builder:(context , value) {

            if(value.hasData==null){
              return Center(child: CircularProgressIndicator(
                color: Color(0xff0873c4),
              ));
            }
            if(!value.hasData){
              return Center(child: CircularProgressIndicator(
                color: Color(0xff0873c4),
              ));
            }

            var y1 = value.data.data!();
            return Stack(
              children: [

                SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                      children: [

                        Padding(
                          padding: EdgeInsets.only(top:height/2.2009),
                          child: Column(
                            children: [

                              Container(
                                margin: EdgeInsets.only(left: width / 36,
                                    right: width / 36,
                                    top: height / 930),
                                height: height / 4.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        spreadRadius: 1.0,

                                        offset: Offset(0, 0.5),
                                        color: Colors.black12,
                                        blurRadius: 2.0,

                                      ),

                                    ]
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height:height/75.6),
                                    Padding(
                                      padding:  EdgeInsets.only(left:width/36.0),
                                      child: Text("User Details", style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize:width/24,
                                          fontWeight: FontWeight.w500

                                      ),),
                                    ),
                                    SizedBox(height:height/75.6),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.phone, color: Colors.black,
                                            size: 20,),

                                          SizedBox(width: width / 22,),

                                          Text(y1["mobile"],
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.email_outlined, color: Colors.black,
                                            size: 20,),

                                          SizedBox(width: width / 22,),

                                          Text(
                                            y1["email"], style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500

                                          ),),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.date_range_outlined, color: Colors.black,
                                            size: 20,),
                                          SizedBox(width: width / 22,),

                                          Text( y1["entrydate"], style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500

                                          ),),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.bloodtype, color: Colors.black,
                                            size: 20,),
                                          SizedBox(width: width / 22,),

                                          Text( y1["bloodgroup"], style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500

                                          ),),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),


                              //personal information

                              Container(
                                margin: EdgeInsets.only(left: width / 36,
                                    right: width / 36,
                                    top: height / 37.8),

                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        spreadRadius: 1.0,

                                        offset: Offset(0, 0.5),
                                        color: Colors.black12,
                                        blurRadius: 2.0,

                                      ),

                                    ]
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height:height/75.6),
                                    Padding(
                                      padding:  EdgeInsets.only(left:width/36.0),
                                      child: Text("Personal Information", style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize:width/24,
                                          fontWeight: FontWeight.w500

                                      ),),
                                    ),
                                    SizedBox(height:height/75.6),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child:

                                      Row(
                                        children: [

                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Father Name ", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),

                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["fathername"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child:

                                      Row(
                                        children: [

                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Mother Name ", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),

                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["mothername"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Weight", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["stweight"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Height", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["sheight"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Section", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["section"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),



                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Mother Mobile", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["motherMobile"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Mother Email", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["motherEmail"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Mother Aadhaar", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["motherAadhaar"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Mother Occupation", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["motherOccupation"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //father

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Father Mobile", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["fatherMobile"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Father Email", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["fatherEmail"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Father Aadhaar", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["fatherAadhaar"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Father Occupation", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["fatherOccupation"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //father

                                    //gurdian

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Guardian Name", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["guardianname"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Guardian Mobile", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["guardianMobile"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Guardian Email", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["guardianEmail"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Guardian Aadhaar", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["guardianAadhaar"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Guardian Occupation", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["guardianOccupation"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //gurdian--end

                                    //..botehr
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Brother Name ", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["brothername"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Brother Studying ", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["brother studying here"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //..botehr--end

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Absent Days", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["absentdays"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),


                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Identificatiol Mark", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["identificatiolmark"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Gender", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["gender"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("DOB", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["dob"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Community", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["community"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Religion", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["religion"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Aadhaar No", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["aadhaarno"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Reg No", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["regno"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,
                                            child: Text("Admit Class", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["admitclass"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,
                                            child: Text("Behaviour", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["behaviour"].toString()}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,
                                            child: Text("House", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["house"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,
                                            child: Text("Transport", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["transport"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,
                                            child: Text("Academic", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["academic"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,
                                            child: Text("EMIS", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["EMIS"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 25, right: width / 45,
                                          top: height / 94.5, bottom: height / 94.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/3.60,

                                            child: Text("Address", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                          SizedBox(
                                            width:width/1.714,

                                            child: Text(": ${y1["address"]}", style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height:height / 84.5),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        GestureDetector(
                                          onTap:(){
                                            launch("mailto:socorpkolathur@gmail.com");
                                          },
                                          child: Container(
                                            height: height / 20.9,
                                            width: width / 2.5,
                                            margin: EdgeInsets.only(right: width / 36),
                                            decoration: BoxDecoration(
                                              color: Color(0xff0873C4),
                                              borderRadius: BorderRadius.circular(5),

                                            ),
                                            child: Center(
                                              child: Text("Request For Edit",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize:width/24,
                                                    fontWeight: FontWeight.bold

                                                ),),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height:height / 84.5)









                                  ],
                                ),
                              ),
                              SizedBox(height:height / 84.5)

                            ],
                          ),
                        ),

                      ]
                  ),

                ),

                Container(
                    height: height/2.2909,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/profile back.jpeg")
                        )
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(

                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: height / 9.745, left: width / 12.4),
                                          child: InkWell(
                                            onTap:(){
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (context)=>Profileview2(y1['imgurl']))
                                              );},
                                            child: CircleAvatar(
                                              radius: 64,
                                              backgroundColor: Colors.grey.shade200,
                                              backgroundImage:  NetworkImage(
                                                  y1['imgurl']
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 5,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: width / 12),
                                              child:
                                              Text(
                                                y1["stname"], style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold

                                              ),),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: width / 12),
                                              child: Text("ID : ${y1["regno"]}",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500

                                                ),),
                                            )
                                          ],
                                        ),

                                      ],
                                    ),


                                  ],
                                ),

                                Positioned(
                                  bottom: height / 15.45, left: width / 3.6,
                                  child: const CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.create_outlined,
                                        color: Colors.black, size: 26,)
                                  ),
                                )

                              ]
                          ),
                        ),

                      ],
                    )),

                /*  Padding(
                  padding:  EdgeInsets.only(left:width/1.161,top:height/21.6),
                  child: PopupMenuButton(
                    position: PopupMenuPosition.under,
                    initialValue: selectedMenu,
                    color: Colors.white,
                    tooltip: "More",
                    // Callback that sets the selected popup menu item.
                    onSelected: (item) {
                      setState(() {
                        selectedMenu = item;
                      });
                      print(selectedMenu);

                      if(selectedMenu==1){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => More_Menu_Page(),));
                      }
                      if(selectedMenu==2){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => More_Menu_Page(),));
                      }
                      if(selectedMenu==3){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => More_Menu_Page(),));
                      }

                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      const PopupMenuItem(
                        value: 1,
                        child: Text('Today Presents'),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Text('Today Absents'),
                      ),
                      const PopupMenuItem(
                        value: 3,
                        child: Text('HR(Pay roll)'),
                      ),
                    ],
                  ),
                ),*/

                Padding(
                  padding:  EdgeInsets.only(left:170,top:100),
                  child: Container(
                      height:100,
                      width:220,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                          ),
                          color:Colors.white
                      ),

                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height:5),
                          Text(
                            "Studying Classes", style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold

                          ),),
                          SizedBox(height:5),
                          Text(
                            "${y1["admitclass"]} ${y1["section"]}", style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold

                          ),),
                        ],
                      )
                  ),
                )








              ],
            );


          } ),);
  }
}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);