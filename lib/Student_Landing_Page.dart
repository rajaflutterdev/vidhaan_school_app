import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'Notifications.dart';
import 'Profileview.dart';
import 'Root_page.dart';
import 'StudentAttendance_Page.dart';
import 'StudentExam_Page.dart';
import 'Student_Profile.dart';
import 'StudentsExam.dart';
import 'account_page.dart';
import 'assignmentsdetailsst.dart';
import 'package:pdf/widgets.dart' as p;
import 'package:printing/printing.dart';

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
  String Studentclass = '';
  String Studentsec = '';

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
          Studentclass = stuvalue['admitclass'];
          Studentsec = stuvalue['section'];
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
  String formattedDate = '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}';
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
    gettimetable();
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
  demo() {
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/0.87111111,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Are you sure want to exit',


      btnCancelOnPress: (){},
      btnOkOnPress: () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
    )..show();
  }
  demo2() {
    return AwesomeDialog(
      width: 450,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Are you sure want to exit',


      btnCancelOnPress: (){

      },
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
    );

  }
  Widget messageTile(Size size, Map<String, dynamic> chatMap,
      BuildContext context, id) {
    showToast() {
    }
    double width = MediaQuery.of(context).size.width;
    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
                width: size.width,
                alignment:  chatMap['sender']==Studentname?Alignment.centerRight: Alignment.centerLeft,
                child:
                GestureDetector(
                  onLongPress: () {
                    if(chatMap['sender']==Studentname) {
                      showDialog(context: context, builder: (ctx) =>
                          AlertDialog(
                            title: Text('Are you sure delete this message'),
                            actions: [
                              TextButton(onPressed: () {
                                _firestore2db.collection(
                                    '${Studentclass}${Studentsec}chat')
                                    .doc(id)
                                    .delete();
                                Navigator.pop(context);
                              }, child: Text('Delete'))
                            ],
                          ));
                    }
                    print('ir');
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 8, horizontal: 14),
                      margin: EdgeInsets.symmetric(
                          vertical: 5, horizontal: 0),
                      decoration: BoxDecoration(
                      color:  chatMap['sender']==Studentname? Colors.white: Color(0xff0271C5),
                        border: Border.all(color: chatMap['sender']==Studentname? Color(0xff010029)
                            .withOpacity(0.65) : Color(0xff0271C5)),
                        borderRadius: BorderRadius.only(topLeft: Radius
                            .circular(15),
                          bottomLeft: chatMap['sender']==Studentname? Radius.circular(15) : Radius.circular(0),
                          bottomRight: chatMap['sender']==Studentname? Radius.circular(0) : Radius.circular(15),
                             topRight: Radius.circular(15),),
                      ),
                      child: Column(
                        children: [
                          Text(
                            chatMap['message'],
                            style: GoogleFonts.montserrat(
                              fontSize: width/30.15384615,
                              fontWeight: FontWeight.w500,
                              color: chatMap['sender']==Studentname? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      )),
                )
            ),
          );
      }
      else {
        return SizedBox();
      }
    });
  }
  TextEditingController _message= new TextEditingController();


  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
        "submittime":"${DateFormat('hh:mm a').format(DateTime.now())}",
        "sender":Studentname,
        "submitdate":"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
      };
      _message.clear();
      await _firestore2db
          .collection('${Studentclass}${Studentsec}chat')
          .add(chatData);
    }
  }

  void onSendMessag() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
        "submittime":"${DateFormat('hh:mm a').format(DateTime.now())}",
        "sender":Studentname,
        "submitdate":"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
      };

      _message.clear();
      await _firestore2db
          .collection('${Studentclass}${Studentsec}chat')
          .add(messages);
    }
    else {
      print("Enter Some Text");
    }
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                                    child: InkWell(
    onTap:(){
    Navigator.of(context).push(
    MaterialPageRoute(builder: (context)=>Profileview2(Studentimg))
    );},
                                      child: CircleAvatar(
                                        radius: 64,
                                        backgroundColor: Colors.grey.shade200,
                                        backgroundImage:  NetworkImage(
                                            Studentimg
                                        ),
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
                    title: Text("Assignments",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),
              
              InkWell(
                onTap:(){
                  setState((){
                    selecteIndexvalue = 1;
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
                  gettimetable();
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.timer_outlined,color: Colors.white,),
                    title: Text("Time Table",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),
              InkWell(
                onTap:(){
                  setState((){
                    page = "Fees";
                  });

                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.wallet_rounded,color: Colors.white,),
                    title: Text("Fees",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),
              InkWell(
                onTap:(){
                  setState((){
                    page = "School Bus";
                  });

                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.directions_bus_filled_rounded,color: Colors.white,),
                    title: Text("School Bus",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),
              InkWell(
                onTap:(){
                  setState((){
                    page = "Feedback";
                  });
                  gettimetable();
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.person_2_outlined,color: Colors.white,),
                    title: Text("Feedback",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),
              InkWell(
                onTap:(){
                  setState((){
                    page = "Request Documents";
                  });

                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.drive_file_move_rounded,color: Colors.white,),
                    title: Text("Request Documents",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),
              InkWell(
                onTap:(){
                  setState((){
                    page = "Library";
                  });
                  gettimetable();
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.menu_book,color: Colors.white,),
                    title: Text("Library",style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize:width/22.5)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _firebaseauth2db.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Accountpage(),));

                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(

                    leading: Icon(Icons.logout, color: Colors.white,),
                    title: Text("Logout", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 23.5)),
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
            demo();
          } else {
            setState(() {
              page = "Home";
            });
          }
          return demo2();
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
                                : page == "Feedback"
                                    ? 4.56
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
                                      child: InkWell(
                                        onTap:(){
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context)=>Profileview2(Studentimg))
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 40,

                                          backgroundImage: NetworkImage(Studentimg),
                                        ),
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
                                              InkWell(
                                          onTap:(){


      },
                                                child: SizedBox(
                                                  width: width / 1.99,
                                                  height: height / 18.9,
                                                  child: Text(
                                                    "Hello ${Studentname}!",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 24,
                                                        textStyle: TextStyle(
                                                            overflow: TextOverflow
                                                                .ellipsis)),
                                                  ),
                                                ),
                                              ),


                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context, MaterialPageRoute(
                                                        builder: (context) =>
                                                            Notifications(),));
                                                    },
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            right: width / 36),
                                                        height: height / 20.47,
                                                        width: width / 10.333,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                            BorderRadius.circular(6)),
                                                        child:
                                                        Icon(Icons.notifications_none,
                                                            color: Color(0xff2C79F1))),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      key.currentState!.openEndDrawer();
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
                                                fontSize: 15),
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
                          page == "Attendance" || page == "Home Works"||page == "Time Table"||page == "Feedback"
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
                              CalendarTimeline(
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

                              SizedBox(height: height / 120.33),

                              Container(
                                height: 1,
                                width: width / 0.947,
                                color: Colors.white,
                              ),


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
                                      padding: EdgeInsets.only(left: width / 45,top: height / 40.12),
                                      child: Text(
                                        "Dashboard",
                                        style: GoogleFonts.poppins(
                                            color: Color(0xff0873C4),
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    ExpandablePageView(
                                      children:[
                                        Container(
                                            child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(top: height / 37.8),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        /// Attendance
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              page = "Attendance";
                                                            });
                                                          },
                                                          child: Container(
                                                            width: width/3.56363636,
                                                            height: height/11.18571429,
                                                            child: Column(
                                                              children: [
                                                                Icon(
                                                                  Icons.calendar_month_outlined,
                                                                  color: Color(0xff609F00),
                                                                  size: width / 12,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(

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
                                                        ),

                                                        ///  home works
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              page = "Home Works";
                                                            });
                                                          },
                                                          child: Container(
                                                            width: width/3.56363636,
                                                            height: height/11.18571429,
                                                            child: Column(
                                                              children: [
                                                                Icon(Icons.note_alt_sharp,
                                                                    color: Color(0xffFECE3E),
                                                                    size: width / 12),
                                                                Padding(
                                                                  padding: EdgeInsets.only(

                                                                      top: height / 94.5,
                                                                      bottom: height / 94.5),
                                                                  child: Text(
                                                                    "Assignments",
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
                                                        ),

                                                        ///  Time Table
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              page = "Time Table";
                                                            });
                                                            gettimetable();
                                                          },
                                                          child: Container(
                                                            width: width/3.56363636,
                                                            height: height/11.18571429,
                                                            child: Column(
                                                              children: [
                                                                Icon(Icons.timer_outlined,
                                                                    color: Color(0xff224FFF),
                                                                    size: width / 12),
                                                                Padding(
                                                                  padding: EdgeInsets.only(

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
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(top: height / 25.8),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        /// Attendance
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              page = "Fees";
                                                            });
                                                          },
                                                          child: Container(
                                                            width: width/3.56363636,
                                                            height: height/11.18571429,
                                                            child: Column(
                                                              children: [
                                                                Icon(
                                                                  Icons.wallet_rounded,
                                                                  color: Color(0xffA021FF),
                                                                  size: width / 12,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(

                                                                      top: height / 94.5,
                                                                      bottom: height / 94.5),
                                                                  child: Text(
                                                                    "Fees",
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
                                                        ),

                                                        ///  home works
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              page = "School Bus";
                                                            });
                                                          },
                                                          child: Container(
                                                            width: width/3.56363636,
                                                            height: height/11.18571429,
                                                            child: Column(
                                                              children: [
                                                                Icon(Icons.directions_bus_filled_rounded,
                                                                    color: Color(0xff224FFF),
                                                                    size: width / 12),
                                                                Padding(
                                                                  padding: EdgeInsets.only(

                                                                      top: height / 94.5,
                                                                      bottom: height / 94.5),
                                                                  child: Text(
                                                                    "School Bus",
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
                                                        ),

                                                        ///  Time Table
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              page = "Feedback";
                                                            });
                                                          },
                                                          child: Container(
                                                            width: width/3.56363636,
                                                            height: height/11.18571429,
                                                            child: Column(
                                                              children: [
                                                                Icon(Icons.person_2_outlined,
                                                                    color: Color(0xff609F00),
                                                                    size: width / 12),
                                                                Padding(
                                                                  padding: EdgeInsets.only(

                                                                      top: height / 94.5,
                                                                      bottom: height / 94.5),
                                                                  child: Text(
                                                                    "Feedback",
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
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                            ),
                                        ),
                                        Container(
                                          height: height/2.61,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: height / 37.8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [

                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          page = "Request Documents";
                                                        });
                                                        print("Request Documents");
                                                      },
                                                      child: Container(
                                                        width: width/3.56363636,
                                                        height: height/11.18571429,

                                                        child: Column(
                                                          children: [
                                                            Icon(
                                                              Icons.drive_file_move_sharp,
                                                              color: Color(
                                                                  0xff609F00),
                                                              size: width / 12,),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  left: width / 45,
                                                                  right: width / 45,
                                                                  top: height / 94.5,
                                                                  bottom: height /
                                                                      94.5),
                                                              child: Text(
                                                                "Request Documents",
                                                                style: GoogleFonts
                                                                    .poppins(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: width/28,
                                                                    fontWeight:
                                                                    FontWeight.w500),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    /// Attendance

                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          //page = "Leave";
                                                        });
                                                        //print("Leave");
                                                      },
                                                      child: Container(
                                                        width: width/3.56363636,
                                                        height: height/11.18571429,
                                                        child: Column(
                                                          children: [

                                                            Icon(Icons.menu_book_sharp,
                                                                color: Color(
                                                                    0xffFECE3E),
                                                                size: width / 12),

                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  left: width / 45,
                                                                  right: width / 45,
                                                                  top: height / 94.5,
                                                                  bottom: height /
                                                                      94.5),
                                                              child: Text(
                                                                "Library",
                                                                style: GoogleFonts
                                                                    .poppins(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: width/28,
                                                                    fontWeight:
                                                                    FontWeight.w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    ///  home works

                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          page = "Progress";
                                                        });
                                                        print("Messages");
                                                      },
                                                      child: Container(
                                                        width: width/3.56363636,
                                                        height: height/11.18571429,
                                                          child: Column(
                                                    children: [
                                                      Icon(Icons.collections_bookmark,
                                                          color: Color(
                                                              0xffA021FF),
                                                          size: width / 12),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left: width / 45,
                                                            right: width / 45,
                                                            top: height / 94.5,
                                                            bottom: height /
                                                                94.5),
                                                        child: Text(
                                                          "Progress \nReport",
                                                          style: GoogleFonts
                                                              .poppins(
                                                              color: Colors
                                                                  .black,
                                                              fontSize: width/28,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                          ),
                                                          textAlign: TextAlign.center,


                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                      ),
                                                    ),

                                                    ///  behaviour
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                     top: height / 25.8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [

                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          page = "Messages";
                                                        });
                                                        print("Messages");
                                                      },
                                                      child: Container(
                                                        width: width/3.56363636,
                                                        height: height/11.18571429,

                                                        child: Column(
                                                          children: [
                                                            Icon(
                                                              Icons.message_sharp,
                                                              color: Color(
                                                                  0xffA021FF),
                                                              size: width / 12,),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  left: width / 45,
                                                                  right: width / 45,
                                                                  top: height / 94.5,
                                                                  bottom: height /
                                                                      94.5),
                                                              child: Text(
                                                                "Groups",
                                                                style: GoogleFonts
                                                                    .poppins(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: width/28,
                                                                    fontWeight:
                                                                    FontWeight.w500),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    /// Attendance

                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          //page = "Leave";
                                                        });
                                                        //print("Leave");
                                                      },
                                                      child: Container(
                                                        width: width/3.56363636,
                                                        height: height/11.18571429,

                                                      ),
                                                    ),

                                                    ///  home works

                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                        //  page = "Messages";
                                                        });
                                                        print("Messages");
                                                      },
                                                      child: Container(
                                                        width: width/3.56363636,
                                                        height: height/11.18571429,

                                                      ),
                                                    ),

                                                    ///  behaviour
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: height / 18.9),


                                            ],
                                          ),
                                        ),
                                      ]
                                    )


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
                                            "Assignments",
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
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
                                                        "Today",
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

                                              ///custom
                                              InkWell(

                                                onTap: () async {
                                                  setState(() {
                                                    Hmselected = 4;
                                                  });
                                                  DateTime? pickedDate = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      //DateTime.now() - not to allow to choose before today.
                                                      lastDate: DateTime(2101)
                                                  );

                                                  if (pickedDate != null) {
                                                    print(
                                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                                    String formattedDate = DateFormat('dMyyyy').format(
                                                        pickedDate);
                                                    print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                                    //you can implement different kind of Date Format here according to your requirement

                                                    setState(() {
                                                      currentdate=formattedDate;

                                                      //set output date to TextField value.
                                                    });
                                                  } else {
                                                    print("Date is not selected");
                                                  }
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
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: snapshot2.data!.docs.length,
                                                    itemBuilder: (context, index) {
                                                      var subjecthomework=snapshot2.data!.docs[index];
                                                      return  Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                                                        "${subjecthomework['subject']} - ${subjecthomework['statffname']}",
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
                                                                      "Due Date: ${subjecthomework['date']} \nTime:${subjecthomework['Time']}",
                                                                      style: GoogleFonts.poppins(
                                                                          color: Color(0xffA294A1),
                                                                          fontWeight:
                                                                          FontWeight.w700,
                                                                          fontSize: 15),
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
                                                                        MaterialPageRoute(builder: (context)=>AssigmentsST(subjecthomework.id,Studentclass,Studentsec,Studentname,Studentregno,currentdate.toString()))
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
                                                                  SizedBox(height: 15,),


                                                                  InkWell(
                                                                    onTap: (){
                                                                      Navigator.of(context).push(
                                                                        MaterialPageRoute(builder: (context)=>AssigmentsST(subjecthomework.id,Studentclass,Studentsec,Studentname,Studentregno,currentdate.toString()))
                                                                      );

                                                                    },
                                                                    child: Container(
                                                                        height: 40,
                                                                        width: 100,
                                                                        decoration: BoxDecoration(
                                                                          color:  Colors.green,
                                                                          border: Border.all(
                                                                            color:  Colors.green,
                                                                          ),
                                                                          borderRadius:
                                                                          BorderRadius
                                                                              .circular(10),
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                            "Completed",
                                                                            style: GoogleFonts.poppins(
                                                                                color: Colors.white,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                                fontSize: 13),
                                                                          ),
                                                                        )),
                                                                  ),
                                                                ],
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                      );

                                                    },);
                                                },);

                                            },
                                          ),


                                          SizedBox(height: height / 4.0),
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


                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: const [
                                                      CircleAvatar(
                                                        radius: 8,
                                                        foregroundColor: Colors.yellow,
                                                        backgroundColor: Colors.yellowAccent,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("Holiday",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w700)),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      CircleAvatar(
                                                        radius: 8,
                                                        foregroundColor: Colors.red,
                                                        backgroundColor: Colors.red,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("Absent",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w700)),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      CircleAvatar(
                                                        radius: 8,
                                                        foregroundColor: Colors.green,
                                                        backgroundColor: Colors.green,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("Present",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w700)),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                    ],
                                                  ),
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
                                                          SizedBox(width: 15),
                                                          Text("16/09/2023- Saturday",style:
                                                          GoogleFonts.poppins(
                                                              color:Colors.white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              fontSize: 18))
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
                                                child: SingleChildScrollView(
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
                                                                  gettimetable();
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
                                                                        "Today",
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
                                                                  gettimetable();
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
                                                                  gettimetable();
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
                                                                  gettimetable();
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
                                                                    TTselected = 5;
                                                                  });
                                                                  gettimetable();
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
                                                                        "Thursday",
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

                                                              ///Friday
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    TTselected = 6;
                                                                  });
                                                                  gettimetable();
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
                                                                        "Friday",
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

                                                              ///Saturday
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    TTselected = 7;
                                                                  });
                                                                  gettimetable();
                                                                },
                                                                child: Container(
                                                                    height: 40,
                                                                    width: 105,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: TTselected ==
                                                                              7
                                                                          ? Color(
                                                                              0xff0873C4)
                                                                          : Color(
                                                                              0xffF0EFEF),
                                                                      border: Border
                                                                          .all(
                                                                        color: TTselected ==
                                                                                7
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
                                                                                    7
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
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: height / 75.6),
                                                        padding: EdgeInsets.only(
                                                            bottom: height / 80.6),
                                                        height: height / 1.7425,
                                                        width: width / 1,
                                                        decoration: BoxDecoration(
                                                            color: Color(0xff0873C4),
                                                            borderRadius: BorderRadius.circular(
                                                                12)),
                                                        child: ListView.builder(
                                                          physics: NeverScrollableScrollPhysics(),
                                                            itemCount: teachertable.length,
                                                            itemBuilder: (context,index){
                                                              return  Padding(
                                                                padding: const EdgeInsets.only(
                                                                    top: 8.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Stack(
                                                                        children: [
                                                                          Container(
                                                                            height: height /
                                                                                18.425,
                                                                            width: width / 1.2,
                                                                            decoration: BoxDecoration(
                                                                                color: Color(
                                                                                    0xffECECEC),
                                                                                borderRadius: BorderRadius
                                                                                    .circular(
                                                                                    18)),
                                                                            child:
                                                                            Padding(
                                                                              padding: EdgeInsets
                                                                                  .only(
                                                                                  left: width /
                                                                                      4.0,top: height/150),
                                                                              child: Text(
                                                                                teachertable[index],
                                                                                style: GoogleFonts
                                                                                    .poppins(
                                                                                    color: Color(
                                                                                        0xff0873C4),
                                                                                    fontSize: width/19.6,
                                                                                    fontWeight: FontWeight
                                                                                        .w600),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                            height / 18.425,
                                                                            width:
                                                                            width / 4.285,
                                                                            decoration:
                                                                            BoxDecoration(
                                                                                color: Colors
                                                                                    .white,
                                                                                borderRadius: BorderRadius
                                                                                    .circular(
                                                                                    18)),
                                                                            child:
                                                                            Center(
                                                                                child: Text("${(index+1).toString()} Hr", style: GoogleFonts
                                                                                    .poppins(
                                                                                    color: Color(
                                                                                        0xff0873C4),
                                                                                    fontSize: width/19.6,
                                                                                    fontWeight: FontWeight
                                                                                        .w600),)
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                      ),

                                                      SizedBox(
                                                          height: height / 3.5),

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
                                            ),
                                          )
                                        : page == "Feedback"
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    left: width / 36,
                                                    right: width / 36,
                                                    top: height / 15.12),
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
                                                          "Feed Back Reports",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Color(0xff0271C5),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
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
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              width: width/1.3,
                                                              child: Divider(
                                                                color:Colors.grey
                                                                    .shade700
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: height / 92.125,
                                                        ),
                                                        Container(
                                                          padding:
                                                          EdgeInsets.only(
                                                              left: width / 18,
                                                              right: width / 14.4,
                                                              top: height / 50.4),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            children: [
                                                              Container(
                                                                width:width /
                                                                    2.6,
                                                                child: Text(
                                                                  "Remarks - Staff",
                                                                  style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      15,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                                ),
                                                              ),
                                                              SizedBox(width: 10,),
                                                              Text(
                                                                "Date \nTime",
                                                                style: GoogleFonts.poppins(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                    15,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                              ),
                                                              SizedBox(width: 40,),
                                                              Text(
                                                                "Value",
                                                                style: GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                  15,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        /// Name

                                                        StreamBuilder(
                                                            stream: _firestore2db.collection("Students").doc(Studentid).collection("Feedback")
                                                                .orderBy("timestamp",descending: true)
                                                                .snapshots(),
                                                            builder: (context, snapshot) {

                                                              if (snapshot.hasData == null) {
                                                                return Center(
                                                                    child: CircularProgressIndicator(
                                                                      color: Color(
                                                                          0xff0873c4),
                                                                    ));
                                                              }
                                                              if (!snapshot.hasData) {
                                                                return Center(
                                                                    child: CircularProgressIndicator(
                                                                      color: Color(
                                                                          0xff0873c4),
                                                                    ));
                                                              }
                                                              return ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),

                                                                  itemCount: snapshot.data!
                                                                      .docs.length,
                                                                  itemBuilder: (context,
                                                                      index) {
                                                                    return

                                                                      Container(
                                                                        padding:
                                                                        EdgeInsets.only(
                                                                          left: width / 18,

                                                                          top: height /
                                                                              50.4,),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: width /
                                                                                      2.6,

                                                                                  child: Text(
                                                                                    snapshot.data!
                                                                                        .docs[index]["remarks"],
                                                                                    style: GoogleFonts
                                                                                        .poppins(
                                                                                        color: Colors
                                                                                            .black,
                                                                                        fontSize:
                                                                                        15,
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .w600),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: width /
                                                                                      2.6,

                                                                                  child: Text(
                                                                                    "- ${snapshot.data!
                                                                                        .docs[index]["staffname"]}",
                                                                                    style: GoogleFonts
                                                                                        .poppins(
                                                                                        color: Colors
                                                                                            .black54,
                                                                                        fontSize:
                                                                                        13,
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .w600),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),

                                                                            Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: width /
                                                                                      4.25,

                                                                                  child: Text(
                                                                                    snapshot.data!
                                                                                        .docs[index]["date"],
                                                                                    style: GoogleFonts
                                                                                        .poppins(
                                                                                        color: Colors
                                                                                            .black,
                                                                                        fontSize:
                                                                                        15,
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .w600),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: width /
                                                                                      7.25,

                                                                                  child: Text(
                                                                                    snapshot.data!
                                                                                        .docs[index]["time"],
                                                                                    style: GoogleFonts
                                                                                        .poppins(
                                                                                        color: Colors
                                                                                            .black,
                                                                                        fontSize:
                                                                                        15,
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .w600),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Container(
                                                                              height: height /
                                                                                  29.48,
                                                                              width:
                                                                              width / 3.6,
                                                                              decoration: BoxDecoration(
                                                                                  color: snapshot
                                                                                      .data!
                                                                                      .docs[index]["value"] ==
                                                                                      "Good"
                                                                                      ? Colors
                                                                                      .green
                                                                                      : snapshot
                                                                                      .data!
                                                                                      .docs[index]["value"] ==
                                                                                      "Bad"
                                                                                      ? Colors
                                                                                      .red
                                                                                      : Colors
                                                                                      .orange,
                                                                                  borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(
                                                                                      5)),
                                                                              child: Row(
                                                                                mainAxisAlignment:
                                                                                MainAxisAlignment
                                                                                    .spaceEvenly,
                                                                                children: [

                                                                                  Text(
                                                                                    snapshot
                                                                                        .data!
                                                                                        .docs[index]["value"],
                                                                                    style: GoogleFonts
                                                                                        .poppins(
                                                                                        color: Colors
                                                                                            .white,
                                                                                        fontSize:
                                                                                        15,
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .w600),
                                                                                  ),
                                                                                  Icon(
                                                                                    snapshot
                                                                                        .data!
                                                                                        .docs[index]["value"] ==
                                                                                        "Good"
                                                                                        ? Icons
                                                                                        .thumb_up_outlined
                                                                                        : Icons
                                                                                        .thumb_down_alt_outlined,
                                                                                    color: Colors
                                                                                        .white,
                                                                                    size: 16,),
                                                                                ],
                                                                              ),
                                                                            ),





                                                                          ],
                                                                        ),
                                                                      );
                                                                  }
                                                              );
                                                            }
                                                        ),


                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                            : page == "Fees"
                            ? Padding(
                          padding: EdgeInsets.only(
                              left: width / 36,
                              right: width / 36,
                              top: height / 15.12),
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
                                CrossAxisAlignment.start,
                                // physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Text(
                                    "Fees",
                                    style: GoogleFonts
                                        .poppins(
                                        color: Color(0xff0271C5),
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight
                                            .w600),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width/1.3,
                                        child: Divider(
                                            color:Colors.grey
                                                .shade700
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height / 92.125,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                            : page== "Progress"
                            ? Padding(
                          padding: EdgeInsets.only(
                              left: width / 36,
                              right: width / 36,
                              top: height / 15.12),
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
                                CrossAxisAlignment.start,
                                // physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Text(
                                    "Progress Report",
                                    style: GoogleFonts
                                        .poppins(
                                        color: Color(0xff0271C5),
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight
                                            .w600),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width/1.3,
                                        child: Divider(
                                            color:Colors.grey
                                                .shade700
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height / 92.125,
                                  ),

                                  Material(
                                    elevation:5,
                                    borderRadius: BorderRadius.circular(12),
                                    child: GestureDetector(
                                      onTap: () async{

                                        List<p.Widget> widgets = [];
                                        var fontsemipoppoins = await PdfGoogleFonts.poppinsSemiBold();
//Profile image
                                        final image =  p.Image(
                                            await imageFromAssetBundle('assets/A2Demo.png'),
                                            fit: p.BoxFit.contain,
                                            height: 841,


                                        );
                                        final image2 =  p.Image(
                                            await imageFromAssetBundle('assets/A1Demo.png'),
                                            fit: p.BoxFit.contain,
                                            height: 841,


                                        );

//container for profile image decoration
                                        final container = p.Center(
                                          child: p.Stack(
                                          children:[

                                          p.Container(
                                              height: 841,
                                              child: image
                                          ),
                                            p.Padding(
                                              padding: p.EdgeInsets.only(top:210,left:380),
                                              child: p.Text(Studentname,style: p.TextStyle(
                                                fontSize: 20,
                                                font: fontsemipoppoins,
                                                color: PdfColors.white,
                                              ))
                                            ),
                                            p.Padding(
                                                padding: p.EdgeInsets.only(top:245,left:380),
                                                child: p.Text("${Studentclass} ${Studentsec}",style: p.TextStyle(
                                                  fontSize: 20,
                                                  font: fontsemipoppoins,
                                                  color: PdfColors.white,
                                                ))
                                            )

                                            ]
                                          )
                                        );
                                        final container2 = p.Center(
                                          child: p.Container(
                                              height: 841,

                                              child: image2
                                          ),
                                        );

//add decorated image container to widgets list

                                        widgets.add(container);
                                        widgets.add(container2);
                                        widgets.add(p.SizedBox(height: 0));//some space beneath image

//add all other data which may be in the form of list
//use a loop to create pdf widget and add it to list
//one by one


//pdf document
                                        final pdf = p.Document();
                                        pdf.addPage(
                                          p.MultiPage(
                                            margin: p.EdgeInsets.zero,
                                            pageFormat: PdfPageFormat.a4,
                                            build: (context) => widgets,//here goes the widgets list
                                          ),
                                        );
                                        Printing.layoutPdf(
                                          onLayout: (PdfPageFormat format) async => pdf.save(),
                                        );


                                      },
                                      child: Container(
                                          width: 370,
                                          height: 100,

                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: Color(0xff0873C4),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 12.0,top:8,bottom: 5),
                                                    child: Text("Download Reports",style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 23,
                                                        fontWeight: FontWeight.w700

                                                    ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 12.0),
                                                    child: Text("Last Updated Today 1.34 AM",style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600

                                                    ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 12.0),
                                                child: Icon(Icons.download,color: Colors.white,size: 40,),
                                              )
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                            : page == "School Bus"
                            ? Padding(
                          padding: EdgeInsets.only(
                              left: width / 36,
                              right: width / 36,
                              top: height / 15.12),
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
                                    "School Bus Tracking",
                                    style: GoogleFonts
                                        .poppins(
                                        color: Color(0xff0271C5),
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight
                                            .w600),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width/1.3,
                                        child: Divider(
                                            color:Colors.grey
                                                .shade700
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height / 92.125,
                                  ),



                                ],
                              ),
                            ),
                          ),
                        )
                            : page == "Request Documents"
                            ? Padding(
                          padding: EdgeInsets.only(
                              left: width / 36,
                              right: width / 36,
                              top: height / 15.12),
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
                                    "Request Documents",
                                    style: GoogleFonts
                                        .poppins(
                                        color: Color(0xff0271C5),
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight
                                            .w600),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width/1.3,
                                        child: Divider(
                                            color:Colors.grey
                                                .shade700
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height / 92.125,
                                  ),

                                  Text(
                                    "Request Documents of the follwing",
                                    style: GoogleFonts
                                        .poppins(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight
                                            .w600),
                                  ),
                                  SizedBox(height:20),
                                  Padding(
                                    padding:EdgeInsets.only(left:75,),
                                    child: Container(
                                      width: 300,
                                      child: Row(
                                        children: [
                                          Icon(Icons.done,size: 15),
                                          Padding(
                                            padding:EdgeInsets.only(left:5),
                                            child: Text('Transver CV',style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:EdgeInsets.only(left:75,),
                                    child: Container(
                                      width: 300,
                                      child: Row(
                                        children: [
                                          Icon(Icons.done,size: 15),
                                          Padding(
                                            padding:EdgeInsets.only(left:5),
                                            child: Text('Bonifide CV',style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:EdgeInsets.only(left:75,),
                                    child: Container(
                                      width: 300,
                                      child: Row(
                                        children: [
                                          Icon(Icons.done,size: 15),
                                          Padding(
                                            padding:EdgeInsets.only(left:5),
                                            child: Text('Sports CV',style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:EdgeInsets.only(left:75,),
                                    child: Container(
                                      width: 300,
                                      child: Row(
                                        children: [
                                          Icon(Icons.done,size: 15),
                                          Padding(
                                            padding:EdgeInsets.only(left:5),
                                            child: Text('Competition CV',style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:EdgeInsets.only(top:25),
                                    child: Container(
                                      width: 300,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Name',style: GoogleFonts.poppins(
                                              color: const Color(0xff707070),
                                              fontWeight:FontWeight.bold
                                          ),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 380,
                                    child: TextField (
                                      controller: namecontroller,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,

                                          hintText: 'Enter Your Name'
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:EdgeInsets.only(top:15),
                                    child: Container(
                                      width: 300,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Reg No',style: GoogleFonts.poppins(
                                              color: const Color(0xff707070),
                                              fontWeight:FontWeight.bold
                                          ),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 380,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                          border: Border.all(color: Colors.black45)
                                      ),
                                      width: 300,
                                      child: TextFormField(
                                        controller: otpcontroller,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Regno'
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:EdgeInsets.only(top:15),
                                    child: Container(
                                      width: 380,
                                      child: Text('Requirement',style: GoogleFonts.poppins(
                                          color: const Color(0xff707070),
                                          fontWeight:FontWeight.bold
                                      ),),
                                    ),
                                  ),
                                  Container(
                                    width: 380,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                          border: Border.all(color: Colors.black45)
                                      ),
                                      width: 300,
                                      child: Padding(
                                        padding:EdgeInsets.only(left:5),
                                        child: DropdownButton(
                                          value: dropdownvalue,
                                          icon: Padding(
                                            padding:EdgeInsets.only(left:160),
                                            child: const Icon(Icons.keyboard_arrow_down),
                                          ),
                                          items: items.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownvalue = newValue!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),



                                  Padding(
                                    padding:EdgeInsets.only(top:20),
                                    child: GestureDetector(onTap: (){



                                    },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Submit',style: GoogleFonts.poppins(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),),
                                        ],
                                      ),
                                    ),
                                  ),





                                ],
                              ),
                            ),
                          ),
                        )
                            : page == "Messages"
                            ? Padding(
                          padding: EdgeInsets.only(
                              left: width / 36,
                              right: width / 36,
                              top: height / 12.6),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              page = "Home";
                                            });
                                          },
                                          child: Text(
                                            "Groups",
                                            style: GoogleFonts.poppins(
                                                color: Color(0xff0873C4),
                                                fontSize: width/21.77777778,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height / 368.5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${DateFormat.yMMMd().format(DateTime.now())}",
                                          style: GoogleFonts
                                              .poppins(
                                              color: Colors
                                                  .grey
                                                  .shade700,
                                              fontSize: width/26.13333333,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                        SizedBox(
                                          width: width / 100,
                                        ),

                                        Container(
                                          height:
                                          height / 49.13,
                                          width: width / 170,
                                          color: Colors.grey,
                                        ),

                                        SizedBox(
                                          width: width / 100,
                                        ),
                                        Text(
                                          day,
                                          style: GoogleFonts
                                              .poppins(
                                              color: Colors
                                                  .grey
                                                  .shade700,
                                              fontSize: width/26.13333333,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                      ],
                                    ),
                                    /// date/day
                                    SizedBox(height: height / 184.25),
                                    Divider(
                                      color: Colors.grey.shade400,
                                      thickness: 1,
                                    ),

                                    SizedBox(height: height / 184.25),
                                    Container(
                                      height: size.height / 2.0,
                                      width: size.width,
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: _firestore2db
                                            .collection('${Studentclass}${Studentsec}chat')
                                            .orderBy('time')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return SingleChildScrollView(
                                              reverse: true,
                                              child: Column(
                                                children: [
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder: (context,
                                                        index) {
                                                      Map<String,
                                                          dynamic> chatMap =
                                                      snapshot.data!
                                                          .docs[index]
                                                          .data()
                                                      as Map<String,
                                                          dynamic>;
                                                      return Column(
                                                        crossAxisAlignment: snapshot.data!.docs[index]["sender"]==Studentname?CrossAxisAlignment.end: CrossAxisAlignment.start,
                                                        children: [
                                                          messageTile(
                                                              size, chatMap,
                                                              context,
                                                              snapshot.data!.docs[index].id),
                                                          snapshot.data!.docs[index]["submitdate"] == "${DateTime.now().year}-${ DateTime.now().month}-${ DateTime.now().day}" ?
                                                          Text(
                                                            'Today  ${snapshot
                                                                .data!
                                                                .docs[index]["submittime"]}',
                                                            style: TextStyle(
                                                                fontSize: _width /
                                                                    40,
                                                                color: Colors
                                                                    .grey,
                                                                fontWeight: FontWeight
                                                                    .w700),)
                                                              :
                                                          snapshot
                                                              .data!
                                                              .docs[index]["submitdate"] ==
                                                              "${DateTime
                                                                  .now()
                                                                  .year}-${ DateTime
                                                                  .now()
                                                                  .month}-${ DateTime
                                                                  .now()
                                                                  .day -
                                                                  1}"
                                                              ?
                                                          Text(
                                                            'Yesterday  ${snapshot
                                                                .data!
                                                                .docs[index]["submittime"]}',
                                                            style: TextStyle(
                                                                fontSize: _width /
                                                                    40,
                                                                color: Colors
                                                                    .grey,
                                                                fontWeight: FontWeight
                                                                    .w700),)
                                                              :
                                                          Text(
                                                            "${snapshot
                                                                .data!
                                                                .docs[index]["submitdate"]}  ${snapshot
                                                                .data!
                                                                .docs[index]["submittime"]}",
                                                            style: TextStyle(
                                                                fontSize: _width /
                                                                    40,
                                                                color: Colors
                                                                    .grey,
                                                                fontWeight: FontWeight
                                                                    .w700),),
                                                          Text(
                                                            '${snapshot
                                                                .data!
                                                                .docs[index]["sender"]}',
                                                            style: TextStyle(
                                                                fontSize: _width /
                                                                    40,
                                                                color: Colors
                                                                    .grey,
                                                                fontWeight: FontWeight
                                                                    .w700),),
                                                          SizedBox(
                                                            height: _height /
                                                                80,)
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: size.height / 15,
                                  width: size.width / 1.0,
                                  alignment:
                                  Alignment.center,
                                  child:
                                  Container(
                                    height: size.height / 18,
                                    width: size.width / 1.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius
                                                .circular(30),
                                          ),
                                          height: size.height / 18,
                                          width: size.width / 1.27,
                                          child: TextField(
                                            controller: _message,
                                            onEditingComplete: onSendMessage,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets
                                                    .all(8),
                                                hintText: "Type here",
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(30),
                                                )),
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.send,
                                              color: Color(0xff2C79F1),),
                                            onPressed: onSendMessage),
                                      ],
                                    ),
                                  ),

                                ),
                                SizedBox(height: height / 5.0),
                              ],
                            ),
                          ),
                        )
                                            : Container()),
                  ),

                  Padding(
                    padding:  EdgeInsets.only(left: width/13.33,right: width/13.333),
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
                        padding:  EdgeInsets.only(top:height/94.5,bottom: height/189),
                        child: TextField(

                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: height/50.4),
                              enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                              focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                              prefixIcon: Icon(Icons.search_rounded
                              ),
                              hintText: "Search",
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey.shade900, fontSize:width/22.5)),
                          onSubmitted: (_){
                            if(Searchcontroller.text=="Attendance"){
                              setState(() {
                                page = "Attendance";
                              });
                            }
                            if(Searchcontroller.text=="Attendance"){
                              setState(() {
                                page = "Attendance";
                              });
                            }
                            if(Searchcontroller.text=="Home Works"){
                              setState(() {
                                page = "Home Works";
                              });
                            }
                            if(Searchcontroller.text=="Behaviour"){
                              setState(() {
                                page = "Behaviour";
                              });
                            }
                            if(Searchcontroller.text=="Circulars"){
                              setState(() {
                                page = "Circulars";
                              });
                            }
                            if(Searchcontroller.text=="Time Table"){
                              setState(() {
                                page = "Time Table";
                              });
                            }
                            if(Searchcontroller.text=="Messages"){
                              setState(() {
                                page = "Messages";
                              });
                            }
                            if(Searchcontroller.text.contains('Home')){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Root_Page() ,));
                            }
                            if(Searchcontroller.text.contains('Message')){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Root_Page() ,));
                            }
                            if(Searchcontroller.text.contains('Exams')){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Root_Page() ,));
                            }
                            if(Searchcontroller.text.contains('Profile')){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Root_Page() ,));
                            }


                          },
                          controller: Searchcontroller,
                        ),
                      ),
                    ),
                  ),
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
                      child: Padding(
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
                            child: SingleChildScrollView(
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

                                      stream:_firestore2db.collection("Circulars").orderBy("timestamp",descending: true).snapshots(),
                                      builder: (context, snap){
                                        if(snap.hasData==null){
                                          return Center(child: CircularProgressIndicator(),);
                                        }
                                        if(!snap.hasData){
                                          return Center(child: CircularProgressIndicator(),);
                                        }

                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
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
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: SizedBox(
                                                              height:28,
                                                              width:28,
                                                              child: Image.asset("assets/Alert Iocn.png"),
                                                            ),
                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.only(top:10.0),
                                                            child: SizedBox(
                                                              width:280,

                                                              child: Text(
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
                                                            ),
                                                          ),

                                                        ],
                                                      ),


                                                      ///deccription
                                                      Padding(
                                                        padding:  EdgeInsets.only(left:30),
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

                                                              width:250,
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    "${circular['Date']} | ${circular['Time']}",
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

                                        },
                                        );
                                      },),


                                  SizedBox(
                                      height: height / 5.0),


                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
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
  int i=0;

  String dropdownvalue = 'Transver CV';

  // List of items in our dropdown menu
  var items = [
    'Transver CV',
    'Bonifide CV',
    'Sports CV',
  ];

  TextEditingController namecontroller =TextEditingController();
  TextEditingController otpcontroller =TextEditingController();
  TextEditingController email =TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  List teachertable=["","","","","","","",""];
  gettimetable() async {
    print("HIooo");
    setState(() {
      teachertable=["","","","","","","",""];
    });
   var document= await _firestore2db.collection("ClassTimeTable").doc("${Studentclass}${Studentsec}").collection("TimeTable").get();

   print("${Studentclass}${Studentsec}");
setState(() {


   if(TTselected==1) {
     if (day == "Monday") {
       for (int i = 0; i < document.docs.length; i++) {
         if (document.docs[i]["order"] == 0) {
           teachertable.replaceRange(0, 1,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 1) {
           teachertable.replaceRange(1, 2,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 2) {
           teachertable.replaceRange(2, 3,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 3) {
           teachertable.replaceRange(3, 4,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 4) {
           teachertable.replaceRange(4, 5,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 5) {
           teachertable.replaceRange(5, 6,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 6) {
           teachertable.replaceRange(6, 7,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 7) {
           teachertable.replaceRange(7, 8,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
       }
      /* for (int j = 0; j < teachertable.length; j++) {
         if (teachertable[j] == "") {
           teachertable.replaceRange(j, j + 1, ["Free Period"]);
         }
       }

       */
     }
     if(day=="Tuesday"){
       for(int i=0;i<document.docs.length;i++){

         if(document.docs[i]["order"]==8){
           teachertable.replaceRange(0,1,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==9){
           teachertable.replaceRange(1,2,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==10){
           teachertable.replaceRange(2,3,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==11){
           teachertable.replaceRange(3,4,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==12){
           teachertable.replaceRange(4,5,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==13){
           teachertable.replaceRange(5,6,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==14){
           teachertable.replaceRange(6,7,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==15){
           teachertable.replaceRange(7,8,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }


       }

     }
     if(day=="Wednesday"){
       for(int i=0;i<document.docs.length;i++){

         if(document.docs[i]["order"]==16){
           teachertable.replaceRange(0,1,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==17){
           teachertable.replaceRange(1,2,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==18){
           teachertable.replaceRange(2,3,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==19){
           teachertable.replaceRange(3,4,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==20){
           teachertable.replaceRange(4,5,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==21){
           teachertable.replaceRange(5,6,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==22){
           teachertable.replaceRange(6,7,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==23){
           teachertable.replaceRange(7,8,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }


       }

     }
     if(day=="Thursday"){
       for(int i=0;i<document.docs.length;i++){

         if(document.docs[i]["order"]==24){
           teachertable.replaceRange(0,1,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==25){
           teachertable.replaceRange(1,2,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==26){
           teachertable.replaceRange(2,3,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==27){
           teachertable.replaceRange(3,4,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==28){
           teachertable.replaceRange(4,5,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==29){
           teachertable.replaceRange(5,6,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==30){
           teachertable.replaceRange(6,7,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==31){
           teachertable.replaceRange(7,8,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }


       }

     }
     if(day=="Friday"){
       for(int i=0;i<document.docs.length;i++){

         if(document.docs[i]["order"]==32){
           teachertable.replaceRange(0,1,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==33){
           teachertable.replaceRange(1,2,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==34){
           teachertable.replaceRange(2,3,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==35){
           teachertable.replaceRange(3,4,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==36){
           teachertable.replaceRange(4,5,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==37){
           teachertable.replaceRange(5,6,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==38){
           teachertable.replaceRange(6,7,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }
         else if(document.docs[i]["order"]==39){
           teachertable.replaceRange(7,8,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
         }


       }

     }
     if(day=="Saturday") {
       for (int i = 0; i < document.docs.length; i++) {
         if (document.docs[i]["order"] == 40) {
           teachertable.replaceRange(0, 1, [
             "${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"
           ]);
         }
         else if (document.docs[i]["order"] == 41) {
           teachertable.replaceRange(1, 2, [
             "${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"
           ]);
         }
         else if (document.docs[i]["order"] == 42) {
           teachertable.replaceRange(2, 3, [
             "${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"
           ]);
         }
         else if (document.docs[i]["order"] == 43) {
           teachertable.replaceRange(3, 4, [
             "${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"
           ]);
         }
         else if (document.docs[i]["order"] == 44) {
           teachertable.replaceRange(4, 5, [
             "${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"
           ]);
         }
         else if (document.docs[i]["order"] == 45) {
           teachertable.replaceRange(5, 6, [
             "${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"
           ]);
         }
         else if (document.docs[i]["order"] == 46) {
           teachertable.replaceRange(6, 7, [
             "${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"
           ]);
         }
         else if (document.docs[i]["order"] == 47) {
           teachertable.replaceRange(7, 8, [
             "${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"
           ]);
         }
       }
     }
   }
  else if(TTselected==2) {

       for (int i = 0; i < document.docs.length; i++) {
         if (document.docs[i]["order"] == 0) {
           teachertable.replaceRange(0, 1,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 1) {
           teachertable.replaceRange(1, 2,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 2) {
           teachertable.replaceRange(2, 3,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 3) {
           teachertable.replaceRange(3, 4,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 4) {
           teachertable.replaceRange(4, 5,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 5) {
           teachertable.replaceRange(5, 6,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 6) {
           teachertable.replaceRange(6, 7,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
         else if (document.docs[i]["order"] == 7) {
           teachertable.replaceRange(7, 8,
               ["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}"]);
         }
       }


   }
  else if(TTselected==3) {

     for(int i=0;i<document.docs.length;i++){

       if(document.docs[i]["order"]==8){
         teachertable.replaceRange(0,1,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==9){
         teachertable.replaceRange(1,2,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==10){
         teachertable.replaceRange(2,3,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==11){
         teachertable.replaceRange(3,4,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==12){
         teachertable.replaceRange(4,5,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==13){
         teachertable.replaceRange(5,6,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==14){
         teachertable.replaceRange(6,7,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==15){
         teachertable.replaceRange(7,8,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }


     }


   }
  else if(TTselected==4) {

     for(int i=0;i<document.docs.length;i++){

       if(document.docs[i]["order"]==16){
         teachertable.replaceRange(0,1,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==17){
         teachertable.replaceRange(1,2,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==18){
         teachertable.replaceRange(2,3,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==19){
         teachertable.replaceRange(3,4,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==20){
         teachertable.replaceRange(4,5,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==21){
         teachertable.replaceRange(5,6,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==22){
         teachertable.replaceRange(6,7,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==23){
         teachertable.replaceRange(7,8,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }


     }


   }
  else if(TTselected==5) {

     for(int i=0;i<document.docs.length;i++){

       if(document.docs[i]["order"]==24){
         teachertable.replaceRange(0,1,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==25){
         teachertable.replaceRange(1,2,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==26){
         teachertable.replaceRange(2,3,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==27){
         teachertable.replaceRange(3,4,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==28){
         teachertable.replaceRange(4,5,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==29){
         teachertable.replaceRange(5,6,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==30){
         teachertable.replaceRange(6,7,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==31){
         teachertable.replaceRange(7,8,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }


     }


   }
  else if(TTselected==6) {

     for(int i=0;i<document.docs.length;i++){

       if(document.docs[i]["order"]==32){
         teachertable.replaceRange(0,1,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==33){
         teachertable.replaceRange(1,2,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==34){
         teachertable.replaceRange(2,3,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==35){
         teachertable.replaceRange(3,4,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==36){
         teachertable.replaceRange(4,5,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==37){
         teachertable.replaceRange(5,6,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==38){
         teachertable.replaceRange(6,7,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==39){
         teachertable.replaceRange(7,8,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }


     }


   }
 else  if(TTselected==7) {

     for(int i=0;i<document.docs.length;i++){

       if(document.docs[i]["order"]==40){
         teachertable.replaceRange(0,1,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==41){
         teachertable.replaceRange(1,2,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==42){
         teachertable.replaceRange(2,3,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==43){
         teachertable.replaceRange(3,4,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==44){
         teachertable.replaceRange(4,5,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==45){
         teachertable.replaceRange(5,6,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==46){
         teachertable.replaceRange(6,7,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }
       else if(document.docs[i]["order"]==47){
         teachertable.replaceRange(7,8,["${document.docs[i]["subject"]} - ${document.docs[i]["staff"]}" ]);
       }



     }


   }
});
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
                activeColor: Color(0xff0873C4),
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