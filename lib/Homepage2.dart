import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:vidhaan_school_app/account_page.dart';
import 'package:http/http.dart' as http;
import 'Notifications.dart';
import 'Profileview.dart';
import 'Root_Page2.dart';
import 'Root_Page3.dart';
import 'Root_Page4.dart';
import 'Root_page.dart';
import 'Today Presents_Page.dart';
import 'const_file.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'exam.dart';
import 'feedback history.dart';
import 'package:pdf/widgets.dart' as p;
import 'package:printing/printing.dart';
import 'package:vidhaan_school_app/modules/home/controllers/home_controller.dart';





class Frontpage extends StatefulWidget {


  @override
  State<Frontpage> createState() => _FrontpageState();
}

class _FrontpageState extends State<Frontpage> with SingleTickerProviderStateMixin {


  String? _selectedLocation;


  int tabar = 1;

  final GlobalKey <ScaffoldState> key = GlobalKey();

  int currentDate = 0;
  int cyear = 0;
  String cmonth = "";
  String day = "";
  String month = "";

  TextEditingController Searchcontroller = TextEditingController();


  String getMonth(int currentMonthIndex) {
    return DateFormat('MMM').format(DateTime(0, currentMonthIndex)).toString();
  }

  List Period = [];


  List mondaylists = [0,1,2,3,4,5,6,7];
  List tueslists = [8,9,10,11,12,13,14,15];
  List wedneslists = [16,17,18,19,20,21,22,23];
  List thurslists = [24,25,26,27,28,29,30,31];
  List Fridaylists = [32,33,34,35,36,37,38,39];
  List Satlists = [40,41,42,43,44,45,46,47];


  showwwaring(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
        width: width/0.8,
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Instructions',
        desc: "Image Should be clear and visible  \nImage should be less than 2MB\nAll images formats are accepted\n",


        descTextStyle: TextStyle(

        ),

        btnOkOnPress: () {

        },

    )..show();


  }
  revokedshow(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
        width: width/0.8,
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Leave Successfully Revoked',
        descTextStyle: TextStyle(

        ),

        btnOkOnPress: () {

        },

    )..show();


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

    if (day == "Monday") {
      for (int i = 0; i < mondaylists.length; i++) {
        setState(() {
          Period.add(mondaylists[i]);
        });
      }
      print(Period);
    }
    else if (day == "Tuesday") {
      for (int i = 0; i < Fridaylists.length; i++) {
        setState(() {
          Period.add(tueslists[i]);
        });
      }
      print(Period);
    }
   else if (day == "Wednesday") {
      for (int i = 0; i < Fridaylists.length; i++) {
        setState(() {
          Period.add(wedneslists[i]);
        });
      }
      print(Period);
    }
   else if (day == "Thursday") {
      for (int i = 0; i < Fridaylists.length; i++) {
        setState(() {
          Period.add(thurslists[i]);
        });
      }
      print(Period);
    }
  else  if (day == "Friday") {
      for (int i = 0; i < Fridaylists.length; i++) {
        setState(() {
          Period.add(Fridaylists[i]);
        });
      }
      print(Period);
    }
  }

  @override
  void initState() {
    print("Home Page 2");

    getstaffdetails();
    Date();
    dayfun();
    adddropdownvalue();


    super.initState();
  }

  setval() {
    setState(() {
      page = "Attendance";
    });
  }

  setval2() {
    setState(() {
      page = "Home Works";
    });
  }

  setval3() {
    setState(() {
      page = "Behaviour";
    });
  }

  setval4() {
    setState(() {
      page = "Circulars";
    });
  }

  setval5() {
    setState(() {
      page = "Time Table";
    });
  }

  setval6() {
    setState(() {
      page = "Messages";
    });
  }

  bool isSelected = false;
  int Selectedindex = 0;
  bool isSelectedy = false;


  bool isSelectedb = false;
  String staffid = "";
  String staffname = "";
  String staffregno = "";
  String staffimg = "";
  String staffphono = "";
  String staffauthendicationid = "";

  getstaffdetails() async {
    var document = await _firestore2db.collection("Staffs").get();
    for (int i = 0; i < document.docs.length; i++) {
      if (document.docs[i]["userid"] == _firebaseauth2db.currentUser!.uid) {
        setState(() {
          staffid = document.docs[i].id;
          staffauthendicationid = document.docs[i]['userid'];
        });
        print("Saffid:${staffid}");
        print(staffid);
      }
    };

    var staffdocument = await _firestore2db.collection("Staffs")
        .doc(staffid)
        .get();
    Map<String, dynamic>?staffvalue = staffdocument.data();
    setState(() {
      staffname = staffvalue!['stname'];
      staffregno = staffvalue['regno'];
      staffimg = staffvalue['imgurl'];
      staffphono = staffvalue['mobile'];
    });

    print("staffname stff id staff img");
    print("Home PAge 2");
    print(staffname);
    print(staffregno);
    print(staffimg);
  }


  String? _selectedCity;
  final TextEditingController _typeAheadControllerclass = TextEditingController();
  final TextEditingController _typeAheadControllersection = TextEditingController();
  final TextEditingController duedate = TextEditingController();
  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();
  static final List<String> classes = [];
  static final List<String> section = [];
  static final List<String> subjects = [];
  static final List<String> leave = ["Leave Type","Casual leave","Medical leave","Earned leave","Commuted leave"];

  String dropdownValue4 = "Class";
  String dropdownValue5 = "Section";
  String subject = "Subject";
  String leavetype = "Leave Type";


  adddropdownvalue() async {
    print("hello");
    setState(() {
      classes.clear();
      section.clear();
      subjects.clear();
    });
    var document = await _firestore2db.collection("ClassMaster").orderBy(
        "order").get();
    var document2 = await _firestore2db.collection("SectionMaster").orderBy(
        "order").get();
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
    var documentsub = await _firestore2db.collection("SubjectMaster").orderBy(
        "order").get();
    setState(() {
      subjects.add("Subject");
    });
    for (int i = 0; i < documentsub.docs.length; i++) {
      setState(() {
        subjects.add(documentsub.docs[i]["name"]);
      });
    }
  }


  final DateFormat formatter = DateFormat('dd / M / yyyy');
  String formattedDate = '${DateTime
      .now()
      .day}${DateTime
      .now()
      .month}${DateTime
      .now()
      .year}';
  int dates = DateTime
      .now()
      .day;
  int year = DateTime
      .now()
      .year;
  int month2 = DateTime
      .now()
      .month;
  String selectdate = '';

  final present = List<bool>.generate(1000, (int bool) => true, growable: true);

  String page = "Home";

  int pageselected = 0;

  List<String>  Homesearclist=[
    "Attendance",
    "Assignments",
    "Feedback",
    "Circulars",
    "Time Table",
    "Check-In/Out",
    "Payroll",
    "LTP",
    "Groups"

  ];

  bool search=false;

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


    List<Widget> widgetlist=[
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
      ///Feed Back
      Icon(Icons.person_outline,
          color: Color(
              0xffA021FF),
          size: width / 12),
      ///Circulars
      Icon(
        Icons.note_alt_outlined,
          color: Color(
              0xffFECE3E),
          size: width / 12),
      ///Time Table
      Icon(Icons.timer_outlined,
          color: Color(0xff224FFF),
          size: width / 12),

      ///check In
      Icon(
        Icons.input_rounded,
        color: Color(
            0xff609F00),
        size: width / 12,),
      ///payroll
      Icon(
        Icons.payment_rounded,
        color: Color(
            0xff609F00),
        size: width / 12,),

      ///leave
      Icon(Icons.sick_rounded,
          color: Color(
              0xffFECE3E),
          size: width / 12),
      ///Groups
      Icon(Icons.message_sharp,
        color: Color(0xffA021FF),
        size: width / 12,),
    ];

    return Scaffold(
      key: key,
      backgroundColor: Color(0xff0873C4),
      endDrawer: Drawer(
        backgroundColor: Color(0xff0873C4),

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height / 25.2),


              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Stack(
                        children: [

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Padding(
                                padding: EdgeInsets.only(
                                    top: height / 25.745, left: width / 40.4),
                                child: GestureDetector(
                                  onTap: (){
                                    print("Height r============" + height.toString());
                                    print("Width ==============" + width.toString());
                                  },
                                  child: InkWell(
                                      onTap:(){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=>Profileview2(staffimg))
                                      );},
                                    child: Container(
                                      width: width/3.26666667,
                                      height: height/6.525,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.white,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                          staffimg,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: height/156.6,),

                              Padding(
                                padding: EdgeInsets.only(left: width / 10),
                                child: Text(
                                  staffname, style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: width/17.81818182,
                                    fontWeight: FontWeight.bold

                                ),),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 15),
                                child: Text("ID : ${staffregno}",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: width / 22.5,
                                      fontWeight: FontWeight.w500

                                  ),),
                              )


                            ],
                          ),

                          Positioned(
                            bottom: height / 13.45, left: width / 3.6,
                            child: GestureDetector(
                              onTap: () {
                                showedit();
                                print("Edit");
                              },
                              child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.create_outlined,
                                    color: Colors.black, size: height/30.11538462,)
                              ),
                            ),
                          )

                        ]
                    ),
                  ),

                ],
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Root_Page(),));

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


             /* GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Root_Page2(),));

                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.message, color: Colors.white,),
                    title: Text("Message", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 22.5)),
                  ),
                ),
              ),

              */


              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Exams(),));

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


              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Root_Page4(),));

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

              GestureDetector(
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
                        fontSize: width / 23.5)),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    page = "Home Works";
                  });
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.note_alt, color: Colors.white,),
                    title: Text("Assignment", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 23.5)),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    page = "Behaviour";
                  });
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.person_outline, color: Colors.white,),
                    title: Text("Feedback", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 23.5)),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    page = "Circulars";
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
                        fontSize: width / 23.5)),
                  ),
                ),
              ),


              GestureDetector(
                onTap: () {
                  setState(() {
                    page = "Time Table";
                  });
                  timetablelogic();
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.timer_outlined, color: Colors.white,),
                    title: Text("Time Table", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 23.5)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    page = "Leave";
                  });
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.sick_outlined, color: Colors.white,),
                    title: Text("LTP", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 23.5)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    page = "Payroll";
                  });
                  key.currentState!.closeEndDrawer();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.payment_rounded, color: Colors.white,),
                    title: Text("Payroll", style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 23.5)),
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
      body:

      WillPopScope(
        onWillPop: () {
          if (page == "Home") {
            demo();
            Searchcontroller.clear();
          }
          else {
            setState(() {
              page = "Home";
              Searchcontroller.clear();
            });
            print("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
          }
          return demo2();
        },
        child:
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 700),
                curve: Curves.ease,
                height: page == "Home" &&Searchcontroller.text==""? height / 2.055 :
                page == "Attendance" ? height / 3.63 :
                page == "Home Works" ? height / 3.63 :
                page == "Behaviour" ? 76.123 :
                page == "Circulars" ? 76.123 :
                page == "Time Table" ? 76.123 :
                page == "Payroll" ? 76.123 :
                page == "Leave" ? 76.123 :
                page == "Messages" ? 76.123 :
                Searchcontroller.text!=""&& page == "Home"?height / 3.63:0,


                child: page == "Circulars" || page == "Behaviour" ||
                    page == "Time Table" || page == "Messages" ||
                    page == "Payroll" || page == "Leave" ? Container() :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    page == "Attendance" || page == "Home Works"
                        ? Container()
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: EdgeInsets.only(
                              left: width / 36,
                              right: width / 36,
                              top: height / 15.12),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap:(){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context)=>Profileview2(staffimg))
                                  );
                                  },
                                child: Container(
                                  width: width/4.9,
                                  height: height/9.7875,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                      staffimg,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width:width/39.2),
                              Container(
                                width:width/2.06315789,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hi ${staffname}",
                                      style: GoogleFonts.poppins(

                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: width/15.68),
                                      overflow: TextOverflow.ellipsis,
                                        
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left:0),
                                      child: Text(
                                        "ID : ${staffregno}",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: width/21.77777778),
                                      ),
                                    ),
                                  ],
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
                                  GestureDetector(
                                    onTap: () {
                                      key.currentState!.openEndDrawer();
                                    },
                                    child: Container(
                                        height: height / 20.47,
                                        width: width / 10.333,
                                        decoration: BoxDecoration(

                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                5)),
                                        child:
                                        Icon(Icons.menu_sharp,
                                            color: Colors.white)),
                                  ),
                                ],
                              ),

                              /// two image containers
                            ],
                          ),
                        ), // headline

                        //
                      ],
                    ),


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: height / 368.5), // id
                        SizedBox(height: height / 20.566,),


                        Divider(
                          color: Colors.white,
                          thickness: 1.5,
                          endIndent: 10,
                          indent: 10,
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              left: width / 36, right: width / 36, top: height /
                              50.4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "This week",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: width/19.6),
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
                                      child:
                                      Icon(Icons.calendar_month_outlined,
                                          color: Color(0xffffffff))),
                                  SizedBox(width: width / 150),
                                  Text(
                                    "${cmonth.toString()} ${cyear.toString()}",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: width/20.63157895),
                                  ),
                                ],
                              ),

                              /// current year
                            ],
                          ),
                        ),

                        SizedBox(height: height / 48),

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


                        SizedBox(height: height / 30.33),


                        Container(

                          height: height/756,
                          width: width / 0.947,
                          color: Colors.white,

                        )

                      ],
                    ),

                  ],
                ),
              ),

              SizedBox(height: height / 123.125),

              Stack(
                children: [

                  Container(
                    height: height / 24.566,
                    width: double.infinity,
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                        top: height / 25.2),
                    child: Container(
                        height:
                        page == "Home" ? height / 1.474 : height / 1.1338,

                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(35),
                                topLeft: Radius.circular(35))),
                          child: page == "Home"
                            ? Padding(
                          padding: EdgeInsets.only(top: Searchcontroller.text!=""?height / 250.12:height / 20.12),
                          child: Searchcontroller.text==""?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0.0,
                                    left: width / 45,
                                    bottom: height / 46.12),
                                child: Text(
                                  "Dashboard",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff0873C4),
                                      fontSize: width/17.81818182,
                                      fontWeight:
                                      FontWeight.w700),
                                ),
                              ),
                              ExpandablePageView(
                                children: [
                                  Container(
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
                                                    page = "Attendance";
                                                    Searchcontroller.clear();
                                                  });
                                                  print("Attendance");
                                                },
                                                child: Container(
                                                  width: width/3.56363636,
                                                  height: height/11.18571429,

                                                  child: Column(
                                                    children: [
                                                      Icon(Icons
                                                          .calendar_month_outlined,
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
                                                          "Attendance",
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

                                              /// Attendance

                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    page = "Home Works";
                                                    Searchcontroller.clear();
                                                  });
                                                  print("Attendance");
                                                },
                                                child: Container(
                                                  width: width/3.56363636,
                                                  height: height/11.18571429,
                                                  child: Column(
                                                    children: [

                                                      Icon(Icons.note_alt_sharp,
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
                                                          "Assignment",
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
                                                    page = "Behaviour";
                                                    Searchcontroller.clear();
                                                  });
                                                  print("Behaviour");
                                                },
                                                child: Container(
                                                  width: width/3.56363636,
                                                  height: height/11.18571429,
                                                  child: Column(
                                                    children: [
                                                      Icon(Icons.person_outline,
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
                                                          "Feedback",
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

                                              ///  behaviour
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: height / 18.9),

                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  page = "Circulars";
                                                  Searchcontroller.clear();
                                                });
                                                print("Circulars");
                                              },
                                              child: Container(
                                                width: width/3.56363636,
                                                height: height/11.18571429,
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                        Icons.note_alt_outlined,
                                                        color: Color(
                                                            0xffFECE3E),
                                                        size: width / 12),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: width / 45,
                                                          right: width / 45,
                                                          top: height / 94.5,
                                                          bottom: height /
                                                              94.5),
                                                      child: Text(
                                                        "Circulars",
                                                        style: GoogleFonts
                                                            .poppins(
                                                            color: Colors.black,
                                                            fontSize: width/28,
                                                            fontWeight:
                                                            FontWeight.w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            /// circulars

                                            InkWell(
                                              onTap: () {

                                                setState(() {
                                                  page = "Time Table";
                                                  Searchcontroller.clear();
                                                });
                                                timetablelogic();
                                                print("Time Table");
                                              },
                                              child: Container(
                                                width: width/3.56363636,
                                                height: height/11.18571429,
                                                child: Column(
                                                  children: [
                                                    Icon(Icons.timer_outlined,
                                                        color: Color(
                                                            0xff224FFF),
                                                        size: width / 12),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: width / 45,
                                                          right: width / 45,
                                                          top: height / 94.5,
                                                          bottom: height /
                                                              94.5),
                                                      child: Text(
                                                        "Time Table",
                                                        style: GoogleFonts
                                                            .poppins(
                                                            color: Colors.black,
                                                            fontSize: width/28,
                                                            fontWeight:
                                                            FontWeight.w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            /// attendance
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  page = "CheckIn";
                                                  Searchcontroller.clear();
                                                });
                                              },
                                              child: Container(
                                                width: width/3.56363636,
                                                height: height/8.7,

                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.input_rounded,
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
                                                              90.5),
                                                      child: Text(
                                                        "Check - IN / \nOUT",
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


                                            /// messages
                                          ],
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
                                                    page = "Payroll";
                                                    Searchcontroller.clear();
                                                  });
                                                  print("Payroll");
                                                },
                                                child: Container(
                                                  width: width/3.56363636,
                                                  height: height/11.18571429,

                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.payment_rounded,
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
                                                          "Payroll",
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

                                              /// Attendance

                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    page = "Leave";
                                                    Searchcontroller.clear();
                                                  });
                                                  print("Leave");
                                                },
                                                child: Container(
                                                  width: width/3.56363636,
                                                  height: height/11.18571429,
                                                  child: Column(
                                                    children: [

                                                      Icon(Icons.sick_rounded,
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
                                                          "LTP",
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
                                                    page = "Messages";
                                                    Searchcontroller.clear();
                                                  });
                                                  print("Messages");
                                                },
                                                child: Container(
                                                  width: width/3.56363636,
                                                  height: height/11.18571429,
                                                  child: Column(
                                                    children: [
                                                      Icon(Icons.message,
                                                          color: Color(0xffA021FF),
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
                                                          "Groups",
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

                                              ///  behaviour
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: height / 18.9),


                                      ],
                                    ),
                                  ),
                                ],
                              ),


                            ],


                          ):
                          SingleChildScrollView(
                            physics: const ScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:Homesearclist.length,
                                  shrinkWrap: true,
                                  itemBuilder:(context, index) {

                                    if( Homesearclist[index].toString().toLowerCase().contains(Searchcontroller.text.toLowerCase()))
                                    {
                                      return  InkWell(
                                        onTap:(){

                                          if(Homesearclist[index]=="Attendance"){
                                            setState((){
                                              page="Attendance";
                                              Searchcontroller.clear();
                                            });
                                          }
                                          if(Homesearclist[index]=="Assignments"){
                                            setState((){
                                              page="Home Works";
                                              Searchcontroller.clear();
                                            });
                                          }
                                          if(Homesearclist[index]=="Feedback"){
                                            setState((){
                                              page="Behaviour";
                                              Searchcontroller.clear();
                                            });
                                          }
                                          if(Homesearclist[index]=="Time Table"){
                                            setState((){
                                              page="Time Table";
                                              Searchcontroller.clear();
                                            });
                                            timetablelogic();
                                          }
                                          if(Homesearclist[index]=="Circulars"){
                                            setState((){
                                              page="Circulars";
                                              Searchcontroller.clear();
                                            });
                                          }
                                          if(Homesearclist[index]=="Check-In/Out"){
                                            setState((){
                                              page="CheckIn";
                                              Searchcontroller.clear();
                                            });
                                          }
                                          if(Homesearclist[index]=="Payroll"){
                                            setState((){
                                              page="Payroll";
                                              Searchcontroller.clear();
                                            });
                                          }
                                          if(Homesearclist[index]=="LTP"){
                                            setState((){
                                              page="Leave";
                                              Searchcontroller.clear();
                                            });

                                          }
                                          if(Homesearclist[index]=="Groups"){
                                            setState((){
                                              page="Messages";
                                              Searchcontroller.clear();
                                            });

                                          }

                                        },
                                        child: Padding(
                                          padding:  EdgeInsets.only(

                                              bottom:height/184.5,
                                              top:height/64.5,
                                              left: width/45,
                                              right: width/45
                                          ),
                                          child: Material(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Color(0xffF9F9F9),
                                            elevation:2,
                                            child: Container(
                                              height:height/14.45,
                                              width:width/1.028,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Color(0xffF9F9F9),

                                              ),

                                              child: Container(
                                                width: width/3.56363636,
                                                height: height/11.18571429,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width:width/8.0),
                                                    widgetlist[index],
                                                    SizedBox(width:width/10.0),
                                                    Padding(
                                                      padding: EdgeInsets.only(

                                                          top: height / 94.5,
                                                          bottom: height / 94.5),
                                                      child: Text(
                                                        Homesearclist[index].toString(),
                                                        style: GoogleFonts.poppins(
                                                            color: Colors.black,
                                                            fontSize: width/25.714,
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

                                  }, ),
                                SizedBox(height:height/15.12),

                              ],
                            ),
                          )

                        )
                            : page == "Circulars"
                            ? Padding(
                          padding: EdgeInsets.only(
                              left: width / 36, right: width / 36, top: height /
                              12.6),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      page = "Home";
                                      Searchcontroller.clear();
                                    });
                                  },
                                  child: Text(
                                    "Circulars",
                                    style: GoogleFonts.poppins(
                                        color: Color(0xff0873C4),
                                        fontSize: width/21.77777778,
                                        fontWeight: FontWeight.w600),
                                  ),
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

                                StreamBuilder(
                                    stream: _firestore2db.collection(
                                        "Circulars").orderBy("timestamp",descending: true).snapshots(),

                                    builder: (context, snapshot) {
                                      if (snapshot.hasData == null) {
                                        return Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xff0873c4),
                                            ));
                                      }
                                      if (!snapshot.hasData) {
                                        return Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xff0873c4),
                                            ));
                                      }
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                         return
                                           Searchcontroller.text==""&&snapshot.data!.docs[index]["type"].toString().toLowerCase()!="Student".toString().toLowerCase()?
                                           Container(

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
                                                           width: width / 60),
                                                       Container(
                                                         width: width / 1.3,
                                                         child: Text(
                                                           snapshot.data!
                                                               .docs[index]["Descr"],
                                                           style:
                                                           GoogleFonts.poppins(
                                                               color:
                                                               Colors.black,
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
                                                       height: height / 73.7),
                                                   Text(
                                                     snapshot.data!
                                                         .docs[index]["reason"],
                                                     style: GoogleFonts
                                                         .poppins(
                                                         color: Colors.black,
                                                         fontSize: width/26.13333333,
                                                         fontWeight:
                                                         FontWeight.w500),
                                                   ),
                                                   SizedBox(height: height/78.3),
                                                   Row(
                                                     mainAxisAlignment:
                                                     MainAxisAlignment
                                                         .start,
                                                     children: [
                                                       Container(
                                                         width: width / 3.8,
                                                         child: Text(
                                                           snapshot.data!
                                                               .docs[index]["Date"],

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
                                                       ),

                                                       Padding(
                                                         padding: const EdgeInsets.only(right: 8.0),
                                                         child: Container(
                                                           height:
                                                           height / 49.133,
                                                           width: width / 170,
                                                           color: Colors.grey,
                                                         ),
                                                       ),

                                                       Container(
                                                         width: width / 2.6,
                                                         child: Text(
                                                           snapshot.data!
                                                               .docs[index]["Time"],
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
                                                       ),
                                                       Text(
                                                         snapshot.data!
                                                             .docs[index]["From"],

                                                         style:
                                                         GoogleFonts.poppins(
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

                                           ) :
                                           snapshot.data!.docs[index]["type"].toString().toLowerCase()!="Student".toString().toLowerCase()&&snapshot.data!.docs[index]["Descr"].toString().toLowerCase().contains(Searchcontroller.text.toLowerCase()) ||
                                               snapshot.data!.docs[index]["type"].toString().toLowerCase()!="Student".toString().toLowerCase()&& snapshot.data!.docs[index]["Date"].toString().toLowerCase().contains(Searchcontroller.text.toLowerCase()) ||
                                               snapshot.data!.docs[index]["type"].toString().toLowerCase()!="Student".toString().toLowerCase()&& snapshot.data!.docs[index]["From"].toString().toLowerCase().contains(Searchcontroller.text.toLowerCase())
                                               ?
                                           Container(

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
                                                           width: width / 60),
                                                       Container(
                                                         width: width / 1.3,
                                                         child: Text(
                                                           snapshot.data!
                                                               .docs[index]["Descr"],
                                                           style:
                                                           GoogleFonts.poppins(
                                                               color:
                                                               Colors.black,
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
                                                       height: height / 73.7),
                                                   Text(
                                                     snapshot.data!
                                                         .docs[index]["reason"],
                                                     style: GoogleFonts
                                                         .poppins(
                                                         color: Colors.black,
                                                         fontSize: width/26.13333333,
                                                         fontWeight:
                                                         FontWeight.w500),
                                                   ),
                                                   SizedBox(height: height/78.3),
                                                   Row(
                                                     mainAxisAlignment:
                                                     MainAxisAlignment
                                                         .spaceBetween,
                                                     children: [
                                                       Text(
                                                         snapshot.data!
                                                             .docs[index]["Date"],

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
                                                           width:
                                                           width / 33.33),
                                                       Container(
                                                         height:
                                                         height / 49.133,
                                                         width: width / 170,
                                                         color: Colors.grey,
                                                       ),
                                                       SizedBox(
                                                           width:
                                                           width / 33.33),
                                                       Text(
                                                         snapshot.data!
                                                             .docs[index]["Time"],
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
                                                       Text(
                                                         snapshot.data!
                                                             .docs[index]["From"],

                                                         style:
                                                         GoogleFonts.poppins(
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

                                           ): SizedBox();


                                          }
                                      );
                                    }
                                ),

                                ///   circular container

                                SizedBox(height: height / 5.0),


                              ],
                            ),
                          ),
                        )
                            : page == "Home Works"
                            ? Padding(
                          padding: EdgeInsets.only(
                              left: width / 36, right: width / 36, top: height /
                              15.12),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      page = "Home";
                                      Searchcontroller.clear();
                                    });
                                  },
                                  child: Text(
                                    "Assignment",
                                    style: GoogleFonts.poppins(
                                        color: Color(0xff0873C4),
                                        fontSize: width/21.77777778,
                                        fontWeight:
                                        FontWeight.w600),
                                  ),
                                ),

                                Row(
                                  children: [
                                    Text(
                                      "${DateFormat.yMMMd().format(DateTime.now())}",
                                      style: GoogleFonts.poppins(
                                          color: Colors
                                              .grey.shade700,
                                          fontSize: width/26.13333333,
                                          fontWeight:
                                          FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: width / 33.33,
                                    ),
                                    Container(
                                      height: height / 49.133,
                                      width: width / 170,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: width / 33.33,
                                    ),
                                    Text(
                                      day,
                                      style: GoogleFonts.poppins(
                                          color: Colors
                                              .grey.shade700,
                                          fontSize: width/26.13333333,
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

                                Column(


                                    children: [
                                      SizedBox(height: height / 773.7),


                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceAround,
                                        children: [

                                          Container(
                                            padding: EdgeInsets.only(
                                                left: width / 36,
                                                right: width / 36),
                                            height: height / 14.74,
                                            width: width / 2.363,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .shade300),
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            child:
                                            DropdownButton2<String>(
                                              value: dropdownValue4,
                                              isExpanded: true,
                                              style: TextStyle(
                                                  color: Color(0xff3D8CF8),
                                                  fontSize: width/23.05882353,
                                                  fontWeight: FontWeight.w700),
                                              underline: Container(
                                                color: Colors.deepPurpleAccent,
                                              ),
                                              onChanged: (String? value) {
                                                // This is called when the user selects an item.
                                                setState(() {
                                                  dropdownValue4 = value!;
                                                  _typeAheadControllerclass
                                                      .text = value;
                                                });
                                              },
                                              items:
                                              classes.map<
                                                  DropdownMenuItem<String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                            ),


                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: width / 36,
                                                right: width / 36),
                                            height: height / 14.74,
                                            width: width / 2.363,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .shade300),
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            child:
                                            DropdownButton2<String>(
                                              value: dropdownValue5,
                                              isExpanded: true,
                                              style: TextStyle(
                                                  color: Color(0xff3D8CF8),
                                                  fontSize: width/23.05882353,
                                                  fontWeight: FontWeight.w700),
                                              underline: Container(
                                                color: Colors.deepPurpleAccent,
                                              ),
                                              onChanged: (String? value) {
                                                // This is called when the user selects an item.
                                                setState(() {
                                                  dropdownValue5 = value!;
                                                  _typeAheadControllersection
                                                      .text = value;
                                                });
                                              },
                                              items:
                                              section.map<
                                                  DropdownMenuItem<String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                            ),

                                          ),

                                        ],
                                      ),

                                      /// Center Container

                                      SizedBox(height: height / 43.7),

                                      Divider(
                                        color: Colors.grey.shade400,
                                        thickness: 1.5,
                                      ),
                                      SizedBox(height: height / 36.85),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceAround,
                                        children: [

                                          Container(
                                            padding: EdgeInsets.only(
                                                left: width / 36,
                                                right: width / 36),
                                            height: height / 14.74,
                                            width: width / 2.363,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    12)),
                                            child:
                                            DropdownButton2<String>(
                                              value: subject,
                                              isExpanded: true,
                                              style: GoogleFonts
                                                  .poppins(
                                                color: Colors
                                                    .black,
                                                fontSize: width/28,
                                                fontWeight:
                                                FontWeight
                                                    .w500,
                                              ),


                                              onChanged: (String? value) {
                                                // This is called when the user selects an item.
                                                setState(() {
                                                  subject = value!;
                                                });
                                              },
                                              items:
                                              subjects.map<
                                                  DropdownMenuItem<String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                              underline: Container(),
                                            ),


                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: width / 36,
                                                right: width / 36),
                                            height: height / 14.74,
                                            width: width / 2.363,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    12)),
                                            child: TextField(
                                              controller: duedate,
                                              readOnly: true,
                                              onTap: () async {
                                                DateTime? pickedDate = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    //DateTime.now() - not to allow to choose before today.
                                                    lastDate: DateTime(2101)
                                                );

                                                if (pickedDate != null) {
                                                  print(
                                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                                  String formattedDate = DateFormat(
                                                      'dd-M-yyyy').format(
                                                      pickedDate);
                                                  print(
                                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                                  //you can implement different kind of Date Format here according to your requirement

                                                  setState(() {
                                                    duedate.text =
                                                        formattedDate;

                                                    //set output date to TextField value.
                                                  });
                                                  print("Date is not selected");
                                                 }
                                                //else {
                                                //   print("Date is not selected");
                                                // }
                                              },
                                              style: GoogleFonts
                                                  .poppins(
                                                color: Colors
                                                    .black,
                                                fontSize: width/28,
                                                fontWeight:
                                                FontWeight
                                                    .w500,
                                              ),

                                              maxLines: 5,
                                              minLines: 1,
                                              decoration:
                                              InputDecoration(
                                                  contentPadding: EdgeInsets
                                                      .only(top: 15),
                                                  suffixIcon: Icon(
                                                      Icons.calendar_month,
                                                      color: Colors.black),
                                                  hintText:
                                                  "Due Date",
                                                  hintStyle:
                                                  GoogleFonts
                                                      .poppins(
                                                    color: Colors
                                                        .black,
                                                    fontSize: width/28,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                  ),
                                                  border:
                                                  InputBorder
                                                      .none),


                                            ),


                                          ),

                                        ],
                                      ),
                                      SizedBox(height: height / 80.85),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Topic",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: width/28,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),

                                      /// today homework


                                      Center(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: height / 157.8,
                                              left: width / 20),
                                          height: height / 14.74,
                                          width: width / 1.0636,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12)),
                                          child: TextField(
                                            controller: topic,

                                            decoration:
                                            InputDecoration(
                                                hintText:
                                                "",
                                                hintStyle:
                                                GoogleFonts
                                                    .poppins(
                                                  color: Colors
                                                      .grey
                                                      .shade700,
                                                  fontSize: width/28,
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

                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Description",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: width/28,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),

                                      /// today homework


                                      Center(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: height / 157.8,
                                              left: width / 20),
                                          height: height / 6.685,
                                          width: width / 1.0636,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12)),
                                          child: TextField(
                                            controller: homecoller,
                                            keyboardType:
                                            TextInputType
                                                .multiline,
                                            maxLines: 5,
                                            minLines: 1,
                                            decoration:
                                            InputDecoration(
                                                hintText:
                                                "",
                                                hintStyle:
                                                GoogleFonts
                                                    .poppins(
                                                  color: Colors
                                                      .grey
                                                      .shade700,
                                                  fontSize: width/28,
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

                                      /// center container

                                      SizedBox(height: height / 49.133),
                                      _pickedFile!=null?    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {

                                            },
                                            child: Container(

                                                height: height / 18.685,
                                                width: width / 1.0636,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12)),

                                                child: Padding(
                                                  padding:  EdgeInsets.only(
                                                      top: height/94.5,
                                                      bottom: height/94.5,
                                                      right: width/45,
                                                      left: width/45),
                                                  child: Row(
                                                      children: [
                                                       Padding(
                                                         padding: const EdgeInsets.all(8.0),
                                                         child: Icon(Icons.file_download_done_sharp),
                                                       ),
                                                        Padding(
                                                          padding:  EdgeInsets
                                                              .only(left: width/24),
                                                          child: Container(
                                                            width: width/2.117,
                                                            child: Text(
                                                             p.basename(_pickedFile!.path),

                                                              style:
                                                              GoogleFonts
                                                                  .poppins(
                                                                color: Colors.black,
                                                                fontSize: width/23.05882353,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                              ),),
                                                          ),
                                                        ),

                                                      ]
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                      ): SizedBox(),
                                      _pickedFile2!=null?    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {

                                            },
                                            child: Container(

                                                height: height / 18.685,
                                                width: width / 1.0636,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12)),

                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 8.0,
                                                      bottom: 8,
                                                      right: 8,
                                                      left: 8),
                                                  child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Icon(Icons.file_download_done_sharp),
                                                        ),
                                                        Padding(
                                                          padding:  EdgeInsets
                                                              .only(left: width/24),
                                                          child: Container(
                                                            width: width/2.30588235,
                                                            child: Text(
                                                              p.basename(_pickedFile2!.path),

                                                              style:
                                                              GoogleFonts
                                                                  .poppins(
                                                                color: Colors.black,
                                                                fontSize: width/23.05882353,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                              ),),
                                                          ),
                                                        ),

                                                      ]
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                      ): SizedBox(),
                                      _pickedFile3!=null?    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {

                                            },
                                            child: Container(

                                                height: height / 18.685,
                                                width: width / 1.0636,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12)),

                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 8.0,
                                                      bottom: 8,
                                                      right: 8,
                                                      left: 8),
                                                  child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Icon(Icons.file_download_done_sharp),
                                                        ),
                                                        Padding(
                                                          padding:  EdgeInsets
                                                              .only(left: width/24),
                                                          child: Container(
                                                            width: width/2.30588235,
                                                            child: Text(
                                                              p.basename(_pickedFile3!.path),

                                                              style:
                                                              GoogleFonts
                                                                  .poppins(
                                                                color: Colors.black,
                                                                fontSize: width/23.05882353,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                              ),),
                                                          ),
                                                        ),

                                                      ]
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                      ): SizedBox(),
                                      _pickedFile4!=null?    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {

                                            },
                                            child: Container(

                                                height: height / 18.685,
                                                width: width / 1.0636,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12)),

                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 8.0,
                                                      bottom: 8,
                                                      right: 8,
                                                      left: 8),
                                                  child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Icon(Icons.file_download_done_sharp),
                                                        ),
                                                        Padding(
                                                          padding:  EdgeInsets
                                                              .only(left: width/24),
                                                          child: Container(
                                                            width: width/2.30588235,
                                                            child: Text(
                                                              p.basename(_pickedFile4!.path),

                                                              style:
                                                              GoogleFonts
                                                                  .poppins(
                                                                color: Colors.black,
                                                                fontSize: width/23.05882353,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                              ),),
                                                          ),
                                                        ),

                                                      ]
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                      ): SizedBox(),
                                      _pickedFile5!=null?    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {

                                            },
                                            child: Container(

                                                height: height / 18.685,
                                                width: width / 1.0636,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12)),

                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 8.0,
                                                      bottom: 8,
                                                      right: 8,
                                                      left: 8),
                                                  child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Icon(Icons.file_download_done_sharp),
                                                        ),
                                                        Padding(
                                                          padding:  EdgeInsets
                                                              .only(left: width/24),
                                                          child: Container(
                                                            width: width/2.30588235,
                                                            child: Text(
                                                              p.basename(_pickedFile5!.path),

                                                              style:
                                                              GoogleFonts
                                                                  .poppins(
                                                                color: Colors.black,
                                                                fontSize: width/23.05882353,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                              ),),
                                                          ),
                                                        ),

                                                      ]
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                      ): SizedBox(),
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            croppimage();
                                          },
                                          child: Container(

                                              height: height / 12.685,
                                              width: width / 1.0636,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      12)),

                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,
                                                    bottom: 8,
                                                    right: 8,
                                                    left: 8),
                                                child: Row(
                                                    children: [
                                                      Material(
                                                        elevation: 3,
                                                        borderRadius: BorderRadius
                                                            .circular(8),
                                                        shadowColor: Color(
                                                            0xff0271C5),
                                                        child: Container(
                                                          width: width/7.84,
                                                          height: height/15.66,
                                                          decoration: BoxDecoration(

                                                              borderRadius: BorderRadius
                                                                  .circular(8)
                                                          ),
                                                          child: Center(
                                                              child: Icon(
                                                                  Icons.attachment_rounded,
                                                                  color: Color(
                                                                      0xff0271C5))),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:  EdgeInsets
                                                            .only(left: width/24),
                                                        child: Container(
                                                          width: width/2.30588235,
                                                          child: Text(
                                                            _pickedFile == null
                                                                ? "Add Attachments"
                                                                : "Add Another File",
                                                            style:
                                                            GoogleFonts
                                                                .poppins(
                                                              color: Color(
                                                                  0xff0271C5),
                                                              fontSize: width/23.05882353,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                            ),),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:  EdgeInsets
                                                            .only(left: width/6),
                                                        child: GestureDetector(
                                                            onTap:(){
                                                              showwwaring();
                                                            },
                                                          child: Icon(Icons
                                                              .info_outline_rounded,
                                                              color: Colors
                                                                  .black54),
                                                        ),
                                                      )

                                                    ]
                                                ),
                                              )
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height / 49.133),

                                      Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (homecoller.text != "" &&
                                                _typeAheadControllerclass
                                                    .text != "Class" &&
                                                _typeAheadControllersection
                                                    .text != "Section" && dropdownValue4!="Class"&&dropdownValue5!="Section"&&duedate.text!=""&&subject!="Subject") {
                                              add();
                                              SuccessHomeworkdialog();
                                            }
                                            else {
                                              ErrorHomeworkdialog();
                                            }
                                          },
                                          child: Container(
                                            height: height / 16.37,
                                            width: width / 2.3636,
                                            decoration: BoxDecoration(
                                                color: Color(0xff609F00),
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    7)),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceEvenly,
                                              children: [
                                                Text(
                                                  "Assign Now",
                                                  style:
                                                  GoogleFonts.poppins(
                                                      color: Colors
                                                          .white,
                                                      fontSize: width / 22.5,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500),
                                                ),
                                                Image.asset(
                                                    "assets/notes.png")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: height / 4.2125),

                                    ]),
                                SizedBox(height: height / 5.0),

                              ],
                            ),
                          ),
                        )
                            : page == "Attendance"
                            ? Padding(
                          padding: EdgeInsets.only(
                              top: height / 25.2),
                          child: Container(
                            height: height / 32.48,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.only(
                                    topRight:
                                    Radius.circular(
                                        35),
                                    topLeft:
                                    Radius.circular(
                                        35))),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: width / 36,
                                  right: width / 36,
                                  top: height / 192),
                              child: SingleChildScrollView(
                                physics: ScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [

                                    Searchcontroller.text==""?GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          page = "Home";
                                        });
                                      },
                                      child: Text(
                                        "Attendance",
                                        style:
                                        GoogleFonts.poppins(
                                            color: Colors
                                                .blueAccent,
                                            fontSize: width/21.77777778,
                                            fontWeight:
                                            FontWeight
                                                .w600),
                                      ),
                                    ):const  SizedBox(),

                                    Searchcontroller.text==""?   Row(
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
                                    ):const SizedBox(),

                                    /// date/day

                                    Searchcontroller.text==""? SizedBox(
                                      height: height / 49.13,
                                    ):const SizedBox(),

                                    Searchcontroller.text==""? Divider(
                                      color:
                                      Colors.grey.shade400,
                                      thickness: 1.5,
                                    ):const SizedBox(),

                                    Column(
                                        children: [

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: [

                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: width / 36,
                                                    right: width / 36),
                                                height: height / 14.74,
                                                width: width / 2.363,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.grey
                                                            .shade300),
                                                    borderRadius:
                                                    BorderRadius.circular(10)),
                                                child:
                                                DropdownButton2<String>(
                                                  value: dropdownValue4,
                                                  isExpanded: true,
                                                  style: TextStyle(
                                                      color: Color(0xff3D8CF8),
                                                      fontSize: width/23.05882353,
                                                      fontWeight: FontWeight
                                                          .w700),
                                                  underline: Container(
                                                    color: Colors
                                                        .deepPurpleAccent,
                                                  ),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      dropdownValue4 = value!;
                                                      _typeAheadControllerclass
                                                          .text = value;
                                                    });
                                                    checkattendance();
                                                  },
                                                  items:
                                                  classes.map<
                                                      DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                ),


                                              ),

                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: width / 36,
                                                    right: width / 36),
                                                height: height / 14.74,
                                                width: width / 2.363,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.grey
                                                            .shade300),
                                                    borderRadius:
                                                    BorderRadius.circular(10)),
                                                child:
                                                DropdownButton2<String>(
                                                  value: dropdownValue5,
                                                  isExpanded: true,
                                                  style: TextStyle(
                                                      color: Color(0xff3D8CF8),
                                                      fontSize: width/23.05882353,
                                                      fontWeight: FontWeight
                                                          .w700),
                                                  underline: Container(
                                                    color: Colors
                                                        .deepPurpleAccent,
                                                  ),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      dropdownValue5 = value!;
                                                      _typeAheadControllersection
                                                          .text = value;
                                                    });
                                                    checkattendance();
                                                  },
                                                  items:
                                                  section.map<
                                                      DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                ),

                                              ),

                                            ],
                                          ),

                                          /// Grade Container

                                          marked == false ? SizedBox(
                                            height: height / 49.13,
                                          ) : SizedBox(),

                                          marked == false ? Column(
                                            children: [
                                              Divider(
                                                color:
                                                Colors.grey.shade400,
                                                thickness: 1.5,
                                              ),

                                              Row(
                                                children: [
                                                  SizedBox(
                                                      width: width / 8),
                                                  Text(
                                                    "Name",
                                                    style: GoogleFonts
                                                        .poppins(
                                                        color: Colors
                                                            .black,
                                                        fontSize: width/26.13333333,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600),
                                                  ),
                                                  SizedBox(
                                                      width: width / 4),
                                                  Text(
                                                    "Present",
                                                    style: GoogleFonts
                                                        .poppins(
                                                        color: Colors
                                                            .black,
                                                        fontSize: width/26.13333333,
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
                                                        fontSize: width/26.13333333,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600),
                                                  ),
                                                ],
                                              ),

                                              ///  title


                                              StreamBuilder<QuerySnapshot>(
                                                  stream: _firestore2db
                                                      .collection("Students")
                                                      .
                                                  orderBy("timestamp")
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
                                                        itemCount: snapshot
                                                            .data!.docs.length,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemBuilder: (
                                                            BuildContext context,
                                                            index) {
                                                          return
                                                            snapshot.data!
                                                                .docs[index]["admitclass"] ==
                                                                _typeAheadControllerclass.text &&
                                                                snapshot.data!.docs[index]["section"] == _typeAheadControllersection.text ?
                                                            Searchcontroller.text==""? Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                      bottom: width /
                                                                          50.4),
                                                                  child: Container(

                                                                    width: width /
                                                                        3.5,
                                                                    child: Text(
                                                                      snapshot
                                                                          .data!
                                                                          .docs[index]["stname"],
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize: width/26.13333333,
                                                                          fontWeight: FontWeight
                                                                              .w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                      bottom: height /
                                                                          37.8,
                                                                      left: width /
                                                                          45),
                                                                  child:
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        present[index] =
                                                                        true;
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      height:
                                                                      height /
                                                                          29.48,
                                                                      width:
                                                                      width /
                                                                          10,
                                                                      decoration:
                                                                      BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          border: Border
                                                                              .all(
                                                                              color: Colors
                                                                                  .green)),
                                                                      child: Container(
                                                                        child: Icon(
                                                                          present[index] ==
                                                                              true
                                                                              ? Icons
                                                                              .check
                                                                              : null,
                                                                          color: Colors
                                                                              .green,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                      bottom: height /
                                                                          37.8),
                                                                  child:
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        present[index] =
                                                                        false;
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      height:
                                                                      height /
                                                                          29.48,
                                                                      width:
                                                                      width /
                                                                          10,
                                                                      decoration:
                                                                      BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          border: Border
                                                                              .all(
                                                                              color: Colors
                                                                                  .red)),
                                                                      child:
                                                                      Container(
                                                                        child: Icon(
                                                                          present[index] ==
                                                                              false
                                                                              ? Icons
                                                                              .clear
                                                                              : null,
                                                                          color: Colors
                                                                              .red,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),


                                                              ],
                                                            ) :

                                                            snapshot.data!.docs[index]["stname"].toLowerCase().contains(Searchcontroller.text.toString().toLowerCase()) ?

                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                      bottom: width /
                                                                          50.4),
                                                                  child: Container(

                                                                    width: width /
                                                                        3.5,
                                                                    child: Text(
                                                                      snapshot
                                                                          .data!
                                                                          .docs[index]["stname"],
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize: width/26.13333333,
                                                                          fontWeight: FontWeight
                                                                              .w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                      bottom: height /
                                                                          37.8,
                                                                      left: width /
                                                                          45),
                                                                  child:
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        present[index] =
                                                                        true;
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      height:
                                                                      height /
                                                                          29.48,
                                                                      width:
                                                                      width /
                                                                          10,
                                                                      decoration:
                                                                      BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          border: Border
                                                                              .all(
                                                                              color: Colors
                                                                                  .green)),
                                                                      child: Container(
                                                                        child: Icon(
                                                                          present[index] ==
                                                                              true
                                                                              ? Icons
                                                                              .check
                                                                              : null,
                                                                          color: Colors
                                                                              .green,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                      bottom: height /
                                                                          37.8),
                                                                  child:
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        present[index] =
                                                                        false;
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      height:
                                                                      height /
                                                                          29.48,
                                                                      width:
                                                                      width /
                                                                          10,
                                                                      decoration:
                                                                      BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          border: Border
                                                                              .all(
                                                                              color: Colors
                                                                                  .red)),
                                                                      child:
                                                                      Container(
                                                                        child: Icon(
                                                                          present[index] ==
                                                                              false
                                                                              ? Icons
                                                                              .clear
                                                                              : null,
                                                                          color: Colors
                                                                              .red,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),


                                                              ],
                                                            )
                                                                : SizedBox() : SizedBox();
                                                        });
                                                  }),
                                              SizedBox(height: height / 25.2,),
                                              marked == false && Searchcontroller.text==""?
                                              Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (dropdownValue4 == "Class" || dropdownValue5 == "Section") {
                                                      Errordialog();
                                                    }
                                                    else {
                                                      if(marked == false){
                                                        attendaceupload();

                                                      }
                                                      else{
                                                        setState((){
                                                          marked=true;
                                                        });
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    height: height / 16.37,
                                                    width: width / 2.3636,
                                                    decoration: BoxDecoration(
                                                        color: Color(
                                                            0xff609F00),
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          "Submit",
                                                          style:
                                                          GoogleFonts.poppins(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: width /
                                                                  22.5,
                                                              fontWeight: FontWeight
                                                                  .w500),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: width / 45),
                                                          child: Icon(
                                                              Icons.done_all,
                                                              color: Colors
                                                                  .white),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ) : SizedBox(),
                                              SizedBox(height: height / 8.2,),
                                            ],
                                          ) :
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                              Container(
                                                  width: width / 1.2,
                                                  height: height / 3.78,
                                                  child: Lottie.asset(
                                                      "assets/completed.json")
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Text(
                                                    "Attendance Marked for ${dropdownValue4} ${dropdownValue5} Today",
                                                    style:
                                                    GoogleFonts.poppins(
                                                        color: Colors
                                                            .blueAccent,
                                                        fontSize: width/21.77777778,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),


                                        ]
                                    ),

                                    SizedBox(height: height / 5.0),


                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                            : page == "Behaviour"
                            ? Padding(
                          padding: EdgeInsets.only(
                              top: height / 25.2),
                          child: Container(
                            height: height / 1.133,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.only(topRight: Radius.circular(35),
                                    topLeft: Radius.circular(35))),
                            child: Padding(
                              padding:
                              EdgeInsets.only(
                                  left: width / 36,
                                  right: width / 36,
                                  top: height / 94.5),
                              child: SingleChildScrollView(

                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [

                                  Searchcontroller.text==""? SizedBox(
                                     child:Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         GestureDetector(
                                           onTap: () {
                                             setState(() {
                                               page = "Home";
                                             });
                                           },
                                           child: Text(
                                             "Student Feedback",
                                             style: GoogleFonts.poppins(
                                                 color: Colors
                                                     .blueAccent,
                                                 fontSize: width/21.77777778,
                                                 fontWeight:
                                                 FontWeight
                                                     .w600),
                                           ),
                                         ),
                                         SizedBox(
                                             height: height /
                                                 92.125),
                                         Text(
                                           "Student report",
                                           style: GoogleFonts
                                               .poppins(
                                               color: Colors
                                                   .grey
                                                   .shade700,
                                               fontSize: width/26.13333333,
                                               fontWeight:
                                               FontWeight
                                                   .w600),
                                         ),

                                         SizedBox(
                                             height:
                                             height / 36.85),

                                         Divider(
                                           color: Colors.grey.shade400,
                                           thickness: 1,
                                         ),
                                       ],
                                     )
                                   ):const SizedBox(),

                                    SizedBox(
                                        height: height /
                                            42.642),
                                    Column(
                                        children: [


                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: [

                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: width / 36,
                                                    right: width / 36),
                                                height: height / 14.74,
                                                width: width / 2.363,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.grey
                                                            .shade300),
                                                    borderRadius:
                                                    BorderRadius.circular(10)),
                                                child:
                                                DropdownButton2<String>(
                                                  value: dropdownValue4,
                                                  isExpanded: true,
                                                  style: TextStyle(
                                                      color: Color(0xff3D8CF8),
                                                      fontSize: width/23.05882353,
                                                      fontWeight: FontWeight
                                                          .w700),
                                                  underline: Container(
                                                    color: Colors
                                                        .deepPurpleAccent,
                                                  ),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      dropdownValue4 = value!;
                                                      _typeAheadControllerclass
                                                          .text = value;
                                                    });
                                                  },
                                                  items:
                                                  classes.map<
                                                      DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                ),


                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: width / 36,
                                                    right: width / 36),
                                                height: height / 14.74,
                                                width: width / 2.363,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.grey
                                                            .shade300),
                                                    borderRadius:
                                                    BorderRadius.circular(10)),
                                                child:
                                                DropdownButton2<String>(
                                                  value: dropdownValue5,
                                                  isExpanded: true,
                                                  style: TextStyle(
                                                      color: Color(0xff3D8CF8),
                                                      fontSize: width/23.05882353,
                                                      fontWeight: FontWeight
                                                          .w700),
                                                  underline: Container(
                                                    color: Colors
                                                        .deepPurpleAccent,
                                                  ),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      dropdownValue5 = value!;
                                                      _typeAheadControllersection
                                                          .text = value;
                                                    });
                                                  },
                                                  items:
                                                  section.map<
                                                      DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                ),
                                              ),

                                            ],
                                          ),


                                          /// Center Container

                                          SizedBox(
                                              height: height /
                                                  42.642),

                                          Divider(
                                            color: Colors
                                                .grey.shade400,
                                            thickness: 1,
                                          ),

                                          SizedBox(
                                              height:
                                              height / 73.7),

                                          Center(
                                            child: Text(
                                              "Click the Student to change their value",
                                              style: GoogleFonts.poppins(
                                                  color: Colors
                                                      .grey
                                                      .shade600,
                                                  fontSize: width/28,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ),
                                          ),

                                          /// today homework

                                          Container(
                                            padding:
                                            EdgeInsets.only(
                                                left: width / 18,
                                                right: width / 14.4,
                                                top: height / 50.4),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  "Name",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors
                                                          .black,
                                                      fontSize:
                                                      width/26.13333333,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600),
                                                ),
                                                Text(
                                                  "Actions",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors
                                                          .black,
                                                      fontSize:
                                                      width/26.13333333,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600,
                                                      decoration:
                                                      TextDecoration
                                                          .underline),
                                                ),
                                              ],
                                            ),
                                          ),

                                          /// Name

                                          StreamBuilder(
                                              stream: _firestore2db.collection(
                                                  "Students")
                                                  .orderBy("regno")
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
                                                        "${snapshot.data!
                                                            .docs[index]["admitclass"]}${snapshot
                                                            .data!
                                                            .docs[index]["section"]}" ==
                                                            "${_typeAheadControllerclass
                                                                .text}${_typeAheadControllersection
                                                                .text}" ? Searchcontroller.text==""?
                                                        GestureDetector(
                                                          onTap: (){
                                                            Navigator.of(context).push(
                                                              MaterialPageRoute(builder: (context)=>Feedbackhistory(
                                                                  snapshot.data!.docs[index].id,
                                                                  snapshot.data!.docs[index]["stname"],
                                                                  staffname,
                                                                  snapshot.data!.docs[index]["token"],
                                                                  staffid,
                                                                  staffauthendicationid

                                                              )));

                                                          },
                                                          child: Container(
                                                            padding:
                                                            EdgeInsets.only(
                                                              left: width / 18,

                                                              top: height /
                                                                  50.4,),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: width /
                                                                      2.25,

                                                                  child: Text(
                                                                    snapshot.data!
                                                                        .docs[index]["stname"],
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                        width/26.13333333,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: width/7.12727273),

                                                                Container(
                                                                  height: height /
                                                                      29.48,
                                                                  width:
                                                                  width / 3.6,
                                                                  decoration: BoxDecoration(
                                                                      color:  Color(0xff3D8CF8),
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          5)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                    children: [

                                                                      Text(
                                                                        "Edit",
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                            width/26.13333333,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w600),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                ),


                                                              ],
                                                            ),
                                                          ),
                                                        ) :
                                                        snapshot.data!.docs[index]["stname"].toLowerCase().contains(Searchcontroller.text.toString().toLowerCase()) ?
                                                        GestureDetector(
                                                          onTap: (){
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(builder: (context)=>Feedbackhistory(snapshot.data!
                                                                    .docs[index].id,snapshot.data!
                                                                    .docs[index]["stname"],
                                                                    staffname,
                                                                    snapshot.data!.docs[index]["token"],
                                                                    staffid,
                                                                    staffauthendicationid

                                                                )));

                                                          },
                                                          child: Container(
                                                            padding:
                                                            EdgeInsets.only(
                                                              left: width / 18,

                                                              top: height /
                                                                  50.4,),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: width /
                                                                      2.25,

                                                                  child: Text(
                                                                    snapshot.data!
                                                                        .docs[index]["stname"],
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                        width/26.13333333,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: width/7.12727273),

                                                                Container(
                                                                  height: height /
                                                                      29.48,
                                                                  width:
                                                                  width / 3.6,
                                                                  decoration: BoxDecoration(
                                                                      color:  Color(0xff3D8CF8),
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          5)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                    children: [

                                                                      Text(
                                                                        "Edit",
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                            width/26.13333333,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w600),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                ),


                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                            : Container() :Container();
                                                    }
                                                );
                                              }
                                          ),

                                          ///  good


                                        ]
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
                          padding:
                          EdgeInsets.only(
                              top: height / 25.2),
                          child: Container(
                            height: height / 1.474,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.only(
                                    topRight: Radius.circular(35),
                                    topLeft: Radius.circular(35))),
                            child: Padding(
                              padding: EdgeInsets.only(left: width / 36,
                                  right: width / 36,
                                  top: width / 75.6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // physics: NeverScrollableScrollPhysics(),
                                children: [
                                  GestureDetector(
                                    onTap: () {

                                      //timetablelogic();

                                    },
                                    child: Text(
                                      "Time Table",
                                      style: GoogleFonts.poppins(
                                          color: Colors
                                              .blueAccent,
                                          fontSize:
                                          width/21.77777778,
                                          fontWeight:
                                          FontWeight
                                              .w600),
                                    ),
                                  ),

                                  SizedBox(
                                    height: height /
                                        92.125,
                                  ),

                                  Row(
                                    children: [
                                      Text(
                                        "${DateFormat.yMMMd().format(DateTime.now())}",
                                        style: GoogleFonts.poppins(
                                            color: Colors
                                                .grey
                                                .shade700,
                                            fontSize:
                                            width/26.13333333,
                                            fontWeight:
                                            FontWeight
                                                .w500),
                                      ),
                                      SizedBox(
                                          width: width /
                                              33.33),
                                      Container(
                                        height:
                                        height /
                                            49.133,
                                        width: width /
                                            260,
                                        color: Colors
                                            .grey,
                                      ),
                                      SizedBox(
                                          width: width /
                                              33.33),
                                      Text(
                                        day,
                                        style: GoogleFonts.poppins(
                                            color: Colors
                                                .grey
                                                .shade700,
                                            fontSize:
                                            width/26.13333333,
                                            fontWeight:
                                            FontWeight
                                                .w500),
                                      ),
                                    ],
                                  ),

                                  /// date/day

                                  SizedBox(
                                      height: height /
                                          36.85),

                                  Divider(
                                    color:
                                    Colors.black,
                                    thickness: 0.5,
                                  ),
                                  SizedBox(height: height / 150.04,),
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
                                                            color: teachertable[index]=="Free Period"? Color(0xfff18d27):Color(
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
                                    })

                                    /* Column(
                                                                      mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                                                      children: [

                                                                        Stack(
                                                                            children: [
                                                                              Container(
                                                                                height:
                                                                                height / 18.425,
                                                                                width:
                                                                                width / 1.2,
                                                                                decoration:
                                                                                BoxDecoration(color: Color(0xffECECEC), borderRadius: BorderRadius.circular(18)),
                                                                                child:
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: width/4.5),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "7th Grade C Section",
                                                                                      style: GoogleFonts.poppins(color:Color(0xff0873C4), fontSize: 20, fontWeight: FontWeight.w600),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height:
                                                                                height / 18.425,
                                                                                width:
                                                                                width / 4.285,
                                                                                decoration:
                                                                                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                                                                                child:
                                                                                Center(
                                                                                  child: Text(
                                                                                    " 2 HR",
                                                                                    style: GoogleFonts.poppins(color:Color(0xff0873C4), fontSize: 20, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                        Stack(
                                                                            children: [
                                                                              Container(
                                                                                height:
                                                                                height / 18.425,
                                                                                width:
                                                                                width / 1.2,
                                                                                decoration:
                                                                                BoxDecoration(color: Color(0xffECECEC), borderRadius: BorderRadius.circular(18)),
                                                                                child:
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: width/4.5),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "6th Grade A Section",
                                                                                      style: GoogleFonts.poppins(color:Color(0xff0873C4), fontSize: 20, fontWeight: FontWeight.w600),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height:
                                                                                height / 18.425,
                                                                                width:
                                                                                width / 4.285,
                                                                                decoration:
                                                                                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                                                                                child:
                                                                                Center(
                                                                                  child: Text(
                                                                                    " 3 HR",
                                                                                    style: GoogleFonts.poppins(color:Color(0xff0873C4), fontSize: 20, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                        Stack(
                                                                            children: [
                                                                              Container(
                                                                                height:
                                                                                height / 18.425,
                                                                                width:
                                                                                width / 1.2,
                                                                                decoration:
                                                                                BoxDecoration(color: Color(0xffECECEC), borderRadius: BorderRadius.circular(18)),
                                                                                child:
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: width/4.5),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "6th Grade B Section",
                                                                                      style: GoogleFonts.poppins(color:Color(0xff0873C4), fontSize: 20, fontWeight: FontWeight.w600),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height:
                                                                                height / 18.425,
                                                                                width:
                                                                                width / 4.285,
                                                                                decoration:
                                                                                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                                                                                child:
                                                                                Center(
                                                                                  child: Text(
                                                                                    " 4 HR",
                                                                                    style: GoogleFonts.poppins(color:Color(0xff0873C4), fontSize: 20, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                        Stack(
                                                                            children: [
                                                                              Container(
                                                                                height:
                                                                                height / 18.425,
                                                                                width:
                                                                                width / 1.2,
                                                                                decoration:
                                                                                BoxDecoration(color: Color(0xffECECEC), borderRadius: BorderRadius.circular(18)),
                                                                                child:
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: width/4.5),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "10th Grade D Section",
                                                                                      style: GoogleFonts.poppins(color:Color(0xff0873C4), fontSize: 20, fontWeight: FontWeight.w600),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height:
                                                                                height / 18.425,
                                                                                width:
                                                                                width / 4.285,
                                                                                decoration:
                                                                                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                                                                                child:
                                                                                Center(
                                                                                  child: Text(
                                                                                    " 5 HR",
                                                                                    style: GoogleFonts.poppins(color:Color(0xff0873C4), fontSize: 20, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ])
                                                                      ],
                                                                    ),*/
                                  ),
                                  SizedBox(height: height / 5.0),

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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: [

                                        Container(
                                          padding: EdgeInsets.only(
                                              left: width / 36,
                                              right: width / 36),
                                          height: height / 14.74,
                                          width: width / 2.363,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .shade300),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          child:
                                          DropdownButton2<String>(
                                            value: dropdownValue4,
                                            isExpanded: true,
                                            style: TextStyle(
                                                color: Color(0xff3D8CF8),
                                                fontSize: width/23.05882353,
                                                fontWeight: FontWeight
                                                    .w700),
                                            underline: Container(
                                              color: Colors
                                                  .deepPurpleAccent,
                                            ),
                                            onChanged: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                dropdownValue4 = value!;
                                                _typeAheadControllerclass
                                                    .text = value;
                                              });
                                              checkattendance();
                                            },
                                            items:
                                            classes.map<
                                                DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                          ),


                                        ),

                                        Container(
                                          padding: EdgeInsets.only(
                                              left: width / 36,
                                              right: width / 36),
                                          height: height / 14.74,
                                          width: width / 2.363,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .shade300),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          child:
                                          DropdownButton2<String>(
                                            value: dropdownValue5,
                                            isExpanded: true,
                                            style: TextStyle(
                                                color: Color(0xff3D8CF8),
                                                fontSize: width/23.05882353,
                                                fontWeight: FontWeight
                                                    .w700),
                                            underline: Container(
                                              color: Colors
                                                  .deepPurpleAccent,
                                            ),
                                            onChanged: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                dropdownValue5 = value!;
                                                _typeAheadControllersection
                                                    .text = value;
                                              });
                                              checkattendance();
                                            },
                                            items:
                                            section.map<
                                                DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                          ),

                                        ),

                                      ],
                                    ),
                                    SizedBox(height: height / 184.25),
                                    Container(
                                      height: size.height / 2.3,
                                      width: size.width,
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: _firestore2db
                                            .collection('${dropdownValue4}${dropdownValue5}chat')
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
                                                        crossAxisAlignment: snapshot.data!.docs[index]["sender"]==staffname?CrossAxisAlignment.end: CrossAxisAlignment.start,
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
                                : page == "Payroll"
                            ? Padding(
                          padding:
                          EdgeInsets.only(
                              top: height / 25.2),
                          child: Container(
                            height: height / 1.474,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.only(
                                    topRight: Radius.circular(35),
                                    topLeft: Radius.circular(35))),
                            child: Padding(
                              padding: EdgeInsets.only(left: width / 36,
                                  right: width / 36,
                                  top: width / 75.6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // physics: NeverScrollableScrollPhysics(),
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        page = "Home";
                                      });
                                    },
                                    child: Text(
                                      "Payroll",
                                      style: GoogleFonts.poppins(
                                          color: Colors
                                              .blueAccent,
                                          fontSize:
                                          width/21.77777778,
                                          fontWeight:
                                          FontWeight
                                              .w600),
                                    ),
                                  ),

                                  SizedBox(
                                    height: height /
                                        92.125,
                                  ),

                                  Row(
                                    children: [
                                      Text(
                                        "${DateFormat.yMMMd().format(DateTime.now())}",
                                        style: GoogleFonts.poppins(
                                            color: Colors
                                                .grey
                                                .shade700,
                                            fontSize:
                                            width/26.13333333,
                                            fontWeight:
                                            FontWeight
                                                .w500),
                                      ),
                                      SizedBox(
                                          width: width /
                                              33.33),
                                      Container(
                                        height:
                                        height /
                                            49.133,
                                        width: width /
                                            260,
                                        color: Colors
                                            .grey,
                                      ),
                                      SizedBox(
                                          width: width /
                                              33.33),
                                      Text(
                                        day,
                                        style: GoogleFonts.poppins(
                                            color: Colors
                                                .grey
                                                .shade700,
                                            fontSize:
                                            width/26.13333333,
                                            fontWeight:
                                            FontWeight
                                                .w500),
                                      ),
                                    ],
                                  ),

                                  /// date/day

                                  SizedBox(
                                      height: height /
                                          36.85),

                                  Divider(
                                    color:
                                    Colors.black,
                                    thickness: 0.5,
                                  ),
                                  SizedBox(height: height / 50.04,),
                                  Material(
                                    elevation:5,
                                    borderRadius: BorderRadius.circular(12),
                                    child: GestureDetector(
                                      onTap: () async{

                                        List<p.Widget> widgets = [];
                                        var fontsemipoppoins = await PdfGoogleFonts.poppinsSemiBold();
//Profile image


//container for profile image decoration



//add decorated image container to widgets list

                                        widgets.add(p.Padding(
                                            padding: const p.EdgeInsets.only(top: 90),
                                            child: p.Container(
                                              height: 600,
                                              child: p.Column(

                                                  children: [
                                                  p.Text("Payslip",style: p.TextStyle(fontSize: 20)),
                                              p.SizedBox(height: 3),
                                              p.Text("RAVEN ENGLISH SCHOOL"),
                                              p.SizedBox(height: 3),
                                              p.Text("ANNANJI,THENI - 625531"),
                                              p.SizedBox(height: 8),
                                              p.Row(mainAxisAlignment: p.MainAxisAlignment.center, children: [
                                                p.Container(
                                                    child: p.Column(
                                                        crossAxisAlignment: p.CrossAxisAlignment.start,
                                                        mainAxisAlignment: p.MainAxisAlignment.start,
                                                        children: [

                                                          p.SizedBox(height: 5),
                                                          p.Row(children: [
                                                            p.Container(
                                                              width: 110,
                                                              height: 20,

                                                              child: p.Text("Date of Joining:",
                                                                  style: const p.TextStyle(
                                                                      color: PdfColors.black)),
                                                            ),
                                                            p.Container(
                                                              width: 140,
                                                              height: 20,
                                                              child: p.Text(": 2018-06-23",
                                                                  style: const p.TextStyle(
                                                                      color: PdfColors.black)),
                                                            ),
                                                          ]),
                                                          p.SizedBox(height: 5),
                                                          p.Row(children: [
                                                            p.Container(
                                                              width: 110,
                                                              height: 20,
                                                              child: p.Text("Pay Period",
                                                                  style: const p.TextStyle(
                                                                      color: PdfColors.black)),
                                                            ),
                                                            p.Container(
                                                              width: 140,
                                                              height: 20,
                                                              child: p.Text(": August 2021",
                                                                  style: const p.TextStyle(
                                                                      color: PdfColors.black)),
                                                            )
                                                          ]),
                                                          p.SizedBox(height: 5),
                                                          p.Row(children: [
                                                            p.Container(
                                                              width: 110,
                                                              height: 20,
                                                              child: p.Text("Worked Days",
                                                                  style: const p.TextStyle(
                                                                      color: PdfColors.black)),
                                                            ),
                                                            p.Container(
                                                              width: 140,
                                                              height: 20,
                                                              child: p.Text("26",
                                                                  style: const p.TextStyle(
                                                                      color: PdfColors.black)),
                                                            )
                                                          ]),
                                                        ])),
                                                p.SizedBox(width: width / 273.2),
                                                p.Container(
                                                    child: p.Column(
                                                        crossAxisAlignment: p.CrossAxisAlignment.start,
                                                        mainAxisAlignment: p.MainAxisAlignment.start,
                                                        children: [
                                                          p.Row(
                                                              crossAxisAlignment: p.CrossAxisAlignment.start,
                                                              children: [
                                                                p.Container(
                                                                  width: 120,
                                                                  height: 20,
                                                                  child: p.Text("Employee Name",
                                                                      style: const p.TextStyle(
                                                                          color: PdfColors.black)),
                                                                ),
                                                                p.Container(
                                                                  width: 140,
                                                                  height: 20,
                                                                  child: p.Text(": Sally Harley",
                                                                      style: const p.TextStyle(
                                                                          color: PdfColors.black)),
                                                                )
                                                              ]),
                                                          p.SizedBox(height: 5),
                                                          p.Row(children: [
                                                            p.Container(
                                                              width: 120,
                                                              height: 20,
                                                              child: p.Text("Designation",
                                                                  style: const p.TextStyle(
                                                                      color: PdfColors.black)),
                                                            ),
                                                            p.Container(
                                                              width: 140,
                                                              height: 20,
                                                              child: p.Text(": Marketing Evecutive",
                                                                  style: const p.TextStyle(
                                                                      color: PdfColors.black)),
                                                            )
                                                          ]),
                                                          p.SizedBox(height: 5),
                                                          p.Row(children: [
                                                            p.Container(
                                                              width: 120,
                                                              height: 20,
                                                              child: p.Text("Department",
                                                                  style: const p.TextStyle(
                                                                      color: PdfColors.black)),
                                                            ),
                                                            p.Container(
                                                              width: 140,
                                                              height: 20,
                                                              child: p.Text(": Marketing",
                                                                  style: const p.TextStyle(
                                                                      color: PdfColors.black)),
                                                            )
                                                          ]),
                                                        ])),
                                              ]),
                                              p.SizedBox(height: 5),

                                              p.Container(
                                                child: p.Row(
                                                    mainAxisAlignment: p.MainAxisAlignment.center,
                                                    children: [
                                                      p.Container(
                                                          width:380,
                                                          height: 30,
                                                          decoration: p.BoxDecoration(
                                                              color: PdfColor.fromHex("0271C5"),
                                                              border: p.Border.all(color: PdfColors.black)
                                                          ),
                                                          child: p.Center(
                                                              child: p.Text("Earnings",style: p.TextStyle(
                                                                color:PdfColors.white,
                                                              ))
                                                          )
                                                      ),
                                                      p.Container(
                                                          width: 100,
                                                          height: 30,
                                                          decoration: p.BoxDecoration(
                                                              color: PdfColor.fromHex("0271C5"),
                                                              border: p.Border.all(color: PdfColors.black)
                                                          ),

                                                          child:p.Center(
                                                              child:  p.Text("Amount",style: p.TextStyle(
                                                                color:PdfColors.white,
                                                              ))
                                                          )
                                                      ),
                                                    ]
                                                ),


                                              ),
                                              p.Container(
                                                child: p.Row(
                                                    crossAxisAlignment: p.CrossAxisAlignment.start,
                                                    mainAxisAlignment: p.MainAxisAlignment.center,
                                                    children: [
                                                      p.Container(
                                                          width:380,
                                                          height: height/6.3,
                                                          decoration: p.BoxDecoration(
                                                              border: p.Border.all(color: PdfColors.black)
                                                          ),
                                                          child:
                                                          p.Padding(
                                                              padding: p.EdgeInsets.only(left: width/36.0),
                                                              child: p.Column(
                                                                  crossAxisAlignment: p.CrossAxisAlignment.start,
                                                                  children: [
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("Basic Pay"),
                                                                    ),
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("DA"),
                                                                    ),
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("House Rent Allowance"),
                                                                    ),
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("Other Allowance"),
                                                                    ),
                                                                    p.Row(
                                                                        mainAxisAlignment: p.MainAxisAlignment.end,
                                                                        children: [
                                                                          p.Padding(
                                                                            padding: p.EdgeInsets.only(right: 8,top: 10),
                                                                            child:  p.Text("Total Earnings"),
                                                                          ),
                                                                        ]
                                                                    )
                                                                  ]
                                                              )
                                                          )
                                                      ),
                                                      p.Container(
                                                          width: 100,
                                                          height: height/6.3,
                                                          decoration: p.BoxDecoration(
                                                              border: p.Border.all(color: PdfColors.black)
                                                          ),

                                                          child: p.Padding(
                                                              padding: p.EdgeInsets.only(right: 10),
                                                              child: p.Column(
                                                                  crossAxisAlignment: p.CrossAxisAlignment.end,
                                                                  children: [
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("10000"),
                                                                    ),
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("1000"),
                                                                    ),
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("400"),
                                                                    ),
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("200"),
                                                                    ),
                                                                    p.Row(
                                                                        mainAxisAlignment: p.MainAxisAlignment.end,
                                                                        children: [
                                                                          p.Padding(
                                                                            padding: p.EdgeInsets.only(top: 10),
                                                                            child:  p.Text("0"),
                                                                          ),
                                                                        ]
                                                                    )
                                                                  ]
                                                              )
                                                          )
                                                      ),
                                                    ]
                                                ),


                                              ),

                                              p.SizedBox(height: height/75.6),

                                              p.Container(
                                                child: p.Row(
                                                    mainAxisAlignment: p.MainAxisAlignment.center,
                                                    children: [
                                                      p.Container(
                                                          width:380,
                                                          height: 30,
                                                          decoration: p.BoxDecoration(
                                                              color: PdfColor.fromHex("0271C5"),
                                                              border: p.Border.all(color: PdfColors.black)
                                                          ),
                                                          child: p.Center(
                                                              child: p.Text("Deductions",style: p.TextStyle(
                                                                color:PdfColors.white,
                                                              ))
                                                          )
                                                      ),
                                                      p.Container(
                                                          width: 100,
                                                          height: 30,
                                                          decoration: p.BoxDecoration(
                                                              color: PdfColor.fromHex("0271C5"),
                                                              border: p.Border.all(color: PdfColors.black)
                                                          ),

                                                          child:p.Center(
                                                              child:  p.Text("Amount",style: p.TextStyle(
                                                                color:PdfColors.white,
                                                              ))
                                                          )
                                                      ),
                                                    ]
                                                ),


                                              ),
                                              p.Container(
                                                child: p.Row(
                                                    crossAxisAlignment: p.CrossAxisAlignment.start,
                                                    mainAxisAlignment: p.MainAxisAlignment.center,
                                                    children: [
                                                      p.Container(
                                                          width:380,
                                                          height: height/6.3,
                                                          decoration: p.BoxDecoration(
                                                              border: p.Border.all(color: PdfColors.black)
                                                          ),
                                                          child:
                                                          p.Padding(
                                                              padding: p.EdgeInsets.only(left: width/36.0),
                                                              child: p.Column(
                                                                  crossAxisAlignment: p.CrossAxisAlignment.start,
                                                                  children: [
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("Provident Fund "),
                                                                    ),
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("Profesional Tax "),
                                                                    ),
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("Loan"),
                                                                    ),

                                                                    p.Row(
                                                                        mainAxisAlignment: p.MainAxisAlignment.end,
                                                                        children: [
                                                                          p.Padding(
                                                                            padding: p.EdgeInsets.only(right: 8,top: 10),
                                                                            child:  p.Text("Total Deductions"),
                                                                          ),
                                                                        ]
                                                                    ),
                                                                    p.Row(
                                                                        mainAxisAlignment: p.MainAxisAlignment.end,
                                                                        children: [
                                                                          p.Padding(
                                                                            padding: p.EdgeInsets.only(right: 8,top: 10),
                                                                            child:  p.Text("Net Pay"),
                                                                          ),
                                                                        ]
                                                                    )
                                                                  ]
                                                              )
                                                          )
                                                      ),
                                                      p.Container(
                                                          width: 100,
                                                          height: height/6.3,
                                                          decoration: p.BoxDecoration(
                                                              border: p.Border.all(color: PdfColors.black)
                                                          ),

                                                          child: p.Padding(
                                                              padding: p.EdgeInsets.only(right: 10),
                                                              child: p.Column(
                                                                  crossAxisAlignment: p.CrossAxisAlignment.end,
                                                                  children: [
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("1200"),
                                                                    ),
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("500"),
                                                                    ),
                                                                    p.Padding(
                                                                      padding: p.EdgeInsets.only(top: 8),
                                                                      child:  p.Text("400"),
                                                                    ),

                                                                    p.Row(
                                                                        mainAxisAlignment: p.MainAxisAlignment.end,
                                                                        children: [
                                                                          p.Padding(
                                                                            padding: p.EdgeInsets.only(top: 10),
                                                                            child:  p.Text("2100"),
                                                                          ),
                                                                        ]
                                                                    ),
                                                                    p.Row(
                                                                        mainAxisAlignment: p.MainAxisAlignment.end,
                                                                        children: [
                                                                          p.Padding(
                                                                            padding: p.EdgeInsets.only(top: 10),
                                                                            child:  p.Text("9500"),
                                                                          ),
                                                                        ]
                                                                    )
                                                                  ]
                                                              )
                                                          )
                                                      ),
                                                    ]
                                                ),


                                              ),
                                              p.SizedBox(height: height/75.6),
                                              p.Text("9500"),
                                              p.SizedBox(height: 5),
                                              p.Text("Nine Thousand Five Hundred"),
                                              p.SizedBox(height: 15),
                                              p.Row(
                                                  mainAxisAlignment: p.MainAxisAlignment.spaceAround,
                                                  children: [
                                                    p.SizedBox(
                                                      width: width/1.8,
                                                      child:  p.Column(
                                                          children: [
                                                            p.Text("Employer Signature"),
                                                            p.SizedBox(height: 15),
                                                            p.Divider()
                                                          ]
                                                      ),
                                                    ),
                                                    p.SizedBox(
                                                      width: width/1.8,
                                                      child:  p.Column(
                                                          children: [
                                                            p.Text("Employee Signature"),
                                                            p.SizedBox(height: 15),
                                                            p.Divider()
                                                          ]
                                                      ),
                                                    ),

                                                  ]
                                              ),
                                              p.SizedBox(height: 15),
                                              p.Text("This is system generated payslip"),




                                            ]))));

                                       //some space beneath image

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
                                          width: width/0.972,
                                          height: height/7.56,

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
                                                    padding:  EdgeInsets.only(left: width/30,top:8,bottom: 5),
                                                    child: Text("Download Payroll",style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 23,
                                                        fontWeight: FontWeight.w700

                                                    ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:  EdgeInsets.only(left: width/30),
                                                    child: Text("September Month ",style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: width/22.5,
                                                        fontWeight: FontWeight.w600

                                                    ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:  EdgeInsets.only(right: width/30),
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
                                : page == "Leave"
                            ? Padding(
                          padding:
                          EdgeInsets.only(
                              top: height / 25.2),
                          child: Container(
                            height: height / 1.474,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.only(
                                    topRight: Radius.circular(35),
                                    topLeft: Radius.circular(35))),
                            child: Padding(
                              padding: EdgeInsets.only(left: width / 36,
                                  right: width / 36,
                                  top: width / 75.6),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          page = "Home";
                                        });
                                      },
                                      child: Text(
                                        "LTP",
                                        style: GoogleFonts.poppins(
                                            color: Colors
                                                .blueAccent,
                                            fontSize:
                                            width/21.77777778,
                                            fontWeight:
                                            FontWeight
                                                .w600),
                                      ),
                                    ),

                                    SizedBox(
                                      height: height /
                                          92.125,
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          "${DateFormat.yMMMd().format(DateTime.now())}",
                                          style: GoogleFonts.poppins(
                                              color: Colors
                                                  .grey
                                                  .shade700,
                                              fontSize:
                                              width/26.13333333,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                        SizedBox(
                                            width: width /
                                                33.33),
                                        Container(
                                          height:
                                          height /
                                              49.133,
                                          width: width /
                                              260,
                                          color: Colors
                                              .grey,
                                        ),
                                        SizedBox(
                                            width: width /
                                                33.33),
                                        Text(
                                          day,
                                          style: GoogleFonts.poppins(
                                              color: Colors
                                                  .grey
                                                  .shade700,
                                              fontSize:
                                              width/26.13333333,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                      ],
                                    ),

                                    /// date/day

                                    SizedBox(
                                        height: height /
                                            36.85),

                                    Divider(
                                      color:
                                      Colors.black,
                                      thickness: 0.5,
                                    ),

                                    SizedBox(height: height / 36.85),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: [

                                        Container(
                                          padding: EdgeInsets.only(
                                              left: width / 36,
                                              right: width / 36),
                                          height: height / 14.74,
                                          width: width / 2.363,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12)),
                                          child:
                                          DropdownButton2<String>(
                                            value: leavetype,
                                            isExpanded: true,
                                            style: GoogleFonts
                                                .poppins(
                                              color: Colors
                                                  .black,
                                              fontSize: width/28,
                                              fontWeight:
                                              FontWeight
                                                  .w500,
                                            ),


                                            onChanged: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                leavetype = value!;
                                              });
                                            },
                                            items:
                                            leave.map<
                                                DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                            underline: Container(),
                                          ),


                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: width / 36,
                                              right: width / 36),
                                          height: height / 14.74,
                                          width: width / 2.363,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12)),
                                          child: TextField(
                                            controller: duedate,
                                            readOnly: true,
                                            onTap: () async {
                                              DateTime? pickedDate = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  //DateTime.now() - not to allow to choose before today.
                                                  lastDate: DateTime(2101)
                                              );

                                              if (pickedDate != null) {
                                                print(
                                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                                String formattedDate = DateFormat(
                                                    'dd-M-yyyy').format(
                                                    pickedDate);
                                                print(
                                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                                //you can implement different kind of Date Format here according to your requirement

                                                setState(() {
                                                  duedate.text =
                                                      formattedDate;

                                                  //set output date to TextField value.
                                                });
                                              } else {
                                                print("Date is not selected");
                                              }
                                            },
                                            style: GoogleFonts
                                                .poppins(
                                              color: Colors
                                                  .black,
                                              fontSize: width/28,
                                              fontWeight:
                                              FontWeight
                                                  .w500,
                                            ),

                                            maxLines: 5,
                                            minLines: 1,
                                            decoration:
                                            InputDecoration(
                                                contentPadding: EdgeInsets
                                                    .only(top: 15),
                                                suffixIcon: Icon(
                                                    Icons.calendar_month,
                                                    color: Colors.black),
                                                hintText:
                                                "Date",
                                                hintStyle:
                                                GoogleFonts
                                                    .poppins(
                                                  color: Colors
                                                      .black,
                                                  fontSize: width/28,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                ),
                                                border:
                                                InputBorder
                                                    .none),


                                          ),


                                        ),

                                      ],
                                    ),
                                    SizedBox(height: height / 80.85),


                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Reason",
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: width/28,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),

                                    /// today homework


                                    Center(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: height / 157.8,
                                            left: width / 20),
                                        height: height / 6.685,
                                        width: width / 1.0636,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey),
                                            borderRadius:
                                            BorderRadius.circular(
                                                12)),
                                        child: TextField(
                                          controller: homecoller,
                                          keyboardType:
                                          TextInputType
                                              .multiline,
                                          maxLines: 5,
                                          minLines: 1,
                                          decoration:
                                          InputDecoration(
                                              hintText:
                                              "Feeling not well",
                                              hintStyle:
                                              GoogleFonts
                                                  .poppins(
                                                color: Colors
                                                    .grey
                                                    .shade700,
                                                fontSize: width/28,
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

                                    /// center container

                                    SizedBox(height: height / 49.133),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            if(leavetype!="Leave Type"&&homecoller.text!=""&&duedate.text !=""){
                                              submitleave();
                                              submitleavepopup();
                                            }
                                            else{
                                              ErrorHomeworkdialog();
                                            }
                                            },
                                          child: Container(
                                            height: height / 16.37,
                                            width: width / 2.3636,
                                            decoration: BoxDecoration(
                                                color: Color(
                                                    0xff609F00),
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    7)),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                Text(
                                                  "Submit",
                                                  style:
                                                  GoogleFonts.poppins(
                                                      color: Colors
                                                          .white,
                                                      fontSize: width /
                                                          22.5,
                                                      fontWeight: FontWeight
                                                          .w500),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets
                                                      .only(
                                                      left: width / 45),
                                                  child: Icon(
                                                      Icons.done_all,
                                                      color: Colors
                                                          .white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height / 49.133),
                                    Text(
                                      "Previous Records",
                                      style: GoogleFonts.poppins(
                                          color: Colors
                                              .blueAccent,
                                          fontSize:
                                          width/21.77777778,
                                          fontWeight:
                                          FontWeight
                                              .w600),
                                    ),
                                    SizedBox(height: height / 49.133),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: width / 50),
                                        Text(
                                          "Type",
                                          style: GoogleFonts
                                              .poppins(
                                              color: Colors
                                                  .black,
                                              fontSize: width/26.13333333,
                                              fontWeight:
                                              FontWeight
                                                  .w600),
                                        ),
                                        SizedBox(
                                            width: width / 3.1),

                                        SizedBox(
                                            width: width / 3.2),
                                        Text(
                                          "Status",
                                          style: GoogleFonts
                                              .poppins(
                                              color: Colors
                                                  .black,
                                              fontSize: width/26.13333333,
                                              fontWeight:
                                              FontWeight
                                                  .w600),
                                        ),
                                      ],
                                    ),
                                    StreamBuilder(stream: _firestore2db.collection("Staffs").doc(staffid).collection('Leave').orderBy("timestamp",descending: true).snapshots(),
                                        builder: (context,snap){

                                      if(!snap.hasData){
                                        return const Center(child: CircularProgressIndicator(),);
                                      }
                                      if(snap.hasData==null){
                                        return const Center(child: CircularProgressIndicator(),);
                                      }

                                      return ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: snap.data!.docs.length,
                                          itemBuilder: (context,index){
                                        return GestureDetector(
                                          onTap: (){
                                            ltpdialog(snap.data!.docs[index]["type"],snap.data!.docs[index]["date"],snap.data!.docs[index]["time"],snap.data!.docs[index]["leaveon"],
                                                snap.data!.docs[index]["reason"],snap.data!.docs[index]["status"],snap.data!.docs[index].id
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text(snap.data!.docs[index]["type"],style: GoogleFonts
                                                    .poppins(
                                                    color: Colors
                                                        .black,
                                                    fontSize: width/26.13333333,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600),
                                                ),
                                                subtitle: Text(snap.data!.docs[index]["date"],style: GoogleFonts.poppins(
                                                    color: Colors
                                                        .grey,
                                                    fontSize: width/40.13333333,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600),),
                                                trailing: Container(
                                                  decoration: BoxDecoration(
                                                    color: snap.data!.docs[index]["status"].toString().toLowerCase()=="approved"?Colors.green:
                                                    snap.data!.docs[index]["status"].toString().toLowerCase()=="pending"? Colors.orange:
                                                    snap.data!.docs[index]["status"].toString().toLowerCase()=="denied"? Colors.red:
                                                    Colors.blueAccent,
                                                    borderRadius: BorderRadius.circular(8)
                                                  ),
                                                  padding: EdgeInsets.symmetric(

                                                    vertical: height/216,
                                                    horizontal: width/102.85
                                                  ),
                                                  child: Text(snap.data!.docs[index]["status"],style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: width/26.13333333,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: width/1.2,
                                                child: Divider(
                                                  thickness: 2,
                                                  color: Colors.black54,
                                                ),
                                              )
                                            ],
                                          )
                                        );

                                      });
                                    }),
                                    SizedBox(height: height/7.56,)

                            

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ) : page == "CheckIn"? Today_Presents_Page(staffname,staffregno)
                            : Container()
                    ),
                  ),

                  page=="Home Works"  ||    page=="Time Table" || page=="CheckIn"|| page=="Leave"|| page=="Messages"?  SizedBox() :
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
                              suffixIcon: InkWell(
                                  onTap: (){
                                    setState(() {
                                      Searchcontroller.clear();
                                      page = "Home";
                                    });
                                  },
                                  child: Icon(Icons.cancel)),
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
                          onChanged: (val){
                            if(Searchcontroller.text==""){
                              setState((){
                                search=false;
                                Searchcontroller.clear();
                              });
                              print(search);
                              setState(() {

                              });
                            }
                            else{
                              setState((){
                                search=true;
                                Searchcontroller.text=val;
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
                  )
                ],
              ), // white
            ],
          ),
        ),
      ),
    );
  }

  File? _pickedFile;
  File? _pickedFile2;
  File? _pickedFile3;
  File? _pickedFile4;
  File? _pickedFile5;

  TextEditingController leavedes= new TextEditingController();
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  submitleave(){

    if(docid=="") {
      String docid = getRandomString(16);
      _firestore2db.collection("Staffs").doc(staffid).collection('Leave').doc(
          docid).set({
        "type": leavetype,
        "date": "${DateTime
            .now()
            .day}-${DateTime
            .now()
            .month}-${DateTime
            .now()
            .year}",
        "time": "${DateFormat('hh:mm a').format(DateTime.now())}",
        "reason": homecoller.text,
        "status": "Pending",
        "timestamp": DateTime
            .now()
            .millisecondsSinceEpoch,
        "leaveon": duedate.text,
        "phoneno": staffphono,
        "staffname": staffname,
        "regno": staffregno,
      });
      _firestore2db.collection('Leave').doc(docid).set({
        "type": leavetype,
        "date": "${DateTime
            .now()
            .day}-${DateTime
            .now()
            .month}-${DateTime
            .now()
            .year}",
        "time": "${DateFormat('hh:mm a').format(DateTime.now())}",
        "reason": homecoller.text,
        "status": "Pending",
        "timestamp": DateTime
            .now()
            .millisecondsSinceEpoch,
        "leaveon": duedate.text,
        "phoneno": staffphono,
        "staffname": staffname,
        "regno": staffregno,
      });
    }
    else{
      _firestore2db.collection("Staffs").doc(staffid).collection('Leave').doc(
          docid).update({
        "type": leavetype,
        "date": "${DateTime
            .now()
            .day}-${DateTime
            .now()
            .month}-${DateTime
            .now()
            .year}",
        "time": "${DateFormat('hh:mm a').format(DateTime.now())}",
        "reason": homecoller.text,
        "status": "Pending",
        "timestamp": DateTime
            .now()
            .millisecondsSinceEpoch,
        "leaveon": duedate.text,
        "phoneno": staffphono,
        "staffname": staffname,
        "regno": staffregno,
      });
      _firestore2db.collection('Leave').doc(docid).update({
        "type": leavetype,
        "date": "${DateTime
            .now()
            .day}-${DateTime
            .now()
            .month}-${DateTime
            .now()
            .year}",
        "time": "${DateFormat('hh:mm a').format(DateTime.now())}",
        "reason": homecoller.text,
        "status": "Pending",
        "timestamp": DateTime
            .now()
            .millisecondsSinceEpoch,
        "leaveon": duedate.text,
        "phoneno": staffphono,
        "staffname": staffname,
        "regno": staffregno,
      });
    }

  }

  submitleavepopup() {
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/0.87111111,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Leave applied successfully',



      btnOkOnPress: () {
        setState(() {
          leavetype="Leave Type";
          homecoller.clear();
          topic.clear();

          duedate.clear();
        });
      },
    )..show();

  }

  croppimage()async{
    if(_pickedFile==null) {
      ImagePicker _picker = ImagePicker();
      await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
        if (xFile != null) {
          setState(() {
            _pickedFile = File(xFile.path);
          });
        }
      });

    }
    else if(_pickedFile2==null) {
      ImagePicker _picker = ImagePicker();
      await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
        if (xFile != null) {
          setState(() {
            _pickedFile2 = File(xFile.path);
          });
        }
      });
    }
    else if(_pickedFile3==null) {
      ImagePicker _picker = ImagePicker();
      await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
        if (xFile != null) {
          setState(() {
            _pickedFile3 = File(xFile.path);
          });
        }
      });
    }
    else if(_pickedFile4==null) {
      ImagePicker _picker = ImagePicker();
      await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
        if (xFile != null) {
          setState(() {
            _pickedFile4 = File(xFile.path);
          });
        }
      });
    }
    else  if(_pickedFile5==null) {
      ImagePicker _picker = ImagePicker();
      await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
        if (xFile != null) {
          setState(() {
            _pickedFile5 = File(xFile.path);
          });
        }
      });
    }

  }

  addattachment() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery,).then((xFile) {
      if (xFile != null) {
        setState(() {
          _pickedFile = File(xFile.path);
        });
      }
    });
    print("fun one completed");
    print(_pickedFile!.path);
    print(
        "Fun 2 Starteddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
  }

  int Day1 = 0;
  int Day2 = 0;
  int Day3 = 0;
  int Day4 = 0;
  int Day5 = 0;
  int Day6 = 0;
  int Day7 = 0;

  List months = [
    "january",
    "february",
    "march",
    "april",
    "may",
    "june",
    "july",
    "august",
    "september",
    "october",
    "november",
    "december"
  ];

  monthfun() {
    if (months == "january" || months == "march" ||
        months == "may" || months == "july"
        || months == "september" || months == "november") {
      for (int day = 1; day <= 31; day++) {
        if (day == "Monday") {
          setState(() {
            Day1 = currentDate + 0;
            Day2 = currentDate + 1;
            Day3 = currentDate + 2;
            Day4 = currentDate + 3;
            Day5 = currentDate + 4;
            Day6 = currentDate + 5;
            Day7 = currentDate + 6;
          });
        } else if (day == "Tuesday") {
          setState(() {
            Day1 = currentDate - 1;
            Day2 = currentDate + 0;
            Day3 = currentDate + 1;
            Day4 = currentDate + 2;
            Day5 = currentDate + 3;
            Day6 = currentDate + 4;
            Day7 = currentDate + 5;
          });
        } else if (day == "Wednesday") {
          setState(() {
            Day1 = currentDate - 1;
            Day2 = currentDate - 2;
            Day3 = currentDate + 0;
            Day4 = currentDate + 1;
            Day5 = currentDate + 2;
            Day6 = currentDate + 3;
            Day7 = currentDate + 4;
          });
        } else if (day == "Thursday") {
          setState(() {
            Day1 = currentDate - 1;
            Day2 = currentDate - 2;
            Day3 = currentDate - 3;
            Day4 = currentDate + 0;
            Day5 = currentDate + 1;
            Day6 = currentDate + 2;
            Day7 = currentDate + 3;
          });
        } else if (day == "Friday") {
          setState(() {
            Day1 = currentDate - 1;
            Day2 = currentDate - 2;
            Day3 = currentDate - 3;
            Day4 = currentDate - 4;
            Day5 = currentDate + 0;
            Day6 = currentDate + 1;
            Day7 = currentDate + 2;
          });
        } else if (day == "Saturday") {
          setState(() {
            Day1 = currentDate - 1;
            Day2 = currentDate - 2;
            Day3 = currentDate - 3;
            Day4 = currentDate - 4;
            Day5 = currentDate - 5;
            Day6 = currentDate + 0;
            Day7 = currentDate + 1;
          });
        } else if (day == "Sunday") {
          setState(() {
            Day1 = currentDate - 1;
            Day2 = currentDate - 2;
            Day3 = currentDate - 3;
            Day4 = currentDate - 4;
            Day5 = currentDate - 5;
            Day6 = currentDate - 6;
            Day7 = currentDate + 0;
          });
        }
      }
    }
    else if (months == "february" || months == "april" ||
        months == "june" || months == "august"
        || months == "october" || months == "december") {
      for (int day = 1; day <= 30; day++) {
        if (day == "Monday") {
          setState(() {
            Day1 = currentDate + 0;
            Day2 = currentDate + 1;
            Day3 = currentDate + 2;
            Day4 = currentDate + 3;
            Day5 = currentDate + 4;
            Day6 = currentDate + 5;
            Day7 = currentDate + 6;
          });
        } else if (day == "Tuesday") {
          setState(() {
            Day1 = currentDate - 1;
            Day2 = currentDate + 0;
            Day3 = currentDate + 1;
            Day4 = currentDate + 2;
            Day5 = currentDate + 3;
            Day6 = currentDate + 4;
            Day7 = currentDate + 5;
          });
        } else if (day == "Wednesday") {
          setState(() {
            Day1 = currentDate - 1;
            Day2 = currentDate - 2;
            Day3 = currentDate + 0;
            Day4 = currentDate + 1;
            Day5 = currentDate + 2;
            Day6 = currentDate + 3;
            Day7 = currentDate + 4;
          });
        } else if (day == "Thursday") {
          setState(() {
            Day1 = currentDate - 1;
            Day2 = currentDate - 2;
            Day3 = currentDate - 3;
            Day4 = currentDate + 0;
            Day5 = currentDate + 1;
            Day6 = currentDate + 2;
            Day7 = currentDate + 3;
          });
        } else if (day == "Friday") {
          setState(() {
            Day1 = currentDate - 1;
            Day2 = currentDate - 2;
            Day3 = currentDate - 3;
            Day4 = currentDate - 4;
            Day5 = currentDate + 0;
            Day6 = currentDate + 1;
            Day7 = currentDate + 2;
          });
        } else if (day == "Saturday") {
          setState(() {
            Day1 = currentDate - 1;
            Day2 = currentDate - 2;
            Day3 = currentDate - 3;
            Day4 = currentDate - 4;
            Day5 = currentDate - 5;
            Day6 = currentDate + 0;
            Day7 = currentDate + 1;
          });
        } else if (day == "Sunday") {
          setState(() {
            Day1 = currentDate - 1;
            Day2 = currentDate - 2;
            Day3 = currentDate - 3;
            Day4 = currentDate - 4;
            Day5 = currentDate - 5;
            Day6 = currentDate - 6;
            Day7 = currentDate + 0;
          });
        }
      }
    }
  }

  dayfun() {
    if (day == "Monday") {
      setState(() {
        Day1 = currentDate + 0;
        Day2 = currentDate + 1;
        Day3 = currentDate + 2;
        Day4 = currentDate + 3;
        Day5 = currentDate + 4;
        Day6 = currentDate + 5;
        Day7 = currentDate + 6;
      });
    } else if (day == "Tuesday") {
      setState(() {
        Day1 = currentDate - 1;
        Day2 = currentDate + 0;
        Day3 = currentDate + 1;
        Day4 = currentDate + 2;
        Day5 = currentDate + 3;
        Day6 = currentDate + 4;
        Day7 = currentDate + 5;
      });
    } else if (day == "Wednesday") {
      setState(() {
        Day1 = currentDate - 1;
        Day2 = currentDate - 2;
        Day3 = currentDate + 0;
        Day4 = currentDate + 1;
        Day5 = currentDate + 2;
        Day6 = currentDate + 3;
        Day7 = currentDate + 4;
      });
    } else if (day == "Thursday") {
      setState(() {
        Day1 = currentDate - 1;
        Day2 = currentDate - 2;
        Day3 = currentDate - 3;
        Day4 = currentDate + 0;
        Day5 = currentDate + 1;
        Day6 = currentDate + 2;
        Day7 = currentDate + 3;
      });
    } else if (day == "Friday") {
      setState(() {
        Day1 = currentDate - 1;
        Day2 = currentDate - 2;
        Day3 = currentDate - 3;
        Day4 = currentDate - 4;
        Day5 = currentDate + 0;
        Day6 = currentDate + 1;
        Day7 = currentDate + 2;
      });
    } else if (day == "Saturday") {
      setState(() {
        Day1 = currentDate - 1;
        Day2 = currentDate - 2;
        Day3 = currentDate - 3;
        Day4 = currentDate - 4;
        Day5 = currentDate - 5;
        Day6 = currentDate + 0;
        Day7 = currentDate + 1;
      });
    } else if (day == "Sunday") {
      setState(() {
        Day1 = currentDate - 1;
        Day2 = currentDate - 2;
        Day3 = currentDate - 3;
        Day4 = currentDate - 4;
        Day5 = currentDate - 5;
        Day6 = currentDate - 6;
        Day7 = currentDate + 0;
      });
    }
  }
  final homecontroller = Get.put(HomeController());



  attendaceupload() async {
    var document2 = await _firestore2db.collection("Attendance").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}").collection("${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}").get();
    if(document2.docs.length>0){
      Alreadymarked();
    }
    else {
      Successdialog();
      var document = await _firestore2db.collection("Students").orderBy("timestamp").get();
      for (int i = 0; i < document.docs.length; i++) {
        if (document.docs[i]["admitclass"] == _typeAheadControllerclass.text &&
            document.docs[i]["section"] == _typeAheadControllersection.text) {
          _firestore2db.collection("Attendance").doc(
              "${_typeAheadControllerclass.text}${_typeAheadControllersection
                  .text}").
          collection("${DateTime
              .now()
              .day}-${DateTime
              .now()
              .month}-${DateTime
              .now()
              .year}").doc().set({
            "stname": document.docs[i]["stname"],
            "regno": document.docs[i]["regno"],
            "stdocid": document.docs[i].id,
            "present": present[i],
            "order": i
          });
          if (present[i] == true) {
            _firestore2db.collection("Students").doc(document.docs[i].id)
                .collection("Attendance").
            doc("${DateTime
                .now()
                .day}-${DateTime
                .now()
                .month}-${DateTime
                .now()
                .year}")
                .set({
              "Attendance": "Present",
              "Date": "${DateTime
                  .now()
                  .day}-${DateTime
                  .now()
                  .month}-${DateTime
                  .now()
                  .year}",
              "timesatmp": DateTime
                  .now()
                  .millisecondsSinceEpoch,
              "month":cmonth
            });
          }
          if (present[i] == false) {
            _firestore2db.collection("Students").doc(document.docs[i].id)
                .collection("Attendance").
            doc("${DateTime
                .now()
                .day}-${DateTime
                .now()
                .month}-${DateTime
                .now()
                .year}")
                .set({
              "Attendance": "Absent",
              "Date": "${DateTime
                  .now()
                  .day}-${DateTime
                  .now()
                  .month}-${DateTime
                  .now()
                  .year}",
              "timesatmp": DateTime
                  .now()
                  .millisecondsSinceEpoch,
              "month":cmonth
            });
            _firestore2db.collection("Students")
                .doc(document.docs[i].id)
                .update({
              "absentdays": FieldValue.increment(1),
            });
          }
          if (present[i] == true) {
            homecontroller.sendPushMessage(document.docs[i]["token"],
                "Attendance marked as Present for ${document
                    .docs[i]["stname"]} today", "Attendance Update","Attendance");
          }
          if (present[i] == false) {
            homecontroller.sendPushMessage(document.docs[i]["token"],
                "Attendance marked as Absent for ${document
                    .docs[i]["stname"]} today", "Attendance Update","Attendance");
          }
        }
      }
    }

  }
  demo() {
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/0.87111111,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Are you sure want to exit',


      btnCancelOnPress: (){

      },
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
  Successdialog() {
    return AwesomeDialog(
      width: 450,
      context: context,

      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Attendance Submitted Successfully',
      desc: 'Attendance Submitted for - ${_typeAheadControllerclass
          .text} ${_typeAheadControllersection.text}',


      btnOkOnPress: () {
        checkattendance();
        setState(() {
          page="Home";
        });
       // Navigator.of(context).pop();
      },
    )
      ..show();
  }
  Alreadymarked() {
    return AwesomeDialog(
      width: 450,
      context: context,

      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Attendance Already Marked',
      desc: 'Attendance Already Marked for - ${_typeAheadControllerclass
          .text} ${_typeAheadControllersection.text}',


      btnOkOnPress: () {
        checkattendance();
        setState(() {
          page="Home";
        });
       // Navigator.of(context).pop();
      },
    )
      ..show();
  }

  Errordialog() {
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width / 0.87111111,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Please select Class and Section',


      btnOkOnPress: () {


      },
    )
      ..show();
  }


  good(id) {
    _firestore2db
        .collection("Students")
        .doc(id)
        .update({"isSelected": true});
  }

  bad(id) {
    _firestore2db
        .collection("Students")
        .doc(id)
        .update({"isSelected": false});
  }

  bool marked = false;

  checkattendance() async {
    setState(() {
      marked = false;
    });
    var document = await _firestore2db.collection("Attendance").doc("${dropdownValue4}${dropdownValue5}").
    collection("${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}").get();
    if (document.docs.length > 0) {
      setState(() {
        marked = true;
      });
      print(marked);
    }
    print("sddddddddddddddddddddddddf");
  }


  TextEditingController homecoller = TextEditingController();
  TextEditingController topic = TextEditingController();
  dynamic formatterDate = DateFormat('dd');
  dynamic currentTime = DateFormat.jm().format(DateTime.now());

  SuccessHomeworkdialog() {
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      dismissOnTouchOutside: false,

      width: width/0.87111111,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,

      title: 'Assignment assigned Successfully',
      desc: '${subject} Assignment assigned for - ${_typeAheadControllerclass
          .text} ${_typeAheadControllersection.text} ',
      btnOkOnPress: () {
        setState(() {
          _pickedFile=null;
          _pickedFile2=null;
          _pickedFile3=null;
          _pickedFile4=null;
          _pickedFile5=null;
          imageurl1="";
          imageurl2="";
          imageurl3="";
          imageurl4="";
          imageurl5="";
          homecoller.clear();
          topic.clear();
          page = "Home";
          _typeAheadControllerclass.clear();
          _typeAheadControllersection.clear();
           dropdownValue4 = "Class";
           dropdownValue5 = "Section";
          duedate.clear();
          homecoller.clear();
          topic.clear();
          subject="Subject";
        });
      },
    )
      ..show();
  }

  ErrorHomeworkdialog() {
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/0.87111111,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Kindly fill all the fields',


      btnOkOnPress: () {


      },
    )
      ..show();
  }

  String imageurl1="";
  String imageurl2="";
  String imageurl3="";
  String imageurl4="";
  String imageurl5="";
  int status = 0;
  
  List teachertable=["","","","","","","",""];
  timetablelogic() async {
    setState(() {
      teachertable=["","","","","","","",""];
    });

      var document= await _firestore2db.collection("Staffs").doc(staffid).collection('Timetable').where("day", isEqualTo: day).get();
      setState(() {
      if(day=="Monday"){
      for(int i=0;i<document.docs.length;i++){

          if(document.docs[i]["period"]==0){
            teachertable.replaceRange(0,1,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==1){
            teachertable.replaceRange(1,2,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==2){
            teachertable.replaceRange(2,3,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==3){
            teachertable.replaceRange(3,4,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==4){
            teachertable.replaceRange(4,5,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==5){
            teachertable.replaceRange(5,6,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==6){
            teachertable.replaceRange(6,7,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==7){
            teachertable.replaceRange(7,8,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }


        }
      for(int j=0;j<teachertable.length;j++){
        if(teachertable[j]==""){
          teachertable.replaceRange(j, j+1, ["Free Period"]);
        }
      }
      }
      if(day=="Tuesday"){
      for(int i=0;i<document.docs.length;i++){

          if(document.docs[i]["period"]==8){
            teachertable.replaceRange(0,1,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==9){
            teachertable.replaceRange(1,2,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==10){
            teachertable.replaceRange(2,3,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==11){
            teachertable.replaceRange(3,4,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==12){
            teachertable.replaceRange(4,5,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==13){
            teachertable.replaceRange(5,6,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==14){
            teachertable.replaceRange(6,7,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==15){
            teachertable.replaceRange(7,8,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }


        }
      for(int j=0;j<teachertable.length;j++){
        if(teachertable[j]==""){
          teachertable.replaceRange(j, j+1, ["Free Period"]);
        }
      }
      }
      if(day=="Wednesday"){
      for(int i=0;i<document.docs.length;i++){

          if(document.docs[i]["period"]==16){
            teachertable.replaceRange(0,1,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==17){
            teachertable.replaceRange(1,2,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==18){
            teachertable.replaceRange(2,3,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==19){
            teachertable.replaceRange(3,4,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==20){
            teachertable.replaceRange(4,5,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==21){
            teachertable.replaceRange(5,6,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==22){
            teachertable.replaceRange(6,7,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==23){
            teachertable.replaceRange(7,8,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }


        }
      for(int j=0;j<teachertable.length;j++){
        if(teachertable[j]==""){
          teachertable.replaceRange(j, j+1, ["Free Period"]);
        }
      }
      }
      if(day=="Thursday"){
      for(int i=0;i<document.docs.length;i++){

          if(document.docs[i]["period"]==24){
            teachertable.replaceRange(0,1,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==25){
            teachertable.replaceRange(1,2,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==26){
            teachertable.replaceRange(2,3,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==27){
            teachertable.replaceRange(3,4,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==28){
            teachertable.replaceRange(4,5,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==29){
            teachertable.replaceRange(5,6,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==30){
            teachertable.replaceRange(6,7,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==31){
            teachertable.replaceRange(7,8,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }


        }
      for(int j=0;j<teachertable.length;j++){
        if(teachertable[j]==""){
          teachertable.replaceRange(j, j+1, ["Free Period"]);
        }
      }
      }
      if(day=="Friday"){
      for(int i=0;i<document.docs.length;i++){

          if(document.docs[i]["period"]==32){
            teachertable.replaceRange(0,1,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==33){
            teachertable.replaceRange(1,2,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==34){
            teachertable.replaceRange(2,3,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==35){
            teachertable.replaceRange(3,4,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==36){
            teachertable.replaceRange(4,5,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==37){
            teachertable.replaceRange(5,6,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==38){
            teachertable.replaceRange(6,7,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==39){
            teachertable.replaceRange(7,8,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }


        }
      for(int j=0;j<teachertable.length;j++){
        if(teachertable[j]==""){
          teachertable.replaceRange(j, j+1, ["Free Period"]);
        }
      }
      }
      if(day=="Saturday"){
      for(int i=0;i<document.docs.length;i++){

          if(document.docs[i]["period"]==40){
            teachertable.replaceRange(0,1,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==41){
            teachertable.replaceRange(1,2,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==42){
            teachertable.replaceRange(2,3,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==43){
            teachertable.replaceRange(3,4,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==44){
            teachertable.replaceRange(4,5,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==45){
            teachertable.replaceRange(5,6,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==46){
            teachertable.replaceRange(6,7,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }
          else if(document.docs[i]["period"]==47){
            teachertable.replaceRange(7,8,["${document.docs[i]["class"]} ${document.docs[i]["section"]}" ]);
          }



        }
      for(int j=0;j<teachertable.length;j++){
        if(teachertable[j]==""){
          teachertable.replaceRange(j, j+1, ["Free Period"]);
        }
      }
      }
      });
      print(teachertable);

  }
  

  add() async {
    int status = 1;
    if(_pickedFile!=null) {
      var ref = _firebaseStorage2.ref().child('ListImages').child(
          "${_pickedFile!.path}.jpg");

      var uploadTask2 = await ref.putFile(_pickedFile!).catchError((
          error) async {
        status = 0;
      });


      if (status == 1) {
        imageurl1 = await uploadTask2.ref.getDownloadURL();


        print(imageurl1);
      }
    }
    if(_pickedFile2!=null) {
      var ref = _firebaseStorage2.ref().child('ListImages').child(
          "${_pickedFile2!.path}.jpg");

      var uploadTask2 = await ref.putFile(_pickedFile2!).catchError((
          error) async {
        status = 0;
      });


      if (status == 1) {
        imageurl2 = await uploadTask2.ref.getDownloadURL();


        print(imageurl2);
      }
    }
    if(_pickedFile3!=null) {
      var ref = _firebaseStorage2.ref().child('ListImages').child(
          "${_pickedFile3!.path}.jpg");

      var uploadTask2 = await ref.putFile(_pickedFile3!).catchError((
          error) async {
        status = 0;
      });


      if (status == 1) {
        imageurl3 = await uploadTask2.ref.getDownloadURL();


        print(imageurl3);
      }
    }
    if(_pickedFile4!=null) {
      var ref = _firebaseStorage2.ref().child('ListImages').child(
          "${_pickedFile4!.path}.jpg");

      var uploadTask2 = await ref.putFile(_pickedFile4!).catchError((
          error) async {
        status = 0;
      });


      if (status == 1) {
        imageurl4 = await uploadTask2.ref.getDownloadURL();


        print(imageurl4);
      }
    }
    if(_pickedFile5!=null) {
      var ref = _firebaseStorage2.ref().child('ListImages').child(
          "${_pickedFile5!.path}.jpg");

      var uploadTask2 = await ref.putFile(_pickedFile5!).catchError((
          error) async {
        status = 0;
      });


      if (status == 1) {

        imageurl5 = await uploadTask2.ref.getDownloadURL();


        print(imageurl5);
      }
    }

    print( "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
    print(homecoller.text);
    print(topic.text);
    print("+Des++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    _firestore2db.collection("homeworks").doc("${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}").
    collection(_typeAheadControllerclass.text).doc(_typeAheadControllersection.text).
    collection("class HomeWorks").doc().set({
      "class": _typeAheadControllerclass.text,
      "section": _typeAheadControllersection.text,
      "date": "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
      "Assignedondate":"${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
      "Duedate":duedate.text,
      "des": homecoller.text,
      "topic": topic.text,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "Time": "${DateFormat('hh:mm a').format(DateTime.now())}",
      "statffname": staffname,
      "statffregno": staffregno,
      "statffid": staffid,
      "subject": subject,
      "imageurl1": imageurl1,
      "imageurl2": imageurl2,
      "imageurl3": imageurl3,
      "imageurl4": imageurl4,
      "imageurl5": imageurl5,
      "submited":[]
    });
    
    
    var studentdata=await _firestore2db.collection("Students").
    where("admitclass",isEqualTo: _typeAheadControllerclass.text).where("section",isEqualTo: _typeAheadControllersection.text).get();

    for(int i=0;i<studentdata.docs.length;i++){
      sendPushMessage( studentdata.docs[i]['token'],  "New Assignment has been assigned for ${subject}","Assignment Update","Assignment");
    }

    
    

    
    _typeAheadControllerclass.clear();
    _typeAheadControllersection.clear();
    duedate.clear();
    homecoller.clear();
    topic.clear();
    subject="Subject";
    setState(() {
      dropdownValue4 = "Class";
      dropdownValue5 = "Section";
       _pickedFile=null;
       _pickedFile2=null;
      _pickedFile3=null;
       _pickedFile4=null;
       _pickedFile5=null;
    });
  }
  TextEditingController editreq= new TextEditingController();


  void sendPushMessage(String token, String body, String title,String Page) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=AAAA9pRd_9E:APA91bGFLaH3PezX-9cPq6c4udZ2lHi5kM3XF6UCdyASEy313xc6SugRk07JiSTzdlSILGA9szuW3DUjyKvtPYttwsgD7oU7D6edQ6Gc9Txvq0EqeMLvrAwcmR2wAaRLh3b1LxStu23m',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title,  "page":Page},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',

            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }
  
  
  showedit() {
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
            height: height/2.23714286,
            width: width/1.03157895,
            child: Column(
              children: [
                Text("Request Edit to Admin",style: GoogleFonts.poppins(

                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: width/15.68),),
                Lottie.asset("assets/profile.json"),
                Container(
                  padding: EdgeInsets.only(
                      left: width / 36, right: width / 36),
                  height: height / 10.74,
                  width: width / 1.563,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.grey.shade300),
                      borderRadius:
                      BorderRadius.circular(10)),
                  child: TextField(
                    controller: editreq,


                    style: GoogleFonts
                        .poppins(
                      color: Colors
                          .black,
                      fontSize: width/28,
                      fontWeight:
                      FontWeight
                          .w500,
                    ),

                    maxLines: 5,
                    minLines: 1,
                    decoration:
                    InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15),

                        hintText: "Enter what you want to change",
                        hintStyle:
                        GoogleFonts
                            .poppins(
                          color: Colors
                              .black,
                          fontSize: width/28,
                          fontWeight:
                          FontWeight
                              .w500,
                        ),
                        border:
                        InputBorder
                            .none),


                  ),


                ),



              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Request Admin'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
  ltpdialog(type,date,time,leaveon,reason,status,id) {
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
          title: Text(type,style: GoogleFonts.poppins(

              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: width/15.68)),
          content: Container(

            width: width/1.03157895,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Applied: ${date} | ${time} \nLeave on : ${leaveon} ",style: GoogleFonts.poppins(

                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: width/25.68),
                  textAlign: TextAlign.center,),
                  SizedBox(height: height/75.6,),
                  Text("Reason",style: GoogleFonts.poppins(

                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: width/25.68),
                    textAlign: TextAlign.center,),
                  SizedBox(height: height/75.6,),
                  Container(
                    padding: EdgeInsets.only(
                        left: width / 36, right: width / 36),

                    width: width / 1.563,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.grey.shade300),
                        borderRadius:
                        BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(reason,style: GoogleFonts.poppins(

                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: width/30.68),),
                    )


                  ),
                  status=="Pending"?     Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      status=="Pending"?   TextButton(
                        child: const Text('Revoke'),
                        onPressed: () {
                          _firestore2db.collection("Staffs").doc(staffid).collection('Leave').doc(id).update({
                            "status":"Revoked"
                          });
                          Navigator.of(context).pop();
                          revokedshow();

                        },
                      ) : SizedBox(),
                      status=="Pending"?  TextButton(
                        child: const Text('Edit'),
                        onPressed: () {
                          Future.delayed(Duration(seconds: 1),(){
                            setdata(type,leaveon,reason,id);
                          });
                          Navigator.of(context).pop();


                        },
                      ) : SizedBox(),
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ) : SizedBox()



                ],
              ),
            ),
          ),
          actions: [
            status=="Pending"? SizedBox(): TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],

        );
      }
    );
  }

  String docid="";
  setdata(leavetype2,duedate2,reason,id){
    setState(() {
      leavetype=leavetype2;
      duedate.text=duedate2;
      homecoller.text=reason;
      docid=id;
    });

  }

  updaetremarks(id, value, remarks) {
    _firestore2db.collection("Students").doc(id).update({
      "value": value,
      "Remarks": remarks,
    });
  }


  onetimefun() async {
    var document1 = await _firestore2db.collection("Students")
        .orderBy("regno")
        .get();
    for (int i = 0; i < document1.docs.length; i++) {
      _firestore2db.collection("Students").doc(document1.docs[i].id).update({
        "Remarks": "Good"
      });
    }
    print("Updated All");
  }

  TextEditingController remarkscon = new TextEditingController();

  _showMyDialog(name, remark, id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        String dropfedback4 = "Good";
        List<String> feedback = ["Good", "Average", "Bad",];

        double height = MediaQuery
            .of(context)
            .size
            .height;
        double width = MediaQuery
            .of(context)
            .size
            .width;
        return StatefulBuilder(

            builder: (context, setstae) {
              return AlertDialog(
                title: Text(
                  'Give Feedback for ${name}', style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: width/21.77777778,
                    fontWeight: FontWeight.w700

                ),),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Container(
                            padding: EdgeInsets.only(
                                left: width / 36, right: width / 36),
                            height: height / 14.74,
                            width: width / 1.563,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey.shade300),
                                borderRadius:
                                BorderRadius.circular(10)),
                            child: TextField(
                              controller: remarkscon,


                              style: GoogleFonts
                                  .poppins(
                                color: Colors
                                    .black,
                                fontSize: width/28,
                                fontWeight:
                                FontWeight
                                    .w500,
                              ),

                              maxLines: 5,
                              minLines: 1,
                              decoration:
                              InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 15),

                                  hintText:
                                  remark,
                                  hintStyle:
                                  GoogleFonts
                                      .poppins(
                                    color: Colors
                                        .black,
                                    fontSize: width/28,
                                    fontWeight:
                                    FontWeight
                                        .w500,
                                  ),
                                  border:
                                  InputBorder
                                      .none),


                            ),


                          ),


                        ],
                      ),
                      SizedBox(height: height/78.3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Container(
                            padding: EdgeInsets.only(
                                left: width / 36, right: width / 36),
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
                              value: dropfedback4,
                              isExpanded: true,
                              style: TextStyle(
                                  color: Color(0xff3D8CF8),
                                  fontSize: width/23.05882353, fontWeight: FontWeight.w700),
                              underline: Container(
                                color: Color(0xff3D8CF8),
                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setstae(() {
                                  dropfedback4 = value!;
                                });
                              },
                              items:
                              feedback.map<DropdownMenuItem<String>>(
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


                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Update Feedback'),
                    onPressed: () {
                      updaetremarks(id, dropfedback4, remarkscon.text);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
        );
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
                alignment:  chatMap['sender']==staffname?Alignment.centerRight: Alignment.centerLeft,
                child:
                GestureDetector(
                  onLongPress: () {
                    showDialog(context: context, builder: (ctx) =>
                        AlertDialog(
                          title: Text('Are you sure delete this message'),
                          actions: [
                            TextButton(onPressed: () {
                              _firestore2db.collection('${dropdownValue4}${dropdownValue5}chat')
                                  .doc(id)
                                  .delete();
                              Navigator.pop(context);
                            }, child: Text('Delete'))
                          ],
                        ));
                    print('ir');
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 8, horizontal: 14),
                      margin: EdgeInsets.symmetric(
                          vertical: 5, horizontal: 0),
                      decoration: BoxDecoration(
                        color:  chatMap['sender']==staffname? Colors.white: Color(0xff0271C5),
                        border: Border.all(color: chatMap['sender']==staffname? Color(0xff010029)
                            .withOpacity(0.65) : Color(0xff0271C5)),
                        borderRadius: BorderRadius.only(topLeft: Radius
                            .circular(15),
                          bottomLeft: chatMap['sender']==staffname? Radius.circular(15) : Radius.circular(0),
                          bottomRight: chatMap['sender']==staffname? Radius.circular(0) : Radius.circular(15),
                          topRight: Radius.circular(15),),
                      ),
                      child: Column(
                        children: [
                          Text(
                            chatMap['message'],
                            style: GoogleFonts.montserrat(
                              fontSize: width/30.15384615,
                              fontWeight: FontWeight.w500,
                              color: chatMap['sender']==staffname? Colors.black : Colors.white,
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
        "sender":staffname,
        "submitdate":"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
      };
      var document = await _firestore2db.collection("Students").orderBy("timestamp").get();
      for (int i = 0; i < document.docs.length; i++) {
        if (document.docs[i]["admitclass"] == _typeAheadControllerclass.text &&
            document.docs[i]["section"] == _typeAheadControllersection.text) {
          homecontroller.sendPushMessage(document.docs[i]["token"], _message.text, "New message alert","Message");
        }
      }


      _message.clear();
      await _firestore2db
          .collection('${dropdownValue4}${dropdownValue5}chat')
          .add(chatData);
    }
  }


}



FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseStorage _firebaseStorage2= FirebaseStorage.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);