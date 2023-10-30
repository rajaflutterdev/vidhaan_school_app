import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vidhaan_school_app/modules/home/controllers/userModel.dart';

class HomeController extends GetxController {
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? mtoken = "";

  @override
  void onReady() {
    super.onReady();
    requestPermission();
    listenFCM();
    loadFCM();
    _allclint.bindStream(FirebaseFirestore.instance
        .collection("UserToken")
        .snapshots()
        .map((QuerySnapshot queryy) {
      List<Usermodel> allvideos = [];
      for (var elment in queryy.docs) {
        allvideos.add(Usermodel.formSnap(elment));
      }
      return allvideos;
    }));
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void sendPushMessage(String token, String body, String title,String Page ) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA9pRd_9E:APA91bGFLaH3PezX-9cPq6c4udZ2lHi5kM3XF6UCdyASEy313xc6SugRk07JiSTzdlSILGA9szuW3DUjyKvtPYttwsgD7oU7D6edQ6Gc9Txvq0EqeMLvrAwcmR2wAaRLh3b1LxStu23m',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title,"page":Page},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  final Rx<List<Usermodel>> _allclint = Rx<List<Usermodel>>([]);
  List<Usermodel> get clientusers => _allclint.value;

  Future<void> findusers() async {
   /* for (var i = 0; i < clientusers.length; i++) {
      sendPushMessage(clientusers[i].token!, body.text, title.text);
    }*/
    print("Notification Started");
    var document= await FirebaseFirestore.instance.collection("Staffs").get();
    var document2= await FirebaseFirestore.instance.collection("Students").get();
    for(var i = 0; i < document.docs.length; i++){
      if(document.docs[i]["token"]!="") {
        print(document.docs[i]["token"]);
        sendPushMessage(document.docs[i]["token"], body.text, title.text,"Attendance");
      }
    }
    for(var j = 0; j < document2.docs.length; j++){
      if(document2.docs[j]["token"]!="") {
        sendPushMessage(document2.docs[j]["token"], body.text, title.text,"Attendance");
      }
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
