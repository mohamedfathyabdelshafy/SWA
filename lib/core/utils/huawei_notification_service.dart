import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:huawei_push/huawei_push.dart';
import 'package:permission_handler/permission_handler.dart';

class HmsPushService {
  static Future<void> initHMSPushNotifications(context) async {
    print("Started HMS Push Init");
    String token = '';
    // Enable auto-init
    // if (await Permission.notification.isDenied) {
    //   await Permission.notification.request();
    // }

    await Push.setAutoInitEnabled(true);

    // Request a push token
    Push.getToken("");

    // Listen to token stream
    Push.getTokenStream.listen((String token) {
      print('HMS Token: $token');

      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Token:\n $token\n\n(from HMS init)"),
          ),
        ),
      );

      // You can save the token here if needed
    });

    // Listen for foreground push messages
    Push.onMessageReceivedStream.listen((RemoteMessage message) {
      print('Received a foreground message: ${message.data}');
    });

    void _onTokenEvent(
      String event,
    ) {
      // Requested tokens can be obtained here

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Token: ${token} end from _onToken"),
        ),
      );
      log("TokenEvent: " + token);
    }

    void _onTokenError(Object error) {}

    Future<void> initTokenStream() async {
      await Push.setAutoInitEnabled(true);
      Push.getTokenStream.listen(_onTokenEvent, onError: _onTokenError);
      Push.getToken("");
    }

    initTokenStream();

    // Optional: Listen for notification opened or other events if you want
  }
}
