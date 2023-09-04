import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'StudentAttendance_Page.dart';
import 'StudentExam_Page.dart';
import 'Student_Profile.dart';
import 'StudentsExam.dart';

class Student_landing_Page extends StatefulWidget {
  const Student_landing_Page({Key? key}) : super(key: key);

  @override
  State<Student_landing_Page> createState() => _Student_landing_PageState();
}

class _Student_landing_PageState extends State<Student_landing_Page> {
  int selecteIndexvalue = 0;

  String page = "Home";
  String Studentid = "";
  String Studentname = '';
  String Studentregno = '';
  String Studentimg = '';

  studentdetails() async {
    var document =
        await _firestore2db.collection("Students").get();
    for (int i = 0; i < document.docs.length; i++) {
      if (document.docs[i]["studentid"] ==
          _firebaseauth2db.currentUser!.uid) {
        setState(() {
          Studentid = document.docs[i].id;
        });
        print("Student:${Studentid}");
        print(Studentid);
      }
      if (Studentid.isNotEmpty) {
        var studentdocument = await _firestore2db
            .collection("Students")
            .doc(Studentid)
            .get();
        Map<String, dynamic>? stuvalue = studentdocument.data();
        final split = stuvalue!['stname'].split(' ');
        final Map<int, String> values = {
          for (int k = 0; k < split.length; k++)
            k: split[k]
        } ;
        print("ghdfghdfghdfugdfgdfgfdggdfg");
        setState((){
          Studentname=values[0]!;
        });
        print(values[0]);
        setState(() {
          Studentregno = stuvalue['regno'];
          Studentimg = stuvalue['imgurl'];
        });
      }
    }
    ;
  }

  Date() {
    Period.clear();
    setState(() {
      Period.clear();
      day = DateFormat('EEEE').format(DateTime.now());

      cyear = DateTime.now().year;
      cmonth = getMonth(DateTime.now().month);

      currentDate = DateTime.now().day;
    });

    print(day);
    print(currentDate);
  }

  String getMonth(int currentMonthIndex) {
    return DateFormat('MMM').format(DateTime(0, currentMonthIndex)).toString();
  }

  List Period = [];

  final GlobalKey<ScaffoldState> key = GlobalKey();


  String currentdate="${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}";
  int currentDate = 0;
  int cyear = 0;
  String cmonth = "";
  String day = "";
  String month = "";

  TextEditingController Searchcontroller = TextEditingController();
  final DateFormat formatter = DateFormat('dd / M / yyyy');
  String formattedDate =
      '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}';
  int dates = DateTime.now().day;
  int year = DateTime.now().year;
  int month2 = DateTime.now().month;
  String selectdate = '';
  TextEditingController homecoller = TextEditingController();
  dynamic formatterDate = DateFormat('dd');
  dynamic currentTime = DateFormat.jm().format(DateTime.now());

  @override
  void initState() {
    studentdetails();
    studentattendancestatus();
    Date();
    // TODO: implement initState
    super.initState();
  }

  ///stuydent attendance length function
  int Absentvalue = 0;
  int presentvalue = 0;

  studentattendancestatus() async {
    var studentdocument = await _firestore2db
        .collection("Students")
        .doc(Studentid)
        .collection('Attendance')
        .where("Attendance", isEqualTo: "Present")
        .get();
    setState(() {
      presentvalue = studentdocument.docs.length;
    });

    var studentdocument2 = await _firestore2db
        .collection("Students")
        .doc(Studentid)
        .collection('Attendance')
        .where("Attendance", isEqualTo: "Absent")
        .get();
    setState(() {
      Absentvalue = studentdocument2.docs.length;
    });
  }

  ///home work select variable
  int Hmselected = 1;

  ///timetable select variable
  int TTselected = 1;
  demo(){}
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
      endDrawer: Drawer(
        backgroundColor:Color(0xff0873C4),

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:height/25.2),

              Container(
                  height: height/3.0,
                  width: double.infinity,
                  decoration: const BoxDecoration(

                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/Rectangle.png")
                      )
                  ),
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Stack(
                            children: [

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: height / 25.745, left: width / 40.4),
                                    child: CircleAvatar(
                                      radius: 64,
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage:  NetworkImage(
                                          Studentimg
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 5,),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: width / 10),
                                        child: Text(
                                          Studentname, style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold

                                        ),),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: width / 15),
                                        child: Text("ID : ${Studentregno}",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize:width/22.5,
                                              fontWeight: FontWeight.w500

                                          ),),
                                      )
                                    ],
                                  ),


                                ],
                              ),

                              Positioned(
                                bottom: height / 13.45, left: width / 4.6,
                                child: const CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.create_outlined,
                                      color: Colors.black, size: 26,)
                                ),
                              )

                            ]
                        ),
                      ),

                    ],
                  )),

              InkWell(
                onTap:(){

                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.home,color: Colors.white,),
                    title: Text("Home",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),

              
              InkWell(
                onTap:(){


                  key.currentState!.closeEndDrawer();
                },
                child: Container(

                  child: ListTile(
                    leading: Icon(Icons.assignment,color: Colors.white,),
                    title: Text("Exams",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),


              InkWell(
                onTap:(){

                  Navigator.push(context, MaterialPageRoute(builder: (context) =>Student_Profile(Studentid) ,));
                  key.currentState!.closeEndDrawer();
                },
                child: Container(

                  child: ListTile(
                    leading: Icon(Icons.person_outline,color: Colors.white,),
                    title: Text("Profile",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),

              InkWell(
                onTap:(){
                  setState((){
                    page = "Attendance";
                  });
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.calendar_month_outlined,color: Colors.white,),
                    title: Text("Attendance",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),

              InkWell(
                onTap:(){
                  setState((){
                    page = "Home Works";
                  });
                  key.currentState!.closeEndDrawer();

                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.note_alt,color: Colors.white,),
                    title: Text("Home Works",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),
              
              InkWell(
                onTap:(){
                  setState((){
                    page = "Circulars";
                  });
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.note_alt_outlined,color: Colors.white,),
                    title: Text("Circulars",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),


              InkWell(
                onTap:(){
                  setState((){
                    page = "Time Table";
                  });
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.timer_outlined,color: Colors.white,),
                    title: Text("Time Table",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
      backgroundColor:selecteIndexvalue==3?
      Color(0xffFFFFFF): Color(0xff0873C4),
      body: selecteIndexvalue==0?
      WillPopScope(
          onWillPop: () {
          if (page == "Home") {
            Navigator.pop(context);
          } else {
            setState(() {
              page = "Home";
            });
          }
          return demo();
        },
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 700),
                curve: Curves.ease,
                height: page == "Home"
                    ? height / 2.256
                    : page == "Attendance"
                        ? height / 4.56
                        : page == "Home Works"
                            ? height / 4.56
                            : page == "Behaviour"
                                ? 76.123
                                : page == "Circulars"
                                    ? 166.0
                                    : page == "Time Table"
                                        ? 166.0
                                        : page == "Messages"
                                            ? 76.123
                                            : 0,
                child:
                        page == "Behaviour" ||
                        page == "Messages"
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: height / 15.12, left: width / 36),
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(Studentimg),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width / 36,
                                              top: height / 15.12),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: width / 1.736,
                                                height: height / 18.9,
                                                child: Text(
                                                  "Hello ${Studentname}!",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 26,
                                                      textStyle: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis)),
                                                ),
                                              ),
                                              SizedBox(width: width / 72),

                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      key.currentState!
                                                          .openEndDrawer();
                                                    },
                                                    child: Container(
                                                        height: height / 20.47,
                                                        width: width / 10.333,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    Colors.white,
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(5)),
                                                        child: Icon(
                                                            Icons.menu_sharp,
                                                            color: Colors.white)),
                                                  ),
                                                ],
                                              ),

                                              /// two image containers
                                            ],
                                          ),
                                        ), // headline
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: width / 36),
                                          child: Text(
                                            "ID : ${Studentregno}",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                        ), //
                                      ],
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: height / 38.566,
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1.5,
                            endIndent: 10,
                            indent: 10,
                          ),
                          page == "Attendance" || page == "Home Works"||page == "Time Table"||page == "Circulars"
                              ? Container()
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [


                              Padding(
                                padding: EdgeInsets.only(
                                    left: width / 36,
                                    right: width / 36,
                                    top: height / 50.4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "This week",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        ),
                                        SizedBox(width: width * 2 / 368.5),
                                        Icon(
                                          Icons.info_outline_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ],
                                    ),

                                    /// select Date

                                    Row(
                                      children: [
                                        Container(
                                            height: height / 24.566,
                                            width: width / 12,
                                            child: Icon(
                                                Icons.calendar_month_outlined,
                                                color: Color(0xffffffff))),
                                        SizedBox(width: width / 150),
                                        Text(
                                          "${cmonth.toString()} ${cyear.toString()}",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 19),
                                        ),
                                      ],
                                    ),

                                    /// current year
                                  ],
                                ),
                              ),

                              SizedBox(height: height / 50.944),

                              /// Select Date
                              IgnorePointer(
                                child: CalendarTimeline(
                                  dayNameColor: Colors.white,
                                  initialDate: DateTime(year, month2, dates),
                                  firstDate: DateTime(1990, 1, 15),
                                  lastDate: DateTime(2050, 11, 20),
                                  onDateSelected: (date) {
                                    setState(() {
                                      dates = date.day;
                                      month2 = date.month;
                                      year = date.year;
                                      formattedDate =
                                          DateFormat('ddMyyyy').format(date);
                                      selectdate =
                                          DateFormat('dd/M/yyyy').format(date);
                                    });
                                    print(formattedDate);
                                  },
                                  leftMargin: 20,
                                  monthColor: Colors.white,
                                  dayColor: Colors.white,
                                  activeDayColor: Color(0xff0873C4),
                                  activeBackgroundDayColor: Colors.white,
                                  dotsColor: Colors.white,
                                  locale: 'en_ISO',
                                ),
                              ),

                              SizedBox(height: height / 120.33),

                              Container(
                                height: 1,
                                width: width / 0.947,
                                color: Colors.white,
                              )

                            ],
                          ),
                        ],
                      ),
              ),

              SizedBox(height: height / 52.125),

              Stack(
                children: [
                  Container(
                    height: height / 24.566,
                    width: double.infinity,
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: height / 25.2),
                    child: Container(
                        height: page == "Home" ? height / 1.474 : height / 1.1338,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(35),
                                topLeft: Radius.circular(35))),
                        child: page == "Home"
                            ? Padding(
                                padding: EdgeInsets.only(top: height / 20.12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: width / 45),
                                      child: Text(
                                        "Dashboard,",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ///Days present circular
                                        Column(
                                          children: [
                                            CircularPercentIndicator(
                                                radius: 43,
                                                lineWidth: 10.0,
                                                percent: 1,
                                                center: Text(
                                                    presentvalue.toString(),
                                                    style: GoogleFonts.montserrat(
                                                        fontSize: width / 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.yellow)),
                                                linearGradient:
                                                    const LinearGradient(
                                                        begin: Alignment.topRight,
                                                        end: Alignment.bottomLeft,
                                                        colors: <Color>[
                                                      Colors.yellowAccent,
                                                      Colors.yellow
                                                    ]),
                                                rotateLinearGradient: true,
                                                circularStrokeCap:
                                                    CircularStrokeCap.round),
                                            SizedBox(height: 5),
                                            Text("Days, Present",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ],
                                        ),
                                        SizedBox(width: 80),

                                        ///Days Absent circular
                                        Column(
                                          children: [
                                            CircularPercentIndicator(
                                                radius: 43,
                                                lineWidth: 10.0,
                                                percent: 1,
                                                center: Text(
                                                    Absentvalue.toString(),
                                                    style: GoogleFonts.montserrat(
                                                        fontSize: width / 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red)),
                                                linearGradient:
                                                    const LinearGradient(
                                                        begin: Alignment.topRight,
                                                        end: Alignment.bottomLeft,
                                                        colors: <Color>[
                                                      Colors.red,
                                                      Colors.redAccent,
                                                    ]),
                                                rotateLinearGradient: true,
                                                circularStrokeCap:
                                                    CircularStrokeCap.round),
                                            SizedBox(height: 5),
                                            Text("Days, Absent",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: height / 37.8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          /// Attendance
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                page = "Attendance";
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.calendar_month_outlined,
                                                  color: Color(0xff609F00),
                                                  size: width / 12,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: width / 45,
                                                      right: width / 45,
                                                      top: height / 94.5,
                                                      bottom: height / 94.5),
                                                  child: Text(
                                                    "Attendance",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          ///  home works
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                page = "Home Works";
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Icon(Icons.note_alt_sharp,
                                                    color: Color(0xffFECE3E),
                                                    size: width / 12),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: width / 45,
                                                      right: width / 45,
                                                      top: height / 94.5,
                                                      bottom: height / 94.5),
                                                  child: Text(
                                                    "Home Works",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          ///  Time Table
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                page = "Time Table";
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Icon(Icons.timer_outlined,
                                                    color: Color(0xff224FFF),
                                                    size: width / 12),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: width / 45,
                                                      right: width / 45,
                                                      top: height / 94.5,
                                                      bottom: height / 94.5),
                                                  child: Text(
                                                    "Time Table",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : page == "Home Works"
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: width / 36,
                                        right: width / 36,
                                        top: height / 15.12),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "HomeWork's",
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width:300,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                                                      style:
                                                      GoogleFonts.poppins(
                                                          color: Colors.grey
                                                              .shade700,
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500),
                                                    ),
                                                    SizedBox(
                                                      width: width / 100,
                                                    ),
                                                    Container(
                                                      height: height / 49.13,
                                                      width: width / 170,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      width: width / 100,
                                                    ),
                                                    Text(
                                                      day,
                                                      style:
                                                      GoogleFonts.poppins(
                                                          color: Colors.grey
                                                              .shade700,
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              InkWell(
                                                onTap:(){
                                                  setState(() {
                                                    page = "Home";
                                                  });
                                                },
                                                child: Padding(                                                          padding:  EdgeInsets.only(right:8.0),
                                                  child: Icon(Icons.arrow_circle_down_sharp,
                                                    size: 30,
                                                    color: Color(0xff0873C4),),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: height / 36.85),

                                          ///selection chips
                                          SingleChildScrollView(
                                            physics: ScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            child: SizedBox(
                                              width: 440,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                children: [
                                                  ///Today's Button
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        Hmselected = 1;
                                                        currentdate="${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}";
                                                      });
                                                    },
                                                    child: Container(
                                                        height: 40,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                          color: Hmselected == 1
                                                              ? Color(0xff0873C4)
                                                              : Color(0xffF0EFEF),
                                                          border: Border.all(
                                                            color: Hmselected == 1
                                                                ? Colors
                                                                    .transparent
                                                                : Color(
                                                                    0xff0873C4),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Today's",
                                                            style: GoogleFonts.poppins(
                                                                color: Hmselected ==
                                                                        1
                                                                    ? Colors.white
                                                                    : Color(
                                                                        0xff0873C4),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 16),
                                                          ),
                                                        )),
                                                  ),

                                                  ///Yesterday
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        Hmselected = 2;
                                                        currentdate="${DateTime.now().day-1}${DateTime.now().month}${DateTime.now().year}";
                                                      });
                                                    },
                                                    child: Container(
                                                        height: 40,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                          color: Hmselected == 2
                                                              ? Color(0xff0873C4)
                                                              : Color(0xffF0EFEF),
                                                          border: Border.all(
                                                            color: Hmselected == 2
                                                                ? Colors
                                                                    .transparent
                                                                : Color(
                                                                    0xff0873C4),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Yesterday",
                                                            style: GoogleFonts.poppins(
                                                                color: Hmselected ==
                                                                        2
                                                                    ? Colors.white
                                                                    : Color(
                                                                        0xff0873C4),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 16),
                                                          ),
                                                        )),
                                                  ),

                                                  ///month
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        Hmselected = 3;
                                                      });
                                                    },
                                                    child: Container(
                                                        height: 40,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                          color: Hmselected == 3
                                                              ? Color(0xff0873C4)
                                                              : Color(0xffF0EFEF),
                                                          border: Border.all(
                                                            color: Hmselected == 3
                                                                ? Colors
                                                                    .transparent
                                                                : Color(
                                                                    0xff0873C4),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Month",
                                                            style: GoogleFonts.poppins(
                                                                color: Hmselected ==
                                                                        3
                                                                    ? Colors.white
                                                                    : Color(
                                                                        0xff0873C4),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 16),
                                                          ),
                                                        )),
                                                  ),

                                                  ///custom
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        Hmselected = 4;
                                                      });
                                                    },
                                                    child: Container(
                                                        height: 40,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                          color: Hmselected == 4
                                                              ? Color(0xff0873C4)
                                                              : Color(0xffF0EFEF),
                                                          border: Border.all(
                                                            color: Hmselected == 4
                                                                ? Colors
                                                                    .transparent
                                                                : Color(
                                                                    0xff0873C4),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Custom",
                                                            style: GoogleFonts.poppins(
                                                                color: Hmselected ==
                                                                        4
                                                                    ? Colors.white
                                                                    : Color(
                                                                        0xff0873C4),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 16),
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: height / 36.85),

                                          ///Listout the HomeWork
                                          FutureBuilder<dynamic>(
                                            future: _firestore2db.collection("Students").doc(Studentid).get(),
                                            builder: (context, snapshot) {
                                              var value=snapshot.data!.data();

                                              if(snapshot.hasData==null){
                                                return Center(child: CircularProgressIndicator(),);

                                              }
                                              if(!snapshot.hasData){
                                                return Center(child: CircularProgressIndicator(),);

                                              }
                                              return StreamBuilder(
                                                stream: _firestore2db.collection("homeworks").doc(currentdate.toString()).
                                                collection(value['admitclass'].toString()).doc(value['section'].toString()).
                                                collection("class HomeWorks").snapshots(),
                                                builder: (context, snapshot2) {
                                                  if(snapshot2.hasData==null){
                                                    return Center(child: CircularProgressIndicator(),);
                                                  }
                                                  if(!snapshot2.hasData){
                                                    return Center(child: CircularProgressIndicator(),);
                                                  }
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: snapshot2.data!.docs.length,
                                                    itemBuilder: (context, index) {
                                                      var subjecthomework=snapshot2.data!.docs[index];
                                                      return  Container(
                                                        height: 100,
                                                        width: 340,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(10),
                                                            border: Border.all(
                                                                color: Color(0xff999999))),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(height: 10),

                                                            ///subject Title
                                                            Padding(
                                                              padding:
                                                              EdgeInsets.only(left: 15.0),
                                                              child: SizedBox(
                                                                width: 250,
                                                                child: Text(
                                                                  "Tamil",
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
                                                                width: 305,
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Text(
                                                                      subjecthomework['des'],
                                                                      textAlign:
                                                                      TextAlign.left,
                                                                      style:
                                                                      GoogleFonts.poppins(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize: 12),
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
                                                      );

                                                    },);
                                                },);

                                            },
                                          ),


                                          SizedBox(height: height / 5.0),
                                        ],
                                      ),
                                    ),
                                  )
                                : page == "Attendance"
                                    ? Padding(
                                        padding:
                                            EdgeInsets.only(top: height / 25.2),
                                        child: Container(
                                          height: height / 32.48,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(35),
                                                  topLeft: Radius.circular(35))),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: width / 36,
                                                right: width / 36,
                                                top: height / 192),
                                            child: SingleChildScrollView(
                                              physics: ScrollPhysics(),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Attendance",
                                                    style: GoogleFonts.poppins(
                                                        color:
                                                            Colors.blueAccent,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),

                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width:300,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                                                              style:
                                                              GoogleFonts.poppins(
                                                                  color: Colors.grey
                                                                      .shade700,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ),
                                                            SizedBox(
                                                              width: width / 100,
                                                            ),
                                                            Container(
                                                              height: height / 49.13,
                                                              width: width / 170,
                                                              color: Colors.grey,
                                                            ),
                                                            SizedBox(
                                                              width: width / 100,
                                                            ),
                                                            Text(
                                                              day,
                                                              style:
                                                              GoogleFonts.poppins(
                                                                  color: Colors.grey
                                                                      .shade700,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      InkWell(
                                                        onTap:(){
                                                          setState(() {
                                                            page = "Home";
                                                          });
                                                        },
                                                        child: Padding(                                                          padding:  EdgeInsets.only(right:8.0),
                                                          child: Icon(Icons.arrow_circle_down_sharp,
                                                            size: 30,
                                                            color: Color(0xff0873C4),),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  /// date/day

                                                  SizedBox(
                                                    height: height / 49.13,
                                                  ),

                                                  Divider(
                                                    color: Colors.grey.shade400,
                                                    thickness: 1.5,
                                                  ),

                                                  ///calender in Widget
                                                   Container(

                                                        //color:Colors.red,
                                                        child: StudentAttendance_Page(Studentid),),



                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 15,
                                                        left: 3,
                                                        right: 8,
                                                        bottom: 8),
                                                    child: Text("Absent Days",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 18)),
                                                  ),

                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Container(
                                                      height: 40,
                                                      width: 320,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffFF0303),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10)),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 15),
                                                          ClipOval(
                                                            child: Container(
                                                                height: 15,
                                                                width: 15,
                                                                color:
                                                                    Colors.white),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(height: height / 5.0),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : page == "Time Table"
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                top: height / 25.2),
                                            child: Container(
                                              height: height / 1.474,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(35),
                                                      topLeft:
                                                          Radius.circular(35))),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: width / 36,
                                                    right: width / 36,
                                                    top: width / 75.6),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // physics: NeverScrollableScrollPhysics(),
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          page = "Home";
                                                        });
                                                      },
                                                      child: Text(
                                                        "Time Table",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color:
                                                                    Colors.black,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),

                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width:300,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                                                                style:
                                                                GoogleFonts.poppins(
                                                                    color: Colors.grey
                                                                        .shade700,
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ),
                                                              SizedBox(
                                                                width: width / 100,
                                                              ),
                                                              Container(
                                                                height: height / 49.13,
                                                                width: width / 170,
                                                                color: Colors.grey,
                                                              ),
                                                              SizedBox(
                                                                width: width / 100,
                                                              ),
                                                              Text(
                                                                day,
                                                                style:
                                                                GoogleFonts.poppins(
                                                                    color: Colors.grey
                                                                        .shade700,
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        InkWell(
                                                          onTap:(){
                                                            setState(() {
                                                              page = "Home";
                                                            });
                                                          },
                                                          child: Padding(                                                          padding:  EdgeInsets.only(right:8.0),
                                                            child: Icon(Icons.arrow_circle_down_sharp,
                                                              size: 30,
                                                              color: Color(0xff0873C4),),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height / 92.125,
                                                    ),

                                                    ///selection chips
                                                    SingleChildScrollView(
                                                      physics: ScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: SizedBox(
                                                        width: 840,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            ///Today's Button
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  TTselected = 1;
                                                                });
                                                              },
                                                              child: Container(
                                                                  height: 40,
                                                                  width: 105,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: TTselected ==
                                                                            1
                                                                        ? Color(
                                                                            0xff0873C4)
                                                                        : Color(
                                                                            0xffF0EFEF),
                                                                    border: Border
                                                                        .all(
                                                                      color: TTselected ==
                                                                              1
                                                                          ? Colors
                                                                              .transparent
                                                                          : Color(
                                                                              0xff0873C4),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Today's",
                                                                      style: GoogleFonts.poppins(
                                                                          color: TTselected ==
                                                                                  1
                                                                              ? Colors
                                                                                  .white
                                                                              : Color(
                                                                                  0xff0873C4),
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w700,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  )),
                                                            ),

                                                            ///MOnday
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  TTselected = 2;
                                                                });
                                                              },
                                                              child: Container(
                                                                  height: 40,
                                                                  width: 105,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: TTselected ==
                                                                            2
                                                                        ? Color(
                                                                            0xff0873C4)
                                                                        : Color(
                                                                            0xffF0EFEF),
                                                                    border: Border
                                                                        .all(
                                                                      color: TTselected ==
                                                                              2
                                                                          ? Colors
                                                                              .transparent
                                                                          : Color(
                                                                              0xff0873C4),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Monday",
                                                                      style: GoogleFonts.poppins(
                                                                          color: TTselected ==
                                                                                  2
                                                                              ? Colors
                                                                                  .white
                                                                              : Color(
                                                                                  0xff0873C4),
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w700,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  )),
                                                            ),

                                                            ///Tuesday
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  TTselected = 3;
                                                                });
                                                              },
                                                              child: Container(
                                                                  height: 40,
                                                                  width: 105,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: TTselected ==
                                                                            3
                                                                        ? Color(
                                                                            0xff0873C4)
                                                                        : Color(
                                                                            0xffF0EFEF),
                                                                    border: Border
                                                                        .all(
                                                                      color: TTselected ==
                                                                              3
                                                                          ? Colors
                                                                              .transparent
                                                                          : Color(
                                                                              0xff0873C4),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Tuesday",
                                                                      style: GoogleFonts.poppins(
                                                                          color: TTselected ==
                                                                                  3
                                                                              ? Colors
                                                                                  .white
                                                                              : Color(
                                                                                  0xff0873C4),
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w700,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  )),
                                                            ),

                                                            ///Wednesday
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  TTselected = 4;
                                                                });
                                                              },
                                                              child: Container(
                                                                  height: 40,
                                                                  width: 105,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: TTselected ==
                                                                            4
                                                                        ? Color(
                                                                            0xff0873C4)
                                                                        : Color(
                                                                            0xffF0EFEF),
                                                                    border: Border
                                                                        .all(
                                                                      color: TTselected ==
                                                                              4
                                                                          ? Colors
                                                                              .transparent
                                                                          : Color(
                                                                              0xff0873C4),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Wednesday",
                                                                      style: GoogleFonts.poppins(
                                                                          color: TTselected ==
                                                                                  4
                                                                              ? Colors
                                                                                  .white
                                                                              : Color(
                                                                                  0xff0873C4),
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w700,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  )),
                                                            ),

                                                            ///Thursday
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  TTselected = 4;
                                                                });
                                                              },
                                                              child: Container(
                                                                  height: 40,
                                                                  width: 105,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: TTselected ==
                                                                            4
                                                                        ? Color(
                                                                            0xff0873C4)
                                                                        : Color(
                                                                            0xffF0EFEF),
                                                                    border: Border
                                                                        .all(
                                                                      color: TTselected ==
                                                                              4
                                                                          ? Colors
                                                                              .transparent
                                                                          : Color(
                                                                              0xff0873C4),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Thursday",
                                                                      style: GoogleFonts.poppins(
                                                                          color: TTselected ==
                                                                                  4
                                                                              ? Colors
                                                                                  .white
                                                                              : Color(
                                                                                  0xff0873C4),
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w700,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  )),
                                                            ),

                                                            ///Friday
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  TTselected = 5;
                                                                });
                                                              },
                                                              child: Container(
                                                                  height: 40,
                                                                  width: 105,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: TTselected ==
                                                                            5
                                                                        ? Color(
                                                                            0xff0873C4)
                                                                        : Color(
                                                                            0xffF0EFEF),
                                                                    border: Border
                                                                        .all(
                                                                      color: TTselected ==
                                                                              5
                                                                          ? Colors
                                                                              .transparent
                                                                          : Color(
                                                                              0xff0873C4),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Friday",
                                                                      style: GoogleFonts.poppins(
                                                                          color: TTselected ==
                                                                                  5
                                                                              ? Colors
                                                                                  .white
                                                                              : Color(
                                                                                  0xff0873C4),
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w700,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  )),
                                                            ),

                                                            ///Saturday
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  TTselected = 6;
                                                                });
                                                              },
                                                              child: Container(
                                                                  height: 40,
                                                                  width: 105,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: TTselected ==
                                                                            6
                                                                        ? Color(
                                                                            0xff0873C4)
                                                                        : Color(
                                                                            0xffF0EFEF),
                                                                    border: Border
                                                                        .all(
                                                                      color: TTselected ==
                                                                              6
                                                                          ? Colors
                                                                              .transparent
                                                                          : Color(
                                                                              0xff0873C4),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Saturday",
                                                                      style: GoogleFonts.poppins(
                                                                          color: TTselected ==
                                                                                  6
                                                                              ? Colors
                                                                                  .white
                                                                              : Color(
                                                                                  0xff0873C4),
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w700,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      height: height / 20.125,
                                                    ),

                                                    ///subject hour and section details text and container
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Stack(children: [
                                                            Container(
                                                              height:
                                                                  height / 18.425,
                                                              width: width / 1.1,
                                                              decoration: BoxDecoration(
                                                                  color: Color(
                                                                      0xffECECEC),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18)),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: width /
                                                                            4.0),
                                                                    child: Text(
                                                                      "7th Grade C Section",
                                                                      style: GoogleFonts.poppins(
                                                                          color: Colors
                                                                              .blueAccent,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      left: 1.3,
                                                                      top: 1.5),
                                                              child: Container(
                                                                height:
                                                                    height / 20.0,
                                                                width:
                                                                    width / 4.285,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                18)),
                                                                child: Center(
                                                                  child: Text(
                                                                    "1 HR",
                                                                    style: GoogleFonts.poppins(
                                                                        color: Colors
                                                                            .blueAccent,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ]),
                                                        ],
                                                      ),
                                                    ),

                                                    SizedBox(
                                                        height: height / 5.0),

                                                    /*Flexible(
                                                                child: ListView(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  children: [
                                                                    // SizedBox(
                                                                    //     height: height /
                                                                    //         49.133),






                                                                    SizedBox(height: height/5.04,)
                                                                  ],
                                                                ),
                                                              ),*/
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : page == "Circulars"
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: height / 25.2),
                                                child: Container(
                                                  height: height / 1.474,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(35),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      35))),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: width / 36,
                                                        right: width / 36,
                                                        top: width / 75.6),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      // physics: NeverScrollableScrollPhysics(),
                                                      children: [
                                                        Text(
                                                          "Circulars",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:300,
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                                                                    style:
                                                                    GoogleFonts.poppins(
                                                                        color: Colors.grey
                                                                            .shade700,
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ),
                                                                  SizedBox(
                                                                    width: width / 100,
                                                                  ),
                                                                  Container(
                                                                    height: height / 49.13,
                                                                    width: width / 170,
                                                                    color: Colors.grey,
                                                                  ),
                                                                  SizedBox(
                                                                    width: width / 100,
                                                                  ),
                                                                  Text(
                                                                    day,
                                                                    style:
                                                                    GoogleFonts.poppins(
                                                                        color: Colors.grey
                                                                            .shade700,
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            InkWell(
                                                              onTap:(){
                                                                setState(() {
                                                                  page = "Home";
                                                                  selecteIndexvalue=1;
                                                                });
                                                              },
                                                              child: Padding(                                                          padding:  EdgeInsets.only(right:8.0),
                                                                child: Icon(Icons.arrow_circle_down_sharp,
                                                                  size: 30,
                                                                  color: Color(0xff0873C4),),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: height / 92.125,
                                                        ),

                                                        Container(
                                                          height:110,
                                                          width:330,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(color:Color(0xff999999),width: 1.5)
                                                          ),
                                                          child:Column(
                                                            children: [
                                                              SizedBox(height:5),

                                                              ///image and School holiday details text
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [

                                                                  SizedBox(
                                                                      height:28,
                                                                      width:28,
                                                                    child: Image.asset("assets/Alert Iocn.png"),
                                                                  ),

                                                                  SizedBox(
                                                                    width:280,
                                                                    height:30,
                                                                    child: Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          "School will be holiday tomorrow",
                                                                          style: GoogleFonts
                                                                              .poppins(
                                                                              color: Colors
                                                                                  .black,
                                                                              fontSize: 16,
                                                                              textStyle: TextStyle(
                                                                                overflow: TextOverflow.ellipsis
                                                                              ),
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .w600),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),

                                                              SizedBox(height:5),
                                                              ///deccription
                                                              Padding(
                                                                padding:  EdgeInsets.only(left:2),
                                                                child: SizedBox(
                                                                  width:310,
                                                                  child: Text(
                                                                    "Due to heavy rain the school will be leave tomorrow",
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize: 12,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height:5),

                                                              ///date and principle text
                                                              Padding(
                                                                padding:  EdgeInsets.only(left:10),
                                                                child: Row(
                                                                  children: [

                                                                    SizedBox(

                                                                      width:210,
                                                                      child: Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "14-06-2022 | 12.30 AM",
                                                                            style: GoogleFonts
                                                                                .poppins(
                                                                                color: Color(0xffA294A1),
                                                                                fontSize: 13,

                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w600),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:100,

                                                                      child: Center(
                                                                        child: Text(                                                                          "Principal",
                                                                          style: GoogleFonts
                                                                              .quando(
                                                                              color: Color(0xff609F00),
                                                                              fontSize: 13,),
                                                                        ),
                                                                      ),
                                                                    )

                                                                  ],
                                                                ),
                                                              ),


                                                            ],
                                                          )
                                                        ),



                                                        SizedBox(
                                                            height: height / 5.0),


                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container()),
                  ),

                  /*Padding(
                    padding: EdgeInsets.only(
                        left: width / 13.33,
                        bottom: height / 1.26,
                        right: width / 13.333),
                    child: Container(
                      height: height / 14.28,
                      width: width / 1.1,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black38,
                                spreadRadius: 0,
                                blurRadius: 10),
                          ],
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: height / 94.5, bottom: height / 189),
                        child: TextField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: height / 50.4),
                              enabledBorder:
                                  OutlineInputBorder(borderSide: BorderSide.none),
                              focusedBorder:
                                  OutlineInputBorder(borderSide: BorderSide.none),
                              prefixIcon: Icon(Icons.search_rounded),
                              hintText: "Search",
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey.shade900,
                                  fontSize: width / 22.5)),
                          onSubmitted: (_) {
                            if (Searchcontroller.text == "Attendance") {
                              setState(() {
                                page = "Attendance";
                              });
                            }
                            if (Searchcontroller.text == "Attendance") {
                              setState(() {
                                page = "Attendance";
                              });
                            }
                            if (Searchcontroller.text == "Home Works") {
                              setState(() {
                                page = "Home Works";
                              });
                            }
                            if (Searchcontroller.text == "Behaviour") {
                              setState(() {
                                page = "Behaviour";
                              });
                            }
                            if (Searchcontroller.text == "Circulars") {
                              setState(() {
                                page = "Circulars";
                              });
                            }
                            if (Searchcontroller.text == "Time Table") {
                              setState(() {
                                page = "Time Table";
                              });
                            }
                            if (Searchcontroller.text == "Messages") {
                              setState(() {
                                page = "Messages";
                              });
                            }
                            if (Searchcontroller.text.contains('Home')) {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) =>Root_Page() ,));
                            }
                            if (Searchcontroller.text.contains('Message')) {}
                            if (Searchcontroller.text.contains('Exams')) {}
                            if (Searchcontroller.text.contains('Profile')) {}
                          },
                          controller: Searchcontroller,
                        ),
                      ),
                    ),
                  ), */// textfield
                ],
              ),
              // white

            ],
          ),
        ),
      ):
      selecteIndexvalue==1?
      SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.ease,
              height: page == "Home"
                  ? height / 2.256
                  : page == "Attendance"
                  ? height / 4.56
                  : page == "Home Works"
                  ? height / 4.56
                  : page == "Behaviour"
                  ? 76.123
                  : page == "Circulars"
                  ? 166.0
                  : page == "Time Table"
                  ? 166.0
                  : page == "Messages"
                  ? 76.123
                  : 0,
              child:
              page == "Behaviour" ||
                  page == "Messages"
                  ? Container()
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: height / 15.12, left: width / 36),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(Studentimg),
                        ),
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: width / 36,
                                top: height / 15.12),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width / 1.736,
                                  height: height / 18.9,
                                  child: Text(
                                    "Hello ${Studentname}!",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                        textStyle: TextStyle(
                                            overflow: TextOverflow
                                                .ellipsis)),
                                  ),
                                ),
                                SizedBox(width: width / 72),

                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        key.currentState!
                                            .openEndDrawer();
                                      },
                                      child: Container(
                                          height: height / 20.47,
                                          width: width / 10.333,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                  Colors.white,
                                                  width: 2),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(5)),
                                          child: Icon(
                                              Icons.menu_sharp,
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),

                                /// two image containers
                              ],
                            ),
                          ), // headline
                          Padding(
                            padding:
                            EdgeInsets.only(left: width / 36),
                            child: Text(
                              "ID : ${Studentregno}",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ), //
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 38.566,
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 1.5,
                    endIndent: 10,
                    indent: 10,
                  ),
                  page == "Attendance" || page == "Home Works"||page == "Time Table"||page == "Circulars"
                      ? Container()
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      Padding(
                        padding: EdgeInsets.only(
                            left: width / 36,
                            right: width / 36,
                            top: height / 50.4),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "This week",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                SizedBox(width: width * 2 / 368.5),
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ],
                            ),

                            /// select Date

                            Row(
                              children: [
                                Container(
                                    height: height / 24.566,
                                    width: width / 12,
                                    child: Icon(
                                        Icons.calendar_month_outlined,
                                        color: Color(0xffffffff))),
                                SizedBox(width: width / 150),
                                Text(
                                  "${cmonth.toString()} ${cyear.toString()}",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19),
                                ),
                              ],
                            ),

                            /// current year
                          ],
                        ),
                      ),

                      SizedBox(height: height / 50.944),

                      /// Select Date
                      IgnorePointer(
                        child: CalendarTimeline(
                          dayNameColor: Colors.white,
                          initialDate: DateTime(year, month2, dates),
                          firstDate: DateTime(1990, 1, 15),
                          lastDate: DateTime(2050, 11, 20),
                          onDateSelected: (date) {
                            setState(() {
                              dates = date.day;
                              month2 = date.month;
                              year = date.year;
                              formattedDate =
                                  DateFormat('ddMyyyy').format(date);
                              selectdate =
                                  DateFormat('dd/M/yyyy').format(date);
                            });
                            print(formattedDate);
                          },
                          leftMargin: 20,
                          monthColor: Colors.white,
                          dayColor: Colors.white,
                          activeDayColor: Color(0xff0873C4),
                          activeBackgroundDayColor: Colors.white,
                          dotsColor: Colors.white,
                          locale: 'en_ISO',
                        ),
                      ),

                      SizedBox(height: height / 120.33),

                      Container(
                        height: 1,
                        width: width / 0.947,
                        color: Colors.white,
                      )

                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: height / 52.125),

            Stack(
              children: [
                Container(
                  height: height / 24.566,
                  width: double.infinity,
                ),

                Padding(
                  padding: EdgeInsets.only(top: height / 25.2),
                  child: Container(
                      height: page == "Home" ? height / 1.474 : height / 1.1338,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(35),
                              topLeft: Radius.circular(35))),
                      child: page == "Home"
                          ? Padding(
                        padding: EdgeInsets.only(top: height / 20.12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: width / 45),
                              child: Text(
                                "Dashboard,",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ///Days present circular
                                Column(
                                  children: [
                                    CircularPercentIndicator(
                                        radius: 43,
                                        lineWidth: 10.0,
                                        percent: 1,
                                        center: Text(
                                            presentvalue.toString(),
                                            style: GoogleFonts.montserrat(
                                                fontSize: width / 13,
                                                fontWeight:
                                                FontWeight.bold,
                                                color: Colors.yellow)),
                                        linearGradient:
                                        const LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: <Color>[
                                              Colors.yellowAccent,
                                              Colors.yellow
                                            ]),
                                        rotateLinearGradient: true,
                                        circularStrokeCap:
                                        CircularStrokeCap.round),
                                    SizedBox(height: 5),
                                    Text("Days, Present",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                        )),
                                  ],
                                ),
                                SizedBox(width: 80),

                                ///Days Absent circular
                                Column(
                                  children: [
                                    CircularPercentIndicator(
                                        radius: 43,
                                        lineWidth: 10.0,
                                        percent: 1,
                                        center: Text(
                                            Absentvalue.toString(),
                                            style: GoogleFonts.montserrat(
                                                fontSize: width / 13,
                                                fontWeight:
                                                FontWeight.bold,
                                                color: Colors.red)),
                                        linearGradient:
                                        const LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: <Color>[
                                              Colors.red,
                                              Colors.redAccent,
                                            ]),
                                        rotateLinearGradient: true,
                                        circularStrokeCap:
                                        CircularStrokeCap.round),
                                    SizedBox(height: 5),
                                    Text("Days, Absent",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(top: height / 37.8),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  /// Attendance
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        page = "Attendance";
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          color: Color(0xff609F00),
                                          size: width / 12,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width / 45,
                                              right: width / 45,
                                              top: height / 94.5,
                                              bottom: height / 94.5),
                                          child: Text(
                                            "Attendance",
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///  home works
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        page = "Home Works";
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Icon(Icons.note_alt_sharp,
                                            color: Color(0xffFECE3E),
                                            size: width / 12),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width / 45,
                                              right: width / 45,
                                              top: height / 94.5,
                                              bottom: height / 94.5),
                                          child: Text(
                                            "Home Works",
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///  Time Table
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        page = "Time Table";
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Icon(Icons.timer_outlined,
                                            color: Color(0xff224FFF),
                                            size: width / 12),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width / 45,
                                              right: width / 45,
                                              top: height / 94.5,
                                              bottom: height / 94.5),
                                          child: Text(
                                            "Time Table",
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                          : page == "Home Works"
                          ? Padding(
                        padding: EdgeInsets.only(
                            left: width / 36,
                            right: width / 36,
                            top: height / 15.12),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "HomeWork's",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width:300,
                                    child: Row(
                                      children: [
                                        Text(
                                          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                                          style:
                                          GoogleFonts.poppins(
                                              color: Colors.grey
                                                  .shade700,
                                              fontSize: 15,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                        SizedBox(
                                          width: width / 100,
                                        ),
                                        Container(
                                          height: height / 49.13,
                                          width: width / 170,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: width / 100,
                                        ),
                                        Text(
                                          day,
                                          style:
                                          GoogleFonts.poppins(
                                              color: Colors.grey
                                                  .shade700,
                                              fontSize: 15,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                      ],
                                    ),
                                  ),

                                  InkWell(
                                    onTap:(){
                                      setState(() {
                                        page = "Home";
                                      });
                                    },
                                    child: Padding(                                                          padding:  EdgeInsets.only(right:8.0),
                                      child: Icon(Icons.arrow_circle_down_sharp,
                                        size: 30,
                                        color: Color(0xff0873C4),),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: height / 36.85),

                              ///selection chips
                              SingleChildScrollView(
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: 440,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      ///Today's Button
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            Hmselected = 1;
                                          });
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Hmselected == 1
                                                  ? Color(0xff0873C4)
                                                  : Color(0xffF0EFEF),
                                              border: Border.all(
                                                color: Hmselected == 1
                                                    ? Colors
                                                    .transparent
                                                    : Color(
                                                    0xff0873C4),
                                              ),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Today's",
                                                style: GoogleFonts.poppins(
                                                    color: Hmselected ==
                                                        1
                                                        ? Colors.white
                                                        : Color(
                                                        0xff0873C4),
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                    fontSize: 16),
                                              ),
                                            )),
                                      ),

                                      ///Yesterday
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            Hmselected = 2;
                                          });
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Hmselected == 2
                                                  ? Color(0xff0873C4)
                                                  : Color(0xffF0EFEF),
                                              border: Border.all(
                                                color: Hmselected == 2
                                                    ? Colors
                                                    .transparent
                                                    : Color(
                                                    0xff0873C4),
                                              ),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Yesterday",
                                                style: GoogleFonts.poppins(
                                                    color: Hmselected ==
                                                        2
                                                        ? Colors.white
                                                        : Color(
                                                        0xff0873C4),
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                    fontSize: 16),
                                              ),
                                            )),
                                      ),

                                      ///month
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            Hmselected = 3;
                                          });
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Hmselected == 3
                                                  ? Color(0xff0873C4)
                                                  : Color(0xffF0EFEF),
                                              border: Border.all(
                                                color: Hmselected == 3
                                                    ? Colors
                                                    .transparent
                                                    : Color(
                                                    0xff0873C4),
                                              ),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Month",
                                                style: GoogleFonts.poppins(
                                                    color: Hmselected ==
                                                        3
                                                        ? Colors.white
                                                        : Color(
                                                        0xff0873C4),
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                    fontSize: 16),
                                              ),
                                            )),
                                      ),

                                      ///custom
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            Hmselected = 4;
                                          });
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Hmselected == 4
                                                  ? Color(0xff0873C4)
                                                  : Color(0xffF0EFEF),
                                              border: Border.all(
                                                color: Hmselected == 4
                                                    ? Colors
                                                    .transparent
                                                    : Color(
                                                    0xff0873C4),
                                              ),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Custom",
                                                style: GoogleFonts.poppins(
                                                    color: Hmselected ==
                                                        4
                                                        ? Colors.white
                                                        : Color(
                                                        0xff0873C4),
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                    fontSize: 16),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: height / 36.85),

                              ///Listout the HomeWork
                              Container(
                                height: 100,
                                width: 340,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Color(0xff999999))),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),

                                    ///subject Title
                                    Padding(
                                      padding:
                                      EdgeInsets.only(left: 15.0),
                                      child: SizedBox(
                                        width: 250,
                                        child: Text(
                                          "Tamil",
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
                                        width: 305,
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              "Completed all the test by tomorrow without fail ",
                                              textAlign:
                                              TextAlign.left,
                                              style:
                                              GoogleFonts.poppins(
                                                  color: Colors
                                                      .black,
                                                  fontSize: 12),
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
                                        "14-06-2022 | 12.30 AM",
                                        style: GoogleFonts.poppins(
                                            color: Color(0xffA294A1),
                                            fontWeight:
                                            FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(height: height / 5.0),
                            ],
                          ),
                        ),
                      )
                          : page == "Attendance"
                          ? Padding(
                        padding:
                        EdgeInsets.only(top: height / 25.2),
                        child: Container(
                          height: height / 32.48,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(35),
                                  topLeft: Radius.circular(35))),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: width / 36,
                                right: width / 36,
                                top: height / 192),
                            child: SingleChildScrollView(
                              physics: ScrollPhysics(),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Attendance",
                                    style: GoogleFonts.poppins(
                                        color:
                                        Colors.blueAccent,
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight.w600),
                                  ),

                                  Row(
                                    children: [
                                      SizedBox(
                                        width:300,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                                              style:
                                              GoogleFonts.poppins(
                                                  color: Colors.grey
                                                      .shade700,
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ),
                                            SizedBox(
                                              width: width / 100,
                                            ),
                                            Container(
                                              height: height / 49.13,
                                              width: width / 170,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: width / 100,
                                            ),
                                            Text(
                                              day,
                                              style:
                                              GoogleFonts.poppins(
                                                  color: Colors.grey
                                                      .shade700,
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ),
                                          ],
                                        ),
                                      ),

                                      InkWell(
                                        onTap:(){
                                          setState(() {
                                            page = "Home";
                                          });
                                        },
                                        child: Padding(                                                          padding:  EdgeInsets.only(right:8.0),
                                          child: Icon(Icons.arrow_circle_down_sharp,
                                            size: 30,
                                            color: Color(0xff0873C4),),
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// date/day

                                  SizedBox(
                                    height: height / 49.13,
                                  ),

                                  Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 1.5,
                                  ),

                                  ///calender in Widget
                                  /* Container(
                                                      color:Colors.red,
                                                      child: StudentAttendance_Page(Studentid),),*/

                                  Container(
                                      height: 50,
                                      width: 340,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius
                                              .circular(20),
                                          color:
                                          Color(0xffFFFFFF),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors
                                                    .black12,
                                                blurRadius: 1,
                                                spreadRadius: 1,
                                                offset:
                                                Offset(1, 1)),
                                            BoxShadow(
                                                color: Colors
                                                    .black12,
                                                blurRadius: 1,
                                                spreadRadius: 1,
                                                offset: Offset(
                                                    -1, -1))
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .center,
                                        children: [
                                          Text(
                                              "Performance is going good. But still \nneed improvement...",
                                              style: GoogleFonts
                                                  .poppins(
                                                  fontWeight:
                                                  FontWeight
                                                      .w700)),
                                        ],
                                      )),

                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 15,
                                        left: 3,
                                        right: 8,
                                        bottom: 8),
                                    child: Text("Absent Days",
                                        style:
                                        GoogleFonts.poppins(
                                            fontWeight:
                                            FontWeight
                                                .w700,
                                            fontSize: 18)),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 8.0),
                                    child: Container(
                                      height: 40,
                                      width: 320,
                                      decoration: BoxDecoration(
                                          color:
                                          Color(0xffFF0303),
                                          borderRadius:
                                          BorderRadius
                                              .circular(10)),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 15),
                                          ClipOval(
                                            child: Container(
                                                height: 15,
                                                width: 15,
                                                color:
                                                Colors.white),
                                          ),
                                          SizedBox(
                                              width: 280,
                                              child: Center(
                                                child: Text(
                                                  "12th July 2023 - Wednesday",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors
                                                          .white,
                                                      fontSize:
                                                      18,
                                                      fontWeight:
                                                      FontWeight
                                                          .w700),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: height / 2.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                          : page == "Time Table"
                          ? Padding(
                        padding: EdgeInsets.only(
                            top: height / 25.2),
                        child: Container(
                          height: height / 1.474,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight:
                                  Radius.circular(35),
                                  topLeft:
                                  Radius.circular(35))),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: width / 36,
                                right: width / 36,
                                top: width / 75.6),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              // physics: NeverScrollableScrollPhysics(),
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      page = "Home";
                                    });
                                  },
                                  child: Text(
                                    "Time Table",
                                    style:
                                    GoogleFonts.poppins(
                                        color:
                                        Colors.black,
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight
                                            .w600),
                                  ),
                                ),

                                Row(
                                  children: [
                                    SizedBox(
                                      width:300,
                                      child: Row(
                                        children: [
                                          Text(
                                            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                                            style:
                                            GoogleFonts.poppins(
                                                color: Colors.grey
                                                    .shade700,
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight
                                                    .w500),
                                          ),
                                          SizedBox(
                                            width: width / 100,
                                          ),
                                          Container(
                                            height: height / 49.13,
                                            width: width / 170,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            width: width / 100,
                                          ),
                                          Text(
                                            day,
                                            style:
                                            GoogleFonts.poppins(
                                                color: Colors.grey
                                                    .shade700,
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight
                                                    .w500),
                                          ),
                                        ],
                                      ),
                                    ),

                                    InkWell(
                                      onTap:(){
                                        setState(() {
                                          page = "Home";
                                        });
                                      },
                                      child: Padding(                                                          padding:  EdgeInsets.only(right:8.0),
                                        child: Icon(Icons.arrow_circle_down_sharp,
                                          size: 30,
                                          color: Color(0xff0873C4),),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height / 92.125,
                                ),

                                ///selection chips
                                SingleChildScrollView(
                                  physics: ScrollPhysics(),
                                  scrollDirection:
                                  Axis.horizontal,
                                  child: SizedBox(
                                    width: 840,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceAround,
                                      children: [
                                        ///Today's Button
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              TTselected = 1;
                                            });
                                          },
                                          child: Container(
                                              height: 40,
                                              width: 105,
                                              decoration:
                                              BoxDecoration(
                                                color: TTselected ==
                                                    1
                                                    ? Color(
                                                    0xff0873C4)
                                                    : Color(
                                                    0xffF0EFEF),
                                                border: Border
                                                    .all(
                                                  color: TTselected ==
                                                      1
                                                      ? Colors
                                                      .transparent
                                                      : Color(
                                                      0xff0873C4),
                                                ),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Today's",
                                                  style: GoogleFonts.poppins(
                                                      color: TTselected ==
                                                          1
                                                          ? Colors
                                                          .white
                                                          : Color(
                                                          0xff0873C4),
                                                      fontWeight:
                                                      FontWeight
                                                          .w700,
                                                      fontSize:
                                                      16),
                                                ),
                                              )),
                                        ),

                                        ///MOnday
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              TTselected = 2;
                                            });
                                          },
                                          child: Container(
                                              height: 40,
                                              width: 105,
                                              decoration:
                                              BoxDecoration(
                                                color: TTselected ==
                                                    2
                                                    ? Color(
                                                    0xff0873C4)
                                                    : Color(
                                                    0xffF0EFEF),
                                                border: Border
                                                    .all(
                                                  color: TTselected ==
                                                      2
                                                      ? Colors
                                                      .transparent
                                                      : Color(
                                                      0xff0873C4),
                                                ),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Monday",
                                                  style: GoogleFonts.poppins(
                                                      color: TTselected ==
                                                          2
                                                          ? Colors
                                                          .white
                                                          : Color(
                                                          0xff0873C4),
                                                      fontWeight:
                                                      FontWeight
                                                          .w700,
                                                      fontSize:
                                                      16),
                                                ),
                                              )),
                                        ),

                                        ///Tuesday
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              TTselected = 3;
                                            });
                                          },
                                          child: Container(
                                              height: 40,
                                              width: 105,
                                              decoration:
                                              BoxDecoration(
                                                color: TTselected ==
                                                    3
                                                    ? Color(
                                                    0xff0873C4)
                                                    : Color(
                                                    0xffF0EFEF),
                                                border: Border
                                                    .all(
                                                  color: TTselected ==
                                                      3
                                                      ? Colors
                                                      .transparent
                                                      : Color(
                                                      0xff0873C4),
                                                ),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Tuesday",
                                                  style: GoogleFonts.poppins(
                                                      color: TTselected ==
                                                          3
                                                          ? Colors
                                                          .white
                                                          : Color(
                                                          0xff0873C4),
                                                      fontWeight:
                                                      FontWeight
                                                          .w700,
                                                      fontSize:
                                                      16),
                                                ),
                                              )),
                                        ),

                                        ///Wednesday
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              TTselected = 4;
                                            });
                                          },
                                          child: Container(
                                              height: 40,
                                              width: 105,
                                              decoration:
                                              BoxDecoration(
                                                color: TTselected ==
                                                    4
                                                    ? Color(
                                                    0xff0873C4)
                                                    : Color(
                                                    0xffF0EFEF),
                                                border: Border
                                                    .all(
                                                  color: TTselected ==
                                                      4
                                                      ? Colors
                                                      .transparent
                                                      : Color(
                                                      0xff0873C4),
                                                ),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Wednesday",
                                                  style: GoogleFonts.poppins(
                                                      color: TTselected ==
                                                          4
                                                          ? Colors
                                                          .white
                                                          : Color(
                                                          0xff0873C4),
                                                      fontWeight:
                                                      FontWeight
                                                          .w700,
                                                      fontSize:
                                                      16),
                                                ),
                                              )),
                                        ),

                                        ///Thursday
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              TTselected = 4;
                                            });
                                          },
                                          child: Container(
                                              height: 40,
                                              width: 105,
                                              decoration:
                                              BoxDecoration(
                                                color: TTselected ==
                                                    4
                                                    ? Color(
                                                    0xff0873C4)
                                                    : Color(
                                                    0xffF0EFEF),
                                                border: Border
                                                    .all(
                                                  color: TTselected ==
                                                      4
                                                      ? Colors
                                                      .transparent
                                                      : Color(
                                                      0xff0873C4),
                                                ),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Thursday",
                                                  style: GoogleFonts.poppins(
                                                      color: TTselected ==
                                                          4
                                                          ? Colors
                                                          .white
                                                          : Color(
                                                          0xff0873C4),
                                                      fontWeight:
                                                      FontWeight
                                                          .w700,
                                                      fontSize:
                                                      16),
                                                ),
                                              )),
                                        ),

                                        ///Friday
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              TTselected = 5;
                                            });
                                          },
                                          child: Container(
                                              height: 40,
                                              width: 105,
                                              decoration:
                                              BoxDecoration(
                                                color: TTselected ==
                                                    5
                                                    ? Color(
                                                    0xff0873C4)
                                                    : Color(
                                                    0xffF0EFEF),
                                                border: Border
                                                    .all(
                                                  color: TTselected ==
                                                      5
                                                      ? Colors
                                                      .transparent
                                                      : Color(
                                                      0xff0873C4),
                                                ),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Friday",
                                                  style: GoogleFonts.poppins(
                                                      color: TTselected ==
                                                          5
                                                          ? Colors
                                                          .white
                                                          : Color(
                                                          0xff0873C4),
                                                      fontWeight:
                                                      FontWeight
                                                          .w700,
                                                      fontSize:
                                                      16),
                                                ),
                                              )),
                                        ),

                                        ///Saturday
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              TTselected = 6;
                                            });
                                          },
                                          child: Container(
                                              height: 40,
                                              width: 105,
                                              decoration:
                                              BoxDecoration(
                                                color: TTselected ==
                                                    6
                                                    ? Color(
                                                    0xff0873C4)
                                                    : Color(
                                                    0xffF0EFEF),
                                                border: Border
                                                    .all(
                                                  color: TTselected ==
                                                      6
                                                      ? Colors
                                                      .transparent
                                                      : Color(
                                                      0xff0873C4),
                                                ),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Saturday",
                                                  style: GoogleFonts.poppins(
                                                      color: TTselected ==
                                                          6
                                                          ? Colors
                                                          .white
                                                          : Color(
                                                          0xff0873C4),
                                                      fontWeight:
                                                      FontWeight
                                                          .w700,
                                                      fontSize:
                                                      16),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: height / 20.125,
                                ),

                                ///subject hour and section details text and container
                                Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      Stack(children: [
                                        Container(
                                          height:
                                          height / 18.425,
                                          width: width / 1.1,
                                          decoration: BoxDecoration(
                                              color: Color(
                                                  0xffECECEC),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  18)),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: width /
                                                        4.0),
                                                child: Text(
                                                  "7th Grade C Section",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors
                                                          .blueAccent,
                                                      fontSize:
                                                      20,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          EdgeInsets.only(
                                              left: 1.3,
                                              top: 1.5),
                                          child: Container(
                                            height:
                                            height / 20.0,
                                            width:
                                            width / 4.285,
                                            decoration: BoxDecoration(
                                                color: Colors
                                                    .white,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    18)),
                                            child: Center(
                                              child: Text(
                                                "1 HR",
                                                style: GoogleFonts.poppins(
                                                    color: Colors
                                                        .blueAccent,
                                                    fontSize:
                                                    20,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                    height: height / 5.0),

                                /*Flexible(
                                                              child: ListView(
                                                                shrinkWrap: true,
                                                                physics: NeverScrollableScrollPhysics(),
                                                                children: [
                                                                  // SizedBox(
                                                                  //     height: height /
                                                                  //         49.133),






                                                                  SizedBox(height: height/5.04,)
                                                                ],
                                                              ),
                                                            ),*/
                              ],
                            ),
                          ),
                        ),
                      )
                          : page == "Circulars"
                          ? Padding(
                        padding: EdgeInsets.only(
                            top: height / 25.2),
                        child: Container(
                          height: height / 1.474,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.only(
                                  topRight: Radius
                                      .circular(35),
                                  topLeft:
                                  Radius.circular(
                                      35))),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: width / 36,
                                right: width / 36,
                                top: width / 75.6),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              // physics: NeverScrollableScrollPhysics(),
                              children: [
                                Text(
                                  "Circulars",
                                  style: GoogleFonts
                                      .poppins(
                                      color: Colors
                                          .black,
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight
                                          .w600),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width:300,
                                      child: Row(
                                        children: [
                                          Text(
                                            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                                            style:
                                            GoogleFonts.poppins(
                                                color: Colors.grey
                                                    .shade700,
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight
                                                    .w500),
                                          ),
                                          SizedBox(
                                            width: width / 100,
                                          ),
                                          Container(
                                            height: height / 49.13,
                                            width: width / 170,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            width: width / 100,
                                          ),
                                          Text(
                                            day,
                                            style:
                                            GoogleFonts.poppins(
                                                color: Colors.grey
                                                    .shade700,
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight
                                                    .w500),
                                          ),
                                        ],
                                      ),
                                    ),


                                  ],
                                ),
                                SizedBox(
                                  height: height / 92.125,
                                ),


                                StreamBuilder(

                                    stream:_firestore2db.collection("Circulars").snapshots(),
                                    builder: (context, snap){
                                      if(snap.hasData==null){
                                        return Center(child: CircularProgressIndicator(),);
                                      }
                                      if(!snap.hasData){
                                        return Center(child: CircularProgressIndicator(),);
                                      }

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:snap.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          var circular=snap.data!.docs[index];
                                          return  Padding(
                                            padding: const EdgeInsets.only(bottom: 16.0),
                                            child: Container(

                                                width:330,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(color:Color(0xff999999),width: 1.5)
                                                ),
                                                child:Column(
                                                  children: [
                                                    SizedBox(height:5),

                                                    ///image and School holiday details text
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [

                                                        SizedBox(
                                                          height:28,
                                                          width:28,
                                                          child: Image.asset("assets/Alert Iocn.png"),
                                                        ),

                                                        SizedBox(
                                                          width:280,
                                                          height:30,
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                circular['reason'],
                                                                style: GoogleFonts
                                                                    .poppins(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16,
                                                                    textStyle: TextStyle(
                                                                        overflow: TextOverflow.ellipsis
                                                                    ),
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                      ],
                                                    ),

                                                    SizedBox(height:5),
                                                    ///deccription
                                                    Padding(
                                                      padding:  EdgeInsets.only(left:2),
                                                      child: SizedBox(
                                                        width:310,
                                                        child: Text(
                                                          circular['Descr'],
                                                          style: GoogleFonts
                                                              .poppins(
                                                              color: Colors
                                                                  .black,
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height:5),

                                                    ///date and principle text
                                                    Padding(
                                                      padding:  EdgeInsets.only(left:10),
                                                      child: Row(
                                                        children: [

                                                          SizedBox(

                                                            width:210,
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "${circular['Date']} | ${circular['Date']}",
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                      color: Color(0xffA294A1),
                                                                      fontSize: 13,

                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:100,
                                                            child: Center(
                                                              child: Text(circular['From'],
                                                                style: GoogleFonts
                                                                    .quando(
                                                                  color: Color(0xff609F00),
                                                                  fontSize: 13,),
                                                              ),
                                                            ),
                                                          )

                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height:5),

                                                  ],
                                                )
                                            ),
                                          );

                                      },);
                                    },),


                                SizedBox(
                                    height: height / 5.0),


                              ],
                            ),
                          ),
                        ),
                      )
                          : Container()),
                ),

                Padding(
                  padding: EdgeInsets.only(
                      left: width / 13.33,
                      bottom: height / 1.26,
                      right: width / 13.333),
                  child: Container(
                    height: height / 14.28,
                    width: width / 1.1,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              spreadRadius: 0,
                              blurRadius: 10),
                        ],
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: height / 94.5, bottom: height / 189),
                      child: TextField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: height / 50.4),
                            enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                            prefixIcon: Icon(Icons.search_rounded),
                            hintText: "Search",
                            hintStyle: GoogleFonts.poppins(
                                color: Colors.grey.shade900,
                                fontSize: width / 22.5)),
                        onSubmitted: (_) {
                          if (Searchcontroller.text == "Attendance") {
                            setState(() {
                              page = "Attendance";
                            });
                          }
                          if (Searchcontroller.text == "Attendance") {
                            setState(() {
                              page = "Attendance";
                            });
                          }
                          if (Searchcontroller.text == "Home Works") {
                            setState(() {
                              page = "Home Works";
                            });
                          }
                          if (Searchcontroller.text == "Behaviour") {
                            setState(() {
                              page = "Behaviour";
                            });
                          }
                          if (Searchcontroller.text == "Circulars") {
                            setState(() {
                              page = "Circulars";
                            });
                          }
                          if (Searchcontroller.text == "Time Table") {
                            setState(() {
                              page = "Time Table";
                            });
                          }
                          if (Searchcontroller.text == "Messages") {
                            setState(() {
                              page = "Messages";
                            });
                          }
                          if (Searchcontroller.text.contains('Home')) {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) =>Root_Page() ,));
                          }
                          if (Searchcontroller.text.contains('Message')) {}
                          if (Searchcontroller.text.contains('Exams')) {}
                          if (Searchcontroller.text.contains('Profile')) {}
                        },
                        controller: Searchcontroller,
                      ),
                    ),
                  ),
                ), // textfield
              ],
            ), // white
          ],
        ),
      ):
      selecteIndexvalue==2?
      StudentExam():
      Student_Profile(Studentid),
      bottomNavigationBar: CreateBottombar(),
    );
  }

  Container CreateBottombar() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          child: Container(
            height: height / 10.8,
            child: GNav(
                backgroundColor: Color(0xff0873C4),
                haptic: true,
                tabBorderRadius: 18,
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 600),
                gap: 8,
                color: Colors.white,
                activeColor: Colors.blue,
                iconSize: 26,
                tabBackgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: width / 36, vertical: height / 151.2),
                tabs: [
                  GButton(
                    onPressed: (){
                      setState((){
                        page = "Home";
                        selecteIndexvalue=0;
                      });
                    },
                    margin: EdgeInsets.only(left: width / 36),
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    onPressed: (){
                      setState(() {
                        page = "Circulars";
                      });
                    },
                    icon: Icons.message,
                    text: 'Circulars',
                  ),
                  GButton(
                    icon: Icons.assignment,
                    text: 'Exams',
                  ),
                  GButton(
                    margin: EdgeInsets.only(right: width / 36),
                    icon: Icons.person_outline,
                    text: 'Profile',
                  )
                ],
                selectedIndex: selecteIndexvalue,
                onTabChange: onTabTapped),
          )),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      selecteIndexvalue = index;
    });
  }
}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);