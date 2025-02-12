import 'dart:developer';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:indexed/indexed.dart';
import 'package:intl/intl.dart' as intl;
import 'package:printing/printing.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/hex_color.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/Screens/Enter_trip_data.dart';
import 'package:swa/features/Swa_umra/Screens/umra_reservation_screen/2_acomidation_screen.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/Transportaion_list_model.dart';
import 'package:swa/features/Swa_umra/models/campainlistmodel.dart';
import 'package:swa/features/Swa_umra/models/page_model.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/Swa_umra/models/umral_trip_model.dart';
import 'package:swa/features/Swa_umra/repository/Umra_repository.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/features/home/presentation/cubit/home_cubit.dart';
import 'package:swa/features/home/presentation/screens/home.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/my_home.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/payment/fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';

class TransportationScreen extends StatefulWidget {
  int typeid, selectedpackage;
  int? umrahReservationID;

  TransportationScreen(
      {super.key,
      required this.selectedpackage,
      required this.typeid,
      this.umrahReservationID});

  @override
  State<TransportationScreen> createState() => _TransportationScreenState();
}

class _TransportationScreenState extends State<TransportationScreen> {
  final UmraBloc _umraBloc = UmraBloc();

  int selectedpackage = 0;
  List<ListElement>? listcampains = [];

  int inn = 0;
  int suggestedindex = 0;
  bool isSuggested = false;

  List<TransportationsSeats> reservedseats = [];

  TransportationListModel? transportationListModel;

  List<TransportList>? transportList = [];
  List<TransportList>? transportSuggestedList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedpackage = widget.selectedpackage;
    _umraBloc.add(GetCompainListEvent());

    _umraBloc.add(GetTransportationEvent(
        tripUmrahID: widget.typeid, reservationID: widget.umrahReservationID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener(
          bloc: _umraBloc,
          listener: (context, UmraState state) {
            if (state.campainlistmodel?.status == "success") {
              listcampains = state.campainlistmodel!.message!.list;
            } else if (state.transportationListModel?.status == "success") {
              transportationListModel = state.transportationListModel;
              transportList =
                  state.transportationListModel!.message!.transportList;
              transportSuggestedList = state
                  .transportationListModel!.message!.transportSuggestedList;
              if (widget.umrahReservationID != null) {
                for (int i = 0; i < transportList!.length; i++) {
                  if (transportList![i].isreserved == true) {
                    BusLayoutRepo(apiConsumer: (sl()))
                        .getReservationSeatsData(
                            reservationID: transportList![i].reservationId!)
                        .then((value) async {
                      log(value.message.mySeatListId.toString());
                      reservedseats.add(TransportationsSeats(
                          tripid: transportList![i].tripId!,
                          seatsnumber: value.message.mySeatListId,
                          totalprice: value.message.mySeatListId.length *
                              transportList![i].priceSeat));
                      setState(() {});
                    });
                  }
                }
                for (int i = 0; i < transportSuggestedList!.length; i++) {
                  if (transportSuggestedList![i].isreserved == true) {
                    BusLayoutRepo(apiConsumer: (sl()))
                        .getReservationSeatsData(
                            reservationID:
                                transportSuggestedList![i].reservationId!)
                        .then((value) async {
                      log(value.message.mySeatListId.toString());
                      reservedseats.add(TransportationsSeats(
                          tripid: transportSuggestedList![i].tripId!,
                          seatsnumber: value.message.mySeatListId,
                          totalprice: value.message.mySeatListId.length *
                              transportSuggestedList![i].priceSeat));
                      setState(() {});
                    });
                  }
                }
              }
            } else if (state.seatsmodel?.status == "success") {
              List selectedseats = [];

              var product = isSuggested
                  ? reservedseats.firstWhere(
                      (product) =>
                          product.tripid ==
                          transportSuggestedList![suggestedindex].tripId,
                      orElse: () => TransportationsSeats(
                            tripid: 0,
                            seatsnumber: [],
                            totalprice: 0,
                          ))
                  : reservedseats.firstWhere(
                      (product) => product.tripid == transportList![inn].tripId,
                      orElse: () => TransportationsSeats(
                          tripid: 0, seatsnumber: [], totalprice: 0));

              if (product.seatsnumber != []) {
                selectedseats = product.seatsnumber;
              }
              showDialog(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.5),
                  useRootNavigator: true,
                  builder: (context) {
                    return StatefulBuilder(builder: (buildContext,
                        StateSetter setStater /*You can rename this!*/) {
                      return AlertDialog(
                          backgroundColor: Color(0xffF5F5F5),
                          insetPadding: EdgeInsets.all(20),
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60.w,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '${selectedseats.length} ${LanguageClass.isEnglish ? 'seats' : 'مقاعد'}',
                                            style: fontStyle(
                                              color: Colors.black,
                                              fontFamily: FontFamily.regular,
                                              fontSize: 17.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      6.horizontalSpace,
                                      Container(
                                          width: 47.w,
                                          child: DottedLine(
                                            dashLength: 1,
                                            dashColor: Color(0xff707070),
                                          )),
                                      6.horizontalSpace,
                                      Container(
                                        width: 70.w,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            isSuggested
                                                ? '${selectedseats.length * transportSuggestedList![suggestedindex].priceSeat} ${Routes.curruncy}'
                                                : '${selectedseats.length * transportList![inn].priceSeat} ${Routes.curruncy}',
                                            style: fontStyle(
                                              color: Colors.black,
                                              fontFamily: FontFamily.regular,
                                              fontSize: 17.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      InkWell(
                                        onTap: () {
                                          if (isSuggested) {
                                            if (selectedseats.isNotEmpty) {
                                              transportList!.add(
                                                  transportSuggestedList![
                                                      suggestedindex]);
                                              transportSuggestedList!
                                                  .removeAt(suggestedindex);

                                              if (reservedseats
                                                      .firstWhere(
                                                          (product) =>
                                                              product.tripid ==
                                                              transportList!
                                                                  .last.tripId,
                                                          orElse: () =>
                                                              TransportationsSeats(
                                                                  tripid: 0,
                                                                  seatsnumber: [],
                                                                  totalprice:
                                                                      0))
                                                      .tripid ==
                                                  transportList!.last.tripId) {
                                                reservedseats
                                                        .firstWhere(
                                                          (product) =>
                                                              product.tripid ==
                                                              transportList!
                                                                  .last.tripId,
                                                        )
                                                        .seatsnumber =
                                                    selectedseats;

                                                reservedseats
                                                        .firstWhere(
                                                          (product) =>
                                                              product.tripid ==
                                                              transportList!
                                                                  .last.tripId,
                                                        )
                                                        .totalprice =
                                                    selectedseats.length *
                                                        transportList!
                                                            .last.priceSeat;
                                              } else {
                                                reservedseats
                                                    .add(TransportationsSeats(
                                                  seatsnumber: selectedseats,
                                                  totalprice:
                                                      (selectedseats.length *
                                                          transportList!
                                                              .last.priceSeat),
                                                  tripid: transportList!
                                                      .last.tripId!,
                                                ));
                                              }
                                            }
                                          } else {
                                            if (reservedseats
                                                    .firstWhere(
                                                        (product) =>
                                                            product.tripid ==
                                                            transportList![inn]
                                                                .tripId,
                                                        orElse: () =>
                                                            TransportationsSeats(
                                                                tripid: 0,
                                                                seatsnumber: [],
                                                                totalprice: 0))
                                                    .tripid ==
                                                transportList![inn].tripId) {
                                              reservedseats
                                                  .firstWhere(
                                                    (product) =>
                                                        product.tripid ==
                                                        transportList![inn]
                                                            .tripId,
                                                  )
                                                  .seatsnumber = selectedseats;

                                              reservedseats
                                                  .firstWhere(
                                                    (product) =>
                                                        product.tripid ==
                                                        transportList![inn]
                                                            .tripId,
                                                  )
                                                  .totalprice = selectedseats
                                                      .length *
                                                  transportList![inn].priceSeat;
                                            } else {
                                              reservedseats
                                                  .add(TransportationsSeats(
                                                seatsnumber: selectedseats,
                                                totalprice:
                                                    (selectedseats.length *
                                                        transportList![inn]
                                                            .priceSeat),
                                                tripid:
                                                    transportList![inn].tripId!,
                                              ));
                                            }
                                          }

                                          print(
                                              reservedseats.length.toString());

                                          Navigator.pop(context);
                                          HapticFeedback.heavyImpact();
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.umragold,
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 0),
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 14,
                                                  spreadRadius: 0)
                                            ],
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          child: Text(
                                            LanguageClass.isEnglish
                                                ? 'Done'
                                                : 'تم',
                                            style: fontStyle(
                                              color: Colors.white,
                                              fontFamily: FontFamily.regular,
                                              fontSize: 17.sp,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Flexible(
                                    child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0.w, vertical: 10.h),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15),
                                              child: SvgPicture.asset(
                                                'assets/images/busfront.svg',
                                                fit: BoxFit.fitWidth,
                                              )),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25),
                                              child: SvgPicture.asset(
                                                'assets/images/backbus.svg',
                                                fit: BoxFit.fitWidth,
                                              )),
                                        ),
                                        Positioned(
                                          top: 130,
                                          bottom: 15.h,
                                          left: 10,
                                          right: 10,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 33),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                for (int index = 0;
                                                    index <
                                                        state
                                                            .seatsmodel!
                                                            .message!
                                                            .busDetailsVm!
                                                            .totalRow!;
                                                    index++)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      for (int i = 0;
                                                          i <
                                                              state
                                                                  .seatsmodel!
                                                                  .message!
                                                                  .busDetailsVm!
                                                                  .totalColumn!;
                                                          i++)
                                                        Expanded(
                                                          child: state
                                                                      .seatsmodel!
                                                                      .message!
                                                                      .busDetailsVm!
                                                                      .rowList![
                                                                          index]
                                                                      .seats[i]
                                                                      .isAvailable ==
                                                                  true
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    if (state.seatsmodel!.message!.busDetailsVm!.rowList![index].seats[i].isReserved ==
                                                                            false ||
                                                                        selectedseats.contains(state.seatsmodel!.message!.busDetailsVm!.rowList![index].seats[i].seatBusID) &&
                                                                            state.seatsmodel!.message!.busDetailsVm!.rowList![index].seats[i].isAvailable ==
                                                                                true) {
                                                                      if (selectedseats.contains(state
                                                                          .seatsmodel!
                                                                          .message!
                                                                          .busDetailsVm!
                                                                          .rowList![
                                                                              index]
                                                                          .seats[
                                                                              i]
                                                                          .seatBusID)) {
                                                                        selectedseats.remove(state
                                                                            .seatsmodel!
                                                                            .message!
                                                                            .busDetailsVm!
                                                                            .rowList![index]
                                                                            .seats[i]
                                                                            .seatBusID);
                                                                      } else {
                                                                        if (reservedseats.isNotEmpty &&
                                                                            transportationListModel!.message!.sameSeatCount ==
                                                                                true) {
                                                                          if (reservedseats
                                                                              .every(
                                                                            (element) {
                                                                              return element.seatsnumber.length == selectedseats.length;
                                                                            },
                                                                          )) {
                                                                            log('message');
                                                                          } else {
                                                                            selectedseats.add(state.seatsmodel!.message!.busDetailsVm!.rowList![index].seats[i].seatBusID);
                                                                          }
                                                                        } else {
                                                                          selectedseats.add(state
                                                                              .seatsmodel!
                                                                              .message!
                                                                              .busDetailsVm!
                                                                              .rowList![index]
                                                                              .seats[i]
                                                                              .seatBusID);
                                                                        }
                                                                      }

                                                                      setStater(
                                                                          () {});
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: double
                                                                        .infinity,
                                                                    height: (MediaQuery.of(context).size.height *
                                                                            0.49) /
                                                                        state
                                                                            .seatsmodel!
                                                                            .message!
                                                                            .busDetailsVm!
                                                                            .totalRow!,
                                                                    margin: EdgeInsets
                                                                        .all(1),
                                                                    child:
                                                                        Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      children: [
                                                                        SvgPicture
                                                                            .asset(
                                                                          'assets/images/busseat.svg',
                                                                          alignment:
                                                                              Alignment.center,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          color: selectedseats.contains(state.seatsmodel!.message!.busDetailsVm!.rowList![index].seats[i].seatBusID)
                                                                              ? Color(0xffB55BCB)
                                                                              : state.seatsmodel!.message!.busDetailsVm!.rowList![index].seats[i].isAvailable! && !state.seatsmodel!.message!.busDetailsVm!.rowList![index].seats[i].isReserved!
                                                                                  ? AppColors.umragold
                                                                                  : null,
                                                                        ),
                                                                        FittedBox(
                                                                          fit: BoxFit
                                                                              .contain,
                                                                          child:
                                                                              Text(
                                                                            state.seatsmodel!.message!.busDetailsVm!.rowList![index].seats[i].seatNo.toString(),
                                                                            style: fontStyle(
                                                                                color: state.seatsmodel!.message!.busDetailsVm!.rowList![index].seats[i].isReserved == false || selectedseats.contains(state.seatsmodel!.message!.busDetailsVm!.rowList![index].seats[i].seatBusID) ? Colors.white : Colors.black,
                                                                                fontSize: 13,
                                                                                fontFamily: FontFamily.bold,
                                                                                fontWeight: FontWeight.w600),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              : SizedBox(),
                                                        )
                                                    ],
                                                  )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                              ]));
                    });
                  });
            }
          },
          child: BlocBuilder(
              bloc: _umraBloc,
              builder: (context, UmraState state) {
                if (state.isloading == true) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.umragold,
                    ),
                  );
                } else {
                  return SafeArea(
                      bottom: false,
                      child: Directionality(
                        textDirection: LanguageClass.isEnglish
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        child: Column(
                          children: [
                            10.verticalSpace,
                            Container(
                                margin: EdgeInsets.only(
                                    left: LanguageClass.isEnglish ? 55 : 0,
                                    right: LanguageClass.isEnglish ? 0 : 55),
                                alignment: LanguageClass.isEnglish
                                    ? Alignment.topLeft
                                    : Alignment.topRight,
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? 'Packages'
                                      : 'الحملات',
                                  style: fontStyle(
                                      fontSize: 24.sp,
                                      color: Colors.black,
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                                width: double.infinity,
                                height: 50,
                                child: ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  scrollDirection: Axis.horizontal,
                                  physics: ScrollPhysics(),
                                  children: [
                                    Indexer(
                                        alignment: Alignment.centerLeft,
                                        reversed: true,
                                        children: List.generate(
                                            listcampains!.length,
                                            (index) => Indexed(
                                                  index: index,
                                                  key: UniqueKey(),
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: AnimatedContainer(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              selectedpackage ==
                                                                      index
                                                                  ? 30
                                                                  : 5,
                                                          right: 5),
                                                      margin: EdgeInsets.only(
                                                          left: index * 80),
                                                      decoration: BoxDecoration(
                                                          boxShadow:
                                                              selectedpackage ==
                                                                      index
                                                                  ? [
                                                                      BoxShadow(
                                                                          offset: Offset(4,
                                                                              0),
                                                                          color: Colors.black.withOpacity(
                                                                              0.4),
                                                                          blurRadius:
                                                                              4,
                                                                          spreadRadius:
                                                                              0)
                                                                    ]
                                                                  : [
                                                                      BoxShadow(
                                                                          offset: Offset(4,
                                                                              0),
                                                                          color: Colors.black.withOpacity(
                                                                              0.2),
                                                                          blurRadius:
                                                                              2,
                                                                          spreadRadius:
                                                                              0)
                                                                    ],
                                                          color: HexColor(
                                                              listcampains![
                                                                          index]
                                                                      .bgColor ??
                                                                  '#AEAEAE'),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      13)),
                                                      width: selectedpackage ==
                                                              index
                                                          ? 148
                                                          : 100,
                                                      height: 47,
                                                      duration: Duration(
                                                          microseconds: 100),
                                                      curve: Curves.linear,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                              child: Text(
                                                                listcampains![
                                                                        index]
                                                                    .name!,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: fontStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .bold,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )).toList()),
                                  ],
                                )),
                            10.verticalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      child: Container(
                                    width: 27,
                                    height: 27,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 2,
                                            color: AppColors.umragold),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: AppColors.umragold,
                                          border: Border.all(
                                              color: AppColors.umragold),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: AppColors.umragold,
                                    ),
                                  )),
                                  Container(
                                      child: transportationListModel
                                                      ?.message!.isRequired ==
                                                  true &&
                                              reservedseats.isEmpty
                                          ? Container(
                                              width: 27,
                                              height: 27,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffC6C6C6),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                            )
                                          : Container(
                                              width: 27,
                                              height: 27,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      width: 2,
                                                      color:
                                                          AppColors.umragold),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Container(
                                                width: 15,
                                                height: 15,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: AppColors.umragold,
                                                    border: Border.all(
                                                        color:
                                                            AppColors.umragold),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                              ),
                                            )),
                                  Expanded(
                                      child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: Color(0xffC6C6C6),
                                    ),
                                  )),
                                  Container(
                                    child: Container(
                                      width: 27,
                                      height: 27,
                                      decoration: BoxDecoration(
                                          color: Color(0xffC6C6C6),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: Color(0xffC6C6C6),
                                    ),
                                  )),
                                  Container(
                                    child: Container(
                                      width: 27,
                                      height: 27,
                                      decoration: BoxDecoration(
                                          color: Color(0xffC6C6C6),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: Color(0xffC6C6C6),
                                    ),
                                  )),
                                  Container(
                                    child: Container(
                                      width: 27,
                                      height: 27,
                                      decoration: BoxDecoration(
                                          color: Color(0xffC6C6C6),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            6.verticalSpace,
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          LanguageClass.isEnglish
                                              ? 'Packages'
                                              : 'الحملات',
                                          textAlign: TextAlign.center,
                                          style: fontStyle(
                                              fontFamily: FontFamily.bold,
                                              fontSize: 9.sp,
                                              height: 1.2,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        LanguageClass.isEnglish
                                            ? 'Transportation'
                                            : 'الانتقالات',
                                        textAlign: TextAlign.center,
                                        style: fontStyle(
                                            fontFamily: FontFamily.bold,
                                            fontSize: 9.sp,
                                            height: 1.2,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        LanguageClass.isEnglish
                                            ? 'Accommodation'
                                            : 'الإقامة',
                                        textAlign: TextAlign.center,
                                        style: fontStyle(
                                            fontFamily: FontFamily.bold,
                                            fontSize: 9.sp,
                                            height: 1.2,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            LanguageClass.isEnglish
                                                ? 'Program'
                                                : 'البرنامج',
                                            textAlign: TextAlign.center,
                                            style: fontStyle(
                                                fontFamily: FontFamily.bold,
                                                fontSize: 9.sp,
                                                height: 1.2,
                                                color: Colors.black),
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        LanguageClass.isEnglish
                                            ? 'Reservation'
                                            : "الحجز",
                                        textAlign: TextAlign.center,
                                        style: fontStyle(
                                            fontFamily: FontFamily.bold,
                                            fontSize: 9.sp,
                                            height: 1.2,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Column(
                                  children: [
                                    20.verticalSpace,
                                    transportList?.isEmpty == true
                                        ? Center(
                                            child: Text(
                                              LanguageClass.isEnglish
                                                  ? 'No Transportation'
                                                  : 'لا يوجد انتقالات',
                                              style: fontStyle(
                                                  fontFamily: FontFamily.bold,
                                                  fontSize: 16.sp,
                                                  height: 1.2,
                                                  color: Colors.black),
                                            ),
                                          )
                                        : Flexible(
                                            child: ListView.builder(
                                              itemCount: transportList!.length,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              physics: ScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return transportList![index]
                                                        .isActive!
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            top: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                isSuggested =
                                                                    false;
                                                                inn = index;
                                                                _umraBloc.add(GetSeatsEvent(
                                                                    tripId: transportList![
                                                                            index]
                                                                        .tripId));
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: 25,
                                                                    height: 25,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            2,
                                                                        vertical:
                                                                            4),
                                                                    decoration: BoxDecoration(
                                                                        color: reservedseats
                                                                                .firstWhere((element) {
                                                                                  return element.tripid == transportList![index].tripId;
                                                                                }, orElse: () => TransportationsSeats(seatsnumber: [], totalprice: 0, tripid: 0))
                                                                                .seatsnumber
                                                                                .isNotEmpty
                                                                            ? AppColors.umragold
                                                                            : Color(0xff707070),
                                                                        borderRadius: BorderRadius.circular(4)),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            'assets/images/seats.svg'),
                                                                  ),
                                                                  7.horizontalSpace,
                                                                  reservedseats
                                                                          .firstWhere(
                                                                              (element) {
                                                                            return element.tripid ==
                                                                                transportList![index].tripId;
                                                                          }, orElse: () => TransportationsSeats(seatsnumber: [], totalprice: 0, tripid: 0))
                                                                          .seatsnumber
                                                                          .isNotEmpty
                                                                      ? Text(
                                                                          reservedseats
                                                                              .firstWhere((element) {
                                                                                return element.tripid == transportList![index].tripId;
                                                                              }, orElse: () => TransportationsSeats(seatsnumber: [], totalprice: 0, tripid: 0))
                                                                              .seatsnumber
                                                                              .length
                                                                              .toString(),
                                                                          style: fontStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 17.sp,
                                                                              fontWeight: FontWeight.normal,
                                                                              fontFamily: FontFamily.medium),
                                                                        )
                                                                      : SizedBox(),
                                                                  Text(
                                                                    LanguageClass
                                                                            .isEnglish
                                                                        ? 'Seats'
                                                                        : 'مقاعد',
                                                                    style: fontStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize: 17
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontFamily:
                                                                            FontFamily.medium),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            18.horizontalSpace,
                                                            Expanded(
                                                              child: Transform
                                                                  .flip(
                                                                flipX: index
                                                                    .isEven,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: transportList![index].from ==
                                                                              null
                                                                          ? const SizedBox()
                                                                          : Transform
                                                                              .flip(
                                                                              flipX: index.isEven,
                                                                              child: Container(
                                                                                height: 20.h,
                                                                                child: ListView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  shrinkWrap: true,
                                                                                  physics: ScrollPhysics(),
                                                                                  padding: EdgeInsets.zero,
                                                                                  children: [
                                                                                    Text(
                                                                                      transportList![index].from!,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: fontStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w500, fontFamily: FontFamily.medium),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                    ),
                                                                    16.horizontalSpace,
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Image
                                                                          .asset(
                                                                              'assets/images/longarrow.png'),
                                                                    ),
                                                                    16.horizontalSpace,
                                                                    Expanded(
                                                                      child: transportList![index].to ==
                                                                              null
                                                                          ? const SizedBox()
                                                                          : Transform
                                                                              .flip(
                                                                              flipX: index.isEven,
                                                                              child: Container(
                                                                                height: 20.h,
                                                                                child: ListView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  shrinkWrap: true,
                                                                                  children: [
                                                                                    Text(
                                                                                      transportList![index].to!,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: fontStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w500, fontFamily: FontFamily.medium),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            16.horizontalSpace,
                                                            Text(
                                                              transportList![
                                                                      index]
                                                                  .tripDate!,
                                                              style: fontStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      17.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox();
                                              },
                                            ),
                                          ),
                                    15.verticalSpace,
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: DottedLine(
                                        dashColor: Color(0xff707070),
                                      ),
                                    ),
                                    15.verticalSpace,
                                    transportList?.isEmpty == true
                                        ? 0.verticalSpace
                                        : Container(
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.w),
                                            child: Container(
                                              child: Text(
                                                "${reservedseats.length > 0 ? reservedseats.map((item) => item.totalprice).reduce((a, b) => a + b) : '0.0'} ${Routes.curruncy}",
                                                style: fontStyle(
                                                    color: Colors.black,
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        FontFamily.medium),
                                              ),
                                            ),
                                          ),
                                    15.verticalSpace,
                                    transportSuggestedList?.isEmpty == true
                                        ? SizedBox()
                                        : Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              LanguageClass.isEnglish
                                                  ? 'Suggested Rides'
                                                  : "الرحلات المقترحة",
                                              style: fontStyle(
                                                  color: Colors.black,
                                                  fontSize: 25.sp,
                                                  fontFamily: FontFamily.medium,
                                                  height: 1.2,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                    15.verticalSpace,
                                    transportSuggestedList?.isEmpty == true
                                        ? SizedBox()
                                        : Expanded(
                                            child: Scrollbar(
                                              key: UniqueKey(),
                                              thickness: 10,
                                              trackVisibility: true,
                                              scrollbarOrientation:
                                                  ScrollbarOrientation.right,
                                              radius: Radius.circular(10),
                                              child: ListView.builder(
                                                controller: ScrollController(),
                                                itemCount:
                                                    transportSuggestedList!
                                                        .length,
                                                shrinkWrap: true,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                physics: ScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return transportSuggestedList![
                                                              index]
                                                          .isActive!
                                                      ? Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 15),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  isSuggested =
                                                                      true;
                                                                  suggestedindex =
                                                                      index;
                                                                  _umraBloc.add(
                                                                      GetSeatsEvent(
                                                                          tripId:
                                                                              transportSuggestedList![index].tripId));
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      width: 25,
                                                                      height:
                                                                          25,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              2,
                                                                          vertical:
                                                                              4),
                                                                      decoration: BoxDecoration(
                                                                          color: reservedseats
                                                                                  .firstWhere((element) {
                                                                                    return element.tripid == transportSuggestedList![index].tripId;
                                                                                  }, orElse: () => TransportationsSeats(seatsnumber: [], totalprice: 0, tripid: 0))
                                                                                  .seatsnumber
                                                                                  .isNotEmpty
                                                                              ? AppColors.umragold
                                                                              : Color(0xff707070),
                                                                          borderRadius: BorderRadius.circular(4)),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              'assets/images/seats.svg'),
                                                                    ),
                                                                    7.horizontalSpace,
                                                                    reservedseats
                                                                            .firstWhere((element) {
                                                                              return element.tripid == transportSuggestedList![index].tripId;
                                                                            }, orElse: () => TransportationsSeats(seatsnumber: [], totalprice: 0, tripid: 0))
                                                                            .seatsnumber
                                                                            .isNotEmpty
                                                                        ? Text(
                                                                            reservedseats
                                                                                .firstWhere((element) {
                                                                                  return element.tripid == transportSuggestedList![index].tripId;
                                                                                }, orElse: () => TransportationsSeats(seatsnumber: [], totalprice: 0, tripid: 0))
                                                                                .seatsnumber
                                                                                .length
                                                                                .toString(),
                                                                            style: fontStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 17.sp,
                                                                                fontWeight: FontWeight.normal,
                                                                                fontFamily: FontFamily.medium),
                                                                          )
                                                                        : SizedBox(),
                                                                    Text(
                                                                      LanguageClass
                                                                              .isEnglish
                                                                          ? 'Seats'
                                                                          : 'مقاعد',
                                                                      style: fontStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize: 17
                                                                              .sp,
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          fontFamily:
                                                                              FontFamily.medium),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              18.horizontalSpace,
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  height: 17,
                                                                  child:
                                                                      ListView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    shrinkWrap:
                                                                        true,
                                                                    children: [
                                                                      Text(
                                                                        transportSuggestedList![index].from ??
                                                                            ' ',
                                                                        style: fontStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 14.sp,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontFamily: FontFamily.medium),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              16.horizontalSpace,
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Image.asset(
                                                                    'assets/images/longarrow.png'),
                                                              ),
                                                              16.horizontalSpace,
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  height: 17.h,
                                                                  child:
                                                                      ListView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    shrinkWrap:
                                                                        true,
                                                                    children: [
                                                                      Text(
                                                                        transportSuggestedList![index].to ??
                                                                            ' ',
                                                                        style: fontStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 14.sp,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontFamily: FontFamily.medium),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              16.horizontalSpace,
                                                              Text(
                                                                transportSuggestedList![
                                                                        index]
                                                                    .tripDate!,
                                                                style: fontStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        17.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .medium),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox();
                                                },
                                              ),
                                            ),
                                          ),
                                    SizedBox(height: 10.h),
                                    InkWell(
                                      onTap: () {
                                        UmraDetails.isbusforumra = true;
                                        UmraDetails.swatransportList = [];
                                        UmraDetails.Swabusreservedseats = [];
                                        showDialog(
                                            context: context,
                                            barrierColor:
                                                Colors.black.withOpacity(0.5),
                                            useRootNavigator: true,
                                            builder: (context) {
                                              return StatefulBuilder(builder:
                                                  (buildContext,
                                                      StateSetter
                                                          setStater /*You can rename this!*/) {
                                                return AlertDialog(
                                                    insetPadding:
                                                        EdgeInsets.all(10.w),
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                    content: Container(
                                                      width: double.infinity,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.8,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white),
                                                      child: MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider<
                                                                LoginCubit>(
                                                              create: (context) =>
                                                                  sl<LoginCubit>(),
                                                            ),
                                                            BlocProvider<
                                                                PackagesBloc>(
                                                              create: (context) =>
                                                                  PackagesBloc(),
                                                            ),
                                                            BlocProvider<
                                                                FawryReservation>(
                                                              create: (context) =>
                                                                  sl<FawryReservation>(),
                                                            ),
                                                            BlocProvider<
                                                                GetAvailableCountriesCubit>(
                                                              create: (context) =>
                                                                  sl<GetAvailableCountriesCubit>(),
                                                            ),
                                                            BlocProvider<
                                                                HomeCubit>(
                                                              create: (context) =>
                                                                  sl<HomeCubit>(),
                                                            ),
                                                            BlocProvider<
                                                                    TimesTripsCubit>(
                                                                create: (context) =>
                                                                    sl<TimesTripsCubit>()),
                                                            BlocProvider<
                                                                    TicketCubit>(
                                                                create: (context) =>
                                                                    sl<TicketCubit>()),
                                                          ],
                                                          child: MyHome()),
                                                    ));
                                              });
                                            }).then((value) {
                                          if (UmraDetails.swatransportList!
                                                      .isNotEmpty ==
                                                  true &&
                                              UmraDetails.Swabusreservedseats
                                                  .isNotEmpty) {
                                            transportList!.addAll(
                                                UmraDetails.swatransportList!);

                                            reservedseats.addAll(UmraDetails
                                                .Swabusreservedseats);
                                          }

                                          setState(() {});
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        alignment: Alignment.centerLeft,
                                        child: InkWell(
                                          child: Container(
                                            width: 100.w,
                                            height: 37.h,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Color(0xffFF5D4B),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  LanguageClass.isEnglish
                                                      ? '+ More'
                                                      : 'المزيد +',
                                                  style: fontStyle(
                                                      color: Colors.white,
                                                      fontSize: 18.sp,
                                                      fontFamily:
                                                          FontFamily.bold,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 20.w),
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 70,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.w, vertical: 2.h),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Color(0xffecb959),
                                          borderRadius:
                                              BorderRadius.circular(41)),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          LanguageClass.isEnglish
                                              ? "previous"
                                              : 'السابق',
                                          style: fontStyle(
                                              fontFamily: FontFamily.bold,
                                              fontSize: 18.sp,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: transportationListModel
                                                    ?.message!.isRequired ==
                                                true &&
                                            reservedseats.isEmpty
                                        ? () {}
                                        : () {
                                            UmraDetails.transportList = [];
                                            UmraDetails.reservedseats = [];
                                            UmraDetails.transportList!
                                                .addAll(transportList!);
                                            UmraDetails.reservedseats
                                                .addAll(reservedseats);

                                            if (transportationListModel!
                                                        .message!
                                                        .sameSeatCount ==
                                                    true &&
                                                reservedseats.isNotEmpty) {
                                              int numberbookedseats =
                                                  reservedseats
                                                      .first.seatsnumber.length;

                                              if (transportList!.length ==
                                                      reservedseats.length &&
                                                  reservedseats.every(
                                                    (element) {
                                                      return element.seatsnumber
                                                              .length ==
                                                          numberbookedseats;
                                                    },
                                                  )) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AccomidationScreen(
                                                                umrahReservationID:
                                                                    widget
                                                                        .umrahReservationID,
                                                                selectedpackage:
                                                                    selectedpackage,
                                                                typeid: widget
                                                                    .typeid)));
                                              } else {
                                                Constants.showDefaultSnackBar(
                                                    context: context,
                                                    text: LanguageClass
                                                            .isEnglish
                                                        ? 'select the same number of seats on all trips'
                                                        : 'اختر نفس عدد المقاعد في جميع الرحلات');
                                              }
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AccomidationScreen(
                                                              umrahReservationID:
                                                                  widget
                                                                      .umrahReservationID,
                                                              selectedpackage:
                                                                  selectedpackage,
                                                              typeid: widget
                                                                  .typeid)));
                                            }
                                          },
                                    child: Container(
                                      height: 35,
                                      width: 70,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: transportationListModel
                                                          ?.message!
                                                          .isRequired ==
                                                      true &&
                                                  reservedseats.isEmpty
                                              ? Color(0xffC3C3C3)
                                              : Color(0xffecb959),
                                          borderRadius:
                                              BorderRadius.circular(41)),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          LanguageClass.isEnglish
                                              ? "Next"
                                              : 'التالي',
                                          style: fontStyle(
                                              fontFamily: FontFamily.bold,
                                              fontSize: 18.sp,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                }
              }),
        ),
        bottomNavigationBar: Navigationbottombar(
          currentIndex: 0,
        ));
  }
}
