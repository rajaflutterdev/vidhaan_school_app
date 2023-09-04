import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' show DateFormat;



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

  List<DateTime?> _dialogCalendarPickerValue = [];

  List <DateTime?>splitlist=[];

  String date='';
  String year='';
  String month='';
  String selct='24-72-2011';

  List<MarkedDate> markedDates=[];

  studentatten() async {
    setState(() {
      Presntlist.clear();
      Presntlist2.clear();
      Presntlist3.clear();
      absentlist.clear();
      absentlist2.clear();
      absentlist3.clear();
      splitlist.clear();
    });

    var studentdocument= await FirebaseFirestore.instance.collection("Students").doc("5d5ko1zzIGasiixy").
    collection('Attendance').where("Attendance",isEqualTo: "Present").get();
    for(int i=0;i<studentdocument.docs.length;i++){
      setState(() {
        final split = studentdocument.docs[i]['Date'].split('-');
        final Map<int, String> values = {
          for (int k = 0; k < split.length; k++)
            k: split[k]
        };
        print(values[0]);
        print(values[1]);
        print(values[2]);
        Presntlist.add(int.parse(values[0]!));
        Presntlist2.add(int.parse(values[1]!));
        Presntlist3.add(int.parse(values[2]!));
      });
    }

    var studentdocument2= await FirebaseFirestore.instance.collection("Students").doc("5d5ko1zzIGasiixy").
    collection('Attendance').where("Attendance",isEqualTo: "Absent").get();
    for(int j=0;j<studentdocument2.docs.length;j++){
      setState(() {
        final split = studentdocument2.docs[j]['Date'].split('-');
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

      });
    }
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
                  textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
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
                textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                date: DateTime(absentlist3[j], absentlist2[j], absentlist[j])));

      });

    }
    setState(() {

    });
    print(_dialogCalendarPickerValue);
    print("Hello");
    print(_markedDateMap.events.keys.indexed);

  }

  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];

  DateTime _currentDate = DateTime(2023, 7, 26);
  DateTime _currentDate2 = DateTime(2023, 7, 26);
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime(2023, 7, 31);
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
    studentatten();
    /// Add more events to _markedDateMap EventList
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Example with custom icon
    final _calendarCarousel = CalendarCarousel<Event>(
      onDayPressed: (date, events) {
        this.setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));
      },
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
//          weekDays: null, /// for pass null when you do not want to render weekDays
      headerText: 'Custom Header',
      weekFormat: true,
      markedDatesMap: _markedDateMap,
      height: 200.0,
      selectedDateTime: _currentDate2,
      showIconBehindDayText: true,
//          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      todayTextStyle: TextStyle(
        color: Colors.white,
      ),


      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.transparent,
      markedDateCustomTextStyle: TextStyle(fontSize: 25,color: Colors.red),
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
      inactiveWeekendTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
      weekdayTextStyle:  GoogleFonts.poppins(fontWeight: FontWeight.w700),
      weekendTextStyle:  GoogleFonts.poppins(fontWeight: FontWeight.w700),
      headerTextStyle:  GoogleFonts.poppins(fontWeight: FontWeight.w700),
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
      selectedDayButtonColor: Colors.transparent,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
      CircleBorder(
          side: BorderSide(color: Colors.yellow)),

      showHeader: false,
      todayTextStyle: GoogleFonts.poppins(
        color: Colors.blue,
        fontWeight: FontWeight.w700
      ),
      todayButtonColor: Colors.indigo,
      selectedDayTextStyle: GoogleFonts.poppins(
        color: Colors.yellow,
          fontWeight: FontWeight.w700
      ),
      showWeekDays: false,
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle:  GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle:  GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
        color: Colors.tealAccent,
        fontSize: 16,
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
          markedDates: markedDates
      ),
    );

    return SizedBox(
      height:400,
      child: new
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,

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
                          fontSize: 22.0,)

                    )),
                TextButton(
                  child: Text('PREV',style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                  onPressed: () {
                    setState(() {
                      _targetDateTime = DateTime(
                          _targetDateTime.year, _targetDateTime.month - 1);
                      _currentMonth =
                          DateFormat.yMMM().format(_targetDateTime);
                    });
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
    );
  }

}
