import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:percent_indicator/circular_percent_indicator.dart';



class StudentAttendance_Page extends StatefulWidget {
  String?Studentid;
  StudentAttendance_Page(this.Studentid);
  
  @override
  State<StudentAttendance_Page> createState() => _StudentAttendance_PageState();
}

class _StudentAttendance_PageState extends State<StudentAttendance_Page> {

  List Presntlist=[];
  List Presntlist2=[];
  List Presntlist3=[];
  List absentlist=[];
  List absentlist2=[];
  List absentlist3=[];
  
  List allabsentdaylist=[];
  List allabsentdaylist2=[];
  List presentabsentdaylist=[];

  List<DateTime?> _dialogCalendarPickerValue = [];

  List <DateTime?>splitlist=[];

  String date='';
  String year='';
  String month='';
  String selct='24-72-2011';

  List<MarkedDate> markedDates=[];

  int presentdayvalue=0;
  int absentdayvalue=0;
  int Totalvalue=0;

String cmonth = "";

  String getMonth(int currentMonthIndex) {
    return DateFormat('MMM').format(DateTime(0, currentMonthIndex)).toString();
  }

  studentatten() async {

    print("Studnet id ${widget.Studentid}");
    setState(() {
      presentdayvalue=0;
      absentdayvalue=0;
      presentabsentdaylist.clear();
      allabsentdaylist.clear();
      allabsentdaylist2.clear();
      Presntlist.clear();
      Presntlist2.clear();
      Presntlist3.clear();
      absentlist.clear();
      absentlist2.clear();
      absentlist3.clear();
      splitlist.clear();

    });

    var studentdocument= await _firestore2db.collection("Students").doc(widget.Studentid).
    collection('Attendance').orderBy("timesatmp",descending: true).get();
    print("Studnet 2 id ${widget.Studentid}");
    setState(() {
      Totalvalue=studentdocument.docs.length;
    });
    print("Studnet 3 id ${widget.Studentid}");
    print("Length of doc ${studentdocument.docs.length}");
    for(int i=0;i<studentdocument.docs.length;i++){
      if(studentdocument.docs[i]['Attendance']=="Present"){
        print(studentdocument.docs[i]['Date']);
       if(studentdocument.docs[i]['month']== cmonth){
          setState(() {
            presentdayvalue=presentdayvalue+1;
          });
        }
        setState(() {
          final split = studentdocument.docs[i]['Date'].split('-');
          final Map<int, String> values = {
            for (int k = 0; k < split.length; k++)
              k: split[k]
          };

          Presntlist.add(int.parse(values[0]!));
          Presntlist2.add(int.parse(values[1]!));
          Presntlist3.add(int.parse(values[2]!));

          presentabsentdaylist.add( DateTime(int.parse(values[2]!), int.parse(values[1]!), int.parse(values[0]!)));

        });
        print(presentdayvalue);
        print("++++++++++++++++++++++");
        print(Presntlist);
        print(Presntlist2);
        print(Presntlist3);
      }
      if(studentdocument.docs[i]['Attendance']=="Absent") {
      if(studentdocument.docs[i]['month']== cmonth){
          setState(() {
            absentdayvalue=absentdayvalue+1;
          });
        }
        setState(() {
          allabsentdaylist2.add(studentdocument.docs[i]['Date']);
          final split = studentdocument.docs[i]['Date'].split('-');
          final Map<int, String> values = {
            for (int k = 0; k < split.length; k++)
              k: split[k]
          };
          print(values[0]);
          print(values[1]);
          print(values[2]);
          absentlist.add(int.parse(values[0]!));
          absentlist2.add(int.parse(values[1]!));
          absentlist3.add(int.parse(values[2]!));

          allabsentdaylist.add( DateTime(int.parse(values[2]!), int.parse(values[1]!), int.parse(values[0]!)));

        });
        print(absentdayvalue);
      }

    }

    print("prrinting the lists presnt and absent lists");
    print(Presntlist);
    print(Presntlist2);
    print(Presntlist3);
    print(absentlist);
    print(absentlist2);
    print(absentlist3);
    for(int i=0;i<Presntlist.length;i++){
      setState(() {
        _markedDateMap.add(
            new DateTime(Presntlist3[i], Presntlist2[i], Presntlist[i]),
            new Event(
              date: new DateTime(Presntlist3[i], Presntlist2[i], Presntlist[i]),
              title: 'Present',
            ));
        markedDates.add(
            MarkedDate(color: Colors.green,
                  textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.white),
                date: DateTime(Presntlist3[i], Presntlist2[i], Presntlist[i])));
      });

    }

    for(int j=0;j<absentlist.length;j++){
      setState(() {
        _markedDateMap.add(
            new DateTime(absentlist3[j], absentlist2[j], absentlist[j]),
            new Event(
              date: new DateTime(absentlist3[j], absentlist2[j], absentlist[j]),
              title: 'Absent',
            ));
        markedDates.add(
            MarkedDate(color: Colors.red,
                textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.white),
                date: DateTime(absentlist3[j], absentlist2[j], absentlist[j])));

      });

    }
    setState(() {

    });
    print(_dialogCalendarPickerValue);
    print("Hello");
    print(_markedDateMap.events.keys.indexed);
    print("Presnt value000000000000000000000000$presentdayvalue");
    print("Absnet valeuooooooooooooooooooooo$absentdayvalue");

  }

  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];

  DateTime _currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _currentDate2 = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static Widget _eventIcon = new Container(
    width: 100,
    height:100,
  );

  EventList<Event> _markedDateMap = new
  EventList<Event>(
    events: {
    },
  );

  @override
  void initState() {
  cmonth = getMonth(DateTime
      .now()
      .month);
    studentatten();
    setState((){
      _currentMonth = DateFormat.yMMM().format(DateTime.now());
    });
    /// Add more events to _markedDateMap EventList
    super.initState();
  }
  presentvalue(){
    return (((presentdayvalue/Totalvalue)*100)/100);

}


  presentvaluetext(){
    return (((presentdayvalue/Totalvalue)*100)).toInt();

}





  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    /// Example with custom icon
    final _calendarCarousel = CalendarCarousel<Event>(
      onDayPressed: (date, events) {
        this.setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));
      },
      weekendTextStyle: TextStyle(
        color: Colors.black,
      ),
      thisMonthDayBorderColor: Colors.grey,
//          weekDays: null, /// for pass null when you do not want to render weekDays
      headerText: 'Custom Header',
      weekFormat: true,
      markedDatesMap: _markedDateMap,
      height: 200.0,
      selectedDateTime: _currentDate2,
      daysTextStyle: TextStyle(color: Colors.black),
      inactiveWeekendTextStyle: TextStyle(color: Colors.black),
      weekdayTextStyle: TextStyle(color: Colors.black),
      showIconBehindDayText: true,
//          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,



      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.transparent,
      markedDateCustomTextStyle: TextStyle(fontSize: width/24.4,color: Colors.white),
      markedDateMoreShowTotal:
      true, // null for not showing hidden events indicator
//          markedDateIconMargin: 9,
//          markedDateIconOffset: 3,
    );

    /// Example Calendar Carousel without header and custom prev & next button
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (date, events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
      },
      daysHaveCircularBorder: true,

      showOnlyCurrentMonthDate: false,
      markedDateIconMargin: 2,
   daysTextStyle:
    GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.black),
      inactiveWeekendTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.black),
      weekdayTextStyle:  GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.black),
      weekendTextStyle:  GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.black),
      headerTextStyle:  GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.black),
      nextDaysTextStyle:  GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.black),
      markedDateMoreCustomTextStyle:  GoogleFonts.poppins(fontWeight: FontWeight.w700,color: Colors.black),

      markedDateCustomTextStyle:  GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
          color:  Colors.white),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,

      selectedDayButtonColor: presentabsentdaylist.contains(_currentDate)?Colors.green:allabsentdaylist.contains(_currentDate)?Colors.red:Colors.transparent,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
      CircleBorder(
          side: BorderSide(color: Colors.yellow)),

      showHeader: false,
      todayTextStyle: GoogleFonts.poppins(
        color: presentabsentdaylist.contains(_currentDate)?Colors.white:allabsentdaylist.contains(_currentDate)?Colors.white:Colors.blue,

        fontWeight: FontWeight.w700
      ),
      todayButtonColor: Colors.indigoAccent,
      selectedDayTextStyle: GoogleFonts.poppins(
        color: presentabsentdaylist.contains(_currentDate)?Colors.white:allabsentdaylist.contains(_currentDate)?Colors.white:Colors.blue,
          fontWeight: FontWeight.w700
      ),
      showWeekDays: true,
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle:  GoogleFonts.poppins(
        fontSize: width/22.5,
        fontWeight: FontWeight.w700,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle:  GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
        color: Colors.tealAccent,
        fontSize: width/22.5,
      ),

      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
      multipleMarkedDates: MultipleMarkedDates(
          markedDates: markedDates,
      ),

    );

    return SizedBox(

      child: Column(
        children: [

          IgnorePointer(
           ignoring: false,
            child: SizedBox(
              height: height/2.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,

                children: <Widget>[
                  //custom icon

                  // This trailing comma makes auto-formatting nicer for build methods.

                  //custom icon without header
                  Container(
                    margin: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                              _currentMonth.toUpperCase(),
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w700,
                                  fontSize: width/16.36,)

                            )),

                        TextButton(
                          child: Text('PREV',style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                          onPressed: () {
                            setState(() {
                              _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month - 1);
                              _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                            });

                            print(_targetDateTime);
                            print(_currentMonth);
                          },
                        ),
                        TextButton(
                          child: Text('NEXT',style: GoogleFonts.poppins(fontWeight: FontWeight.w700),),
                          onPressed: () {
                            setState(() {
                              _targetDateTime = DateTime(
                                  _targetDateTime.year, _targetDateTime.month + 1);
                              _currentMonth =
                                  DateFormat.yMMM().format(_targetDateTime);
                            });
                          },
                        )
                      ],
                    ),
                  ),

                  SizedBox
                    (
                    child: _calendarCarouselNoHeader,
                  ),





                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  [
              CircleAvatar(
                radius: 8,
                foregroundColor: Colors.yellow,
                backgroundColor: Colors.yellowAccent,
              ),
              SizedBox(
               width: width/72,
              ),
              Text("Holiday",
                  style: TextStyle(
                      fontWeight: FontWeight.w700)),
              SizedBox(
                width: width/24,
              ),
              CircleAvatar(
                radius: 8,
                foregroundColor: Colors.red,
                backgroundColor: Colors.red,
              ),
              SizedBox(
               width: width/72,
              ),
              Text("Absent",
                  style: TextStyle(
                      fontWeight: FontWeight.w700)),
              SizedBox(
                width: width/24,
              ),
              CircleAvatar(
                radius: 8,
                foregroundColor: Colors.green,
                backgroundColor: Colors.green,
              ),
              SizedBox(
               width: width/72,
              ),
              Text("Present",
                  style: TextStyle(
                      fontWeight: FontWeight.w700)),
              SizedBox(
                width: width/18,
              ),
            ],
          ),
          SizedBox(height: height/37.8,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularPercentIndicator(
                  radius: 58,
                  lineWidth: width/24.0,
                  percent: presentvalue(),
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Text("Attendance",
                          style: GoogleFonts.poppins(
                              fontSize: width / 35.916,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      new Text("${presentvaluetext()} %",
                          style: GoogleFonts.poppins(
                              fontSize: width / 25.916,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  linearGradient: LinearGradient(begin: Alignment
                      .topRight,
                      end: Alignment.bottomLeft,
                      colors: <Color>[
                        Colors.green,
                        Colors.green
                      ]),
                  rotateLinearGradient: true,
                  circularStrokeCap: CircularStrokeCap.round),
              SizedBox(width: width/7.2,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: height/37.8,
                        width: width/9,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Center(child: Text(presentdayvalue.toString(),style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white),)),
                      ),
                      SizedBox(width: width/45,),
                      Text("Present",
                          style: TextStyle(
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                  SizedBox(height: height/75.6,),
                  Row(
                    children: [
                      Container(
                        height: height/37.8,
                        width: width/9,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Center(child: Text(absentdayvalue.toString(),style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white),)),
                      ),
                      SizedBox(width: width/45,),
                      Text("Absent",
                          style: TextStyle(
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),


            ],
          ),
          SizedBox(height: height/37.8,),

          Text(
              "Absent Days",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700,
                fontSize: width/18,)

          ),

          ListView.builder(
            shrinkWrap: true,
            physics:const  NeverScrollableScrollPhysics(),
            itemCount: allabsentdaylist2.length,
            itemBuilder: (context, index) {

              return
                Container(
                  height: height/12.6,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black)
                      )
                  ),
                  child: ListTile(
                    title:  Text(
                        "Date : ${allabsentdaylist2[index].toString()}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500,
                          fontSize: width/25.714,)

                    ),
                    subtitle:   Text(
                        "Day   : ${DateFormat("EEEE").format(DateFormat("dd-M-yyyy").parse(allabsentdaylist2[index].toString()))}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500,
                          fontSize: width/25.714,)

                    ),

                  ),
                );

          },)
          


          // Padding(
          //   padding: EdgeInsets.only(
          //       top: 15,
          //       left: 3,
          //       right: 8,
          //       bottom: 8),
          //   child: Text("Absent Days",
          //       style:
          //       GoogleFonts.poppins(
          //           fontWeight:
          //           FontWeight
          //               .w700,
          //           fontSize: 18)),
          // ),
          //
          // Padding(
          //   padding: EdgeInsets.only(
          //       left: 8.0),
          //   child: Container(
          //     height: 40,
          //     width: 320,
          //     decoration: BoxDecoration(
          //         color:
          //         Color(0xffFF0303),
          //         borderRadius:
          //         BorderRadius
          //             .circular(10)),
          //     child: Row(
          //       children: [
          //         SizedBox(width: width/24),
          //         ClipOval(
          //           child: Container(
          //               height: 15,
          //               width: width/24,
          //               color:
          //               Colors.white),
          //         ),
          //         SizedBox(width: width/24),
          //         Text("16/09/2023- Saturday",style:
          //         GoogleFonts.poppins(
          //             color:Colors.white,
          //             fontWeight:
          //             FontWeight
          //                 .w600,
          //             fontSize: 18))
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

}
FirebaseApp _secondaryApp = Firebase.app('SecondaryApp');
final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
FirebaseFirestore _firestore2db = FirebaseFirestore.instanceFor(app: _secondaryApp);
FirebaseAuth _firebaseauth2db = FirebaseAuth.instanceFor(app: _secondaryApp);