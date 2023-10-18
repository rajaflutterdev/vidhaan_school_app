import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Profile_More_Page.dart';
import 'Profileview.dart';
import 'Today Presents_Page.dart';
import 'demo.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String staffid="";
  String staffname="";
  String staffregno="";

  getstaffdetails() async {
    var document = await _firestore2db.collection("Staffs").get();
    for(int i=0;i<document.docs.length;i++){
      if(document.docs[i]["userid"]==_firebaseauth2db.currentUser!.uid){
        setState(() {
          staffid=document.docs[i].id.toString();
        });
      }
      if(staffid.isNotEmpty){
        var staffdocument= await _firestore2db.collection("Staffs").doc(staffid).get();
        Map<String,dynamic>?staffvalue=staffdocument.data();
        setState(() {
          staffname=staffvalue!['stname'].toString();
          staffregno=staffvalue['regno'].toString();

        });
      }
    }

  }




  @override
  void initState() {
    getstaffdetails();
    // TODO: implement initState
    super.initState();
  }

  int selectedMenu=0;
  var popiconani=kAlwaysDismissedAnimation;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: staffid.toString()!=""?
      FutureBuilder<dynamic>(
        future: _firestore2db.collection("Staffs").doc(staffid.toString()).get(),
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

                                      Text(y1["mobile"].toString(),
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
                                        y1["email"].toString(), style: GoogleFonts.poppins(
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

                                      Text( y1["entrydate"].toString(), style: GoogleFonts.poppins(
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

                                      Text( y1["bloodgroup"].toString(), style: GoogleFonts.poppins(
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
                                  y1['Maritalstatus']=="Married"?
                                  Row(
                                    children: [

                                      SizedBox(
                                        width:width/3.60,

                                        child: Text("Spouse Name ", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),

                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Spousename"].toString()}", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                    ],
                                  ):
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

                                        child: Text(": ${y1["Spousename"].toString()}", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                                y1['Maritalstatus']=="Married"?
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width / 25, right: width / 45,
                                      top: height / 94.5, bottom: height / 94.5),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:width/3.60,

                                        child: Text("Spouse Phone  ", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Spousephone"].toString()}", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                    ],
                                  ),
                                ):
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width / 25, right: width / 45,
                                      top: height / 94.5, bottom: height / 94.5),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:width/3.60,

                                        child: Text("Father Phone  ", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Spousephone"].toString()}", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                                y1['Maritalstatus']=="Married"?
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width / 25, right: width / 45,
                                      top: height / 94.5, bottom: height / 94.5),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:width/3.60,

                                        child: Text("Spouse Email ", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Spouseemail"].toString()}", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                    ],
                                  ),
                                ):
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width / 25, right: width / 45,
                                      top: height / 94.5, bottom: height / 94.5),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:width/3.60,

                                        child: Text("Father Email ", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Spouseemail"].toString()}", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                                y1['Maritalstatus']=="Married"?
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width / 25, right: width / 45,
                                      top: height / 94.5, bottom: height / 94.5),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:width/3.60,

                                        child: Text("Spouse Aadhaar No ", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Spouseaadhaar"].toString()}", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                    ],
                                  ),
                                ):
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width / 25, right: width / 45,
                                      top: height / 94.5, bottom: height / 94.5),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:width/3.60,

                                        child: Text("Father Aadhaar No ", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Spouseaadhaar"].toString()}", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                                y1['Maritalstatus']=="Married"?
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width / 25, right: width / 45,
                                      top: height / 94.5, bottom: height / 94.5),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:width/3.60,

                                        child: Text("Spouse Office ", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Spouseoffice"].toString()}", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                    ],
                                  ),
                                ):
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width / 25, right: width / 45,
                                      top: height / 94.5, bottom: height / 94.5),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:width/3.60,

                                        child: Text("Father Office ", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Spouseoffice"].toString()}", style: GoogleFonts.poppins(
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

                                        child: Text("Seminar/Workshop", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Seminar/Workshop"].toString()}", style: GoogleFonts.poppins(
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

                                        child: Text("Subject", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Subject"].toString()}", style: GoogleFonts.poppins(
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

                                        child: Text("School Last", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["School Last"].toString()}", style: GoogleFonts.poppins(
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

                                        child: Text("Specialisation", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Specialisation"].toString()}", style: GoogleFonts.poppins(
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

                                        child: Text("Work Experience", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Work Experience"].toString()}", style: GoogleFonts.poppins(
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

                                        child: Text("Language Known", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Language Known"].toString()}", style: GoogleFonts.poppins(
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

                                        child: Text(": ${y1["dob"].toString()}", style: GoogleFonts.poppins(
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

                                        child: Text(": ${y1["community"].toString()}", style: GoogleFonts.poppins(
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

                                        child: Text(": ${y1["religion"].toString()}", style: GoogleFonts.poppins(
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

                                        child: Text(": ${y1["aadhaarno"].toString()}", style: GoogleFonts.poppins(
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
                                        child: Text("Married Status", style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500

                                        ),),
                                      ),
                                      SizedBox(
                                        width:width/1.714,

                                        child: Text(": ${y1["Maritalstatus"].toString()}", style: GoogleFonts.poppins(
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

                                        child: Text(": ${y1["address"].toString()}", style: GoogleFonts.poppins(
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
                                                MaterialPageRoute(builder: (context)=>Profileview2(y1['imgurl'].toString()))
                                            );},
                                          child: Container(
                                            width: 130,
                                            height: 130,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(150),
                                                child: CachedNetworkImage(
                                                    imageUrl:y1['imgurl'].toString())),

                                          ),
                                        )
                                      ),

                                      Padding(
                                        padding:  EdgeInsets.only(top:height/7.56,left: width/5.142),
                                        child: SizedBox(
                                          child: CircularPercentIndicator(
                                              radius: 55,
                                              lineWidth: 12.0,
                                              percent: 0.76,
                                              center:  Text("76%",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: width/15,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white)),
                                              backgroundColor: Colors.white,
                                              linearGradient: const LinearGradient(begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: <Color>[
                                                    Colors.lightGreen,
                                                    Colors.green
                                                  ]),
                                              rotateLinearGradient: true,
                                              circularStrokeCap: CircularStrokeCap.round),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 5,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: width / 12),
                                            child: Text(
                                              y1["stname"].toString(), style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold

                                            ),),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: width / 12),
                                            child: Text("ID : ${y1["regno"].toString()}",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500

                                              ),),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: width / 12),
                                            child: Text("Designation : ${y1["designation"].toString()}",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500

                                              ),),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 19,),
                                      Container(
                                        height: 60,
                                        child: VerticalDivider(
                                          width: 2,
                                          color: Colors.white,

                                        ),
                                      ),
                                      SizedBox(width: 19,),
                                      Text("Profile \nCompleted", style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold

                                      ),
                                      textAlign: TextAlign.center,)
                                      // GestureDetector(
                                      //   onTap:(){
                                      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Today_Presents_Page(y1["stname"],y1["regno"]) ,));
                                      //   },
                                      //   child: Container(
                                      //     height: height / 18.9,
                                      //     width: width / 2.168,
                                      //     margin: EdgeInsets.only(),
                                      //     decoration: BoxDecoration(
                                      //       color: Colors.white,
                                      //       borderRadius: BorderRadius.circular(20),
                                      //
                                      //     ),
                                      //     child: Center(
                                      //       child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         children: [
                                      //           Text("Check - IN/OUT",
                                      //             style: GoogleFonts.poppins(
                                      //                 color: Color(0xff0873C4),
                                      //                 fontSize: 16,
                                      //                 fontWeight: FontWeight.bold
                                      //
                                      //             ),),
                                      //
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),


                                ],
                              ),

                              Positioned(
                                bottom: height / 9.45, left: width / 3.6,
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

              Padding(
                padding:  EdgeInsets.only(left:width/1.161,top:height/21.6),
                child: PopupMenuButton(
                  position: PopupMenuPosition.under,
                  initialValue: selectedMenu,
                  color: Colors.white,
                  tooltip: "More",
                  onOpened: (){
                    setState(() {
                      popiconani=kAlwaysCompleteAnimation;

                    });
                  },
                  onCanceled: (){
                    setState(() {
                      popiconani=kAlwaysDismissedAnimation;

                    });
                  },
                  icon: AnimatedIcon(icon: AnimatedIcons.menu_close,progress: popiconani,),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  // Callback that sets the selected popup menu item.
                  onSelected: (item) {
                    setState(() {
                      selectedMenu = item;
                    });
                    print(selectedMenu);

                    if(selectedMenu==1){
                      setState(() {
                        popiconani=kAlwaysDismissedAnimation;
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => More_Menu_Page(),));
                    }
                    if(selectedMenu==2){
                      setState(() {
                        popiconani=kAlwaysDismissedAnimation;
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => More_Menu_Page(),));
                    }
                    if(selectedMenu==3){
                      setState(() {
                        popiconani=kAlwaysDismissedAnimation;
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => More_Menu_Page(),));
                    }

                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                     PopupMenuItem(
                      value: 1,
                      child: Text('About Vidhaan'),
                      textStyle:
                      GoogleFonts
                          .poppins(
                        color: Colors
                            .black,
                        fontSize: 14,
                        fontWeight:
                        FontWeight
                            .w500,
                      ),
                    ),

                     PopupMenuItem(
                      value: 3,
                      child: Text('Contact Support'),
                      textStyle:
                      GoogleFonts
                          .poppins(
                      color: Colors
                          .black,
                      fontSize: 14,
                      fontWeight:
                      FontWeight
                          .w500,
                    ),
                    ),
                  ],
                ),
              ),


            ],
          );


        } ) : Center(child: CircularProgressIndicator(),),

    );
  }
}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);