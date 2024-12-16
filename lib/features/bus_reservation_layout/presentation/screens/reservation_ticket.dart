import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:intl/intl.dart' as intl;
import 'package:swa/core/widgets/Timer_widget.dart';
import 'package:swa/features/bus_reservation_layout/data/models/BusSeatsModel.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Ticket_class.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/bus_layout.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/bus_layout_back.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/Container_Widget.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_model.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_widget.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/text_widget.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/sign_in/presentation/screens/login.dart';
import 'package:swa/features/times_trips/data/models/TimesTripsResponsedart.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/features/times_trips/presentation/screens/times_screen_back.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/data/models/policyTicket_model.dart';
import 'package:swa/select_payment2/data/models/trip_reservartion_model.dart';
import 'package:swa/select_payment2/data/repo/reservation_repo/reservation_repo.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_states_my_wallet.dart';
import 'package:swa/select_payment2/presentation/screens/select_payment.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/icon_back.dart';
import '../../../sign_in/domain/entities/user.dart';
import '../../../sign_in/presentation/cubit/login_cubit.dart';

class ReservationTicket extends StatefulWidget {
  ReservationTicket(
      {super.key,
      required this.tripTypeId,
      this.countSeats2,
      this.tripListBack,
      this.user});

  String tripTypeId;

  List<dynamic>? countSeats2;
  User? user;

  List<TripList>? tripListBack;

  @override
  State<ReservationTicket> createState() => _ReservationTicketState();
}

class _ReservationTicketState extends State<ReservationTicket> {
  BusSeatsModel? busSeatsModel;
  BusLayoutRepo busLayoutRepo = BusLayoutRepo(apiConsumer: (sl()));

  bool switch1 = false;
  bool accept = false;
  int numberTrip = 0;
  String elite = "";
  String accessBusTime = "";
  TextEditingController _promocodetext = new TextEditingController();
  String accessDate = '';
  String accessDate2 = '';

  String lineName = "";
  ReservationRepo reservationCubit = ReservationRepo(apiConsumer: sl());
  Policyticketmodel policy = Policyticketmodel();
  int? numberTrip2;
  String? elite2;
  String? accessBusTime2;
  String? lineName2;
  double discount = 0;
  double minusdiscount = 0;
  double minusdiscount2 = 0;

  double realprice = 0;
  double realprice2 = 0;

  double totaldiscount = 0;

  String promocodid = '';
  bool ihaveprocode = false;
  double afterdiscount = 0;
  double afterdiscount2 = 0;

  PackagesBloc _packagesBloc = new PackagesBloc();

  @override
  void initState() {
    log(widget.tripTypeId);
    afterdiscount =
        (Ticketreservation.countSeats1.length * Ticketreservation.priceticket1);

    afterdiscount2 =
        (Ticketreservation.countSeats2.length * Ticketreservation.priceticket2);
    realprice =
        (Ticketreservation.countSeats1.length * Ticketreservation.priceticket1);

    realprice2 =
        (Ticketreservation.countSeats2.length * Ticketreservation.priceticket2);

    Future.delayed(const Duration(seconds: 0)).then((_) async {
      BlocProvider.of<LoginCubit>(context).getUserData();
      policy = await reservationCubit.getpolicy();
    });

    numberTrip = CacheHelper.getDataToSharedPref(key: 'numberTrip');
    elite = CacheHelper.getDataToSharedPref(key: "elite");
    accessDate = CacheHelper.getDataToSharedPref(key: "accessBusDate");
    accessBusTime = CacheHelper.getDataToSharedPref(key: "accessBusTime");
    lineName = CacheHelper.getDataToSharedPref(key: "lineName");
    if (widget.tripTypeId == '2') {
      numberTrip2 = CacheHelper.getDataToSharedPref(key: 'numberTrip2');
      elite2 = CacheHelper.getDataToSharedPref(key: "elite2");
      accessDate2 = CacheHelper.getDataToSharedPref(key: "accessBusDate2");

      accessBusTime2 = CacheHelper.getDataToSharedPref(key: "accessBusTime2");
      lineName2 = CacheHelper.getDataToSharedPref(key: "lineName2");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener(
        bloc: _packagesBloc,
        listener: (context, PackagesState state) {
          if (state.promocodemodel?.status == 'failed') {
            _promocodetext.text = '';
            Constants.showDefaultSnackBar(
                color: Colors.red,
                context: context,
                text: state.promocodemodel!.errormessage ?? ' ');
          } else if (state.promocodemodel?.status == 'success') {
            discount = state.promocodemodel!.message!.discount!;

            totaldiscount = state.promocodemodel!.message!.discount!;
            promocodid = state.promocodemodel!.message!.promoCodeId.toString();

            Routes.PromoCodeID =
                state.promocodemodel!.message!.promoCodeId.toString();

            if (widget.tripTypeId == '2') {
              discount = discount / 2;

              Routes.discount = discount;
            }

            if (state.promocodemodel!.message!.isPrecentage == true) {
              Routes.ispercentage = true;

              minusdiscount = ((realprice) * discount) / 100;
              minusdiscount2 = ((realprice2) * discount) / 100;

              afterdiscount = realprice - minusdiscount;
              afterdiscount2 = realprice2 - minusdiscount2;
            } else {
              afterdiscount = realprice - discount;
              afterdiscount2 = realprice2 - discount;
            }
          }
        },
        child: BlocBuilder(
            bloc: _packagesBloc,
            builder: (context, PackagesState state) {
              if (state.isloading == true) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              } else {
                return Directionality(
                  textDirection: LanguageClass.isEnglish
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        SizedBox(
                          height: sizeHeight * 0.08,
                        ),
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
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LanguageClass.isEnglish ? "Ticket" : "تذكرتك",
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "black"),
                              ),
                              Timerwidget(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: sizeHeight * 0.01,
                        ),

                        Container(
                          height: 175,
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          padding: EdgeInsets.all(15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xffFF5D4B)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   LanguageClass.isEnglish
                                      //       ? "Departure "
                                      //       : "تغادر في",
                                      //   style: const TextStyle(
                                      //       color: Colors.white,
                                      //       fontFamily: "bold",
                                      //       fontSize: 23),
                                      // ),

                                      Expanded(
                                          child: Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${DateTime.parse(accessDate).day.toString()}/${DateTime.parse(accessDate).month.toString()}/${DateTime.parse(accessDate).year.toString()}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "black",
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                intl.DateFormat('hh:mm a')
                                                    .format(DateTime.parse(
                                                        accessDate))
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "black",
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 5,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      AppColors.white,
                                                      AppColors.yellow2
                                                    ])),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  LanguageClass.isEnglish
                                                      ? "From"
                                                      : "من",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "black",
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  Ticketreservation
                                                      .fromcitystation1,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "black",
                                                      fontSize: 10.sp),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  LanguageClass.isEnglish
                                                      ? "To"
                                                      : "الي",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "black",
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  Ticketreservation
                                                      .tocitystation1,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "bold",
                                                      fontSize: 10.sp),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),

                                      Text(
                                        "${Routes.curruncy} $afterdiscount",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "black",
                                            fontSize: 16),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 14,
                                        height: 14,
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                            "assets/images/Icon fa-solid-bus.png"),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        numberTrip.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "black",
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      busLayoutRepo
                                          .getBusSeatsData(
                                              tripId: Ticketreservation.tripid1)
                                          .then((value) async {
                                        busSeatsModel = await value;

                                        if (busSeatsModel != null) {
                                          for (int i = 0;
                                              i <
                                                  busSeatsModel!.busSeatDetails!
                                                      .busDetails!.totalRow!;
                                              i++) {
                                            for (int j = 0;
                                                j <
                                                    busSeatsModel!
                                                        .busSeatDetails!
                                                        .busDetails!
                                                        .rowList![i]
                                                        .seats
                                                        .length;
                                                j++) {
                                              if (busSeatsModel
                                                          ?.busSeatDetails
                                                          ?.busDetails
                                                          ?.rowList?[i]
                                                          .seats[j]
                                                          .isReserved ==
                                                      true ||
                                                  busSeatsModel
                                                          ?.busSeatDetails
                                                          ?.busDetails
                                                          ?.rowList?[i]
                                                          .seats[j]
                                                          .isAvailable ==
                                                      true) {
                                                busSeatsModel
                                                    ?.busSeatDetails
                                                    ?.busDetails
                                                    ?.rowList?[i]
                                                    .seats[j]
                                                    .seatState = SeatState.sold;
                                              }

                                              for (var n = 0;
                                                  n <
                                                      Ticketreservation
                                                          .Seatsnumbers1.length;
                                                  n++) {
                                                if (busSeatsModel
                                                        ?.busSeatDetails
                                                        ?.busDetails
                                                        ?.rowList?[i]
                                                        .seats[j]
                                                        .seatNo ==
                                                    Ticketreservation
                                                        .Seatsnumbers1[n]) {
                                                  busSeatsModel
                                                          ?.busSeatDetails
                                                          ?.busDetails
                                                          ?.rowList?[i]
                                                          .seats[j]
                                                          .seatState =
                                                      SeatState.booked;
                                                }
                                              }
                                            }
                                          }

                                          setState(() {});
                                        }

                                        showGeneralDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierLabel:
                                                MaterialLocalizations.of(
                                                        context)
                                                    .modalBarrierDismissLabel,
                                            barrierColor:
                                                Colors.black.withOpacity(0.5),
                                            transitionDuration: const Duration(
                                                milliseconds: 200),
                                            pageBuilder: (context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation) {
                                              return Material(
                                                child: SafeArea(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Icon(
                                                            Icons.close,
                                                            color: AppColors
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SeatLayoutWidget(
                                                              seatHeight:
                                                                  sizeHeight *
                                                                      .036,
                                                              onSeatStateChanged:
                                                                  (rowI,
                                                                      colI,
                                                                      seatState,
                                                                      seat) {},
                                                              stateModel:
                                                                  SeatLayoutStateModel(
                                                                rows: busSeatsModel
                                                                        ?.busSeatDetails
                                                                        ?.busDetails
                                                                        ?.rowList
                                                                        ?.length ??
                                                                    0,
                                                                cols: busSeatsModel
                                                                        ?.busSeatDetails
                                                                        ?.busDetails
                                                                        ?.totalColumn ??
                                                                    5,
                                                                seatSvgSize: 30
                                                                    .sp
                                                                    .toInt(),
                                                                pathSelectedSeat:
                                                                    'assets/images/unavailable_seats.svg',
                                                                pathDisabledSeat:
                                                                    'assets/images/unavailable_seats.svg',
                                                                pathSoldSeat:
                                                                    'assets/images/disabled_seats.svg',
                                                                pathUnSelectedSeat:
                                                                    'assets/images/unavailable_seats.svg',
                                                                currentSeats:
                                                                    List.generate(
                                                                  busSeatsModel
                                                                          ?.busSeatDetails
                                                                          ?.busDetails
                                                                          ?.rowList
                                                                          ?.length ??
                                                                      0,

                                                                  // Number of rows based on totalSeats
                                                                  (row) => busSeatsModel!
                                                                      .busSeatDetails!
                                                                      .busDetails!
                                                                      .rowList![
                                                                          row]
                                                                      .seats,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 14,
                                          height: 14,
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                              "assets/images/chairs.png"),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          ' ${Ticketreservation.Seatsnumbers1.length.toString()} ${LanguageClass.isEnglish ? ' Seats' : ' كرسي'}',
                                          style: TextStyle(
                                              color: AppColors.white,
                                              fontFamily: "black",
                                              fontSize: 14),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.tripTypeId == '2') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return BlocProvider(
                                                create: (context) =>
                                                    BusLayoutCubit(),
                                                child: BusLayoutScreen(
                                                  isedit: true,
                                                  busdate: DateTime.parse(
                                                      Ticketreservation
                                                          .accessDate1),
                                                  busttime: Ticketreservation
                                                      .accessBusTime1,
                                                  to: Ticketreservation
                                                          .tocitystation1 ??
                                                      "",
                                                  from: Ticketreservation
                                                          .fromcitystation1 ??
                                                      "",
                                                  triTypeId: widget.tripTypeId,
                                                  tripListBack:
                                                      widget.tripListBack,
                                                  price: Ticketreservation
                                                      .priceticket1,
                                                  user: Routes.user,
                                                  tripId:
                                                      Ticketreservation.tripid1,
                                                  tocity: Ticketreservation
                                                          .tocity1 ??
                                                      '',
                                                  fromcity: Ticketreservation
                                                          .fromcity1 ??
                                                      '',
                                                ),
                                              );
                                            }),
                                          ).then((value) {
                                            afterdiscount = (Ticketreservation
                                                    .countSeats1.length *
                                                Ticketreservation.priceticket1);
                                            ihaveprocode = false;
                                            setState(() {});

                                            log('Edit ');
                                          });
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: AppColors.white,
                                                  offset: Offset(0, 0),
                                                  spreadRadius: 0,
                                                  blurRadius: 15)
                                            ],
                                            color: AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Text(
                                          LanguageClass.isEnglish
                                              ? 'Edit '
                                              : 'تعديل ',
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontFamily: 'black',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      elite,
                                      style: TextStyle(
                                          fontFamily: "black",
                                          fontSize: 15,
                                          color: Color(0xfff7f8f9)),
                                    ),
                                  ))
                                ],
                              ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        widget.tripTypeId == '2'
                            ? Container(
                                height: 175,
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                padding: EdgeInsets.all(15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(0xffFF5D4B)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${DateTime.parse(accessDate2!).day.toString()}/${DateTime.parse(accessDate2!).month.toString()}/${DateTime.parse(accessDate2!).year.toString()}',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "black",
                                                          fontSize: 13),
                                                    ),
                                                    Text(
                                                      intl.DateFormat('hh:mm a')
                                                          .format(
                                                              DateTime.parse(
                                                                  accessDate2))
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "black",
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  width: 5,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                      gradient: LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            AppColors.white,
                                                            AppColors.yellow2
                                                          ])),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        LanguageClass.isEnglish
                                                            ? "From"
                                                            : "من",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: "black",
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        Ticketreservation
                                                            .fromcitystation2,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: "black",
                                                            fontSize: 10.sp),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        LanguageClass.isEnglish
                                                            ? "To"
                                                            : "الي",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: "black",
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        Ticketreservation
                                                            .tocitystation2,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: "black",
                                                            fontSize: 10.sp),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                            Text(
                                              "${Routes.curruncy} $afterdiscount2",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "black",
                                                  fontSize: 16),
                                            ),
                                          ],
                                        )),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 14,
                                              height: 14,
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                  "assets/images/Icon fa-solid-bus.png"),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              numberTrip2.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "black",
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            busLayoutRepo
                                                .getBusSeatsData(
                                                    tripId: Ticketreservation
                                                        .tripid1)
                                                .then((value) async {
                                              busSeatsModel = await value;

                                              if (busSeatsModel != null) {
                                                for (int i = 0;
                                                    i <
                                                        busSeatsModel!
                                                            .busSeatDetails!
                                                            .busDetails!
                                                            .totalRow!;
                                                    i++) {
                                                  for (int j = 0;
                                                      j <
                                                          busSeatsModel!
                                                              .busSeatDetails!
                                                              .busDetails!
                                                              .rowList![i]
                                                              .seats
                                                              .length;
                                                      j++) {
                                                    if (busSeatsModel
                                                                ?.busSeatDetails
                                                                ?.busDetails
                                                                ?.rowList?[i]
                                                                .seats[j]
                                                                .isReserved ==
                                                            true ||
                                                        busSeatsModel
                                                                ?.busSeatDetails
                                                                ?.busDetails
                                                                ?.rowList?[i]
                                                                .seats[j]
                                                                .isAvailable ==
                                                            true) {
                                                      busSeatsModel
                                                              ?.busSeatDetails
                                                              ?.busDetails
                                                              ?.rowList?[i]
                                                              .seats[j]
                                                              .seatState =
                                                          SeatState.sold;
                                                    }

                                                    for (var n = 0;
                                                        n <
                                                            Ticketreservation
                                                                .Seatsnumbers2
                                                                .length;
                                                        n++) {
                                                      if (busSeatsModel
                                                              ?.busSeatDetails
                                                              ?.busDetails
                                                              ?.rowList?[i]
                                                              .seats[j]
                                                              .seatNo ==
                                                          Ticketreservation
                                                                  .Seatsnumbers2[
                                                              n]) {
                                                        busSeatsModel
                                                                ?.busSeatDetails
                                                                ?.busDetails
                                                                ?.rowList?[i]
                                                                .seats[j]
                                                                .seatState =
                                                            SeatState.booked;
                                                      }
                                                    }
                                                  }
                                                }

                                                setState(() {});
                                              }

                                              showGeneralDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  barrierLabel:
                                                      MaterialLocalizations.of(
                                                              context)
                                                          .modalBarrierDismissLabel,
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.5),
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  pageBuilder: (context,
                                                      Animation<double>
                                                          animation,
                                                      Animation<double>
                                                          secondaryAnimation) {
                                                    return Material(
                                                      child: SafeArea(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Icon(
                                                                  Icons.close,
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SeatLayoutWidget(
                                                                    seatHeight:
                                                                        sizeHeight *
                                                                            .036,
                                                                    onSeatStateChanged: (rowI,
                                                                        colI,
                                                                        seatState,
                                                                        seat) {},
                                                                    stateModel:
                                                                        SeatLayoutStateModel(
                                                                      rows: busSeatsModel
                                                                              ?.busSeatDetails
                                                                              ?.busDetails
                                                                              ?.rowList
                                                                              ?.length ??
                                                                          0,
                                                                      cols: busSeatsModel
                                                                              ?.busSeatDetails
                                                                              ?.busDetails
                                                                              ?.totalColumn ??
                                                                          5,
                                                                      seatSvgSize: 30
                                                                          .sp
                                                                          .toInt(),
                                                                      pathSelectedSeat:
                                                                          'assets/images/unavailable_seats.svg',
                                                                      pathDisabledSeat:
                                                                          'assets/images/unavailable_seats.svg',
                                                                      pathSoldSeat:
                                                                          'assets/images/disabled_seats.svg',
                                                                      pathUnSelectedSeat:
                                                                          'assets/images/unavailable_seats.svg',
                                                                      currentSeats:
                                                                          List.generate(
                                                                        busSeatsModel?.busSeatDetails?.busDetails?.rowList?.length ??
                                                                            0,

                                                                        // Number of rows based on totalSeats
                                                                        (row) => busSeatsModel!
                                                                            .busSeatDetails!
                                                                            .busDetails!
                                                                            .rowList![row]
                                                                            .seats,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 14,
                                                height: 14,
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                    "assets/images/chairs.png"),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                ' ${Ticketreservation.Seatsnumbers2.length.toString()} ${LanguageClass.isEnglish ? ' Seats' : ' كرسي'}',
                                                style: TextStyle(
                                                    color: AppColors.white,
                                                    fontFamily: "black",
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
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
                                                              ),
                                                              BlocProvider<
                                                                  BusLayoutCubit>(
                                                                create: (context) =>
                                                                    BusLayoutCubit(),
                                                              )
                                                            ],
                                                            // Replace with your actual cubit creation logic
                                                            child:
                                                                BusLayoutScreenBack(
                                                              isedit: true,
                                                              to: Ticketreservation
                                                                      .tocitystation2 ??
                                                                  "",
                                                              from: Ticketreservation
                                                                      .fromcitystation2 ??
                                                                  "",
                                                              triTypeId: widget
                                                                  .tripTypeId,
                                                              price: Ticketreservation
                                                                  .priceticket2,
                                                              user: Routes.user,
                                                              tripId:
                                                                  Ticketreservation
                                                                      .tripid2,
                                                              tocity: Ticketreservation
                                                                      .tocity2 ??
                                                                  '',
                                                              fromcity:
                                                                  Ticketreservation
                                                                          .fromcity2 ??
                                                                      '',
                                                              busdate: DateTime.parse(
                                                                  Ticketreservation
                                                                      .accessDate2),
                                                              busttime:
                                                                  Ticketreservation
                                                                      .accessBusTime2,
                                                            ))),
                                              ).then((value) {
                                                afterdiscount2 =
                                                    (Ticketreservation
                                                            .countSeats2
                                                            .length *
                                                        Ticketreservation
                                                            .priceticket2);
                                                ihaveprocode = false;
                                                setState(() {});

                                                log('Edit ');
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 5),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: AppColors.white,
                                                        offset: Offset(0, 0),
                                                        spreadRadius: 0,
                                                        blurRadius: 15)
                                                  ],
                                                  color: AppColors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Text(
                                                LanguageClass.isEnglish
                                                    ? 'Edit '
                                                    : 'تعديل ',
                                                style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'black',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: Container(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            elite2!,
                                            style: TextStyle(
                                                fontFamily: "black",
                                                fontSize: 15,
                                                color: Color(0xfff7f8f9)),
                                          ),
                                        ))
                                      ],
                                    ))
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 0,
                              ),

                        SizedBox(
                          height: 20,
                        ),
                        ihaveprocode == false
                            ? InkWell(
                                onTap: (() {
                                  setState(() {
                                    ihaveprocode = true;
                                  });
                                }),
                                child: Container(
                                  height: 44,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColors.primaryColor,
                                            blurRadius: 3,
                                            offset: Offset(0, 3))
                                      ]),
                                  child: Text(
                                    LanguageClass.isEnglish
                                        ? 'I have a Promocode !'
                                        : 'لدي كود خصم ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : Container(
                                height: 44,
                                decoration: BoxDecoration(
                                    color: Color(0xffDEDEDE),
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xffa7a7a7)
                                              .withOpacity(0.1),
                                          blurRadius: 3,
                                          offset: Offset(0, 3))
                                    ]),
                                child: TextField(
                                  controller: _promocodetext,
                                  style: TextStyle(
                                      color: Color(0xff969696),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    hintText: LanguageClass.isEnglish
                                        ? 'Enter Promocode !'
                                        : ' كود الخصم ',
                                    hintStyle: TextStyle(
                                        color: Color(0xff969696),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        if (Routes.user == null) {
                                          Constants.showDefaultSnackBar(
                                              color: Colors.red,
                                              context: context,
                                              text: LanguageClass.isEnglish
                                                  ? 'Please login'
                                                  : 'من فضلك سجل الدخول ');
                                        } else {
                                          if (_promocodetext.text != "") {
                                            Routes.resrvedtrips.clear();
                                            if (widget.tripTypeId == '2') {
                                              final tripOneId = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'tripOneId');
                                              final tripRoundId = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'tripRoundId');
                                              final selectedDayTo = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'selectedDayTo');
                                              final selectedDayFrom = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'selectedDayFrom');
                                              final toStationId = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'toStationId');
                                              final fromStationId = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'fromStationId');
                                              final seatIdsOneTrip = CacheHelper
                                                      .getDataToSharedPref(
                                                          key: 'countSeats')
                                                  ?.map((e) =>
                                                      int.tryParse(e) ?? 0)
                                                  .toList();
                                              final seatIdsRoundTrip =
                                                  CacheHelper
                                                          .getDataToSharedPref(
                                                              key:
                                                                  'countSeats2')
                                                      ?.map((e) =>
                                                          int.tryParse(e) ?? 0)
                                                      .toList();
                                              final price = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'price');
                                              final busdate = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'accessBusDate');

                                              final lineid = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'lineid');
                                              final busid = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'busId');
                                              final serviceTypeID = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'serviceTypeID');

                                              final tripOneId2 = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'tripOneId');
                                              final tripRoundId2 = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'tripRoundId');
                                              final selectedDayTo2 = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'selectedDayTo');
                                              final selectedDayFrom2 =
                                                  CacheHelper
                                                      .getDataToSharedPref(
                                                          key:
                                                              'selectedDayFrom');
                                              final toStationId2 = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'toStationId');
                                              final fromStationId2 = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'fromStationId');
                                              final seatIdsOneTrip2 =
                                                  CacheHelper
                                                          .getDataToSharedPref(
                                                              key: 'countSeats')
                                                      ?.map((e) =>
                                                          int.tryParse(e) ?? 0)
                                                      .toList();
                                              final seatIdsRoundTrip2 =
                                                  CacheHelper
                                                          .getDataToSharedPref(
                                                              key:
                                                                  'countSeats2')
                                                      ?.map((e) =>
                                                          int.tryParse(e) ?? 0)
                                                      .toList();
                                              final price2 = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'price');
                                              final busdate2 = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'accessBusDate2');

                                              final lineid2 = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'lineid2');
                                              final busid2 = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'busId2');
                                              final serviceTypeID2 = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'serviceTypeID2');

                                              TripReservationList trip =
                                                  TripReservationList(
                                                      busId: Ticketreservation
                                                          .busid1,
                                                      discount:
                                                          discount.toString(),
                                                      fromStationId:
                                                          fromStationId,
                                                      lineId: lineid,
                                                      price: afterdiscount,
                                                      seatIds: Ticketreservation
                                                          .countSeats1,
                                                      serviceTypeId:
                                                          serviceTypeID,
                                                      toStationId: toStationId,
                                                      tripDate: DateTime.parse(
                                                          busdate),
                                                      tripId: Ticketreservation
                                                          .tripid1);

                                              TripReservationList trip2 =
                                                  TripReservationList(
                                                      busId: Ticketreservation
                                                          .busid2,
                                                      discount:
                                                          discount.toString(),
                                                      fromStationId:
                                                          toStationId,
                                                      lineId: lineid2,
                                                      price: afterdiscount2,
                                                      seatIds: Ticketreservation
                                                          .countSeats2,
                                                      serviceTypeId:
                                                          serviceTypeID2,
                                                      toStationId:
                                                          fromStationId,
                                                      tripDate: DateTime.parse(
                                                          busdate2),
                                                      tripId: Ticketreservation
                                                          .tripid2);

                                              Routes.resrvedtrips.add(trip);

                                              Routes.resrvedtrips.add(trip2);

                                              if (Routes.user == null) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MultiBlocProvider(
                                                        providers: [
                                                          BlocProvider<
                                                              LoginCubit>(
                                                            create: (context) =>
                                                                sl<LoginCubit>(),
                                                          ),
                                                        ],
                                                        child: LoginScreen(
                                                          isback: true,
                                                        ),
                                                      ),
                                                    ));
                                              } else {
                                                int lenght = widget
                                                        .countSeats2?.length ??
                                                    0;
                                                CacheHelper.setDataToSharedPref(
                                                  key: 'price',
                                                  value: afterdiscount,
                                                );
                                                _packagesBloc.add(
                                                    PromocodReservationEvent(
                                                        promocode:
                                                            _promocodetext.text,
                                                        promocodeid: '',
                                                        custId: widget
                                                            .user!.customerId!,
                                                        paymentTypeID: 67,
                                                        trips: Routes
                                                            .resrvedtrips));
                                              }
                                            } else {
                                              final tripOneId = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'tripOneId');
                                              final tripRoundId = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'tripRoundId');
                                              final selectedDayTo = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'selectedDayTo');
                                              final selectedDayFrom = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'selectedDayFrom');
                                              final toStationId = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'toStationId');
                                              final fromStationId = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'fromStationId');
                                              final seatIdsOneTrip = CacheHelper
                                                      .getDataToSharedPref(
                                                          key: 'countSeats')
                                                  ?.map((e) =>
                                                      int.tryParse(e) ?? 0)
                                                  .toList();
                                              final seatIdsRoundTrip =
                                                  CacheHelper
                                                          .getDataToSharedPref(
                                                              key:
                                                                  'countSeats2')
                                                      ?.map((e) =>
                                                          int.tryParse(e) ?? 0)
                                                      .toList();
                                              final price = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'price');
                                              final busdate = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'accessBusDate');

                                              final lineid = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'lineid');
                                              final busid = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'busId');
                                              final serviceTypeID = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'serviceTypeID');

                                              TripReservationList trip =
                                                  TripReservationList(
                                                      busId: Ticketreservation
                                                          .busid1,
                                                      discount:
                                                          discount.toString(),
                                                      fromStationId:
                                                          fromStationId,
                                                      lineId: lineid,
                                                      price: afterdiscount,
                                                      seatIds: Ticketreservation
                                                          .countSeats1,
                                                      serviceTypeId:
                                                          serviceTypeID,
                                                      toStationId: toStationId,
                                                      tripDate: DateTime.parse(
                                                          busdate),
                                                      tripId: Ticketreservation
                                                          .tripid1);

                                              Routes.resrvedtrips.add(trip);

                                              _packagesBloc.add(
                                                  PromocodReservationEvent(
                                                      promocode:
                                                          _promocodetext.text,
                                                      promocodeid: '',
                                                      custId: widget
                                                          .user!.customerId!,
                                                      paymentTypeID: 67,
                                                      trips:
                                                          Routes.resrvedtrips));
                                            }
                                          } else {
                                            Constants.showDefaultSnackBar(
                                                color: Colors.red,
                                                context: context,
                                                text: LanguageClass.isEnglish
                                                    ? 'Please enter code'
                                                    : 'من فضلك  ادخل الكود ');
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Color(0xffFF5D4B),
                                            borderRadius:
                                                BorderRadius.circular(22)),
                                        padding: EdgeInsets.only(left: 0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          LanguageClass.isEnglish
                                              ? 'Apply'
                                              : "تطبيق",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                LanguageClass.isEnglish ? 'Disscount' : "خصم",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'black',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                state.promocodemodel!.message?.isPrecentage ==
                                        true
                                    ? widget.tripTypeId == '2'
                                        ? "${minusdiscount + minusdiscount2} ${Routes.curruncy}"
                                        : "$minusdiscount ${Routes.curruncy}"
                                    : "$totaldiscount ${Routes.curruncy}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontFamily: 'black',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                LanguageClass.isEnglish
                                    ? 'Total Price'
                                    : "السعر الكلي",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'black',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.tripTypeId == '2'
                                    ? "  ${afterdiscount + afterdiscount2} ${Routes.curruncy}"
                                    : "  $afterdiscount ${Routes.curruncy}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontFamily: 'black',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 20),
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                  value: accept,
                                  hoverColor: Colors.black,
                                  checkColor: AppColors.primaryColor,
                                  focusColor: Colors.black,
                                  activeColor: Colors.black,
                                  fillColor:
                                      MaterialStatePropertyAll(Colors.grey),
                                  onChanged: (value) {
                                    showAdaptiveDialog(
                                      context: context,
                                      builder: (BuildContext buildContext) {
                                        return Directionality(
                                          textDirection: LanguageClass.isEnglish
                                              ? TextDirection.ltr
                                              : TextDirection.rtl,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Container(
                                              color: Colors.white,
                                              margin: EdgeInsets.all(20),
                                              padding: EdgeInsets.all(30),
                                              child: ListView(
                                                children: [
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? 'Terms and conditions '
                                                        : "الشروط والأحكام",
                                                    textAlign:
                                                        LanguageClass.isEnglish
                                                            ? TextAlign.left
                                                            : TextAlign.right,
                                                    textDirection:
                                                        LanguageClass.isEnglish
                                                            ? TextDirection.ltr
                                                            : TextDirection.rtl,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'black',
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 0),
                                                    child: ListView.builder(
                                                      itemCount: policy
                                                          .message!.length,
                                                      shrinkWrap: true,
                                                      physics: ScrollPhysics(),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Text(
                                                          "${index + 1} - ${policy.message![index]}",
                                                          textAlign:
                                                              LanguageClass
                                                                      .isEnglish
                                                                  ? TextAlign
                                                                      .left
                                                                  : TextAlign
                                                                      .right,
                                                          textDirection:
                                                              LanguageClass
                                                                      .isEnglish
                                                                  ? TextDirection
                                                                      .ltr
                                                                  : TextDirection
                                                                      .rtl,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff818181),
                                                            fontSize: 14,
                                                            fontFamily: 'black',
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 30),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            LanguageClass
                                                                    .isEnglish
                                                                ? "Done"
                                                                : 'تم',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'black',
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      barrierDismissible: true,
                                      barrierLabel:
                                          MaterialLocalizations.of(context)
                                              .modalBarrierDismissLabel,
                                      barrierColor:
                                          Colors.black.withOpacity(0.5),
                                    );

                                    setState(() {
                                      accept = value!;
                                    });
                                  }),
                              Text(
                                LanguageClass.isEnglish
                                    ? 'Accept reservation policy'
                                    : 'قبول سياسة الحجز',
                                style: TextStyle(
                                    fontFamily: 'black',
                                    color: Colors.black,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: accept
                                ? () {
                                    Routes.resrvedtrips.clear();
                                    if (widget.tripTypeId == '2') {
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
                                      final price =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'price');
                                      final busdate =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'accessBusDate');

                                      final lineid =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'lineid');
                                      final busid =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'busId');
                                      final serviceTypeID =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'serviceTypeID');

                                      final tripOneId2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'tripOneId');
                                      final tripRoundId2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'tripRoundId');
                                      final selectedDayTo2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'selectedDayTo');
                                      final selectedDayFrom2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'selectedDayFrom');
                                      final toStationId2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'toStationId');
                                      final fromStationId2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'fromStationId');
                                      final seatIdsOneTrip2 =
                                          CacheHelper.getDataToSharedPref(
                                                  key: 'countSeats')
                                              ?.map((e) => int.tryParse(e) ?? 0)
                                              .toList();
                                      final seatIdsRoundTrip2 =
                                          CacheHelper.getDataToSharedPref(
                                                  key: 'countSeats2')
                                              ?.map((e) => int.tryParse(e) ?? 0)
                                              .toList();
                                      final price2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'price');
                                      final busdate2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'accessBusDate2');

                                      final lineid2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'lineid2');
                                      final busid2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'busId2');
                                      final serviceTypeID2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'serviceTypeID2');

                                      TripReservationList trip =
                                          TripReservationList(
                                              busId: Ticketreservation.busid1,
                                              discount: discount.toString(),
                                              fromStationId: fromStationId,
                                              lineId: lineid,
                                              price: afterdiscount,
                                              seatIds:
                                                  Ticketreservation.countSeats1,
                                              serviceTypeId: serviceTypeID,
                                              toStationId: toStationId,
                                              tripDate: DateTime.parse(busdate),
                                              tripId:
                                                  Ticketreservation.tripid1);

                                      TripReservationList trip2 =
                                          TripReservationList(
                                              busId: Ticketreservation.busid2,
                                              discount: discount.toString(),
                                              fromStationId: toStationId,
                                              lineId: lineid2,
                                              price: afterdiscount2,
                                              seatIds:
                                                  Ticketreservation.countSeats2,
                                              serviceTypeId: serviceTypeID2,
                                              toStationId: fromStationId,
                                              tripDate:
                                                  DateTime.parse(busdate2),
                                              tripId:
                                                  Ticketreservation.tripid2);

                                      Routes.resrvedtrips.add(trip);

                                      Routes.resrvedtrips.add(trip2);

                                      if (Routes.user == null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MultiBlocProvider(
                                                providers: [
                                                  BlocProvider<LoginCubit>(
                                                    create: (context) =>
                                                        sl<LoginCubit>(),
                                                  ),
                                                ],
                                                child: LoginScreen(
                                                  isback: true,
                                                ),
                                              ),
                                            ));
                                      } else {
                                        int lenght =
                                            widget.countSeats2?.length ?? 0;
                                        CacheHelper.setDataToSharedPref(
                                          key: 'price',
                                          value: afterdiscount,
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BlocProvider<ReservationCubit>(
                                              create: (context) =>
                                                  ReservationCubit(),
                                              child: SelectPaymentScreen2(
                                                  discount: discount.toString(),
                                                  promcodeid: promocodid,
                                                  user: Routes.user),
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
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
                                      final price =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'price');
                                      final busdate =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'accessBusDate');

                                      final lineid =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'lineid');
                                      final busid =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'busId');
                                      final serviceTypeID =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'serviceTypeID');

                                      TripReservationList trip =
                                          TripReservationList(
                                              busId: Ticketreservation.busid1,
                                              discount: discount.toString(),
                                              fromStationId: fromStationId,
                                              lineId: lineid,
                                              price: afterdiscount,
                                              seatIds:
                                                  Ticketreservation.countSeats1,
                                              serviceTypeId: serviceTypeID,
                                              toStationId: toStationId,
                                              tripDate: DateTime.parse(busdate),
                                              tripId:
                                                  Ticketreservation.tripid1);

                                      Routes.resrvedtrips.add(trip);

                                      if (Routes.user == null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MultiBlocProvider(
                                                providers: [
                                                  BlocProvider<LoginCubit>(
                                                    create: (context) =>
                                                        sl<LoginCubit>(),
                                                  ),
                                                ],
                                                child: LoginScreen(
                                                  isback: true,
                                                ),
                                              ),
                                            ));
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BlocProvider<ReservationCubit>(
                                              create: (context) =>
                                                  ReservationCubit(),
                                              child: SelectPaymentScreen2(
                                                  discount: discount.toString(),
                                                  promcodeid: promocodid,
                                                  user: Routes.user),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                : null,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Constants.customButton(
                                  text: LanguageClass.isEnglish
                                      ? "Reservation"
                                      : "حجز",
                                  color: accept
                                      ? AppColors.primaryColor
                                      : AppColors.darkGrey),
                            ))
                        // : InkWell(
                        //     onTap: () {
                        //       final tripOneId =
                        //           CacheHelper.getDataToSharedPref(
                        //               key: 'tripOneId');
                        //       final tripRoundId =
                        //           CacheHelper.getDataToSharedPref(
                        //               key: 'tripRoundId');
                        //       final selectedDayTo =
                        //           CacheHelper.getDataToSharedPref(
                        //               key: 'selectedDayTo');
                        //       final selectedDayFrom =
                        //           CacheHelper.getDataToSharedPref(
                        //               key: 'selectedDayFrom');
                        //       final toStationId =
                        //           CacheHelper.getDataToSharedPref(
                        //               key: 'toStationId');
                        //       final fromStationId =
                        //           CacheHelper.getDataToSharedPref(
                        //               key: 'fromStationId');
                        //       final seatIdsOneTrip =
                        //           CacheHelper.getDataToSharedPref(
                        //                   key: 'countSeats')
                        //               ?.map((e) => int.tryParse(e) ?? 0)
                        //               .toList();
                        //       final seatIdsRoundTrip =
                        //           CacheHelper.getDataToSharedPref(
                        //                   key: 'countSeats2')
                        //               ?.map((e) => int.tryParse(e) ?? 0)
                        //               .toList();
                        //       final price = CacheHelper.getDataToSharedPref(
                        //           key: 'price');
                        //       final busdate =
                        //           CacheHelper.getDataToSharedPref(
                        //               key: 'accessBusDate');

                        //       final lineid =
                        //           CacheHelper.getDataToSharedPref(
                        //               key: 'lineid');
                        //       final busid = CacheHelper.getDataToSharedPref(
                        //           key: 'busId');
                        //       final serviceTypeID =
                        //           CacheHelper.getDataToSharedPref(
                        //               key: 'serviceTypeID');

                        //       TripReservationList trip =
                        //           TripReservationList(
                        //               busId: busid,
                        //               discount: discount.toString(),
                        //               fromStationId: fromStationId,
                        //               lineId: lineid,
                        //               price: afterdiscount,
                        //               seatIds: seatIdsOneTrip,
                        //               serviceTypeId: serviceTypeID,
                        //               toStationId: toStationId,
                        //               tripDate: DateTime.parse(busdate),
                        //               tripId: tripOneId);

                        //       Routes.resrvedtrips.add(trip);

                        //       log(Routes.resrvedtrips.toString());
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => MultiBlocProvider(
                        //                     providers: [
                        //                       BlocProvider<LoginCubit>(
                        //                           create: (context) =>
                        //                               sl<LoginCubit>()),
                        //                       BlocProvider<TimesTripsCubit>(
                        //                         create: (context) =>
                        //                             TimesTripsCubit(),
                        //                       )
                        //                     ],
                        //                     // Replace with your actual cubit creation logic
                        //                     child: TimesScreenBack(
                        //                       price: widget.price,
                        //                       tripListBack:
                        //                           widget.tripListBack!,
                        //                       tripTypeId: widget.tripTypeId,
                        //                       user: widget.user,
                        //                     ))),
                        //       );
                        //     },
                        //     child: Constants.customButton(
                        //         text: LanguageClass.isEnglish
                        //             ? "Back ticket"
                        //             : "تذكرة العودة",
                        //         color: accept
                        //             ? AppColors.primaryColor
                        //             : AppColors.darkGrey),
                        //   ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
