import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidhaan_school_app/viewassigndetails2.dart';

class SubmittedAssign extends StatefulWidget {
  String date;
  String classes;
  String sec;
  String id;
  SubmittedAssign(this.date,this.classes,this.sec,this.id);

  @override
  State<SubmittedAssign> createState() => _SubmittedAssignState();
}

class _SubmittedAssignState extends State<SubmittedAssign> {

  getcount() async {
    var document = await _firestore2db.collection("Students").where("admitclass",isEqualTo: widget.classes).where("section",isEqualTo: widget.sec).get();
    var document2 =await _firestore2db.collection("homeworks").doc(widget.date).
    collection(widget.classes).doc(widget.sec).
    collection("class HomeWorks").doc(widget.id).collection("Submissions").get();


    setState(() {
      presentcount=document2.docs.length;
      absentcount=document.docs.length- document2.docs.length;
    });

  }
  @override
  void initState() {
    getcount();
    // TODO: implement initState
    super.initState();
  }

  int presentcount=0;
  int absentcount=0;
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
    final Size size = MediaQuery
        .of(context)
        .size;
    double _width = MediaQuery
        .of(context)
        .size
        .width;
    double _height = MediaQuery
        .of(context)
        .size
        .height;


    return Scaffold(
      appBar: AppBar(
        title: Text("Submitted Students",style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700

        ),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              shadowColor: Color(0xff0873C4),
              child: Container(
                padding: EdgeInsets.only(left: width/36,right: width/36),
                height: height / 10.74,
                width: width / 1.0163,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Color(0xff0873C4)),
                    borderRadius:
                    BorderRadius.circular(
                        12)),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("${presentcount} ",style: GoogleFonts.poppins(
                            color: Colors.green,
                            fontSize: 25,
                            fontWeight: FontWeight.w600

                        ),),

                        Text("Completed",style: GoogleFonts.poppins(
                            color: Colors.green,
                            fontSize: 22,
                            fontWeight: FontWeight.w600

                        ),),
                      ],
                    ),
                    SizedBox(width: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: VerticalDivider(
                        width: 3,
                        color: Color(0xff0873C4),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Column(
                      children: [
                        Text("${absentcount} ",style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 25,
                            fontWeight: FontWeight.w600

                        ),),

                        Text("Incomplete",style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 22,
                            fontWeight: FontWeight.w600

                        ),),
                      ],
                    ),
                  ],
                ),


              ),
            ),
          ),
          StreamBuilder(
            stream: _firestore2db.collection("homeworks").doc(widget.date).
            collection(widget.classes).doc(widget.sec).
            collection("class HomeWorks").doc(widget.id).collection("Submissions").snapshots(),
            builder: (context, snapshot2) {
              if(snapshot2.hasData==null){
                return Center(child: CircularProgressIndicator(),);
              }
              if(!snapshot2.hasData){
                return Center(child: CircularProgressIndicator(),);
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot2.data!.docs.length,
                itemBuilder: (context, index) {
                  var subjecthomework=snapshot2.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                    child: Container(

                      width: 340,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10),
                          border: Border.all(
                              color: Color(0xff999999))),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),

                              ///subject Title
                              Padding(
                                padding:
                                EdgeInsets.only(left: 15.0),
                                child: SizedBox(
                                  width: 200,
                                  child: Text(
                                    "${subjecthomework['stname']} - ${subjecthomework['stregno']}",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                ),
                              ),

                              ///subject Description
                              Padding(
                                padding:
                                EdgeInsets.only(left: 15.0),
                                child: SizedBox(
                                  height: 35,
                                  width: 250,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .center,
                                    children: [
                                      Container(
                                        width:250,
                                        child: Text(
                                          subjecthomework['des'],
                                          textAlign:
                                          TextAlign.left,
                                          style:
                                          GoogleFonts.poppins(
                                              color: Colors
                                                  .black,
                                              fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ///Subject assign date and time
                              Padding(
                                padding:
                                EdgeInsets.only(left: 15.0),
                                child: Text(
                                  "${subjecthomework['date']} | ${subjecthomework['Time']}",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xffA294A1),
                                      fontWeight:
                                      FontWeight.w700,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context)=>Assignmentsdetails2(widget.date,widget.classes,widget.sec,widget.id,subjecthomework.id))
                                  );

                                },
                                child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color:  Color(0xff0873C4),
                                      border: Border.all(
                                        color:  Color(
                                            0xff0873C4),
                                      ),
                                      borderRadius:
                                      BorderRadius
                                          .circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "View",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight
                                                .w700,
                                            fontSize: 16),
                                      ),
                                    )),
                              ),
                              SizedBox(height: 5,),



                            ],
                          ),

                        ],
                      ),
                    ),
                  );

                },);
            },)

        ],
      ),
    );
  }
}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);
