import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pinput/pinput.dart';
import 'Notifications.dart';
import 'Profileview.dart';
import 'StudentAttendance_Page.dart';
import 'Student_Profile.dart';
import 'StudentsExam.dart';
import 'account_page.dart';
import 'assignmentsdetailsst.dart';
import 'package:pdf/widgets.dart' as p;
import 'package:printing/printing.dart';

class Student_landing_Page extends StatefulWidget {
  String?navigation;
  bool?naviagtiontcheck;
  Student_landing_Page(this.navigation,this.naviagtiontcheck);

  @override
  State<Student_landing_Page> createState() => _Student_landing_PageState();
}

class _Student_landing_PageState extends State<Student_landing_Page> {
  int selecteIndexvalue = 0;

  String page = "Home";
  String Studentid = "";
  String Studentname = '';
  String Studentlastname = '';
  String Studentregno = '';
  String Studentimg = '';
  String Studentclass = '';
  String Studentsec = '';
bool Loading=false;

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
        };
        setState(() {
          Studentname = values[0]!;
        });
        print(values[0]);
        setState(() {
          Studentlastname=stuvalue['stlastname'];
          Studentregno = stuvalue['regno'];
          Studentimg = stuvalue['imgurl'];
          Studentclass = stuvalue['admitclass'];
          Studentsec = stuvalue['section'];
        });

        studentattendancestatus();

      }
    };


  }

  Date() {
    Period.clear();
    setState(() {
      Period.clear();
      day = DateFormat('EEEE').format(DateTime.now());

      cyear = DateTime
          .now()
          .year;
      cmonth = getMonth(DateTime
          .now()
          .month);

      currentDate = DateTime
          .now()
          .day;
    });

    print(day);
    print(currentDate);
  }

  String getMonth(int currentMonthIndex) {
    return DateFormat('MMM').format(DateTime(0, currentMonthIndex)).toString();
  }

  List Period = [];

  final GlobalKey<ScaffoldState> key = GlobalKey();


  String currentdate = "${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}";
  int currentDate = 0;
  String studentassingid = 'All';
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
    if(widget.navigation!=""&&widget.naviagtiontcheck!=false){
      setState(() {
        page=widget.navigation!;
      });
    print(widget.navigation);
      print(widget.naviagtiontcheck);
    }
    print("init functiopn entereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    studentdetails();

    Date();
    gettimetable();
    // TODO: implement initState
    super.initState();
  }

  ///stuydent attendance length function
  int Absentvalue = 0;
  int presentvalue = 0;
  double Percentagevalue=0;
  double Circlularprogrossvalue=0;

  studentattendancestatus() async {
    print("Enter fffffffffffffffffffffffffffffffffffffffffffff");
    print(Studentid);
    setState((){
      Totalvalue=0;
      presentvalue=0;
      Absentvalue=0;
      Percentagevalue=0;
      Circlularprogrossvalue=0;
    });
    print("studentattendancestatuslllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
    var document= await _firestore2db.collection("Students").doc(Studentid).
    collection('Attendance').get();
    setState(() {
      Totalvalue=document.docs.length;
    });
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


    setState(() {
      Percentagevalue=(((presentvalue/Totalvalue)*100));
      Circlularprogrossvalue=(((presentvalue/Totalvalue)*100)/100);
    });
    print("Presnt value000000000000000000000000$presentdayvalue");
    print("Absnet valeuooooooooooooooooooooo$absentdayvalue");

    print("Attenge value-------------------------------------------");
    print(Circlularprogrossvalue);
    print(Totalvalue);
    print(Percentagevalue);
    print("22222222222222222222222222222222-------------------------------------------");

  }


  

  ///home work select variable
  int Hmselected = 1;

  ///timetable select variable
  int TTselected = 1;

  demo() {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return AwesomeDialog(
      width: width / 0.87111111,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Are you sure want to exit',


      btnCancelOnPress: () {},
      btnOkOnPress: () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
    )
      ..show();
  }

  demo2() {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return AwesomeDialog(
      width: width / 0.8,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Are you sure want to exit',


      btnCancelOnPress: () {

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
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
                width: size.width,
                alignment: chatMap['sender'] == Studentname ? Alignment.centerRight : Alignment.centerLeft,
                child:
                GestureDetector(
                  onLongPress: () {
                    if (chatMap['sender'] == Studentname) {
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
                        color: chatMap['sender'] == Studentname
                            ? Colors.white
                            : Color(0xff0271C5),
                        border: Border.all(
                            color: chatMap['sender'] == Studentname ? Color(
                                0xff010029)
                                .withOpacity(0.65) : Color(0xff0271C5)),
                        borderRadius: BorderRadius.only(topLeft: Radius
                            .circular(15),
                          bottomLeft: chatMap['sender'] == Studentname ? Radius
                              .circular(15) : Radius.circular(0),
                          bottomRight: chatMap['sender'] == Studentname ? Radius
                              .circular(0) : Radius.circular(15),
                          topRight: Radius.circular(15),),
                      ),
                      child: Column(
                        children: [
                          Text(
                            chatMap['message'],
                            style: GoogleFonts.montserrat(
                              fontSize: width / 30.15384615,
                              fontWeight: FontWeight.w500,
                              color: chatMap['sender'] == Studentname ? Colors
                                  .black : Colors.white,
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

  TextEditingController _message = new TextEditingController();


  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
        "submittime": "${DateFormat('hh:mm a').format(DateTime.now())}",
        "sender": Studentname,
        "submitdate": "${DateTime
            .now()
            .year}-${DateTime
            .now()
            .month}-${DateTime
            .now()
            .day}",
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
        "submittime": "${DateFormat('hh:mm a').format(DateTime.now())}",
        "sender": Studentname,
        "submitdate": "${DateTime
            .now()
            .year}-${DateTime
            .now()
            .month}-${DateTime
            .now()
            .day}",
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


  List<String> Homesearclist = [
    "Attendance",
    "Assignments",
    "Time Table",
    "Fees",
    "School Bus",
    "Feedback",
    "Request Documents",
    "Library",
    "Progress Reports",
    "Groups"
  ];


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

    List<Widget> widgetlist = [

      ///Attendance
      Icon(
        Icons.calendar_month_outlined,
        color: Color(0xff609F00),
        size: width / 12,
      ),

      ///asisignment
      Icon(Icons.note_alt_sharp,
          color: Color(0xffFECE3E),
          size: width / 12),

      ///Time Table
      Icon(Icons.timer_outlined,
          color: Color(0xff224FFF),
          size: width / 12),

      ///Fees
      Icon(
        Icons.wallet_rounded,
        color: Color(0xffA021FF),
        size: width / 12,
      ),

      ///School BUs
      Icon(Icons.directions_bus_filled_rounded, color: Color(0xff224FFF),
          size: width / 12),

      ///Feed Back
      Icon(
          Icons.person_2_outlined,
          color: Color(0xff609F00),
          size: width / 12),

      ///Request Docments
      Icon(
          Icons.drive_file_move_sharp,
          color: Color(0xff609F00),
          size: width / 12
      ),

      ///library
      Icon(Icons.menu_book_sharp,
          color: Color(0xffFECE3E),
          size: width / 12),

      ///Progresss reports
      Icon(Icons.collections_bookmark,
          color: Color(0xffA021FF),
          size: width / 12),

      ///Groups
      Icon(Icons.message_sharp,
        color: Color(0xffA021FF),
        size: width / 12,),
    ];

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
        backgroundColor: Color(0xff0873C4),

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height / 25.2),

              Container(
                  height: height / 3.0,
                  width: double.infinity,
                  decoration: const BoxDecoration(

                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/Rectangle.png")
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Stack(
                            children: [

                              Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: height / 25.745,
                                        left: 0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Profileview2(Studentimg))
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 64,
                                        backgroundColor: Colors.grey.shade200,
                                        backgroundImage: NetworkImage(
                                            Studentimg
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height / 151.2,),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 0),
                                    child: Text(
                                     "${Studentname} ${Studentlastname}",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: width / 16.363,
                                          fontWeight: FontWeight.bold

                                      ),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 0),
                                    child: Text("ID : ${Studentregno}",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: width / 22.5,
                                          fontWeight: FontWeight.w500

                                      ),),
                                  )
                                ],
                              ),

                              

                            ]
                        ),
                      ),

                    ],
                  )),

              InkWell(
                onTap: () {
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.home, color: Colors.white,),
                    title: Text("Home", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 22.5)),
                  ),
                ),
              ),


              InkWell(
                onTap: () {
                  key.currentState!.closeEndDrawer();
                },
                child: Container(

                  child: ListTile(
                    leading: Icon(Icons.assignment, color: Colors.white,),
                    title: Text("Exams", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 22.5)),
                  ),
                ),
              ),


              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Student_Profile(Studentid),));
                  key.currentState!.closeEndDrawer();
                },
                child: Container(

                  child: ListTile(
                    leading: Icon(Icons.person_outline, color: Colors.white,),
                    title: Text("Profile", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 22.5)),
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  setState(() {
                    page = "Attendance";
                  });
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(
                      Icons.calendar_month_outlined, color: Colors.white,),
                    title: Text("Attendance", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 22.5)),
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  setState(() {
                    page = "Home Works";
                  });
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.note_alt, color: Colors.white,),
                    title: Text("Assignments", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 22.5)),
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  setState(() {
                    selecteIndexvalue = 1;
                  });
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(
                      Icons.note_alt_outlined, color: Colors.white,),
                    title: Text("Circulars", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 22.5)),
                  ),
                ),
              ),


              InkWell(
                onTap: () {
                  setState(() {
                    page = "Time Table";
                  });
                  gettimetable();
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.timer_outlined, color: Colors.white,),
                    title: Text("Time Table", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 22.5)),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    page = "Fees";
                  });

                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.wallet_rounded, color: Colors.white,),
                    title: Text("Fees", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 22.5)),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    page = "School Bus";
                  });

                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.directions_bus_filled_rounded,
                      color: Colors.white,),
                    title: Text("School Bus", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 22.5)),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    page = "Feedback";
                  });
                  gettimetable();
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(
                      Icons.person_2_outlined, color: Colors.white,),
                    title: Text("Feedback", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 22.5)),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    page = "Request Documents";
                  });
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(
                      Icons.drive_file_move_rounded, color: Colors.white,),
                    title: Text("Request Documents", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 22.5)),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    page = "Library";
                  });
                  gettimetable();
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.menu_book, color: Colors.white,),
                    title: Text("Library", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 22.5)),
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
      backgroundColor: selecteIndexvalue == 3 ?
      Color(0xffFFFFFF) : Color(0xff0873C4),
      body: selecteIndexvalue == 0 ?
      WillPopScope(
        onWillPop: () {
          if (page == "Home") {
            demo();
            Searchcontroller.clear();
          } else {
            setState(() {
              page = "Home";
              Searchcontroller.clear();
              print("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
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
                height: page == "Home" && Searchcontroller.text == ""
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
                    ? 76.123 :
                Searchcontroller.text != "" && page == "Home"
                    ? height / 3.63
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
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) =>
                                      Profileview2(Studentimg))
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
                                    onTap: () {


                                    },
                                    child: SizedBox(
                                      width: width / 1.99,
                                      height: height / 18.9,
                                      child: Text(
                                        "Hello ${Studentname}!",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: width / 15,
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
                                          Navigator.push(
                                              context, MaterialPageRoute(
                                            builder: (context) =>
                                                Notifications(),));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                right: width / 50),
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
                                            width: width / 10.1,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                    Colors.white,
                                                    width: width / 180),
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
                                    fontSize: width / 24),
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
                    page == "Attendance" || page == "Home Works" ||
                        page == "Time Table" || page == "Feedback"
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
                                        fontSize: width / 18),
                                  ),
                                  SizedBox(width: width * 2 / 368.5),
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: Colors.white,
                                    size: width / 16.363,
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
                                        fontSize: width / 18.947),
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
                          height: height / 756,
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
                        height: page == "Home" ? height / 1.474 : height /
                            1.1338,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(35),
                                topLeft: Radius.circular(35))),
                        child: page == "Home"
                            ? Padding(
                          padding: EdgeInsets.only(top: Searchcontroller.text !=
                              "" ? height / 250.12 : height / 20.12),
                          child:
                          Searchcontroller.text == "" ?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width / 45, top: height / 40.12),
                                child: Text(
                                  "Dashboard",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff0873C4),
                                      fontSize: width / 16.363,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              ExpandablePageView(
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [

                                          Padding(
                                            padding:
                                            EdgeInsets.only(top: height / 37.8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceEvenly,
                                              children: [

                                                /// Attendance
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      page = "Attendance";
                                                    });
                                                  },
                                                  child: Container(
                                                    width: width / 3.56363636,
                                                    height: height /
                                                        11.18571429,
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .calendar_month_outlined,
                                                          color: Color(
                                                              0xff609F00),
                                                          size: width / 12,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(

                                                              top: height /
                                                                  94.5,
                                                              bottom: height /
                                                                  94.5),
                                                          child: Text(
                                                            "Attendance",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: width /
                                                                    25.714,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                                    width: width / 3.56363636,
                                                    height: height /
                                                        11.18571429,
                                                    child: Column(
                                                      children: [
                                                        Icon(Icons
                                                            .note_alt_sharp,
                                                            color: Color(
                                                                0xffFECE3E),
                                                            size: width / 12),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(

                                                              top: height /
                                                                  94.5,
                                                              bottom: height /
                                                                  94.5),
                                                          child: Text(
                                                            "Assignments",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: width /
                                                                    25.714,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                                    width: width / 3.56363636,
                                                    height: height /
                                                        11.18571429,
                                                    child: Column(
                                                      children: [
                                                        Icon(Icons
                                                            .timer_outlined,
                                                            color: Color(
                                                                0xff224FFF),
                                                            size: width / 12),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(

                                                              top: height /
                                                                  94.5,
                                                              bottom: height /
                                                                  94.5),
                                                          child: Text(
                                                            "Time Table",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: width /
                                                                    25.714,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceEvenly,
                                              children: [

                                                /// Attendance
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      page = "Fees";
                                                    });
                                                  },
                                                  child: Container(
                                                    width: width / 3.56363636,
                                                    height: height /
                                                        11.18571429,
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.wallet_rounded,
                                                          color: Color(
                                                              0xffA021FF),
                                                          size: width / 12,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(

                                                              top: height /
                                                                  94.5,
                                                              bottom: height /
                                                                  94.5),
                                                          child: Text(
                                                            "Fees",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: width /
                                                                    25.714,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                                    width: width / 3.56363636,
                                                    height: height /
                                                        11.18571429,
                                                    child: Column(
                                                      children: [
                                                        Icon(Icons
                                                            .directions_bus_filled_rounded,
                                                            color: Color(
                                                                0xff224FFF),
                                                            size: width / 12),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(

                                                              top: height /
                                                                  94.5,
                                                              bottom: height /
                                                                  94.5),
                                                          child: Text(
                                                            "School Bus",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: width /
                                                                    25.714,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                                    width: width / 3.56363636,
                                                    height: height /
                                                        11.18571429,
                                                    child: Column(
                                                      children: [
                                                        Icon(Icons
                                                            .person_2_outlined,
                                                            color: Color(
                                                                0xff609F00),
                                                            size: width / 12),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(

                                                              top: height /
                                                                  94.5,
                                                              bottom: height /
                                                                  94.5),
                                                          child: Text(
                                                            "Feedback",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: width /
                                                                    25.714,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                      height: height / 2.61,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: height / 37.8),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [

                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      page =
                                                      "Request Documents";
                                                    });
                                                    print("Request Documents");
                                                  },
                                                  child: Container(
                                                    width: width / 3.56363636,
                                                    height: height / 9.0,

                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .drive_file_move_sharp,
                                                          color: Color(
                                                              0xff609F00),
                                                          size: width / 12,),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: width / 45,
                                                              right: width / 45,
                                                              top: height /
                                                                  94.5,
                                                              bottom: height /
                                                                  94.5),
                                                          child: Text(
                                                            "Request\nDocuments",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: width /
                                                                    28,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                            textAlign: TextAlign
                                                                .center,
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
                                                    width: width / 3.56363636,
                                                    height: height /
                                                        11.18571429,
                                                    child: Column(
                                                      children: [

                                                        Icon(Icons
                                                            .menu_book_sharp,
                                                            color: Color(
                                                                0xffFECE3E),
                                                            size: width / 12),

                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: width / 45,
                                                              right: width / 45,
                                                              top: height /
                                                                  94.5,
                                                              bottom: height /
                                                                  94.5),
                                                          child: Text(
                                                            "Library",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: width /
                                                                    28,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                                    width: width / 3.56363636,
                                                    height: height / 9.0,
                                                    child: Column(
                                                      children: [
                                                        Icon(Icons
                                                            .collections_bookmark,
                                                            color: Color(
                                                                0xffA021FF),
                                                            size: width / 12),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: width / 45,
                                                              right: width / 45,
                                                              top: height /
                                                                  94.5,
                                                              bottom: height /
                                                                  94.5),
                                                          child: Text(
                                                            "Progress\nReport",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color: Colors
                                                                  .black,
                                                              fontSize: width /
                                                                  28,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,


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
                                                top: height / 60.8),
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
                                                    width: width / 3.56363636,
                                                    height: height /
                                                        11.18571429,

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
                                                              top: height /
                                                                  94.5,
                                                              bottom: height /
                                                                  94.5),
                                                          child: Text(
                                                            " ",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: width /
                                                                    28,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                            textAlign: TextAlign
                                                                .center,
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
                                                    width: width / 3.56363636,
                                                    height: height /
                                                        11.18571429,

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
                                                    width: width / 3.56363636,
                                                    height: height /
                                                        11.18571429,

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
                          ) :
                          Searchcontroller.text != "" && page == "Home" ?
                          SingleChildScrollView(
                            physics: const ScrollPhysics(),
                            child: Column(
                              children: [
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: Homesearclist.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    if (Homesearclist[index]
                                        .toString()
                                        .toLowerCase()
                                        .contains(
                                        Searchcontroller.text.toLowerCase())) {
                                      return

                                        InkWell(
                                          onTap: () {
                                            if (Homesearclist[index] ==
                                                "Attendance") {
                                              setState(() {
                                                page = "Attendance";
                                                Searchcontroller.clear();
                                              });
                                            }
                                            if (Homesearclist[index] ==
                                                "Assignments") {
                                              setState(() {
                                                page = "Home Works";
                                                Searchcontroller.clear();
                                              });
                                            }
                                            if (Homesearclist[index] ==
                                                "Time Table") {
                                              setState(() {
                                                page = "Time Table";
                                                Searchcontroller.clear();
                                              });
                                              gettimetable();
                                            }
                                            if (Homesearclist[index] ==
                                                "Fees") {
                                              setState(() {
                                                page = "Fees";
                                                Searchcontroller.clear();
                                              });
                                            }
                                            if (Homesearclist[index] ==
                                                "School Bus") {
                                              setState(() {
                                                page = "School Bus";
                                                Searchcontroller.clear();
                                              });
                                            }
                                            if (Homesearclist[index] ==
                                                "Feedback") {
                                              setState(() {
                                                page = "Feedback";
                                                Searchcontroller.clear();
                                              });
                                            }
                                            if (Homesearclist[index] ==
                                                "Request Documents") {
                                              setState(() {
                                                page = "Request Documents";
                                                Searchcontroller.clear();
                                              });
                                            }
                                            if (Homesearclist[index] ==
                                                "Library") {
                                              setState(() {
                                                page = "Library";
                                                Searchcontroller.clear();
                                              });
                                            }
                                            if (Homesearclist[index] ==
                                                "Progress Reports") {
                                              setState(() {
                                                page = "Progress";
                                                Searchcontroller.clear();
                                              });
                                            }
                                            if (Homesearclist[index] ==
                                                "Groups") {
                                              setState(() {
                                                page = "Messages";
                                                Searchcontroller.clear();
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: height / 184.5,
                                                top: height / 64.5,
                                                left: width / 45,
                                                right: width / 45
                                            ),
                                            child: Material(
                                              borderRadius: BorderRadius
                                                  .circular(8),
                                              color: Color(0xffF9F9F9),
                                              elevation: 2,
                                              child: Container(
                                                height: height / 14.45,
                                                width: width / 1.028,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(8),
                                                    color: Color(0xffF9F9F9)
                                                ),

                                                child: Container(
                                                  width: width / 3.56363636,
                                                  height: height / 11.18571429,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: [
                                                      SizedBox(
                                                          width: width / 8.0),
                                                      widgetlist[index],
                                                      SizedBox(
                                                          width: width / 10.0),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(

                                                            top: height / 94.5,
                                                            bottom: height /
                                                                94.5),
                                                        child: Text(
                                                          Homesearclist[index]
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                              color: Colors
                                                                  .black,
                                                              fontSize: width /
                                                                  25.714,
                                                              fontWeight:
                                                              FontWeight.w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                    }


                                    return const SizedBox();
                                  },),
                                SizedBox(height: height / 15.12),
                              ],
                            ),
                          ) :

                          const SizedBox(),
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
                                      fontSize: width / 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: width / 1.2,
                                      child: Row(
                                        children: [
                                          Text(
                                            "${ DateFormat.yMMMd().format(
                                                DateTime.now())}",
                                            style:
                                            GoogleFonts.poppins(
                                                color: Colors.grey
                                                    .shade700,
                                                fontSize: width / 24,
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
                                                fontSize: width / 24,
                                                fontWeight:
                                                FontWeight
                                                    .w500),
                                          ),
                                        ],
                                      ),
                                    ),

                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          page = "Home";
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: width / 45),
                                        child: Icon(
                                          Icons.arrow_circle_down_sharp,
                                          size: 30,
                                          color: Color(0xff0873C4),),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: height / 36.85),


                                ///Listout the HomeWork
                                FutureBuilder<dynamic>(
                                  future: _firestore2db.collection("Students")
                                      .doc(Studentid)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(),);
                                    }
                                    if (snapshot.hasData == null) {
                                      return Center(
                                        child: CircularProgressIndicator(),);
                                    }
                                    var value = snapshot.data!.data();

                                    currentdate = "${DateTime
                                        .now()
                                        .day}${DateTime
                                        .now()
                                        .month}${DateTime
                                        .now()
                                        .year}";

                                    return Column(
                                      children: [

                                        ///selection chips
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [

                                            ///Pending Button
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  Hmselected = 1;
                                                  studentassingid = "Pending";
                                                  currentdate = "";
                                                  // currentdate="${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}";
                                                });
                                              },
                                              child: Container(
                                                  height: height / 19.6,
                                                  width: width / 3.8,
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
                                                      "Pending",
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: Hmselected ==
                                                              1
                                                              ? Colors.white
                                                              : Color(
                                                              0xff0873C4),
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          fontSize: width /
                                                              30.0),
                                                    ),
                                                  )),
                                            ),

                                            ///Completed
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  Hmselected = 2;
                                                  studentassingid = "Completed";
                                                  //currentdate="";
                                                  currentdate = "${DateTime
                                                      .now()
                                                      .day - 1}${DateTime
                                                      .now()
                                                      .month}${DateTime
                                                      .now()
                                                      .year}";
                                                });
                                              },
                                              child: Container(
                                                  height: height / 19.6,
                                                  width: width / 3.8,
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
                                                      "Completed",
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: Hmselected ==
                                                              2
                                                              ? Colors.white
                                                              : Color(
                                                              0xff0873C4),
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          fontSize: width /
                                                              30.0),
                                                    ),
                                                  )),
                                            ),

                                            ///month

                                            ///All
                                            Column(
                                              children: [
                                                InkWell(

                                                  onTap: () async {
                                                    setState(() {
                                                      Hmselected = 4;
                                                      studentassingid = "All";
                                                      currentdate = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      height: height / 19.6,
                                                      width: width / 3.8,
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
                                                          "All",
                                                          style: GoogleFonts
                                                              .poppins(
                                                              color: Hmselected ==
                                                                  4
                                                                  ? Colors.white
                                                                  : Color(
                                                                  0xff0873C4),
                                                              fontWeight:
                                                              FontWeight
                                                                  .w700,
                                                              fontSize: width /
                                                                  30.0),
                                                        ),
                                                      )),
                                                ),

                                                // ///date picker container
                                                // InkWell(
                                                //   onTap: () async {
                                                //     setState(() {
                                                //       Hmselected = 5;
                                                //     });
                                                //     DateTime? pickedDate = await showDatePicker(
                                                //         context: context,
                                                //         initialDate: DateTime.now(),
                                                //         firstDate: DateTime(2000),
                                                //         //DateTime.now() - not to allow to choose before today.
                                                //         lastDate: DateTime(2101)
                                                //     );
                                                //
                                                //     if (pickedDate != null) {
                                                //       print(
                                                //           pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                                //       String formattedDate = DateFormat('dMyyyy').format(
                                                //           pickedDate);
                                                //       print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                                //       //you can implement different kind of Date Format here according to your requirement
                                                //
                                                //       setState(() {
                                                //         currentdate=formattedDate;
                                                //
                                                //         //set output date to TextField value.
                                                //       });
                                                //     } else {
                                                //       print("Date is not selected");
                                                //     }
                                                //   },
                                                //   child: Container(
                                                //
                                                //       height: height/21.6,
                                                //       width: width/4.2,
                                                //
                                                //
                                                //       child:
                                                //       Row(
                                                //
                                                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                //         children: [
                                                //           Icon(Icons.calendar_month,color:Color(0xff0873C4)
                                                //             ,),
                                                //           Container(
                                                //
                                                //             width:61,
                                                //             child: Text(
                                                //               currentdate==""?"Sort by Date":"Clear",
                                                //               style: GoogleFonts.poppins(
                                                //                   color: Color(0xff0873C4),
                                                //                   fontWeight:
                                                //                   FontWeight
                                                //                       .w700,
                                                //                   fontSize: width/45.0),
                                                //             ),
                                                //           ),
                                                //         ],
                                                //       )
                                                //   ),
                                                // ),
                                              ],
                                            ),


                                          ],
                                        ),

                                        SizedBox(height: height / 36.85),

                                        StreamBuilder(
                                          stream: _firestore2db.collection(
                                              "homeworks").doc(
                                              currentdate.toString()).
                                          collection(
                                              value['admitclass'].toString())
                                              .doc(value['section'].toString()).
                                          collection("class HomeWorks").orderBy(
                                              "timestamp", descending: true)
                                              .snapshots(),
                                          builder: (context, snapshot2) {
                                            if (snapshot2.hasData == null) {
                                              return Center(
                                                child: CircularProgressIndicator(),);
                                            }
                                            if (!snapshot2.hasData) {
                                              return Center(
                                                child: CircularProgressIndicator(),);
                                            }
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: snapshot2.data!.docs
                                                  .length,
                                              itemBuilder: (context, index) {
                                                var subjecthomework = snapshot2
                                                    .data!.docs[index];

                                                if(Searchcontroller.text=="") {
                                                  if (studentassingid ==
                                                      "All") {
                                                    return
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            vertical: height /
                                                                94.5),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                              border: Border
                                                                  .all(
                                                                  color: Color(
                                                                      0xff999999))),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [

                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [

                                                                      SizedBox(
                                                                          height: height /
                                                                              75.6),

                                                                      ///subject Title
                                                                      Padding(
                                                                        padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                            left: width /
                                                                                24),
                                                                        child: SizedBox(
                                                                          width: width /
                                                                              1.636,
                                                                          child: Text(
                                                                            "${subjecthomework['subject']} - ${subjecthomework['statffname']}",
                                                                            style: GoogleFonts
                                                                                .poppins(
                                                                                color: Colors
                                                                                    .black,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                                fontSize: width /
                                                                                    22.5),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      ///subject Description
                                                                      Padding(
                                                                        padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                            left: width /
                                                                                24),
                                                                        child: SizedBox(
                                                                          height: height /
                                                                              21.6,
                                                                          width: width /
                                                                              1.636,
                                                                          child: Row(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .center,
                                                                            children: [
                                                                              Container(
                                                                                width: width /
                                                                                    1.636,
                                                                                child: Text(
                                                                                  subjecthomework['topic'],
                                                                                  textAlign:
                                                                                  TextAlign
                                                                                      .left,
                                                                                  style:
                                                                                  GoogleFonts
                                                                                      .poppins(
                                                                                      color: Colors
                                                                                          .black,
                                                                                      fontSize: width /
                                                                                          30),
                                                                                  overflow: TextOverflow
                                                                                      .ellipsis,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      ///Subject assign date and time

                                                                    ],
                                                                  ),

                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right: width /
                                                                            45),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .spaceEvenly,
                                                                      children: [

                                                                        subjecthomework['submited']
                                                                            .contains(
                                                                            value['regno'])
                                                                            ?

                                                                        InkWell(
                                                                          onTap: () {
                                                                            Navigator
                                                                                .of(
                                                                                context)
                                                                                .push(
                                                                                MaterialPageRoute(
                                                                                    builder: (
                                                                                        context) =>
                                                                                        AssigmentsST(
                                                                                            subjecthomework
                                                                                                .id,
                                                                                            Studentclass,
                                                                                            Studentsec,
                                                                                            Studentname,
                                                                                            Studentregno,
                                                                                            currentdate
                                                                                                .toString(),
                                                                                            "Completed"))
                                                                            );
                                                                          },
                                                                          child: Container(
                                                                              height: height /
                                                                                  21,
                                                                              width: width /
                                                                                  3.8,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors
                                                                                    .green,
                                                                                border: Border
                                                                                    .all(
                                                                                  color: Colors
                                                                                      .green,
                                                                                ),
                                                                                borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                    10),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Completed",
                                                                                  style: GoogleFonts
                                                                                      .poppins(
                                                                                      color: Colors
                                                                                          .white,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w700,
                                                                                      fontSize: width /
                                                                                          27.69),
                                                                                ),
                                                                              )),
                                                                        )
                                                                            : InkWell(
                                                                          onTap: () {
                                                                            Navigator
                                                                                .of(
                                                                                context)
                                                                                .push(
                                                                                MaterialPageRoute(
                                                                                    builder: (
                                                                                        context) =>
                                                                                        AssigmentsST(
                                                                                            subjecthomework
                                                                                                .id,
                                                                                            Studentclass,
                                                                                            Studentsec,
                                                                                            Studentname,
                                                                                            Studentregno,
                                                                                            currentdate
                                                                                                .toString(),
                                                                                            "View"))
                                                                            );
                                                                          },
                                                                          child: Container(
                                                                              height: height /
                                                                                  21,
                                                                              width: width /
                                                                                  4,
                                                                              decoration: BoxDecoration(
                                                                                color: Color(
                                                                                    0xff0873C4),
                                                                                border: Border
                                                                                    .all(
                                                                                  color: Color(
                                                                                      0xff0873C4),
                                                                                ),
                                                                                borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                    10),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "View",
                                                                                  style: GoogleFonts
                                                                                      .poppins(
                                                                                      color: Colors
                                                                                          .white,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w700,
                                                                                      fontSize: width /
                                                                                          27.69),
                                                                                ),
                                                                              )),
                                                                        ),


                                                                        // SizedBox(height: height/50.4),
                                                                        //
                                                                        // InkWell(
                                                                        //   onTap: (){
                                                                        //     Navigator.of(context).push(
                                                                        //         MaterialPageRoute(builder: (context)=>AssigmentsST(subjecthomework.id,Studentclass,Studentsec,Studentname,Studentregno,currentdate.toString()))
                                                                        //     );
                                                                        //
                                                                        //   },
                                                                        //   child: Container(
                                                                        //       height: height/21,
                                                                        //       width: width/4,
                                                                        //       decoration: BoxDecoration(
                                                                        //         color:  Colors.green,
                                                                        //         border: Border.all(
                                                                        //           color:  Colors.green,
                                                                        //         ),
                                                                        //         borderRadius:
                                                                        //         BorderRadius
                                                                        //             .circular(10),
                                                                        //       ),
                                                                        //       child: Center(
                                                                        //         child: Text(
                                                                        //           "Completed",
                                                                        //           style: GoogleFonts.poppins(
                                                                        //               color: Colors.white,
                                                                        //               fontWeight:
                                                                        //               FontWeight
                                                                        //                   .w700,
                                                                        //               fontSize: width/27.69),
                                                                        //         ),
                                                                        //       )),
                                                                        // ),


                                                                      ],
                                                                    ),
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
                                                                    SizedBox(
                                                                        width: width /
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
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                  }

                                                  if (studentassingid ==
                                                      "Completed" &&
                                                      subjecthomework['submited']
                                                          .contains(
                                                          value['regno'])) {
                                                    return
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            vertical: height /
                                                                94.5),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                              border: Border
                                                                  .all(
                                                                  color: Color(
                                                                      0xff999999))),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [

                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [

                                                                      SizedBox(
                                                                          height: height /
                                                                              75.6),

                                                                      ///subject Title
                                                                      Padding(
                                                                        padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                            left: width /
                                                                                24),
                                                                        child: SizedBox(
                                                                          width: width /
                                                                              1.636,
                                                                          child: Text(
                                                                            "${subjecthomework['subject']} - ${subjecthomework['statffname']}",
                                                                            style: GoogleFonts
                                                                                .poppins(
                                                                                color: Colors
                                                                                    .black,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                                fontSize: width /
                                                                                    22.5),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      ///subject Description
                                                                      Padding(
                                                                        padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                            left: width /
                                                                                24),
                                                                        child: SizedBox(
                                                                          height: height /
                                                                              21.6,
                                                                          width: width /
                                                                              1.636,
                                                                          child: Row(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .center,
                                                                            children: [
                                                                              Container(
                                                                                width: width /
                                                                                    1.636,
                                                                                child: Text(
                                                                                  subjecthomework['des'],
                                                                                  textAlign:
                                                                                  TextAlign
                                                                                      .left,
                                                                                  style:
                                                                                  GoogleFonts
                                                                                      .poppins(
                                                                                      color: Colors
                                                                                          .black,
                                                                                      fontSize: width /
                                                                                          30),
                                                                                  overflow: TextOverflow
                                                                                      .ellipsis,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      ///Subject assign date and time

                                                                    ],
                                                                  ),

                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right: width /
                                                                            45),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .spaceEvenly,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () {
                                                                            Navigator
                                                                                .of(
                                                                                context)
                                                                                .push(
                                                                                MaterialPageRoute(
                                                                                    builder: (
                                                                                        context) =>
                                                                                        AssigmentsST(
                                                                                            subjecthomework
                                                                                                .id,
                                                                                            Studentclass,
                                                                                            Studentsec,
                                                                                            Studentname,
                                                                                            Studentregno,
                                                                                            currentdate
                                                                                                .toString(),
                                                                                            "Completed"))
                                                                            );
                                                                          },
                                                                          child: Container(
                                                                              height: height /
                                                                                  21,
                                                                              width: width /
                                                                                  3.8,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors
                                                                                    .green,
                                                                                border: Border
                                                                                    .all(
                                                                                  color: Colors
                                                                                      .green,
                                                                                ),
                                                                                borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                    10),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Completed",
                                                                                  style: GoogleFonts
                                                                                      .poppins(
                                                                                      color: Colors
                                                                                          .white,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w700,
                                                                                      fontSize: width /
                                                                                          27.69),
                                                                                ),
                                                                              )),
                                                                        ),
                                                                        // SizedBox(height: height/50.4),
                                                                        //
                                                                        // InkWell(
                                                                        //   onTap: (){
                                                                        //     Navigator.of(context).push(
                                                                        //         MaterialPageRoute(builder: (context)=>AssigmentsST(subjecthomework.id,Studentclass,Studentsec,Studentname,Studentregno,currentdate.toString()))
                                                                        //     );
                                                                        //
                                                                        //   },
                                                                        //   child: Container(
                                                                        //       height: height/21,
                                                                        //       width: width/4,
                                                                        //       decoration: BoxDecoration(
                                                                        //         color:  Colors.green,
                                                                        //         border: Border.all(
                                                                        //           color:  Colors.green,
                                                                        //         ),
                                                                        //         borderRadius:
                                                                        //         BorderRadius
                                                                        //             .circular(10),
                                                                        //       ),
                                                                        //       child: Center(
                                                                        //         child: Text(
                                                                        //           "Completed",
                                                                        //           style: GoogleFonts.poppins(
                                                                        //               color: Colors.white,
                                                                        //               fontWeight:
                                                                        //               FontWeight
                                                                        //                   .w700,
                                                                        //               fontSize: width/27.69),
                                                                        //         ),
                                                                        //       )),
                                                                        // ),


                                                                      ],
                                                                    ),
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
                                                                    SizedBox(
                                                                        width: width /
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
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                  }

                                                  if (studentassingid ==
                                                      "Pending" &&
                                                      !subjecthomework['submited']
                                                          .contains(
                                                          value['regno'])) {
                                                    return
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            vertical: height /
                                                                94.5),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                              border: Border
                                                                  .all(
                                                                  color: Color(
                                                                      0xff999999))),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [

                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [

                                                                      SizedBox(
                                                                          height: height /
                                                                              75.6),

                                                                      ///subject Title
                                                                      Padding(
                                                                        padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                            left: width /
                                                                                24),
                                                                        child: SizedBox(
                                                                          width: width /
                                                                              1.636,
                                                                          child: Text(
                                                                            "${subjecthomework['subject']} - ${subjecthomework['statffname']}",
                                                                            style: GoogleFonts
                                                                                .poppins(
                                                                                color: Colors
                                                                                    .black,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                                fontSize: width /
                                                                                    22.5),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      ///subject Description
                                                                      Padding(
                                                                        padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                            left: width /
                                                                                24),
                                                                        child: SizedBox(
                                                                          height: height /
                                                                              21.6,
                                                                          width: width /
                                                                              1.636,
                                                                          child: Row(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .center,
                                                                            children: [
                                                                              Container(
                                                                                width: width /
                                                                                    1.636,
                                                                                child: Text(
                                                                                  subjecthomework['des'],
                                                                                  textAlign:
                                                                                  TextAlign
                                                                                      .left,
                                                                                  style:
                                                                                  GoogleFonts
                                                                                      .poppins(
                                                                                      color: Colors
                                                                                          .black,
                                                                                      fontSize: width /
                                                                                          30),
                                                                                  overflow: TextOverflow
                                                                                      .ellipsis,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      ///Subject assign date and time

                                                                    ],
                                                                  ),

                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right: width /
                                                                            45),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .spaceEvenly,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () {
                                                                            Navigator
                                                                                .of(
                                                                                context)
                                                                                .push(
                                                                                MaterialPageRoute(
                                                                                    builder: (
                                                                                        context) =>
                                                                                        AssigmentsST(
                                                                                            subjecthomework
                                                                                                .id,
                                                                                            Studentclass,
                                                                                            Studentsec,
                                                                                            Studentname,
                                                                                            Studentregno,
                                                                                            currentdate
                                                                                                .toString(),
                                                                                            "View"))
                                                                            );
                                                                          },
                                                                          child: Container(
                                                                              height: height /
                                                                                  21,
                                                                              width: width /
                                                                                  4,
                                                                              decoration: BoxDecoration(
                                                                                color: Color(
                                                                                    0xff0873C4),
                                                                                border: Border
                                                                                    .all(
                                                                                  color: Color(
                                                                                      0xff0873C4),
                                                                                ),
                                                                                borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                    10),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "View",
                                                                                  style: GoogleFonts
                                                                                      .poppins(
                                                                                      color: Colors
                                                                                          .white,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w700,
                                                                                      fontSize: width /
                                                                                          27.69),
                                                                                ),
                                                                              )),
                                                                        ),
                                                                        // SizedBox(height: height/50.4),
                                                                        //
                                                                        // InkWell(
                                                                        //   onTap: (){
                                                                        //     Navigator.of(context).push(
                                                                        //         MaterialPageRoute(builder: (context)=>AssigmentsST(subjecthomework.id,Studentclass,Studentsec,Studentname,Studentregno,currentdate.toString()))
                                                                        //     );
                                                                        //
                                                                        //   },
                                                                        //   child: Container(
                                                                        //       height: height/21,
                                                                        //       width: width/4,
                                                                        //       decoration: BoxDecoration(
                                                                        //         color:  Colors.green,
                                                                        //         border: Border.all(
                                                                        //           color:  Colors.green,
                                                                        //         ),
                                                                        //         borderRadius:
                                                                        //         BorderRadius
                                                                        //             .circular(10),
                                                                        //       ),
                                                                        //       child: Center(
                                                                        //         child: Text(
                                                                        //           "Completed",
                                                                        //           style: GoogleFonts.poppins(
                                                                        //               color: Colors.white,
                                                                        //               fontWeight:
                                                                        //               FontWeight
                                                                        //                   .w700,
                                                                        //               fontSize: width/27.69),
                                                                        //         ),
                                                                        //       )),
                                                                        // ),


                                                                      ],
                                                                    ),
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
                                                                    SizedBox(
                                                                        width: width /
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
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                  }

                                                  return SizedBox();
                                                }


                                                else {

                                                  if (subjecthomework['subject'].toString().toLowerCase().contains(Searchcontroller.text.toLowerCase()) ||
                                                      subjecthomework['statffname'].toString().toLowerCase().contains(Searchcontroller.text.toLowerCase()) ||
                                                      subjecthomework['topic'].toString().toLowerCase().contains(Searchcontroller.text.toLowerCase())) {
                                                    return
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            vertical: height /
                                                                94.5),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                              border: Border
                                                                  .all(
                                                                  color: Color(
                                                                      0xff999999))),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [

                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [

                                                                      SizedBox(
                                                                          height: height /
                                                                              75.6),

                                                                      ///subject Title
                                                                      Padding(
                                                                        padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                            left: width /
                                                                                24),
                                                                        child: SizedBox(
                                                                          width: width /
                                                                              1.636,
                                                                          child: Text(
                                                                            "${subjecthomework['subject']} - ${subjecthomework['statffname']}",
                                                                            style: GoogleFonts
                                                                                .poppins(
                                                                                color: Colors
                                                                                    .black,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                                fontSize: width /
                                                                                    22.5),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      ///subject Description
                                                                      Padding(
                                                                        padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                            left: width /
                                                                                24),
                                                                        child: SizedBox(
                                                                          height: height /
                                                                              21.6,
                                                                          width: width /
                                                                              1.636,
                                                                          child: Row(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .center,
                                                                            children: [
                                                                              Container(
                                                                                width: width /
                                                                                    1.636,
                                                                                child: Text(
                                                                                  subjecthomework['topic'],
                                                                                  textAlign:
                                                                                  TextAlign
                                                                                      .left,
                                                                                  style:
                                                                                  GoogleFonts
                                                                                      .poppins(
                                                                                      color: Colors
                                                                                          .black,
                                                                                      fontSize: width /
                                                                                          30),
                                                                                  overflow: TextOverflow
                                                                                      .ellipsis,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      ///Subject assign date and time

                                                                    ],
                                                                  ),

                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right: width /
                                                                            45),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .spaceEvenly,
                                                                      children: [

                                                                        subjecthomework['submited']
                                                                            .contains(
                                                                            value['regno'])
                                                                            ?

                                                                        InkWell(
                                                                          onTap: () {
                                                                            Navigator
                                                                                .of(
                                                                                context)
                                                                                .push(
                                                                                MaterialPageRoute(
                                                                                    builder: (
                                                                                        context) =>
                                                                                        AssigmentsST(
                                                                                            subjecthomework
                                                                                                .id,
                                                                                            Studentclass,
                                                                                            Studentsec,
                                                                                            Studentname,
                                                                                            Studentregno,
                                                                                            currentdate
                                                                                                .toString(),
                                                                                            "Completed"))
                                                                            );
                                                                          },
                                                                          child: Container(
                                                                              height: height /
                                                                                  21,
                                                                              width: width /
                                                                                  3.8,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors
                                                                                    .green,
                                                                                border: Border
                                                                                    .all(
                                                                                  color: Colors
                                                                                      .green,
                                                                                ),
                                                                                borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                    10),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Completed",
                                                                                  style: GoogleFonts
                                                                                      .poppins(
                                                                                      color: Colors
                                                                                          .white,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w700,
                                                                                      fontSize: width /
                                                                                          27.69),
                                                                                ),
                                                                              )),
                                                                        )
                                                                            : InkWell(
                                                                          onTap: () {
                                                                            Navigator
                                                                                .of(
                                                                                context)
                                                                                .push(
                                                                                MaterialPageRoute(
                                                                                    builder: (
                                                                                        context) =>
                                                                                        AssigmentsST(
                                                                                            subjecthomework
                                                                                                .id,
                                                                                            Studentclass,
                                                                                            Studentsec,
                                                                                            Studentname,
                                                                                            Studentregno,
                                                                                            currentdate
                                                                                                .toString(),
                                                                                            "View"))
                                                                            );
                                                                          },
                                                                          child: Container(
                                                                              height: height /
                                                                                  21,
                                                                              width: width /
                                                                                  4,
                                                                              decoration: BoxDecoration(
                                                                                color: Color(
                                                                                    0xff0873C4),
                                                                                border: Border
                                                                                    .all(
                                                                                  color: Color(
                                                                                      0xff0873C4),
                                                                                ),
                                                                                borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                    10),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "View",
                                                                                  style: GoogleFonts
                                                                                      .poppins(
                                                                                      color: Colors
                                                                                          .white,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w700,
                                                                                      fontSize: width /
                                                                                          27.69),
                                                                                ),
                                                                              )),
                                                                        ),


                                                                        // SizedBox(height: height/50.4),
                                                                        //
                                                                        // InkWell(
                                                                        //   onTap: (){
                                                                        //     Navigator.of(context).push(
                                                                        //         MaterialPageRoute(builder: (context)=>AssigmentsST(subjecthomework.id,Studentclass,Studentsec,Studentname,Studentregno,currentdate.toString()))
                                                                        //     );
                                                                        //
                                                                        //   },
                                                                        //   child: Container(
                                                                        //       height: height/21,
                                                                        //       width: width/4,
                                                                        //       decoration: BoxDecoration(
                                                                        //         color:  Colors.green,
                                                                        //         border: Border.all(
                                                                        //           color:  Colors.green,
                                                                        //         ),
                                                                        //         borderRadius:
                                                                        //         BorderRadius
                                                                        //             .circular(10),
                                                                        //       ),
                                                                        //       child: Center(
                                                                        //         child: Text(
                                                                        //           "Completed",
                                                                        //           style: GoogleFonts.poppins(
                                                                        //               color: Colors.white,
                                                                        //               fontWeight:
                                                                        //               FontWeight
                                                                        //                   .w700,
                                                                        //               fontSize: width/27.69),
                                                                        //         ),
                                                                        //       )),
                                                                        // ),


                                                                      ],
                                                                    ),
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
                                                                    SizedBox(
                                                                        width: width /
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
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                  }
                                                  else{
                                                    return SizedBox();
                                                  }
                                                }

                                              },);
                                          },),
                                      ],
                                    );
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
                                          fontSize: width / 20,
                                          fontWeight:
                                          FontWeight.w600),
                                    ),

                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width / 1.276,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${DateFormat.yMMMd().format(
                                                    DateTime.now())}",
                                                style:
                                                GoogleFonts.poppins(
                                                    color: Colors.grey
                                                        .shade700,
                                                    fontSize: width / 24,
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
                                                    fontSize: width / 24,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              ),
                                            ],
                                          ),
                                        ),

                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              page = "Home";
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: width / 45),
                                            child: Icon(
                                              Icons.arrow_circle_down_sharp,
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
                                      child: StudentAttendance_Page(
                                          Studentid),),

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
                                            fontSize: width / 20,
                                            fontWeight:
                                            FontWeight
                                                .w600),
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width / 1.2,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${DateFormat.yMMMd().format(
                                                    DateTime.now())}",
                                                style:
                                                GoogleFonts.poppins(
                                                    color: Colors.grey
                                                        .shade700,
                                                    fontSize: width / 24,
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
                                                    fontSize: width / 24,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              ),
                                            ],
                                          ),
                                        ),

                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              page = "Home";
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: width / 45),
                                            child: Icon(
                                              Icons.arrow_circle_down_sharp,
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
                                        width: width / 0.4285,
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
                                                  height: height / 18.9,
                                                  width: width / 3.428,
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
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: TTselected ==
                                                              1
                                                              ? Colors
                                                              .white
                                                              : Color(
                                                              0xff0873C4),
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          fontSize: width /
                                                              22.5),
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
                                                  height: height / 18.9,
                                                  width: width / 3.428,
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
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: TTselected ==
                                                              2
                                                              ? Colors
                                                              .white
                                                              : Color(
                                                              0xff0873C4),
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          fontSize: width /
                                                              22.5),
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
                                                  height: height / 18.9,
                                                  width: width / 3.428,
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
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: TTselected ==
                                                              3
                                                              ? Colors
                                                              .white
                                                              : Color(
                                                              0xff0873C4),
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          fontSize: width /
                                                              22.5),
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
                                                  height: height / 18.9,
                                                  width: width / 3.428,
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
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: TTselected ==
                                                              4
                                                              ? Colors
                                                              .white
                                                              : Color(
                                                              0xff0873C4),
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          fontSize: width /
                                                              22.5),
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
                                                  height: height / 18.9,
                                                  width: width / 3.428,
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
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: TTselected ==
                                                              5
                                                              ? Colors
                                                              .white
                                                              : Color(
                                                              0xff0873C4),
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          fontSize: width /
                                                              22.5),
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
                                                  height: height / 18.9,
                                                  width: width / 3.428,
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
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: TTselected ==
                                                              6
                                                              ? Colors
                                                              .white
                                                              : Color(
                                                              0xff0873C4),
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          fontSize: width /
                                                              22.5),
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
                                                  height: height / 18.9,
                                                  width: width / 3.428,
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
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: TTselected ==
                                                              7
                                                              ? Colors
                                                              .white
                                                              : Color(
                                                              0xff0873C4),
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          fontSize: width /
                                                              22.5),
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
                                      height: height / 1.0425,
                                      width: width / 1,
                                      decoration: BoxDecoration(
                                          color: Color(0xff0873C4),
                                          borderRadius: BorderRadius.circular(
                                              12)),
                                      child: ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: teachertable.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  top: height / 94.5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Stack(
                                                      children: [
                                                        Container(
                                                          height: height /
                                                              10.425,
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
                                                                    4.0,
                                                                top: height /
                                                                    150),
                                                            child: Text(
                                                              teachertable[index],
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                  color: Color(
                                                                      0xff0873C4),
                                                                  fontSize: width /
                                                                      19.6,
                                                                  fontWeight: FontWeight
                                                                      .w600),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height:
                                                          height / 10.425,
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
                                                              child: Text(
                                                                "${(index + 1)
                                                                    .toString()} Hr",
                                                                style: GoogleFonts
                                                                    .poppins(
                                                                    color: Color(
                                                                        0xff0873C4),
                                                                    fontSize: width /
                                                                        19.6,
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
                              child: SingleChildScrollView(
                                physics: const ScrollPhysics(),
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
                                          fontSize: width / 20,
                                          fontWeight:
                                          FontWeight
                                              .w600),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end,
                                      children: [
                                        SizedBox(
                                          width: width / 1.286,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${ DateFormat.yMMMd().format(
                                                    DateTime.now())}",
                                                style:
                                                GoogleFonts.poppins(
                                                    color: Colors.grey
                                                        .shade700,
                                                    fontSize: width / 24,
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
                                                    fontSize: width / 24,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              ),
                                            ],
                                          ),
                                        ),

                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              page = "Home";
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: width / 45),
                                            child: Icon(
                                              Icons.arrow_circle_down_sharp,
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
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Container(
                                          width: width / 1.3,
                                          child: Divider(
                                              color: Colors.grey
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
                                            width: width /
                                                2.6,
                                            child: Text(
                                              "Remarks - Staff",
                                              style: GoogleFonts.poppins(
                                                  color: Colors
                                                      .black,
                                                  fontSize:
                                                  width / 24,
                                                  fontWeight:
                                                  FontWeight
                                                      .w600),
                                            ),
                                          ),
                                          SizedBox(width: width / 36.0,),

                                          SizedBox(width: width / 6,),
                                          Text(
                                            "Value",
                                            style: GoogleFonts.poppins(
                                              color: Colors
                                                  .black,
                                              fontSize:
                                              width / 24,
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
                                        stream: _firestore2db.collection(
                                            "Students").doc(Studentid)
                                            .collection("Feedback")
                                            .orderBy(
                                            "timestamp", descending: true)
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
                                                if (page == "Feedback" &&
                                                    Searchcontroller.text !=
                                                        "") {
                                                  if (snapshot.data!
                                                      .docs[index]["remarks"]
                                                      .toString().toLowerCase()
                                                      .contains(
                                                      Searchcontroller.text
                                                          .toLowerCase()) ||
                                                      snapshot.data!
                                                          .docs[index]["staffname"]
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(
                                                          Searchcontroller.text
                                                              .toLowerCase()) ||
                                                      snapshot.data!
                                                          .docs[index]["date"]
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(
                                                          Searchcontroller.text
                                                              .toLowerCase())
                                                  ) {
                                                    return
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .black))
                                                        ),
                                                        child: ListTile(
                                                          onTap: () {
                                                            ///show the descriptiuon ppoup
                                                            feedbackdescriptionpopup(
                                                                snapshot.data!
                                                                    .docs[index]["staffname"],
                                                                snapshot.data!
                                                                    .docs[index]["remarks"]
                                                            );
                                                          },
                                                          title: SizedBox(
                                                            height: height /
                                                                37.8,
                                                            width: width /
                                                                2.6,

                                                            child: Text(
                                                              "${snapshot.data!
                                                                  .docs[index]["remarks"]}",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                  width / 24,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                            ),
                                                          ),
                                                          subtitle: Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Container(
                                                                height: height /
                                                                    50.4,
                                                                width: width /
                                                                    2.0,

                                                                child: Text(
                                                                  "By: ${snapshot
                                                                      .data!
                                                                      .docs[index]["staffname"]}",
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                      color: Colors
                                                                          .black54,
                                                                      textStyle: TextStyle(
                                                                          overflow: TextOverflow
                                                                              .ellipsis),
                                                                      fontSize:
                                                                      width /
                                                                          36.0,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(

                                                                    height: height /
                                                                        50.4,
                                                                    width: width /
                                                                        6.0,
                                                                    child: Text(
                                                                      "${snapshot
                                                                          .data!
                                                                          .docs[index]["date"]}",
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                          color: Colors
                                                                              .black54,
                                                                          textStyle: TextStyle(
                                                                              overflow: TextOverflow
                                                                                  .ellipsis),
                                                                          fontSize:
                                                                          width /
                                                                              36.0,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                    ),
                                                                  ),
                                                                  SizedBox(

                                                                    height: height /
                                                                        50.4,
                                                                    width: width /
                                                                        4.9,

                                                                    child: Text(
                                                                      "- ${snapshot
                                                                          .data!
                                                                          .docs[index]["time"]}",
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                          color: Colors
                                                                              .black54,
                                                                          fontSize:
                                                                          width /
                                                                              36.0,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          trailing: Container(
                                                            height: height /
                                                                29.48,
                                                            width:
                                                            width / 3.4,

                                                            decoration: BoxDecoration(
                                                                color: snapshot
                                                                    .data!
                                                                    .docs[index]["value"]
                                                                    == "Good"
                                                                    ? Colors
                                                                    .yellow
                                                                    : snapshot
                                                                    .data!
                                                                    .docs[index]["value"] ==
                                                                    "Outstanding"
                                                                    ? Color(
                                                                    0xff00A99D)
                                                                    :
                                                                snapshot.data!
                                                                    .docs[index]["value"] ==
                                                                    "Excellent"
                                                                    ? Colors
                                                                    .green
                                                                    :
                                                                snapshot.data!
                                                                    .docs[index]["value"] ==
                                                                    "Satisfactory"
                                                                    ? Colors
                                                                    .orange
                                                                    :
                                                                snapshot.data!
                                                                    .docs[index]["value"] ==
                                                                    "Focus Needed"
                                                                    ? Colors.red
                                                                    : Colors
                                                                    .orange,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    5)),
                                                            child: Center(
                                                              child: Text(
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]["value"],
                                                                style: GoogleFonts
                                                                    .poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                    width /
                                                                        37.0,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                  }
                                                }

                                                if (page == "Feedback" &&
                                                    Searchcontroller.text ==
                                                        "") {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black))
                                                    ),
                                                    child: ListTile(
                                                      onTap: () {
                                                        ///show the descriptiuon ppoup
                                                        feedbackdescriptionpopup(
                                                            snapshot.data!
                                                                .docs[index]["staffname"],
                                                            snapshot.data!
                                                                .docs[index]["remarks"]
                                                        );
                                                      },
                                                      title: SizedBox(
                                                        height: height / 37.8,
                                                        width: width /
                                                            2.6,

                                                        child: Text(
                                                          "${snapshot.data!
                                                              .docs[index]["remarks"]}",
                                                          style: GoogleFonts
                                                              .poppins(
                                                              color: Colors
                                                                  .black,
                                                              fontSize:
                                                              width / 24,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                        ),
                                                      ),
                                                      subtitle: Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Container(
                                                            height: height /
                                                                50.4,
                                                            width: width / 2.0,

                                                            child: Text(
                                                              "By: ${snapshot
                                                                  .data!
                                                                  .docs[index]["staffname"]}",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                  color: Colors
                                                                      .black54,
                                                                  textStyle: TextStyle(
                                                                      overflow: TextOverflow
                                                                          .ellipsis),
                                                                  fontSize:
                                                                  width / 36.0,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              SizedBox(

                                                                height: height /
                                                                    50.4,
                                                                width: width /
                                                                    6.0,
                                                                child: Text(
                                                                  "${snapshot
                                                                      .data!
                                                                      .docs[index]["date"]}",
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                      color: Colors
                                                                          .black54,
                                                                      textStyle: TextStyle(
                                                                          overflow: TextOverflow
                                                                              .ellipsis),
                                                                      fontSize:
                                                                      width /
                                                                          36.0,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                                ),
                                                              ),
                                                              SizedBox(

                                                                height: height /
                                                                    50.4,
                                                                width: width /
                                                                    4.9,

                                                                child: Text(
                                                                  "- ${snapshot
                                                                      .data!
                                                                      .docs[index]["time"]}",
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                      width /
                                                                          36.0,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),

                                                      trailing: Container(
                                                        height: height /
                                                            29.48,
                                                        width:
                                                        width / 3.4,

                                                        decoration: BoxDecoration(
                                                            color: snapshot
                                                                .data!
                                                                .docs[index]["value"]
                                                                == "Good"
                                                                ? Colors.yellow
                                                                : snapshot.data!
                                                                .docs[index]["value"] ==
                                                                "Outstanding"
                                                                ? Color(
                                                                0xff00A99D)
                                                                :
                                                            snapshot.data!
                                                                .docs[index]["value"] ==
                                                                "Excellent"
                                                                ? Colors.green
                                                                :
                                                            snapshot.data!
                                                                .docs[index]["value"] ==
                                                                "Satisfactory"
                                                                ? Colors.orange
                                                                :
                                                            snapshot.data!
                                                                .docs[index]["value"] ==
                                                                "Focus Needed"
                                                                ? Colors.red
                                                                : Colors.orange,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                5)),
                                                        child: Center(
                                                          child: Text(
                                                            snapshot
                                                                .data!
                                                                .docs[index]["value"],
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                width / 37.0,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }

                                                return const SizedBox();
                                              }
                                          );
                                        }
                                    ),
                                    SizedBox(height: height / 10.12),


                                  ],
                                ),
                              ),
                            ),
                          ),
                        ) :
                           page == "Fees" ? Padding(
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
                              child: SingleChildScrollView(
                                physics: const ScrollPhysics(),
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
                                          fontSize: width / 20,
                                          fontWeight:
                                          FontWeight
                                              .w600),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end,
                                      children: [
                                        SizedBox(
                                          width: width / 1.286,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${ DateFormat.yMMMd().format(
                                                    DateTime.now())}",
                                                style:
                                                GoogleFonts.poppins(
                                                    color: Colors.grey
                                                        .shade700,
                                                    fontSize: width / 24,
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
                                                    fontSize: width / 24,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              ),
                                            ],
                                          ),
                                        ),

                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              page = "Home";
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: width / 45),
                                            child: Icon(
                                              Icons.arrow_circle_down_sharp,
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
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Container(
                                          width: width / 1.3,
                                          child: Divider(
                                              color: Colors.grey
                                                  .shade700
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height / 92.125,),
                                    //
                                    // StreamBuilder(
                                    //     stream: _firestore2db.collection("FeesMaster").orderBy("order",descending:false).snapshots(),
                                    //     builder: (context,snap){
                                    //       if(snap.hasData==null){
                                    //         return Center(
                                    //           child: CircularProgressIndicator(),
                                    //         );
                                    //       }
                                    //       if(!snap.hasData){
                                    //         return Center(
                                    //           child: CircularProgressIndicator(),
                                    //         );
                                    //       }
                                    //       return
                                    //         ListView.builder(
                                    //           shrinkWrap: true,
                                    //           physics: NeverScrollableScrollPhysics(),
                                    //           itemCount: snap.data!.docs.length,
                                    //           itemBuilder: (context,index){
                                    //
                                    //             return
                                    //
                                    //               StreamBuilder(
                                    //                   stream: _firestore2db.collection("Students").doc(Studentid).
                                    //                   collection("Fees").where("status",isEqualTo: false).snapshots(),
                                    //                   builder: (context,snap2){
                                    //                     if(snap2.hasData==null){
                                    //                       return Center(
                                    //                         child: CircularProgressIndicator(),
                                    //                       );
                                    //                     }
                                    //                     if(!snap2.hasData){
                                    //                       return Center(
                                    //                         child: CircularProgressIndicator(),
                                    //                       );
                                    //                     }
                                    //
                                    //                     return
                                    //                       ListView.builder(
                                    //                           shrinkWrap: true,
                                    //                           physics: NeverScrollableScrollPhysics(),
                                    //                           itemCount: snap2.data!.docs.length,
                                    //                           itemBuilder: (context,index){
                                    //
                                    //                             var feesdata=snap2.data!.docs[index];
                                    //                             return
                                    //
                                    //
                                    //                               Column(
                                    //                                 children: [
                                    //                                   Padding(
                                    //                                     padding:  EdgeInsets.only(bottom: height/94.5),
                                    //                                     child: Material(
                                    //                                       elevation:5,
                                    //                                       borderRadius: BorderRadius.circular(15),
                                    //                                       child: Container(
                                    //                                           width: width/1.2,
                                    //                                           height: height/7.0,
                                    //                                           decoration: BoxDecoration(
                                    //                                             borderRadius: BorderRadius.circular(15),
                                    //                                             //color: Color(0xff0873C4),
                                    //                                             color: diffrencedays==5||diffrencedays==4?Colors.orange:diffrencedays<=3?Colors.red:Color(0xff0873C4),
                                    //                                           ),
                                    //                                           child: Row(
                                    //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //                                             children: [
                                    //                                               Column(
                                    //
                                    //                                                 children: [
                                    //                                                   Padding(
                                    //                                                     padding:  EdgeInsets.only(left: width/30,top:height/94.5,bottom: height/151.2),
                                    //                                                     child: Row(
                                    //                                                       children: [
                                    //                                                         Container(
                                    //                                                           width:width/2,
                                    //                                                           child: Text(snap.data!.docs[index]["name"],style: GoogleFonts.poppins(
                                    //                                                               color: Colors.white,
                                    //                                                               fontSize: width/20,
                                    //                                                               fontWeight: FontWeight.w700
                                    //
                                    //                                                           )),
                                    //                                                         ),
                                    //
                                    //                                                           Container(
                                    //                                                               width:width/3.60,
                                    //                                                               child: Center(child: Text("₹ ${feesdata['amount'].toString()}",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.white),))),
                                    //
                                    //
                                    //                                                       ],
                                    //                                                     ),
                                    //                                                   ),
                                    //                                                   Padding(
                                    //                                                     padding:  EdgeInsets.only(left: width/30),
                                    //                                                     child: Row(
                                    //                                                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    //                                                       children: [
                                    //                                                         SizedBox(
                                    //                                                             width:width/2,
                                    //                                                             child: Text("Due Date: ${feesdata['duedate']}",
                                    //                                                               style: GoogleFonts.poppins(fontWeight: FontWeight.w500),)),
                                    //                                                           Column(
                                    //                                                             children: [
                                    //                                                               SizedBox(
                                    //                                                                   width:width/3.60,
                                    //                                                                   child: Icon(Icons.text_snippet_rounded,color: Colors.white,size: width/10,)),
                                    //                                                               Container(
                                    //                                                                 decoration: BoxDecoration(
                                    //                                                                     color: Colors.white,
                                    //                                                                     borderRadius:BorderRadius.circular(8)
                                    //                                                                 ),
                                    //                                                                 padding: EdgeInsets.only(top: height/378,bottom: height/378,left: width/90,right: width/90),
                                    //                                                                 child: Text("5 Days",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,
                                    //                                                                     color: Colors.black
                                    //                                                                 ),),
                                    //                                                               )
                                    //                                                             ],
                                    //                                                           ),
                                    //
                                    //                                                       ],
                                    //                                                     ),
                                    //                                                   ),
                                    //                                                 ],
                                    //                                                 mainAxisAlignment: MainAxisAlignment.start,
                                    //                                               ),
                                    //
                                    //                                             ],
                                    //                                           )
                                    //                                       ),
                                    //                                     ),
                                    //                                   ),
                                    //
                                    //
                                    //                                 ],
                                    //                               );
                                    //                           });
                                    //                   });
                                    //           });
                                    //     }),
                                    StreamBuilder(
                                        stream: _firestore2db.collection(
                                            "Students").doc(Studentid).
                                        collection("Fees")
                                            .where("status", isEqualTo: false)
                                            .snapshots(),
                                        builder: (context, snap2) {
                                          if (snap2.hasData == null) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          if (!snap2.hasData) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }

                                          return
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: snap2.data!.docs
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  var feesdata = snap2.data!
                                                      .docs[index];

                                                  return
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: height /
                                                              94.5),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          warningpayment();
                                                        },
                                                        child: Material(
                                                          elevation: 5,
                                                          borderRadius: BorderRadius
                                                              .circular(15),
                                                          child: Container(
                                                              width: width /
                                                                  1.1,
                                                              height: height /
                                                                  9.0,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    15),
                                                                //color: Color(0xff0873C4),
                                                                color:
                                                                differenceDatefunction(
                                                                    feesdata['duedate'])
                                                                    .isNegative
                                                                    ? Colors.red
                                                                    : Color(
                                                                    0xff0873C4),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets
                                                                            .only(
                                                                            left: width /
                                                                                29,
                                                                            top: height /
                                                                                94.5,
                                                                            bottom: height /
                                                                                151.2),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Container(
                                                                              width: width /
                                                                                  1.89,
                                                                              child: Text(
                                                                                  feesdata["feesname"],
                                                                                  textAlign: TextAlign
                                                                                      .start,

                                                                                  style: GoogleFonts
                                                                                      .poppins(
                                                                                      color: Colors
                                                                                          .white,
                                                                                      fontSize: width /
                                                                                          20,
                                                                                      fontWeight: FontWeight
                                                                                          .w700

                                                                                  )),
                                                                            ),

                                                                            Container(
                                                                                width: width /
                                                                                    3.60,
                                                                                child: Center(
                                                                                    child: Text(
                                                                                      "₹ ${feesdata['amount']
                                                                                          .toString()}",
                                                                                      style: GoogleFonts
                                                                                          .poppins(
                                                                                        fontWeight: FontWeight
                                                                                            .w500,
                                                                                        color: Colors
                                                                                            .white,
                                                                                        fontSize: width /
                                                                                            20,),))),


                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height: height /
                                                                              130.6),
                                                                      Padding(
                                                                        padding: EdgeInsets
                                                                            .only(
                                                                            left: width /
                                                                                30),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .spaceAround,
                                                                          children: [
                                                                            Container(
                                                                                width: width /
                                                                                    2.0,
                                                                                child: Text(
                                                                                  "Due Date: ${feesdata['duedate']}",
                                                                                  style: GoogleFonts
                                                                                      .poppins(
                                                                                      fontWeight: FontWeight
                                                                                          .w500,
                                                                                      color: Colors
                                                                                          .white),)),
                                                                            SizedBox(
                                                                              width: width /
                                                                                  12.438,),

                                                                            differenceDatefunction(
                                                                                feesdata['duedate'])
                                                                                .isNegative
                                                                                ?
                                                                            Container(
                                                                              width: width /
                                                                                  4.60,
                                                                              decoration: BoxDecoration(
                                                                                  color: Colors
                                                                                      .white,
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      8)
                                                                              ),

                                                                              padding: EdgeInsets
                                                                                  .only(
                                                                                  top: height /
                                                                                      378,
                                                                                  bottom: height /
                                                                                      378,
                                                                                  left: width /
                                                                                      90,
                                                                                  right: width /
                                                                                      90),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  differenceDatefunction(
                                                                                      feesdata['duedate'])
                                                                                      .isNegative
                                                                                      ?
                                                                                  "Over Due"
                                                                                      :
                                                                                  "${differenceDatefunction(
                                                                                      feesdata['duedate'])
                                                                                      .toString()} Days",
                                                                                  style: GoogleFonts
                                                                                      .poppins(
                                                                                      fontWeight: FontWeight
                                                                                          .w500,
                                                                                      color:
                                                                                      differenceDatefunction(
                                                                                          feesdata['duedate']) ==
                                                                                          5
                                                                                          ? Colors
                                                                                          .orange
                                                                                          :
                                                                                      differenceDatefunction(
                                                                                          feesdata['duedate']) ==
                                                                                          4
                                                                                          ? Colors
                                                                                          .yellow
                                                                                          :
                                                                                      differenceDatefunction(
                                                                                          feesdata['duedate']) <=
                                                                                          3
                                                                                          ? Colors
                                                                                          .red
                                                                                          : Colors
                                                                                          .white,
                                                                                      fontSize: width /
                                                                                          27.692
                                                                                  ),),
                                                                              ),
                                                                            )
                                                                                :
                                                                            differenceDatefunction(
                                                                                feesdata['duedate']) <=
                                                                                5
                                                                                ?
                                                                            Container(
                                                                              width: width /
                                                                                  3.6364,
                                                                              decoration: BoxDecoration(
                                                                                  color: Colors
                                                                                      .white,
                                                                                  borderRadius: BorderRadius
                                                                                      .only(
                                                                                      topLeft: Radius
                                                                                          .circular(
                                                                                          15),
                                                                                      bottomLeft: Radius
                                                                                          .circular(
                                                                                          15))
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    top: height /
                                                                                        378,
                                                                                    bottom: height /
                                                                                        378,
                                                                                    left: width /
                                                                                        36,
                                                                                    right: width /
                                                                                        90),
                                                                                child: Text(
                                                                                  "Due In: ${differenceDatefunction(
                                                                                      feesdata['duedate'])
                                                                                      .toString()} Day",
                                                                                  style: GoogleFonts
                                                                                      .poppins(
                                                                                      fontWeight: FontWeight
                                                                                          .w500,
                                                                                      color:
                                                                                      differenceDatefunction(
                                                                                          feesdata['duedate']) ==
                                                                                          5
                                                                                          ? Colors
                                                                                          .orange
                                                                                          :
                                                                                      differenceDatefunction(
                                                                                          feesdata['duedate']) ==
                                                                                          4
                                                                                          ? Colors
                                                                                          .orange
                                                                                          :
                                                                                      differenceDatefunction(
                                                                                          feesdata['duedate']) <=
                                                                                          3
                                                                                          ? Colors
                                                                                          .red
                                                                                          : Colors
                                                                                          .white,
                                                                                      fontSize: width /
                                                                                          28.692
                                                                                  ),),
                                                                              ),
                                                                            )
                                                                                : SizedBox()

                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                    mainAxisAlignment: MainAxisAlignment
                                                                        .start,
                                                                  ),

                                                                ],
                                                              )
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                });
                                        }),
                                    SizedBox(height: height / 92.125,),

                                    Text(
                                      "Previous Reports",
                                      style: GoogleFonts
                                          .poppins(
                                          color: Color(0xff0271C5),
                                          fontSize: width / 20,
                                          fontWeight:
                                          FontWeight
                                              .w600),
                                    ),
                                    SizedBox(height: height / 92.125,),
                                    StreamBuilder(
                                        stream: _firestore2db.collection(
                                            "Students").doc(Studentid)
                                            .collection("Fees").where(
                                            "status", isEqualTo: true)
                                            .snapshots(),
                                        builder: (context, snap) {
                                          if (snap.hasData == null) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          if (!snap.hasData) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }

                                          return
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: snap.data!.docs
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  var feesdata = snap.data!
                                                      .docs[index];
                                                  return
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 0.8
                                                              )
                                                          )
                                                      ),
                                                      child: ListTile(
                                                        trailing: Column(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .end,
                                                          children: [
                                                            SizedBox(
                                                              height: height /
                                                                  400.5,),
                                                            Text(
                                                              "₹ ${feesdata['amount']
                                                                  .toString()}",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                  fontWeight: FontWeight
                                                                      .w500),),
                                                            SizedBox(
                                                              height: height /
                                                                  94.5,),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius
                                                                      .circular(
                                                                      8)
                                                              ),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  top: height /
                                                                      378,
                                                                  bottom: height /
                                                                      378,
                                                                  left: width /
                                                                      90,
                                                                  right: width /
                                                                      90),
                                                              child: Text(
                                                                "Time : ${feesdata['time']
                                                                    .toString()}",
                                                                style: GoogleFonts
                                                                    .poppins(
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    color: Colors
                                                                        .black
                                                                ),),
                                                            )
                                                          ],
                                                        ),
                                                        title: Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              bottom: height /
                                                                  75.6),
                                                          child: Text(
                                                            feesdata['feesname'],
                                                            style: GoogleFonts
                                                                .poppins(
                                                                fontWeight: FontWeight
                                                                    .w500),),
                                                        ),
                                                        subtitle: Container(
                                                            width: width / 2.5,
                                                            child: Text(
                                                              "Paid on : ${feesdata['date']}",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                  fontWeight: FontWeight
                                                                      .w500),)),
                                                      ),
                                                    );
                                                });
                                        }),
                                    SizedBox(height: height / 10.125,),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                            : page == "Progress"
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
                                        fontSize: width / 20,
                                        fontWeight:
                                        FontWeight
                                            .w600),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: width / 1.286,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${ DateFormat.yMMMd().format(
                                                  DateTime.now())}",
                                              style:
                                              GoogleFonts.poppins(
                                                  color: Colors.grey
                                                      .shade700,
                                                  fontSize: width / 24,
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
                                                  fontSize: width / 24,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ),
                                          ],
                                        ),
                                      ),

                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            page = "Home";
                                          });
                                        },
                                        child: Padding(padding: EdgeInsets.only(
                                            right: width / 45),
                                          child: Icon(
                                            Icons.arrow_circle_down_sharp,
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
                                        width: width / 1.3,
                                        child: Divider(
                                            color: Colors.grey
                                                .shade700
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height / 92.125,
                                  ),

                                  Material(
                                    elevation: 5,
                                    borderRadius: BorderRadius.circular(12),
                                    child: GestureDetector(
                                      onTap: () async {

                                        PdfPrint("Raven English School","ANNANJI ,THENI - 625531");
                                      },
                                      child: Container(
                                          width: width / 0.972,
                                          height: height / 7.56,

                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                12),
                                            color: Color(0xff0873C4),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: width / 30,
                                                        top: height / 94.5,
                                                        bottom: height / 151.2),
                                                    child: Text(
                                                      "Download Reports",
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: Colors.white,
                                                          fontSize: width /
                                                              15.652,
                                                          fontWeight: FontWeight
                                                              .w700

                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: width / 30),
                                                    child: Text(
                                                      "Last Updated Today 1.34 AM",
                                                      style: GoogleFonts
                                                          .poppins(
                                                          color: Colors.white,
                                                          fontSize: width /
                                                              22.5,
                                                          fontWeight: FontWeight
                                                              .w600

                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width / 30),
                                                child: Icon(Icons.download,
                                                  color: Colors.white,
                                                  size: 40,),
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
                                        fontSize: width / 20,
                                        fontWeight:
                                        FontWeight
                                            .w600),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: width / 1.286,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${ DateFormat.yMMMd().format(
                                                  DateTime.now())}",
                                              style:
                                              GoogleFonts.poppins(
                                                  color: Colors.grey
                                                      .shade700,
                                                  fontSize: width / 24,
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
                                                  fontSize: width / 24,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ),
                                          ],
                                        ),
                                      ),

                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            page = "Home";
                                          });
                                        },
                                        child: Padding(padding: EdgeInsets.only(
                                            right: width / 45),
                                          child: Icon(
                                            Icons.arrow_circle_down_sharp,
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
                                        width: width / 1.3,
                                        child: Divider(
                                            color: Colors.grey
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
                                        fontSize: width / 20,
                                        fontWeight:
                                        FontWeight
                                            .w600),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: width / 1.286,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${ DateFormat.yMMMd().format(
                                                  DateTime.now())}",
                                              style:
                                              GoogleFonts.poppins(
                                                  color: Colors.grey
                                                      .shade700,
                                                  fontSize: width / 24,
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
                                                  fontSize: width / 24,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ),
                                          ],
                                        ),
                                      ),

                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            page = "Home";
                                          });
                                        },
                                        child: Padding(padding: EdgeInsets.only(
                                            right: width / 45),
                                          child: Icon(
                                            Icons.arrow_circle_down_sharp,
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
                                        width: width / 1.3,
                                        child: Divider(
                                            color: Colors.grey
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
                                        fontSize: width / 20,
                                        fontWeight:
                                        FontWeight
                                            .w600),
                                  ),
                                  SizedBox(height: height / 37.8),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: width / 4.8,),
                                    child: Container(
                                      width: width / 1.2,
                                      child: Row(
                                        children: [
                                          Icon(Icons.done, size: width / 24),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width / 72),
                                            child: Text('Transfer CV',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: width / 25.714)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: width / 4.8,),
                                    child: Container(
                                      width: width / 1.2,
                                      child: Row(
                                        children: [
                                          Icon(Icons.done, size: width / 24),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width / 72),
                                            child: Text('Bonifide CV',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: width / 25.714)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: width / 4.8,),
                                    child: Container(
                                      width: width / 1.2,
                                      child: Row(
                                        children: [
                                          Icon(Icons.done, size: width / 24),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width / 72),
                                            child: Text('Sports CV',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: width / 25.714)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: width / 4.8,),
                                    child: Container(
                                      width: width / 1.2,
                                      child: Row(
                                        children: [
                                          Icon(Icons.done, size: width / 24),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width / 72),
                                            child: Text('Competition CV',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: width / 25.714)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: height / 30.24),
                                    child: Container(
                                      width: width / 1.2,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            'Name', style: GoogleFonts.poppins(
                                              color: const Color(0xff707070),
                                              fontWeight: FontWeight.bold
                                          ),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width / 0.947,
                                    child: TextField(
                                      controller: namecontroller,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,

                                          hintText: 'Enter Your Name'
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: height / 50.4),
                                    child: Container(
                                      width: width / 1.2,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          Text('Reg No',
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xff707070),
                                                fontWeight: FontWeight.bold
                                            ),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width / 0.947,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black45)
                                      ),
                                      width: width / 1.2,
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
                                    padding: EdgeInsets.only(
                                        top: height / 50.4),
                                    child: Container(
                                      width: width / 0.947,
                                      child: Text('Requirement',
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xff707070),
                                            fontWeight: FontWeight.bold
                                        ),),
                                    ),
                                  ),
                                  Container(
                                    width: width / 0.947,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black45)
                                      ),
                                      width: width / 1.2,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: width / 72),
                                        child: DropdownButton(
                                          value: dropdownvalue,
                                          icon: Padding(
                                            padding: EdgeInsets.only(
                                                left: width / 2.25),
                                            child: const Icon(
                                                Icons.keyboard_arrow_down),
                                          ),
                                          underline: Container(),
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
                                    padding: EdgeInsets.only(
                                        top: height / 37.8),
                                    child: GestureDetector(onTap: () {


                                    },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Text('Submit',
                                            style: GoogleFonts.poppins(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: width / 20
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
                                                fontSize: width / 21.77777778,
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
                                          "${ DateFormat.yMMMd().format(
                                              DateTime.now())}",
                                          style: GoogleFonts
                                              .poppins(
                                              color: Colors
                                                  .grey
                                                  .shade700,
                                              fontSize: width / 26.13333333,
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
                                              fontSize: width / 26.13333333,
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
                                            .collection(
                                            '${Studentclass}${Studentsec}chat')
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
                                                    itemCount: snapshot.data!.docs.length,
                                                    itemBuilder: (context, index) {
                                                      Map<String, dynamic> chatMap =
                                                      snapshot.data!.docs[index].data() as Map<String, dynamic>;

                                                      if(Searchcontroller.text!=""&&page == "Messages"&&snapshot.data!.docs[index]["message"].toString().
                                                      toLowerCase().startsWith(Searchcontroller.text.toLowerCase().toString())){
                                                        return
                                                          Column(
                                                            crossAxisAlignment: snapshot
                                                                .data!
                                                                .docs[index]["sender"] ==
                                                                Studentname
                                                                ? CrossAxisAlignment
                                                                .end
                                                                : CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Container(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(3.0),
                                                                  child: Container(
                                                                      width: size.width,
                                                                      alignment: snapshot.data!.docs[index]['sender'] == Studentname ? Alignment.centerRight : Alignment.centerLeft,
                                                                      child:
                                                                      GestureDetector(
                                                                        onLongPress: () {
                                                                          if (snapshot.data!.docs[index]['sender'] == Studentname) {
                                                                            showDialog(context: context, builder: (ctx) =>
                                                                                AlertDialog(
                                                                                  title: Text('Are you sure delete this message'),
                                                                                  actions: [
                                                                                    TextButton(onPressed: () {
                                                                                      _firestore2db.collection(
                                                                                          '${Studentclass}${Studentsec}chat')
                                                                                          .doc(snapshot.data!.docs[index].id)
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
                                                                              color:  Searchcontroller.text!=""?Color(0xffF8FF95):snapshot.data!.docs[index]['sender'] == Studentname
                                                                                  ? Colors.white
                                                                                  : Color(0xff0271C5),
                                                                              border: Border.all(
                                                                                  color:
                                                                                  Searchcontroller.text!=""?Colors.white:
                                                                                  snapshot.data!.docs[index]['sender'] == Studentname ? Color(
                                                                                      0xff010029)
                                                                                      .withOpacity(0.65) : Color(0xff0271C5)),
                                                                              borderRadius: BorderRadius.only(topLeft: Radius
                                                                                  .circular(15),
                                                                                bottomLeft: snapshot.data!.docs[index]['sender'] == Studentname ? Radius
                                                                                    .circular(15) : Radius.circular(0),
                                                                                bottomRight: snapshot.data!.docs[index]['sender'] == Studentname ? Radius
                                                                                    .circular(0) : Radius.circular(15),
                                                                                topRight: Radius.circular(15),),
                                                                            ),
                                                                            child: Column(
                                                                              children: [
                                                                                Text(
                                                                                  snapshot.data!.docs[index]['message'],
                                                                                  style: GoogleFonts.montserrat(
                                                                                    fontSize: width / 30.15384615,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color:  Searchcontroller.text!=""?Colors.black:
                                                                                    Searchcontroller.text==""&&
                                                                                        snapshot.data!.docs[index]['sender'] == Studentname ? Colors.black : Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      )
                                                                  ),
                                                                ),
                                                                // messageTile(
                                                                //   size, chatMap,
                                                                //   context,
                                                                //   snapshot.data!.docs[index].id,
                                                                // ),
                                                              ),
                                                              snapshot.data!.docs[index]["submitdate"] ==
                                                                  "${DateTime.now().year}-${ DateTime.now().month}-${ DateTime.now().day}" ?
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
                                                      }
                                                      else if(Searchcontroller.text==""&&page == "Messages"){

                                                        return
                                                          Column(
                                                            crossAxisAlignment: snapshot
                                                                .data!
                                                                .docs[index]["sender"] ==
                                                                Studentname
                                                                ? CrossAxisAlignment
                                                                .end
                                                                : CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              messageTile(
                                                                size, chatMap,
                                                                context,
                                                                snapshot.data!.docs[index].id,
                                                              ),
                                                              snapshot.data!.docs[index]["submitdate"] ==
                                                                  "${DateTime.now().year}-${ DateTime.now().month}-${ DateTime.now().day}" ?
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

                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          else {
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
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
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
                  page=="Attendance" || page=="Time Table" || page=="Progress" ||page=="Fees"
                      ||  page=="School Bus"

                      ?

                  SizedBox():

                  Padding(
                    padding: EdgeInsets.only(
                        left: width / 13.33, right: width / 13.333),
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
                              contentPadding: EdgeInsets.only(
                                  top: height / 50.4),

                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Searchcontroller.clear();
                                      page = "Home";
                                    });
                                  },
                                  child: Icon(Icons.clear)),
                              enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                              focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                              prefixIcon: Icon(Icons.search_rounded
                              ),
                              hintText: "Search",
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey.shade900,
                                  fontSize: width / 22.5)),

                          onChanged: (val) {
                            if (Searchcontroller.text =="") {
                              setState(() {
                                Searchcontroller.clear();
                              });
                              setState(() {

                              });
                            }
                            else {
                              setState(() {
                                Searchcontroller.text = val;
                              });
                              setState(() {

                              });
                            }
                            setState(() {

                            });
                            print(Searchcontroller.text);
                          },
                          controller: Searchcontroller,
                        ),
                      ),
                    ),
                  ),
                    Loading==true?Padding(
                      padding:  EdgeInsets.only(left:width/4.5,top:height/3.024),
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
              // white

            ],
          ),
        ),
      ) :
      selecteIndexvalue == 1 ?
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
                                        fontSize: width / 20,
                                        fontWeight:
                                        FontWeight
                                            .w600),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: width / 1.2,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${DateTime
                                                  .now()
                                                  .day}-${DateTime
                                                  .now()
                                                  .month}-${DateTime
                                                  .now()
                                                  .year}",
                                              style:
                                              GoogleFonts.poppins(
                                                  color: Colors.grey
                                                      .shade700,
                                                  fontSize: width / 24,
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
                                                  fontSize: width / 24,
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

                                    stream: _firestore2db.collection(
                                        "Circulars")
                                        .orderBy("timestamp", descending: true)
                                        .snapshots(),
                                    builder: (context, snap) {
                                      if (snap.hasData == null) {
                                        return Center(
                                          child: CircularProgressIndicator(),);
                                      }
                                      if (!snap.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),);
                                      }

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snap.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          var circular = snap.data!.docs[index];

                                          if (Searchcontroller.text != "") {
                                            if (page == "Circulars" &&
                                                circular['reason'].toString()
                                                    .toLowerCase()
                                                    .contains(
                                                    Searchcontroller.text
                                                        .toLowerCase()) &&
                                                circular["type"]
                                                    .toString()
                                                    .toLowerCase() != "Staff"
                                                    .toString()
                                                    .toLowerCase() ||
                                                page == "Circulars" &&
                                                    circular['Descr'].toString()
                                                        .toLowerCase()
                                                        .contains(
                                                        Searchcontroller.text
                                                            .toLowerCase()) &&
                                                    circular["type"]
                                                        .toString()
                                                        .toLowerCase() !=
                                                        "Staff"
                                                            .toString()
                                                            .toLowerCase() ||
                                                page == "Circulars" &&
                                                    circular['Date'].toString()
                                                        .toLowerCase()
                                                        .contains(
                                                        Searchcontroller.text
                                                            .toLowerCase()) &&
                                                    circular["type"]
                                                        .toString()
                                                        .toLowerCase() !=
                                                        "Staff"
                                                            .toString()
                                                            .toLowerCase()
                                            ) {
                                              return
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: height / 47.25),
                                                  child: Container(

                                                    width: width / 1.0714,
                                                    margin: EdgeInsets.only(
                                                        bottom: height / 30.24),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                        border: Border.all(
                                                            color: Colors
                                                                .black)),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: width / 45,
                                                          right: width / 45,
                                                          top: height / 94.5,
                                                          bottom: height /
                                                              94.5),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Image.asset(
                                                                  "assets/Exlmtry.png"),
                                                              SizedBox(
                                                                  width: width /
                                                                      60),
                                                              Container(
                                                                width: width /
                                                                    1.3,
                                                                child: Text(
                                                                  circular["Descr"],
                                                                  style:
                                                                  GoogleFonts
                                                                      .poppins(
                                                                      color:
                                                                      Colors
                                                                          .black,
                                                                      fontSize: width /
                                                                          22.5,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height: height /
                                                                  73.7),
                                                          Text(
                                                            circular["reason"],
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: width /
                                                                    26.13333333,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          ),
                                                          SizedBox(
                                                              height: height /
                                                                  78.3),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            children: [
                                                              Container(
                                                                width: width /
                                                                    3.8,
                                                                child: Text(
                                                                  circular["Date"],

                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700,
                                                                      fontSize: width /
                                                                          26.13333333,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ),
                                                              ),

                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    right: 8.0),
                                                                child: Container(
                                                                  height:
                                                                  height /
                                                                      49.133,
                                                                  width: width /
                                                                      170,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),

                                                              Container(
                                                                width: width /
                                                                    2.6,
                                                                child: Text(
                                                                  circular["Time"],
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700,
                                                                      fontSize: width /
                                                                          26.13333333,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ),
                                                              ),
                                                              Text(
                                                                circular["From"],

                                                                style:
                                                                GoogleFonts
                                                                    .poppins(
                                                                    color:
                                                                    Colors
                                                                        .green,
                                                                    fontSize: width /
                                                                        22.5,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),

                                                    ),

                                                  ),
                                                  // Container(
                                                  //
                                                  //     width: width/1.090,
                                                  //     decoration: BoxDecoration(
                                                  //         borderRadius: BorderRadius.circular(10),
                                                  //         border: Border.all(color:Color(0xff999999),width: width/240)
                                                  //     ),
                                                  //     child:Column(
                                                  //       children: [
                                                  //         SizedBox(height: height/151.2),
                                                  //
                                                  //         ///image and School holiday details text
                                                  //         Row(
                                                  //           mainAxisAlignment: MainAxisAlignment.start,
                                                  //           crossAxisAlignment: CrossAxisAlignment.start,
                                                  //           children: [
                                                  //
                                                  //             Padding(
                                                  //               padding:  EdgeInsets.all(8.0),
                                                  //               child: SizedBox(
                                                  //                 height: height/27,
                                                  //                 width: width/12.857,
                                                  //                 child: Image.asset("assets/Alert Iocn.png"),
                                                  //               ),
                                                  //             ),
                                                  //
                                                  //             Padding(
                                                  //               padding:  EdgeInsets.only(top:height/75.6),
                                                  //               child: SizedBox(
                                                  //                 width: width/1.285,
                                                  //
                                                  //                 child: Text(
                                                  //                   circular['reason'],
                                                  //                   style: GoogleFonts
                                                  //                       .poppins(
                                                  //                       color: Colors
                                                  //                           .black,
                                                  //                       fontSize: width/22.5,
                                                  //                       textStyle: TextStyle(
                                                  //                           overflow: TextOverflow.ellipsis
                                                  //                       ),
                                                  //                       fontWeight:
                                                  //                       FontWeight
                                                  //                           .w600),
                                                  //                 ),
                                                  //               ),
                                                  //             ),
                                                  //
                                                  //           ],
                                                  //         ),
                                                  //
                                                  //
                                                  //         ///deccription
                                                  //         Padding(
                                                  //           padding:  EdgeInsets.only(left: width/0.9473),
                                                  //           child: Container(
                                                  //
                                                  //             width: width/1.161,
                                                  //             child: Text(
                                                  //               circular['Descr'],
                                                  //               style: GoogleFonts
                                                  //                   .poppins(
                                                  //                   color: Colors
                                                  //                       .black,
                                                  //                   fontSize: width/30,
                                                  //                   fontWeight:
                                                  //                   FontWeight
                                                  //                       .w600),
                                                  //             ),
                                                  //           ),
                                                  //         ),
                                                  //         SizedBox(height: height/151.2),
                                                  //
                                                  //         ///date and principle text
                                                  //         Padding(
                                                  //           padding:  EdgeInsets.only(left:width/36.0),
                                                  //           child: Row(
                                                  //             children: [
                                                  //               SizedBox(
                                                  //
                                                  //                 width:width/1.5,
                                                  //                 child: Row(
                                                  //                   crossAxisAlignment: CrossAxisAlignment.center,
                                                  //                   children: [
                                                  //                     Text(
                                                  //                       "${circular['Date']} | ${circular['Time']}",
                                                  //                       style: GoogleFonts
                                                  //                           .poppins(
                                                  //                           color: Color(0xffA294A1),
                                                  //                           fontSize: width/27.69,
                                                  //
                                                  //                           fontWeight:
                                                  //                           FontWeight
                                                  //                               .w600),
                                                  //                     ),
                                                  //                   ],
                                                  //                 ),
                                                  //               ),
                                                  //               SizedBox(
                                                  //                 width:width/4.5,
                                                  //                 child: Center(
                                                  //                   child: Text(circular['From'],
                                                  //                     style: GoogleFonts
                                                  //                         .quando(
                                                  //                       color: Color(0xff609F00),
                                                  //                       fontSize: width/27.69,),
                                                  //                   ),
                                                  //                 ),
                                                  //               )
                                                  //             ],
                                                  //           ),
                                                  //         ),
                                                  //         SizedBox(height: height/151.2),
                                                  //
                                                  //       ],
                                                  //     )
                                                  // ),
                                                );
                                            }
                                          }

                                          if (page == "Circulars" &&
                                              Searchcontroller.text == "" &&
                                              circular["type"]
                                                  .toString()
                                                  .toLowerCase() != "Staff"
                                                  .toString()
                                                  .toLowerCase()) {
                                            return
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: height / 47.25),
                                                child: Container(

                                                  width: width / 1.0714,
                                                  margin: EdgeInsets.only(
                                                      bottom: height / 30.24),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(12),
                                                      border: Border.all(
                                                          color: Colors.black)),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: width / 45,
                                                        right: width / 45,
                                                        top: height / 94.5,
                                                        bottom: height / 94.5),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Image.asset(
                                                                "assets/Exlmtry.png"),
                                                            SizedBox(
                                                                width: width /
                                                                    60),
                                                            Container(
                                                              width: width /
                                                                  1.3,
                                                              child: Text(
                                                                circular["Descr"],
                                                                style:
                                                                GoogleFonts
                                                                    .poppins(
                                                                    color:
                                                                    Colors
                                                                        .black,
                                                                    fontSize: width /
                                                                        22.5,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height: height /
                                                                73.7),
                                                        Text(
                                                          circular["reason"],
                                                          style: GoogleFonts
                                                              .poppins(
                                                              color: Colors
                                                                  .black,
                                                              fontSize: width /
                                                                  26.13333333,
                                                              fontWeight:
                                                              FontWeight.w500),
                                                        ),
                                                        SizedBox(
                                                            height: height /
                                                                78.3),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            Container(
                                                              width: width /
                                                                  3.8,
                                                              child: Text(
                                                                circular["Date"],

                                                                style: GoogleFonts
                                                                    .poppins(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700,
                                                                    fontSize: width /
                                                                        26.13333333,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ),
                                                            ),

                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                  right: 8.0),
                                                              child: Container(
                                                                height:
                                                                height / 49.133,
                                                                width: width /
                                                                    170,
                                                                color: Colors
                                                                    .grey,
                                                              ),
                                                            ),

                                                            Container(
                                                              width: width /
                                                                  2.6,
                                                              child: Text(
                                                                circular["Time"],
                                                                style: GoogleFonts
                                                                    .poppins(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700,
                                                                    fontSize: width /
                                                                        26.13333333,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ),
                                                            ),
                                                            Text(
                                                              circular["From"],

                                                              style:
                                                              GoogleFonts
                                                                  .poppins(
                                                                  color:
                                                                  Colors.green,
                                                                  fontSize: width /
                                                                      22.5,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                  ),

                                                ),
                                                // Container(
                                                //
                                                //     width: width/1.090,
                                                //     decoration: BoxDecoration(
                                                //         borderRadius: BorderRadius.circular(10),
                                                //         border: Border.all(color:Color(0xff999999),width: width/240)
                                                //     ),
                                                //     child:Column(
                                                //       children: [
                                                //         SizedBox(height: height/151.2),
                                                //
                                                //         ///image and School holiday details text
                                                //         Row(
                                                //           mainAxisAlignment: MainAxisAlignment.start,
                                                //           crossAxisAlignment: CrossAxisAlignment.start,
                                                //           children: [
                                                //
                                                //             Padding(
                                                //               padding:  EdgeInsets.all(8.0),
                                                //               child: SizedBox(
                                                //                 height: height/27,
                                                //                 width: width/12.857,
                                                //                 child: Image.asset("assets/Alert Iocn.png"),
                                                //               ),
                                                //             ),
                                                //
                                                //             Padding(
                                                //               padding:  EdgeInsets.only(top:height/75.6),
                                                //               child: SizedBox(
                                                //                 width: width/1.285,
                                                //
                                                //                 child: Text(
                                                //                   circular['reason'],
                                                //                   style: GoogleFonts
                                                //                       .poppins(
                                                //                       color: Colors
                                                //                           .black,
                                                //                       fontSize: width/22.5,
                                                //                       textStyle: TextStyle(
                                                //                           overflow: TextOverflow.ellipsis
                                                //                       ),
                                                //                       fontWeight:
                                                //                       FontWeight
                                                //                           .w600),
                                                //                 ),
                                                //               ),
                                                //             ),
                                                //
                                                //           ],
                                                //         ),
                                                //
                                                //
                                                //         ///deccription
                                                //         Padding(
                                                //           padding:  EdgeInsets.only(left: width/0.9473),
                                                //           child: Container(
                                                //
                                                //             width: width/1.161,
                                                //             child: Text(
                                                //               circular['Descr'],
                                                //               style: GoogleFonts
                                                //                   .poppins(
                                                //                   color: Colors
                                                //                       .black,
                                                //                   fontSize: width/30,
                                                //                   fontWeight:
                                                //                   FontWeight
                                                //                       .w600),
                                                //             ),
                                                //           ),
                                                //         ),
                                                //         SizedBox(height: height/151.2),
                                                //
                                                //         ///date and principle text
                                                //         Padding(
                                                //           padding:  EdgeInsets.only(left:width/36.0),
                                                //           child: Row(
                                                //             children: [
                                                //               SizedBox(
                                                //
                                                //                 width:width/1.5,
                                                //                 child: Row(
                                                //                   crossAxisAlignment: CrossAxisAlignment.center,
                                                //                   children: [
                                                //                     Text(
                                                //                       "${circular['Date']} | ${circular['Time']}",
                                                //                       style: GoogleFonts
                                                //                           .poppins(
                                                //                           color: Color(0xffA294A1),
                                                //                           fontSize: width/27.69,
                                                //
                                                //                           fontWeight:
                                                //                           FontWeight
                                                //                               .w600),
                                                //                     ),
                                                //                   ],
                                                //                 ),
                                                //               ),
                                                //               SizedBox(
                                                //                 width:width/4.5,
                                                //                 child: Center(
                                                //                   child: Text(circular['From'],
                                                //                     style: GoogleFonts
                                                //                         .quando(
                                                //                       color: Color(0xff609F00),
                                                //                       fontSize: width/27.69,),
                                                //                   ),
                                                //                 ),
                                                //               )
                                                //             ],
                                                //           ),
                                                //         ),
                                                //         SizedBox(height: height/151.2),
                                                //
                                                //       ],
                                                //     )
                                                // ),
                                              );
                                          }
                                          return const SizedBox();
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
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Searchcontroller.clear();
                                  });
                                },
                                child: Icon(Icons.clear)),
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
                        onChanged: (val) {
                          if (Searchcontroller.text == "") {
                            setState(() {
                              Searchcontroller.clear();
                            });
                            setState(() {

                            });
                          }
                          else {
                            setState(() {
                              Searchcontroller.text = val;
                            });
                            setState(() {

                            });
                          }
                          setState(() {

                          });
                          print(Searchcontroller.text);
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
      ) :
      selecteIndexvalue == 2 ?
      StudentExam() :
      Student_Profile(Studentid),
      bottomNavigationBar: CreateBottombar(),
    );
  }

  int i = 0;

  String dropdownvalue = 'Transver CV';

  // List of items in our dropdown menu
  var items = [
    'Transver CV',
    'Bonifide CV',
    'Sports CV',
  ];

  TextEditingController namecontroller = TextEditingController();
  TextEditingController otpcontroller = TextEditingController();
  TextEditingController email = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  List teachertable = ["", "", "", "", "", "", "", ""];

  gettimetable() async {
    print("HIooo");
    setState(() {
      teachertable = ["", "", "", "", "", "", "", ""];
    });
    var document = await _firestore2db.collection("ClassTimeTable").doc(
        "${Studentclass}${Studentsec}").collection("TimeTable").get();

    print("${Studentclass}${Studentsec}");
    setState(() {
      if (TTselected == 1) {
        if (day == "Monday") {
          for (int i = 0; i < document.docs.length; i++) {
            if (document.docs[i]["order"] == 0) {
              teachertable.replaceRange(0, 1,
                  [
                    "${document.docs[i]["subject"]}\n${document
                        .docs[i]["staff"]}"
                  ]);
            }
            else if (document.docs[i]["order"] == 1) {
              teachertable.replaceRange(1, 2,
                  [
                    "${document.docs[i]["subject"]}\n${document
                        .docs[i]["staff"]}"
                  ]);
            }
            else if (document.docs[i]["order"] == 2) {
              teachertable.replaceRange(2, 3,
                  [
                    "${document.docs[i]["subject"]}\n${document
                        .docs[i]["staff"]}"
                  ]);
            }
            else if (document.docs[i]["order"] == 3) {
              teachertable.replaceRange(3, 4,
                  [
                    "${document.docs[i]["subject"]}\n${document
                        .docs[i]["staff"]}"
                  ]);
            }
            else if (document.docs[i]["order"] == 4) {
              teachertable.replaceRange(4, 5,
                  [
                    "${document.docs[i]["subject"]}\n${document
                        .docs[i]["staff"]}"
                  ]);
            }
            else if (document.docs[i]["order"] == 5) {
              teachertable.replaceRange(5, 6,
                  [
                    "${document.docs[i]["subject"]}\n${document
                        .docs[i]["staff"]}"
                  ]);
            }
            else if (document.docs[i]["order"] == 6) {
              teachertable.replaceRange(6, 7,
                  [
                    "${document.docs[i]["subject"]}\n${document
                        .docs[i]["staff"]}"
                  ]);
            }
            else if (document.docs[i]["order"] == 7) {
              teachertable.replaceRange(7, 8,
                  [
                    "${document.docs[i]["subject"]}\n${document
                        .docs[i]["staff"]}"
                  ]);
            }
          }
          /* for (int j = 0; j < teachertable.length; j++) {
         if (teachertable[j] == "") {
           teachertable.replaceRange(j, j + 1, ["Free Period"]);
         }
       }

       */
        }
        if (day == "Tuesday") {
          for (int i = 0; i < document.docs.length; i++) {
            if (document.docs[i]["order"] == 8) {
              teachertable.replaceRange(0, 1, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 9) {
              teachertable.replaceRange(1, 2, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 10) {
              teachertable.replaceRange(2, 3, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 11) {
              teachertable.replaceRange(3, 4, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 12) {
              teachertable.replaceRange(4, 5, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 13) {
              teachertable.replaceRange(5, 6, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 14) {
              teachertable.replaceRange(6, 7, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 15) {
              teachertable.replaceRange(7, 8, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
          }
        }
        if (day == "Wednesday") {
          for (int i = 0; i < document.docs.length; i++) {
            if (document.docs[i]["order"] == 16) {
              teachertable.replaceRange(0, 1, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 17) {
              teachertable.replaceRange(1, 2, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 18) {
              teachertable.replaceRange(2, 3, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 19) {
              teachertable.replaceRange(3, 4, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 20) {
              teachertable.replaceRange(4, 5, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 21) {
              teachertable.replaceRange(5, 6, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 22) {
              teachertable.replaceRange(6, 7, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 23) {
              teachertable.replaceRange(7, 8, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
          }
        }
        if (day == "Thursday") {
          for (int i = 0; i < document.docs.length; i++) {
            if (document.docs[i]["order"] == 24) {
              teachertable.replaceRange(0, 1, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 25) {
              teachertable.replaceRange(1, 2, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 26) {
              teachertable.replaceRange(2, 3, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 27) {
              teachertable.replaceRange(3, 4, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 28) {
              teachertable.replaceRange(4, 5, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 29) {
              teachertable.replaceRange(5, 6, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 30) {
              teachertable.replaceRange(6, 7, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 31) {
              teachertable.replaceRange(7, 8, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
          }
        }
        if (day == "Friday") {
          for (int i = 0; i < document.docs.length; i++) {
            if (document.docs[i]["order"] == 32) {
              teachertable.replaceRange(0, 1, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 33) {
              teachertable.replaceRange(1, 2, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 34) {
              teachertable.replaceRange(2, 3, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 35) {
              teachertable.replaceRange(3, 4, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 36) {
              teachertable.replaceRange(4, 5, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 37) {
              teachertable.replaceRange(5, 6, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 38) {
              teachertable.replaceRange(6, 7, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 39) {
              teachertable.replaceRange(7, 8, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
          }
        }
        if (day == "Saturday") {
          for (int i = 0; i < document.docs.length; i++) {
            if (document.docs[i]["order"] == 40) {
              teachertable.replaceRange(0, 1, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 41) {
              teachertable.replaceRange(1, 2, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 42) {
              teachertable.replaceRange(2, 3, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 43) {
              teachertable.replaceRange(3, 4, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 44) {
              teachertable.replaceRange(4, 5, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 45) {
              teachertable.replaceRange(5, 6, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 46) {
              teachertable.replaceRange(6, 7, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
            else if (document.docs[i]["order"] == 47) {
              teachertable.replaceRange(7, 8, [
                "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
              ]);
            }
          }
        }
      }
      else if (TTselected == 2) {
        for (int i = 0; i < document.docs.length; i++) {
          if (document.docs[i]["order"] == 0) {
            teachertable.replaceRange(0, 1,
                [
                  "${document.docs[i]["subject"]}\n${document
                      .docs[i]["staff"]}"
                ]);
          }
          else if (document.docs[i]["order"] == 1) {
            teachertable.replaceRange(1, 2,
                [
                  "${document.docs[i]["subject"]}\n${document
                      .docs[i]["staff"]}"
                ]);
          }
          else if (document.docs[i]["order"] == 2) {
            teachertable.replaceRange(2, 3,
                [
                  "${document.docs[i]["subject"]}\n${document
                      .docs[i]["staff"]}"
                ]);
          }
          else if (document.docs[i]["order"] == 3) {
            teachertable.replaceRange(3, 4,
                [
                  "${document.docs[i]["subject"]}\n${document
                      .docs[i]["staff"]}"
                ]);
          }
          else if (document.docs[i]["order"] == 4) {
            teachertable.replaceRange(4, 5,
                [
                  "${document.docs[i]["subject"]}\n${document
                      .docs[i]["staff"]}"
                ]);
          }
          else if (document.docs[i]["order"] == 5) {
            teachertable.replaceRange(5, 6,
                [
                  "${document.docs[i]["subject"]}\n${document
                      .docs[i]["staff"]}"
                ]);
          }
          else if (document.docs[i]["order"] == 6) {
            teachertable.replaceRange(6, 7,
                [
                  "${document.docs[i]["subject"]}\n${document
                      .docs[i]["staff"]}"
                ]);
          }
          else if (document.docs[i]["order"] == 7) {
            teachertable.replaceRange(7, 8,
                [
                  "${document.docs[i]["subject"]}\n${document
                      .docs[i]["staff"]}"
                ]);
          }
        }
      }
      else if (TTselected == 3) {
        for (int i = 0; i < document.docs.length; i++) {
          if (document.docs[i]["order"] == 8) {
            teachertable.replaceRange(0, 1, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 9) {
            teachertable.replaceRange(1, 2, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 10) {
            teachertable.replaceRange(2, 3, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 11) {
            teachertable.replaceRange(3, 4, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 12) {
            teachertable.replaceRange(4, 5, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 13) {
            teachertable.replaceRange(5, 6, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 14) {
            teachertable.replaceRange(6, 7, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 15) {
            teachertable.replaceRange(7, 8, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
        }
      }
      else if (TTselected == 4) {
        for (int i = 0; i < document.docs.length; i++) {
          if (document.docs[i]["order"] == 16) {
            teachertable.replaceRange(0, 1, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 17) {
            teachertable.replaceRange(1, 2, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 18) {
            teachertable.replaceRange(2, 3, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 19) {
            teachertable.replaceRange(3, 4, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 20) {
            teachertable.replaceRange(4, 5, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 21) {
            teachertable.replaceRange(5, 6, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 22) {
            teachertable.replaceRange(6, 7, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 23) {
            teachertable.replaceRange(7, 8, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
        }
      }
      else if (TTselected == 5) {
        for (int i = 0; i < document.docs.length; i++) {
          if (document.docs[i]["order"] == 24) {
            teachertable.replaceRange(0, 1, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 25) {
            teachertable.replaceRange(1, 2, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 26) {
            teachertable.replaceRange(2, 3, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 27) {
            teachertable.replaceRange(3, 4, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 28) {
            teachertable.replaceRange(4, 5, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 29) {
            teachertable.replaceRange(5, 6, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 30) {
            teachertable.replaceRange(6, 7, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 31) {
            teachertable.replaceRange(7, 8, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
        }
      }
      else if (TTselected == 6) {
        for (int i = 0; i < document.docs.length; i++) {
          if (document.docs[i]["order"] == 32) {
            teachertable.replaceRange(0, 1, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 33) {
            teachertable.replaceRange(1, 2, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 34) {
            teachertable.replaceRange(2, 3, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 35) {
            teachertable.replaceRange(3, 4, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 36) {
            teachertable.replaceRange(4, 5, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 37) {
            teachertable.replaceRange(5, 6, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 38) {
            teachertable.replaceRange(6, 7, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 39) {
            teachertable.replaceRange(7, 8, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
        }
      }
      else if (TTselected == 7) {
        for (int i = 0; i < document.docs.length; i++) {
          if (document.docs[i]["order"] == 40) {
            teachertable.replaceRange(0, 1, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 41) {
            teachertable.replaceRange(1, 2, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 42) {
            teachertable.replaceRange(2, 3, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 43) {
            teachertable.replaceRange(3, 4, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 44) {
            teachertable.replaceRange(4, 5, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 45) {
            teachertable.replaceRange(5, 6, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 46) {
            teachertable.replaceRange(6, 7, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
          else if (document.docs[i]["order"] == 47) {
            teachertable.replaceRange(7, 8, [
              "${document.docs[i]["subject"]}\n${document.docs[i]["staff"]}"
            ]);
          }
        }
      }
    });
  }

  Container CreateBottombar() {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
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
                iconSize: width / 13.8461,
                tabBackgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: width / 36, vertical: height / 151.2),
                tabs: [
                  GButton(
                    onPressed: () {
                      setState(() {
                        page = "Home";
                        selecteIndexvalue = 0;
                      });
                    },
                    margin: EdgeInsets.only(left: width / 36),
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    onPressed: () {
                      setState(() {
                        page = "Circulars";
                        Searchcontroller.clear();
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

  TextEditingController remarkscon1 = TextEditingController();

  seditpoup(docid, context) async {
    _firestore2db.collection("Students").doc(Studentid).collection("Feedback")
        .doc(docid).get()
        .then((value) {
      setState(() {
        remarkscon1.text = value['remarks'];
      });
    });

    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return
      showDialog(

        context: context, builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            height: double.infinity,
            width: width / 1.2,
            child: Scaffold(
              body: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height / 75.6,),
                        Text(
                          'Edit the Student Feedback', style: GoogleFonts
                            .poppins(
                            color: Colors.black,
                            fontSize: width / 20,
                            fontWeight: FontWeight.w700

                        ),),
                        SizedBox(height: height / 75.6,),
                        Text(
                          'Edit Remarks', style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: width / 20,
                            fontWeight: FontWeight.w700

                        ),),
                        SizedBox(height: height / 75.6,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: width / 36, right: width / 36),
                            height: height / 4.74,
                            width: width / 1.3,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey.shade300),
                                borderRadius:
                                BorderRadius.circular(10)),
                            child: TextField(
                              controller: remarkscon1,


                              style: GoogleFonts
                                  .poppins(
                                color: Colors
                                    .black,
                                fontSize: width / 25.714,
                                fontWeight:
                                FontWeight
                                    .w500,
                              ),

                              maxLines: 5,
                              minLines: 1,
                              decoration:
                              InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: height / 50.4),

                                  hintText:
                                  "",
                                  hintStyle:
                                  GoogleFonts
                                      .poppins(
                                    color: Colors
                                        .black,
                                    fontSize: width / 25.714,
                                    fontWeight:
                                    FontWeight
                                        .w500,
                                  ),
                                  border:
                                  InputBorder
                                      .none),


                            ),


                          ),
                        ),
                        SizedBox(height: height / 9.45,),
                        GestureDetector(
                          onTap: () {
                            updateremarks(docid);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: width / 36, right: width / 36),
                            height: height / 14.74,
                            width: width / 2.363,
                            decoration: BoxDecoration(
                                color: Color(0xff3D8CF8),
                                border: Border.all(
                                    color: Colors.grey.shade300),
                                borderRadius:
                                BorderRadius.circular(10)),
                            child: Center(
                              child: Text("Submit", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width / 18,
                                  fontWeight: FontWeight.w700),),
                            ),

                          ),
                        ),
                        SizedBox(height: height / 18.9,),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },);
  }


  updateremarks(docid) {
    _firestore2db.collection("Students").doc(Studentid)
        .collection("Feedback")
        .doc(docid)
        .update({
      "remarks": remarkscon1.text
    });
    setState(() {
      remarkscon1.clear();
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  feedbackdescriptionpopup(name, description) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return showDialog(context: context, builder: (ctx) =>
        AlertDialog(
          title: Center(child: Column(
            children: [
              Text('Feed Back Report', style: TextStyle(
                  fontSize: width / 20.5, fontWeight: FontWeight.w700),),
              SizedBox(height: height / 200.2,),
              Text('Staff Name:  ${name.toString()}', style: TextStyle(
                  fontSize: width / 30.5, fontWeight: FontWeight.w700),),
              SizedBox(height: height / 200.2,),

            ],
          )),
          content: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: height / 50.4,),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: height / 189,
                    horizontal: width / 90,
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white54,

                      ), padding: EdgeInsets.symmetric(
                    vertical: height / 189,
                    horizontal: width / 90,
                  ),
                      child: Text(description, style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: width / 25.714,
                          color: Colors.black),)),
                ),
                SizedBox(height: height / 50.4,),


              ],
            ),
          ),

        ));
  }

  int diffrencedays = 0;

  differenceDatefunction(date1) {
    print("Dateeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    print(date1);
    diffrencedays = DateFormat('dd/MM/yyyy')
        .parse(date1)
        .difference(DateTime.now())
        .inDays;
    // setState(() {
    //   diffrencedays=DateFormat('dd / M / yyyy').parse('21 / 10 / 2023').difference(DateTime.now()).inDays;;
    // });
    print(diffrencedays);
    print("diffrencedays");
    return diffrencedays;
  }

  paymentpopup() {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return showDialog(context: context, builder: (ctx) =>
        AlertDialog(
          title: Center(child: Column(
            children: [
              Text('Fees Payment', style: TextStyle(
                  fontSize: width / 20.5, fontWeight: FontWeight.w700),),
              SizedBox(height: height / 200.2,),


            ],

          )),
          content: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: height / 50.4,),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: height / 189,
                    horizontal: width / 90,
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white54,

                      ), padding: EdgeInsets.symmetric(
                    vertical: height / 189,
                    horizontal: width / 90,
                  ),
                      child: Text(
                        "Currently online Unavailable Kindly Request School Acccount Team",
                        style: TextStyle(fontWeight: FontWeight.w700,
                            fontSize: width / 25.714,
                            color: Colors.black),)),
                ),
                SizedBox(height: height / 50.4,),


              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
            },
                child: Text("Okay",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),))
          ],

        ));
  }


  warningpayment() {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return AwesomeDialog(
      width: width / 0.87111111,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Online Payment is Unavailable',
      desc: 'Currently online payment is Unavailable,Kindly contact school Accounts Team',


      btnOkOnPress: () {},
    )
      ..show();
  }


  List FirstTermexamList=[];
  List SecondexamList=[];
  List SubjectsList=[];
  List ExamnameList=[];
  List staffFeedbackList=[];



  int subjectcount=0;

  List MainList = List<List>.generate(15, (index) => []);



  int presentdayvalue=0;
  int absentdayvalue=0;
  int Totalvalue=0;

  PdfPrint(Schoolname,Schoollocated) async {
    print(Circlularprogrossvalue);
    print(Percentagevalue);
    print("Circleprogress indicators valuessssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
    setState((){
      FirstTermexamList.clear();
      SecondexamList.clear();
      SubjectsList.clear();
      ExamnameList.clear();
      staffFeedbackList.clear();
      Loading=true;
    });
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    ///Subject add function
    var studentdata=await _firestore2db.collection("ClassMaster").where("name",isEqualTo:Studentclass).get();

    for(int i=0;i<studentdata.docs.length;i++){
      var Sectiondata= await _firestore2db.collection("ClassMaster").doc(studentdata.docs[i].id).
      collection("Sections").doc("${Studentclass}${Studentsec}").collection("Subjects").orderBy("timestamp").get();
      setState(() {
        subjectcount=Sectiondata.docs.length;
      });
      for(int j=0;j<Sectiondata.docs.length;j++){
         setState(() {
           SubjectsList.add(Sectiondata.docs[j]['name']);
         });
      }
      print("_____________________________________________");
      print(SubjectsList);
    }

    ///exam master add function
    var examdata=await _firestore2db.collection("Students").doc(Studentid).collection("Exams").get();

    for(int i=0;i<examdata.docs.length;i++){
    setState(() {
      ExamnameList.add(examdata.docs[i]['name']);
    });
    }
    print(ExamnameList);
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    print(ExamnameList.length);

    ///matrix Functiuon

    print("Matrix funtion entereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    for(int i=0;i<SubjectsList.length;i++) {
      setState(() {
        MainList[i].clear();
      });
      for (int j = 0; j < ExamnameList.length; j++) {
        setState(() {
          MainList[i].add("");
        });
      }
    }

    print("empty List ==---------------------------------------------------- ");
    print(MainList);

    for(int i=0;i<SubjectsList.length;i++) {
      print("Sub Length");
      print(SubjectsList.length);
      for (int j = 0; j < ExamnameList.length; j++) {
        print("Exam Length");
        print(ExamnameList.length);
        var document = await _firestore2db.collection("Students").doc(Studentid).collection("Exams").get();
        print("Doc 1");
        print(document.docs.length);

        for (int m = 0; m < document.docs.length; m++) {
          print(document.docs[m]["name"]);
          print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
          var document2 = await _firestore2db.collection("Students").doc(Studentid).collection("Exams").
          doc(document.docs[m].id).collection("Timetable").get();
          print("Doc 2");
          print(document2.docs.length);
          for (int n = 0; n < document2.docs.length; n++) {
            print("Val of i ${i}");
            print("Val of j ${j}}");
            print("${document2.docs[n]['name']} isequal to ${SubjectsList[i]}");
            print("${document2.docs[n]['exam']} isequal to ${ExamnameList[j]}");
            print("${document2.docs[n]['mark']} is answer");
            print(document2.docs[n]['exam'].toString().length);
            print(ExamnameList[j].toString().length);
            if (document2.docs[n]['name'] == SubjectsList[i]) {
              if (document2.docs[n]['exam'] == ExamnameList[j]) {
                print("Done good===========================================");
                print(MainList[i][j]);
                setState(() {
                  MainList[i][j] = document2.docs[n]['mark'];
                });
                print(MainList[i][j]);
              }
            }
          }
        }
      }
    }

    print(MainList);
    print("Matrrix funtion___________________________________");

    ///Feed back

    var staffdocument= await _firestore2db.collection("Students").doc(Studentid).collection("Feedback").
    orderBy("timestamp", descending: true).get();
    for(int j=0;j<staffdocument.docs.length;j++){
      setState((){
        staffFeedbackList.add(Stafffeebackclass(
            staffname:staffdocument.docs[j]['staffname'],
          value:staffdocument.docs[j]['value'] ,
          date: staffdocument.docs[j]['date'],
          remarks:staffdocument.docs[j]['remarks'] ,
          time: staffdocument.docs[j]['time'],
        ));
      });

    }
    print(staffFeedbackList);
    print("staffFeedbackList Vlues--------------------------------------");




 


    List<p.Widget> widgets = [];
    // var fontsemipoppoins = await PdfGoogleFonts.poppinsSemiBold();
//Profile image
    final image = p.Image(
      await imageFromAssetBundle('assets/MarkBakcground.png'),
      fit: p.BoxFit.contain,
      height: 180,
      width:180


    );
    // final Clockimage = p.Image(
    //     await imageFromAssetBundle('assets/Clock Image.png'),
    //     fit: p.BoxFit.contain,
    //     height: 30,
    //     width:30
    //
    //
    // );

    final image2 = p.Image(
      await imageFromAssetBundle('assets/Tiles.png'),
      fit: p.BoxFit.contain,
        height: 500,
        width:500
    );


    final thumbupicon = p.Image(
        await imageFromAssetBundle('assets/icons8-thumbs-up-96 1.png'),
        fit: p.BoxFit.contain,
        height: 40,
        width:40
    );

    final LogoImage = p.Image(
      await imageFromAssetBundle('assets/Ellipse 239 Logo.png'),
      fit: p.BoxFit.contain,
      height: 100,
      width:100


    );

//container for profile image decoration
    final container = p.Center(
        child: p.Stack(
          alignment: p.Alignment.center,
            children: [
              p.Padding(
                padding: p.EdgeInsets.only(top: 0, left: 155),
                child: image,
              ),
              p.Padding(
                  padding: p.EdgeInsets.only(top: 0, left: 160),
                  child: p.Text(Studentname, style: p.TextStyle(
                    fontSize: width / 18,
                    //font: fontsemipoppoins,
                    color: PdfColors.white,
                  ))
              ),
              p.Padding(
                  padding: p.EdgeInsets.only(bottom: 45, left: 160),
                  child: p.Text(
                      "${Studentclass} ${Studentsec}", style: p.TextStyle(
                    fontSize: width / 18,
                    // font: fontsemipoppoins,
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


    final Circleindicator= p.Column(
      children: [
        p.Row(

          children: [
            p.SizedBox(width:15),

            p.Stack(
              alignment: p.Alignment.center,
              children: [
               p.SizedBox(
                 height:100,
                 width:100,
                 child: p.CircularProgressIndicator(
                   backgroundColor: PdfColors.red,
                   value:  Circlularprogrossvalue,
                   color: PdfColors.green,
                   strokeWidth: 15,
                 ),
               ),
               p.Text("${Percentagevalue.toStringAsFixed(2)}%"),
              ]
            ),
            p.SizedBox(width:15),

            p.Row(
              children: [
               p.Container(
                 child: p.Column(
                   crossAxisAlignment: p.CrossAxisAlignment.start,
                   children: [
                     p. Row(
                       children: [
                         p.Container(
                           height: height/37.8,
                           width: width/9,
                           decoration: p.BoxDecoration(
                               color: PdfColors.green,
                               borderRadius: p.BorderRadius.circular(5)
                           ),
                           child: p.Center(child: p.Text(presentvalue.toString(),
                             style: p.TextStyle(color: PdfColors.white),)),
                         ),
                         p.SizedBox(width: width/45,),
                         p.Text("Present",
                             style: p.TextStyle()),
                       ],
                     ),
                     p.SizedBox(height: height/75.6,),
                     p.Row(
                       children: [
                         p. Container(
                           height: height/37.8,
                           width: width/9,
                           decoration:p. BoxDecoration(
                               color: PdfColors.red,
                               borderRadius: p.BorderRadius.circular(5)
                           ),
                           child:p. Center(child: p.Text(Absentvalue.toString(),style: p.TextStyle(

                               color: PdfColors.white),)),
                         ),
                         p. SizedBox(width: width/45,),
                         p.Text("Absent",
                             style:p. TextStyle()),
                       ],
                     ),
                   ],
                 ),
               ),

                container,

              ]
            ),



          ],
        ),
      ]
    );

    final Tablecontainer=  p.Column(
      crossAxisAlignment: p.CrossAxisAlignment.start,
        children: [
          p.Row(
            children: [
              p.Container(
                  height:50,
                  width:50,
                  decoration: p.BoxDecoration(
                      color: PdfColor.fromHex("F7983E"),
                      border: p.Border.all(color: PdfColors.black)
                  ),
                  child: p.Center(
                    child:p. Text("Exm\n/Sub",textAlign:p.TextAlign.center,style: p.TextStyle(color: PdfColors.white)),
                  )
              ),
              for(int j=0;j<ExamnameList.length;j++)
              p.Container(
                  height:50,
                  width:80,
                  decoration: p.BoxDecoration(
                    color: PdfColor.fromHex("F7983E"),
                    border: p.Border.all(color: PdfColors.black)
                  ),
                  child: p.Center(
                    child:p. Text(ExamnameList[j].toString(),textAlign:p.TextAlign.center,style: p.TextStyle(color: PdfColors.white)),
                  )
              ),

            ]
          ),

              p.Row(
                children: [
                  p.Column(
                      children: [
                        for(int i=0;i<SubjectsList.length;i++)
                          p.Container(
                              height:50,
                              width:50,
                              decoration: p.BoxDecoration(
                                  color: PdfColor.fromHex("A75BF4"),
                                  border: p.Border.all(color: PdfColors.black)
                              ),
                              child: p.Center(
                                child:p. Text(SubjectsList[i].toString(),textAlign:p.TextAlign.center,style: p.TextStyle(color: PdfColors.white)),
                              )
                          ),
                      ]
                  ),
                  p.ListView.builder(
                    itemCount: SubjectsList.length,
                    itemBuilder: (context, index) {

                      return  p.ListView.builder(
                          direction: p.Axis.horizontal,
                          itemBuilder:(context,index2){
                        return  p.Container(
                            height:50,
                            width:80,
                            decoration: p.BoxDecoration(

                                border: p.Border.all(color: PdfColors.black)
                            ),
                            child: p.Center(
                              child:p. Text(MainList[index][index2].toString(),
                                  textAlign:p.TextAlign.center,style: p.TextStyle(color: PdfColors.black)),
                            )
                        );
                      },

                          itemCount: ExamnameList.length);
                    },

                  ),

                ]
              ),















    ]
    );





    final TotalContainer=p.Row(
      mainAxisAlignment: p.MainAxisAlignment.spaceAround,
      children: [

        ///Total
       p.Container(
           height:20,
         width:100,
         decoration: p.BoxDecoration(
           borderRadius: p.BorderRadius.circular(5),
           border: p.Border.all(
             color: PdfColors.black
           )
         ),
         child:p.Row(
           children: [
             p.Container(
                 height:20,
               width:50,
               decoration: p.BoxDecoration(
                   borderRadius: p.BorderRadius.circular(5),
                   color: PdfColor.fromHex("A75BF4"),
                   border: p.Border.all(
                       color: PdfColors.black
                   )
               ),
                 child: p.Center(
                     child: p.Text("537",style: p.TextStyle(color: PdfColors.white))
                 )
             ),
             p.SizedBox(
                 height:20,
                 width:50,
               child: p.Center(
                 child: p.Text("Total",style: p.TextStyle())
               )
             )
           ]
         )
       ),
///percentage
        p.Container(
            height:20,
            width:140,
            decoration: p.BoxDecoration(
                borderRadius: p.BorderRadius.circular(5),
                border: p.Border.all(
                    color: PdfColors.black
                )
            ),
            child:p.Row(
                children: [
                  p.Container(
                      height:20,
                      width:50,
                      decoration: p.BoxDecoration(
                          borderRadius: p.BorderRadius.circular(5),
                          color: PdfColor.fromHex("F7983E"),
                          border: p.Border.all(
                              color: PdfColors.black
                          )
                      ),
                      child: p.Center(
                          child: p.Text("90",style: p.TextStyle(color: PdfColors.white))
                      )
                  ),
                  p.SizedBox(
                      height:20,
                      width:80,
                      child: p.Center(
                          child: p.Text("Percentage",style: p.TextStyle())
                      )
                  )
                ]
            )
        ),

        ///Grade
        p.Container(
            height:20,
            width:100,
            decoration: p.BoxDecoration(
                borderRadius: p.BorderRadius.circular(5),
                border: p.Border.all(
                    color: PdfColors.black
                )
            ),
            child:p.Row(
                children: [
                  p.Container(
                      height:20,
                      width:50,
                      decoration: p.BoxDecoration(
                          borderRadius: p.BorderRadius.circular(5),
                          color: PdfColor.fromHex("5B98F4"),
                          border: p.Border.all(
                              color: PdfColors.black
                          )
                      ),
                      child: p.Center(
                          child: p.Text("A+",style: p.TextStyle(color: PdfColors.white))
                      )
                  ),
                  p.SizedBox(
                      height:20,
                      width:50,
                      child: p.Center(
                          child: p.Text("Grade",style: p.TextStyle())
                      )
                  )
                ]
            )
        ),

        ///Rank

        p.Container(
            height:20,
            width:100,
            decoration: p.BoxDecoration(
                borderRadius: p.BorderRadius.circular(5),
                border: p.Border.all(
                    color: PdfColors.black
                )
            ),
            child:p.Row(
                children: [
                  p.Container(
                      height:20,
                      width:50,
                      decoration: p.BoxDecoration(
                          borderRadius: p.BorderRadius.circular(5),
                          color: PdfColor.fromHex("F73E3E"),
                          border: p.Border.all(
                              color: PdfColors.black
                          )
                      ),
                      child: p.Center(
                          child: p.Text("A+",style: p.TextStyle(color: PdfColors.white))
                      )
                  ),
                  p.SizedBox(
                      height:20,
                      width:60,
                      child: p.Center(
                          child: p.Text("Rank",style: p.TextStyle())
                      )
                  )
                ]
            )
        ),
      ],
    );


    final Contents=p.Container(
      height: 841,
      padding: p.EdgeInsets.all(20),
      child:p.Center(
        child: p.Column(
            mainAxisAlignment: p.MainAxisAlignment.start,
            crossAxisAlignment: p.CrossAxisAlignment.center,
            children: [
              p.SizedBox(height: 10),
              LogoImage,
              p.SizedBox(height: 5),
              p.Text(Schoolname),
              p.SizedBox(height: 5),
              p.Text(Schoollocated),
              p.SizedBox(height: 20),
              Circleindicator,
               p.SizedBox(height: 15),
              p.Row(
                children: [
                  p.Text("Exam Reports"),
                ]
              ),
               p.SizedBox(height: 15),
               Tablecontainer,
               p.SizedBox(height: 30),
               TotalContainer,
               p.SizedBox(height: 20),
            ]
        )
      )
    );



    final staffeedback=
    p.Container(
        height: 841,
        padding: p.EdgeInsets.all(20),
      child:p.Column(
          children: [
            p.SizedBox(height: 20),
            p.Container(
              width:100,
          height:100,
          child:  LogoImage),
            p.SizedBox(height: 5),
            p.Text(Schoolname),
            p.SizedBox(height: 5),
            p.Text(Schoollocated),
            p.SizedBox(height: 20),

            p.Stack(
              children: [
                image2,

          ///container-1
          p.Padding(
            padding: p.EdgeInsets.only(left:30,top:40),
            child: p.Container(
                width:110,
                height:60,
                child: p.Text("Your are good at \nMaths and \nSocial",
                 )
            )
          ),
                ///container-2
                p.Padding(
                    padding: p.EdgeInsets.only(left:30,top:160),
                    child: p.Container(
                        width:110,
                        height:60,
                        child: p.Text("You need to\nImprove your\nLanguage skills",)
                    )
                ),
                ///contaner-3

                p.Padding(
                    padding: p.EdgeInsets.only(left:370,top:40),
                    child: p.Container(
                        width:110,
                        height:60,
                        child: p.Text("Your are weak at tamil and\nenglish")
                    )
                ),


                ///container-4
                p.Padding(
                    padding: p.EdgeInsets.only(left:370,top:160),
                    child: p.Container(
                        width:110,
                        height:60,
                        child: p.Text("Low marks\nin Tamil will\nresult bad in finals")
                    )
                ),
              ]
            ),

            p.SizedBox(height: 20),
            p.Row(
                children: [
                  p.Text("Staff's Feedback"),
                ]
            ),

            p.SizedBox(height: 20),

            p.ListView.builder(
              itemCount: staffFeedbackList.length,
              itemBuilder:(context, index) {
                return
                  p.Padding(
                      padding: p.EdgeInsets.only(bottom:8),
                      child:p.Container(
                          height:50,
                          width:550,
                          decoration: p.BoxDecoration(
                              border: p.Border.all(
                                  color: PdfColor.fromHex("40C502")
                              ),
                              borderRadius: p.BorderRadius.circular(8)
                          ),

                          child:p.Row(
                              crossAxisAlignment: p.CrossAxisAlignment.center,
                              children: [
                                p.SizedBox(width: 10),
                                p.SizedBox(
                                  height:50,
                                  width:50,
                                  child:thumbupicon,
                                ),
                                p.SizedBox(width: 10),
                                p.SizedBox(
                                    height:50,
                                    width:300,
                                    child:  p.Column(
                                        crossAxisAlignment: p.CrossAxisAlignment.start,
                                        mainAxisAlignment: p.MainAxisAlignment.spaceAround,
                                        children: [
                                          p.SizedBox(height:8),
                                          p.Text(staffFeedbackList[index].value.toString()),
                                          p.SizedBox(height:5),
                                          p.Text(staffFeedbackList[index].remarks.toString()),
                                          p.SizedBox(height:8),
                                        ]
                                    )
                                ),
                                p.Column(
                                    mainAxisAlignment: p.MainAxisAlignment.end,
                                    children: [
                                      p.Row(
                                          crossAxisAlignment: p.CrossAxisAlignment.end,
                                          children: [
                                            p.Container(
                                              width:70,
                                              child: p.Text(staffFeedbackList[index].staffname.toString()),
                                            ),
                                            p.SizedBox(width:2),
                                            p.Container(
                                              width:15,
                                              height:15,

                                            ),
                                            p.SizedBox(width:2),

                                            p.Container(
                                              width:70,
                                              child: p.Text(staffFeedbackList[index].date.toString()),
                                            ),
                                          ]
                                      ),
                                      p.SizedBox(height:8),
                                    ]
                                )


                              ]
                          )
                      )
                  );
              },  ),

            p.SizedBox(height: 20),



          ]
      )
    );

print("Goog Morning _________________________________________________________________");

   widgets.add(Contents);
    widgets.add(staffeedback);

    widgets.add(p.SizedBox(height: 0)); //some space beneath image

//add all other data which may be in the form of list
//use a loop to create pdf widget and add it to list
//one by one


//pdf document
    final pdf = p.Document();
    pdf.addPage(
      p.MultiPage(
        margin: p.EdgeInsets.zero,
        pageFormat: PdfPageFormat.a4,
        build: (context) => widgets, //here goes the widgets list
      ),
    );
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    setState(() {
      Loading=false;
    });
  }


}

class Stafffeebackclass{
  String ?remarks;
  String ?date;
  String ?staffname;
  String ?time;
  String ?value;


  Stafffeebackclass({this.remarks,this.date,this.staffname,this.time,this.value,});

}




FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(
    app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);