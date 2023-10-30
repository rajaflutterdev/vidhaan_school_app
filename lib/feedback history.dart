import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart"as http;
import 'package:intl/intl.dart';

import 'const_file.dart';


class Feedbackhistory extends StatefulWidget {
  String studentid;
  String studentname;
  String staffname;
  String studenttoken;
  String staffid;
  String staffauthendicationid;
  Feedbackhistory(this.studentid,this.studentname,this.staffname,this.studenttoken,this.staffid,this.staffauthendicationid);

  @override
  State<Feedbackhistory> createState() => _FeedbackhistoryState();
}

class _FeedbackhistoryState extends State<Feedbackhistory> {


  String dropfedback4 = "Outstanding";
  String dropdownvalueweditvalue = "Outstanding";
  List<String> feedback = ["Outstanding", "Excellent", "Good","Satisfactory", "Focus Needed"];
  TextEditingController remarkscon = new TextEditingController();
  TextEditingController remarkscon1 = new TextEditingController();
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
      body: Padding(
        padding: EdgeInsets.only(
            top: height / 25.2),
        child: Container(

          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.only(topRight: Radius.circular(35),
                  topLeft: Radius.circular(35))),
          child: Padding(
            padding:
            EdgeInsets.only(
                left: width / 36,
                right: width / 36,
                top: height / 94.5),
            child: SingleChildScrollView(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  GestureDetector(
                    onTap: () {
                      setState(() {

                      });
                    },
                    child: Text(
                      widget.studentname,
                      style: GoogleFonts.poppins(
                          color: Colors
                              .blueAccent,
                          fontSize:width/20,
                          fontWeight:
                          FontWeight
                              .w600),
                    ),
                  ),
                  SizedBox(
                      height: height /
                          92.125),
                  Text(
                    "Feedback report",
                    style: GoogleFonts
                        .poppins(
                        color: Colors
                            .grey
                            .shade700,
                        fontSize:width/24,
                        fontWeight:
                        FontWeight
                            .w600),
                  ),

                  SizedBox(
                      height:
                      height / 36.85),

                  Divider(
                    color: Colors.grey.shade400,
                    thickness: 1,
                  ),

                  SizedBox(
                      height: height /
                          42.642),
                  Column(
                      children: [




                        /// today homework


                        Text(
                          'Give Feedback for ${widget.studentname}', style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize:width/20,
                            fontWeight: FontWeight.w700

                        ),),
                        SizedBox(height:height/75.6,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Container(
                              padding: EdgeInsets.only(
                                  left: width / 36, right: width / 36),
                              height: height / 14.74,
                              width: width / 1.065,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              child: TextField(
                                controller: remarkscon,


                                style: GoogleFonts
                                    .poppins(
                                  color: Colors
                                      .black,
                                  fontSize:width/25.714,
                                  fontWeight:
                                  FontWeight
                                      .w500,
                                ),

                                maxLines: 5,
                                minLines: 1,
                                decoration:
                                InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 15),

                                    hintText:
                                    "",
                                    hintStyle:
                                    GoogleFonts
                                        .poppins(
                                      color: Colors
                                          .black,
                                      fontSize:width/25.714,
                                      fontWeight:
                                      FontWeight
                                          .w500,
                                    ),
                                    border:
                                    InputBorder
                                        .none),


                              ),


                            ),


                          ],
                        ),
                        SizedBox(height:height/75.6,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            Container(
                              padding: EdgeInsets.only(
                                  left: width / 36, right: width / 36),
                              height: height / 14.74,
                              width: width / 1.8,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              child:
                              DropdownButton2<String>(
                                value: dropfedback4,
                                isExpanded: true,
                                style: TextStyle(
                                    color: Color(0xff3D8CF8),
                                    fontSize:width/24, fontWeight: FontWeight.w700),
                                underline: Container(
                                  color: Color(0xff3D8CF8),
                                ),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    dropfedback4 = value!;
                                  });
                                },
                                items:
                                feedback.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),


                            ),
                            SizedBox(width: width/24,),
                            GestureDetector(
                              onTap: (){
                                if(remarkscon.text!="") {
                                  submit();
                                  Successdialog();
                                }
                                else{
                                  Errordialog();
                                }
                              },
                              child:
                              Container(
                                padding: EdgeInsets.only(
                                    left: width / 36, right: width / 36),
                                height: height / 14.74,
                                width: width / 3.0,
                                decoration: BoxDecoration(
                                    color: Color(0xff3D8CF8),
                                    border: Border.all(
                                        color: Colors.grey.shade300),
                                    borderRadius:
                                    BorderRadius.circular(10)),
                              child: Center(
                                child: Text("Submit", style: TextStyle(
                                    color: Colors.white,
                                    fontSize:width/18, fontWeight: FontWeight.w700),),
                              ),

                              ),
                            )


                          ],
                        ),
                        Container(
                          padding:
                          EdgeInsets.only(
                              left: width / 18,
                              right: width / 14.4,
                              top: height / 50.4),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .start,
                            children: [
                              Container(
                                width:width /
                                    2.6,
                                child: Text(
                                  "Remarks - Staff",
                                  style: GoogleFonts.poppins(
                                      color: Colors
                                          .black,
                                      fontSize:
                                      15,
                                      fontWeight:
                                      FontWeight
                                          .w600),
                                ),
                              ),
                              SizedBox(width: width/36.0,),

                              SizedBox(width: width/4.5,),
                              Text(
                                "Value",
                                style: GoogleFonts.poppins(
                                    color: Colors
                                        .black,
                                    fontSize:
                                    15,
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        /// Name

                        StreamBuilder(
                            stream: _firestore2db.collection("Students").doc(widget.studentid).collection("Feedback")
                                .orderBy("timestamp",descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {

                              if (snapshot.hasData == null) {
                                return Center(
                                    child: CircularProgressIndicator(
                                      color: Color(
                                          0xff0873c4),
                                    ));
                              }
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator(
                                      color: Color(
                                          0xff0873c4),
                                    ));
                              }
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),

                                  itemCount: snapshot.data!
                                      .docs.length,
                                  itemBuilder: (context,
                                      index) {
                                    return

                                      Container(
                                        margin: EdgeInsets.only(bottom: height/75.6),
                                        child: ListTile(
                                          title:SizedBox(

                                            height:height/37.8,
                                            width: width /
                                                .6,
                                            child:
                                            Text(
                                              "${ snapshot.data!.docs[index]["remarks"]}",
                                              style: GoogleFonts
                                                  .poppins(
                                                  color: Colors
                                                      .black,
                                                  textStyle: TextStyle(overflow: TextOverflow.ellipsis),
                                                  fontSize:
                                                  15,
                                                  fontWeight:
                                                  FontWeight
                                                      .w600),
                                            ),
                                          ),
                                          subtitle:Column(
                                            children: [
                                              Row(
                                                children: [

                                                  SizedBox(

                                                    height:height/50.4,
                                                    width: width /
                                                        2.0,

                                                    child: Text(
                                                      "By ${snapshot.data!
                                                          .docs[index]["staffname"]}",
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: Colors
                                                              .black54,textStyle: TextStyle(overflow: TextOverflow.ellipsis),
                                                          fontSize:
                                                          width/36.0,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),

                                                    ),
                                                  ),

                                                ],
                                              ),
                                              Row(
                                                children: [

                                                  SizedBox(
                                                    height:height/50.4,
                                                    width: width /
                                                        5.8,

                                                    child: Text(
                                                      "${snapshot.data!
                                                          .docs[index]["date"]}",
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: Colors
                                                              .black54,textStyle: TextStyle(overflow: TextOverflow.ellipsis),
                                                          fontSize:
                                                          width/36.0,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),

                                                    ),
                                                  ),

                                                  SizedBox(
                                                    height:height/50.4,
                                                    width: width /
                                                        4.6,

                                                    child: Text(
                                                      "- ${snapshot.data!
                                                          .docs[index]["time"]}",
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: Colors
                                                              .black54,
                                                          fontSize:
                                                          10,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          trailing:GestureDetector(
                                            onTap: (){

                                              print(_firebaseauth2db..currentUser!.uid);
                                              print(widget.staffauthendicationid);
                                              normalpopup(
                                                  snapshot.data!.docs[index].id,
                                                  widget.studentname,
                                                  widget.staffauthendicationid,
                                                  _firebaseauth2db.currentUser!.uid,
                                                  snapshot.data!.docs[index]["remarks"],
                                                  widget. staffname,
                                                  snapshot.data!.docs[index]["value"]
                                              );



                                            },
                                            child: Container(
                                              height: height /
                                                  29.48,
                                              width:
                                              width / 3.4,
                                              //   "Outstanding", "Excellent", "Good","Satisfactory", "Focus Needed"
                                              decoration: BoxDecoration(
                                                  color: snapshot.data!.docs[index]["value"]
                                                      == "Good" ? Colors.yellow
                                                      : snapshot.data!.docs[index]["value"] == "Outstanding"
                                                      ? Color(0xff00A99D):
                                                  snapshot.data!.docs[index]["value"] == "Excellent"
                                                      ? Colors.green:
                                                  snapshot.data!.docs[index]["value"] == "Satisfactory"
                                                      ? Colors.orange:
                                                  snapshot.data!.docs[index]["value"] == "Focus Needed"
                                                      ? Colors.red
                                                      : Colors.orange,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      5)),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [

                                                  Text(
                                                    snapshot.data!.docs[index]["value"],
                                                    style: GoogleFonts
                                                        .poppins(
                                                        color: Colors
                                                            .white,
                                                        fontSize:
                                                        width/27.69,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600),
                                                  ),
                                                  // Icon(
                                                  //   snapshot
                                                  //       .data!
                                                  //       .docs[index]["value"] ==
                                                  //       "Good"
                                                  //       ? Icons
                                                  //       .thumb_up_outlined
                                                  //       : Icons
                                                  //       .thumb_down_alt_outlined,
                                                  //   color: Colors
                                                  //       .white,
                                                  //   size: 16,),
                                                ],
                                              ),
                                            ),
                                          ),




                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.black38,

                                            )
                                          )
                                        ),
                                      );
                                  }
                              );
                            }
                        ),

                        ///  good


                      ]
                  ),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Successdialog() {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return AwesomeDialog(
      width: width/0.8,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Feed Back Submitted Successfully',
      desc: 'Submitted for - ${widget.studentname}',


      btnOkOnPress: () {
setState(() {
  remarkscon.clear();
});
Navigator.of(context).pop();

      },
    )
      ..show();
  }

  Errordialog() {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return AwesomeDialog(
      width: width/0.8,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Please fill all the fields',
      btnOkOnPress: () {


      },
    )
      ..show();
  }


  ///edit the popup dialog
  seditpoup(docid) async {
    _firestore2db.collection("Students").doc(widget.studentid).collection("Feedback").doc(docid).get().then((value){
      setState(() {
        remarkscon1.text= value['remarks'];
        dropdownvalueweditvalue= value['value'];
      });
    });

    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return
      showDialog(

        context: context, builder: (context){
        return
          AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height:height/75.6,),
                  Text(
                    'Edit the Student Feedback', style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize:width/25,
                      fontWeight: FontWeight.w700

                  ),),
                  SizedBox(height:height/75.6,),
                  Text(
                    'Feedback Status', style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize:width/25,
                      fontWeight: FontWeight.w700

                  ),),
                  SizedBox(height:height/75.6,),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: DropdownButton2<String>(
                      value: dropdownvalueweditvalue,
                      isExpanded: true,
                      style: TextStyle(
                          color: Color(0xff3D8CF8),
                          fontSize:width/24, fontWeight: FontWeight.w700),
                      underline: Container(
                        color: Color(0xff3D8CF8),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownvalueweditvalue = value!;
                        });
                      },
                      items:
                      feedback.map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                  ),
                  SizedBox(height:height/75.6,),
                  Text(
                    'Remarks', style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize:width/25,
                      fontWeight: FontWeight.w700

                  ),),
                  SizedBox(height:height/75.6,),
                  Padding(
                    padding:  EdgeInsets.symmetric(
                      horizontal: width/45,
                      vertical: height/94.5
                    ),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: width / 36, right: width / 36),
                      height: height / 4.74,
                      width: width / 1.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.grey.shade300),
                          borderRadius:
                          BorderRadius.circular(10)),
                      child: TextField(
                        controller: remarkscon1,


                        style: GoogleFonts
                            .poppins(
                          color: Colors
                              .black,
                          fontSize:width/25.714,
                          fontWeight:
                          FontWeight
                              .w500,
                        ),

                        maxLines: 5,
                        minLines: 1,
                        decoration:
                        InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15),

                            hintText:
                            "",
                            hintStyle:
                            GoogleFonts
                                .poppins(
                              color: Colors
                                  .black,
                              fontSize:width/25.714,
                              fontWeight:
                              FontWeight
                                  .w500,
                            ),
                            border:
                            InputBorder
                                .none),


                      ),


                    ),
                  ),
                  SizedBox(height: height/18.9,),
                  GestureDetector(
                    onTap: (){
                      updateremarks(docid);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: width / 36, right: width / 36),
                      height: height / 14.74,
                      width: width / 2.363,
                      decoration: BoxDecoration(
                          color: Color(0xff3D8CF8),
                          border: Border.all(
                              color: Colors.grey.shade300),
                          borderRadius:
                          BorderRadius.circular(10)),
                      child: Center(
                        child: Text("Submit", style: TextStyle(
                            color: Colors.white,
                            fontSize:width/18, fontWeight: FontWeight.w700),),
                      ),

                    ),
                  ),
                  SizedBox(height: height/18.9,),

                ],
              ),
            ),
          );
      },);




  }


  ///delete the popup content
  deletedialpopup(docid){

    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return showDialog(context: context, builder: (ctx) =>
        AlertDialog(
          title: Text('Are you sure delete this message'),
          actions: [
            TextButton(onPressed: () {
              _firestore2db.collection("Students").doc(widget.studentid).collection("Feedback").doc(docid)
                  .delete();
              Navigator.pop(context);
            }, child: Text('Delete'))
          ],
        ));
  }


  ///normal popup

  normalpopup(docid,name,authstaffdocid,athendicationid,description,currentstaffname,statustype){

    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
     return showDialog(context: context, builder: (ctx) =>
        AlertDialog(
          title: Center(child: Column(
            children: [
              Text('Feedback By ${currentstaffname.toString()}',style: TextStyle(fontSize: width/22.5,fontWeight: FontWeight.w700),),
              SizedBox(height: height/151.2,),
              Container(
                  padding:  EdgeInsets.symmetric(
                    vertical: height/189,
                    horizontal: width/90,
                  ),
                  decoration: BoxDecoration(
                      color: statustype
                          == "Good" ? Colors.yellow
                          :statustype== "Outstanding"
                          ? Color(0xff00A99D):
                      statustype== "Excellent"
                          ? Colors.green:
                      statustype == "Satisfactory"
                          ? Colors.orange:
                      statustype == "Focus Needed"
                          ? Colors.red
                          : Colors.orange,
                      borderRadius:
                      BorderRadius
                          .circular(
                          5)),
                  child: Text('Feedback Status:  ${statustype.toString()}',style: TextStyle(fontSize: width/30.5,fontWeight: FontWeight.w700,color: Colors.white),)),
            ],
          )),
          actions: [

            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: height/50.4,),
                  Padding(
                    padding:  EdgeInsets.symmetric(
                      vertical: height/189,
                      horizontal: width/90,
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white54,
                            // color: statustype
                            //     == "Good" ? Colors.yellow
                            //     :statustype== "Outstanding"
                            //     ? Color(0xff00A99D):
                            // statustype== "Excellent"
                            //     ? Colors.green:
                            // statustype == "Satisfactory"
                            //     ? Colors.orange:
                            // statustype == "Focus Needed"
                            //     ? Colors.red
                            //     : Colors.orange,
                            // borderRadius:
                            // BorderRadius
                            //     .circular(
                            //     5)),
                        ),padding:  EdgeInsets.symmetric(
                          vertical: height/189,
                          horizontal: width/90,
                        ),
                        child: Text(description,style: TextStyle(fontWeight: FontWeight.w700,fontSize: width/25.714,color: Colors.black),)),
                  ),
                  SizedBox(height: height/50.4,),

                  authstaffdocid==athendicationid?Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          seditpoup(docid);

                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: width / 36, right: width / 36),
                          height: height / 20.74,
                          width: width / 4.363,
                          decoration: BoxDecoration(
                              color: Color(0xff3D8CF8),
                              border: Border.all(
                                  color: Colors.grey.shade300),
                              borderRadius:
                              BorderRadius.circular(10)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Edit", style: TextStyle(
                                  color: Colors.white,
                                  fontSize:width/25, fontWeight: FontWeight.w700),),
                              Icon(Icons.edit,color: Colors.white,size: width/20)

                            ],
                          ),

                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          deletedialpopup(docid);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: width / 36, right: width / 36),
                          height: height / 20.74,
                          width: width / 4.363,
                          decoration: BoxDecoration(
                              color: Color(0xff3D8CF8),
                              border: Border.all(
                                  color: Colors.grey.shade300),
                              borderRadius:
                              BorderRadius.circular(10)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Delete", style: TextStyle(
                                  color: Colors.white,
                                  fontSize:width/25, fontWeight: FontWeight.w700),),
                              Icon(Icons.delete,color: Colors.white,size: width/20,)
                            ],
                          ),

                        ),
                      ),
                    ],
                  ):SizedBox()

                ],
              ),
            ),







          ],
        ));
  }


  updateremarks(docid){
    _firestore2db.collection("Students").doc(widget.studentid).collection("Feedback").doc(docid).update({
      "remarks":remarkscon1.text,
      "value":dropdownvalueweditvalue
    });
    setState(() {
      remarkscon1.clear();
    });
    Navigator.pop(context);

  }


  submit(){
    _firestore2db.collection("Students").doc(widget.studentid).collection("Feedback").doc().set({
      "staffname":widget.staffname,
      "remarks":remarkscon.text,
      "value":dropfedback4,
      "date":"${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "time":"${DateFormat('hh:mm a').format(DateTime.now())}",
      "timestamp":DateTime.now().millisecondsSinceEpoch,
    });

    sendPushMessage(widget.studenttoken,remarkscon.text,"Feedback from Tutor ${widget.staffname}","Feedback");


  }


  sendPushMessage(String token, String body, String title,String Page) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=AAAA9pRd_9E:APA91bGFLaH3PezX-9cPq6c4udZ2lHi5kM3XF6UCdyASEy313xc6SugRk07JiSTzdlSILGA9szuW3DUjyKvtPYttwsgD7oU7D6edQ6Gc9Txvq0EqeMLvrAwcmR2wAaRLh3b1LxStu23m',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title,"page":Page},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);
