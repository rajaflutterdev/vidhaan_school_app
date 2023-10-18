import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Records2 extends StatefulWidget {
  const Records2({Key? key}) : super(key: key);

  @override
  State<Records2> createState() => _Records2State();
}

class _Records2State extends State<Records2> {

  final TextEditingController _typeAheadControllerclass = TextEditingController();
  final TextEditingController _typeAheadControllersection = TextEditingController();
  final TextEditingController duedate = TextEditingController();
  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();
  static final List<String> classes = [];
  static final List<String> section = [];
  static final List<String> subjects = [];

  String dropdownValue4="Class";
  String dropdownValue5="Section";

  adddropdownvalue() async {
    print("hello");
    setState(() {
      classes.clear();
      section.clear();
      subjects.clear();
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
    var documentsub = await  _firestore2db.collection("SubjectMaster").orderBy("order").get();
    setState(() {
      subjects.add("Subject");

    });
    for(int i=0;i<documentsub.docs.length;i++) {
      setState(() {
        subjects.add(documentsub.docs[i]["name"]);
      });

    }
  }



  @override
  void initState() {
    adddropdownvalue();
    setState(() {
      duedate.text="${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
    });
    // TODO: implement initState
    super.initState();
  }
  int presentcount=0;
  int absentcount=0;

  getcount() async {
    var document1= await _firestore2db.collection("Attendance").doc("${dropdownValue4}${dropdownValue5}").collection(duedate.text).where("present",isEqualTo: true).get();
    var document2= await _firestore2db.collection("Attendance").doc("${dropdownValue4}${dropdownValue5}").collection(duedate.text).where("present",isEqualTo: false).get();
    setState(() {
      presentcount= document1.docs.length;
      absentcount= document2.docs.length;
    });


  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Students Attendance",style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700

        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Container(
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
                      color: Color(0xff3D8CF8),
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue4 = value!;
                        _typeAheadControllerclass.text = value;
                      });
                      getcount();

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

                Container(
                  padding: EdgeInsets.only(left: width/36,right: width/36),
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
                    value: dropdownValue5,
                    isExpanded: true,
                    style: TextStyle(
                        color: Color(0xff3D8CF8),
                        fontSize: 17,fontWeight: FontWeight.w700),
                    underline: Container(
                      color: Color(0xff3D8CF8),
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue5 = value!;
                        _typeAheadControllersection.text = value;
                      });
                      getcount();

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
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Container(
                  padding: EdgeInsets.only(left: width/36,right: width/36),
                  height: height / 14.74,
                  width: width / 2.363,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.grey),
                      borderRadius:
                      BorderRadius.circular(
                          12)),
                  child:TextField(
                    controller: duedate,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(),
                          firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101)
                      );

                      if(pickedDate != null ){
                        print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = DateFormat('d-M-yyyy').format(pickedDate);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {

                          duedate.text = formattedDate;

                          //set output date to TextField value.
                        });
                        getcount();




                      }else{
                        print("Date is not selected");
                      }
                    },
                    style: GoogleFonts
                        .poppins(
                      color: Colors
                          .black,
                      fontSize: 14,
                      fontWeight:
                      FontWeight
                          .w500,
                    ),

                    maxLines: 5,
                    minLines: 1,
                    decoration:
                    InputDecoration(
                        contentPadding: EdgeInsets.only(top:15),
                        suffixIcon: Icon(Icons.calendar_month,color:Colors.black),
                        hintText:
                        "Due Date",
                        hintStyle:
                        GoogleFonts
                            .poppins(
                          color: Colors
                              .black,
                          fontSize: 14,
                          fontWeight:
                          FontWeight
                              .w500,
                        ),
                        border:
                        InputBorder
                            .none),


                  ),


                ),
                Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  shadowColor: Color(0xff0873C4),
                  child: Container(
                    padding: EdgeInsets.only(left: width/36,right: width/36),
                    height: height / 14.74,
                    width: width / 2.363,
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
                                fontSize: 15,
                                fontWeight: FontWeight.w600

                            ),),

                            Text("Present",style: GoogleFonts.poppins(
                                color: Colors.green,
                                fontSize: 15,
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
                                fontSize: 15,
                                fontWeight: FontWeight.w600

                            ),),

                            Text("Absent",style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.w600

                            ),),
                          ],
                        ),
                      ],
                    ),


                  ),
                ),

              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(
                    width: width / 12),
                Text(
                  "Name",
                  style: GoogleFonts
                      .poppins(
                      color: Colors
                          .black,
                      fontSize: 15,
                      fontWeight:
                      FontWeight
                          .w600),
                ),
                SizedBox(
                    width: width / 3.2),
                Text(
                  "Present",
                  style: GoogleFonts
                      .poppins(
                      color: Colors
                          .black,
                      fontSize: 15,
                      fontWeight:
                      FontWeight
                          .w600),
                ),
                SizedBox(
                    width: width / 10),
                Text(
                  "Absent",
                  style: GoogleFonts
                      .poppins(
                      color: Colors
                          .black,
                      fontSize: 15,
                      fontWeight:
                      FontWeight
                          .w600),
                ),
              ],
            ),
            SizedBox(height: 15,),


            ///  title



            StreamBuilder<QuerySnapshot>(
                stream: _firestore2db.collection("Attendance").doc("${dropdownValue4}${dropdownValue5}").collection(duedate.text).
                orderBy("order").snapshots(),
                builder: (context, snapshot) {

                  if(snapshot.hasData==null){
                    return Center(child: CircularProgressIndicator(
                      color: Color(0xff0873c4),
                    ));
                  }
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(
                      color: Color(0xff0873c4),
                    ));
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder:(BuildContext context, index) {
                        return

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(bottom: width/50.4),
                                child: Container(

                                  width: width / 3.5,
                                  child: Text(
                                    snapshot.data!.docs[index]["stname"],
                                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(
                                    bottom: height/37.8,
                                    left: width/45),
                                child:
                                Container(
                                  height:
                                  height / 29.48,
                                  width:
                                  width / 10,
                                  decoration:
                                  BoxDecoration(shape: BoxShape.circle, border: Border.all(color:Colors.green)),
                                  child: Container(
                                    child: Icon(
                                      snapshot.data!.docs[index]["present"] == true ? Icons.check : null,
                                      color:Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                EdgeInsets.only(bottom: height/37.8),
                                child:
                                Container(
                                  height:
                                  height / 29.48,
                                  width:
                                  width / 10,
                                  decoration:
                                  BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.red)),
                                  child:
                                  Container(
                                    child: Icon(
                                      snapshot.data!.docs[index]["present"] == false ? Icons.clear : null,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),


                            ],
                          );
                      });
                }),
            SizedBox(height: height/25.2,),
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