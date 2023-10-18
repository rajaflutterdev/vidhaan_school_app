import 'dart:developer';

import 'package:vidhaan_school_app/app/modules/register_screen/controllers/register_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreenView extends StatelessWidget {

  final registercontroller = Get.put(RegisterScreenController());

  @override
  Widget build(BuildContext context) {
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
                  height: 50,
                  width: 200,
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
