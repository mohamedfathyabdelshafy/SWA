import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/features/home/data/models/Notifications_model.dart';
import 'package:swa/features/home/presentation/screens/Notification/Notification_respotary.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationState.init()) {
    on<NotificationEvent>(mapEventToState);
  }

  NotifcationRespo respotarey = new NotifcationRespo();

  @override
  void mapEventToState(
      NotificationEvent event, Emitter<NotificationState> emit) async {
    // TODO: implement mapEventToState

    if (event is getNotificationlist) {
      emit(state.update(isloading: true));

      NotificationModel notificationModel = await respotarey.getNotifications();

      emit(
          state.update(isloading: false, notificationModel: notificationModel));
    } else if (event is DeleteNotificationEvent) {
      emit(state.update(isloading: true));

      final notificationModel =
          await respotarey.deletenotification(id: event.id);

      emit(state.update(
        isloading: false,
      ));
    } else if (event is deletallevent) {
      emit(state.update(isloading: true));

      final notificationModel = await respotarey.Deleteall();

      emit(state.update(
        isloading: false,
      ));
    }
  }
}
