import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vidhaan_school_app/photoviewpage.dart';


class AssigmentsST extends StatefulWidget {
  String docid;
  String classes;
  String sec;
  String stname;
  String stregno;
  String date;
  String type;
  AssigmentsST(this.docid,this.classes,this.sec,this.stname,this.stregno,this.date,this.type);

  @override
  State<AssigmentsST> createState() => _AssigmentsSTState();
}

class _AssigmentsSTState extends State<AssigmentsST> {


  File? _pickedFile;
  File? _pickedFile2;
  File? _pickedFile3;
  File? _pickedFile4;
  File? _pickedFile5;
  String imageurl1="";
  String imageurl2="";
  String imageurl3="";
  String imageurl4="";
  String imageurl5="";
  int status = 0;

  add() async {
    int status = 1;
    if(_pickedFile!=null) {
      var ref = _firebaseStorage2.ref().child('ListImages').child(
          "${_pickedFile!.path}.jpg");

      var uploadTask2 = await ref.putFile(_pickedFile!).catchError((
          error) async {
        status = 0;
      });


      if (status == 1) {
        imageurl1 = await uploadTask2.ref.getDownloadURL();


        print(imageurl1);
      }
    }
    if(_pickedFile2!=null) {
      var ref = _firebaseStorage2.ref().child('ListImages').child(
          "${_pickedFile2!.path}.jpg");

      var uploadTask2 = await ref.putFile(_pickedFile2!).catchError((
          error) async {
        status = 0;
      });


      if (status == 1) {
        imageurl2 = await uploadTask2.ref.getDownloadURL();


        print(imageurl2);
      }
    }
    if(_pickedFile3!=null) {
      var ref = _firebaseStorage2.ref().child('ListImages').child(
          "${_pickedFile3!.path}.jpg");

      var uploadTask2 = await ref.putFile(_pickedFile3!).catchError((
          error) async {
        status = 0;
      });


      if (status == 1) {
        imageurl3 = await uploadTask2.ref.getDownloadURL();


        print(imageurl3);
      }
    }
    if(_pickedFile4!=null) {
      var ref = _firebaseStorage2.ref().child('ListImages').child(
          "${_pickedFile4!.path}.jpg");

      var uploadTask2 = await ref.putFile(_pickedFile4!).catchError((
          error) async {
        status = 0;
      });


      if (status == 1) {
        imageurl4 = await uploadTask2.ref.getDownloadURL();


        print(imageurl4);
      }
    }
    if(_pickedFile5!=null) {
      var ref = _firebaseStorage2.ref().child('ListImages').child(
          "${_pickedFile5!.path}.jpg");

      var uploadTask2 = await ref.putFile(_pickedFile5!).catchError((
          error) async {
        status = 0;
      });


      if (status == 1) {

        imageurl5 = await uploadTask2.ref.getDownloadURL();


        print(imageurl5);
      }
    }
    _firestore2db.collection("homeworks").doc(widget.date).
    collection(widget.classes).doc(widget.sec).
    collection("class HomeWorks").doc(widget.docid).collection("Submissions").doc().set({

      "date": DateFormat.yMMMd().format(DateTime.now()),
      "submitted_date": DateFormat.yMMMd().format(DateTime.now()),
      "des": homecoller.text,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "Time": "${DateFormat('hh:mm a').format(DateTime.now())}",
      "imageurl1": imageurl1,
      "imageurl2": imageurl2,
      "imageurl3": imageurl3,
      "imageurl4": imageurl4,
      "imageurl5": imageurl5,
      "stname":widget.stname,
      "stregno":widget.stregno,

    });
    _firestore2db.collection("homeworks").doc(widget.date).
    collection(widget.classes).doc(widget.sec).
    collection("class HomeWorks").doc(widget.docid).update({
      "submited": FieldValue.arrayUnion([widget.stregno]),
    });

    homecoller.clear();

  }

  croppimage()async{
    if(_pickedFile==null) {
      ImagePicker _picker = ImagePicker();
      await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
        if (xFile != null) {
          setState(() {
            _pickedFile = File(xFile.path);
          });
        }
      });

    }
    else if(_pickedFile2==null) {
      ImagePicker _picker = ImagePicker();
      await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
        if (xFile != null) {
          setState(() {
            _pickedFile2 = File(xFile.path);
          });
        }
      });
    }
    else if(_pickedFile3==null) {
      ImagePicker _picker = ImagePicker();
      await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
        if (xFile != null) {
          setState(() {
            _pickedFile3 = File(xFile.path);
          });
        }
      });
    }
    else if(_pickedFile4==null) {
      ImagePicker _picker = ImagePicker();
      await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
        if (xFile != null) {
          setState(() {
            _pickedFile4 = File(xFile.path);
          });
        }
      });
    }
    else  if(_pickedFile5==null) {
      ImagePicker _picker = ImagePicker();
      await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
        if (xFile != null) {
          setState(() {
            _pickedFile5 = File(xFile.path);
          });
        }
      });
    }

  }

  SuccessHomeworkdialog() {
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/0.87111111,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Assignment Submitted Successfully',
      desc: '',

      btnCancelOnPress: () {

      },
      btnOkOnPress: () {
        Navigator.of(context).pop();


      },
    )
      ..show();
  }

  TextEditingController homecoller = TextEditingController();


  bool submitted=false;

  checksubmittedfunction()async{
    setState(() {
      submitted=false;
    });
print(widget.stregno);
print(widget.date);
print(widget.docid);
print(widget.classes);
print(widget.stname);

  _firestore2db.collection("homeworks").doc(widget.date).
    collection(widget.classes).doc(widget.sec).
    collection("class HomeWorks").doc(widget.docid).get().then((value){

      if(value['submited'].contains(widget.stregno)){

        setState(() {
          submitted=true;
        });
        shoedialogpopup();
      }
   });

  }

  @override
  void initState() {
    print(" Time:  ${DateFormat('hh:mm a').format(DateTime.now())}");
    getstatus();
   // checksubmittedfunction();
    // TODO: implement initState
    super.initState();
  }

  bool statusval = false;

  String sdate="";
  String stime="";


  getstatus() async {
    setState(() {
      statusval= false;
    });
var docu=  await  _firestore2db.collection("homeworks").doc(widget.date).
    collection(widget.classes).doc(widget.sec).
    collection("class HomeWorks").doc(widget.docid).collection("Submissions").get();
for(int i=0;i<docu.docs.length;i++){
  if(docu.docs[i]["stregno"]==widget.stregno)
  setState(() {
    statusval = true;
    sdate = docu.docs[i]["submitted_date"];
    stime = docu.docs[i]["Time"];
  });
}
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignment Details",style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight:
            FontWeight
                .w700,
            fontSize: width/20),),
      ),
      body: FutureBuilder(
        future: _firestore2db.collection("homeworks").doc(widget.date).
        collection(widget.classes).doc(widget.sec).
        collection("class HomeWorks").doc(widget.docid).get(),
        builder: (context,snap) {
          Map<String, dynamic>? val = snap.data!.data();
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(
                    vertical: height/189,
                    horizontal: width/90,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: width/1.028,

                        decoration: BoxDecoration(
                          color: Color(0xff0271C5),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(
                            horizontal: width/45,
                            vertical: height/94.5
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: height/37.8,),
                              Text("Subject",style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.w700,
                                  fontSize: width/22)),
                              Text(val!["subject"],style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight
                                      .w500,
                                  fontSize: width/25)),
                              Container(
                                width: width/1.8,
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),


                              Text("Assigned Date  & Time",style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight
                                      .w700,
                                  fontSize: width/22)),
                              Text("${val["Assignedondate"].toString()}  - ${val['Time']}",style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight
                                      .w500,
                                  fontSize: width/25)),
                              Container(
                                width: width/1.8,
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                              Text("Due Date",style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                  fontSize: width/22)),
                              Text("${val['Duedate']}",style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight
                                      .w500,
                                  fontSize: width/25)),
                              Container(
                                width: width/1.8,
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                              Text("Assigned By",style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight
                                      .w700,
                                  fontSize: width/22)),
                              Text(val["statffname"],style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight
                                      .w500,
                                  fontSize: width/25)),
                              Container(
                               width: width/1.8,
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                              Text("Topic",style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight
                                      .w700,
                                  fontSize: width/22)),
                              Text(val["topic"],
                                  style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight
                                      .w500,
                                  fontSize: width/25)),
                              Container(
                               width: width/1.8,
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                              Text("Description",style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight
                                      .w700,
                                  fontSize: width/22)),
                              Text(val["des"],
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight:
                                      FontWeight
                                          .w500,
                                      fontSize: width/25)),
                              Container(
                                width: width/1.8,
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: height/75.6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Material(
                              borderRadius: BorderRadius.circular(20),
                                    elevation: 4,
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context)=>PhotoViewPage(val["imageurl1"],val["imageurl2"],val["imageurl3"],val["imageurl4"],val["imageurl5"],))
                                        );
                                      },
                                      child: Container(
                                        width: width/1.44,
                                        height: height/15.12,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20)

                                        ),
                                        child: Center(
                                          child: Text("View Attachments",style: GoogleFonts.poppins(
                                              color: Color(0xff0271C5),
                                              fontWeight:
                                              FontWeight
                                                  .w600,
                                              fontSize: width/20)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height/75.6,),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                statusval==true  ?SizedBox():  Row(
                  children: [
                    Padding(
                      padding:  EdgeInsets.all(8.0),
                      child: Text(
                        "Answer",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width/28,
                            fontWeight:
                            FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                /// today homework


                statusval==true  ?SizedBox():  Center(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: height / 157.8,
                        left: width / 20),
                    height: height / 6.685,
                    width: width / 1.0636,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.grey),
                        borderRadius:
                        BorderRadius.circular(
                            12)),
                    child: TextField(
                      controller: homecoller,
                      keyboardType:
                      TextInputType
                          .multiline,
                      maxLines: 5,
                      minLines: 1,
                      decoration:
                      InputDecoration(
                          hintText:
                          "",
                          hintStyle:
                          GoogleFonts
                              .poppins(
                            color: Colors
                                .grey
                                .shade700,
                            fontSize: width/28,
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

                /// center container

                SizedBox(height: height / 49.133),
                _pickedFile!=null?    Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {

                      },
                      child: Container(

                          height: height / 18.685,
                          width: width / 1.0636,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey),
                              borderRadius:
                              BorderRadius.circular(
                                  12)),

                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 8,
                                right: 8,
                                left: 8),
                            child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.file_download_done_sharp),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets
                                        .only(left: 15.0),
                                    child: Container(
                                      width: width/2.117,
                                      child: Text(
                                        p.basename(_pickedFile!.path),

                                        style:
                                        GoogleFonts
                                            .poppins(
                                          color: Colors.black,
                                          fontSize: width/23.05882353,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                        ),),
                                    ),
                                  ),

                                ]
                            ),
                          )
                      ),
                    ),
                  ),
                ): SizedBox(),
                _pickedFile2!=null?    Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {

                      },
                      child: Container(

                          height: height / 18.685,
                          width: width / 1.0636,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey),
                              borderRadius:
                              BorderRadius.circular(
                                  12)),

                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 8,
                                right: 8,
                                left: 8),
                            child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.file_download_done_sharp),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets
                                        .only(left: 15.0),
                                    child: Container(
                                      width: width/2.30588235,
                                      child: Text(
                                        p.basename(_pickedFile2!.path),

                                        style:
                                        GoogleFonts
                                            .poppins(
                                          color: Colors.black,
                                          fontSize: width/23.05882353,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                        ),),
                                    ),
                                  ),

                                ]
                            ),
                          )
                      ),
                    ),
                  ),
                ): SizedBox(),
                _pickedFile3!=null?    Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {

                      },
                      child: Container(

                          height: height / 18.685,
                          width: width / 1.0636,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey),
                              borderRadius:
                              BorderRadius.circular(
                                  12)),

                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 8,
                                right: 8,
                                left: 8),
                            child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.file_download_done_sharp),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets
                                        .only(left: 15.0),
                                    child: Container(
                                      width: width/2.30588235,
                                      child: Text(
                                        p.basename(_pickedFile3!.path),

                                        style:
                                        GoogleFonts
                                            .poppins(
                                          color: Colors.black,
                                          fontSize: width/23.05882353,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                        ),),
                                    ),
                                  ),

                                ]
                            ),
                          )
                      ),
                    ),
                  ),
                ): SizedBox(),
                _pickedFile4!=null?    Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {

                      },
                      child: Container(

                          height: height / 18.685,
                          width: width / 1.0636,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey),
                              borderRadius:
                              BorderRadius.circular(
                                  12)),

                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 8,
                                right: 8,
                                left: 8),
                            child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.file_download_done_sharp),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets
                                        .only(left: 15.0),
                                    child: Container(
                                      width: width/2.30588235,
                                      child: Text(
                                        p.basename(_pickedFile4!.path),

                                        style:
                                        GoogleFonts
                                            .poppins(
                                          color: Colors.black,
                                          fontSize: width/23.05882353,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                        ),),
                                    ),
                                  ),

                                ]
                            ),
                          )
                      ),
                    ),
                  ),
                ): SizedBox(),
                _pickedFile5!=null?    Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {

                      },
                      child: Container(

                          height: height / 18.685,
                          width: width / 1.0636,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey),
                              borderRadius:
                              BorderRadius.circular(
                                  12)),

                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 8,
                                right: 8,
                                left: 8),
                            child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.file_download_done_sharp),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets
                                        .only(left: 15.0),
                                    child: Container(
                                      width: width/2.30588235,
                                      child: Text(
                                        p.basename(_pickedFile5!.path),

                                        style:
                                        GoogleFonts
                                            .poppins(
                                          color: Colors.black,
                                          fontSize: width/23.05882353,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                        ),),
                                    ),
                                  ),

                                ]
                            ),
                          )
                      ),
                    ),
                  ),
                ): SizedBox(),
                statusval==true  ?SizedBox():  Center(
                  child: InkWell(
                    onTap: () {
                      croppimage();
                    },
                    child: Container(

                        height: height / 12.685,
                        width: width / 1.0636,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey),
                            borderRadius:
                            BorderRadius.circular(
                                12)),

                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8,
                              right: 8,
                              left: 8),
                          child: Row(
                              children: [
                                Material(
                                  elevation: 3,
                                  borderRadius: BorderRadius
                                      .circular(8),
                                  shadowColor: Color(
                                      0xff0271C5),
                                  child: Container(
                                    width: width/7.84,
                                    height: height/15.66,
                                    decoration: BoxDecoration(

                                        borderRadius: BorderRadius
                                            .circular(8)
                                    ),
                                    child: Center(
                                        child: Icon(
                                            Icons.attachment_rounded,
                                            color: Color(
                                                0xff0271C5))),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets
                                      .only(left: 15.0),
                                  child: Container(
                                    width: width/2.30588235,
                                    child: Text(
                                      _pickedFile == null
                                          ? "Add Attachments"
                                          : "Add Another File",
                                      style:
                                      GoogleFonts
                                          .poppins(
                                        color: Color(
                                            0xff0271C5),
                                        fontSize: width/23.05882353,
                                        fontWeight:
                                        FontWeight
                                            .w500,
                                      ),),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets
                                      .only(left: 60.0),
                                  child: Icon(Icons
                                      .info_outline_rounded,
                                      color: Colors
                                          .black54),
                                )

                              ]
                          ),
                        )
                    ),
                  ),
                ),
                SizedBox(height: height / 49.133),
                statusval==true ?
                Center(
                  child: GestureDetector(
                    onTap: () {



                    },
                    child: Container(
                      height: height / 16.37,
                      width: width / 1.8,
                      decoration: BoxDecoration(
                          color: Color(0xff609F00),
                          border: Border.all(
                              color: Colors.grey),
                          borderRadius:
                          BorderRadius.circular(
                              7)),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceEvenly,
                        children: [
                          Text(
                            "Completed",
                            style:
                            GoogleFonts.poppins(
                                color: Colors
                                    .white,
                                fontSize: width / 22.5,
                                fontWeight:
                                FontWeight
                                    .w500),
                          ),
                          Icon(Icons.download_done_rounded,color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                ) :
                Center(
                  child: GestureDetector(
                    onTap: () {

                      if(submitted==true){
                        shoedialogpopup();
                      }

                      else{
                        add();
                        SuccessHomeworkdialog();
                      }

                    },
                    child: Container(
                      height: height / 16.37,
                      width: width / 1.8,
                      decoration: BoxDecoration(
                          color: Color(0xff609F00),
                          border: Border.all(
                              color: Colors.grey),
                          borderRadius:
                          BorderRadius.circular(
                              7)),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceEvenly,
                        children: [
                          Text(
                            "Mark as Complete",
                            style:
                            GoogleFonts.poppins(
                                color: Colors
                                    .white,
                                fontSize: width / 22.5,
                                fontWeight:
                                FontWeight
                                    .w500),
                          ),
                          Icon(Icons.download_done_rounded,color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height / 99.133),
                statusval==true  ?  Text("Submitted on ${sdate} \nat ${stime}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                    color: Color(0xff0271C5),
                    fontWeight:
                    FontWeight.w600,
                    fontSize: width/28)) : SizedBox(),

                SizedBox(height: height / 4.2125),
              ],
            ),
          );
        }
      ),
    );
  }



  shoedialogpopup(){

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return showDialog(
      barrierDismissible: false,

      context: context, builder:(context) {
      return
        Padding(
          padding:  EdgeInsets.only(top:height/3.78,bottom: height/3.78,left: width/7.2,right: width/7.2),
          child: Scaffold(
            body: Container(
              height: height/3.024,
              width: width/1.44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height/25.2,),
                  Text(
                    "Already to Submitted.....",
                    style:
                    GoogleFonts.poppins(
                        color: Colors
                            .black,
                        fontSize: width / 22.5,
                        fontWeight:
                        FontWeight
                            .w500),
                  ),

                  SizedBox(height: height/25.2,),
                  SizedBox(
                    height: height/9.45,
                    width: width/4.5,
                    child: Lottie.asset("assets/2pv43mVDXm.json"),
                    
                  ),
                  SizedBox(height: height/25.2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.pop(context);

                        },
                        child: Container(
                          height: height / 16.37,
                          width: width / 2.8,
                          decoration: BoxDecoration(
                              color: Color(0xff609F00),
                              border: Border.all(
                                  color: Colors.grey),
                              borderRadius:
                              BorderRadius.circular(
                                  7)),
                          child: Center(
                            child: Text(
                              "Okay",
                              style:
                              GoogleFonts.poppins(
                                  color: Colors
                                      .white,
                                  fontSize: width / 22.5,
                                  fontWeight:
                                  FontWeight
                                      .w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),



            ),
          ),
        );
    },);


  }



}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseStorage _firebaseStorage2= FirebaseStorage.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);