import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/home/presentation/screens/Notification/bloc/notification_bloc.dart';
import 'package:badges/badges.dart' as badges;

class NotificationsIcon extends StatelessWidget {
  const NotificationsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        final model = state.notificationModel;
        final unReadCount = model?.notifications.where((notification) => !notification.IsRead!).length ?? 0;

        return unReadCount <= 0
            ? SizedBox()
            : Positioned(
                top: 2,
                right: 8,
                child: badges.Badge(
                  badgeContent: Text(
                    unReadCount.toString(),
                    style: fontStyle(fontFamily: FontFamily.medium, color: Colors.white, fontSize: 14),
                  ),
                  badgeStyle: badges.BadgeStyle(badgeColor: AppColors.darkRed, padding: EdgeInsets.all(5)),
                ),
              );
      },
    );
  }
}
