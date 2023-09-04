import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Update extends StatefulWidget {
  const Update({Key? key}) : super(key: key);

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

  String page = "";
  @override
  Widget build(BuildContext context) {


    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;
    return Scaffold(

      body: Column(

        children: [

          Padding(
            padding:  EdgeInsets.only(top: height/15.12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                GestureDetector(
                  onTap: (){
                    setState(() {
                      page = "Attendance";
                    });
                  },
                  child: Column(
                    children: [
                      Image.asset("assets/calendar.png"),
                      Text("Attendance",style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                      ),),
                    ],
                  ),
                ) ,   /// Attendance


                GestureDetector(
                  onTap: (){
                    setState(() {
                      page = "Home Works";

                    });
                  },

                  child: Column(
                    children: [
                      Image.asset("assets/edit.png"),
                      Text("Home Works",style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                      ),),
                    ],
                  ),
                ),    ///  home works



                GestureDetector(
                  onTap:  () {

                    setState(() {
                      page = "Behaviour";

                    });

                  },
                  child: Column(
                    children: [
                      Image.asset("assets/user.png"),
                      Text("Behaviour",style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                      ),),
                    ],
                  ),
                ),    ///  behaviour
              ],
            ),
          ),

          SizedBox(height: height/14.74),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    page="Circulars";
                  });
                },
                child: Column(
                  children: [
                    Image.asset("assets/important.png"),
                    Text("Circulars",style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    ),),
                  ],
                ),
              ) ,  /// circulars


              GestureDetector(
                onTap: (){
                  setState(() {
                    page = "Time Table";
                  });
                },
                child: Column(
                  children: [
                    Image.asset("assets/time.png"),
                    Text("Time Table",style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    ),),
                  ],
                ),
              ),   /// attendance


              GestureDetector(
                onTap: (){
                  setState(() {
                    page = "Messages";

                  });
                },
                child: Column(
                  children: [
                    Image.asset("assets/message.png"),
                    Text("Messages",style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    ),),
                  ],
                ),
              ),    /// messages
            ],
          ),

        ],

    )
    );
  }
}
