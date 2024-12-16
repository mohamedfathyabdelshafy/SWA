import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/Container_Widget.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/text_widget.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
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

class ReservationbackTicket extends StatefulWidget {
  ReservationbackTicket(
      {super.key,
      required this.countSeates,
      required this.seatsnumbers,
      required this.busId,
      required this.tripTypeId,
      required this.to,
      required this.from,
      required this.tocity,
      required this.fromcity,
      required this.oneTripId,
      this.countSeats2,
      required this.price,
      this.user});
  List<num> countSeates;
  List<num> seatsnumbers;

  int busId;
  String tripTypeId;
  String from;
  String to;
  String fromcity;
  String tocity;
  int oneTripId;
  List<dynamic>? countSeats2;
  double price;
  User? user;

  @override
  State<ReservationbackTicket> createState() => _ReservationbackTicketState();
}

class _ReservationbackTicketState extends State<ReservationbackTicket> {
  bool switch1 = false;
  bool accept = false;
  int numberTrip = 0;
  String elite = "";
  String accessBusTime = "";
  TextEditingController _promocodetext = new TextEditingController();
  String accessDate = '';
  String lineName = "";
  ReservationRepo reservationCubit = ReservationRepo(apiConsumer: sl());
  Policyticketmodel policy = Policyticketmodel();
  int? numberTrip2;
  String? elite2;
  String? accessBusTime2;
  String? lineName2;
  double discount = 0;
  String promocodid = '';
  bool ihaveprocode = false;
  double afterdiscount = 0;

  PackagesBloc _packagesBloc = new PackagesBloc();

  @override
  void initState() {
    afterdiscount = (widget.countSeates.length * widget.price);

    discount = Routes.discount;
    if (Routes.ispercentage == true) {
      var minusdiscount = (afterdiscount * discount) / 100;

      afterdiscount = afterdiscount - minusdiscount;
    } else {
      afterdiscount = afterdiscount - discount;
    }

    log(afterdiscount.toString());

    Future.delayed(const Duration(seconds: 0)).then((_) async {
      BlocProvider.of<LoginCubit>(context).getUserData();
      policy = await reservationCubit.getpolicy();
    });

    numberTrip = CacheHelper.getDataToSharedPref(key: 'numberTrip2');
    elite = CacheHelper.getDataToSharedPref(key: "elite2");
    accessDate = CacheHelper.getDataToSharedPref(key: "accessBusDate2");
    accessBusTime = CacheHelper.getDataToSharedPref(key: "accessBusTime2");
    lineName = CacheHelper.getDataToSharedPref(key: "lineName2");

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
        listener: (context, PackagesState state) {},
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
                          child: Text(
                            LanguageClass.isEnglish ? "Ticket" : "تذكرتك",
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 38,
                                fontWeight: FontWeight.w500,
                                fontFamily: "roman"),
                          ),
                        ),
                        SizedBox(
                          height: sizeHeight * 0.01,
                        ),
                        Container(
                          height: 230,
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
                                      Text(
                                        LanguageClass.isEnglish
                                            ? "Departure "
                                            : "تغادر في",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "bold",
                                            fontSize: 23),
                                      ),
                                      Text(
                                        '${DateTime.parse(accessDate).day.toString()}/${DateTime.parse(accessDate).month.toString()}/${DateTime.parse(accessDate).year.toString()}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "roman",
                                            fontSize: 14),
                                      ),
                                      SizedBox(
                                        height: 17,
                                      ),
                                      Expanded(
                                          child: Row(
                                        children: [
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
                                          Column(
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
                                                    fontFamily: "roman",
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                widget.from,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "bold",
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                widget.fromcity,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "roman",
                                                    fontSize: 12),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                LanguageClass.isEnglish
                                                    ? "To"
                                                    : "الي",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "roman",
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                widget.to,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "bold",
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                widget.tocity,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "roman",
                                                    fontSize: 12),
                                              ),
                                            ],
                                          )
                                        ],
                                      ))
                                    ],
                                  )),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${Routes.curruncy} $afterdiscount",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: "bold",
                                        fontSize: 18),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.watch_later_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        accessBusTime,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "roman",
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
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
                                            fontFamily: "roman",
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Container(
                                          width: 70,
                                          child: Wrap(
                                            direction: Axis.horizontal,
                                            children: [
                                              for (int i = 0;
                                                  i <
                                                      widget
                                                          .seatsnumbers.length;
                                                  i++)
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Container(
                                                      child: Text(
                                                        ' ${widget.seatsnumbers[i].toString()} ,',
                                                        style: TextStyle(
                                                            color:
                                                                AppColors.white,
                                                            fontFamily: "bold",
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                            ],
                                          ))
                                    ],
                                  ),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      elite,
                                      style: TextStyle(
                                          fontFamily: "bold",
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                Routes.ispercentage == true
                                    ? "$discount %"
                                    : "$discount ${Routes.curruncy}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.primaryColor,
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "  $afterdiscount ${Routes.curruncy}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.blackColor,
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
                                    showGeneralDialog(
                                      context: context,
                                      pageBuilder: (context,
                                          Animation<double> animation,
                                          Animation<double>
                                              secondaryAnimation) {
                                        return Container(
                                          color: Colors.transparent,
                                          margin: EdgeInsets.all(50),
                                          child: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: Colors.white)),
                                            child: Material(
                                              color: Colors.grey,
                                              child: Scrollbar(
                                                thumbVisibility: true,
                                                child: ListView(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: ListView.builder(
                                                        itemCount: policy
                                                            .message!.length,
                                                        shrinkWrap: true,
                                                        physics:
                                                            ScrollPhysics(),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Text(
                                                            "${index + 1}- ${policy.message![index]}",
                                                            textAlign:
                                                                TextAlign.right,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .blackColor,
                                                                fontSize: 16),
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
                                                                  horizontal:
                                                                      30),
                                                          padding:
                                                              EdgeInsets.all(
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
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )),
                                                    )
                                                    // Padding(
                                                    //   padding: const EdgeInsets.symmetric(horizontal: 40),
                                                    //   child: ElevatedButton(
                                                    //
                                                    //       onPressed: () {
                                                    //         Navigator.pop(context);
                                                    //       },
                                                    //       child: Text(LanguageClass.isEnglish
                                                    //           ? "Done"
                                                    //           : 'تم',
                                                    //       style: TextStyle(color: Colors.black),)),
                                                    // )
                                                  ],
                                                ),
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
                                      transitionDuration:
                                          const Duration(milliseconds: 200),
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
                                    color: Colors.black, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: accept
                                ? () {
                                    if (widget.user == null) {
                                      Navigator.pushNamed(
                                          context, Routes.signInRoute);
                                    } else {
                                      log(Routes.resrvedtrips.length
                                          .toString());
                                      CacheHelper.setDataToSharedPref(
                                        key: 'price',
                                        value: afterdiscount,
                                      );

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
                                              key: 'accessBusDate2');

                                      final lineid =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'lineid2');
                                      final busid =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'busId2');
                                      final serviceTypeID =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'serviceTypeID2');

                                      TripReservationList trip =
                                          TripReservationList(
                                              busId: busid,
                                              discount: discount.toString(),
                                              fromStationId: toStationId,
                                              lineId: lineid,
                                              price: afterdiscount,
                                              seatIds: widget.countSeates,
                                              serviceTypeId: serviceTypeID,
                                              toStationId: fromStationId,
                                              tripDate:
                                                  DateTime.parse(accessDate),
                                              tripId: int.parse(tripRoundId));

                                      Routes.resrvedtrips.add(trip);

                                      log(Routes.resrvedtrips.length
                                          .toString());
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
                                                user: widget.user),
                                          ),
                                        ),
                                      );
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
                            )),
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
