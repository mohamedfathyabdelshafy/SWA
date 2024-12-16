part of 'notification_bloc.dart';

class NotificationState {
  bool? isloading;
  NotificationModel? notificationModel;
  NotificationState({this.isloading, this.notificationModel});

  factory NotificationState.init() {
    return NotificationState(
        isloading: false,
        notificationModel: NotificationModel(notifications: []));
  }

  NotificationState update(
      {bool? isloading, NotificationModel? notificationModel}) {
    return NotificationState(
        isloading: isloading, notificationModel: notificationModel);
  }
}
