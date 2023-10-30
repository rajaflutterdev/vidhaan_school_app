import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vidhaan_school_app/submittedassignments.dart';

class AssignmentReports extends StatefulWidget {
  String staffreg;

  AssignmentReports(this.staffreg);

  @override
  State<AssignmentReports> createState() => _AssignmentReportsState();
}

class _AssignmentReportsState extends State<AssignmentReports> {
  final TextEditingController _typeAheadControllerclass =
      TextEditingController();
  final TextEditingController _typeAheadControllersection =
      TextEditingController();
  final TextEditingController duedate = TextEditingController();
  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();
  static final List<String> classes = [];
  static final List<String> section = [];
  static final List<String> subjects = [];

  String dropdownValue4 = "Class";
  String dropdownValue5 = "Section";
  String currentdate = "";

  adddropdownvalue() async {
    print("hello");
    setState(() {
      classes.clear();
      section.clear();
      subjects.clear();
    });
    var document =
        await _firestore2db.collection("ClassMaster").orderBy("order").get();
    var document2 =
        await _firestore2db.collection("SectionMaster").orderBy("order").get();
    setState(() {
      classes.add("Class");
      section.add("Section");
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
    var documentsub =
        await _firestore2db.collection("SubjectMaster").orderBy("order").get();
    setState(() {
      subjects.add("Subject");
    });
    for (int i = 0; i < documentsub.docs.length; i++) {
      setState(() {
        subjects.add(documentsub.docs[i]["name"]);
      });
    }
  }

  bool view = false;

  @override
  void initState() {
    adddropdownvalue();
    setState(() {
      duedate.text =
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
      String formattedDate2 = DateFormat('dMyyyy').format(DateTime.now());
      currentdate = formattedDate2;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Assignments Reports",
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: width / 16.363,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height / 37.8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.only(left: width / 36, right: width / 36),
                  height: height / 14.74,
                  width: width / 2.2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton2<String>(
                    value: dropdownValue4,
                    isExpanded: true,
                    style: TextStyle(
                        color: Color(0xff3D8CF8),
                        fontSize: width / 21.176,
                        fontWeight: FontWeight.w700),
                    underline: Container(
                      color: Color(0xff3D8CF8),
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue4 = value!;
                        _typeAheadControllerclass.text = value;
                      });
                      //getcount();
                    },
                    items:
                        classes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: width / 36, right: width / 36),
                  height: height / 14.74,
                  width: width / 2.2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton2<String>(
                    value: dropdownValue5,
                    isExpanded: true,
                    style: TextStyle(
                        color: Color(0xff3D8CF8),
                        fontSize: width / 21.176,
                        fontWeight: FontWeight.w700),
                    underline: Container(
                      color: Color(0xff3D8CF8),
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue5 = value!;
                        _typeAheadControllersection.text = value;
                      });
                      //getcount();
                    },
                    items:
                        section.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 50.4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.only(left: width / 36, right: width / 36),
                  height: height / 14.74,
                  width: width / 2.2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: duedate,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('dd/M/yyyy').format(pickedDate);
                        String formattedDate2 =
                            DateFormat('dMyyyy').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          duedate.text = formattedDate;
                          currentdate = formattedDate2;

                          //set output date to TextField value.
                        });
                        //getcount();
                      } else {
                        print("Date is not selected");
                      }
                    },
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: width / 25.714,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15),
                        suffixIcon:
                            Icon(Icons.calendar_month, color: Colors.black),
                        hintText: "Due Date",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: width / 25.714,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none),
                  ),
                ),
                Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  shadowColor: Color(0xff0873C4),
                  child: GestureDetector(
                    onTap: () {
                      print("i worked");
                      setState(() {
                        view = true;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(
                            left: width / 36, right: width / 36),
                        height: height / 14.74,
                        width: width / 2.2,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Color(0xff0873C4)),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            "View",
                            style: TextStyle(
                                color: Color(0xff3D8CF8),
                                fontSize: width / 16.363,
                                fontWeight: FontWeight.w700),
                          ),
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 37.8,
            ),
            view == true
                ? StreamBuilder(
                    stream: _firestore2db
                        .collection("homeworks")
                        .doc(currentdate.toString())
                        .collection(dropdownValue4.toString())
                        .doc(dropdownValue5.toString())
                        .collection("class HomeWorks")
                        .snapshots(),
                    builder: (context, snapshot2) {
                      if (snapshot2.hasData == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot2.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot2.data!.docs.length,
                        itemBuilder: (context, index) {
                          var subjecthomework = snapshot2.data!.docs[index];
                          return widget.staffreg ==
                                  subjecthomework['statffregno']
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height / 94.5,
                                      horizontal: width / 45),
                                  child: Container(
                                    width: width / 1.058,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                                                SizedBox(height: height / 145.6),

                                                ///subject Title
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: width / 24),
                                                  child: SizedBox(
                                                    width: width / 1.8,
                                                    child: Text(
                                                      "${subjecthomework['subject']} - ${subjecthomework['statffname']}",
                                                      style: GoogleFonts.poppins(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: width / 22.5),
                                                    ),
                                                  ),
                                                ),

                                                ///subject Description
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: width / 24),
                                                  child: SizedBox(
                                                    height: height / 21.6,
                                                    width: width / 1.7,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: width / 1.7,
                                                          child: Text(
                                                            subjecthomework['topic']==""?"No Topic":   subjecthomework['topic'],
                                                            textAlign:
                                                                TextAlign.left,
                                                            style:
                                                                GoogleFonts.poppins(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        width / 30),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                ///Subject assign date and time

                                                SizedBox(height: height / 145.6),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SubmittedAssign(
                                                                    currentdate
                                                                        .toString(),
                                                                    dropdownValue4,
                                                                    dropdownValue5,
                                                                    subjecthomework
                                                                        .id,subjecthomework['topic'])));
                                                  },
                                                  child: Container(
                                                      height: height / 20.9,
                                                      width: width / 3.90,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff0873C4),
                                                        border: Border.all(
                                                          color: Color(0xff0873C4),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "View",
                                                          style:
                                                              GoogleFonts.poppins(
                                                                  color:
                                                                      Colors.white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      width / 22.5),
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: height / 151.2,
                                                ),
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
                                                "Due Date: ${subjecthomework['Duedate']}",
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
                                                  3.8),
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
                                )
                              : Container();
                        },
                      );
                    },
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db =
    FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);
