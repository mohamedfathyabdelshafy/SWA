import 'dart:convert';
import 'dart:developer' as log;
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class FlutterLocalNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel _channel;
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> _launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  //
  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    AndroidInitializationSettings? initializationSettingsAndroid;
    DarwinInitializationSettings? initializationSettingsIOS;

    if (Platform.isAndroid) {
      initializationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/ic_launcher');

      _channel = const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );

      // Request permission (Android 13+)
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    } else if (Platform.isIOS) {
      initializationSettingsIOS = const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Request iOS notification permission
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      _channel = const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );
    }

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  //
  Future<void> _onSelectNotification(NotificationResponse response) async {
    log.log("_onSelectNotification${response.toString()}",
        name: "_onSelectNotification");
    final decoded =
        json.decode(response.payload ?? "{}") as Map<String, dynamic>;
    if (decoded["data"] != null) {
      log.log('Got a message whilst in the foreground! Message data: $decoded',
          name: "onclic notify");

      // if (decoded["data"]['category'] == 'open_link') {
      //   _launchInWebView(Uri.parse(decoded["data"]['url']));
      // } else if (decoded["data"]['category'] == 'open_package') {
      //   Navigator.push(
      //     getIt<NavHelper>().navigatorKey.currentContext!,
      //     MaterialPageRoute(builder: (context) => PackageMainAllTerms()),
      //   );
      // } else if (decoded["data"]['category'] == 'open_wallet') {
      //   Navigator.push(
      //     getIt<NavHelper>().navigatorKey.currentContext!,
      //     MaterialPageRoute(builder: (context) => MyWalletScreen()),
      //   );
      // } else if (decoded["data"]['category'] == 'open_trip') {
      //   Navigator.push(
      //     getIt<NavHelper>().navigatorKey.currentContext!,
      //     MaterialPageRoute(builder: (context) => AllTripsScreen()),
      //   );
      // } else if (decoded["data"]['category'] == 'open_person_info') {
      //   Navigator.push(
      //     getIt<NavHelper>().navigatorKey.currentContext!,
      //     MaterialPageRoute(builder: (context) => ProfileScreen()),
      //   );
      // } else if (decoded["data"]['category'] == 'confirmation') {
      //   globalAlertDialogue(
      //       canCancel: true,
      //       icon: Icons.info,
      //       '',
      //       title2: decoded["notification"]['body'],
      //       okText: Singleton().isEnglishSelected ? 'Accept' : 'اقبل',
      //       cancelText: Singleton().isEnglishSelected ? 'Decline' : 'ارفض',
      //       onOk: () async {
      //         var response = await LoginRepo().confirmNotifaction(
      //             url: decoded["data"]['url'],
      //             InvitaionStudentID: decoded["data"]['InvitaionStudentID'],
      //             IsApprove: true,
      //             PromoCodeID: decoded["data"]['PromoCOdeID']);
      //
      //         if (response['status'] == 'failed') {
      //           showSnackBar(
      //               isError: true,
      //               getIt<NavHelper>().navigatorKey.currentContext!,
      //               response['message'].toString());
      //         } else if (response['status'] == 'success') {
      //           showSnackBar(
      //               isError: false,
      //               getIt<NavHelper>().navigatorKey.currentContext!,
      //               response['message'].toString());
      //         }
      //
      //         goBack();
      //       }, onCancel: () async {
      //     var response = await LoginRepo().confirmNotifaction(
      //         url: decoded["data"]['url'],
      //         InvitaionStudentID: decoded["data"]['InvitaionStudentID'],
      //         IsApprove: false,
      //         PromoCodeID: decoded["data"]['PromoCOdeID']);
      //
      //     if (response['status'] == 'failed') {
      //       showSnackBar(
      //           isError: true,
      //           getIt<NavHelper>().navigatorKey.currentContext!,
      //           response['message'].toString());
      //     } else if (response['status'] == 'success') {
      //       showSnackBar(
      //           isError: false,
      //           getIt<NavHelper>().navigatorKey.currentContext!,
      //           response['message'].toString());
      //     }
      //
      //     goBack();
      //   });
      // }
    }
  }

  void showFirebaseNotification(
    RemoteMessage message,
  ) {
    final RemoteNotification? notification = message.notification;
    if ((notification != null || message.data['notification'] != null) &&
        !kIsWeb) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title,
        notification?.body,
        NotificationDetails(
          iOS: DarwinNotificationDetails(),
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: json.encode(message.toMap()),
      );
    }
  }

  // IOS this function is executed when the app is in the foreground and you can show alert dialog with notification details
  void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    debugPrint('notification _onDidReceiveLocalNotification');
    if (payload != null) {
      debugPrint('notification payload Ios: $payload');
    }
  }
}
