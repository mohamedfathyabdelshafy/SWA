import 'dart:async';
import 'dart:developer';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:intl/intl.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/Timer_widget.dart';
import 'package:swa/core/widgets/icon_back.dart';
import 'package:swa/core/widgets/timer.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Ticket_class.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_states.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/reservation_ticket.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/select_payment2/data/models/trip_reservartion_model.dart';

import '../../../../core/local_cache_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../main.dart';
import '../../../sign_in/domain/entities/user.dart';
import '../../../times_trips/data/models/TimesTripsResponsedart.dart';
import '../../../times_trips/presentation/PLOH/times_trips_cubit.dart';
import '../../../times_trips/presentation/screens/times_screen_back.dart';
import '../../data/models/BusSeatsModel.dart';
import '../widgets/bus_seat_widget/seat_layout_model.dart';
import '../widgets/bus_seat_widget/seat_layout_widget.dart';

class BusLayoutScreen extends StatefulWidget {
  BusLayoutScreen(
      {super.key,
      required this.to,
      required this.tocity,
      required this.fromcity,
      required this.from,
      required this.triTypeId,
      required this.isedit,
      this.tripListBack,
      this.busdate,
      this.busttime,
      required this.price,
      this.user,
      required this.tripId});
  String from;
  String to;
  String tocity, fromcity;
  bool isedit;
  DateTime? busdate;
  String? busttime;
  String triTypeId;
  List<TripList>? tripListBack;
  double price;
  User? user;
  int tripId;
  @override
  State<BusLayoutScreen> createState() => _BusLayoutScreenState();
}

class _BusLayoutScreenState extends State<BusLayoutScreen> {
  SeatDetails? selectedSeats;
  BusSeatsModel? busSeatsModel;
  BusLayoutRepo busLayoutRepo = BusLayoutRepo(apiConsumer: (sl()));
  int unavailable = 0;
  final CountDownController _controller = CountDownController();

  int seatheight = 1;
  List<num> countSeats = [];
  List<num> Seatsnumbers = [];
  bool showtimer = false;
  List<dynamic> cachCountSeats = [];
  int countSeatesNum = 0;
  BusLayoutCubit _busLayoutCubit = new BusLayoutCubit();
  @override
  void initState() {
    print("tripTypeId${widget.triTypeId}}");
    BlocProvider.of<BusLayoutCubit>(context).getBusSeats(tripId: widget.tripId);
    // busLayoutRepo?.getBusSeatsData();
    get();
    super.initState();
  }

  void get() async {
    print("DDttttttttttttt${widget.tripId}");
    busLayoutRepo.getBusSeatsData(tripId: widget.tripId).then((value) async {
      busSeatsModel = await value;

      if (busSeatsModel != null) {
        unavailable = await busSeatsModel!.busSeatDetails!.totalSeats! -
            busSeatsModel!.busSeatDetails!.emptySeats!;

        for (int i = 0;
            i < busSeatsModel!.busSeatDetails!.busDetails!.totalRow!;
            i++) {
          for (int j = 0;
              j <
                  busSeatsModel!
                      .busSeatDetails!.busDetails!.rowList![i].seats.length;
              j++) {
            print(
                "fffffff fff ff ${busSeatsModel?.busSeatDetails?.busDetails?.rowList?[i].seats[j].seatNo}");
            if (busSeatsModel?.busSeatDetails?.busDetails?.rowList?[i].seats[j]
                    .isReserved ==
                true) {
              busSeatsModel?.busSeatDetails?.busDetails?.rowList?[i].seats[j]
                  .seatState = SeatState.sold;
            }

            if (widget.isedit == true) {
              for (int n = 0; n < Ticketreservation.Seatsnumbers1.length; n++) {
                countSeatesNum = Ticketreservation.Seatsnumbers1.length;
                if (busSeatsModel?.busSeatDetails?.busDetails?.rowList?[i]
                        .seats[j].seatNo ==
                    Ticketreservation.Seatsnumbers1[n]) {
                  busSeatsModel?.busSeatDetails?.busDetails?.rowList?[i]
                      .seats[j].seatState = SeatState.selected;
                  countSeats.add(Ticketreservation.countSeats1[n]);

                  Seatsnumbers.add(Ticketreservation.Seatsnumbers1[n]);
                }
              }
            }
          }
        }
        seatheight = busSeatsModel!.busSeatDetails!.busDetails!.rowList!.length;

        setState(() {});
      }
    });
    print(
        "busSeatsmodel${busSeatsModel?.busSeatDetails?.busDetails?.totalRow}");
    print("unavailable$unavailable");
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<BusLayoutCubit, ReservationState>(
        builder: (context, state) {
          if (state is BusSeatsLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: sizeHeight * 0.06,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      if (widget.isedit == false) {
                        Ticketreservation.Seatsnumbers1.clear();
                      }
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.primaryColor,
                      size: 35,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        LanguageClass.isEnglish ? "Select seats" : "حدد كراسيك",
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "roman"),
                      ),
                      showtimer || widget.isedit ? Timerwidget() : SizedBox()
                      // ? CircularCountDownTimer(
                      //     duration: timer,
                      //     initialDuration: 0,
                      //     controller: _controller,
                      //     width: 40,
                      //     height: 40,
                      //     ringColor: AppColors.primaryColor,
                      //     ringGradient: null,
                      //     fillColor: AppColors.yellow2,
                      //     fillGradient: null,
                      //     backgroundColor: Colors.transparent,
                      //     backgroundGradient: null,
                      //     strokeWidth: 4.0,
                      //     strokeCap: StrokeCap.round,
                      //     textStyle: TextStyle(
                      //         fontSize: 16.sp,
                      //         color: AppColors.primaryColor,
                      //         fontWeight: FontWeight.bold),
                      //     textFormat: CountdownTextFormat.S,
                      //     isReverse: true,
                      //     isReverseAnimation: true,
                      //     isTimerTextShown: true,
                      //     autoStart: true,
                      //     onStart: () {
                      //       debugPrint('Countdown Started');
                      //     },
                      //     onComplete: () {
                      //       debugPrint('Countdown Ended');

                      //       BlocProvider.of<BusLayoutCubit>(context)
                      //           .Removehold(
                      //               tripid: widget.tripId,
                      //               Seatsnumbers: countSeats);
                      //       BlocProvider.of<BusLayoutCubit>(context)
                      //           .getBusSeats(tripId: widget.tripId);
                      //       // busLayoutRepo?.getBusSeatsData();
                      //       get();

                      //       countSeats.clear();
                      //       Seatsnumbers.clear();
                      //       countSeatesNum = 0;

                      //       showtimer = false;
                      //     },
                      //     onChange: (String timeStamp) {
                      //       debugPrint('Countdown Changed $timeStamp');
                      //     },
                      //     timeFormatterFunction:
                      //         (defaultFormatterFunction, duration) {
                      //       if (duration.inSeconds == 0) {
                      //         return "-";
                      //       } else {
                      //         return Function.apply(
                      //             defaultFormatterFunction, [duration]);
                      //       }
                      //     },
                      //   )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 60.sp,
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10)),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat('dd-MM-yyyy')
                                    .format(widget.busdate!)
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: "bold",
                                    color: Colors.black),
                              ),
                              Text(
                                DateFormat('hh:mm a')
                                    .format(widget.busdate!)
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: "bold",
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Container(
                            height: 50.sp,
                            width: 4,
                            margin: const EdgeInsetsDirectional.symmetric(
                                horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                begin: AlignmentDirectional.topStart,
                                end: AlignmentDirectional.bottomStart,
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.primaryColor
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.from,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: "bold",
                                    color: Colors.black),
                              ),
                              Text(
                                widget.to,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: "bold",
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Text(
                              LanguageClass.isEnglish ? 'Available' : 'المتاح',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: "meduim",
                                  color: Colors.black),
                            ),
                            Padding(
                              padding: EdgeInsets.zero,
                              child: Text(
                                busSeatsModel?.busSeatDetails?.emptySeats
                                        .toString() ??
                                    "",
                                style: TextStyle(
                                    fontSize: 45.sp,
                                    fontFamily: 'black',
                                    color: AppColors.primaryColor),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              LanguageClass.isEnglish
                                  ? 'Selected'
                                  : 'تم تحديده',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: "meduim",
                                  color: Colors.black),
                            ),
                            Text(
                              countSeatesNum.toString(),
                              style: TextStyle(
                                fontSize: 45.sp,
                                fontFamily: "black",
                                color: Color(0xff5332F7),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              LanguageClass.isEnglish
                                  ? 'Unavailable'
                                  : 'غير متاح',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: "meduim",
                                  color: Colors.black),
                            ),
                            Text(
                              unavailable.toString(),
                              style: TextStyle(
                                  fontSize: 45.sp,
                                  fontFamily: "black",
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                if (Seatsnumbers.isNotEmpty) {
                                  cachCountSeats =
                                      CacheHelper.getDataToSharedPref(
                                              key: 'countSeats')
                                          ?.map((e) => int.tryParse(e) ?? 0)
                                          .toList();
                                  print("countSeats2Bassant$cachCountSeats");

                                  final tripOneId =
                                      CacheHelper.getDataToSharedPref(
                                          key: 'tripOneId');
                                  final tripRoundId =
                                      CacheHelper.getDataToSharedPref(
                                          key: 'tripRoundId');
                                  final selectedDayTo =
                                      CacheHelper.getDataToSharedPref(
                                          key: 'selectedDayTo');
                                  final selectedDayFrom =
                                      CacheHelper.getDataToSharedPref(
                                          key: 'selectedDayFrom');
                                  final toStationId =
                                      CacheHelper.getDataToSharedPref(
                                          key: 'toStationId');
                                  final fromStationId =
                                      CacheHelper.getDataToSharedPref(
                                          key: 'fromStationId');
                                  final seatIdsOneTrip =
                                      CacheHelper.getDataToSharedPref(
                                              key: 'countSeats')
                                          ?.map((e) => int.tryParse(e) ?? 0)
                                          .toList();
                                  final seatIdsRoundTrip =
                                      CacheHelper.getDataToSharedPref(
                                              key: 'countSeats2')
                                          ?.map((e) => int.tryParse(e) ?? 0)
                                          .toList();
                                  final price = CacheHelper.getDataToSharedPref(
                                      key: 'price');
                                  final busdate =
                                      CacheHelper.getDataToSharedPref(
                                          key: 'accessBusDate');

                                  final lineid =
                                      CacheHelper.getDataToSharedPref(
                                          key: 'lineid');
                                  final busid = CacheHelper.getDataToSharedPref(
                                      key: 'busId');
                                  final serviceTypeID =
                                      CacheHelper.getDataToSharedPref(
                                          key: 'serviceTypeID');

                                  Ticketreservation.tripid1 = widget.tripId;
                                  Ticketreservation.tocity1 = widget.tocity;
                                  Ticketreservation.fromcity1 = widget.fromcity;
                                  Ticketreservation.priceticket1 = widget.price;
                                  Ticketreservation.countSeats1 = countSeats;
                                  Ticketreservation.Seatsnumbers1 =
                                      Seatsnumbers;
                                  Ticketreservation.busid1 = busSeatsModel!
                                      .busSeatDetails!.busDetails!.busID!;
                                  Ticketreservation.fromcitystation1 =
                                      widget.from;
                                  Ticketreservation.tocitystation1 = widget.to;
                                  Ticketreservation.cachCountSeats1 =
                                      cachCountSeats;

                                  Ticketreservation.numbertrip1 =
                                      CacheHelper.getDataToSharedPref(
                                          key: 'numberTrip');
                                  Ticketreservation.elite1 =
                                      CacheHelper.getDataToSharedPref(
                                          key: "elite");
                                  Ticketreservation.accessBusTime1 =
                                      CacheHelper.getDataToSharedPref(
                                          key: "accessBusTime");
                                  Ticketreservation.accessDate1 =
                                      CacheHelper.getDataToSharedPref(
                                          key: "accessBusDate");
                                  if (widget.triTypeId == '1') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider<LoginCubit>(
                                                create: (context) =>
                                                    sl<LoginCubit>(),
                                                child: ReservationTicket(
                                                  tripListBack:
                                                      widget.tripListBack,
                                                  tripTypeId: widget.triTypeId,
                                                  user: widget.user,
                                                )),
                                      ),
                                    );
                                  } else {
                                    if (Ticketreservation
                                        .Seatsnumbers2.isNotEmpty) {
                                      if (widget.isedit == true) {
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BlocProvider<LoginCubit>(
                                                    create: (context) =>
                                                        sl<LoginCubit>(),
                                                    child: ReservationTicket(
                                                      tripListBack:
                                                          widget.tripListBack,
                                                      tripTypeId:
                                                          widget.triTypeId,
                                                      user: widget.user,
                                                    )),
                                          ),
                                        );
                                      }
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  }
                                } else {
                                  Constants.showDefaultSnackBar(
                                      color: Colors.red,
                                      context: context,
                                      text: LanguageClass.isEnglish
                                          ? 'Select Seats'
                                          : 'اختر الكراسي');
                                }
                              },
                              child: Container(
                                height: 30.sp,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    LanguageClass.isEnglish ? "Save" : "تم",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "bold",
                                        fontSize: 16.sp),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            seatheight < 10
                                ? Positioned(
                                    top: 0,
                                    right: 0,
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                        alignment: Alignment.topCenter,
                                        height: sizeHeight / 5,
                                        width: sizeWidth - (sizeWidth / 4),
                                        child: Image.asset(
                                          'assets/images/mini.png',
                                          fit: BoxFit.fill,
                                          height: sizeHeight / 4,
                                          width: sizeWidth - (sizeWidth / 4),
                                        )),
                                  )
                                : Positioned(
                                    top: 0,
                                    right: 0,
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                        alignment: Alignment.topCenter,
                                        height: sizeHeight / 5,
                                        width: sizeWidth - (sizeWidth / 4),
                                        child: Image.asset(
                                          'assets/images/bus_body.png',
                                          fit: BoxFit.fill,
                                          height: sizeHeight / 4,
                                          width: sizeWidth - (sizeWidth / 4),
                                        )),
                                  ),
                            seatheight < 10
                                ? Positioned(
                                    top: ((sizeHeight * .036) * seatheight),
                                    bottom: 5,
                                    left: 5,
                                    right: 5,
                                    child: Container(
                                        alignment: Alignment.topCenter,
                                        width: sizeWidth - (sizeWidth / 4),
                                        child: Image.asset(
                                          'assets/images/miniback.png',
                                          fit: BoxFit.fill,
                                          height: sizeHeight / 4,
                                          width: sizeWidth - (sizeWidth / 4),
                                        )),
                                  )
                                : Positioned(
                                    top: seatheight < 10
                                        ? ((sizeHeight * .036) * seatheight)
                                        : ((sizeHeight * .036) * seatheight) -
                                            30.sp,
                                    bottom: 5,
                                    left: 5,
                                    right: 5,
                                    child: Container(
                                        alignment: Alignment.topCenter,
                                        width: sizeWidth - (sizeWidth / 4),
                                        child: Image.asset(
                                          'assets/images/busback.png',
                                          fit: BoxFit.fill,
                                          height: sizeHeight / 4,
                                          width: sizeWidth - (sizeWidth / 4),
                                        )),
                                  ),
                            Positioned(
                              top: seatheight < 10
                                  ? (sizeHeight / 9)
                                  : (sizeHeight / 5) - 30.sp,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                alignment: Alignment.topCenter,
                                width: sizeWidth - (sizeWidth / 4),
                                child: SeatLayoutWidget(
                                  seatHeight: (sizeHeight * .036),
                                  onSeatStateChanged:
                                      (rowI, colI, seatState, seat) {
                                    print("set $seat");
                                    print("seatstate $seatState");
                                    print("rowI ${rowI}, column1 ${colI}");
                                    if (seatState == SeatState.selected) {
                                      print("I am here");

                                      if (countSeats.length < 1) {
                                        Constants.showDefaultSnackBar(
                                            color: Colors.red,
                                            context: context,
                                            text: LanguageClass.isEnglish
                                                ? 'You have 120 seconds to select your seats'
                                                : 'لديك ١٢٠ ثانية لاختيار مقاعدك');
                                        showtimer = true;
                                        Reservationtimer.start = 120;

                                        Reservationtimer.startTimer(
                                          context,
                                          () {
                                            Navigator.pop(context);
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Routes.home,
                                                (route) => false,
                                                arguments: Routes.isomra);
                                          },
                                        );
                                        if (Reservationtimer
                                                .controller.isStarted ==
                                            false) {
                                          Reservationtimer.controller.start();
                                        }

                                        BlocProvider.of<BusLayoutCubit>(context)
                                            .seathold(
                                                seatid: busSeatsModel!
                                                    .busSeatDetails!
                                                    .busDetails!
                                                    .rowList![rowI]
                                                    .seats[colI]
                                                    .seatBusID!
                                                    .toInt(),
                                                tripid: busSeatsModel!
                                                    .busSeatDetails!.tripId!);
                                      } else {
                                        _busLayoutCubit.seathold(
                                            seatid: busSeatsModel!
                                                .busSeatDetails!
                                                .busDetails!
                                                .rowList![rowI]
                                                .seats[colI]
                                                .seatBusID!
                                                .toInt(),
                                            tripid: busSeatsModel!
                                                .busSeatDetails!.tripId!);
                                      }

                                      countSeats.add(busSeatsModel!
                                          .busSeatDetails!
                                          .busDetails!
                                          .rowList![rowI]
                                          .seats[colI]
                                          .seatBusID!);
                                      Seatsnumbers.add(busSeatsModel!
                                          .busSeatDetails!
                                          .busDetails!
                                          .rowList![rowI]
                                          .seats[colI]
                                          .seatNo!);
                                      print("countSeats${Seatsnumbers}");
                                      countSeatesNum = countSeats.length;
                                      CacheHelper.setDataToSharedPref(
                                          key: 'countSeats', value: countSeats);

                                      setState(() {});
                                    } else {
                                      print("I am there");
                                      selectedSeats = null;
                                      busSeatsModel
                                          ?.busSeatDetails
                                          ?.busDetails
                                          ?.rowList?[rowI]
                                          .seats[colI]
                                          .seatState = SeatState.available;
                                      countSeats.remove(busSeatsModel!
                                          .busSeatDetails!
                                          .busDetails!
                                          .rowList![rowI]
                                          .seats[colI]
                                          .seatBusID!);
                                      Seatsnumbers.remove(busSeatsModel!
                                          .busSeatDetails!
                                          .busDetails!
                                          .rowList![rowI]
                                          .seats[colI]
                                          .seatNo!);
                                      countSeatesNum = countSeats.length;
                                      setState(() {});
                                    }
                                  },
                                  stateModel: SeatLayoutStateModel(
                                    rows: busSeatsModel?.busSeatDetails
                                            ?.busDetails?.rowList?.length ??
                                        0,
                                    cols: busSeatsModel?.busSeatDetails
                                            ?.busDetails?.totalColumn ??
                                        5,
                                    seatSvgSize: 35.sp.toInt(),
                                    pathSelectedSeat:
                                        'assets/images/unavailable_seats.svg',
                                    pathDisabledSeat:
                                        'assets/images/unavailable_seats.svg',
                                    pathSoldSeat:
                                        'assets/images/disabled_seats.svg',
                                    pathUnSelectedSeat:
                                        'assets/images/unavailable_seats.svg',
                                    currentSeats: List.generate(
                                      busSeatsModel?.busSeatDetails?.busDetails
                                              ?.rowList?.length ??
                                          0,

                                      // Number of rows based on totalSeats
                                      (row) => busSeatsModel!.busSeatDetails!
                                          .busDetails!.rowList![row].seats,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
