import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidhaan_school_app/photoviewpage.dart';

class Assignmentsdetails2 extends StatefulWidget {
  String date;
  String classes;
  String sec;
  String id;
  String docid;
   Assignmentsdetails2(this.date,this.classes,this.sec,this.id,this.docid);

  @override
  State<Assignmentsdetails2> createState() => _Assignmentsdetails2State();
}

class _Assignmentsdetails2State extends State<Assignmentsdetails2> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignment Reports",style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight:
            FontWeight
                .w700,
            fontSize: 18),),
      ),
      body: FutureBuilder(
          future: _firestore2db.collection("homeworks").doc(widget.date).
          collection(widget.classes).doc(widget.sec).
          collection("class HomeWorks").doc(widget.id).collection("Submissions").doc(widget.docid).get(),
          builder: (context,snap) {
            Map<String, dynamic>? val = snap.data!.data();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 380,

                          decoration: BoxDecoration(
                              color: Color(0xff0271C5),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20,),
                                Text("Student Name",style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                    fontSize: 18)),
                                Text("${val!["stname"]} - ${val!["stregno"]}",style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                    fontSize: 24)),
                                Container(
                                  width: 200,
                                  child: Divider(
                                    color: Colors.white,
                                  ),
                                ),
                                Text("Submitted Date & Time",style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                    fontSize: 18)),
                                Text("${val['date']} - ${val['Time']}",style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                    fontSize: 24)),
                                Container(
                                  width: 200,
                                  child: Divider(
                                    color: Colors.white,
                                  ),
                                ),

                                Text("Description",style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                    fontSize: 18)),
                                Text(val["des"],
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight
                                            .w700,
                                        fontSize: 20)),
                                Container(
                                  width: 200,
                                  child: Divider(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10,),
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
                                          width: 250,
                                          height: 50,
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
                                                fontSize: 18)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),


                  /// today homework





                  SizedBox(height: height / 4.2125),
                ],
              ),
            );
          }
      ),
    );
  }
}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);