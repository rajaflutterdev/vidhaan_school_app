import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Feedbackhistory extends StatefulWidget {
  String studentid;
  String studentname;
  String staffname;
  Feedbackhistory(this.studentid,this.studentname,this.staffname);

  @override
  State<Feedbackhistory> createState() => _FeedbackhistoryState();
}

class _FeedbackhistoryState extends State<Feedbackhistory> {
  String dropfedback4 = "Outstanding";
  List<String> feedback = ["Outstanding", "Excellent", "Good","Satisfactory", "Focus Needed"];
  TextEditingController remarkscon = new TextEditingController();
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
                          fontSize: 18,
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
                        fontSize: 15,
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
                            fontSize: 18,
                            fontWeight: FontWeight.w700

                        ),),
                        SizedBox(height: 10,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Container(
                              padding: EdgeInsets.only(
                                  left: width / 36, right: width / 36),
                              height: height / 14.74,
                              width: width / 1.1,
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
                                  fontSize: 14,
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
                                      fontSize: 14,
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
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            Container(
                              padding: EdgeInsets.only(
                                  left: width / 36, right: width / 36),
                              height: height / 14.74,
                              width: width / 2.363,
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
                                    fontSize: 15, fontWeight: FontWeight.w700),
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
                                    fontSize: 20, fontWeight: FontWeight.w700),),
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
                              SizedBox(width: 10,),
                              Text(
                                "Date \nTime",
                                style: GoogleFonts.poppins(
                                    color: Colors
                                        .black,
                                    fontSize:
                                    15,
                                    fontWeight:
                                    FontWeight
                                        .w600),
                              ),
                              SizedBox(width: 40,),
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

                                      GestureDetector(
                                        onLongPress: (){
                                          showDialog(context: context, builder: (ctx) =>
                                              AlertDialog(
                                                title: Text('Are you sure delete this message'),
                                                actions: [
                                                  TextButton(onPressed: () {
                                                    _firestore2db.collection("Students").doc(widget.studentid).collection("Feedback").doc(snapshot.data!
                                                        .docs[index].id)
                                                        .delete();
                                                    Navigator.pop(context);
                                                  }, child: Text('Delete'))
                                                ],
                                              ));
                                        },
                                        child: Container(
                                          padding:
                                          EdgeInsets.only(
                                            left: width / 18,

                                            top: height /
                                                50.4,),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: width /
                                                        2.6,

                                                    child: Text(
                                                      snapshot.data!
                                                          .docs[index]["remarks"],
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: Colors
                                                              .black,
                                                          fontSize:
                                                          15,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width /
                                                        2.6,

                                                    child: Text(
                                                    "- ${snapshot.data!
                                                        .docs[index]["staffname"]}",
                                                    style: GoogleFonts
                                                        .poppins(
                                                    color: Colors
                                                        .black54,
                                                          fontSize:
                                                          13,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Column(
                                                children: [
                                                  SizedBox(
                                                    width: width /
                                                        4.25,

                                                    child: Text(
                                                      snapshot.data!
                                                          .docs[index]["date"],
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: Colors
                                                              .black,
                                                          fontSize:
                                                          15,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width /
                                                        7.25,

                                                    child: Text(
                                                      snapshot.data!
                                                          .docs[index]["time"],
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: Colors
                                                              .black,
                                                          fontSize:
                                                          15,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: height /
                                                    29.48,
                                                width:
                                                width / 3.6,
                                                decoration: BoxDecoration(
                                                    color: snapshot
                                                        .data!
                                                        .docs[index]["value"] ==
                                                        "Good"
                                                        ? Colors
                                                        .green
                                                        : snapshot
                                                        .data!
                                                        .docs[index]["value"] ==
                                                        "Bad"
                                                        ? Colors
                                                        .red
                                                        : Colors
                                                        .orange,
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
                                                      snapshot
                                                          .data!
                                                          .docs[index]["value"],
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: Colors
                                                              .white,
                                                          fontSize:
                                                          15,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                    Icon(
                                                      snapshot
                                                          .data!
                                                          .docs[index]["value"] ==
                                                          "Good"
                                                          ? Icons
                                                          .thumb_up_outlined
                                                          : Icons
                                                          .thumb_down_alt_outlined,
                                                      color: Colors
                                                          .white,
                                                      size: 16,),
                                                  ],
                                                ),
                                              ),





                                            ],
                                          ),
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
    return AwesomeDialog(
      width: 450,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Feed Back Submitted Successfully',
      desc: 'Submitted for - ${widget.studentname}',


      btnOkOnPress: () {
setState(() {
  remarkscon.clear();
});

      },
    )
      ..show();
  }
  Errordialog() {
    return AwesomeDialog(
      width: 450,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Please fill all the fields',
      btnOkOnPress: () {


      },
    )
      ..show();
  }
  submit(){
    _firestore2db.collection("Students").doc(widget.studentid).collection("Feedback").doc().set({
      "staffname":widget.staffname,
      "remarks":remarkscon.text,
      "value":dropfedback4,
      "date":"${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "time":"${DateTime.now().hour}:${DateTime.now().minute}",
      "timestamp":DateTime.now().millisecondsSinceEpoch,
    });
  }
}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);
