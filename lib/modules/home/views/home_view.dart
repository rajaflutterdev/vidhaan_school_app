import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidhaan_school_app/modules/home/controllers/home_controller.dart';


class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);
  final homecontroller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    log(homecontroller.clientusers.length.toString());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Admin ",
              style: TextStyle(fontSize: 30),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                decoration: InputDecoration(hintText: "Description"),
                controller: homecontroller.title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                decoration: InputDecoration(hintText: "Heding"),
                controller: homecontroller.body,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                homecontroller.findusers();
              },
              child: Text("Send Notification All"),
            )
          ],
        ),
      ),
    );
  }
}
