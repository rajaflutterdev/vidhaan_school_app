import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'View_Time_Table_Page.dart';
import 'examtimetable.dart';


class Exams extends StatefulWidget {
  const Exams({Key? key}) : super(key: key);

  @override
  State<Exams> createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return
      Container(
      color: Colors.white,
      height: double.infinity,
      child: Padding(
        padding:  EdgeInsets.only(
            left: width/36, right: width/36, top: height/15.12),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                "Exams",
                style: GoogleFonts.poppins(
                    color:Color(0xff0873C4),
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w600),
              ),

              Row(
                children: [
                  Text(
                    "For this academic year",
                    style: GoogleFonts.poppins(
                        color: Colors
                            .grey.shade700,
                        fontSize:width/24,
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
                        fontSize:width/24,
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
                  stream: _firestore2db.collection("ExamMaster").snapshots(),
                  builder: (context,snap){
                    if(snap.hasData==null){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(!snap.hasData){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                return ListView.builder(
                  shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (context,index){
                  return Padding(
                    padding:  EdgeInsets.only(bottom: 8),
                    child: Material(
                      elevation:5,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
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
                                    padding:  EdgeInsets.only(left: width/30,top:height/94.5,bottom: height/151.2),
                                    child: Text(snap.data!.docs[index]["name"],style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: width/14.4,
                                      fontWeight: FontWeight.w700

                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(left: width/30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        //SizedBox(width: 130,),

                                        GestureDetector(
                                          onTap:(){

                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context)=>
                                                    View_Time_Table_Page(snap.data!.docs[index]["name"],snap.data!.docs[index].id))
                                            );

                                          },
                                          child: Container(
                                            height: height/27,
                                            width: width/2.769,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                             borderRadius: BorderRadius.circular(8),

                                            ),
                                            child: Center(
                                              child: Text("View TimeTable",style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: width/28,
                                                fontWeight: FontWeight.w600

                                              ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: width/36.0,),

                                        GestureDetector(
                                          onTap: (){
                                            Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context)=>ExamTimetable(snap.data!.docs[index]["name"],snap.data!.docs[index].id))
                                            );
                                          },
                                          child: Container(
                                            height: height/27,
                                            width: width/2.769,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                             borderRadius: BorderRadius.circular(8),

                                            ),
                                            child: Center(
                                              child: Text("Assigned Marks",style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: width/28,
                                                fontWeight: FontWeight.w600

                                              ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          )
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
