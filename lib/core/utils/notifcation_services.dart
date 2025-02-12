import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FirebaseNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  //To be notified whenever the token is updated
  static void onTokenChanged() {
    _messaging.onTokenRefresh.listen((fcmToken) async {
      debugPrint("token has been refreshed: $fcmToken");
    }).onError((err) {
      // Error getting token.
    });
  }

  Future<void> _launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  // request permission must be done on ios and web
  static Future<void> requestPermission() async {
    final NotificationSettings settings = await _messaging.requestPermission(
      announcement: true,
    );
    //Calling this method updates these options to allow customizing notification
    // presentation behavior whilst the application is in the foreground.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    //settings.authorizationStatus
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  void handleForegroundNotifications() async {
    // when the app is foreground and on focus status
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground! Message data: ${message.toMap()}',
          name: "onMessage");
      print(message.data['notification']);

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.data}');

        // if (message.data['category'] == 'open_link') {
        //   _launchInWebView(Uri.parse(message.data['url']));
        // }
      }
    });
    // whe click on the message
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log("onMessageOpenedApp ${message.notification}\n${message.toMap()}",
          name: "onMessageOpenedApp");

      if (message.data['category'] == 'open_link') {
        _launchInWebView(Uri.parse(message.data['url']));
      }
      // getIt<CacheDataSource>().getUserType() =="emp"?
      // EmployeeBottomNavigationCubit.get().changeTabIndex(3):
      // GuestManagerBottomNavigationCubit.get().changeTabIndex(3);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('TERMINATED ');
        if (message.notification != null) {}
      }
    });
  }

  void handleBackgroundNotifications() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static void checkTokenChanging() async {
    final fcmToken;
    if (Platform.isIOS) {
      fcmToken = await FirebaseMessaging.instance.getAPNSToken();
    } else {
      fcmToken = await FirebaseMessaging.instance.getToken();
    }
    if (fcmToken != null) {}
  }

  void setUp() async {
    if (Platform.isIOS) await requestPermission();
    handleForegroundNotifications();
    handleBackgroundNotifications();
    checkTokenChanging();
    onTokenChanged();
  }
}

//When using Flutter version 3.3.0 or higher,
// the message handler must be annotated with @pragma('vm:entry-point')
// right above the function declaration (
// otherwise it may be removed during tree shaking for release mode)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // flutterLocalNotificationService.showFirebaseNotification(message);
  debugPrint("Handling a background message: ${message.data}");
}
