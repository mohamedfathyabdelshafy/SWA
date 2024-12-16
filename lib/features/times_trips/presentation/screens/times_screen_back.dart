import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/bus_layout_back.dart';
import 'package:swa/features/home/presentation/screens/tabs/my_home.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/local_cache_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../sign_in/domain/entities/user.dart';
import '../../data/models/TimesTripsResponsedart.dart';

// ignore: must_be_immutable
class TimesScreenBack extends StatefulWidget {
  TimesScreenBack(
      {super.key,
      required this.tripListBack,
      required this.tripTypeId,
      required this.price,
      this.user});
  List<TripList> tripListBack;
  String tripTypeId;
  double price;
  User? user;

  @override
  State<TimesScreenBack> createState() => _TimesScreenBackState();
}

class _TimesScreenBackState extends State<TimesScreenBack> {
  int selected = -1;

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
              alignment: Alignment.topLeft,
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
            Expanded(
              child: ListView.builder(
                  itemCount: widget.tripListBack.length,
                  itemBuilder: (context, index) {
                    return Column(
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
                            height: 140,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: selected == index
                                    ? Color(0xffFF5D4B)
                                    : AppColors.lightBink),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LanguageClass.isEnglish ? "From" : "من",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "roman",
                                          fontSize: 12),
                                    ),
                                    Text(
                                      widget.tripListBack[index].fromCityName ??
                                          '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "bold",
                                          fontSize: 12),
                                    ),
                                    Text(
                                      widget.tripListBack[index].from,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "roman",
                                          fontSize: 12),
                                    ),
                                    Text(
                                      LanguageClass.isEnglish ? "To" : "الي",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "roman",
                                          fontSize: 12),
                                    ),
                                    Text(
                                      widget.tripListBack[index].toCityName ??
                                          '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "bold",
                                          fontSize: 12),
                                    ),
                                    Text(
                                      widget.tripListBack[index].to,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "roman",
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.tripListBack[index].lineName,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "roman",
                                          fontSize: 12),
                                    ),
                                    Text(
                                      widget.tripListBack[index]
                                          .timeOfCustomerStation
                                          .substring(0, 5)
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "bold",
                                          fontSize: 14),
                                    ),
                                    Text(
                                      '${widget.tripListBack[index].price.toString()} ${Routes.curruncy}' ??
                                          '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "bold",
                                          fontSize: 14),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        CacheHelper.setDataToSharedPref(
                                            key: 'numberTrip2',
                                            value: widget.tripListBack[index]
                                                .tripNumber);
                                        CacheHelper.setDataToSharedPref(
                                            key: 'elite2',
                                            value: widget.tripListBack[index]
                                                .serviceType);
                                        CacheHelper.setDataToSharedPref(
                                            key: 'accessBusDate2',
                                            value: widget
                                                .tripListBack[index].accessDate
                                                .toString());
                                        CacheHelper.setDataToSharedPref(
                                            key: 'accessBusTime2',
                                            value: widget.tripListBack[index]
                                                .accessBusTime);
                                        CacheHelper.setDataToSharedPref(
                                            key: 'lineName2',
                                            value: widget
                                                .tripListBack[index].lineName);
                                        CacheHelper.setDataToSharedPref(
                                            key: 'tripOneId',
                                            value: widget.tripListBack[index]
                                                    .tripId ??
                                                0);

                                        CacheHelper.setDataToSharedPref(
                                            key: 'tripRoundId',
                                            value: widget
                                                .tripListBack[index].tripId
                                                .toString());

                                        CacheHelper.setDataToSharedPref(
                                            key: 'lineid2',
                                            value: widget.tripListBack[index]
                                                    .lineId ??
                                                0);

                                        CacheHelper.setDataToSharedPref(
                                            key: 'serviceTypeID2',
                                            value: widget.tripListBack[index]
                                                    .serviceTypeId ??
                                                0);

                                        CacheHelper.setDataToSharedPref(
                                            key: 'busId2',
                                            value: widget.tripListBack[index]
                                                    .busId ??
                                                0);

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
                                                        isedit: false,
                                                        to: widget
                                                                .tripListBack[
                                                                    index]
                                                                .to ??
                                                            "",
                                                        from: widget
                                                                .tripListBack[
                                                                    index]
                                                                .from ??
                                                            "",
                                                        triTypeId:
                                                            widget.tripTypeId,
                                                        price: widget
                                                            .tripListBack[index]
                                                            .price!,
                                                        user: widget.user,
                                                        tripId: widget
                                                            .tripListBack[index]
                                                            .tripId!,
                                                        tocity: widget
                                                                .tripListBack[
                                                                    index]
                                                                .toCityName ??
                                                            '',
                                                        fromcity: widget
                                                                .tripListBack[
                                                                    index]
                                                                .fromCityName ??
                                                            '',
                                                      ))),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
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
                                              ? 'Reservation'
                                              : 'حجز',
                                          style: fontStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        selected == index
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: ListView.builder(
                                  itemCount: widget
                                      .tripListBack[index].lineCity.length,
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
                                            '${widget.tripListBack[index].lineCity[index2].cityName}' ??
                                                '',
                                            style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontFamily: "bold",
                                                fontSize: 16),
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
                                                        color:
                                                            Colors.transparent,
                                                        child: Directionality(
                                                          textDirection:
                                                              LanguageClass
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
                                                            alignment: Alignment
                                                                .topRight,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            20),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20))),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        30,
                                                                    vertical:
                                                                        5),
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                    height: 15),
                                                                Container(
                                                                  alignment: LanguageClass.isEnglish
                                                                      ? Alignment
                                                                          .topLeft
                                                                      : Alignment
                                                                          .topRight,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .arrow_back_rounded,
                                                                      color: AppColors
                                                                          .primaryColor,
                                                                      size: 35,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          20),
                                                                  child: Text(
                                                                    LanguageClass
                                                                            .isEnglish
                                                                        ? "Access Points"
                                                                        : "نقط التجمع",
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .blackColor,
                                                                        fontSize:
                                                                            28,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontFamily:
                                                                            "meduim"),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Expanded(
                                                                  child: ListView
                                                                      .separated(
                                                                          itemBuilder:
                                                                              (context,
                                                                                  index3) {
                                                                            return Container(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                    child: Text(
                                                                                      '${widget.tripListBack[index].lineCity[index2].lineStationList[index3].stationName}' ?? '',
                                                                                      style: TextStyle(color: AppColors.primaryColor, fontFamily: "bold", fontSize: 14),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                    child: Text(
                                                                                      '${widget.tripListBack[index].lineCity[index2].lineStationList[index3].accessTime.substring(0, 5)}' ?? '',
                                                                                      style: TextStyle(color: AppColors.primaryColor, fontFamily: "bold", fontSize: 14),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },
                                                                          separatorBuilder:
                                                                              (context,
                                                                                  index) {
                                                                            return Divider(
                                                                              color: Colors.black,
                                                                            );
                                                                          },
                                                                          physics:
                                                                              ScrollPhysics(),
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount:
                                                                              widget.tripListBack[index].lineCity[index2].lineStationList.length ?? 0),
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
                                              primary: AppColors.primaryColor,
                                              onPrimary: Colors.white,
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  LanguageClass.isEnglish
                                                      ? "Points"
                                                      : "نقط التجمع",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
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
          ],
        ),
      ),
    );
  }
}
