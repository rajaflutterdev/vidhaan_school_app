import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:vidhaan_school_app/photoviewpage.dart';

class Assignmentsdetails2 extends StatefulWidget {
  String date;
  String classes;
  String sec;
  String id;
  String docid;
  String topic;
   Assignmentsdetails2(this.date,this.classes,this.sec,this.id,this.docid,this.topic);

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
            fontSize:width/20),),
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
                    padding:  EdgeInsets.symmetric(
                      vertical: height/189,
                      horizontal: width/90
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
                              vertical: height/94.5,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: height/37.8,),
                                Text("Student Name",style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                    fontSize:width/20)),
                                Text("${val!["stname"]} - ${val!["stregno"]}",style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w500,
                                    fontSize:width/25)),
                                Container(
                                  width:width/1.8,
                                  child: Divider(
                                    color: Colors.white,
                                  ),
                                ),
                                Text("Submitted Date & Time",style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                    fontSize:width/20)),
                                Text("${val['date']} - ${val['Time']}",style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w500,
                                    fontSize:width/25)),
                                Container(
                                  width:width/1.8,
                                  child: Divider(
                                    color: Colors.white,
                                  ),
                                ),
                                Text("Topic",style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                    fontSize:width/20)),
                                Text(widget.topic,style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w500,
                                    fontSize:width/25)),
                                Container(
                                  width:width/1.8,
                                  child: Divider(
                                    color: Colors.white,
                                  ),
                                ),

                                Text("Answer",style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                    fontSize:width/20)),
                                Text(val["des"],
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight
                                            .w500,
                                        fontSize: width/25)),
                                Container(
                                  width:width/1.8,
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

                                          if(val["imageurl1"]==""&&val["imageurl2"]==""&&val["imageurl3"]==""&&val["imageurl4"]==""&&val["imageurl5"]==""){

                                            NoImagedatapopup();
                                          }

                                         else{
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context)=>PhotoViewPage(val["imageurl1"],val["imageurl2"],val["imageurl3"],val["imageurl4"],val["imageurl5"],))
                                            );
                                          }
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
                                                fontSize:width/20)),
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


                  /// today homework





                  SizedBox(height: height / 4.2125),
                ],
              ),
            );
          }
      ),
    );
  }


  NoImagedatapopup(){

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return showDialog(context: context, builder:
        (context) {

      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              ),)
          ],

        ),

        content: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Text("Sorry Attachments are Empty !.....",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                ),),
          Lottie.asset("assets/error animation.json",height: height/5.04,width: width/2.4,fit: BoxFit.cover)

            ],
          ),
        ),

        actions: [

          TextButton(
              onPressed: (){
                Navigator.pop(context);

              },
              child: Text("Okay"))

        ],


      );
    },);

  }


}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);