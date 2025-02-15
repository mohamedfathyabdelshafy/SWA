import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:intl/intl.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/Timer_widget.dart';
import 'package:swa/core/widgets/icon_back.dart';
import 'package:swa/core/widgets/timer.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/Swa_umra/models/umral_trip_model.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Ticket_class.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_states.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/reservation_ticket.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import '../../../../core/local_cache_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../main.dart';
import '../../../sign_in/domain/entities/user.dart';
import '../../data/models/BusSeatsModel.dart';
import '../widgets/bus_seat_widget/seat_layout_model.dart';
import '../widgets/bus_seat_widget/seat_layout_widget.dart';

class BusLayoutScreenBack extends StatefulWidget {
  BusLayoutScreenBack(
      {super.key,
      required this.to,
      required this.from,
      required this.tocity,
      required this.fromcity,
      required this.triTypeId,
      required this.price,
      this.busdate,
      this.busttime,
      required this.isedit,
      this.user,
      required this.tripId});
  String from;
  String to;
  String fromcity;
  String tocity;
  String triTypeId;
  bool isedit;

  DateTime? busdate;
  String? busttime;
  double price;
  User? user;
  int tripId;
  @override
  State<BusLayoutScreenBack> createState() => _BusLayoutScreenBackState();
}

class _BusLayoutScreenBackState extends State<BusLayoutScreenBack> {
  SeatDetails? selectedSeats;
  BusSeatsModel? busSeatsModel;
  BusLayoutRepo busLayoutRepo = BusLayoutRepo(apiConsumer: (sl()));
  int unavailable = 0;
  int seatheight = 1;
  bool showtimer = false;

  BusLayoutCubit _busLayoutCubit = new BusLayoutCubit();

  List<num> countSeats = [];
  List<num> seatsnumber = [];

  List<dynamic>? cachCountSeats2;

  int countSeatesNum = 0;
  @override
  void initState() {
    print("tripTypeId${widget.triTypeId}}");
    BlocProvider.of<BusLayoutCubit>(context).getBusSeats(tripId: widget.tripId);

    if (Reservationtimer.start != 120) {
      showtimer = true;
    }
    // busLayoutRepo?.getBusSeatsData();
    get();
    super.initState();
  }

  void get() async {
    await busLayoutRepo.getBusSeatsData(tripId: widget.tripId).then((value) {
      busSeatsModel = value;

      seatheight = busSeatsModel!.busSeatDetails!.busDetails!.rowList!.length;

      if (busSeatsModel != null) {
        unavailable = busSeatsModel!.busSeatDetails!.totalSeats! -
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
              for (int n = 0; n < Ticketreservation.Seatsnumbers2.length; n++) {
                countSeatesNum = Ticketreservation.Seatsnumbers2.length;
                if (busSeatsModel?.busSeatDetails?.busDetails?.rowList?[i]
                        .seats[j].seatNo ==
                    Ticketreservation.Seatsnumbers2[n]) {
                  busSeatsModel?.busSeatDetails?.busDetails?.rowList?[i]
                      .seats[j].seatState = SeatState.selected;
                  countSeats.add(Ticketreservation.countSeats2[n]);

                  seatsnumber.add(Ticketreservation.Seatsnumbers2[n]);
                }
              }
            }
          }
        }

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
                        Ticketreservation.Seatsnumbers2.clear();
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
                        style: fontStyle(
                            color: AppColors.blackColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            fontFamily: FontFamily.medium),
                      ),
                      showtimer || widget.isedit ? Timerwidget() : SizedBox()
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
                                style: fontStyle(
                                    fontSize: 12.sp,
                                    fontFamily: FontFamily.bold,
                                    height: 1,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Text(
                                DateFormat('hh:mm a')
                                    .format(widget.busdate!)
                                    .toString(),
                                style: fontStyle(
                                    fontSize: 12.sp,
                                    fontFamily: FontFamily.bold,
                                    fontWeight: FontWeight.w600,
                                    height: 1,
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
                                style: fontStyle(
                                    fontSize: 16.sp,
                                    fontFamily: FontFamily.bold,
                                    height: 1,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Text(
                                widget.to,
                                style: fontStyle(
                                    fontSize: 16.sp,
                                    fontFamily: FontFamily.bold,
                                    height: 1.2,
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
                              style: fontStyle(
                                  fontSize: 12.sp,
                                  fontFamily: FontFamily.medium,
                                  height: 1.2,
                                  color: Colors.black),
                            ),
                            Padding(
                              padding: EdgeInsets.zero,
                              child: Text(
                                busSeatsModel?.busSeatDetails?.emptySeats
                                        .toString() ??
                                    "",
                                style: fontStyle(
                                    fontSize: 30.sp,
                                    fontFamily: FontFamily.bold,
                                    height: 1.2,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              LanguageClass.isEnglish
                                  ? 'Selected'
                                  : 'تم تحديده',
                              style: fontStyle(
                                  fontSize: 12.sp,
                                  height: 1,
                                  fontFamily: FontFamily.medium,
                                  color: Colors.black),
                            ),
                            Text(
                              countSeatesNum.toString(),
                              style: fontStyle(
                                fontSize: 30.sp,
                                fontFamily: FontFamily.bold,
                                height: 1.2,
                                color: Color(0xff5332F7),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              LanguageClass.isEnglish
                                  ? 'Unavailable'
                                  : 'غير متاح',
                              style: fontStyle(
                                  fontSize: 12.sp,
                                  fontFamily: FontFamily.medium,
                                  height: 1,
                                  color: Colors.black),
                            ),
                            Text(
                              unavailable.toString(),
                              style: fontStyle(
                                  fontSize: 30.sp,
                                  height: 1.2,
                                  fontFamily: FontFamily.bold,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                if (seatsnumber.isNotEmpty) {
                                  cachCountSeats2 =
                                      CacheHelper.getDataToSharedPref(
                                              key: 'countSeats2')
                                          ?.map((e) => int.tryParse(e) ?? 0)
                                          .toList();
                                  print("countSeats3Bassant$cachCountSeats2");

                                  Ticketreservation.tripid2 = widget.tripId;
                                  Ticketreservation.tocity2 = widget.tocity;
                                  Ticketreservation.fromcity2 = widget.fromcity;
                                  Ticketreservation.priceticket2 = widget.price;
                                  Ticketreservation.countSeats2 = countSeats;
                                  Ticketreservation.Seatsnumbers2 = seatsnumber;
                                  Ticketreservation.busid2 = busSeatsModel!
                                      .busSeatDetails!.busDetails!.busID!;
                                  Ticketreservation.fromcitystation2 =
                                      widget.from;
                                  Ticketreservation.tocitystation2 = widget.to;
                                  Ticketreservation.cachCountSeats2 =
                                      cachCountSeats2;

                                  Ticketreservation.numbertrip2 =
                                      CacheHelper.getDataToSharedPref(
                                          key: 'numberTrip2');
                                  Ticketreservation.elite2 =
                                      CacheHelper.getDataToSharedPref(
                                          key: "elite2");
                                  Ticketreservation.accessDate2 =
                                      CacheHelper.getDataToSharedPref(
                                          key: "accessBusDate2");

                                  Ticketreservation.accessBusTime2 =
                                      CacheHelper.getDataToSharedPref(
                                          key: "accessBusTime2");

                                  if (UmraDetails.isbusforumra) {
                                    UmraDetails.swatransportList!.first
                                        .fromStationId = null;
                                    UmraDetails.swatransportList!.first
                                        .toStationId = null;

                                    UmraDetails.Swabusreservedseats.add(
                                        TransportationsSeats(
                                      tripid: widget.tripId,
                                      seatsnumber: countSeats,
                                      totalprice:
                                          countSeats.length * widget.price,
                                    ));
                                  }
                                  if (Ticketreservation.Seatsnumbers1.isEmpty) {
                                    Navigator.pop(context);
                                  } else {
                                    if (widget.isedit == true) {
                                      Navigator.pop(context);
                                    } else {
                                      if (UmraDetails.isbusforumra) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MultiBlocProvider(
                                                      providers: [
                                                        BlocProvider<
                                                                LoginCubit>(
                                                            create: (context) =>
                                                                sl<LoginCubit>()),
                                                        BlocProvider<
                                                            TimesTripsCubit>(
                                                          create: (context) =>
                                                              TimesTripsCubit(),
                                                        )
                                                      ],
                                                      // Replace with your actual cubit creation logic
                                                      child: ReservationTicket(
                                                        tripTypeId: "2",
                                                        countSeats2:
                                                            cachCountSeats2,
                                                        user: widget.user,
                                                      ))),
                                        );
                                      }
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
                                    style: fontStyle(
                                        color: Colors.white,
                                        fontFamily: FontFamily.bold,
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
                                      print(Reservationtimer.start.toString());

                                      if (Reservationtimer.start == 120) {
                                        showtimer = true;
                                        Reservationtimer.start = 120;

                                        Reservationtimer.startTimer(
                                          context,
                                          () {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Routes.home,
                                                (route) => false,
                                                arguments: Routes.isomra);
                                          },
                                        );

                                        if (Reservationtimer
                                                .controller.isStarted ==
                                            ValueNotifier<bool>(false)) {
                                          Reservationtimer.controller.start();
                                        }
                                      }

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

                                      countSeats.add(busSeatsModel!
                                          .busSeatDetails!
                                          .busDetails!
                                          .rowList![rowI]
                                          .seats[colI]
                                          .seatBusID!);
                                      seatsnumber.add(busSeatsModel!
                                          .busSeatDetails!
                                          .busDetails!
                                          .rowList![rowI]
                                          .seats[colI]
                                          .seatNo!);
                                      print("countSeats${seatsnumber}");
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
                                      seatsnumber.remove(busSeatsModel!
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
                                    seatSvgSize: 30.sp.toInt(),
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
