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
  String topic;
  SubmittedAssign(this.date,this.classes,this.sec,this.id,this.topic);

  @override
  State<SubmittedAssign> createState() => _SubmittedAssignState();
}

class _SubmittedAssignState extends State<SubmittedAssign> {

  getcount() async {
    var document = await _firestore2db.collection("Students").where("admitclass",isEqualTo: widget.classes).where("section",isEqualTo: widget.sec).get();
    var document2 =await
    _firestore2db.collection("homeworks").doc(widget.date).collection(widget.classes).doc(widget.sec).
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


  List<String> incomplrListdata=[];
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
            fontSize: width/16.363,
            fontWeight: FontWeight.w700

        ),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: width/45,
              vertical: height/94.5
            ),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              shadowColor: Color(0xff0873C4),
              child: Container(
                padding: EdgeInsets.only(left: width/36,right: width/36),
                height: height / 10.0,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${presentcount} ",style: GoogleFonts.poppins(
                            color: Colors.green,
                            fontSize:width/18.4,
                            fontWeight: FontWeight.w600

                        ),),

                        Text("Completed",style: GoogleFonts.poppins(
                            color: Colors.green,
                            fontSize:width/16.363,
                            fontWeight: FontWeight.w600

                        ),),
                      ],
                    ),
                    SizedBox(width:width/72,),
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: height/94.5),
                      child: VerticalDivider(
                        width: width/120,
                        color: Color(0xff0873C4),
                      ),
                    ),
                    SizedBox(width:width/72,),
                    GestureDetector(
                      onTap: (){
                        notsubmittedstudentdatapopup();
                      },
                      child: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${absentcount} ",style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontSize:width/18.4,
                                fontWeight: FontWeight.w600

                            ),),

                            Text("Incomplete",style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontSize:width/16.363,
                                fontWeight: FontWeight.w600

                            ),),
                          ],
                        ),
                      ),
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
                  incomplrListdata.clear();
                  snapshot2.data!.docs.forEach((element) {
                    incomplrListdata.add(element['stregno']);
                  });
                  var subjecthomework=snapshot2.data!.docs[index];
                  return Padding(
                    padding:  EdgeInsets.symmetric(vertical: height/94.5,horizontal: width/45),
                    child: Container(

                      width: width/1.058,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10),
                          border: Border.all(
                              color: Color(0xff999999))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: height/145.6),

                                  ///subject Title
                                  Padding(
                                    padding:
                                    EdgeInsets.only(left:width/24),
                                    child: SizedBox(
                                      width: width/1.8,
                                      child: Text(
                                        "${subjecthomework['stname']} - ${subjecthomework['stregno']}",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight.w700,
                                            fontSize:width/22.5),
                                      ),
                                    ),
                                  ),

                                  ///subject Description
                                  Padding(
                                    padding:
                                    EdgeInsets.only(left:width/24),
                                    child: SizedBox(
                                      height: height/21.6,
                                      width: width/1.636,
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .center,
                                        children: [
                                          Container(
                                            width:width/1.636,
                                            child: Text(
                                              subjecthomework['des'],
                                              textAlign:
                                              TextAlign.left,
                                              style:
                                              GoogleFonts.poppins(
                                                  color: Colors
                                                      .black,
                                                  fontSize: width/30),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  ///Subject assign date and tim
                                  SizedBox(height: height/145.6),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=>Assignmentsdetails2(widget.date,widget.classes,widget.sec,widget.id,subjecthomework.id,widget.topic))
                                      );

                                    },
                                    child: Container(
                                        height: height/20.9,
                                        width: width/3.90,
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
                                                fontSize:width/22.5),
                                          ),
                                        )),
                                  ),
                                  SizedBox(height: height/151.2,),



                                ],
                              ),

                            ],
                          ),
                          Padding(
                            padding:
                            EdgeInsets
                                .only(
                                left: width /
                                    24),
                            child: Row(

                              children: [
                                Text(
                                  "Submitted on: ${subjecthomework['submitted_date']}",
                                  style: GoogleFonts
                                      .poppins(
                                      color: Color(
                                          0xffA294A1),
                                      fontWeight:
                                      FontWeight
                                          .w500,
                                      fontSize: width /
                                          30.5),
                                ),
                                SizedBox(width: width /
                                    4.8),
                                Text(
                                  "Time: ${subjecthomework['Time']}",
                                  style: GoogleFonts
                                      .poppins(
                                      color: Color(
                                          0xffA294A1),
                                      fontWeight:
                                      FontWeight
                                          .w500,
                                      fontSize: width /
                                          30.5),
                                ),
                              ],
                            ),
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



  notsubmittedstudentdatapopup(){
    return showDialog(context: context, builder:
    (context) {

      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Assignments Not \nSubmitted Students",
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
              StreamBuilder(
                stream: _firestore2db.collection("Students").orderBy("regno").snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData==null){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    if(!snapshot.hasData){
                      return Center(child: CircularProgressIndicator(),);
                    }

                  return  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var incomplestudnet=snapshot.data!.docs[index];

                     if(incomplestudnet['admitclass']==widget.classes&&incomplestudnet['section']==widget.sec){
                       if(!incomplrListdata.contains(incomplestudnet['regno'])){
                         return  Container(
                           decoration: BoxDecoration(
                               border: Border(
                                   bottom: BorderSide(color: Colors.black)
                               )
                           ),
                           child: ListTile(
                             title: Text("Name: ${incomplestudnet['stname']}"),
                             subtitle:Text("Rag No: ${incomplestudnet['regno']}"),

                           ),
                         );
                       }
                     }

                      return SizedBox();

                  },);

                  },)

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


  // incomplestudnetlis()async{
  //   setState(() {
  //     incomplrListdata.clear();
  //   });
  //   var studendata=await _firestore2db.collection("homeworks").doc(widget.date).
  //   collection(widget.classes).doc(widget.sec).collection("class HomeWorks").doc(widget.id).collection("Submissions").get();
  //
  //   for(int i=0;i<studendata.docs.length;i++){
  //
  //     incomplrListdata.add(studendata.docs.)
  //
  //   }
  // }






}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);
