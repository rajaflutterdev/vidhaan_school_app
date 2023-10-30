import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class View_Time_Table_Page extends StatefulWidget {
  String title;
  String docid;

  View_Time_Table_Page(this.title, this.docid);

  @override
  State<View_Time_Table_Page> createState() => _View_Time_Table_PageState();
}

class _View_Time_Table_PageState extends State<View_Time_Table_Page> {
  final TextEditingController _typeAheadControllerclass =
      TextEditingController();
  final TextEditingController _typeAheadControllersection =
      TextEditingController();
  final TextEditingController _typeAheadControllerstaffid =
      TextEditingController();

  static final List<String> classes = [];
  static final List<String> section = [];
  static final List<String> subject = [];

  String dropdownValue4 = "Class";
  String dropdownValue5 = "Section";
  String dropdownValue6 = "Subject";

  @override
  void initState() {
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
    var document =
        await _firestore2db.collection("ClassMaster").orderBy("order").get();
    var document2 =
        await _firestore2db.collection("SectionMaster").orderBy("order").get();

    setState(() {
      classes.add("Class");
      section.add("Section");
      subject.add("Subject");
    });
    for (int i = 0; i < document.docs.length; i++) {
      setState(() {
        classes.add(document.docs[i]["name"]);
      });
    }
    for (int i = 0; i < document2.docs.length; i++) {
      setState(() {
        section.add(document2.docs[i]["name"]);
      });
    }
  }

  subjectnamefunction() async {
    setState(() {
      subject.clear();
    });
    var document3 = await _firestore2db
        .collection("ExamMaster")
        .doc(widget.docid)
        .collection(dropdownValue4)
        .get();
    setState(() {
      subject.add("Subject");
    });
    for (int i = 0; i < document3.docs.length; i++) {
      setState(() {
        subject.add(document3.docs[i]["name"]);
      });
    }
    print(subject);
  }

  TextEditingController Totalmarkcontroller = TextEditingController();

  List<TextEditingController> controllers =
      List<TextEditingController>.generate(
          1000, (index) => TextEditingController());

  bool editMark = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.title}- TimeTable"),
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height/75.6,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ///Class dropdown
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height / 94.5, horizontal: width / 45),
                  child: Row(

                    children: [
                      Text(
                        "Select Class : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: width / 25,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: width / 75.6,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: width / 36, right: width / 36),
                        height: height / 18.74,
                        width: width / 2.4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton2<String>(
                          value: dropdownValue4,
                          isExpanded: true,
                          style: TextStyle(
                              color: Color(0xff3D8CF8),
                              fontSize: width / 24,
                              fontWeight: FontWeight.w700),
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
                          items: classes
                              .map<DropdownMenuItem<String>>((String value) {
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
                //
                // ///Section dropdown
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //       vertical: height / 94.5, horizontal: width / 45),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         "Section",
                //         style: TextStyle(
                //             color: Colors.black,
                //             fontSize: width / 25,
                //             fontWeight: FontWeight.w700),
                //       ),
                //       SizedBox(
                //         height: height / 75.6,
                //       ),
                //       Container(
                //         padding: EdgeInsets.only(
                //             left: width / 36, right: width / 36),
                //         height: height / 18.74,
                //         width: width / 2.4,
                //         decoration: BoxDecoration(
                //             color: Colors.white,
                //             border: Border.all(color: Colors.grey.shade300),
                //             borderRadius: BorderRadius.circular(10)),
                //         child: DropdownButton2<String>(
                //           value: dropdownValue5,
                //           isExpanded: true,
                //           style: TextStyle(
                //               color: Color(0xff3D8CF8),
                //               fontSize: width / 24,
                //               fontWeight: FontWeight.w700),
                //           underline: Container(
                //             color: Colors.deepPurpleAccent,
                //           ),
                //           onChanged: (String? value) {
                //             // This is called when the user selects an item.
                //             setState(() {
                //               dropdownValue5 = value!;
                //             });
                //           },
                //           items: section
                //               .map<DropdownMenuItem<String>>((String value) {
                //             return DropdownMenuItem<String>(
                //               value: value,
                //               child: Text(value),
                //             );
                //           }).toList(),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ]),
              Text(
                "Time Table",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: width / 22,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: height / 50.4),
              Padding(
                padding: EdgeInsets.only(left: width / 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: height / 18.9,
                      width: width / 2.4,
                      child: Center(
                        child: Text(
                          "Subject",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: width / 22,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                    ),
                    Container(
                      height: height / 18.9,
                      width: width / 2.4,
                      child: Center(
                        child: Text(
                          "Date",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: width / 22,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                    ),
                  ],
                ),
              ),

              StreamBuilder<QuerySnapshot>(
                  stream: _firestore2db
                      .collection("ExamMaster")
                      .where("name", isEqualTo: widget.title)
                      .snapshots(),
                  builder: (context, snap) {
                    if (snap.hasData == null) {
                      return Center(
                        child: Container(),
                      );
                    }
                    if (!snap.hasData) {
                      return Center(
                        child: Container(),
                      );
                    }

                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snap.data!.docs.length,
                        itemBuilder: (context, index) {
                          var studentdata = snap.data!.docs[index];

                          return StreamBuilder<QuerySnapshot>(
                              stream: _firestore2db
                                  .collection("ExamMaster")
                                  .doc(studentdata.id).collection(dropdownValue4).orderBy("timestamp2")
                                  .snapshots(),
                              builder: (context, snap2) {
                                if (snap2.hasData == null) {
                                  return Center(
                                    child: Container(),
                                  );
                                }
                                if (!snap2.hasData) {
                                  return Center(
                                    child: Container(),
                                  );
                                }

                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: snap2.data!.docs.length,
                                    itemBuilder: (context, index3) {
                                      var studentdata2 = snap2.data!.docs[index3];

                                      return Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width / 12),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: height / 18.9,
                                                  width: width / 2.4,
                                                  child: Center(
                                                    child: Text(
                                                      studentdata2['name'],
                                                      style: GoogleFonts
                                                          .poppins(
                                                              color: Colors
                                                                  .black,
                                                              fontSize:
                                                                  width /
                                                                      22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors
                                                              .black)),
                                                ),
                                                Container(
                                                  height: height / 18.9,
                                                  width: width / 2.4,
                                                  child: Center(
                                                    child: Text(
                                                      studentdata2['date'],
                                                      style: GoogleFonts
                                                          .poppins(
                                                              color: Colors
                                                                  .black,
                                                              fontSize:
                                                                  width /
                                                                      22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors
                                                              .black)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              });
                        });
                  })
            ],
          ),
        ));
  }
}

FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db =
    FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);
