import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExamTimetable extends StatefulWidget {
  String title;
  String docid;
  ExamTimetable(this.title,this.docid);

  @override
  State<ExamTimetable> createState() => _ExamTimetableState();
}

class _ExamTimetableState extends State<ExamTimetable> {

  final TextEditingController _typeAheadControllerclass = TextEditingController();
  final TextEditingController _typeAheadControllersection = TextEditingController();
  final TextEditingController _typeAheadControllerstaffid = TextEditingController();

  static final List<String> classes = [];
  static final List<String> section = [];

  String dropdownValue4="Class";
  String dropdownValue5="Section";

  @override
  void initState() {
    print("Home Page 2");

    adddropdownvalue();

    super.initState();
  }

  adddropdownvalue() async {
    print("hello");
    setState(() {
      classes.clear();
      section.clear();
    });
    var document = await  _firestore2db.collection("ClassMaster").orderBy("order").get();
    var document2 = await  _firestore2db.collection("SectionMaster").orderBy("order").get();
    setState(() {
      classes.add("Class");
      section.add("Section");
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}- TimeTable"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Select the Class :" ,style: TextStyle(
                color: Colors.black,
                fontSize: 20,fontWeight: FontWeight.w700),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.only(left: width/36,right:  width/36),
              height: height / 14.74,
              width: width / 2.363,
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
                    fontSize: 17,fontWeight: FontWeight.w700),
                underline: Container(
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue4 = value!;
                    _typeAheadControllerclass.text = value;
                  });
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
          ),

        ]
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
                child: Text("Subject",style: GoogleFonts.poppins(
                color: Colors.black,
                    fontSize: 20,
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
                child: Text("Date",style: GoogleFonts.poppins(
                color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700

                ),),
              )



            ),

          ]
          ),
        ),
          StreamBuilder(
              stream: _firestore2db.collection("ExamMaster").doc(widget.docid).collection(dropdownValue4).orderBy("timestamp").snapshots(),
              builder: (context,snap){

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
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
                                    child: Text(snap.data!.docs[index]["name"],style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 20,
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
                                    child: Text(snap.data!.docs[index]["date"],style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600

                                    ),),
                                  )



                              ),

                            ]
                        ),
                      );
                    });
              })
        ],
      ),

    );
  }
}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);