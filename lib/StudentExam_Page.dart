
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StudentExam_PAge extends StatefulWidget {
  const StudentExam_PAge({Key? key}) : super(key: key);

  @override
  State<StudentExam_PAge> createState() => _StudentExam_PAgeState();
}

class _StudentExam_PAgeState extends State<StudentExam_PAge> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      body: Center(child:Lottie.asset('assets/empty loader.json')),);
  }
}
