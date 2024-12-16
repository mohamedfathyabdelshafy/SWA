import 'dart:convert';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intil;
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/home/presentation/screens/Notification/Notification_respotary.dart';
import 'package:swa/features/home/presentation/screens/Notification/bloc/notification_bloc.dart';
import 'package:swa/features/home/presentation/screens/Notification/notifications_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({
    super.key,
    required this.isScreenHome,
    required this.updateNotificationCount,
  });
  bool isScreenHome;
  final Function(int newCount) updateNotificationCount;

  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<void> _launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  int count = 0;

  NotificationBloc _notificationBloc = new NotificationBloc();

  @override
  void initState() {
    super.initState();
    get();
  }

  void get() async {
    _notificationBloc.add(getNotificationlist());
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Directionality(
      textDirection:
          LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener(
          bloc: _notificationBloc,
          listener: (context, NotificationState state) {
            if (state.notificationModel?.status == 'success') {
              count = state.notificationModel?.notifications
                      .where((notification) => !notification.IsRead!)
                      .length ??
                  0;
            }
          },
          child: BlocBuilder(
            bloc: _notificationBloc,
            builder: (context, NotificationState state) {
              return SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: LanguageClass.isEnglish
                                ? Alignment.topLeft
                                : Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: AppColors.primaryColor,
                                size: 35,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _notificationBloc.add(deletallevent());
                              get();
                            },
                            child: Text(
                              (LanguageClass.isEnglish
                                  ? 'Delete All'
                                  : 'حذف الكل'),
                              style: fontStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          LanguageClass.isEnglish
                              ? 'Notifications'
                              : 'الاشعارات',
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 38,
                              fontWeight: FontWeight.w500,
                              fontFamily: "roman"),
                        ),
                      ),
                      Expanded(
                        child: state.notificationModel?.notifications != null &&
                                state.notificationModel!.notifications.length >
                                    0
                            ? ListView.builder(
                                itemCount: state
                                    .notificationModel!.notifications.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      NotifcationRespo()
                                          .readNotification(
                                              id: state
                                                      .notificationModel
                                                      ?.notifications[index]
                                                      .NotificationID ??
                                                  0)
                                          .then((value) {});
                                      state.notificationModel
                                          ?.notifications[index].IsRead = true;

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationDetailsScreen(
                                                    notificationid: state
                                                        .notificationModel!
                                                        .notifications[index]
                                                        .NotificationID!,
                                                    date: intil.DateFormat(
                                                            'd/M/y, hh:mm a')
                                                        .format(state
                                                                .notificationModel
                                                                ?.notifications[
                                                                    index]
                                                                .Date ??
                                                            DateTime.now()),
                                                    title: state
                                                            .notificationModel
                                                            ?.notifications[
                                                                index]
                                                            .Title ??
                                                        "0",
                                                    desc: state
                                                            .notificationModel
                                                            ?.notifications[
                                                                index]
                                                            .Description ??
                                                        "0",
                                                  ))).then((value) {
                                        get();
                                      });

                                      if (state
                                                  .notificationModel
                                                  ?.notifications[index]
                                                  .IsRead ==
                                              true &&
                                          count > 0) {
                                        count--;
                                      }
                                      setState(() {
                                        widget.updateNotificationCount(count);
                                      });
                                    },
                                    child: Dismissible(
                                      onDismissed: (direction) async {
                                        _notificationBloc.add(
                                            DeleteNotificationEvent(
                                                id: state
                                                    .notificationModel!
                                                    .notifications[index]
                                                    .NotificationID
                                                    .toString()));

                                        get();
                                      },
                                      key: UniqueKey(),
                                      child: Container(
                                        padding: EdgeInsets.all(9),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: state
                                                        .notificationModel
                                                        ?.notifications[index]
                                                        .IsRead ==
                                                    false
                                                ? Color(0xffEBEBEB)
                                                : Colors.white),
                                        child: Row(
                                          children: [
                                            Stack(
                                              children: [
                                                state
                                                            .notificationModel
                                                            ?.notifications[
                                                                index]
                                                            .IsRead ==
                                                        false
                                                    ? Positioned(
                                                        top: 2,
                                                        child: badges.Badge(
                                                            badgeContent:
                                                                Container()),
                                                      )
                                                    : Container(),
                                                Icon(
                                                  Icons.notifications,
                                                  size: 35,
                                                  color: state
                                                              .notificationModel
                                                              ?.notifications[
                                                                  index]
                                                              .IsRead ==
                                                          false
                                                      ? AppColors.blue
                                                      : Colors.grey,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                state
                                                        .notificationModel
                                                        ?.notifications[index]
                                                        .Description ??
                                                    "",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily: 'English_Regular',
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  (LanguageClass.isEnglish
                                      ? "You Don't Have Any Notifications"
                                      : 'ليس لديك أي إشعارات'),
                                  style: fontStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackColor),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
