import 'package:flutter/material.dart';

class More_Menu_Page extends StatefulWidget {
  const More_Menu_Page({Key? key}) : super(key: key);

  @override
  State<More_Menu_Page> createState() => _More_Menu_PageState();
}

class _More_Menu_PageState extends State<More_Menu_Page> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Text("More Item details"),
      ),
    );
  }
}
