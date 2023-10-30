import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Exam_Reports(Terms)_Page/Exam_report_View_Page.dart';




class ExamReports extends StatefulWidget {
  const ExamReports({Key? key}) : super(key: key);

  @override
  State<ExamReports> createState() => _ExamReportsState();
}

class _ExamReportsState extends State<ExamReports> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Exam Reports",style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: width/16.363,
            fontWeight: FontWeight.w700

        ),),
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        child: Padding(
          padding:  EdgeInsets.only(
              left: width/36, right: width/36, top: height/60.12),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

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
                              padding:  EdgeInsets.only(bottom: height/94.5),
                              child: Material(
                                elevation:2,
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xff0873C4),
                                child: GestureDetector(
                                  onTap: (){

                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=>Exam_report_View_Page(
                                            title:snap.data!.docs[index]["name"] ,
                                            docid:snap.data!.docs[index].id ,))

                                    );
                                  },
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
                                                    fontSize: width/20.4,
                                                    fontWeight: FontWeight.w700

                                                ),
                                                ),
                                              ),
                                              Padding(
                                                padding:  EdgeInsets.only(left: width/30),
                                                child: Text("View",style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: width/22,
                                                    fontWeight: FontWeight.w600

                                                ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:  EdgeInsets.only(right: width/30),
                                            child: Icon(Icons.text_snippet_rounded,color: Colors.white,size: width/9,),
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
      )
    );
  }
}

FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);

