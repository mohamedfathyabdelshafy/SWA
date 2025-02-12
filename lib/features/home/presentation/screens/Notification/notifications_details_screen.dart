import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationDetailsScreen extends StatelessWidget {
  NotificationDetailsScreen({
    super.key,
    required this.title,
    required this.notificationid,
    required this.desc,
    required this.date,
  });
  final String title;

  final String desc;
  final int notificationid;

  final String date;

  Future<void> _launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool selected = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            // navigateTo(replace: true ,NotificationScreen());
            // Navigator.pop(context)
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 25,
            color: Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Icon(
          //   Icons.notifications,
          //   size: 150.sp,
          //   color: Colors.yellow
          // ),
          // 16.verticalSpace,
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: fontStyle(
                      fontSize: 19,
                      fontFamily: FontFamily.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  desc,
                  style: fontStyle(
                      fontSize: 17,
                      fontFamily: FontFamily.regular,
                      color: Color(0xff818181)),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  date,
                  style: fontStyle(
                      fontSize: 13,
                      fontFamily: FontFamily.regular,
                      color: Color(0xff818181)),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
