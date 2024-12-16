import 'dart:async';
import 'dart:developer';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Ticket_class.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/main.dart';

class Reservationtimer {
  static Timer? timer;
  static int start = 120;

  static CountDownController controller = CountDownController();

  static void startTimer(BuildContext context, Function callback) {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          timer.cancel();
        } else if (start == -1) {
          timer.cancel();
        } else {
          start--;

          log(start.toString());
        }
      },
    );
  }

  static void stoptimer() {
    if (timer?.isActive == true) {
      timer!.cancel();
      BusLayoutRepo(apiConsumer: sl()).Removeholdfun(
          tripid: Ticketreservation.tripid1,
          Seatsnumbers: Ticketreservation.countSeats1);

      BusLayoutRepo(apiConsumer: sl()).Removeholdfun(
          tripid: Ticketreservation.tripid2,
          Seatsnumbers: Ticketreservation.countSeats2);
    }

    start = -1;
    log('stopped');
  }
}
