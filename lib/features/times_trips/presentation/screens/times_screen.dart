import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/timer.dart';
import 'package:swa/features/Swa_umra/models/Transportaion_list_model.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Ticket_class.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/bus_layout.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/bus_layout_back.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/reservation_ticket.dart';
import 'package:swa/features/home/presentation/screens/tabs/my_home.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/sign_in/presentation/screens/login.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';
import '../../../../core/local_cache_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';
import '../../../sign_in/domain/entities/user.dart';
import '../../data/models/TimesTripsResponsedart.dart';

// ignore: must_be_immutable
class TimesScreen extends StatefulWidget {
  TimesScreen({
    super.key,
    required this.tripList,
    required this.tripTypeId,
    this.tripListBack,
  });
  List<TripList> tripList;
  List<TripList>? tripListBack;
  String tripTypeId;
  @override
  State<TimesScreen> createState() => _TimesScreenState();
}

class _TimesScreenState extends State<TimesScreen> {
  int selected = -1;
  int selectedback = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Reservationtimer.stoptimer();

    Reservationtimer.start = 120;
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: sizeHeight * 0.08,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);

                  Reservationtimer.stoptimer();
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
            SizedBox(
              height: sizeHeight * 0.01,
            ),
            Image.asset(
              "assets/images/applogo.png",
              height: sizeHeight * 0.06,
              width: sizeWidth * 0.06,
            ),
            SizedBox(
              height: sizeHeight * 0.015,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                LanguageClass.isEnglish ? "Go trips" : "رحلات الذهاب",
                textAlign:
                    LanguageClass.isEnglish ? TextAlign.left : TextAlign.right,
                style: fontStyle(
                    color: Colors.black,
                    fontFamily: FontFamily.medium,
                    fontSize: 16.sp),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Ticketreservation.Seatsnumbers1.isNotEmpty
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primaryColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LanguageClass.isEnglish
                                        ? "Departure "
                                        : "تغادر في",
                                    style: fontStyle(
                                        color: Colors.white,
                                        fontFamily: FontFamily.bold,
                                        fontSize: 18.sp),
                                  ),
                                  Text(
                                    '${DateTime.parse(Ticketreservation.accessDate1).day.toString()}/${DateTime.parse(Ticketreservation.accessDate1).month.toString()}/${DateTime.parse(Ticketreservation.accessDate1).year.toString()}',
                                    style: fontStyle(
                                        color: Colors.white,
                                        fontFamily: FontFamily.medium,
                                        fontSize: 14.sp),
                                  ),
                                  SizedBox(
                                    height: 17,
                                  ),
                                  Flexible(
                                      fit: FlexFit.loose,
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
                                                style: fontStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        FontFamily.medium,
                                                    fontSize: 12.sp),
                                              ),
                                              Text(
                                                Ticketreservation
                                                    .fromcitystation1,
                                                style: fontStyle(
                                                    color: Colors.white,
                                                    fontFamily: FontFamily.bold,
                                                    fontSize: 14.sp),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                LanguageClass.isEnglish
                                                    ? "To"
                                                    : "الي",
                                                style: fontStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        FontFamily.medium,
                                                    fontSize: 12.sp),
                                              ),
                                              Text(
                                                Ticketreservation
                                                    .tocitystation1,
                                                style: fontStyle(
                                                    color: Colors.white,
                                                    fontFamily: FontFamily.bold,
                                                    fontSize: 14.sp),
                                              ),
                                            ],
                                          )
                                        ],
                                      ))
                                ],
                              )),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${Routes.curruncy} ${(Ticketreservation.countSeats1.length * Ticketreservation.priceticket1)}",
                                    style: fontStyle(
                                        color: Colors.white,
                                        fontFamily: FontFamily.bold,
                                        fontSize: 16.sp),
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
                                        Ticketreservation.accessBusTime1,
                                        style: fontStyle(
                                            color: Colors.white,
                                            fontFamily: FontFamily.medium,
                                            fontSize: 14.sp),
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
                                        Ticketreservation.numbertrip1
                                            .toString(),
                                        style: fontStyle(
                                            color: Colors.white,
                                            fontFamily: FontFamily.medium,
                                            fontSize: 14.sp),
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
                                                      Ticketreservation
                                                          .Seatsnumbers1.length;
                                                  i++)
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Container(
                                                      child: Text(
                                                        ' ${Ticketreservation.Seatsnumbers1[i].toString()} ,',
                                                        style: fontStyle(
                                                            color:
                                                                AppColors.white,
                                                            fontFamily:
                                                                FontFamily.bold,
                                                            fontSize: 12.sp),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                            ],
                                          ))
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
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
                                                    .priceticket1!,
                                                user: Routes.user,
                                                tripId:
                                                    Ticketreservation.tripid1,
                                                tocity:
                                                    Ticketreservation.tocity1 ??
                                                        '',
                                                fromcity: Ticketreservation
                                                        .fromcity2 ??
                                                    '',
                                              ),
                                            );
                                          }),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
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
                                      Ticketreservation.elite1,
                                      style: fontStyle(
                                          fontFamily: FontFamily.bold,
                                          fontSize: 14.sp,
                                          color: Color(0xfff7f8f9)),
                                    ),
                                  ))
                                ],
                              ))
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: widget.tripList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selected == index
                                      ? selected = -1
                                      : selected = index;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.primaryColor),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10.0),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              intl.DateFormat('dd-MM-yyyy')
                                                  .format(widget.tripList[index]
                                                      .accessDate)
                                                  .toString(),
                                              style: fontStyle(
                                                  color: Colors.white,
                                                  fontFamily: FontFamily.medium,
                                                  fontSize: 13.sp),
                                            ),
                                            Text(
                                              intl.DateFormat('hh:mm a')
                                                  .format(widget.tripList[index]
                                                      .accessDate)
                                                  .toString(),
                                              style: fontStyle(
                                                  color: Colors.white,
                                                  fontFamily: FontFamily.medium,
                                                  fontSize: 13.sp),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          height: 80.sp,
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
                                        Flexible(
                                          flex: 2,
                                          fit: FlexFit.tight,
                                          child: Container(
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
                                                          FontFamily.medium,
                                                      fontSize: 12.sp),
                                                ),
                                                Text(
                                                  widget.tripList[index].from,
                                                  style: fontStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          FontFamily.medium,
                                                      fontSize: 12.sp),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  LanguageClass.isEnglish
                                                      ? "To"
                                                      : "الي",
                                                  style: fontStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          FontFamily.medium,
                                                      fontSize: 12.sp),
                                                ),
                                                Text(
                                                  widget.tripList[index].to,
                                                  style: fontStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          FontFamily.medium,
                                                      fontSize: 12.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '${widget.tripList[index].price.toString()} ${Routes.curruncy}' ??
                                                      '',
                                                  style: fontStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          FontFamily.medium,
                                                      fontSize: 12.sp),
                                                ),
                                                Text(
                                                  LanguageClass.isEnglish
                                                      ? 'available ${widget.tripList[index].emptySeat}'
                                                      : 'متاح  ${widget.tripList[index].emptySeat}',
                                                  style: fontStyle(
                                                      color: AppColors.yellow2,
                                                      fontFamily:
                                                          FontFamily.medium,
                                                      fontSize: 13.sp),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      // if (Routes.user == null) {
                                                      //   Constants.showDefaultSnackBar(
                                                      //       color: Colors.red,
                                                      //       context: context,
                                                      //       text: LanguageClass.isEnglish
                                                      //           ? 'Login first'
                                                      //           : ' سجل الدخول أولا');

                                                      //   Navigator.push(
                                                      //       context,
                                                      //       MaterialPageRoute(
                                                      //         builder: (context) =>
                                                      //             MultiBlocProvider(
                                                      //           providers: [
                                                      //             BlocProvider<
                                                      //                 LoginCubit>(
                                                      //               create: (context) =>
                                                      //                   sl<LoginCubit>(),
                                                      //             ),
                                                      //           ],
                                                      //           child: LoginScreen(
                                                      //             isback: true,
                                                      //           ),
                                                      //         ),
                                                      //       ));
                                                      // } else {
                                                      CacheHelper
                                                          .setDataToSharedPref(
                                                              key: 'numberTrip',
                                                              value: widget
                                                                  .tripList[
                                                                      index]
                                                                  .tripNumber);
                                                      CacheHelper
                                                          .setDataToSharedPref(
                                                              key: 'elite',
                                                              value: widget
                                                                  .tripList[
                                                                      index]
                                                                  .serviceType);
                                                      CacheHelper
                                                          .setDataToSharedPref(
                                                              key:
                                                                  'accessBusTime',
                                                              value: widget
                                                                  .tripList[
                                                                      index]
                                                                  .accessBusTime);
                                                      CacheHelper
                                                          .setDataToSharedPref(
                                                              key:
                                                                  'accessBusDate',
                                                              value: widget
                                                                  .tripList[
                                                                      index]
                                                                  .accessDate
                                                                  .toString());
                                                      CacheHelper
                                                          .setDataToSharedPref(
                                                              key: 'lineName',
                                                              value: widget
                                                                  .tripList[
                                                                      index]
                                                                  .lineName);
                                                      CacheHelper
                                                          .setDataToSharedPref(
                                                              key: 'tripOneId',
                                                              value: widget
                                                                      .tripList[
                                                                          index]
                                                                      .tripId ??
                                                                  0);

                                                      CacheHelper
                                                          .setDataToSharedPref(
                                                              key: 'lineid',
                                                              value: widget
                                                                      .tripList[
                                                                          index]
                                                                      .lineId ??
                                                                  0);

                                                      CacheHelper.setDataToSharedPref(
                                                          key: 'serviceTypeID',
                                                          value: widget
                                                                  .tripList[
                                                                      index]
                                                                  .serviceTypeId ??
                                                              0);

                                                      CacheHelper
                                                          .setDataToSharedPref(
                                                              key: 'busId',
                                                              value: widget
                                                                      .tripList[
                                                                          index]
                                                                      .busId ??
                                                                  0);
                                                      print(
                                                          " widget.tripList[index].tripId${widget.tripList[index].tripId}");
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                          return BlocProvider(
                                                            create: (context) =>
                                                                BusLayoutCubit(),
                                                            child:
                                                                BusLayoutScreen(
                                                              isedit: false,
                                                              busdate: widget
                                                                  .tripList[
                                                                      index]
                                                                  .accessDate,
                                                              busttime: widget
                                                                  .tripList[
                                                                      index]
                                                                  .accessBusTime,
                                                              to: widget
                                                                      .tripList[
                                                                          index]
                                                                      .to ??
                                                                  "",
                                                              from: widget
                                                                      .tripList[
                                                                          index]
                                                                      .from ??
                                                                  "",
                                                              triTypeId: widget
                                                                  .tripTypeId,
                                                              tripListBack: widget
                                                                  .tripListBack,
                                                              price: widget
                                                                  .tripList[
                                                                      index]
                                                                  .price!,
                                                              user: Routes.user,
                                                              tripId: widget
                                                                  .tripList[
                                                                      index]
                                                                  .tripId!,
                                                              tocity: widget
                                                                      .tripList[
                                                                          index]
                                                                      .toCityName ??
                                                                  '',
                                                              fromcity: widget
                                                                      .tripList[
                                                                          index]
                                                                      .fromCityName ??
                                                                  '',
                                                            ),
                                                          );
                                                        }),
                                                      ).then((value) {
                                                        setState(() {});
                                                      });

                                                      UmraDetails.swatransportList!.add(TransportList(
                                                          availability: widget
                                                              .tripList[index]
                                                              .emptySeat,
                                                          busId: widget
                                                              .tripList[index]
                                                              .busId,
                                                          from: widget
                                                              .tripList[index]
                                                              .fromCityName,
                                                          fromStationName:
                                                              widget
                                                                  .tripList[
                                                                      index]
                                                                  .from,
                                                          to: widget
                                                              .tripList[index]
                                                              .toCityName,
                                                          isActive: true,
                                                          isDelete: widget
                                                              .tripList[index]
                                                              .isDeleted,
                                                          isAddedTrip: true,
                                                          lineId: widget
                                                              .tripList[index]
                                                              .lineId,
                                                          notes: '',
                                                          priceSeat: widget
                                                              .tripList[index]
                                                              .price,
                                                          toStationName: widget
                                                              .tripList[index]
                                                              .to,
                                                          tripDate:
                                                              '${intl.DateFormat.d('en_US').format(widget.tripList[index].accessDate)}${intl.DateFormat.MMM('en_US').format(widget.tripList[index].accessDate)}',
                                                          isreserved: false,
                                                          tripId: widget
                                                              .tripList[index]
                                                              .tripId,
                                                          personCountReserved:
                                                              0,
                                                          serviceTypeId: widget
                                                              .tripList[index]
                                                              .serviceTypeId,
                                                          tripTime: widget
                                                              .tripList[index]
                                                              .accessBusTime
                                                              .toString(),
                                                          fromStationId: null,
                                                          toStationId: null,
                                                          tripUmrahTransportationId:
                                                              null,
                                                          reservationId: null));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 5),
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: AppColors
                                                                    .white,
                                                                offset: Offset(
                                                                    0, 0),
                                                                spreadRadius: 0,
                                                                blurRadius: 15)
                                                          ],
                                                          color:
                                                              AppColors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: Text(
                                                        LanguageClass.isEnglish
                                                            ? 'Reserve'
                                                            : 'حجز',
                                                        style: fontStyle(
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontSize: 10.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            selected == index
                                ? Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: ListView.builder(
                                      itemCount: widget
                                          .tripList[index].lineCity.length,
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index2) {
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.black26))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${widget.tripList[index].lineCity[index2].cityName}' ??
                                                    '',
                                                style: fontStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontFamily: FontFamily.bold,
                                                    fontSize: 16.sp),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  showGeneralDialog(
                                                      context: context,
                                                      pageBuilder: (BuildContext
                                                              buildContext,
                                                          Animation<double>
                                                              animation,
                                                          Animation<double>
                                                              secondaryAnimation) {
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                setStater) {
                                                          return Material(
                                                            color: Colors
                                                                .transparent,
                                                            child:
                                                                Directionality(
                                                              textDirection: LanguageClass
                                                                      .isEnglish
                                                                  ? TextDirection
                                                                      .ltr
                                                                  : TextDirection
                                                                      .rtl,
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            25,
                                                                        vertical:
                                                                            50),
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius: BorderRadius.only(
                                                                        bottomLeft:
                                                                            Radius.circular(
                                                                                20),
                                                                        bottomRight:
                                                                            Radius.circular(20))),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            30,
                                                                        vertical:
                                                                            5),
                                                                width: double
                                                                    .infinity,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                        height:
                                                                            15),
                                                                    Container(
                                                                      alignment: LanguageClass.isEnglish
                                                                          ? Alignment
                                                                              .topLeft
                                                                          : Alignment
                                                                              .topRight,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .arrow_back_rounded,
                                                                          color:
                                                                              AppColors.primaryColor,
                                                                          size:
                                                                              35,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              20),
                                                                      child:
                                                                          Text(
                                                                        LanguageClass.isEnglish
                                                                            ? "Access Points"
                                                                            : "نقط التجمع",
                                                                        style: fontStyle(
                                                                            color:
                                                                                AppColors.blackColor,
                                                                            fontSize: 28.sp,
                                                                            fontWeight: FontWeight.w600,
                                                                            fontFamily: FontFamily.medium),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Expanded(
                                                                      child: ListView.separated(
                                                                          itemBuilder: (context, index3) {
                                                                            return Container(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                    child: Text(
                                                                                      '${widget.tripList[index].lineCity[index2].lineStationList[index3].stationName}' ?? '',
                                                                                      style: fontStyle(color: AppColors.primaryColor, fontFamily: FontFamily.bold, fontSize: 14.sp),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                    child: Text(
                                                                                      '${widget.tripList[index].lineCity[index2].lineStationList[index3].accessTime.substring(0, 5)}' ?? '',
                                                                                      style: fontStyle(color: AppColors.primaryColor, fontFamily: FontFamily.bold, fontSize: 14.sp),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },
                                                                          separatorBuilder: (context, index) {
                                                                            return Divider(
                                                                              color: Colors.black,
                                                                            );
                                                                          },
                                                                          physics: ScrollPhysics(),
                                                                          shrinkWrap: true,
                                                                          itemCount: widget.tripList[index].lineCity[index2].lineStationList.length ?? 0),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                          ;
                                                        });
                                                      });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.primaryColor,
                                                  elevation: 4,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      LanguageClass.isEnglish
                                                          ? "Points"
                                                          : "نقط التجمع",
                                                      style: fontStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18.sp,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_circle_right_rounded,
                                                      color: AppColors.white,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : SizedBox()
                          ],
                        );
                      }),
            ),
            widget.tripTypeId == '2'
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      LanguageClass.isEnglish ? "Back trips" : "رحلات العودة",
                      textAlign: LanguageClass.isEnglish
                          ? TextAlign.left
                          : TextAlign.right,
                      style: fontStyle(
                          color: Colors.black,
                          fontFamily: FontFamily.medium,
                          fontSize: 16.sp),
                    ),
                  )
                : SizedBox(),
            widget.tripTypeId == '2'
                ? Flexible(
                    fit: FlexFit.loose,
                    child: Ticketreservation.Seatsnumbers2.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            padding: EdgeInsets.all(15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.primaryColor),
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
                                        Text(
                                          LanguageClass.isEnglish
                                              ? "Departure "
                                              : "تغادر في",
                                          style: fontStyle(
                                              color: Colors.white,
                                              fontFamily: FontFamily.bold,
                                              fontSize: 18.sp),
                                        ),
                                        Text(
                                          '${DateTime.parse(Ticketreservation.accessDate2).day.toString()}/${DateTime.parse(Ticketreservation.accessDate2).month.toString()}/${DateTime.parse(Ticketreservation.accessDate2).year.toString()}',
                                          style: fontStyle(
                                              color: Colors.white,
                                              fontFamily: FontFamily.medium,
                                              fontSize: 14.sp),
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
                                                      begin:
                                                          Alignment.topCenter,
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
                                                  style: fontStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          FontFamily.medium,
                                                      fontSize: 12.sp),
                                                ),
                                                Text(
                                                  Ticketreservation
                                                      .fromcitystation2,
                                                  style: fontStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          FontFamily.bold,
                                                      fontSize: 16.sp),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  LanguageClass.isEnglish
                                                      ? "To"
                                                      : "الي",
                                                  style: fontStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          FontFamily.medium,
                                                      fontSize: 12.sp),
                                                ),
                                                Text(
                                                  Ticketreservation
                                                      .tocitystation2,
                                                  style: fontStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          FontFamily.bold,
                                                      fontSize: 16.sp),
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
                                      "${Routes.curruncy} ${Ticketreservation.countSeats2.length * Ticketreservation.priceticket2}",
                                      style: fontStyle(
                                          color: Colors.white,
                                          fontFamily: FontFamily.bold,
                                          fontSize: 16.sp),
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
                                          Ticketreservation.accessBusTime2,
                                          style: fontStyle(
                                              color: Colors.white,
                                              fontFamily: FontFamily.medium,
                                              fontSize: 14.sp),
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
                                          Ticketreservation.numbertrip2
                                              .toString(),
                                          style: fontStyle(
                                              color: Colors.white,
                                              fontFamily: FontFamily.medium,
                                              fontSize: 14.sp),
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
                                                        Ticketreservation
                                                            .Seatsnumbers2
                                                            .length;
                                                    i++)
                                                  Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: Container(
                                                        child: Text(
                                                          ' ${Ticketreservation.Seatsnumbers2[i].toString()} ,',
                                                          style: fontStyle(
                                                              color: AppColors
                                                                  .white,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .bold,
                                                              fontSize: 12.sp),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ))
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.center,
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
                                                          triTypeId:
                                                              widget.tripTypeId,
                                                          price:
                                                              Ticketreservation
                                                                  .priceticket2,
                                                          user: Routes.user,
                                                          tripId:
                                                              Ticketreservation
                                                                  .tripid2,
                                                          tocity:
                                                              Ticketreservation
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
                                            setState(() {});
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
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
                                        Ticketreservation.elite2,
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
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: widget.tripListBack!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedback == index
                                            ? selectedback = -1
                                            : selectedback = index;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: AppColors.primaryColor),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10.0),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      intl.DateFormat(
                                                              'dd-MM-yyyy')
                                                          .format(widget
                                                              .tripListBack![
                                                                  index]
                                                              .accessDate)
                                                          .toString(),
                                                      style: fontStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontSize: 13.sp),
                                                    ),
                                                    Text(
                                                      intl.DateFormat('hh:mm a')
                                                          .format(widget
                                                              .tripListBack![
                                                                  index]
                                                              .accessDate)
                                                          .toString(),
                                                      style: fontStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontSize: 14.sp),
                                                    ),
                                                  ]),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                height: 80.sp,
                                                width: 5,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
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
                                              Flexible(
                                                flex: 2,
                                                fit: FlexFit.tight,
                                                child: Container(
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
                                                                FontFamily
                                                                    .medium,
                                                            fontSize: 12.sp),
                                                      ),
                                                      Text(
                                                        widget
                                                            .tripListBack![
                                                                index]
                                                            .from,
                                                        style: fontStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            fontSize: 12.sp),
                                                      ),
                                                      Text(
                                                        LanguageClass.isEnglish
                                                            ? "To"
                                                            : "الي",
                                                        style: fontStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            fontSize: 12.sp),
                                                      ),
                                                      Text(
                                                        widget
                                                            .tripListBack![
                                                                index]
                                                            .to,
                                                        style: fontStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            fontSize: 12.sp),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '${widget.tripListBack![index].price.toString()} ${Routes.curruncy}' ??
                                                            '',
                                                        style: fontStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            fontSize: 12.sp),
                                                      ),
                                                      Text(
                                                        LanguageClass.isEnglish
                                                            ? 'available ${widget.tripListBack![index].emptySeat ?? ''}'
                                                            : 'متاح ${widget.tripListBack![index].emptySeat ?? ''}',
                                                        style: fontStyle(
                                                            color: AppColors
                                                                .yellow2,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            fontSize: 12.sp),
                                                      ),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: InkWell(
                                                          onTap: () {
                                                            CacheHelper.setDataToSharedPref(
                                                                key:
                                                                    'numberTrip2',
                                                                value: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .tripNumber);
                                                            CacheHelper.setDataToSharedPref(
                                                                key: 'elite2',
                                                                value: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .serviceType);
                                                            CacheHelper.setDataToSharedPref(
                                                                key:
                                                                    'accessBusDate2',
                                                                value: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .accessDate
                                                                    .toString());
                                                            CacheHelper.setDataToSharedPref(
                                                                key:
                                                                    'accessBusTime2',
                                                                value: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .accessBusTime);
                                                            CacheHelper.setDataToSharedPref(
                                                                key:
                                                                    'lineName2',
                                                                value: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .lineName);
                                                            CacheHelper.setDataToSharedPref(
                                                                key:
                                                                    'tripOneId',
                                                                value: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .tripId ??
                                                                    0);

                                                            CacheHelper.setDataToSharedPref(
                                                                key:
                                                                    'tripRoundId',
                                                                value: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .tripId
                                                                    .toString());

                                                            CacheHelper.setDataToSharedPref(
                                                                key: 'lineid2',
                                                                value: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .lineId ??
                                                                    0);

                                                            CacheHelper.setDataToSharedPref(
                                                                key:
                                                                    'serviceTypeID2',
                                                                value: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .serviceTypeId ??
                                                                    0);

                                                            CacheHelper.setDataToSharedPref(
                                                                key: 'busId2',
                                                                value: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .busId ??
                                                                    0);

                                                            UmraDetails.swatransportList!.add(TransportList(
                                                                availability: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .emptySeat,
                                                                busId: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .busId,
                                                                from: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .fromCityName,
                                                                fromStationName:
                                                                    widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .from,
                                                                to: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .toCityName,
                                                                isActive: true,
                                                                isDelete: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .isDeleted,
                                                                isAddedTrip:
                                                                    true,
                                                                lineId: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .lineId,
                                                                notes: '',
                                                                priceSeat: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .price,
                                                                toStationName:
                                                                    widget
                                                                        .tripListBack![index]
                                                                        .to,
                                                                tripDate: '${intl.DateFormat.d('en_US').format(widget.tripListBack![index].accessDate)}${intl.DateFormat.MMM('en_US').format(widget.tripListBack![index].accessDate)}',
                                                                isreserved: false,
                                                                tripId: widget.tripListBack![index].tripId,
                                                                personCountReserved: 0,
                                                                serviceTypeId: widget.tripListBack![index].serviceTypeId,
                                                                tripTime: widget.tripListBack![index].accessBusTime.toString(),
                                                                fromStationId: null,
                                                                toStationId: null,
                                                                tripUmrahTransportationId: null,
                                                                reservationId: null));

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      MultiBlocProvider(
                                                                          providers: [
                                                                            BlocProvider<LoginCubit>(create: (context) => sl<LoginCubit>()),
                                                                            BlocProvider<TimesTripsCubit>(
                                                                              create: (context) => TimesTripsCubit(),
                                                                            ),
                                                                            BlocProvider<BusLayoutCubit>(
                                                                              create: (context) => BusLayoutCubit(),
                                                                            )
                                                                          ],
                                                                          // Replace with your actual cubit creation logic
                                                                          child:
                                                                              BusLayoutScreenBack(
                                                                            isedit:
                                                                                false,
                                                                            busdate:
                                                                                widget.tripListBack![index].accessDate,
                                                                            busttime:
                                                                                widget.tripListBack![index].accessBusTime,
                                                                            to: widget.tripListBack![index].to ??
                                                                                "",
                                                                            from:
                                                                                widget.tripListBack![index].from ?? "",
                                                                            triTypeId:
                                                                                widget.tripTypeId,
                                                                            price:
                                                                                widget.tripListBack![index].price!,
                                                                            user:
                                                                                Routes.user,
                                                                            tripId:
                                                                                widget.tripListBack![index].tripId!,
                                                                            tocity:
                                                                                widget.tripListBack![index].toCityName ?? '',
                                                                            fromcity:
                                                                                widget.tripListBack![index].fromCityName ?? '',
                                                                          ))),
                                                            ).then((value) {
                                                              setState(() {});
                                                            });
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: AppColors
                                                                          .white,
                                                                      offset:
                                                                          Offset(0,
                                                                              0),
                                                                      spreadRadius:
                                                                          0,
                                                                      blurRadius:
                                                                          15)
                                                                ],
                                                                color: AppColors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12)),
                                                            child: Text(
                                                              LanguageClass
                                                                      .isEnglish
                                                                  ? 'Reserve'
                                                                  : 'حجز',
                                                              style: fontStyle(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .medium,
                                                                fontSize: 10.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  selectedback == index
                                      ? Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: ListView.builder(
                                            itemCount: widget
                                                .tripListBack![index]
                                                .lineCity
                                                .length,
                                            shrinkWrap: true,
                                            physics: ScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index2) {
                                              return Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .black26))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${widget.tripListBack![index].lineCity[index2].cityName}' ??
                                                          '',
                                                      style: fontStyle(
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontFamily:
                                                              FontFamily.bold,
                                                          fontSize: 16.sp),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        showGeneralDialog(
                                                            context: context,
                                                            pageBuilder: (BuildContext
                                                                    buildContext,
                                                                Animation<
                                                                        double>
                                                                    animation,
                                                                Animation<
                                                                        double>
                                                                    secondaryAnimation) {
                                                              return StatefulBuilder(
                                                                  builder: (context,
                                                                      setStater) {
                                                                return Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      Directionality(
                                                                    textDirection: LanguageClass.isEnglish
                                                                        ? TextDirection
                                                                            .ltr
                                                                        : TextDirection
                                                                            .rtl,
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              25,
                                                                          vertical:
                                                                              50),
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.only(
                                                                              bottomLeft: Radius.circular(20),
                                                                              bottomRight: Radius.circular(20))),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              30,
                                                                          vertical:
                                                                              5),
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                              height: 15),
                                                                          Container(
                                                                            alignment: LanguageClass.isEnglish
                                                                                ? Alignment.topLeft
                                                                                : Alignment.topRight,
                                                                            child:
                                                                                InkWell(
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
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.symmetric(horizontal: 20),
                                                                            child:
                                                                                Text(
                                                                              LanguageClass.isEnglish ? "Access Points" : "نقط التجمع",
                                                                              style: fontStyle(color: AppColors.blackColor, fontSize: 28.sp, fontWeight: FontWeight.w600, fontFamily: FontFamily.medium),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          Expanded(
                                                                            child: ListView.separated(
                                                                                itemBuilder: (context, index3) {
                                                                                  return Container(
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                          child: Text(
                                                                                            '${widget.tripListBack![index].lineCity[index2].lineStationList[index3].stationName}' ?? '',
                                                                                            style: fontStyle(color: AppColors.primaryColor, fontFamily: FontFamily.bold, fontSize: 14.sp),
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                          child: Text(
                                                                                            '${widget.tripListBack![index].lineCity[index2].lineStationList[index3].accessTime.substring(0, 5)}' ?? '',
                                                                                            style: fontStyle(color: AppColors.primaryColor, fontFamily: FontFamily.bold, fontSize: 14.sp),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                },
                                                                                separatorBuilder: (context, index) {
                                                                                  return Divider(
                                                                                    color: Colors.black,
                                                                                  );
                                                                                },
                                                                                physics: ScrollPhysics(),
                                                                                shrinkWrap: true,
                                                                                itemCount: widget.tripListBack![index].lineCity[index2].lineStationList.length ?? 0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                                ;
                                                              });
                                                            });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            AppColors
                                                                .primaryColor,
                                                        elevation: 4,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            LanguageClass
                                                                    .isEnglish
                                                                ? "Points"
                                                                : "نقط التجمع",
                                                            style: fontStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18.sp,
                                                              color: AppColors
                                                                  .white,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .arrow_circle_right_rounded,
                                                            color:
                                                                AppColors.white,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              );
                            }),
                  )
                : SizedBox(),
            Ticketreservation.Seatsnumbers2.isNotEmpty &&
                    Ticketreservation.Seatsnumbers1.isNotEmpty
                ? InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider<LoginCubit>(
                              create: (context) => sl<LoginCubit>(),
                              child: ReservationTicket(
                                tripListBack: widget.tripListBack,
                                tripTypeId: widget.tripTypeId,
                                user: Routes.user,
                              )),
                        ),
                      );
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      alignment: Alignment.centerRight,
                      height: 50,
                      //padding:  EdgeInsets.symmetric(horizontal: 10,vertical:20),
                      //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(41)),
                      child: Center(
                        child: Text(
                          LanguageClass.isEnglish ? "Continue" : "استمر",
                          style: fontStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 20.sp),
                        ),
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
      bottomNavigationBar: UmraDetails.isbusforumra
          ? SizedBox()
          : Navigationbottombar(
              currentIndex: 0,
            ),
    );
  }
}
