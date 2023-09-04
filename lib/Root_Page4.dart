import 'package:flutter/material.dart';
import 'package:vidhaan_school_app/profile_page.dart';

class Root_Page4 extends StatefulWidget {
  const Root_Page4({Key? key}) : super(key: key);

  @override
  State<Root_Page4> createState() => _Root_Page4State();
}

class _Root_Page4State extends State<Root_Page4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3D8CF8),
      body:  Profile(),
    );
  }
}
