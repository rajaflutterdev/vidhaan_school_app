import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Studentexamrimetable.dart';
import 'examtimetable.dart';

class StudentExam extends StatefulWidget {
  const StudentExam({Key? key}) : super(key: key);

  @override
  State<StudentExam> createState() => _StudentExamState();
}

class _StudentExamState extends State<StudentExam> {

  String Studentid = "";
  String Studentname = '';
  String Studentregno = '';
  String Studentimg = '';

  studentdetails() async {
    var document =
    await _firestore2db.collection("Students").get();
    for (int i = 0; i < document.docs.length; i++) {
      if (document.docs[i]["studentid"] == _firebaseauth2db.currentUser!.uid) {
        setState(() {
          Studentid = document.docs[i].id;
        });
        print("Student:${Studentid}");
        print(Studentid);
      }
      if (Studentid.isNotEmpty) {
        var studentdocument = await _firestore2db
            .collection("Students")
            .doc(Studentid)
            .get();
        Map<String, dynamic>? stuvalue = studentdocument.data();
        final split = stuvalue!['stname'].split(' ');
        final Map<int, String> values = {
          for (int k = 0; k < split.length; k++)
            k: split[k]
        } ;
        print("ghdfghdfghdfugdfgdfgfdggdfg");
        setState((){
          Studentname=values[0]!;
        });
        print(values[0]);
        setState(() {
          Studentregno = stuvalue['regno'];
          Studentimg = stuvalue['imgurl'];
        });
      }
    }
    ;
  }
  @override
  void initState() {
    studentdetails();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      height: double.infinity,
      child: Padding(
        padding:  EdgeInsets.only(
            left: width/36, right: width/36, top: height/15.12),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              GestureDetector(
                onTap: () {

                },
                child: Text(
                  "Exams",
                  style: GoogleFonts.poppins(
                      color:Color(0xff0873C4),
                      fontSize: 18,
                      fontWeight:
                      FontWeight.w600),
                ),
              ),

              Row(
                children: [
                  Text(
                    "For this academic year",
                    style: GoogleFonts.poppins(
                        color: Colors
                            .grey.shade700,
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w500),
                  ),
                  SizedBox(
                    width: width / 33.33,
                  ),

                  SizedBox(
                    width: width / 33.33,
                  ),
                  Text(
                    "",
                    style: GoogleFonts.poppins(
                        color: Colors
                            .grey.shade700,
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w500),
                  ),
                ],
              ),

              /// date/day

              SizedBox(height: height / 36.85),

              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
              ),
              StreamBuilder(
                  stream: _firestore2db.collection("Students").doc(Studentid).collection("Exams").snapshots(),
                  builder: (context,snap){

                    if(!snap.hasData){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(snap.hasData==null){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }


                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snap.data!.docs.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context,index){
                          return
                            Padding(
                            padding:  EdgeInsets.only(bottom: height/94.5),
                            child: Material(
                              elevation:5,
                              borderRadius: BorderRadius.circular(15),
                              child: GestureDetector(
                                onTap: (){

                                  print(Studentid.toString());
                                  Navigator.of(context).push(

                                      MaterialPageRoute(builder: (context)=>StudentExamTime(
                                          snap.data!.docs[index]["name"].toString(),
                                          snap.data!.docs[index].id.toString(),
                                          Studentid.toString()))
                                  );


                                },
                                child:
                                Container(
                                    width: width/1.2,
                                    height: height/7.56,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0xff0873C4),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 12.0,top:8,bottom: 5),
                                              child: Text(snap.data!.docs[index]["name"],style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w700

                                              ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 12.0),
                                              child: Text("View",style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600

                                              ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 12.0),
                                          child: Icon(Icons.text_snippet_rounded,color: Colors.white,size: 40,),
                                        )
                                      ],
                                    )
                                ),
                              ),
                            ),
                          );
                        });
                  })




            ],
          ),
        ),
      ),
    );
  }
}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);