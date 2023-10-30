import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Previous_Fees_details_Page extends StatefulWidget {
  String ?Feesname;
  String ?Studentdocid;
   Previous_Fees_details_Page({this.Feesname,this.Studentdocid});

  @override
  State<Previous_Fees_details_Page> createState() => _Previous_Fees_details_PageState();
}

class _Previous_Fees_details_PageState extends State<Previous_Fees_details_Page> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return
      Scaffold(
        body:  Container(
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
                    "${widget.Feesname}",
                    style: GoogleFonts.poppins(
                        color:Color(0xff0873C4),
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w600),
                  ),

                  Row(
                    children: [
                      Text(
                        "For this Previous  ${widget.Feesname} Details",
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
                      stream: _firestore2db.collection("Students").doc(widget.Studentdocid).collection("Fees").where("status",isEqualTo: true).snapshots(),
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

                        return
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snap.data!.docs.length,
                              itemBuilder: (context,index){

                                var feesdata=snap.data!.docs[index];
                                return
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black,
                                                width: 0.8
                                            )
                                        )
                                    ),
                                    child: ListTile(
                                      trailing: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(height: height/400.5,),
                                          Text("₹ ${feesdata['amount'].toString()}",style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                                          SizedBox(height: height/94.5,),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:BorderRadius.circular(8)
                                            ),
                                            padding: EdgeInsets.only(top: height/378,bottom: height/378,left: width/90,right: width/90),
                                            child: Text("5 Days",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,
                                                color: Colors.white
                                            ),),
                                          )
                                        ],
                                      ),
                                      title: Text(feesdata['feesname'],style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                                      subtitle: Container(
                                          width: width/2,
                                          child: Text("Due Date: ${feesdata['duedate']}",style: GoogleFonts.poppins(fontWeight: FontWeight.w500),)),
                                    ),
                                  );
                              });
                      })




                ],
              ),
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

