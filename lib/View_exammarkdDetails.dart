import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarkDetails extends StatefulWidget {
  String?Class;
  String?Section;
  String?documnetid;
  String?snapid;
  String?Subjectname;

   MarkDetails({this.Class,this.Section,this.documnetid,this.snapid,this.Subjectname});

  @override
  State<MarkDetails> createState() => _MarkDetailsState();
}

class _MarkDetailsState extends State<MarkDetails> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Subject Details"),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height/20.4,),
            Padding(
              padding:  EdgeInsets.only(left:width/45 ),
              child: Text("Subject Marks Details",style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700

              ),),
            ),
            Padding(
              padding:  EdgeInsets.only(left:width/45,right: width/45 ),
              child: Divider(color: Colors.grey,),
            ),
            SizedBox(height: height/40.4,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [

                  Container(
                      padding: EdgeInsets.only(left: width/36,right:  width/36),
                      height: height / 18.74,
                      width: width / 1.963,
                      decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child:
                        Text("Subject : ${widget.Subjectname}",style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700

                        ),),
                      )



                  ),
                  Container(
                      padding: EdgeInsets.only(left: width/36,right:  width/36),
                      height: height / 18.74,
                      width: width / 2.363,
                      decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8)
                        ),
                      child: Center(
                        child: Text("Class : ${widget.Class}",style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700

                        ),),
                      )



                  ),

                ]
            ),
            SizedBox(height: height/20.4,),
            Row(
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
                        child: Text("Student Name",style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
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
                        child: Text("Mark/Total Mark",style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700

                        ),),
                      )



                  ),

                ]
            ),

            StreamBuilder<QuerySnapshot>(
              stream:_firestore2db.collection("ExamMaster").doc(widget.documnetid).collection(widget.Class.toString()).doc(widget.snapid).
              collection("${widget.Class}-${widget.Section}Submmission").snapshots() ,
              builder: (context, snapshot2) {
                if(!snapshot2.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(snapshot2.hasData==null){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:snapshot2.data!.docs.length ,
                  itemBuilder:(context, index){
                    print(snapshot2.data!.docs.length);


                    return
                      Row(
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
                                  child: Text(snapshot2.data!.docs[index]["name"],style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: width/24,
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
                                  child: Text("${snapshot2.data!.docs[index]["mark"]}/${snapshot2.data!.docs[index]["totalmark"]}",style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: width/24,
                                      fontWeight: FontWeight.w600

                                  ),),
                                )



                            ),

                          ]
                      );

                  },);
              },),
            SizedBox(height: height/37.4,),
          ],
        ),
      ),
    );
  }
}

FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);
