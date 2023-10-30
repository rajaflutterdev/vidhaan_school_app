import 'dart:developer';

import 'package:vidhaan_school_app/app/modules/register_screen/controllers/register_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreenView extends StatelessWidget {

  final registercontroller = Get.put(RegisterScreenController());

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    log(registercontroller.clientusers.length.toString());
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  const Text(
                    "Client Applicaton",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              SizedBox(
                  height: height/15.12,
                  width: width/1.8,
                  child: ElevatedButton(
                      onPressed: () async {
                        registercontroller.getToken();
                      },
                      child: const Text(
                        "Iam Client",
                        style: TextStyle(fontSize: 18),
                      ),),),
            ]),
          ),
        ),
      ),
    );
  }
}
