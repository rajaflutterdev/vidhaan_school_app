// To parse this JSON data, do
//
//     final Usermodel = UsermodelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// Usermodel UsermodelFromJson(String str) => Usermodel.fromJson(json.decode(str));

String UsermodelToJson(Usermodel data) => json.encode(data.toJson());

class Usermodel {
  Usermodel({
    this.email,
    this.token,
    this.uid,
  });

  String? email;
  String? token;
  String? uid;

  static Usermodel formSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Usermodel(
      email: snapshot["email"],
      token: snapshot["token"],
      uid: snapshot["uid"],
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email == null ? null : email,
        "token": token == null ? null : token,
        "uid": uid == null ? null : uid,
      };
}
