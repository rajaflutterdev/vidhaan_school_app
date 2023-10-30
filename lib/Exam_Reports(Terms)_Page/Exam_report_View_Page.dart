import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class Exam_report_View_Page extends StatefulWidget {
  String ?title;
  String ?docid;
  Exam_report_View_Page({this.title, this.docid});

  @override
  State<Exam_report_View_Page> createState() => _Exam_report_View_PageState();
}

class _Exam_report_View_PageState extends State<Exam_report_View_Page> {

  final TextEditingController _typeAheadControllerclass = TextEditingController();


  static final List<String> classes = [];
  static final List<String> section = [];
  static final List<String> subject = [];

  String dropdownValue4="Class";
  String dropdownValue5="Section";
  String dropdownValue6="Subject";

  @override
  void initState() {
    print("Home Page 2");
    setState(() {
      Loading=false;
    });

    adddropdownvalue();

    super.initState();
  }

  adddropdownvalue() async {
    print("hello");
    setState(() {
      classes.clear();
      section.clear();
      subject.clear();
    });
    var document = await  _firestore2db.collection("ClassMaster").orderBy("order").get();
    var document2 = await  _firestore2db.collection("SectionMaster").orderBy("order").get();


    setState(() {
      classes.add("Class");
      section.add("Section");
      subject.add("Subject");
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

  subjectnamefunction()async{
    setState(() {
      subject.clear();
    });
    var document3 = await  _firestore2db.collection("ExamMaster").doc(widget.docid).collection(dropdownValue4).get();
    setState(() {
      subject.add("Subject");
    });
    for(int i=0;i<document3.docs.length;i++) {
      setState(() {
        subject.add(document3.docs[i]["name"]);
      });

    }
    print(subject);

  }

  TextEditingController Totalmarkcontroller=TextEditingController();

  List<TextEditingController> controllers = List<TextEditingController>.generate(1000,(index) => TextEditingController());


  bool editMark=false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}- TimeTable"),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      ///Class dropdown
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height/94.5,
                            horizontal: width/45
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Class " ,style: TextStyle(
                                color: Colors.black,
                                fontSize: width/25,fontWeight: FontWeight.w700),),
                            SizedBox(height: height/75.6,),

                            Container(
                              padding: EdgeInsets.only(left: width/36,right:  width/36),
                              height: height / 18.74,
                              width: width / 2.4,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              child:
                              DropdownButton2<String>(
                                value: dropdownValue4,
                                isExpanded: true,
                                style: TextStyle(
                                    color: Color(0xff3D8CF8),
                                    fontSize: width/24,fontWeight: FontWeight.w700),
                                underline: Container(
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    dropdownValue4 = value!;
                                    _typeAheadControllerclass.text = value;
                                  });
                                  subjectnamefunction();
                                },
                                items:
                                classes.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),


                            ),
                          ],
                        ),
                      ),

                      ///Section dropdown
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height/94.5,
                            horizontal: width/45
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Section" ,style: TextStyle(
                                color: Colors.black,
                                fontSize: width/25,fontWeight: FontWeight.w700),),
                            SizedBox(height: height/75.6,),

                            Container(
                              padding: EdgeInsets.only(left: width/36,right:  width/36),
                              height: height / 18.74,
                              width: width / 2.4,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              child:
                              DropdownButton2<String>(
                                value: dropdownValue5,
                                isExpanded: true,
                                style: TextStyle(
                                    color: Color(0xff3D8CF8),
                                    fontSize: width/24,fontWeight: FontWeight.w700),
                                underline: Container(
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    dropdownValue5 = value!;
                                  });
                                },
                                items:
                                section.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),


                            ),
                          ],
                        ),
                      ),



                    ]
                ),

                Padding(
                  padding:  EdgeInsets.only(left: width/45),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      ///subject dropdown
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height/94.5,
                            horizontal: width/45
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Subject" ,style: TextStyle(
                                color: Colors.black,
                                fontSize: width/25,fontWeight: FontWeight.w700),),
                            SizedBox(height: height/75.6,),
                            Container(
                              padding: EdgeInsets.only(left: width/36,right:  width/36),
                              height: height / 18.74,
                              width: width / 2.4,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              child:
                              DropdownButton2<String>(
                                value: dropdownValue6,
                                isExpanded: true,
                                style: TextStyle(
                                    color: Color(0xff3D8CF8),
                                    fontSize: width/24,fontWeight: FontWeight.w700),
                                underline: Container(
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    dropdownValue6 = value!;
                                  });

                                },
                                items:
                                subject.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),


                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height/94.5,
                            horizontal: width/20
                        ),
                        child: GestureDetector(
                          onTap: (){
                            setthemarkfunction();
                          },

                          child: Padding(
                            padding:  EdgeInsets.only(top:25),
                            child: Container(
                              padding: EdgeInsets.only(left: width/26,right:  width/36),
                              height: height / 18.74,
                              width: width / 2.5,
                              decoration: BoxDecoration(
                                  color: Color(0xff3D8CF8),
                                  borderRadius:
                                  BorderRadius.circular(8)),
                              child: Center(child: Text("View",style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: Colors.white

                              ),))



                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height/94.5,
                      horizontal: width/45
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [

                        Container(
                          width: width/2.25,
                          child: Text("Subject",style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: width/22,
                              fontWeight: FontWeight.w700

                          ),),
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Text("Mark",style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: width/22,
                                  fontWeight: FontWeight.w700

                              ),),
                            ],
                          ),
                        )

                      ]
                  ),
                ),

                StreamBuilder<QuerySnapshot>(
                    stream: _firestore2db.collection("Students").orderBy("regno").snapshots(),
                    builder: (context,snap){

                      if(snap.hasData==null){
                        return Center(child: CircularProgressIndicator(),);
                      }
                      if(!snap.hasData){
                        return Center(child: CircularProgressIndicator(),);
                      }

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snap.data!.docs.length,
                          itemBuilder: (context,index){
                            var studentdata=snap.data!.docs[index];

                            if(studentdata["admitclass"]==dropdownValue4&&
                                studentdata["section"]==dropdownValue5){
                              return
                                Container(
                                  height: height/9.45,
                                  margin: EdgeInsets.only(left: width/72,right: width/72),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black,
                                              width: 0.5
                                          )
                                      )
                                  ),
                                  child: ListTile(
                                    title: Text(studentdata['stname'],style: TextStyle(
                                        fontSize: width/25.71
                                    ),),
                                    subtitle: Text("Reg No: ${studentdata['regno']}",style: TextStyle(
                                        fontSize: width/35.71
                                    ),),
                                    trailing: Container(
                                      padding: EdgeInsets.only(left: width/36,right:  width/36),
                                      height: height / 24.74,
                                      width: width / 4.5,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                          BorderRadius.circular(8)),
                                      child:
                                      Center(
                                        child: Text(
                                            controllers[index].text.toString()
                                        ),
                                      ),



                                    ),
                                  ),
                                );
                            }

                            return
                              const SizedBox();
                          });
                    }),


                SizedBox(height: height/30.24,),

              ],
            ),
          ),
          Loading==true?Material(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white70,
            shadowColor: Colors.black26,
            elevation: 25,
            child: Container(
              height: height/3.15,
              width: width/1.8,decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white70
            ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset("assets/loaqding.json",fit: BoxFit.cover),
                  Text("Please Wait....",style: TextStyle(fontWeight: FontWeight.w600,)),
                ],
              ),
            ),
          ):const SizedBox()
        ],
      ),

    );
  }


  String documentid='';
  String subjectname="";
  bool Loading=false;



  setthemarkfunction() async {
    setState(() {
      Loading=true;
    });

    var studentdata=await _firestore2db.collection("Students").orderBy("regno").get();
    var examdata=await  _firestore2db.collection("ExamMaster").doc(widget.docid).collection(dropdownValue4).where("name",isEqualTo: dropdownValue6).get();
    print(examdata.docs.length);
    setState(() {
      documentid=examdata.docs[0].id;
      subjectname=examdata.docs[0]['name'];
    });

    print("filledMark value------------------------------------------------------------------");


    print("Document documentid$documentid");

    for(int i=0;i<studentdata.docs.length;i++){
      if(studentdata.docs[i]['admitclass']==dropdownValue4&&studentdata.docs[i]['section']==dropdownValue5){
        var docdata= await _firestore2db.collection("Students").doc(studentdata.docs[i].id).collection("Exams").get();
        if(docdata.docs.isNotEmpty){
          for(int s=0;s<docdata.docs.length;s++){
            var data2=await _firestore2db.collection("Students").doc(studentdata.docs[i].id).
            collection("Exams").doc(docdata.docs[s].id).collection("Timetable").get();

            for(int k=0;k<data2.docs.length;k++){
              if(data2.docs[k]['exam']==widget.title && data2.docs[k]['name']==dropdownValue6){
                setState(() {
                  Totalmarkcontroller.text=data2.docs[k]['total'];
                  controllers[i].text=data2.docs[k]['mark'];
                });

              }
            }


          }
        }
      }


    }
    var filledmarkdata=await _firestore2db.collection("ExamMaster").doc(widget.docid).collection(dropdownValue4).doc(documentid).
    collection("${dropdownValue4}-${dropdownValue5}Submmission").get();
    print(filledmarkdata.docs.length);
    setState(() {
      Loading=false;
    });


  }



}


FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);
