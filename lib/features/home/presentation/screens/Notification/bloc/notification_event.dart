part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class getNotificationlist extends NotificationEvent {
  getNotificationlist();
}

class DeleteNotificationEvent extends NotificationEvent {
  String id;
  DeleteNotificationEvent({required this.id});
}

class deletallevent extends NotificationEvent {}
