import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:personal/personal/notif/firebaseMessageData.dart';

class NotifHelper {

  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase(BuildContext context) {
    _firebaseMessaging = FirebaseMessaging();
    return _firebaseCloudMessagingListeners(context);

  }

  void _firebaseCloudMessagingListeners(BuildContext context) {
    _firebaseMessaging.configure(
      onMessage: (Map<dynamic, dynamic> message) async {
        print(json.encode(message));
        _notificationHandler(message, context);
      },
      onResume: (Map<dynamic, dynamic> message) async {
        print(json.encode(message));
        // в теле доп параметров должно быть
        // click_action FLUTTER_NOTIFICATION_CLICK
        _notificationHandler(message, context);
      },
      onLaunch: (Map<dynamic, dynamic> message) async {
        print(json.encode(message));
        // в теле доп параметров должно быть
        // click_action FLUTTER_NOTIFICATION_CLICK
        _notificationHandler(message, context);
      },
    );
  }

  void _notificationHandler(Map<dynamic, dynamic> msg, BuildContext context) {
    FirebaseMessageData message =
    FirebaseMessageData.fromJson(json.decode(json.encode(msg)));
    if(message.notification.body == null || message.notification.title == null) {
      message.notification.body = message.data.body;
      message.notification.title = message.data.title;
    }
    Future.delayed(
      Duration(milliseconds: 1000),
          () => _showMsg(message, context),
    );
  }

  void _showMsg(FirebaseMessageData msg, BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg.notification.title),
          content: Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Text(msg.notification.body),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () async {
                Navigator.of(context).pop();
                //обращение к сети и отправка окея
              },
            ),
          ],
        );
      },
    );
  }
}