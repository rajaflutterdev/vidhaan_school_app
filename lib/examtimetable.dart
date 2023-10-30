import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

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
        alignment: Alignment.topCenter,
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
                            controllerclear();
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
                                setthemarkfunction();
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total Mark" ,style: TextStyle(
                              color: Colors.black,
                              fontSize: width/25,fontWeight: FontWeight.w700),),
                          SizedBox(height: height/75.6,),
                          Container(
                            padding: EdgeInsets.only(left: width/26,right:  width/36),
                            height: height / 18.74,
                            width: width / 2.5,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey.shade300),
                                borderRadius:
                                BorderRadius.circular(8)),
                            child: TextField(
                              maxLength: 3,
                              keyboardType: TextInputType.number,
                              controller: Totalmarkcontroller,
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none
                              ),
                            ),



                          ),
                        ],
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
                    child:
                    Text("Subject",style: GoogleFonts.poppins(
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
                                      child: TextField(
                                        maxLength: 3,
                                        keyboardType: TextInputType.number,
                                        controller: controllers[index],
                                        decoration: InputDecoration(
                                            counterText: "",
                                            border: InputBorder.none
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


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){

                        if(editMark==true){
                          updatethestudentmarkfun();

                        }
                        else{
                          Examdocumentfunction();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: width / 36, right: width / 36),
                        height: height / 18.74,
                        width: width / 3.3,
                        decoration: BoxDecoration(
                            color: Color(0xff3D8CF8),
                            border: Border.all(
                                color: Colors.grey.shade300),
                            borderRadius:
                            BorderRadius.circular(10)),
                        child: Center(
                          child: Text("Submit", style: TextStyle(
                              color: Colors.white,
                              fontSize:width/18, fontWeight: FontWeight.w700),),
                        ),

                      ),
                    ),
                  ],
                ),
                SizedBox(height: height/30.24,),
              ],
            ),
          ),
          Loading==true?Padding(
            padding:  EdgeInsets.only(top: height/3.78),
            child: Material(
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
            ),
          ):const SizedBox()


        ],
      ),

    );
  }


  String documentid='';
  String subjectname="";
  bool Loading=false;

  Examdocumentfunction() async {
    setState(() {
      Loading=true;
      editMark=false;
    });
    var studentdata=await _firestore2db.collection("Students").where("admitclass",isEqualTo:dropdownValue4).where("section",isEqualTo:dropdownValue5).get();
  var examdata=await  _firestore2db.collection("ExamMaster").doc(widget.docid).collection(dropdownValue4).where("name",isEqualTo: dropdownValue6).get();
  print(examdata.docs.length);
    setState(() {
    documentid=examdata.docs[0].id;
    subjectname=examdata.docs[0]['name'];
  });
    for(int i=0;i<studentdata.docs.length;i++){

      _firestore2db.collection("ExamMaster").doc(widget.docid).collection(dropdownValue4).
      doc(documentid).collection("${dropdownValue4}-${dropdownValue5}Submmission").doc().set({
        "examname":widget.title,
        "name":studentdata.docs[i]['stname'],
        "regno":studentdata.docs[i]['regno'],
        "class":dropdownValue4,
        "section":dropdownValue5,
        "subject":subjectname,
        "mark":controllers[i].text==""?"0":controllers[i].text,
        "totalmark":Totalmarkcontroller.text,
        "percentage":controllers[i].text==""?"0":(((double.parse(controllers[i].text))/double.parse(Totalmarkcontroller.text))*100).toStringAsFixed(2),
        "timestamp":DateTime.now().millisecond,
        "time":"${DateFormat('hh:mm a').format(DateTime.now())}",
        "date":"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",

      });
      var docdata= await _firestore2db.collection("Students").doc(studentdata.docs[i].id).collection("Exams").get();

      if(docdata.docs.isNotEmpty){
        for(int s=0;s<docdata.docs.length;s++){
          var data2=await _firestore2db.collection("Students").doc(studentdata.docs[i].id).
          collection("Exams").doc(docdata.docs[s].id).collection("Timetable").get();
          for(int k=0;k<data2.docs.length;k++){
            if(data2.docs[k]['exam']==widget.title && data2.docs[k]['name']==dropdownValue6){
              _firestore2db.collection("Students").doc(studentdata.docs[i].id).
              collection("Exams").doc(docdata.docs[s].id).collection("Timetable").doc(data2.docs[k].id).update({
                "mark":controllers[i].text==""?"0":controllers[i].text,
                "total":Totalmarkcontroller.text,
                "date":"${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                "percentage":controllers[i].text==""?"0":(((double.parse(controllers[i].text.toString()))/double.parse(Totalmarkcontroller.text.toString()))*100).toStringAsFixed(2),
              });

            }
          }
        }
      }

    }
    setState(() {
      dropdownValue4="Class";
      dropdownValue5="Section";
      dropdownValue6="Subject";
      documentid='';
      subjectname="";
      Totalmarkcontroller.clear();
      controllers.clear();
      Loading=false;
    });
    print("Check---3");
    controllerclear();
    successpopup("Submitted Successfully");
  }

  controllerclear(){
    for(int j=0;j<controllers.length;j++){
      setState(() {
        controllers[j].clear();

      });
    }
  }

  successpopup(Name) {
    return showDialog(
        context: context,
        builder: (context) {
          double height = MediaQuery
              .of(context)
              .size
              .height;
          double width = MediaQuery
              .of(context)
              .size
              .width;
          return AlertDialog(
            content: Container(
              height: height/3.83714286,
              width: width/1.03157895,
              child: Column(
                children: [
                  Text(Name,style: GoogleFonts.poppins(

                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: width/25.68),),
                  Lottie.asset("assets/gMMZ6teGnn.json"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }


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
    if(filledmarkdata.docs.length>0){
      Alredysubmittedmarkpopup();
    }
    setState(() {
      Loading=false;
    });


  }


  Alredysubmittedmarkpopup(){
    print("Enter Alertdialog");
    return
      showDialog(context: context, builder:(context) {
        return
          StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Marks are Assigned",style: TextStyle(fontSize: 14),),
                ],
              ),
              actions: [
                TextButton(onPressed:(){
                  Navigator.pop(context);
                  Navigator.pop(context);

                }, child: Text("Cancel")),
                GestureDetector(
                  onTap: (){
                    setState((){
                      editMark=true;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.indigo.withOpacity(0.7),
                    ),
                    child: Center(
                      child: Text("Edit",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                )

              ],
            );
          },);
      },);

  }



  updatethestudentmarkfun() async {
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
   
    var examsubmission=await _firestore2db.collection("ExamMaster").doc(widget.docid).
    collection(dropdownValue4).doc(documentid).collection("${dropdownValue4}-${dropdownValue5}Submmission").orderBy("regno").get();
    for(int k=0;k<examsubmission.docs.length;k++){
      _firestore2db.collection("ExamMaster").doc(widget.docid).
      collection(dropdownValue4).doc(documentid).collection("${dropdownValue4}-${dropdownValue5}Submmission").
      doc(examsubmission.docs[k].id).update({
        "mark":controllers[k].text,
        "totalmark":Totalmarkcontroller.text
      });

    }



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
                _firestore2db.collection("Students").doc(studentdata.docs[i].id).
                collection("Exams").doc(docdata.docs[s].id).collection("Timetable").doc(data2.docs[k].id).update({
                  "mark":controllers[i].text,
                  "total":Totalmarkcontroller.text
                });

              }
            }


          }
        }
      }


    }

    setState(() {
      dropdownValue4="Class";
      dropdownValue5="Section";
      dropdownValue6="Subject";
      documentid='';
      subjectname="";
      Totalmarkcontroller.clear();
      controllers.clear();
      Loading=false;
      editMark=false;
    });

    controllerclear();
    successpopup("Edit Marks Successfully");

  }
  
  
  
}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);