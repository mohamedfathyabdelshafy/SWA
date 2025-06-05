import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/Timer_widget.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/bus_reservation_layout/data/models/BusSeatsModel.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Ticket_class.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/bus_layout.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/bus_layout_back.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_model.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_widget.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/sign_in/presentation/screens/login.dart';
import 'package:swa/features/times_trips/data/models/TimesTripsResponsedart.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/data/models/policyTicket_model.dart';
import 'package:swa/select_payment2/data/models/trip_reservartion_model.dart';
import 'package:swa/select_payment2/data/repo/reservation_repo/reservation_repo.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/select_payment2/presentation/screens/select_payment.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../sign_in/domain/entities/user.dart';
import '../../../sign_in/presentation/cubit/login_cubit.dart';

class ReservationTicket extends StatefulWidget {
  ReservationTicket({
    super.key,
    required this.tripTypeId,
    this.countSeats2,
    this.tripListBack,
    this.companionList = const [],
    this.user,
    this.actualDiscount, // This is the actual discount to apply
  });

  String tripTypeId;

  List<dynamic>? countSeats2;
  User? user;

  List<TripList>? tripListBack;

  List companionList;

  final num? actualDiscount; // Changed to num? as it might be null or double

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
  double discount = 0; // Keeping for future use as requested
  double minusdiscount = 0; // Keeping for future use as requested
  double minusdiscount2 = 0; // Keeping for future use as requested

  double realprice = 0;
  double realprice2 = 0;

  double totaldiscount = 0; // Keeping for future use as requested

  String promocodid = '';
  bool ihaveprocode = false;
  double afterdiscount = 0;

  double afterdiscount2 = 0;

  PackagesBloc _packagesBloc = new PackagesBloc();

  @override
  void initState() {
    log("ReservationTicket Init State - Trip Type ID: ${widget.tripTypeId}");
    log("ReservationTicket Init State - Actual Discount Received: ${widget.actualDiscount}");

    // Calculate realprice for the 'go' trip
    realprice =
        (Ticketreservation.countSeats1.length * Ticketreservation.priceticket1);
    afterdiscount = realprice; // Initialize afterdiscount with realprice
    log("ReservationTicket Init State - Real Price Go: $realprice");

    // --- UPDATED LOGIC FOR MATCHED SEATS DISCOUNT ---
    // Calculate the number of matched seats.
    // This is the minimum number of seats selected for the 'go' trip and the 'back' trip.
    int matchedSeats = 0;
    if (widget.tripTypeId == '2') {
      matchedSeats = (Ticketreservation.countSeats1.length <
              Ticketreservation.countSeats2.length
          ? Ticketreservation.countSeats1.length
          : Ticketreservation.countSeats2.length);
    } else {
      // For a one-way trip, there are no 'matched' seats in the same sense as a round trip.
      // The discount will apply per selected seat for the single trip.
      matchedSeats = Ticketreservation.countSeats1.length;
    }

    // Calculate the total discount based on actualDiscount (per seat) and matched seats
    totaldiscount = (widget.actualDiscount?.toDouble() ?? 0.0) * matchedSeats;
    log("ReservationTicket Init State - Calculated Total Discount (based on matched seats): $totaldiscount");
    // --- END UPDATED LOGIC ---

    if (widget.tripTypeId == '2') {
      // Round trip case
      // Calculate realprice2 for the 'back' trip
      realprice2 = (Ticketreservation.countSeats2.length *
          Ticketreservation.priceticket2);
      afterdiscount2 = realprice2; // Initialize afterdiscount2 with realprice2
      log("ReservationTicket Init State - Real Price Back: $realprice2");

      if (totaldiscount > 0) {
        // Only apply if a discount actually exists
        log("ReservationTicket Init State - Applying Round Trip Discount Logic");
        double combinedRealPrice = realprice + realprice2;
        if (combinedRealPrice > 0) {
          // Avoid division by zero
          double discountFactor = totaldiscount / combinedRealPrice;
          afterdiscount = realprice * (1 - discountFactor);
          afterdiscount2 = realprice2 * (1 - discountFactor);
        } else {
          afterdiscount = 0;
          afterdiscount2 = 0;
        }
      }
    } else {
      // One-way trip
      log("ReservationTicket Init State - One-Way Trip Discount Logic");
      // For one-way, totaldiscount is simply widget.actualDiscount * count of seats
      afterdiscount = realprice - totaldiscount;
    }

    log("ReservationTicket Init State - Final afterdiscount (Go): $afterdiscount");
    log("ReservationTicket Init State - Final afterdiscount (Back): $afterdiscount2");

    Future.delayed(const Duration(seconds: 0)).then((_) async {
      BlocProvider.of<LoginCubit>(context).getUserData();
      policy = await reservationCubit.getpolicy();
    });

    numberTrip = CacheHelper.getDataToSharedPref(key: 'numberTrip') ?? 0;
    elite = CacheHelper.getDataToSharedPref(key: "elite") ?? '';
    accessDate = CacheHelper.getDataToSharedPref(key: "accessBusDate") ?? '';
    accessBusTime = CacheHelper.getDataToSharedPref(key: "accessBusTime") ?? '';
    lineName = CacheHelper.getDataToSharedPref(key: "lineName") ?? '';
    if (widget.tripTypeId == '2') {
      numberTrip2 = CacheHelper.getDataToSharedPref(key: 'numberTrip2');
      elite2 = CacheHelper.getDataToSharedPref(key: "elite2");
      accessDate2 =
          CacheHelper.getDataToSharedPref(key: "accessBusDate2") != null
              ? CacheHelper.getDataToSharedPref(key: "accessBusDate2")
              : "";

      accessBusTime2 =
          CacheHelper.getDataToSharedPref(key: "accessBusTime2") ?? "";
      lineName2 = CacheHelper.getDataToSharedPref(key: "lineName2") ?? "";
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
            discount =
                0; // This `discount` variable is for the promo code specific logic
            totaldiscount = 0; // Reset totaldiscount if promo fails

            afterdiscount = realprice;
            afterdiscount2 = realprice2;
            Constants.showDefaultSnackBar(
                color: Colors.red,
                context: context,
                text: state.promocodemodel!.errormessage ?? ' ');
          } else if (state.promocodemodel?.status == 'success') {
            discount = state.promocodemodel!.message!
                .discount!; // This `discount` is from promo code
            totaldiscount = state.promocodemodel!.message!
                .discount!; // Override totaldiscount with promo discount

            promocodid = state.promocodemodel!.message!.promoCodeId.toString();

            Routes.PromoCodeID =
                state.promocodemodel!.message!.promoCodeId.toString();

            if (widget.tripTypeId == '2' &&
                state.promocodemodel!.message!.isPrecentage == false) {
              // This part of the logic handles if the promo code is a fixed amount
              // and needs to be split for round trip.
              // Note: This logic might conflict with the `actualDiscount` passed in widget.
              // We'll rely on the `actualDiscount` for the initial calculation.
              // This `discount` here is specifically for the promo code.
              discount = discount /
                  2; // For promotional fixed discount per trip in round trip

              Routes.discount = discount;
            }

            if (state.promocodemodel!.message!.isPrecentage == true) {
              Routes.ispercentage = true;

              minusdiscount = ((realprice) * totaldiscount) /
                  100; // Use totaldiscount from promo here
              minusdiscount2 = ((realprice2) * totaldiscount) / 100;

              afterdiscount = realprice - minusdiscount;
              afterdiscount2 = realprice2 - minusdiscount2;
            } else {
              // For fixed amount promo code, `totaldiscount` already holds the full discount.
              // We should apply it to the overall total price and then distribute.
              double currentOverallPrice = realprice + realprice2;
              if (currentOverallPrice > 0) {
                double discountFactor = totaldiscount / currentOverallPrice;
                afterdiscount = realprice * (1 - discountFactor);
                afterdiscount2 = realprice2 * (1 - discountFactor);
              } else {
                afterdiscount = 0;
                afterdiscount2 = 0;
              }
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
                                style: fontStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: FontFamily.bold),
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
                                      //   style: const fontStyle(
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
                                                intl.DateFormat('dd-MM-yyyy')
                                                    .format(DateTime.parse(
                                                        accessDate))
                                                    .toString(),
                                                style: fontStyle(
                                                    color: Colors.white,
                                                    fontFamily: FontFamily.bold,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                intl.DateFormat('hh:mm a')
                                                    .format(DateTime.parse(
                                                        accessDate))
                                                    .toString(),
                                                style: fontStyle(
                                                    color: Colors.white,
                                                    fontFamily: FontFamily.bold,
                                                    fontSize: 13.sp),
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
                                                  style: fontStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          FontFamily.bold,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  Ticketreservation
                                                      .fromcitystation1,
                                                  style: fontStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          FontFamily.bold,
                                                      fontSize: 10.sp),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  LanguageClass.isEnglish
                                                      ? "To"
                                                      : "الي",
                                                  style: fontStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          FontFamily.bold,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  Ticketreservation
                                                      .tocitystation1,
                                                  style: fontStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          FontFamily.bold,
                                                      fontSize: 10.sp),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),

                                      Text(
                                        "${Routes.curruncy ?? ""} ${realprice.toStringAsFixed(2)}",
                                        style: fontStyle(
                                            color: Colors.white,
                                            fontFamily: FontFamily.bold,
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
                                        style: fontStyle(
                                            color: Colors.white,
                                            fontFamily: FontFamily.bold,
                                            fontSize: 14.sp),
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
                                          style: fontStyle(
                                              color: AppColors.white,
                                              fontFamily: FontFamily.bold,
                                              fontSize: 14.sp),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: LanguageClass.isEnglish
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: InkWell(
                                      onTap: () {
                                        print(
                                            "Tik Tik Trip id: ${widget.tripTypeId}");
                                        if (widget.tripTypeId == '2' ||
                                            widget.tripTypeId == '1') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return BlocProvider(
                                                create: (context) =>
                                                    BusLayoutCubit(),
                                                child: BusLayoutScreen(
                                                  isedit: true,
                                                  isEditFromTicket: true,
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
                                            // Ensure price variables are updated after returning from edit screen
                                            realprice = (Ticketreservation
                                                    .countSeats1.length *
                                                Ticketreservation.priceticket1);
                                            afterdiscount = realprice;
                                            // --- RECALCULATE DISCOUNT ON RETURN ---
                                            int matchedSeats = 0;
                                            if (widget.tripTypeId == '2') {
                                              matchedSeats = (Ticketreservation
                                                          .countSeats1.length <
                                                      Ticketreservation
                                                          .countSeats2.length
                                                  ? Ticketreservation
                                                      .countSeats1.length
                                                  : Ticketreservation
                                                      .countSeats2.length);
                                            } else {
                                              matchedSeats = Ticketreservation
                                                  .countSeats1.length;
                                            }
                                            totaldiscount = (widget
                                                        .actualDiscount
                                                        ?.toDouble() ??
                                                    0.0) *
                                                matchedSeats;
                                            // --- END RECALCULATION ---

                                            if (widget.tripTypeId == '2' &&
                                                totaldiscount > 0) {
                                              double combinedRealPrice =
                                                  realprice + realprice2;
                                              if (combinedRealPrice > 0) {
                                                double discountFactor =
                                                    totaldiscount /
                                                        combinedRealPrice;
                                                afterdiscount = realprice *
                                                    (1 - discountFactor);
                                                afterdiscount2 = realprice2 *
                                                    (1 - discountFactor);
                                              } else {
                                                afterdiscount = 0;
                                                afterdiscount2 = 0;
                                              }
                                            } else if (widget.tripTypeId !=
                                                '2') {
                                              // One-way trip
                                              afterdiscount =
                                                  realprice - totaldiscount;
                                            }

                                            ihaveprocode = false;
                                            setState(() {});
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
                                          style: fontStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: FontFamily.medium,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    alignment: LanguageClass.isEnglish
                                        ? Alignment.bottomRight
                                        : Alignment.bottomLeft,
                                    child: Text(
                                      elite,
                                      style: fontStyle(
                                          fontFamily: FontFamily.bold,
                                          fontSize: 15.sp,
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
                                                      '${accessDate2 != "" ? DateTime.parse(accessDate2!).day.toString() : ""}/${accessDate2 != "" ? DateTime.parse(accessDate2!).month.toString() : ""}/${accessDate2 != "" ? DateTime.parse(accessDate2!).year.toString() : ""}',
                                                      style: fontStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              FontFamily.bold,
                                                          fontSize: 13.sp),
                                                    ),
                                                    Text(
                                                      accessDate2 != ""
                                                          ? intl.DateFormat(
                                                                  'hh:mm a')
                                                              .format(DateTime
                                                                  .parse(
                                                                      accessDate2))
                                                              .toString()
                                                          : "",
                                                      style: fontStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              FontFamily.bold,
                                                          fontSize: 13.sp),
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
                                                        style: fontStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                FontFamily.bold,
                                                            fontSize: 12.sp),
                                                      ),
                                                      Text(
                                                        Ticketreservation
                                                            .fromcitystation2,
                                                        style: fontStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                FontFamily.bold,
                                                            fontSize: 10.sp),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        LanguageClass.isEnglish
                                                            ? "To"
                                                            : "الي",
                                                        style: fontStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                FontFamily.bold,
                                                            fontSize: 12.sp),
                                                      ),
                                                      Text(
                                                        Ticketreservation
                                                            .tocitystation2,
                                                        style: fontStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            fontSize: 10.sp),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                            Text(
                                              "${Routes.curruncy ?? ""} ${realprice2.toStringAsFixed(2)}",
                                              style: fontStyle(
                                                  color: Colors.white,
                                                  fontFamily: FontFamily.medium,
                                                  fontSize: 16.sp),
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
                                              style: fontStyle(
                                                  color: Colors.white,
                                                  fontFamily: FontFamily.medium,
                                                  fontSize: 14.sp),
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
                                                style: fontStyle(
                                                    color: AppColors.white,
                                                    fontFamily:
                                                        FontFamily.medium,
                                                    fontSize: 14.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          alignment: LanguageClass.isEnglish
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
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
                                                // Recalculate prices after potential seat changes
                                                realprice2 = (Ticketreservation
                                                        .countSeats2.length *
                                                    Ticketreservation
                                                        .priceticket2);
                                                afterdiscount2 = realprice2;
                                                // --- RECALCULATE DISCOUNT ON RETURN ---
                                                int matchedSeats = 0;
                                                if (widget.tripTypeId == '2') {
                                                  matchedSeats =
                                                      (Ticketreservation
                                                                  .countSeats1
                                                                  .length <
                                                              Ticketreservation
                                                                  .countSeats2
                                                                  .length
                                                          ? Ticketreservation
                                                              .countSeats1
                                                              .length
                                                          : Ticketreservation
                                                              .countSeats2
                                                              .length);
                                                } else {
                                                  matchedSeats =
                                                      Ticketreservation
                                                          .countSeats1.length;
                                                }
                                                totaldiscount = (widget
                                                            .actualDiscount
                                                            ?.toDouble() ??
                                                        0.0) *
                                                    matchedSeats;
                                                // --- END RECALCULATION ---
                                                if (widget.tripTypeId == '2' &&
                                                    totaldiscount > 0) {
                                                  double combinedRealPrice =
                                                      realprice + realprice2;
                                                  if (combinedRealPrice > 0) {
                                                    double discountFactor =
                                                        totaldiscount /
                                                            combinedRealPrice;
                                                    afterdiscount = realprice *
                                                        (1 - discountFactor);
                                                    afterdiscount2 =
                                                        realprice2 *
                                                            (1 -
                                                                discountFactor);
                                                  } else {
                                                    afterdiscount = 0;
                                                    afterdiscount2 = 0;
                                                  }
                                                } else if (widget.tripTypeId !=
                                                    '2') {
                                                  // One-way trip
                                                  afterdiscount =
                                                      realprice - totaldiscount;
                                                }

                                                ihaveprocode = false;
                                                setState(() {});
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
                                                style: fontStyle(
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: FontFamily.medium,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: Container(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            elite2 ?? "",
                                            style: fontStyle(
                                                fontFamily: FontFamily.medium,
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
                                    style: fontStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: FontFamily.bold,
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
                                  style: fontStyle(
                                      color: Color(0xff969696),
                                      fontSize: 14,
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    hintText: LanguageClass.isEnglish
                                        ? 'Enter Promocode !'
                                        : ' كود الخصم ',
                                    hintStyle: fontStyle(
                                        color: Color(0xff969696),
                                        fontSize: 14,
                                        fontFamily: FontFamily.bold,
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
                                              final toStationId = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'toStationId');
                                              final fromStationId = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'fromStationId');

                                              final busdate = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'accessBusDate');

                                              final lineid = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'lineid');
                                              final serviceTypeID = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'serviceTypeID');

                                              final busdate2 = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'accessBusDate2');

                                              final lineid2 = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'lineid2');
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
                                              final toStationId = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'toStationId');
                                              final fromStationId = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'fromStationId');

                                              final busdate = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'accessBusDate');

                                              final lineid = CacheHelper
                                                  .getDataToSharedPref(
                                                      key: 'lineid');
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
                                          style: fontStyle(
                                              color: Colors.white,
                                              fontFamily: FontFamily.bold,
                                              height: 1.2,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              LanguageClass.isEnglish ? 'Price' : "السعر ",
                              textAlign: TextAlign.center,
                              style: fontStyle(
                                  color: Colors.black,
                                  fontFamily: FontFamily.medium,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.tripTypeId == '2'
                                  ? "  ${(realprice + realprice2).toStringAsFixed(2)} ${Routes.curruncy ?? ""}"
                                  : "  ${realprice.toStringAsFixed(2)} ${Routes.curruncy ?? ""}",
                              textAlign: TextAlign.center,
                              style: fontStyle(
                                  color: AppColors.blackColor,
                                  fontFamily: FontFamily.bold,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              LanguageClass.isEnglish ? 'Discount' : "خصم",
                              textAlign: TextAlign.center,
                              style: fontStyle(
                                  color: Colors.black,
                                  fontFamily: FontFamily.medium,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              // Display totaldiscount from the widget.actualDiscount calculation OR from the promo code calculation
                              state.promocodemodel?.status == 'success'
                                  ? state.promocodemodel!.message
                                              ?.isPrecentage ==
                                          true
                                      ? widget.tripTypeId == '2'
                                          ? "${(minusdiscount + minusdiscount2).toStringAsFixed(2)} ${Routes.curruncy ?? ""}"
                                          : "${minusdiscount.toStringAsFixed(2)} ${Routes.curruncy ?? ""}"
                                      : "${totaldiscount.toStringAsFixed(2)} ${Routes.curruncy ?? ""}"
                                  : "${(totaldiscount).toStringAsFixed(2)} ${Routes.curruncy ?? ""}", // Changed to display calculated totaldiscount
                              textAlign: TextAlign.center,
                              style: fontStyle(
                                  color: AppColors.primaryColor,
                                  fontFamily: FontFamily.medium,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              LanguageClass.isEnglish
                                  ? 'Total Price'
                                  : "السعر الكلي",
                              textAlign: TextAlign.center,
                              style: fontStyle(
                                  color: Colors.black,
                                  fontFamily: FontFamily.medium,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.tripTypeId == '2'
                                  ? "  ${(afterdiscount + afterdiscount2).toStringAsFixed(2)} ${Routes.curruncy ?? ""}"
                                  : "  ${afterdiscount.toStringAsFixed(2)} ${Routes.curruncy ?? ""}",
                              textAlign: TextAlign.center,
                              style: fontStyle(
                                  color: AppColors.blackColor,
                                  fontFamily: FontFamily.bold,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
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
                              Container(
                                padding: const EdgeInsets.all(2),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: accept
                                        ? Colors.black
                                        : Colors
                                            .transparent, // Border color changes based on selection
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      4), // Optional: rounded corners
                                ),
                                child: Checkbox(
                                    value: accept,
                                    hoverColor: Colors.black,
                                    checkColor: AppColors.primaryColor,
                                    focusColor: Colors.black,
                                    // shape: RoundedRectangleBorder(
                                    //     side: BorderSide(
                                    //         color: Colors.black,
                                    //         width: 2,
                                    //         strokeAlign: 2)),
                                    // side: BorderSide(
                                    //   color: accept
                                    //       ? Colors.black
                                    //       : Colors
                                    //           .grey, // border color when selected
                                    //   width: 2,
                                    // ),
                                    activeColor: Colors.black,
                                    fillColor:
                                        MaterialStatePropertyAll(Colors.white),
                                    onChanged: (value) {
                                      accept == false
                                          ? showAdaptiveDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext buildContext) {
                                                print(
                                                    " Tik Tik POLICY ${policy.message}");
                                                return Directionality(
                                                  textDirection:
                                                      LanguageClass.isEnglish
                                                          ? TextDirection.ltr
                                                          : TextDirection.rtl,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: Container(
                                                      color: Colors.white,
                                                      margin:
                                                          EdgeInsets.all(20),
                                                      padding:
                                                          EdgeInsets.all(30),
                                                      child: ListView(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                LanguageClass
                                                                        .isEnglish
                                                                    ? 'Terms and conditions '
                                                                    : "الشروط والأحكام",
                                                                textAlign: LanguageClass
                                                                        .isEnglish
                                                                    ? TextAlign
                                                                        .left
                                                                    : TextAlign
                                                                        .right,
                                                                textDirection: LanguageClass
                                                                        .isEnglish
                                                                    ? TextDirection
                                                                        .ltr
                                                                    : TextDirection
                                                                        .rtl,
                                                                style:
                                                                    fontStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .cancel_outlined)),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        0),
                                                            child: ListView
                                                                .builder(
                                                              itemCount: policy
                                                                      .message
                                                                      ?.length ??
                                                                  0,
                                                              shrinkWrap: true,
                                                              physics:
                                                                  ScrollPhysics(),
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return policy
                                                                        .message![
                                                                            index]
                                                                        .contains(
                                                                            "div")
                                                                    ? Html(
                                                                        data: policy
                                                                            .message![index])
                                                                    : Text(
                                                                        "${index + 1} - ${policy.message![index]}",
                                                                        textAlign: LanguageClass.isEnglish
                                                                            ? TextAlign.left
                                                                            : TextAlign.right,
                                                                        textDirection: LanguageClass.isEnglish
                                                                            ? TextDirection.ltr
                                                                            : TextDirection.rtl,
                                                                        style:
                                                                            fontStyle(
                                                                          color:
                                                                              Color(0xff818181),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              FontFamily.medium,
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
                                                              setState(() {
                                                                accept = value!;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            30),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    LanguageClass
                                                                            .isEnglish
                                                                        ? "Done"
                                                                        : 'تم',
                                                                    style: fontStyle(
                                                                        fontFamily:
                                                                            FontFamily
                                                                                .medium,
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
                                                  MaterialLocalizations.of(
                                                          context)
                                                      .modalBarrierDismissLabel,
                                              barrierColor:
                                                  Colors.black.withOpacity(0.5),
                                            )
                                          : setState(() {
                                              accept = value!;
                                            });
                                    }),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 6.0),
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? 'Accept reservation policy'
                                      : 'قبول سياسة الحجز',
                                  style: fontStyle(
                                      fontFamily: FontFamily.medium,
                                      color: Colors.black,
                                      fontSize: 14),
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: accept
                                ? () {
                                    Routes.resrvedtrips.clear();
                                    if (widget.tripTypeId == '2') {
                                      final toStationId =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'toStationId');
                                      final fromStationId =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'fromStationId');

                                      final busdate =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'accessBusDate');

                                      final lineid =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'lineid');
                                      final serviceTypeID =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'serviceTypeID');

                                      final busdate2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'accessBusDate2');

                                      final lineid2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'lineid2');
                                      final serviceTypeID2 =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'serviceTypeID2');

                                      TripReservationList trip =
                                          TripReservationList(
                                              busId: Ticketreservation.busid1,
                                              discount: totaldiscount
                                                  .toString(), // Use totaldiscount here
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
                                              discount: totaldiscount
                                                  .toString(), // Use totaldiscount here
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
                                                  discount: totaldiscount
                                                      .toString(), // Pass totaldiscount
                                                  promcodeid: promocodid,
                                                  user: Routes.user),
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      final toStationId =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'toStationId');
                                      final fromStationId =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'fromStationId');
                                      final busdate =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'accessBusDate');

                                      final lineid =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'lineid');
                                      final serviceTypeID =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'serviceTypeID');

                                      TripReservationList trip =
                                          TripReservationList(
                                              busId: Ticketreservation.busid1,
                                              discount:
                                                  (totaldiscount) // Use totaldiscount
                                                      .toString(),
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
                                                  discount:
                                                      (totaldiscount) // Use totaldiscount
                                                          .toString(),
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
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
      bottomNavigationBar: UmraDetails.isbusforumra
          ? SizedBox()
          : Navigationbottombar(
              currentIndex: 0,
            ),
    );
  }
}
