import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentExamTime extends StatefulWidget {
  String title;
  String docid;
  String userdocid;
  StudentExamTime(this.title,this.docid,this.userdocid);

  @override
  State<StudentExamTime> createState() => _StudentExamTimeState();
}

class _StudentExamTimeState extends State<StudentExamTime> {


  final TextEditingController _typeAheadControllerclass = TextEditingController();
  final TextEditingController _typeAheadControllersection = TextEditingController();
  final TextEditingController _typeAheadControllerstaffid = TextEditingController();

  static final List<String> classes = [];
  static final List<String> section = [];

  String dropdownValue4="";
  String dropdownValue5="Section";

  getadmitclass() async {
    var studentdocument = await _firestore2db
        .collection("Students")
        .doc(widget.userdocid)
        .get();
    Map<String, dynamic>? stuvalue = studentdocument.data();
    setState(() {
      dropdownValue4 = stuvalue!['admitclass'];

    });

  }
  @override
  void initState() {
    print("Home Page 2");

    getadmitclass();

    super.initState();
  }

  adddropdownvalue() async {
    print("hello");
    setState(() {
      classes.clear();
      section.clear();
    });
    var document = await  _firestore2db.collection("ClassMaster").orderBy("order").get();
    var document2 = await  _firestore2db.collection("SectionMaster").orderBy("order").get();
    setState(() {
      classes.add("Class");
      section.add("Section");
    });
    for(int i=0;i<document.docs.length;i++) {
      setState(() {
        classes.add(document.docs[i]["name"]);
      });

    }
    for(int i=0;i<document2.docs.length;i++) {
      setState(() {
        section.add(document2.docs[i]["name"]);
      });

    }
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}- TimeTable"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Container(
                      padding: EdgeInsets.only(left: width/36,right:  width/36),
                      height: height / 18.74,
                      width: width / 1.963,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.black)),
                      child: Center(
                        child: Text("Subject",style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700

                        ),),
                      )



                  ),
                  Container(
                      padding: EdgeInsets.only(left: width/36,right:  width/36),
                      height: height / 18.74,
                      width: width / 2.363,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.black)),
                      child: Center(
                        child: Text("Date",style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700

                        ),),
                      )



                  ),

                ]
            ),
          ),
          StreamBuilder(
              stream: _firestore2db.collection("ExamMaster").doc(widget.docid).collection(dropdownValue4).snapshots(),
              builder: (context,snap){

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [

                              Container(
                                  padding: EdgeInsets.only(left: width/36,right:  width/36),
                                  height: height / 18.74,
                                  width: width / 1.963,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.black)),
                                  child: Center(
                                    child: Text(snap.data!.docs[index]["name"],style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600

                                    ),),
                                  )



                              ),
                              Container(
                                  padding: EdgeInsets.only(left: width/36,right:  width/36),
                                  height: height / 18.74,
                                  width: width / 2.363,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.black)),
                                  child: Center(
                                    child: Text(snap.data!.docs[index]["date"],style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600

                                    ),),
                                  )



                              ),

                            ]
                        ),
                      );
                    });
              })
        ],
      ),

    );
  }
}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);