import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Student_homework extends StatefulWidget {
  String?Studentid;
  Student_homework(this.Studentid);


  @override
  State<Student_homework> createState() => _Student_homeworkState();
}

class _Student_homeworkState extends State<Student_homework> {

  String currentdate="${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      FutureBuilder<dynamic>(
        future: FirebaseFirestore.instance.collection("Students").doc(widget.Studentid).get(),
        builder: (context, snapshot) {
          var value=snapshot.data!.data();

          if(snapshot.hasData==null){
            return Center(child: CircularProgressIndicator(),);

          }
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);

          }
          return StreamBuilder(
             stream: FirebaseFirestore.instance.collection("homeworks").doc(currentdate.toString()).
             collection(value['admitclass'].toString()).doc(value['section'].toString()).
             collection("class HomeWorks").snapshots(),
             builder: (context, snapshot2) {
               if(snapshot2.hasData==null){
                 return Center(child: CircularProgressIndicator(),);
               }
               if(!snapshot2.hasData){
                 return Center(child: CircularProgressIndicator(),);
               }
                 return ListView.builder(
                   itemCount: snapshot2.data!.docs.length,
                   itemBuilder: (context, index) {
                     return Container();

                 },);
           },);

        },
      ),
    );
  }
}
