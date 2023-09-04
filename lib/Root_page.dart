import 'package:flutter/material.dart';
import 'package:vidhaan_school_app/profile_page.dart';

import 'Homepage2.dart';
import 'const_file.dart';
import 'excel.sheet.dart';

class Root_Page extends StatefulWidget {


  @override
  State<Root_Page> createState() => _Root_PageState();
}

class _Root_PageState extends State<Root_Page> {

  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;

    return  Scaffold(

      backgroundColor: Color(0xff3D8CF8),

      body:
      Frontpage()
    );
  }
}
