import 'dart:developer';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indexed/indexed.dart';
import 'package:intl/intl.dart' as intl;
import 'package:printing/printing.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/hex_color.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/Swa_umra/Screens/Bus_seat_screan.dart';
import 'package:swa/features/Swa_umra/Screens/Enter_trip_data.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';

class TriplistScreen extends StatefulWidget {
  String city, date;
  TriplistScreen({super.key, required this.city, required this.date});

  @override
  State<TriplistScreen> createState() => _TriplistScreenState();
}

class _TriplistScreenState extends State<TriplistScreen> {
  final UmraBloc _umraBloc = UmraBloc();

  int selectedpackage = 0;

  int opentap = -1;
  CarouselSliderController _carouselSliderController =
      CarouselSliderController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _umraBloc.add(GetcampaginsListEvent(city: widget.city, date: widget.date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder(
          bloc: _umraBloc,
          builder: (context, UmraState state) {
            return SafeArea(
                bottom: false,
                child: Directionality(
                  textDirection: LanguageClass.isEnglish
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 27, right: 27),
                        alignment: LanguageClass.isEnglish
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.umragold,
                            size: 25,
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              left: LanguageClass.isEnglish ? 55 : 0,
                              right: LanguageClass.isEnglish ? 0 : 55),
                          alignment: LanguageClass.isEnglish
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: Text(
                            LanguageClass.isEnglish ? 'Packages' : 'الحملات',
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontFamily: 'bold',
                                fontWeight: FontWeight.w500),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
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
                                      state.triplistmodel!.message!.length,
                                      (index) => Indexed(
                                            index: index,
                                            key: UniqueKey(),
                                            child: InkWell(
                                              onTap: () {
                                                UniqueKey();
                                                log('message');
                                                setState(() {
                                                  selectedpackage = index;
                                                });
                                              },
                                              child: AnimatedContainer(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        selectedpackage == index
                                                            ? 30
                                                            : 5,
                                                    right: 5),
                                                margin: EdgeInsets.only(
                                                    left: index * 80),
                                                decoration: BoxDecoration(
                                                    boxShadow:
                                                        selectedpackage == index
                                                            ? [
                                                                BoxShadow(
                                                                    offset:
                                                                        Offset(4,
                                                                            0),
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.4),
                                                                    blurRadius:
                                                                        4,
                                                                    spreadRadius:
                                                                        0)
                                                              ]
                                                            : null,
                                                    color: HexColor(state
                                                        .triplistmodel!
                                                        .message![index]
                                                        .bgColor!),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13)),
                                                width: selectedpackage == index
                                                    ? 148
                                                    : 100,
                                                height: 47,
                                                duration:
                                                    Duration(microseconds: 100),
                                                curve: Curves.linear,
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                          state
                                                              .triplistmodel!
                                                              .message![index]
                                                              .name!,
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'bold',
                                                              fontSize: 18),
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
                      Expanded(
                        child: state.triplistmodel!.message![selectedpackage]
                                .tripList!.isEmpty
                            ? Center(
                                child: Text(
                                    LanguageClass.isEnglish
                                        ? 'No Trips!'
                                        : 'لا يوجد رحلات',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'bold',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                              )
                            : ListView.builder(
                                itemCount: state.triplistmodel!
                                    .message![selectedpackage].tripList!.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: ScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 33, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              opentap == index
                                                  ? opentap = -1
                                                  : opentap = index;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(15),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Color(0xffC3C3C3),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                image: state
                                                            .triplistmodel!
                                                            .message![index]
                                                            .image ==
                                                        null
                                                    ? null
                                                    : index <
                                                            (state
                                                                    .triplistmodel!
                                                                    .message!
                                                                    .length -
                                                                1)
                                                        ? DecorationImage(
                                                            fit: BoxFit.cover,
                                                            opacity: 1,
                                                            colorFilter: ColorFilter.mode(
                                                                HexColor(state
                                                                    .triplistmodel!
                                                                    .message![
                                                                        index]
                                                                    .bgColor!),
                                                                BlendMode
                                                                    .multiply),
                                                            alignment: Alignment
                                                                .center,
                                                            image: NetworkImage(
                                                              state
                                                                  .triplistmodel!
                                                                  .message![
                                                                      index]
                                                                  .image!,
                                                            ))
                                                        : DecorationImage(
                                                            fit: BoxFit.cover,
                                                            opacity: 1,
                                                            colorFilter: ColorFilter.mode(
                                                                HexColor(state.triplistmodel!.message![index - state.triplistmodel!.message!.length].bgColor!),
                                                                BlendMode.multiply),
                                                            alignment: Alignment.center,
                                                            image: NetworkImage(
                                                              state
                                                                  .triplistmodel!
                                                                  .message![index -
                                                                      state
                                                                          .triplistmodel!
                                                                          .message!
                                                                          .length]
                                                                  .image!,
                                                            ))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          state
                                                              .triplistmodel!
                                                              .message![
                                                                  selectedpackage]
                                                              .tripList![index]
                                                              .campaignName!,
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              fontFamily:
                                                                  'bold',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                    InkWell(
                                                      onTap: (() {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SleactseatScrean(
                                                                selectedpackage:
                                                                    index,
                                                                tripdetails: state
                                                                        .triplistmodel!
                                                                        .message![
                                                                    selectedpackage],
                                                              ),
                                                            ));
                                                      }),
                                                      child: Container(
                                                        height: 30,
                                                        width: 80,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black54,
                                                                  offset:
                                                                      Offset(
                                                                          0, 2),
                                                                  blurRadius:
                                                                      14,
                                                                  spreadRadius:
                                                                      0)
                                                            ],
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        41)),
                                                        child: Text(
                                                            LanguageClass.isEnglish
                                                                ? 'Book'
                                                                : 'احجز',
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'bold',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                    0xffcacaca))),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height: 40,
                                                          child:
                                                              ListView.builder(
                                                            itemCount: state
                                                                .triplistmodel!
                                                                .message![
                                                                    selectedpackage]
                                                                .tripList![
                                                                    index]
                                                                .nightsList!
                                                                .length,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            shrinkWrap: true,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index3) {
                                                              return Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            5),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        '${state.triplistmodel!.message![selectedpackage].tripList![index].nightsList![index3].numberNights.toString()} ${LanguageClass.isEnglish == true ? 'Nights' : 'ليالي'}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'bold',
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: Colors.white)),
                                                                    2.horizontalSpace,
                                                                    Text(
                                                                        state
                                                                            .triplistmodel!
                                                                            .message![
                                                                                selectedpackage]
                                                                            .tripList![
                                                                                index]
                                                                            .nightsList![
                                                                                index3]
                                                                            .cityName
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'bold',
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: Colors.white)),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                            intl.DateFormat(
                                                                    "EEE, MMM d, yyyy")
                                                                .format(state
                                                                    .triplistmodel!
                                                                    .message![
                                                                        selectedpackage]
                                                                    .tripList![
                                                                        index]
                                                                    .tripDateGo!)
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'bold',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white)),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                LanguageClass
                                                                        .isEnglish
                                                                    ? 'Transportation'
                                                                    : 'مواصلات',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'bold',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white)),
                                                            state
                                                                    .triplistmodel!
                                                                    .message![
                                                                        selectedpackage]
                                                                    .tripList![
                                                                        index]
                                                                    .withTransportaion!
                                                                ? Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color: Colors
                                                                        .green,
                                                                    size: 20,
                                                                  )
                                                                : SizedBox()
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                            state
                                                                .triplistmodel!
                                                                .message![
                                                                    selectedpackage]
                                                                .tripList![
                                                                    index]
                                                                .tripTimeGo!,
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'bold',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white)),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                            LanguageClass.isEnglish
                                                                ? 'Availability ${state.triplistmodel!.message![selectedpackage].tripList![index].availability}'
                                                                : 'المتاح ${state.triplistmodel!.message![selectedpackage].tripList![index].availability}',
                                                            style: const TextStyle(
                                                                fontSize: 11,
                                                                fontFamily:
                                                                    'bold',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white)),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        opentap == index
                                            ? Container(
                                                child: ListView.builder(
                                                  itemCount: state
                                                      .triplistmodel!
                                                      .message![index]
                                                      .detailsList!
                                                      .length,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index2) {
                                                    return Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      child:
                                                          Text(
                                                              state
                                                                  .triplistmodel!
                                                                  .message![
                                                                      index]
                                                                  .detailsList![
                                                                      index2]
                                                                  .description!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                              textDirection: LanguageClass
                                                                      .isEnglish
                                                                  ? TextDirection
                                                                      .ltr
                                                                  : TextDirection
                                                                      .rtl,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'meduim',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black)),
                                                    );
                                                  },
                                                ),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  );
                                },
                              ),
                      )
                    ],
                  ),
                ));
          }),
    );
  }
}
