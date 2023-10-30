import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentCircular_Page extends StatefulWidget {


  @override
  State<StudentCircular_Page> createState() => _StudentCircular_PageState();
}

class _StudentCircular_PageState extends State<StudentCircular_Page> {
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Circulars").snapshots(),
        builder:(context, snapshot) {
          return Column(
            children: snapshot.data!.docs.map((e){
              return Container(
                height: height/7.56,
                width: double.infinity,
                color:Colors.red,
                child: Column(
                  children: [
                    Text(e['From']),
                    Text(e['reason']),
                    Text(e['Descr']),
                  ],
                ),
              );
            }).toList()
          );
        },
      ),
    );
  }
}
