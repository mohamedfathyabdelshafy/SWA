import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/widgets/timer.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Ticket_class.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';
import 'package:swa/main.dart';

class Timerwidget extends StatefulWidget {
  const Timerwidget({super.key});

  @override
  State<Timerwidget> createState() => _TimerwidgetState();
}

class _TimerwidgetState extends State<Timerwidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularCountDownTimer(
        duration: Reservationtimer.start ?? 120,
        initialDuration: 0,
        controller: Reservationtimer.controller,
        width: 40,
        height: 40,
        ringColor: AppColors.primaryColor,
        ringGradient: null,
        fillColor: AppColors.yellow2,
        fillGradient: null,
        backgroundColor: Colors.transparent,
        backgroundGradient: null,
        strokeWidth: 4.0,
        strokeCap: StrokeCap.round,
        textStyle: TextStyle(
            fontSize: 8.sp,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold),
        textFormat: CountdownTextFormat.S,
        isReverse: true,
        isReverseAnimation: true,
        isTimerTextShown: true,
        autoStart: true,
        onStart: () {
          debugPrint('Countdown Started');
        },
        onComplete: () {
          debugPrint('Countdown Ended');

          BusLayoutRepo(apiConsumer: sl()).Removeholdfun(
              tripid: Ticketreservation.tripid1,
              Seatsnumbers: Ticketreservation.countSeats1);

          BusLayoutRepo(apiConsumer: sl()).Removeholdfun(
              tripid: Ticketreservation.tripid2,
              Seatsnumbers: Ticketreservation.countSeats2);

          CoolAlert.show(
              barrierDismissible: false,
              context: context,
              confirmBtnText: "ok",
              title: 'error',
              lottieAsset: 'assets/json/error.json',
              type: CoolAlertType.error,
              loopAnimation: false,
              backgroundColor: Colors.red,
              text: LanguageClass.isEnglish
                  ? 'Time for reservation has been finished start again'
                  : "لقد انتهى وقت الحجز، ابدأ من جديد",
              widget: Container(),
              onConfirmBtnTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.home, (route) => false,
                    arguments: Routes.isomra);

                Reservationtimer.stoptimer();
              });
        },
        onChange: (String timeStamp) {
          debugPrint('Countdown Changed $timeStamp');
        },
        timeFormatterFunction: (defaultFormatterFunction, duration) {
          if (duration.inSeconds == 0) {
            return "-";
          } else {
            return Function.apply(defaultFormatterFunction, [duration]);
          }
        },
      ),
    );
  }
}
