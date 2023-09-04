import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExamReports extends StatefulWidget {
  const ExamReports({Key? key}) : super(key: key);

  @override
  State<ExamReports> createState() => _ExamReportsState();
}

class _ExamReportsState extends State<ExamReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exam Reports",style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700

        ),),
      ),
    );
  }
}
