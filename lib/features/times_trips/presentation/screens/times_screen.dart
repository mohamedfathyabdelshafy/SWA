import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import 'package:swa/features/bus_reservation_layout/data/models/BusSeatsModel.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Ticket_class.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/bus_layout.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/bus_layout_back.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/reservation_ticket.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_model.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_widget.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';

import '../../../../core/local_cache_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';

import '../../data/models/TimesTripsResponsedart.dart';
import '../PLOH/times_trips_states.dart';

// ignore: must_be_immutable
class TimesScreen extends StatefulWidget {
  TimesScreen({
    super.key,
    required this.tripList,
    required this.tripTypeId,
    this.tripListBack,
    required this.fromTrip,
    required this.toTrip,
    required this.numberOfAdults,
    required this.dateTrip,
    this.tripType,
    this.fromStationID,
    this.toStationID,
    this.dateGo,
    this.dateBack,
  });
  List<TripList> tripList;
  List<TripList>? tripListBack;
  String tripTypeId;
  String fromTrip;
  String toTrip;
  String numberOfAdults;
  String dateTrip;

  /// request
  String? tripType;
  String? fromStationID;
  String? toStationID;
  String? dateGo;
  String? dateBack;

  @override
  State<TimesScreen> createState() => _TimesScreenState();
}

class _TimesScreenState extends State<TimesScreen> {
  int selected = -1;
  int selectedback = -1;
  BusSeatsModel? busSeatsModel;

  BusLayoutRepo busLayoutRepo = BusLayoutRepo(apiConsumer: (sl()));

  bool showTime = false;
  bool isRecommended = false;

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: Color(0xfff3f3f3),
      // backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.symmetric(horizontal: 7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // color: Color(0xfff3f3f3),
            color: AppColors.white,
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);

              Reservationtimer.stoptimer();
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: AppColors.blackColor,
              size: 35,
            ),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: SizedBox(
          width: MediaQuery.sizeOf(context).width * 1,
          child: Card(
            // color: Color(0xfff3f3f3),
            color: AppColors.white,
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 5,
                children: [
                  Text(
                    "${widget.fromTrip} - ${widget.toTrip}",
                    style: fontStyle(
                        color: Colors.black,
                        fontFamily: FontFamily.medium,
                        fontSize: 12.sp),
                  ),
                  (LanguageClass.isEnglish)
                      ? Text(
                          "${widget.numberOfAdults} Adult -  ${widget.dateTrip}",
                          style: fontStyle(
                              color: Colors.grey,
                              fontFamily: FontFamily.regular,
                              fontSize: 10.sp),
                        )
                      : Text(
                          "\u202B${widget.numberOfAdults} بالغ - ${widget.dateTrip}",
                          style: fontStyle(
                              color: Colors.grey,
                              fontFamily: FontFamily.regular,
                              fontSize: 10.sp),
                        )
                ],
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: Color(0xfff3f3f3),
              color: AppColors.white,
            ),
            child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Icon(
                  CupertinoIcons.share,
                  color: AppColors.blackColor,
                  size: 20,
                )),
          )
        ],
      ),
      body: Directionality(
        textDirection:
            (LanguageClass.isEnglish) ? TextDirection.ltr : TextDirection.rtl,
        child: BlocProvider(
          create: (context) => TimesTripsCubit(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // todo : filter
              SizedBox(
                height: sizeHeight * 0.08,
                child: Card(
                  color: Colors.transparent,
                  elevation: 0.0,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        // color: Color(0xfff3f3f3),
                        color: AppColors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6),
                          child: Image.asset(
                            height: 20,
                            width: 20,
                            "assets/images/filter.png",
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: _buildFilterCard(
                          title: (LanguageClass.isEnglish)
                              ? "Recommended"
                              : "الموصي بها",
                          icon: Icons.keyboard_arrow_down_outlined,
                          iconCustom: true,
                          // widget: Container(),
                          dropdownItems: [
                            "Price - High to Low",
                            "Price - Low to High",
                            "Top rated",
                            "Category"
                          ],
                          onOpenChanged: (isOpen) {
                            setState(() {
                              isRecommended = isOpen;
                              print(isRecommended.toString());
                            });
                          },
                          isRadiusActive: isRecommended,
                          onItemSelected: (selected) {
                            setState(() {
                              print("Selected: $selected");
                            });
                          },
                        ),
                      ),
                      // _buildFilterCard(
                      //     onTap: () async {
                      //       // Navigator.pop(context);
                      //       // final result = await showDialog(
                      //       //     context: context,
                      //       //     builder: (context) {
                      //       //       return Dialog(
                      //       //         child:
                      //       //         MultiBlocProvider(providers: [
                      //       //           BlocProvider<LoginCubit>(
                      //       //             create: (context) => sl<LoginCubit>(),
                      //       //           ),
                      //       //           BlocProvider<PackagesBloc>(
                      //       //             create: (context) => PackagesBloc(),
                      //       //           ),
                      //       //           BlocProvider<FawryReservation>(
                      //       //             create: (context) =>
                      //       //                 sl<FawryReservation>(),
                      //       //           ),
                      //       //           BlocProvider<GetAvailableCountriesCubit>(
                      //       //             create: (context) =>
                      //       //                 sl<GetAvailableCountriesCubit>(),
                      //       //           ),
                      //       //           BlocProvider<HomeCubit>(
                      //       //             create: (context) => sl<HomeCubit>(),
                      //       //           ),
                      //       //           BlocProvider<TimesTripsCubit>(
                      //       //               create: (context) =>
                      //       //                   sl<TimesTripsCubit>()),
                      //       //           BlocProvider<TicketCubit>(
                      //       //               create: (context) => sl<TicketCubit>()),
                      //       //         ], child: MyHome(showNavBar: true)),
                      //       //       );
                      //       //     });
                      //       //
                      //       // if (result != null) {
                      //       //   setState(() {
                      //       //     widget.tripList = result['tripList'];
                      //       //     widget.tripTypeId = result['tripTypeId'];
                      //       //     widget.tripListBack = result['tripListBack'];
                      //       //     widget.fromTrip = result['fromTrip'];
                      //       //     widget.toTrip = result['toTrip'];
                      //       //     widget.dateTrip = result['dateTrip'];
                      //       //     widget.numberOfAdults = result['numberOfAdults'];
                      //       //   });
                      //       // }
                      //       // final date = DateTime.parse("${widget.dateTrip}");
                      //       // final newDate = date.add(const Duration(days: 1));
                      //       // print("${newDate.year}-"
                      //       //     "${newDate.month.toString().padLeft(2, '0')}-"
                      //       //     "${newDate.day.toString().padLeft(2, '0')}");
                      //
                      //       // setState(() {
                      //       //   isRecommended = !isRecommended;
                      //       //   if (isRecommended) {
                      //       //     showTime = false;
                      //       //   }
                      //       // });
                      //     },
                      //     title: (LanguageClass.isEnglish)
                      //         ? "Recommended"
                      //         : "الموصي بها",
                      //     icon: Icons.keyboard_arrow_down_outlined,
                      //     iconCustom: true,
                      //     widget: Container()),
                      Expanded(
                        flex: 2,
                        child: _buildFilterCard(
                          onTap: () {
                            setState(() {
                              showTime = !showTime;
                              if (showTime) {
                                // isRecommended = false;
                              }
                            });
                          },
                          title: (LanguageClass.isEnglish) ? "Stops" : "توقف",
                          icon: Icons.keyboard_arrow_down_rounded,
                          // icon: Icons.keyboard_arrow_down_outlined,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Builder(builder: (context) {
                          return BlocListener<TimesTripsCubit,
                              TimesTripsStates>(
                            listener: (context, state) {
                              if (state is LoadingTimesTrips) {
                                Constants.showLoadingDialog(context);
                              } else if (state is LoadedTimesTrips) {
                                Constants.hideLoadingDialog(context);
                                print(
                                    "${state.timesTripsResponse.message!.tripListBack.length} back list");
                                if (state.timesTripsResponse.message!.tripList!
                                    .isNotEmpty) {
                                  setState(() {
                                    widget.tripList = state
                                        .timesTripsResponse.message!.tripList;

                                    widget.tripTypeId = '1';
                                    if (widget.tripTypeId == '1') {
                                      widget.tripListBack?.clear();
                                      widget.tripTypeId = '1';
                                    }
                                    print(widget.tripTypeId.toString());
                                    if (state.timesTripsResponse.message!
                                        .tripListBack.isNotEmpty) {
                                      widget.tripTypeId = '2';
                                      widget.tripListBack = state
                                          .timesTripsResponse
                                          .message!
                                          .tripListBack;
                                    }
                                  });

                                  Reservationtimer.stoptimer();

                                  Ticketreservation.Seatsnumbers1.clear();
                                  Ticketreservation.Seatsnumbers2.clear();
                                } else {
                                  Constants.showDefaultSnackBar(
                                      context: context,
                                      text: LanguageClass.isEnglish
                                          ? "No trips in this date"
                                          : "لا يوجد مواعيد في هذا الموعد");
                                }
                              } else if (state is ErrorTimesTrips) {
                                Constants.hideLoadingDialog(context);
                                Constants.showDefaultSnackBar(
                                    context: context, text: state.msg);
                              }
                            },
                            child: _buildFilterCard(
                                onTap: () {
                                  if (widget.tripListBack?.isEmpty == true) {
                                    final parts = widget.dateGo!.split('-');

                                    final year = int.parse(parts[0]); // 2026
                                    final month = int.parse(parts[1]); // 2
                                    final day = int.parse(parts[2]); // 3

                                    print(
                                        "Original date string: ${widget.dateGo}");
                                    print(
                                        "Parsed as: year=$year, month=$month, day=$day");

                                    final date = DateTime(year, month,
                                        day); // DateTime(2026, 2, 3)
                                    print("DateTime object: $date");

                                    final newDate =
                                        date.add(const Duration(days: 1));
                                    print("After adding 1 day: $newDate");

                                    final formattedDate = "${newDate.year}-"
                                        "${newDate.month.toString().padLeft(2, '0')}-"
                                        "${newDate.day.toString().padLeft(2, '0')}";

                                    print(
                                        "Final formatted date: $formattedDate");

                                    context.read<TimesTripsCubit>().getTimes(
                                          tripType: "2",
                                          fromStationID:
                                              widget.fromStationID.toString(),
                                          toStationID:
                                              widget.toStationID.toString(),
                                          dateGo: widget.dateGo.toString(),
                                          dateBack: formattedDate,
                                        );
                                  } else {
                                    context.read<TimesTripsCubit>().getTimes(
                                          tripType: "1",
                                          // widget.tripTypeId.toString(),
                                          fromStationID:
                                              widget.fromStationID.toString(),
                                          toStationID:
                                              widget.toStationID.toString(),
                                          dateGo: widget.dateGo.toString(),
                                          dateBack: widget.dateBack.toString(),
                                          // dateBack: "",
                                        );
                                  }
                                },
                                title: (LanguageClass.isEnglish)
                                    ? (widget.tripListBack?.isEmpty == true
                                        ? "Go"
                                        : "Back")
                                    : (widget.tripListBack?.isEmpty == true
                                        ? "ذهاب"
                                        : "عوده"),
                                icon: Icons.keyboard_arrow_down_outlined,
                                iconCustom: true,
                                widget: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7.0),
                                  child: Image.asset(
                                    height: 10,
                                    width: 10,
                                    "assets/images/arrow_toggle.png",
                                  ),
                                )),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              // BlocProvider(
              //   create: (context) => TimesTripsCubit(),
              //   child: Builder(builder: (context) {
              //     return BlocListener<TimesTripsCubit, TimesTripsStates>(
              //         // bloc: BlocProvider.of<TimesTripsCubit>(context),
              //         listener: (context, state) {
              //           if (state is LoadingTimesTrips) {
              //             Constants.showLoadingDialog(context);
              //           } else if (state is LoadedTimesTrips) {
              //             Constants.hideLoadingDialog(context);
              //             print(
              //                 "${state.timesTripsResponse.message!.tripListBack.length} back list");
              //             if (state.timesTripsResponse.message!.tripList!
              //                 .isNotEmpty) {
              //               setState(() {
              //                 widget.tripList =
              //                     state.timesTripsResponse.message!.tripList;
              //
              //                 widget.tripTypeId = '1';
              //                 if (widget.tripTypeId == '1') {
              //                   widget.tripListBack?.clear();
              //                   widget.tripTypeId = '1';
              //                 }
              //                 print(widget.tripTypeId.toString());
              //                 if (state.timesTripsResponse.message!.tripListBack
              //                     .isNotEmpty) {
              //                   widget.tripTypeId = '2';
              //                   widget.tripListBack = state
              //                       .timesTripsResponse.message!.tripListBack;
              //                 }
              //               });
              //
              //               Reservationtimer.stoptimer();
              //
              //               Ticketreservation.Seatsnumbers1.clear();
              //               Ticketreservation.Seatsnumbers2.clear();
              //             } else {
              //               Constants.showDefaultSnackBar(
              //                   context: context,
              //                   text: LanguageClass.isEnglish
              //                       ? "No trips in this date"
              //                       : "لا يوجد مواعيد في هذا الموعد");
              //             }
              //           } else if (state is ErrorTimesTrips) {
              //             Constants.hideLoadingDialog(context);
              //             Constants.showDefaultSnackBar(
              //                 context: context, text: state.msg);
              //           }
              //         },
              //         child: (isRecommended)
              //             ? SizedBox(
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   spacing: 20,
              //                   children: [
              //                     FilledButton(
              //                       onPressed: () {
              //                         print(widget.dateGo.toString());
              //                         context.read<TimesTripsCubit>().getTimes(
              //                               tripType: "1",
              //                               // widget.tripTypeId.toString(),
              //                               fromStationID:
              //                                   widget.fromStationID.toString(),
              //                               toStationID:
              //                                   widget.toStationID.toString(),
              //                               dateGo: widget.dateGo.toString(),
              //                               dateBack:
              //                                   widget.dateBack.toString(),
              //                               // dateBack: "",
              //                             );
              //                       },
              //                       style: ButtonStyle(
              //                         overlayColor: WidgetStatePropertyAll(
              //                           AppColors.primaryColor,
              //                         ),
              //                         backgroundBuilder:
              //                             (context, states, child) {
              //                           return Ink(
              //                             decoration: BoxDecoration(
              //                               borderRadius:
              //                                   BorderRadius.circular(30),
              //                               gradient: LinearGradient(
              //                                 begin: Alignment.centerLeft,
              //                                 end: Alignment.centerRight,
              //                                 colors: [
              //                                   Color(0xfffd634f),
              //                                   Color(0xffff9976),
              //                                 ],
              //                               ),
              //                             ),
              //                             child: child,
              //                           );
              //                         },
              //                       ),
              //                       child: Padding(
              //                         padding: const EdgeInsets.all(8.0),
              //                         child: Text(
              //                           LanguageClass.isEnglish
              //                               ? "One way"
              //                               : "ذهاب فقط",
              //                           style: fontStyle(
              //                               // color: Color(0xff383838),
              //                               color: Colors.white,
              //                               fontFamily: FontFamily.bold,
              //                               fontSize: 13.sp),
              //                         ),
              //                       ),
              //                     ),
              //                     FilledButton(
              //                       onPressed: () {
              //                         final parts = widget.dateGo!.split('-');
              //
              //                         final year = int.parse(parts[0]); // 2026
              //                         final month = int.parse(parts[1]); // 2
              //                         final day = int.parse(parts[2]); // 3
              //
              //                         print(
              //                             "Original date string: ${widget.dateGo}");
              //                         print(
              //                             "Parsed as: year=$year, month=$month, day=$day");
              //
              //                         final date = DateTime(year, month,
              //                             day); // DateTime(2026, 2, 3)
              //                         print("DateTime object: $date");
              //
              //                         final newDate =
              //                             date.add(const Duration(days: 1));
              //                         print("After adding 1 day: $newDate");
              //
              //                         final formattedDate = "${newDate.year}-"
              //                             "${newDate.month.toString().padLeft(2, '0')}-"
              //                             "${newDate.day.toString().padLeft(2, '0')}";
              //
              //                         print(
              //                             "Final formatted date: $formattedDate");
              //
              //                         context.read<TimesTripsCubit>().getTimes(
              //                               tripType: "2",
              //                               fromStationID:
              //                                   widget.fromStationID.toString(),
              //                               toStationID:
              //                                   widget.toStationID.toString(),
              //                               dateGo: widget.dateGo.toString(),
              //                               dateBack: formattedDate,
              //                             );
              //                       },
              //                       style: ButtonStyle(
              //                         overlayColor: WidgetStatePropertyAll(
              //                           AppColors.primaryColor,
              //                         ),
              //                         backgroundBuilder:
              //                             (context, states, child) {
              //                           return Ink(
              //                             decoration: BoxDecoration(
              //                               borderRadius:
              //                                   BorderRadius.circular(30),
              //                               gradient: LinearGradient(
              //                                 begin: Alignment.centerLeft,
              //                                 end: Alignment.centerRight,
              //                                 colors: [
              //                                   Color(0xfffd634f),
              //                                   Color(0xffff9976),
              //                                 ],
              //                               ),
              //                             ),
              //                             child: child,
              //                           );
              //                         },
              //                       ),
              //                       child: Padding(
              //                         padding: const EdgeInsets.all(8.0),
              //                         child: Text(
              //                           LanguageClass.isEnglish
              //                               ? "Round Trip"
              //                               : "ذهاب وعوده",
              //                           style: fontStyle(
              //                               // color: Color(0xff383838),
              //                               color: Colors.white,
              //                               fontFamily: FontFamily.bold,
              //                               fontSize: 13.sp),
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               )
              //             : SizedBox.shrink());
              //   }),
              // ),
              (showTime) ? _buildTimeWidget("day", "time") : SizedBox.shrink(),
              // isRecommended
              //     ? SizedBox(
              //         height: 10,
              //       )
              //     : SizedBox.shrink(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Text(
              //     (LanguageClass.isEnglish)
              //         ? "Per person, in EGP (taxes and fees included)"
              //         : "للفرد الواحد، بالجنيه المصري (شاملة الضرائب والرسوم)",
              //     style: fontStyle(
              //         color: Color(0xff383838),
              //         fontFamily: FontFamily.regular,
              //         fontSize: 13.sp),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
              //   child: Card(
              //     elevation: 0.0,
              //     color: Color(0xfff3f3f3),
              //     child: Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: Text(
              //         (LanguageClass.isEnglish)
              //             ? "Book directly with SWA using your local bank cards, without any restrictions and additional bank charges."
              //             : "احجز مباشرةً مع SWA باستخدام بطاقاتك المصرفية المحلية، بدون أي قيود أو رسوم مصرفية إضافية.",
              //         style: fontStyle(
              //             color: Color(0xff383838),
              //             fontFamily: FontFamily.regular,
              //             fontSize: 12.sp),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: sizeHeight * 0.015,
              // ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 15),
              //   child: Text(
              //     LanguageClass.isEnglish ? "Go trips" : "رحلات الذهاب",
              //     textAlign: LanguageClass.isEnglish
              //         ? TextAlign.left
              //         : TextAlign.right,
              //     style: fontStyle(
              //         color: Colors.black,
              //         fontFamily: FontFamily.medium,
              //         fontSize: 16.sp),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              Ticketreservation.Seatsnumbers1.isNotEmpty
                  ? SizedBox.shrink()
                  // Flexible(
                  //         flex: (selectedback != -1) ? 4 : 1,
                  //         child: Container(
                  //           margin: EdgeInsets.symmetric(horizontal: 16.w),
                  //           // padding: EdgeInsets.all(15),
                  //           width: double.infinity,
                  //           clipBehavior: Clip.hardEdge,
                  //           height: 150.h,
                  //           // decoration: BoxDecoration(
                  //           //     borderRadius: BorderRadius.circular(12),
                  //           //     color: Color(0xffFF5D4B)),
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(10),
                  //               color: AppColors.white
                  //               // color: Color(0xffF3F3F3)
                  //               ),
                  //           child: Column(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               Container(
                  //                 decoration: BoxDecoration(
                  //                   gradient: const LinearGradient(
                  //                     colors: [
                  //                       Color(0xfffd634f),
                  //                       Color(0xffff9976),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 padding: EdgeInsets.all(10),
                  //                 child: Row(
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceBetween,
                  //                   children: [
                  //                     Column(
                  //                       mainAxisSize: MainAxisSize.min,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           LanguageClass.isEnglish
                  //                               ? "Enjoy for less with Swa Bus"
                  //                               : "استمتع بتكلفة أقل مع حافلات سوا",
                  //                           style: fontStyle(
                  //                               color: Colors.white,
                  //                               fontFamily: FontFamily.bold,
                  //                               fontSize: 12.sp),
                  //                         ),
                  //                         Text(
                  //                           LanguageClass.isEnglish
                  //                               ? "Unbeatable trips deals with Swa Bus! "
                  //                               : "عروض رحلات لا تُضاهى مع سوا!",
                  //                           style: fontStyle(
                  //                               color: Colors.white,
                  //                               fontFamily: FontFamily.regular,
                  //                               fontSize: 10.sp),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     Text(
                  //                       LanguageClass.isEnglish
                  //                           ? "Sponsored"
                  //                           : "ممول",
                  //                       style: fontStyle(
                  //                           color: Colors.white,
                  //                           fontFamily: FontFamily.regular,
                  //                           fontSize: 12.sp),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                   child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   SizedBox(
                  //                     width: 15,
                  //                   ),
                  //                   Expanded(
                  //                       flex: 3,
                  //                       child: Column(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.center,
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         spacing: 5,
                  //                         children: [
                  //                           Spacer(),
                  //                           Padding(
                  //                             padding: const EdgeInsets.symmetric(
                  //                                 horizontal: 0.0, vertical: 0),
                  //                             child: Row(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.center,
                  //                               children: [
                  //                                 // SizedBox(
                  //                                 //   width: 10,
                  //                                 // ),
                  //                                 // Container(
                  //                                 //   height: 45,
                  //                                 //   width: 45,
                  //                                 //   clipBehavior:
                  //                                 //       Clip.antiAliasWithSaveLayer,
                  //                                 //   decoration: BoxDecoration(
                  //                                 //     shape: BoxShape.circle,
                  //                                 //   ),
                  //                                 //   child: Image.network(
                  //                                 //     "https://play-lh.googleusercontent.com/ACfnkQHBH_KBNpqhaU2PkbNp1mcLeZtaOHHvKTSDHBEOD43QH9gB9nd5GQkWpfB9n7M=w480-h960-rw",
                  //                                 //   ),
                  //                                 // ),
                  //                                 Container(
                  //                                   height: 38,
                  //                                   width: 38,
                  //                                   clipBehavior:
                  //                                       Clip.antiAliasWithSaveLayer,
                  //                                   decoration: BoxDecoration(
                  //                                     shape: BoxShape.circle,
                  //                                   ),
                  //                                   child: Image.network(
                  //                                     widget.tripList.first.logo ??
                  //                                         "https://play-lh.googleusercontent.com/ACfnkQHBH_KBNpqhaU2PkbNp1mcLeZtaOHHvKTSDHBEOD43QH9gB9nd5GQkWpfB9n7M=w480-h960-rw",
                  //                                   ),
                  //                                 ),
                  //                                 SizedBox(
                  //                                   width: 10,
                  //                                 ),
                  //                                 // Text(
                  //                                 //   (LanguageClass.isEnglish
                  //                                 //       ? "Swa"
                  //                                 //       : "سوا"),
                  //                                 //   style: fontStyle(
                  //                                 //       color: Colors.black,
                  //                                 //       fontFamily:
                  //                                 //           FontFamily.medium,
                  //                                 //       fontSize: 12.sp),
                  //                                 // ),
                  //                                 Text(
                  //                                   widget.tripList.first
                  //                                           .companyName ??
                  //                                       (LanguageClass.isEnglish
                  //                                           ? "Swa"
                  //                                           : "سوا"),
                  //                                   style: fontStyle(
                  //                                       color: Colors.black,
                  //                                       fontFamily:
                  //                                           FontFamily.medium,
                  //                                       fontSize: 12.sp),
                  //                                 ),
                  //                                 SizedBox(
                  //                                   width: 20,
                  //                                 ),
                  //                                 Icon(
                  //                                   Icons.star,
                  //                                   color: Color(0xffFC9900),
                  //                                   size: 15,
                  //                                 ),
                  //                                 SizedBox(
                  //                                   width: 2,
                  //                                 ),
                  //                                 Text(
                  //                                   "4.5",
                  //                                   style: fontStyle(
                  //                                       color: Colors.black,
                  //                                       fontFamily:
                  //                                           FontFamily.medium,
                  //                                       height: 0,
                  //                                       fontSize: 12.sp),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           Row(
                  //                             children: [
                  //                               Column(
                  //                                 mainAxisAlignment:
                  //                                     MainAxisAlignment.center,
                  //                                 crossAxisAlignment:
                  //                                     CrossAxisAlignment.center,
                  //                                 spacing: 3,
                  //                                 children: [
                  //                                   Text(
                  //                                     Ticketreservation
                  //                                         .fromcitystation1,
                  //                                     style: fontStyle(
                  //                                         color: Color(0xff858585),
                  //                                         fontFamily:
                  //                                             FontFamily.regular,
                  //                                         fontSize: 10.sp),
                  //                                   ),
                  //                                   Text(
                  //                                     intl.DateFormat('hh:mm a')
                  //                                         .format(DateTime.parse(
                  //                                             Ticketreservation
                  //                                                 .accessDate1))
                  //                                         .toString(),
                  //                                     style: fontStyle(
                  //                                         color: Colors.black,
                  //                                         fontFamily:
                  //                                             FontFamily.bold,
                  //                                         fontSize: 11.sp),
                  //                                   ),
                  //                                   Text(
                  //                                     intl.DateFormat(
                  //                                             'dd MMMM yyyy',
                  //                                             LanguageClass
                  //                                                     .isEnglish
                  //                                                 ? 'en'
                  //                                                 : 'ar')
                  //                                         .format(DateTime.parse(
                  //                                             Ticketreservation
                  //                                                 .accessDate1))
                  //                                         .toString(),
                  //                                     style: fontStyle(
                  //                                         color: Color(0xff858585),
                  //                                         fontFamily:
                  //                                             FontFamily.regular,
                  //                                         fontSize: 8.sp),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                               SizedBox(
                  //                                 height: 10,
                  //                               ),
                  //                               RotatedBox(
                  //                                 quarterTurns:
                  //                                     LanguageClass.isEnglish
                  //                                         ? 90
                  //                                         : 90,
                  //                                 child: Stack(
                  //                                   // alignment: Alignment.centerLeft,
                  //                                   children: [
                  //                                     Container(
                  //                                       width: 50,
                  //                                       height: 1,
                  //                                       margin: EdgeInsets.only(
                  //                                           top: 10,
                  //                                           right: 10,
                  //                                           left: 10,
                  //                                           bottom: 5),
                  //                                       color: Color(0xff000000),
                  //                                       // child: Icon(
                  //                                       //   Icons.arrow_right_alt_rounded,
                  //                                       //   size: 30,
                  //                                       // ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding: EdgeInsets.only(
                  //                                         top: 2.3,
                  //                                         right: LanguageClass
                  //                                                 .isEnglish
                  //                                             ? 0
                  //                                             : 2,
                  //                                         left: LanguageClass
                  //                                                 .isEnglish
                  //                                             ? 2
                  //                                             : 0,
                  //                                       ),
                  //                                       child: Icon(
                  //                                         LanguageClass.isEnglish
                  //                                             ? Icons
                  //                                                 .keyboard_arrow_left_rounded
                  //                                             : Icons
                  //                                                 .keyboard_arrow_right_rounded,
                  //                                         size: 15.5,
                  //                                         color: Color(0xff000000),
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                               SizedBox(
                  //                                 height: 2,
                  //                               ),
                  //                               Ticketreservation.arrivaldate1 ==
                  //                                       null
                  //                                   ? Container()
                  //                                   : Column(
                  //                                       mainAxisAlignment:
                  //                                           MainAxisAlignment
                  //                                               .center,
                  //                                       crossAxisAlignment:
                  //                                           CrossAxisAlignment
                  //                                               .center,
                  //                                       spacing: 3,
                  //                                       children: [
                  //                                           Text(
                  //                                             Ticketreservation
                  //                                                 .tocitystation1,
                  //                                             style: fontStyle(
                  //                                                 color: Color(
                  //                                                     0xff858585),
                  //                                                 fontFamily:
                  //                                                     FontFamily
                  //                                                         .regular,
                  //                                                 fontSize: 10.sp),
                  //                                           ),
                  //                                           Text(
                  //                                             intl.DateFormat(
                  //                                                     'hh:mm a')
                  //                                                 .format(DateTime.parse(
                  //                                                     Ticketreservation
                  //                                                         .arrivaldate1!))
                  //                                                 .toString(),
                  //                                             style: fontStyle(
                  //                                                 color:
                  //                                                     Colors.black,
                  //                                                 fontFamily:
                  //                                                     FontFamily
                  //                                                         .bold,
                  //                                                 fontSize: 11.sp),
                  //                                           ),
                  //                                           Text(
                  //                                             intl.DateFormat(
                  //                                                     'dd MMMM yyyy',
                  //                                                     LanguageClass
                  //                                                             .isEnglish
                  //                                                         ? 'en'
                  //                                                         : 'ar')
                  //                                                 .format(DateTime.parse(
                  //                                                     Ticketreservation
                  //                                                         .arrivaldate1!))
                  //                                                 .toString(),
                  //                                             style: fontStyle(
                  //                                                 color: Color(
                  //                                                     0xff858585),
                  //                                                 fontFamily:
                  //                                                     FontFamily
                  //                                                         .regular,
                  //                                                 fontSize: 8.sp),
                  //                                           ),
                  //                                         ]),
                  //                               SizedBox(
                  //                                 width: 5,
                  //                               ),
                  //                               SizedBox(
                  //                                 width: 10,
                  //                               ),
                  //                             ],
                  //                           ),
                  //                           Spacer(),
                  //                           Text(
                  //                             "${Routes.curruncy ?? ""} ${(Ticketreservation.countSeats1.length * Ticketreservation.priceticket1)}",
                  //                             style: fontStyle(
                  //                                 color: Colors.black,
                  //                                 fontFamily: FontFamily.bold,
                  //                                 fontSize: 12.sp),
                  //                           ),
                  //                           SizedBox(
                  //                             height: 15,
                  //                           ),
                  //                         ],
                  //                       )),
                  //                   Column(
                  //                     mainAxisAlignment: MainAxisAlignment.center,
                  //                     crossAxisAlignment: CrossAxisAlignment.end,
                  //                     spacing: 3,
                  //                     children: [
                  //                       Spacer(),
                  //                       Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.start,
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.center,
                  //                         children: [
                  //                           Container(
                  //                             width: 14,
                  //                             height: 14,
                  //                             alignment: Alignment.center,
                  //                             child: Image.asset(
                  //                                 "assets/images/Icon fa-solid-bus.png",
                  //                                 color: AppColors.grey
                  //                                 // color: Color(0xff007663),
                  //                                 ),
                  //                           ),
                  //                           SizedBox(
                  //                             width: 5,
                  //                           ),
                  //                           Text(
                  //                             Ticketreservation.numbertrip1
                  //                                 .toString(),
                  //                             style: fontStyle(
                  //                                 color: AppColors.grey
                  //                                     .withValues(alpha: 0.8),
                  //                                 fontFamily: FontFamily.medium,
                  //                                 fontSize: 12.sp),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       InkWell(
                  //                         onTap: () {
                  //                           busLayoutRepo
                  //                               .getBusSeatsData(
                  //                                   tripId:
                  //                                       Ticketreservation.tripid1)
                  //                               .then((value) async {
                  //                             busSeatsModel = await value;
                  //
                  //                             if (busSeatsModel != null) {
                  //                               for (int i = 0;
                  //                                   i <
                  //                                       busSeatsModel!
                  //                                           .busSeatDetails!
                  //                                           .busDetails!
                  //                                           .totalRow!;
                  //                                   i++) {
                  //                                 for (int j = 0;
                  //                                     j <
                  //                                         busSeatsModel!
                  //                                             .busSeatDetails!
                  //                                             .busDetails!
                  //                                             .rowList![i]
                  //                                             .seats
                  //                                             .length;
                  //                                     j++) {
                  //                                   if (busSeatsModel
                  //                                               ?.busSeatDetails
                  //                                               ?.busDetails
                  //                                               ?.rowList?[i]
                  //                                               .seats[j]
                  //                                               .isReserved ==
                  //                                           true ||
                  //                                       busSeatsModel
                  //                                               ?.busSeatDetails
                  //                                               ?.busDetails
                  //                                               ?.rowList?[i]
                  //                                               .seats[j]
                  //                                               .isAvailable ==
                  //                                           true) {
                  //                                     busSeatsModel
                  //                                             ?.busSeatDetails
                  //                                             ?.busDetails
                  //                                             ?.rowList?[i]
                  //                                             .seats[j]
                  //                                             .seatState =
                  //                                         SeatState.sold;
                  //                                   }
                  //
                  //                                   for (var n = 0;
                  //                                       n <
                  //                                           Ticketreservation
                  //                                               .Seatsnumbers1
                  //                                               .length;
                  //                                       n++) {
                  //                                     if (busSeatsModel
                  //                                             ?.busSeatDetails
                  //                                             ?.busDetails
                  //                                             ?.rowList?[i]
                  //                                             .seats[j]
                  //                                             .seatNo ==
                  //                                         Ticketreservation
                  //                                             .Seatsnumbers1[n]) {
                  //                                       busSeatsModel
                  //                                               ?.busSeatDetails
                  //                                               ?.busDetails
                  //                                               ?.rowList?[i]
                  //                                               .seats[j]
                  //                                               .seatState =
                  //                                           SeatState.booked;
                  //                                     }
                  //                                   }
                  //                                 }
                  //                               }
                  //
                  //                               setState(() {});
                  //                             }
                  //
                  //                             showGeneralDialog(
                  //                                 context: context,
                  //                                 barrierDismissible: true,
                  //                                 barrierLabel:
                  //                                     MaterialLocalizations.of(
                  //                                             context)
                  //                                         .modalBarrierDismissLabel,
                  //                                 barrierColor:
                  //                                     Colors.black.withOpacity(0.5),
                  //                                 transitionDuration:
                  //                                     const Duration(
                  //                                         milliseconds: 200),
                  //                                 pageBuilder: (context,
                  //                                     Animation<double> animation,
                  //                                     Animation<double>
                  //                                         secondaryAnimation) {
                  //                                   return Material(
                  //                                     child: SafeArea(
                  //                                       child: Column(
                  //                                         mainAxisAlignment:
                  //                                             MainAxisAlignment
                  //                                                 .start,
                  //                                         crossAxisAlignment:
                  //                                             CrossAxisAlignment
                  //                                                 .center,
                  //                                         children: [
                  //                                           InkWell(
                  //                                             onTap: () {
                  //                                               Navigator.pop(
                  //                                                   context);
                  //                                             },
                  //                                             child: Container(
                  //                                               padding:
                  //                                                   EdgeInsets.all(
                  //                                                       10),
                  //                                               alignment: Alignment
                  //                                                   .topLeft,
                  //                                               child: Icon(
                  //                                                 Icons.close,
                  //                                                 color: AppColors
                  //                                                     .primaryColor,
                  //                                               ),
                  //                                             ),
                  //                                           ),
                  //                                           Expanded(
                  //                                             child: Row(
                  //                                               mainAxisAlignment:
                  //                                                   MainAxisAlignment
                  //                                                       .center,
                  //                                               crossAxisAlignment:
                  //                                                   CrossAxisAlignment
                  //                                                       .center,
                  //                                               children: [
                  //                                                 SeatLayoutWidget(
                  //                                                   seatHeight:
                  //                                                       sizeHeight *
                  //                                                           .036,
                  //                                                   onSeatStateChanged:
                  //                                                       (rowI,
                  //                                                           colI,
                  //                                                           seatState,
                  //                                                           seat) {},
                  //                                                   stateModel:
                  //                                                       SeatLayoutStateModel(
                  //                                                     rows: busSeatsModel
                  //                                                             ?.busSeatDetails
                  //                                                             ?.busDetails
                  //                                                             ?.rowList
                  //                                                             ?.length ??
                  //                                                         0,
                  //                                                     cols: busSeatsModel
                  //                                                             ?.busSeatDetails
                  //                                                             ?.busDetails
                  //                                                             ?.totalColumn ??
                  //                                                         5,
                  //                                                     seatSvgSize: 30
                  //                                                         .sp
                  //                                                         .toInt(),
                  //                                                     pathSelectedSeat:
                  //                                                         'assets/images/unavailable_seats.svg',
                  //                                                     pathDisabledSeat:
                  //                                                         'assets/images/unavailable_seats.svg',
                  //                                                     pathSoldSeat:
                  //                                                         'assets/images/disabled_seats.svg',
                  //                                                     pathUnSelectedSeat:
                  //                                                         'assets/images/unavailable_seats.svg',
                  //                                                     currentSeats:
                  //                                                         List.generate(
                  //                                                       busSeatsModel
                  //                                                               ?.busSeatDetails
                  //                                                               ?.busDetails
                  //                                                               ?.rowList
                  //                                                               ?.length ??
                  //                                                           0,
                  //
                  //                                                       // Number of rows based on totalSeats
                  //                                                       (row) => busSeatsModel!
                  //                                                           .busSeatDetails!
                  //                                                           .busDetails!
                  //                                                           .rowList![
                  //                                                               row]
                  //                                                           .seats,
                  //                                                     ),
                  //                                                   ),
                  //                                                 ),
                  //                                               ],
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                   );
                  //                                 });
                  //                           });
                  //                         },
                  //                         child: Row(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.start,
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.center,
                  //                           children: [
                  //                             Container(
                  //                               width: 14,
                  //                               height: 14,
                  //                               alignment: Alignment.center,
                  //                               child: Image.asset(
                  //                                   "assets/images/img_1.png"
                  //                                   // color: Color(0xff007663),
                  //                                   ),
                  //                             ),
                  //                             SizedBox(
                  //                               width: 5,
                  //                             ),
                  //                             Text(
                  //                               ' ${Ticketreservation.Seatsnumbers1.length.toString()} ${LanguageClass.isEnglish ? ' Seats' : ' كرسي'}',
                  //                               style: fontStyle(
                  //                                   color: AppColors.grey
                  //                                       .withValues(alpha: 0.8),
                  //                                   fontFamily: FontFamily.medium,
                  //                                   fontSize: 12.sp),
                  //                             )
                  //                           ],
                  //                         ),
                  //                       ),
                  //                       SizedBox(
                  //                         height: 10,
                  //                       ),
                  //                       Container(
                  //                         alignment: LanguageClass.isEnglish
                  //                             ? Alignment.centerRight
                  //                             : Alignment.centerLeft,
                  //                         child: InkWell(
                  //                           onTap: () {
                  //                             Navigator.push(
                  //                               context,
                  //                               MaterialPageRoute(
                  //                                   builder: (context) {
                  //                                 return BlocProvider(
                  //                                   create: (context) =>
                  //                                       BusLayoutCubit(),
                  //                                   child: BusLayoutScreen(
                  //                                     isedit: true,
                  //                                     busdate: DateTime.parse(
                  //                                         Ticketreservation
                  //                                             .accessDate1),
                  //                                     arrivalDate: DateTime.parse(
                  //                                         Ticketreservation
                  //                                             .arrivaldate1!),
                  //                                     busttime: Ticketreservation
                  //                                         .accessBusTime1,
                  //                                     to: Ticketreservation
                  //                                             .tocitystation1 ??
                  //                                         "",
                  //                                     from: Ticketreservation
                  //                                             .fromcitystation1 ??
                  //                                         "",
                  //                                     triTypeId: widget.tripTypeId,
                  //                                     tripListBack:
                  //                                         widget.tripListBack,
                  //                                     price: Ticketreservation
                  //                                         .priceticket1,
                  //                                     user: Routes.user,
                  //                                     tripId:
                  //                                         Ticketreservation.tripid1,
                  //                                     tocity: Ticketreservation
                  //                                             .tocity1 ??
                  //                                         '',
                  //                                     fromcity: Ticketreservation
                  //                                             .fromcity2 ??
                  //                                         '',
                  //                                     discount: Ticketreservation
                  //                                         .discount,
                  //                                   ),
                  //                                 );
                  //                               }),
                  //                             ).then((value) {
                  //                               setState(() {});
                  //                             });
                  //                           },
                  //                           child: Container(
                  //                             padding: EdgeInsets.symmetric(
                  //                                 horizontal: 15, vertical: 10),
                  //                             decoration: BoxDecoration(
                  //                                 boxShadow: [
                  //                                   BoxShadow(
                  //                                       color: AppColors.white,
                  //                                       offset: Offset(0, 0),
                  //                                       spreadRadius: 0,
                  //                                       blurRadius: 15)
                  //                                 ],
                  //                                 color: AppColors.white,
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(8)),
                  //                             child: Text(
                  //                               LanguageClass.isEnglish
                  //                                   ? 'Edit '
                  //                                   : 'تعديل ',
                  //                               style: fontStyle(
                  //                                 color: AppColors.primaryColor,
                  //                                 fontWeight: FontWeight.bold,
                  //                                 fontFamily: FontFamily.medium,
                  //                                 fontSize: 12.sp,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       Spacer(),
                  //                       Container(
                  //                         alignment: LanguageClass.isEnglish
                  //                             ? Alignment.bottomRight
                  //                             : Alignment.bottomLeft,
                  //                         child: Text(
                  //                           Ticketreservation.elite1,
                  //                           style: fontStyle(
                  //                               fontFamily: FontFamily.bold,
                  //                               fontSize: 14.sp,
                  //                               // color: Color(0xfff7f8f9)
                  //                               color: AppColors.primaryColor),
                  //                         ),
                  //                       ),
                  //                       SizedBox(
                  //                         height: 15,
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   SizedBox(
                  //                     width: 15,
                  //                   ),
                  //                 ],
                  //               ))
                  //             ],
                  //           ),
                  //         ),
                  //       )
                  : Expanded(
                      flex: selected.isEven ? 7 : 1,
                      child: ListView.builder(
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
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                        borderRadius: selected != index
                                            ? BorderRadius.circular(10)
                                            : BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                        color: AppColors.white
                                        // color: Color(0xffF3F3F3)
                                        ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10.0),
                                    // padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xfffd634f),
                                                Color(0xffff9976),
                                              ],
                                            ),
                                          ),
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? "Enjoy for less with ${widget.tripList[index].companyName}"
                                                        : "استمتع بتكلفة أقل مع حافلات ${widget.tripList[index].companyName}",
                                                    style: fontStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            FontFamily.bold,
                                                        fontSize: 12.sp),
                                                  ),
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? "Unbeatable trips deals with ${widget.tripList[index].companyName}! "
                                                        : "عروض رحلات لا تُضاهى مع ${widget.tripList[index].companyName}!",
                                                    style: fontStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontSize: 10.sp),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                LanguageClass.isEnglish
                                                    ? "Sponsored"
                                                    : "ممول",
                                                style: fontStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        FontFamily.regular,
                                                    fontSize: 12.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // todo : logo and provider name
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 6),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    height: 38,
                                                    width: 38,
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Image.network(
                                                      widget.tripList[index]
                                                              .logo ??
                                                          "https://play-lh.googleusercontent.com/ACfnkQHBH_KBNpqhaU2PkbNp1mcLeZtaOHHvKTSDHBEOD43QH9gB9nd5GQkWpfB9n7M=w480-h960-rw",
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    widget.tripList[index]
                                                            .companyName ??
                                                        (LanguageClass.isEnglish
                                                            ? "Swa"
                                                            : "سوا"),
                                                    style: fontStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        fontSize: 12.sp),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: Color(0xffFC9900),
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                    "4.5",
                                                    style: fontStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        height: 0,
                                                        fontSize: 12.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            Expanded(
                                                flex: 3,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  spacing: 10,
                                                  children: [
                                                    Card(
                                                      margin: EdgeInsets.zero,
                                                      elevation: 0.0,
                                                      color: Color(0xff05488F),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                        bottomRight:
                                                            Radius.circular(6),
                                                        bottomLeft:
                                                            Radius.circular(6),
                                                      )),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 6.0,
                                                                vertical: 2),
                                                        child: Center(
                                                            child: Text(
                                                          "Cheapest",
                                                          style: fontStyle(
                                                              fontSize: 10.sp,
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                      ),
                                                    ),
                                                    Card(
                                                      margin: EdgeInsets.zero,
                                                      elevation: 0.0,
                                                      color: AppColors
                                                          .primaryColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                        bottomRight:
                                                            Radius.circular(6),
                                                        bottomLeft:
                                                            Radius.circular(6),
                                                      )),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 6.0,
                                                                vertical: 2),
                                                        child: Center(
                                                            child: Text(
                                                          "Best Value",
                                                          style: fontStyle(
                                                              fontSize: 10.sp,
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 0,
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                        // todo : details from to
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                spacing: 5,
                                                children: [
                                                  Text(
                                                    widget
                                                        .tripList[index].from!,
                                                    style: fontStyle(
                                                        color:
                                                            Color(0xff858585),
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontSize: 10.sp),
                                                  ),
                                                  Text(
                                                    intl.DateFormat('hh:mm a')
                                                        .format(widget
                                                            .tripList[index]
                                                            .accessDate!)
                                                        .toString(),
                                                    style: fontStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        fontSize: 10.sp),
                                                  ),
                                                  Text(
                                                    intl.DateFormat(
                                                            'dd MMMM yyyy',
                                                            LanguageClass
                                                                    .isEnglish
                                                                ? 'en'
                                                                : 'ar')
                                                        .format(widget
                                                            .tripList[index]
                                                            .accessDate!)
                                                        .toString(),
                                                    style: fontStyle(
                                                        color:
                                                            Color(0xff858585),
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontSize: 7.sp),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              RotatedBox(
                                                quarterTurns:
                                                    LanguageClass.isEnglish
                                                        ? 90
                                                        : 90,
                                                child: Stack(
                                                  // alignment: Alignment.centerLeft,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 1,
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          right: 10,
                                                          left: 10,
                                                          bottom: 5),
                                                      color: Color(0xff000000),
                                                      // child: Icon(
                                                      //   Icons.arrow_right_alt_rounded,
                                                      //   size: 30,
                                                      // ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top: 2.3,
                                                        right: LanguageClass
                                                                .isEnglish
                                                            ? 0
                                                            : 2,
                                                        left: LanguageClass
                                                                .isEnglish
                                                            ? 2
                                                            : 0,
                                                      ),
                                                      child: Icon(
                                                        LanguageClass.isEnglish
                                                            ? Icons
                                                                .keyboard_arrow_left_rounded
                                                            : Icons
                                                                .keyboard_arrow_right_rounded,
                                                        size: 15.5,
                                                        color:
                                                            Color(0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                spacing: 5,
                                                children: [
                                                  Text(
                                                    widget.tripList[index].to!,
                                                    style: fontStyle(
                                                        color:
                                                            Color(0xff858585),
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontSize: 10.sp),
                                                  ),
                                                  Text(
                                                    intl.DateFormat('hh:mm a')
                                                        .format(widget
                                                            .tripList[index]
                                                            .arrivalDate!)
                                                        .toString(),
                                                    style: fontStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        fontSize: 10.sp),
                                                  ),
                                                  Text(
                                                    intl.DateFormat(
                                                            'dd MMMM yyyy',
                                                            LanguageClass
                                                                    .isEnglish
                                                                ? 'en'
                                                                : 'ar')
                                                        .format(widget
                                                            .tripList[index]
                                                            .arrivalDate!),
                                                    style: fontStyle(
                                                        color:
                                                            Color(0xff858585),
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontSize: 7.sp),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                // fit: FlexFit.loose,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  spacing: 5,
                                                  children: [
                                                    Text(
                                                      '${widget.tripList[index].price.toString()} ${Routes.curruncy ?? ""}',
                                                      style: fontStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontSize: 12.sp),
                                                    ),
                                                    // SizedBox(
                                                    //   height: 10,
                                                    // ),
                                                    Row(
                                                      spacing: 5,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        // SvgPicture.asset(
                                                        //   "assets/images/disabled_seats.svg",
                                                        //   height: 15,
                                                        //   width: 15,
                                                        // ),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 0.0),
                                                            child: Image.asset(
                                                              "assets/images/img_1.png",
                                                              width: 20,
                                                              height: 20,
                                                              filterQuality:
                                                                  FilterQuality
                                                                      .high,
                                                            )),
                                                        Text(
                                                          LanguageClass
                                                                  .isEnglish
                                                              ? '${widget.tripList[index].emptySeat}'
                                                              : '${widget.tripList[index].emptySeat}',
                                                          style: fontStyle(
                                                              color: AppColors
                                                                  .grey,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .medium,
                                                              fontSize: 13.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    8.verticalSpace,
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                selected == index
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            // color: Color(0xffF3F3F3),
                                            color: AppColors.white,
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            )),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 230,
                                              width: double.infinity,
                                              child: Image.asset(
                                                "assets/images/img.png",
                                                fit: BoxFit.cover,
                                              ),
                                              //     MapRouteWidget(
                                              //   routePoints: [
                                              //     // LatLng(30.0444, 31.2357),
                                              //     // LatLng(31.2001, 29.9187),
                                              //     LatLng(30.0, 31.0),
                                              //     LatLng(31.0, 30.0),
                                              //   ],
                                              //   googleApiKey:
                                              //       'AIzaSyAipdrKwqPfmyfmzhZG1PZJJ8J61SM14i8',
                                              //   useDirections: true,
                                              // )
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 5,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0),
                                                        child: ListView.builder(
                                                          itemCount: widget
                                                              .tripList[index]
                                                              .lineCity
                                                              .length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              ScrollPhysics(),
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index2) {
                                                            final date = now
                                                                .add(Duration(
                                                                    days:
                                                                        index2));
                                                            final time = intl
                                                                .DateFormat(
                                                              'h:mm a',
                                                              LanguageClass
                                                                      .isEnglish
                                                                  ? 'en'
                                                                  : 'ar',
                                                            ).format(date.add(
                                                                Duration(
                                                                    hours:
                                                                        index2)));
                                                            return Container(
                                                              color: AppColors
                                                                  .white,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 70,
                                                                    child: Text(
                                                                      // '${widget.tripList[index].lineCity[index2].lineStationList.first.accessTime!.split(':')[0]}:${widget.tripList[index].lineCity[index2].lineStationList.first.accessTime!.split(':')[1]}' ??
                                                                      time,
                                                                      style: fontStyle(
                                                                          color: AppColors
                                                                              .blackColor,
                                                                          fontFamily: FontFamily
                                                                              .medium,
                                                                          height:
                                                                              0.5,
                                                                          fontSize:
                                                                              12.sp),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            13,
                                                                        width:
                                                                            13,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        padding: index2 ==
                                                                                0
                                                                            ? EdgeInsets.all(1.2)
                                                                            : EdgeInsets.zero,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          border:
                                                                              Border.all(
                                                                            style:
                                                                                BorderStyle.solid,
                                                                            color: index2 == 0
                                                                                ? Color(0xff007663)
                                                                                : Colors.transparent,
                                                                            width: index2 == 0
                                                                                ? 1
                                                                                : 0.0,
                                                                          ),
                                                                        ),
                                                                        child: index2 ==
                                                                                widget.tripList[index].lineCity.length - 1
                                                                            ? Icon(
                                                                                CupertinoIcons.location_solid,
                                                                                size: 15,
                                                                                color: Color(0xff7700FF),
                                                                              )
                                                                            : Container(
                                                                                height: 11,
                                                                                width: 11,
                                                                                decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  color: Colors.red,
                                                                                ),
                                                                                child: Icon(
                                                                                  Icons.circle,
                                                                                  size: 4,
                                                                                  color: Colors.white,
                                                                                )),
                                                                      ),
                                                                      index2 ==
                                                                              widget.tripList[index].lineCity.length -
                                                                                  1
                                                                          ? SizedBox
                                                                              .shrink()
                                                                          : Container(
                                                                              height: 20,
                                                                              width: 1.1,
                                                                              color: AppColors.blackColor,
                                                                            )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  Text(
                                                                    '${widget.tripList[index].lineCity[index2].cityName}' ??
                                                                        '',
                                                                    style: fontStyle(
                                                                        color: AppColors
                                                                            .blackColor,
                                                                        fontFamily:
                                                                            FontFamily
                                                                                .bold,
                                                                        decoration: index2 ==
                                                                                0
                                                                            ? TextDecoration
                                                                                .underline
                                                                            : TextDecoration
                                                                                .none,
                                                                        height:
                                                                            0.5,
                                                                        fontSize:
                                                                            12.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 25,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        child: Text(
                                                          'Premuim • AC • Bus',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: fontStyle(
                                                            color: Color(
                                                                0xff888888),
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontFamily:
                                                                FontFamily
                                                                    .regular,
                                                            fontSize: 9.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      // SizedBox(
                                                      //   height: 10,
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    _buildFilterCard(
                                                      onTap: () {},
                                                      icon: Icons
                                                          .directions_car_filled,
                                                      iconColor:
                                                          Color(0xff007663),
                                                      title: (LanguageClass
                                                              .isEnglish)
                                                          ? "20 min"
                                                          : "20 دقيقة",
                                                      padding: EdgeInsets.zero,
                                                      iconCustom: true,
                                                      widget: Icon(
                                                        Icons
                                                            .directions_car_filled,
                                                        color:
                                                            Color(0xff007663),
                                                        size: 15,
                                                      ),
                                                      textStyle: fontStyle(
                                                          color:
                                                              Color(0xff717171),
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontSize: 11.sp),
                                                    ),
                                                    _buildFilterCard(
                                                      onTap: () {},
                                                      icon:
                                                          Icons.directions_walk,
                                                      iconColor:
                                                          Color(0xff007663),
                                                      title: (LanguageClass
                                                              .isEnglish)
                                                          ? "20 min"
                                                          : "20 دقيقة",
                                                      padding: EdgeInsets.zero,
                                                      iconCustom: true,
                                                      widget: Icon(
                                                        Icons.directions_walk,
                                                        color:
                                                            Color(0xff007663),
                                                        size: 15,
                                                      ),
                                                      textStyle: fontStyle(
                                                          color:
                                                              Color(0xff717171),
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontSize: 11.sp),
                                                    ),
                                                    SizedBox(
                                                      height: sizeHeight * 0.07,
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: InkWell(
                                                        onTap: () {
                                                          CacheHelper
                                                              .setDataToSharedPref(
                                                                  key:
                                                                      'numberTrip',
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
                                                          CacheHelper.setDataToSharedPref(
                                                              key:
                                                                  'accessBusTime',
                                                              value: widget
                                                                  .tripList[
                                                                      index]
                                                                  .accessBusTime);
                                                          CacheHelper.setDataToSharedPref(
                                                              key:
                                                                  'accessBusDate',
                                                              value: widget
                                                                  .tripList[
                                                                      index]
                                                                  .accessDate
                                                                  .toString());

                                                          CacheHelper.setDataToSharedPref(
                                                              key:
                                                                  'arrivaldate',
                                                              value: widget
                                                                  .tripList[
                                                                      index]
                                                                  .arrivalDate
                                                                  .toString());
                                                          CacheHelper
                                                              .setDataToSharedPref(
                                                                  key:
                                                                      'lineName',
                                                                  value: widget
                                                                      .tripList[
                                                                          index]
                                                                      .lineName);
                                                          CacheHelper.setDataToSharedPref(
                                                              key: 'tripOneId',
                                                              value: widget
                                                                      .tripList[
                                                                          index]
                                                                      .tripId ??
                                                                  0);

                                                          CacheHelper.setDataToSharedPref(
                                                              key: 'lineid',
                                                              value: widget
                                                                      .tripList[
                                                                          index]
                                                                      .lineId ??
                                                                  0);

                                                          CacheHelper.setDataToSharedPref(
                                                              key:
                                                                  'serviceTypeID',
                                                              value: widget
                                                                      .tripList[
                                                                          index]
                                                                      .serviceTypeId ??
                                                                  0);

                                                          CacheHelper.setDataToSharedPref(
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
                                                                builder:
                                                                    (context) {
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
                                                                  arrivalDate: widget
                                                                      .tripList[
                                                                          index]
                                                                      .arrivalDate,
                                                                  busttime: widget
                                                                      .tripList[
                                                                          index]
                                                                      .accessBusTime,
                                                                  discount: widget
                                                                      .tripList[
                                                                          index]
                                                                      .discount,
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
                                                                  tripListBack:
                                                                      widget
                                                                          .tripListBack,
                                                                  price: widget
                                                                      .tripList[
                                                                          index]
                                                                      .price!,
                                                                  user: Routes
                                                                      .user,
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
                                                              availability:
                                                                  widget
                                                                      .tripList[
                                                                          index]
                                                                      .emptySeat,
                                                              busId: widget
                                                                  .tripList[
                                                                      index]
                                                                  .busId,
                                                              from: widget
                                                                  .tripList[
                                                                      index]
                                                                  .fromCityName,
                                                              fromStationName:
                                                                  widget
                                                                      .tripList[
                                                                          index]
                                                                      .from,
                                                              to: widget
                                                                  .tripList[
                                                                      index]
                                                                  .toCityName,
                                                              isActive: true,
                                                              isDelete: widget
                                                                  .tripList[
                                                                      index]
                                                                  .isDeleted,
                                                              isAddedTrip: true,
                                                              lineId: widget
                                                                  .tripList[
                                                                      index]
                                                                  .lineId,
                                                              notes: '',
                                                              priceSeat: widget
                                                                  .tripList[
                                                                      index]
                                                                  .price,
                                                              toStationName: widget
                                                                  .tripList[index]
                                                                  .to,
                                                              tripDate: '${intl.DateFormat.d('en_US').format(widget.tripList[index].accessDate!)}${intl.DateFormat.MMM('en_US').format(widget.tripList[index].accessDate!)}',
                                                              isreserved: false,
                                                              tripId: widget.tripList[index].tripId,
                                                              personCountReserved: 0,
                                                              serviceTypeId: widget.tripList[index].serviceTypeId,
                                                              tripTime: widget.tripList[index].accessBusTime.toString(),
                                                              fromStationId: null,
                                                              toStationId: null,
                                                              tripUmrahTransportationId: null,
                                                              reservationId: null));
                                                        },
                                                        child: Container(
                                                          height: 32.sp,
                                                          width: LanguageClass
                                                                  .isEnglish
                                                              ? 64.sp
                                                              : 48.sp,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 8),
                                                          decoration: BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: AppColors
                                                                        .white,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            0),
                                                                    spreadRadius:
                                                                        0,
                                                                    blurRadius:
                                                                        8)
                                                              ],
                                                              color: AppColors
                                                                  .white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Center(
                                                            child: Text(
                                                              LanguageClass
                                                                      .isEnglish
                                                                  ? 'Book'
                                                                  : 'حجز',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: fontStyle(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .medium,
                                                                fontSize: 12.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            );
                          })),

              /// todo :  [  part for round trip  ]
              // widget.tripTypeId == '2'
              //     ? Container(
              //         padding:
              //             EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              //         child: Text(
              //           LanguageClass.isEnglish ? "Back trips" : "رحلات العودة",
              //           textAlign: LanguageClass.isEnglish
              //               ? TextAlign.left
              //               : TextAlign.right,
              //           style: fontStyle(
              //               color: Colors.black,
              //               fontFamily: FontFamily.medium,
              //               fontSize: 16.sp),
              //         ),
              //       )
              //     : SizedBox(),
              (widget.tripTypeId == '2' &&
                      Ticketreservation.Seatsnumbers1.isNotEmpty)
                  ?
                  // Ticketreservation.Seatsnumbers2.isNotEmpty
                  //         ? Flexible(
                  //             child: Container(
                  //               margin: EdgeInsets.symmetric(horizontal: 16.w),
                  //               padding: EdgeInsets.all(15),
                  //               width: double.infinity,
                  //               height: 150.h,
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(12),
                  //                   color: Color(0xffFF5D4B)),
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.start,
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Expanded(
                  //                       flex: 2,
                  //                       child: Column(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.start,
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           // Text(
                  //                           //   LanguageClass.isEnglish
                  //                           //       ? "Departure "
                  //                           //       : "تغادر في",
                  //                           //   style: const fontStyle(
                  //                           //       color: Colors.white,
                  //                           //       fontFamily: "bold",
                  //                           //       fontSize: 23),
                  //                           // ),
                  //
                  //                           Expanded(
                  //                               child: Row(
                  //                             children: [
                  //                               Column(
                  //                                 mainAxisAlignment:
                  //                                     MainAxisAlignment.center,
                  //                                 crossAxisAlignment:
                  //                                     CrossAxisAlignment.start,
                  //                                 children: [
                  //                                   Text(
                  //                                     LanguageClass.isEnglish
                  //                                         ? "Departure"
                  //                                         : "تغادر في",
                  //                                     style: fontStyle(
                  //                                         color: Colors.white,
                  //                                         fontFamily:
                  //                                             FontFamily.bold,
                  //                                         fontSize: 13.sp),
                  //                                   ),
                  //                                   Text(
                  //                                     intl.DateFormat('dd-MM-yyyy')
                  //                                         .format(DateTime.parse(
                  //                                             Ticketreservation
                  //                                                 .accessDate2))
                  //                                         .toString(),
                  //                                     style: fontStyle(
                  //                                         color: Colors.white,
                  //                                         fontFamily:
                  //                                             FontFamily.medium,
                  //                                         fontSize: 11.sp),
                  //                                   ),
                  //                                   Text(
                  //                                     intl.DateFormat('hh:mm a')
                  //                                         .format(DateTime.parse(
                  //                                             Ticketreservation
                  //                                                 .accessDate2))
                  //                                         .toString(),
                  //                                     style: fontStyle(
                  //                                         color: Colors.white,
                  //                                         fontFamily:
                  //                                             FontFamily.medium,
                  //                                         fontSize: 11.sp),
                  //                                   ),
                  //                                   Ticketreservation
                  //                                               .arrivaldate2 ==
                  //                                           null
                  //                                       ? Container()
                  //                                       : Column(
                  //                                           mainAxisAlignment:
                  //                                               MainAxisAlignment
                  //                                                   .center,
                  //                                           crossAxisAlignment:
                  //                                               CrossAxisAlignment
                  //                                                   .start,
                  //                                           children: [
                  //                                               10.verticalSpace,
                  //                                               Text(
                  //                                                 LanguageClass
                  //                                                         .isEnglish
                  //                                                     ? "Arrival"
                  //                                                     : "الوصول",
                  //                                                 style: fontStyle(
                  //                                                     color: Colors
                  //                                                         .white,
                  //                                                     fontFamily:
                  //                                                         FontFamily
                  //                                                             .bold,
                  //                                                     fontSize:
                  //                                                         13.sp),
                  //                                               ),
                  //                                               Text(
                  //                                                 intl.DateFormat(
                  //                                                         'dd-MM-yyyy')
                  //                                                     .format(DateTime.parse(
                  //                                                         Ticketreservation
                  //                                                             .arrivaldate2!))
                  //                                                     .toString(),
                  //                                                 style: fontStyle(
                  //                                                     color: Colors
                  //                                                         .white,
                  //                                                     fontFamily:
                  //                                                         FontFamily
                  //                                                             .medium,
                  //                                                     fontSize:
                  //                                                         11.sp),
                  //                                               ),
                  //                                               Text(
                  //                                                 intl.DateFormat(
                  //                                                         'hh:mm a')
                  //                                                     .format(DateTime.parse(
                  //                                                         Ticketreservation
                  //                                                             .arrivaldate2!))
                  //                                                     .toString(),
                  //                                                 style: fontStyle(
                  //                                                     color: Colors
                  //                                                         .white,
                  //                                                     fontFamily:
                  //                                                         FontFamily
                  //                                                             .medium,
                  //                                                     fontSize:
                  //                                                         11.sp),
                  //                                               ),
                  //                                             ])
                  //                                 ],
                  //                               ),
                  //                               SizedBox(
                  //                                 width: 5,
                  //                               ),
                  //                               Container(
                  //                                 width: 5,
                  //                                 decoration: BoxDecoration(
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(2),
                  //                                     gradient: LinearGradient(
                  //                                         begin:
                  //                                             Alignment.topCenter,
                  //                                         end: Alignment
                  //                                             .bottomCenter,
                  //                                         colors: [
                  //                                           AppColors.white,
                  //                                           AppColors.yellow2
                  //                                         ])),
                  //                               ),
                  //                               SizedBox(
                  //                                 width: 10,
                  //                               ),
                  //                               Expanded(
                  //                                 child: Column(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment.start,
                  //                                   crossAxisAlignment:
                  //                                       CrossAxisAlignment.start,
                  //                                   children: [
                  //                                     Text(
                  //                                       LanguageClass.isEnglish
                  //                                           ? "From"
                  //                                           : "من",
                  //                                       style: fontStyle(
                  //                                           color: Colors.white,
                  //                                           fontFamily:
                  //                                               FontFamily.bold,
                  //                                           fontSize: 12),
                  //                                     ),
                  //                                     Text(
                  //                                       Ticketreservation
                  //                                           .fromcitystation2,
                  //                                       style: fontStyle(
                  //                                           color: Colors.white,
                  //                                           fontFamily:
                  //                                               FontFamily.bold,
                  //                                           fontSize: 12.sp),
                  //                                     ),
                  //                                     SizedBox(
                  //                                       height: 5,
                  //                                     ),
                  //                                     Text(
                  //                                       LanguageClass.isEnglish
                  //                                           ? "To"
                  //                                           : "الي",
                  //                                       style: fontStyle(
                  //                                           color: Colors.white,
                  //                                           fontFamily:
                  //                                               FontFamily.bold,
                  //                                           fontSize: 12),
                  //                                     ),
                  //                                     Text(
                  //                                       Ticketreservation
                  //                                           .tocitystation2,
                  //                                       style: fontStyle(
                  //                                           color: Colors.white,
                  //                                           fontFamily:
                  //                                               FontFamily.bold,
                  //                                           fontSize: 12.sp),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               )
                  //                             ],
                  //                           )),
                  //
                  //                           Text(
                  //                             "${Routes.curruncy ?? ""} ${(Ticketreservation.countSeats2.length * Ticketreservation.priceticket2)}",
                  //                             style: fontStyle(
                  //                                 color: Colors.white,
                  //                                 fontFamily: FontFamily.bold,
                  //                                 fontSize: 12.sp),
                  //                           ),
                  //                         ],
                  //                       )),
                  //                   Expanded(
                  //                       child: Column(
                  //                     mainAxisAlignment: MainAxisAlignment.start,
                  //                     crossAxisAlignment: CrossAxisAlignment.end,
                  //                     children: [
                  //                       Row(
                  //                         mainAxisAlignment: MainAxisAlignment.end,
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.center,
                  //                         children: [
                  //                           Container(
                  //                             width: 14,
                  //                             height: 14,
                  //                             alignment: Alignment.center,
                  //                             child: Image.asset(
                  //                                 "assets/images/Icon fa-solid-bus.png"),
                  //                           ),
                  //                           SizedBox(
                  //                             width: 5,
                  //                           ),
                  //                           Text(
                  //                             Ticketreservation.numbertrip2
                  //                                 .toString(),
                  //                             style: fontStyle(
                  //                                 color: Colors.white,
                  //                                 fontFamily: FontFamily.bold,
                  //                                 fontSize: 14.sp),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       InkWell(
                  //                         onTap: () {
                  //                           busLayoutRepo
                  //                               .getBusSeatsData(
                  //                                   tripId:
                  //                                       Ticketreservation.tripid2)
                  //                               .then((value) async {
                  //                             busSeatsModel = await value;
                  //
                  //                             if (busSeatsModel != null) {
                  //                               for (int i = 0;
                  //                                   i <
                  //                                       busSeatsModel!
                  //                                           .busSeatDetails!
                  //                                           .busDetails!
                  //                                           .totalRow!;
                  //                                   i++) {
                  //                                 for (int j = 0;
                  //                                     j <
                  //                                         busSeatsModel!
                  //                                             .busSeatDetails!
                  //                                             .busDetails!
                  //                                             .rowList![i]
                  //                                             .seats
                  //                                             .length;
                  //                                     j++) {
                  //                                   if (busSeatsModel
                  //                                               ?.busSeatDetails
                  //                                               ?.busDetails
                  //                                               ?.rowList?[i]
                  //                                               .seats[j]
                  //                                               .isReserved ==
                  //                                           true ||
                  //                                       busSeatsModel
                  //                                               ?.busSeatDetails
                  //                                               ?.busDetails
                  //                                               ?.rowList?[i]
                  //                                               .seats[j]
                  //                                               .isAvailable ==
                  //                                           true) {
                  //                                     busSeatsModel
                  //                                             ?.busSeatDetails
                  //                                             ?.busDetails
                  //                                             ?.rowList?[i]
                  //                                             .seats[j]
                  //                                             .seatState =
                  //                                         SeatState.sold;
                  //                                   }
                  //
                  //                                   for (var n = 0;
                  //                                       n <
                  //                                           Ticketreservation
                  //                                               .Seatsnumbers2
                  //                                               .length;
                  //                                       n++) {
                  //                                     if (busSeatsModel
                  //                                             ?.busSeatDetails
                  //                                             ?.busDetails
                  //                                             ?.rowList?[i]
                  //                                             .seats[j]
                  //                                             .seatNo ==
                  //                                         Ticketreservation
                  //                                             .Seatsnumbers2[n]) {
                  //                                       busSeatsModel
                  //                                               ?.busSeatDetails
                  //                                               ?.busDetails
                  //                                               ?.rowList?[i]
                  //                                               .seats[j]
                  //                                               .seatState =
                  //                                           SeatState.booked;
                  //                                     }
                  //                                   }
                  //                                 }
                  //                               }
                  //
                  //                               setState(() {});
                  //                             }
                  //
                  //                             showGeneralDialog(
                  //                                 context: context,
                  //                                 barrierDismissible: true,
                  //                                 barrierLabel:
                  //                                     MaterialLocalizations.of(
                  //                                             context)
                  //                                         .modalBarrierDismissLabel,
                  //                                 barrierColor:
                  //                                     Colors.black.withOpacity(0.5),
                  //                                 transitionDuration:
                  //                                     const Duration(
                  //                                         milliseconds: 200),
                  //                                 pageBuilder: (context,
                  //                                     Animation<double> animation,
                  //                                     Animation<double>
                  //                                         secondaryAnimation) {
                  //                                   return Material(
                  //                                     child: SafeArea(
                  //                                       child: Column(
                  //                                         mainAxisAlignment:
                  //                                             MainAxisAlignment
                  //                                                 .start,
                  //                                         crossAxisAlignment:
                  //                                             CrossAxisAlignment
                  //                                                 .center,
                  //                                         children: [
                  //                                           InkWell(
                  //                                             onTap: () {
                  //                                               Navigator.pop(
                  //                                                   context);
                  //                                             },
                  //                                             child: Container(
                  //                                               padding:
                  //                                                   EdgeInsets.all(
                  //                                                       10),
                  //                                               alignment: Alignment
                  //                                                   .topLeft,
                  //                                               child: Icon(
                  //                                                 Icons.close,
                  //                                                 color: AppColors
                  //                                                     .primaryColor,
                  //                                               ),
                  //                                             ),
                  //                                           ),
                  //                                           Expanded(
                  //                                             child: Row(
                  //                                               mainAxisAlignment:
                  //                                                   MainAxisAlignment
                  //                                                       .center,
                  //                                               crossAxisAlignment:
                  //                                                   CrossAxisAlignment
                  //                                                       .center,
                  //                                               children: [
                  //                                                 SeatLayoutWidget(
                  //                                                   seatHeight:
                  //                                                       sizeHeight *
                  //                                                           .036,
                  //                                                   onSeatStateChanged:
                  //                                                       (rowI,
                  //                                                           colI,
                  //                                                           seatState,
                  //                                                           seat) {},
                  //                                                   stateModel:
                  //                                                       SeatLayoutStateModel(
                  //                                                     rows: busSeatsModel
                  //                                                             ?.busSeatDetails
                  //                                                             ?.busDetails
                  //                                                             ?.rowList
                  //                                                             ?.length ??
                  //                                                         0,
                  //                                                     cols: busSeatsModel
                  //                                                             ?.busSeatDetails
                  //                                                             ?.busDetails
                  //                                                             ?.totalColumn ??
                  //                                                         5,
                  //                                                     seatSvgSize: 30
                  //                                                         .sp
                  //                                                         .toInt(),
                  //                                                     pathSelectedSeat:
                  //                                                         'assets/images/unavailable_seats.svg',
                  //                                                     pathDisabledSeat:
                  //                                                         'assets/images/unavailable_seats.svg',
                  //                                                     pathSoldSeat:
                  //                                                         'assets/images/disabled_seats.svg',
                  //                                                     pathUnSelectedSeat:
                  //                                                         'assets/images/unavailable_seats.svg',
                  //                                                     currentSeats:
                  //                                                         List.generate(
                  //                                                       busSeatsModel
                  //                                                               ?.busSeatDetails
                  //                                                               ?.busDetails
                  //                                                               ?.rowList
                  //                                                               ?.length ??
                  //                                                           0,
                  //
                  //                                                       // Number of rows based on totalSeats
                  //                                                       (row) => busSeatsModel!
                  //                                                           .busSeatDetails!
                  //                                                           .busDetails!
                  //                                                           .rowList![
                  //                                                               row]
                  //                                                           .seats,
                  //                                                     ),
                  //                                                   ),
                  //                                                 ),
                  //                                               ],
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                   );
                  //                                 });
                  //                           });
                  //                         },
                  //                         child: Row(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.end,
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.center,
                  //                           children: [
                  //                             Container(
                  //                               width: 14,
                  //                               height: 14,
                  //                               alignment: Alignment.center,
                  //                               child: Image.asset(
                  //                                   "assets/images/chairs.png"),
                  //                             ),
                  //                             SizedBox(
                  //                               width: 5,
                  //                             ),
                  //                             Text(
                  //                               ' ${Ticketreservation.Seatsnumbers2.length.toString()} ${LanguageClass.isEnglish ? ' Seats' : ' كرسي'}',
                  //                               style: fontStyle(
                  //                                   color: AppColors.white,
                  //                                   fontFamily: FontFamily.bold,
                  //                                   fontSize: 14.sp),
                  //                             )
                  //                           ],
                  //                         ),
                  //                       ),
                  //                       SizedBox(
                  //                         height: 10,
                  //                       ),
                  //                       Container(
                  //                         alignment: LanguageClass.isEnglish
                  //                             ? Alignment.centerRight
                  //                             : Alignment.centerLeft,
                  //                         child: InkWell(
                  //                           onTap: () {
                  //                             Navigator.push(
                  //                               context,
                  //                               MaterialPageRoute(
                  //                                   builder: (context) =>
                  //                                       MultiBlocProvider(
                  //                                           providers: [
                  //                                             BlocProvider<
                  //                                                     LoginCubit>(
                  //                                                 create: (context) =>
                  //                                                     sl<LoginCubit>()),
                  //                                             BlocProvider<
                  //                                                 TimesTripsCubit>(
                  //                                               create: (context) =>
                  //                                                   TimesTripsCubit(),
                  //                                             ),
                  //                                             BlocProvider<
                  //                                                 BusLayoutCubit>(
                  //                                               create: (context) =>
                  //                                                   BusLayoutCubit(),
                  //                                             )
                  //                                           ],
                  //                                           // Replace with your actual cubit creation logic
                  //                                           child:
                  //                                               BusLayoutScreenBack(
                  //                                             isedit: true,
                  //                                             arrivaltime: DateTime.parse(
                  //                                                 Ticketreservation
                  //                                                     .arrivaldate2!),
                  //                                             to: Ticketreservation
                  //                                                     .tocitystation2 ??
                  //                                                 "",
                  //                                             from: Ticketreservation
                  //                                                     .fromcitystation2 ??
                  //                                                 "",
                  //                                             triTypeId:
                  //                                                 widget.tripTypeId,
                  //                                             price:
                  //                                                 Ticketreservation
                  //                                                     .priceticket2,
                  //                                             user: Routes.user,
                  //                                             tripId:
                  //                                                 Ticketreservation
                  //                                                     .tripid2,
                  //                                             tocity:
                  //                                                 Ticketreservation
                  //                                                         .tocity2 ??
                  //                                                     '',
                  //                                             fromcity:
                  //                                                 Ticketreservation
                  //                                                         .fromcity2 ??
                  //                                                     '',
                  //                                             busdate: DateTime.parse(
                  //                                                 Ticketreservation
                  //                                                     .accessDate2),
                  //                                             busttime:
                  //                                                 Ticketreservation
                  //                                                     .accessBusTime2,
                  //                                           ))),
                  //                             ).then((value) {
                  //                               setState(() {});
                  //                             });
                  //                           },
                  //                           child: Container(
                  //                             padding: EdgeInsets.symmetric(
                  //                                 horizontal: 15, vertical: 5),
                  //                             decoration: BoxDecoration(
                  //                                 boxShadow: [
                  //                                   BoxShadow(
                  //                                       color: AppColors.white,
                  //                                       offset: Offset(0, 0),
                  //                                       spreadRadius: 0,
                  //                                       blurRadius: 15)
                  //                                 ],
                  //                                 color: AppColors.white,
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(12)),
                  //                             child: Text(
                  //                               LanguageClass.isEnglish
                  //                                   ? 'Edit '
                  //                                   : 'تعديل ',
                  //                               style: fontStyle(
                  //                                 color: AppColors.primaryColor,
                  //                                 fontWeight: FontWeight.bold,
                  //                                 fontFamily: FontFamily.medium,
                  //                                 fontSize: 12.sp,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       Expanded(
                  //                           child: Container(
                  //                         alignment: LanguageClass.isEnglish
                  //                             ? Alignment.bottomRight
                  //                             : Alignment.bottomLeft,
                  //                         child: Text(
                  //                           Ticketreservation.elite2,
                  //                           style: fontStyle(
                  //                               fontFamily: FontFamily.bold,
                  //                               fontSize: 15.sp,
                  //                               color: Color(0xfff7f8f9)),
                  //                         ),
                  //                       ))
                  //                     ],
                  //                   ))
                  //                 ],
                  //               ),
                  //             ),
                  //           )
                  //         :
                  Expanded(
                      flex: selectedback.isEven ? 7 : 1,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: widget.tripListBack?.length,
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
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                        borderRadius: selectedback != index
                                            ? BorderRadius.circular(10)
                                            : BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                        color: AppColors.white
                                        // color: Color(0xffF3F3F3)
                                        ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10.0),
                                    // padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xfffd634f),
                                                Color(0xffff9976),
                                              ],
                                            ),
                                          ),
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? "Enjoy for less with ${widget.tripListBack?[index].companyName}"
                                                        : "استمتع بتكلفة أقل مع حافلات ${widget.tripListBack?[index].companyName}",
                                                    style: fontStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            FontFamily.bold,
                                                        fontSize: 12.sp),
                                                  ),
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? "Unbeatable trips deals with ${widget.tripListBack?[index].companyName}! "
                                                        : "عروض رحلات لا تُضاهى مع ${widget.tripListBack?[index].companyName}!",
                                                    style: fontStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontSize: 10.sp),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                LanguageClass.isEnglish
                                                    ? "Sponsored"
                                                    : "ممول",
                                                style: fontStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        FontFamily.regular,
                                                    fontSize: 12.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // todo : logo and provider name
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 6),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    height: 38,
                                                    width: 38,
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Image.network(
                                                      // "https://play-lh.googleusercontent.com/hN3av1FyuynMPnXhnQsLh3DBPlIki4cxAoO77stXaNjS5PQ0GIBsP1IO4uY6hXWJRw=w480-h960-rw",
                                                      widget
                                                              .tripListBack?[
                                                                  index]
                                                              // .lineCity[index]
                                                              // .lineStationList[
                                                              //     index]
                                                              .logo ??
                                                          "https://play-lh.googleusercontent.com/ACfnkQHBH_KBNpqhaU2PkbNp1mcLeZtaOHHvKTSDHBEOD43QH9gB9nd5GQkWpfB9n7M=w480-h960-rw",
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    widget
                                                            .tripListBack?[
                                                                index]
                                                            // .lineCity[index]
                                                            // .lineStationList[
                                                            //     index]
                                                            .companyName ??
                                                        (LanguageClass.isEnglish
                                                            ? "Swa"
                                                            : "سوا"),
                                                    style: fontStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        fontSize: 12.sp),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: Color(0xffFC9900),
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                    "4.5",
                                                    style: fontStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        height: 0,
                                                        fontSize: 12.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            Expanded(
                                                flex: 3,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  spacing: 10,
                                                  children: [
                                                    Card(
                                                      margin: EdgeInsets.zero,
                                                      elevation: 0.0,
                                                      color: Color(0xff05488F),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                        bottomRight:
                                                            Radius.circular(6),
                                                        bottomLeft:
                                                            Radius.circular(6),
                                                      )),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 6.0,
                                                                vertical: 2),
                                                        child: Center(
                                                            child: Text(
                                                          "Cheapest",
                                                          style: fontStyle(
                                                              fontSize: 10.sp,
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                      ),
                                                    ),
                                                    Card(
                                                      margin: EdgeInsets.zero,
                                                      elevation: 0.0,
                                                      color: AppColors
                                                          .primaryColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                        bottomRight:
                                                            Radius.circular(6),
                                                        bottomLeft:
                                                            Radius.circular(6),
                                                      )),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 6.0,
                                                                vertical: 2),
                                                        child: Center(
                                                            child: Text(
                                                          "Best Value",
                                                          style: fontStyle(
                                                              fontSize: 10.sp,
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 0,
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                        // todo : details from to
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                spacing: 5,
                                                children: [
                                                  Text(
                                                    widget.tripListBack?[index]
                                                            .from! ??
                                                        "",
                                                    style: fontStyle(
                                                        color:
                                                            Color(0xff858585),
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontSize: 10.sp),
                                                  ),
                                                  Text(
                                                    intl.DateFormat('hh:mm a')
                                                        .format(widget
                                                            .tripListBack![
                                                                index]
                                                            .accessDate!)
                                                        .toString(),
                                                    style: fontStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        fontSize: 10.sp),
                                                  ),
                                                  Text(
                                                    intl.DateFormat(
                                                            'dd MMMM yyyy',
                                                            LanguageClass
                                                                    .isEnglish
                                                                ? 'en'
                                                                : 'ar')
                                                        .format(widget
                                                            .tripListBack![
                                                                index]
                                                            .accessDate!)
                                                        .toString(),
                                                    style: fontStyle(
                                                        // color: Color(
                                                        //     0xff858585),
                                                        color:
                                                            Color(0xff858585),
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontSize: 7.sp),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              RotatedBox(
                                                quarterTurns:
                                                    LanguageClass.isEnglish
                                                        ? 90
                                                        : 90,
                                                child: Stack(
                                                  // alignment: Alignment.centerLeft,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 1,
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          right: 10,
                                                          left: 10,
                                                          bottom: 5),
                                                      color: Color(0xff000000),
                                                      // child: Icon(
                                                      //   Icons.arrow_right_alt_rounded,
                                                      //   size: 30,
                                                      // ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top: 2.3,
                                                        right: LanguageClass
                                                                .isEnglish
                                                            ? 0
                                                            : 2,
                                                        left: LanguageClass
                                                                .isEnglish
                                                            ? 2
                                                            : 0,
                                                      ),
                                                      child: Icon(
                                                        LanguageClass.isEnglish
                                                            ? Icons
                                                                .keyboard_arrow_left_rounded
                                                            : Icons
                                                                .keyboard_arrow_right_rounded,
                                                        size: 15.5,
                                                        color:
                                                            Color(0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                spacing: 5,
                                                children: [
                                                  Text(
                                                    widget.tripListBack?[index]
                                                            .to! ??
                                                        "",
                                                    style: fontStyle(
                                                        color:
                                                            Color(0xff858585),
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontSize: 10.sp),
                                                  ),
                                                  Text(
                                                    intl.DateFormat('hh:mm a')
                                                        .format(widget
                                                            .tripListBack![
                                                                index]
                                                            .arrivalDate!)
                                                        .toString(),
                                                    style: fontStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        fontSize: 10.sp),
                                                  ),
                                                  Text(
                                                    intl.DateFormat(
                                                            'dd MMMM yyyy',
                                                            LanguageClass
                                                                    .isEnglish
                                                                ? 'en'
                                                                : 'ar')
                                                        .format(widget
                                                            .tripListBack![
                                                                index]
                                                            .arrivalDate!),
                                                    style: fontStyle(
                                                        color:
                                                            Color(0xff858585),
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontSize: 7.sp),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  spacing: 5,
                                                  children: [
                                                    Text(
                                                      '${widget.tripListBack?[index].price.toString()} ${Routes.curruncy ?? ""}',
                                                      style: fontStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontSize: 12.sp),
                                                    ),
                                                    Row(
                                                      spacing: 5,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 0.0),
                                                            child: Image.asset(
                                                              height: 20,
                                                              width: 20,
                                                              "assets/images/img_1.png",
                                                              filterQuality:
                                                                  FilterQuality
                                                                      .high,
                                                            )),
                                                        Text(
                                                          LanguageClass
                                                                  .isEnglish
                                                              ? '${widget.tripListBack?[index].emptySeat}'
                                                              : '${widget.tripListBack?[index].emptySeat}',
                                                          style: fontStyle(
                                                              color: AppColors
                                                                  .grey,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .medium,
                                                              fontSize: 13.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    8.verticalSpace,
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                selectedback == index
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            // color: Color(0xffF3F3F3),
                                            color: AppColors.white,
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            )),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 230,
                                              width: double.infinity,
                                              child: Image.asset(
                                                "assets/images/img.png",
                                                fit: BoxFit.cover,
                                              ),
                                              //     MapRouteWidget(
                                              //   routePoints: [
                                              //     // LatLng(30.0444, 31.2357),
                                              //     // LatLng(31.2001, 29.9187),
                                              //     LatLng(30.0, 31.0),
                                              //     LatLng(31.0, 30.0),
                                              //   ],
                                              //   googleApiKey:
                                              //       'AIzaSyAipdrKwqPfmyfmzhZG1PZJJ8J61SM14i8',
                                              //   useDirections: true,
                                              // )
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 5,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0),
                                                        child: ListView.builder(
                                                          itemCount: widget
                                                              .tripList[index]
                                                              .lineCity
                                                              .length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              ScrollPhysics(),
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index2) {
                                                            final date = now
                                                                .add(Duration(
                                                                    days:
                                                                        index2));
                                                            final time = intl
                                                                .DateFormat(
                                                              'h:mm a',
                                                              LanguageClass
                                                                      .isEnglish
                                                                  ? 'en'
                                                                  : 'ar',
                                                            ).format(date.add(
                                                                Duration(
                                                                    hours:
                                                                        index2)));
                                                            return Container(
                                                              // padding: EdgeInsets.all(10),
                                                              // color: Color(
                                                              //     0xffF3F3F3),
                                                              color: AppColors
                                                                  .white,
                                                              child: Row(
                                                                // mainAxisAlignment:
                                                                //     MainAxisAlignment
                                                                //         .spaceBetween,

                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 70,
                                                                    child: Text(
                                                                      // '${widget.tripList[index].lineCity[index2].lineStationList.first.accessTime!.split(':')[0]}:${widget.tripList[index].lineCity[index2].lineStationList.first.accessTime!.split(':')[1]}' ??
                                                                      time,
                                                                      style: fontStyle(
                                                                          color: AppColors
                                                                              .blackColor,
                                                                          fontFamily: FontFamily
                                                                              .medium,
                                                                          height:
                                                                              0.5,
                                                                          fontSize:
                                                                              12.sp),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            13,
                                                                        width:
                                                                            13,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        padding: index2 ==
                                                                                0
                                                                            ? EdgeInsets.all(1.2)
                                                                            : EdgeInsets.zero,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          border:
                                                                              Border.all(
                                                                            style:
                                                                                BorderStyle.solid,
                                                                            color: index2 == 0
                                                                                ? Color(0xff007663)
                                                                                : Colors.transparent,
                                                                            width: index2 == 0
                                                                                ? 1
                                                                                : 0.0,
                                                                          ),
                                                                        ),
                                                                        child: index2 ==
                                                                                widget.tripListBack![index].lineCity.length - 1
                                                                            ? Icon(
                                                                                CupertinoIcons.location_solid,
                                                                                size: 15,
                                                                                color: Color(0xff7700FF),
                                                                              )
                                                                            : Container(
                                                                                height: 11,
                                                                                width: 11,
                                                                                decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  color: Colors.red,
                                                                                ),
                                                                                child: Icon(
                                                                                  Icons.circle,
                                                                                  size: 4,
                                                                                  color: Colors.white,
                                                                                )),
                                                                      ),
                                                                      index2 ==
                                                                              widget.tripListBack![index].lineCity.length -
                                                                                  1
                                                                          ? SizedBox
                                                                              .shrink()
                                                                          : Container(
                                                                              height: 20,
                                                                              width: 1.1,
                                                                              color: AppColors.blackColor,
                                                                            )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  Text(
                                                                    '${widget.tripListBack![index].lineCity[index2].cityName}' ??
                                                                        '',
                                                                    style: fontStyle(
                                                                        color: AppColors
                                                                            .blackColor,
                                                                        fontFamily:
                                                                            FontFamily
                                                                                .bold,
                                                                        decoration: index2 ==
                                                                                0
                                                                            ? TextDecoration
                                                                                .underline
                                                                            : TextDecoration
                                                                                .none,
                                                                        height:
                                                                            0.5,
                                                                        fontSize:
                                                                            12.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 25,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        child: Text(
                                                          'Premuim • AC • Bus',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: fontStyle(
                                                            color: Color(
                                                                0xff888888),
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontFamily:
                                                                FontFamily
                                                                    .regular,
                                                            fontSize: 9.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    _buildFilterCard(
                                                      onTap: () {},
                                                      icon: Icons
                                                          .directions_car_filled,
                                                      iconColor:
                                                          Color(0xff007663),
                                                      title: (LanguageClass
                                                              .isEnglish)
                                                          ? "20 min"
                                                          : "20 دقيقة",
                                                      padding: EdgeInsets.zero,
                                                      iconCustom: true,
                                                      widget: Icon(
                                                        Icons
                                                            .directions_car_filled,
                                                        color:
                                                            Color(0xff007663),
                                                        size: 15,
                                                      ),
                                                      textStyle: fontStyle(
                                                          color:
                                                              Color(0xff717171),
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontSize: 11.sp),
                                                    ),
                                                    _buildFilterCard(
                                                      onTap: () {},
                                                      icon:
                                                          Icons.directions_walk,
                                                      iconColor:
                                                          Color(0xff007663),
                                                      title: (LanguageClass
                                                              .isEnglish)
                                                          ? "20 min"
                                                          : "20 دقيقة",
                                                      padding: EdgeInsets.zero,
                                                      iconCustom: true,
                                                      widget: Icon(
                                                        Icons.directions_walk,
                                                        color:
                                                            Color(0xff007663),
                                                        size: 15,
                                                      ),
                                                      textStyle: fontStyle(
                                                          color:
                                                              Color(0xff717171),
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontSize: 11.sp),
                                                    ),
                                                    SizedBox(
                                                      height: sizeHeight * 0.07,
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (Ticketreservation
                                                              .Seatsnumbers1
                                                              .isNotEmpty) {
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
                                                                    'arrivalDate2',
                                                                value: widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .arrivalDate
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
                                                                tripDate: '${intl.DateFormat.d('en_US').format(widget.tripListBack![index].accessDate!)}${intl.DateFormat.MMM('en_US').format(widget.tripListBack![index].accessDate!)}',
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
                                                                            arrivaltime:
                                                                                widget.tripListBack![index].arrivalDate,
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
                                                                            discount:
                                                                                widget.tripListBack![index].discount,
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
                                                          } else {
                                                            Constants.showDefaultSnackBar(
                                                                context:
                                                                    context,
                                                                text: LanguageClass
                                                                        .isEnglish
                                                                    ? "Please reserve go trip first"
                                                                    : "برجاء اختيار رحلة ذهاب اولاً");
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 32.sp,
                                                          width: LanguageClass
                                                                  .isEnglish
                                                              ? 64.sp
                                                              : 48.sp,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 8),
                                                          decoration: BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: AppColors
                                                                        .white,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            0),
                                                                    spreadRadius:
                                                                        0,
                                                                    blurRadius:
                                                                        8)
                                                              ],
                                                              color: AppColors
                                                                  .white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Center(
                                                            child: Text(
                                                              LanguageClass
                                                                      .isEnglish
                                                                  ? 'Book'
                                                                  : 'حجز',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: fontStyle(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .medium,
                                                                fontSize: 12.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            );
                          }))
                  : SizedBox.shrink(),
              // todo :  button action next confirm
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
                                  tripTypeId: "2",
                                  actualDiscount:
                                      Ticketreservation.discount * 2,
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
      ),
      bottomNavigationBar: UmraDetails.isbusforumra
          ? SizedBox()
          : Navigationbottombar(
              currentIndex: 0,
            ),
    );
  }

  final now = DateTime.now();
  int selectedIndex = 0;

  Widget _buildTimeWidget(String day, String time) {
    final locale = LanguageClass.isEnglish ? 'en' : 'ar';
    return SizedBox(
      height: 60,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final date = now.add(Duration(days: index));

          final dayText = intl.DateFormat(
            'EEE, d MMM',
            locale,
          ).format(date);
          final fromTime = intl.DateFormat(
            'h a',
            locale,
          ).format(date.add(Duration(hours: index))).toLowerCase();
          final toTime = intl.DateFormat(
            'h a',
            locale,
          ).format(date.add(Duration(hours: index + 1))).toLowerCase();

          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 0,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      dayText,
                      style: fontStyle(
                          fontSize: 10.sp,
                          color: const Color(0xff383838),
                          // fontWeight: FontWeight.w800,
                          fontFamily: FontFamily.regular),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(
                      left: (LanguageClass.isEnglish) ? 10 : 0,
                      right: (LanguageClass.isEnglish) ? 0 : 20,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: isSelected ? null : const Color(0xfff3f3f3),
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                Color(0xfffd634f),
                                Color(0xffff9976),
                              ],
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '$fromTime - $toTime',
                          textDirection: locale == 'ar'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: fontStyle(
                            fontSize: 8.sp,
                            fontFamily: FontFamily.regular,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget _buildFilterCard({
  //   required VoidCallback onTap,
  //   required IconData icon,
  //   required String title,
  //   bool iconCustom = false,
  //   Widget? widget,
  //   Color? iconColor,
  //   EdgeInsetsGeometry? padding,
  //   TextStyle? textStyle,
  // }) {
  //   return SizedBox(
  //     height: 40,
  //     child: GestureDetector(
  //       onTap: onTap,
  //       child: Card(
  //         elevation: 0.0,
  //         // color: Color(0xfff3f3f3),
  //         color: AppColors.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(6),
  //         ),
  //         child: Padding(
  //           padding: padding ??
  //               const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             spacing: 3,
  //             children: [
  //               if (iconCustom) widget ?? SizedBox.shrink(),
  //               Text(
  //                 title,
  //                 style: textStyle ??
  //                     fontStyle(
  //                         color: Color(0xff717171),
  //                         fontFamily: FontFamily.regular,
  //                         fontSize: 12.sp),
  //               ),
  //               (iconCustom)
  //                   ? SizedBox.shrink()
  //                   : Icon(
  //                       icon,
  //                       color: iconColor ?? AppColors.blackColor,
  //                       size: 15,
  //                     ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildFilterCard({
    required String title,
    required IconData icon,
    List<String>? dropdownItems,
    Function(String)? onItemSelected,
    VoidCallback? onTap,
    bool iconCustom = false,
    Widget? widget,
    ValueChanged<bool>? onOpenChanged,
    Color? iconColor,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    bool isRadiusActive = false,
  }) {
    if (dropdownItems != null && dropdownItems.isNotEmpty) {
      return FilterDropdownCard(
        icon: icon,
        title: title,
        items: dropdownItems,
        onItemSelected: onItemSelected ?? (_) {},
        iconCustom: iconCustom,
        widget: widget,
        iconColor: iconColor,
        onTap: onTap,
        padding: padding,
        isOpen: isRadiusActive,
        onOpenChanged: onOpenChanged,
        textStyle: textStyle,
      );
    }

    return SizedBox(
      height: 40,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.0,
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: (isRadiusActive == true)
                ? BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  )
                : BorderRadius.circular(6),
          ),
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 3,
              children: [
                if (iconCustom) widget ?? SizedBox.shrink(),
                Text(
                  title,
                  style: textStyle ??
                      TextStyle(
                        color: Color(0xff717171),
                        fontSize: 12,
                      ),
                ),
                if (!iconCustom)
                  Icon(
                    icon,
                    color: iconColor ?? AppColors.blackColor,
                    size: 15,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FilterDropdownCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<String> items;
  final Function(String) onItemSelected;
  final bool iconCustom;
  final Widget? widget;
  final Color? iconColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final ValueChanged<bool>? onOpenChanged;
  final bool isOpen;
  const FilterDropdownCard({
    required this.icon,
    required this.title,
    required this.items,
    required this.onItemSelected,
    this.iconCustom = false,
    this.widget,
    this.iconColor,
    this.onTap,
    this.padding,
    this.textStyle,
    this.onOpenChanged,
    this.isOpen = false,
  });

  @override
  State<FilterDropdownCard> createState() => _FilterDropdownCardState();
}

class _FilterDropdownCardState extends State<FilterDropdownCard> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _hideDropdown();
    } else {
      _showDropdown();
    }
    widget.onTap?.call();
  }

  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
    widget.onOpenChanged?.call(true);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
    });
    widget.onOpenChanged?.call(false);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hideDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              width: size.width - 8.5,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(4, size.height - 3.4),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: _isOpen
                          ? BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            )
                          : BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: 5),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.items.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        thickness: 0.5,
                        endIndent: 10,
                        indent: 10,
                        color: Color(0xFFE0E0E0),
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            widget.onItemSelected(widget.items[index]);
                            _hideDropdown();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 5,
                            ),
                            child: Text(
                              widget.items[index],
                              style: widget.textStyle ??
                                  TextStyle(
                                    color: Color(0xff717171),
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        height: 40,
        child: GestureDetector(
          onTap: _toggleDropdown,
          child: Card(
            elevation: 0.0,
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(6),
              borderRadius: widget.isOpen
                  ? BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    )
                  : BorderRadius.circular(6),
            ),
            child: Padding(
              padding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 13.0, vertical: 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.iconCustom) widget.widget ?? SizedBox.shrink(),
                  if (widget.iconCustom) SizedBox(width: 3),
                  Text(
                    widget.title,
                    style: widget.textStyle ??
                        TextStyle(
                          color: Color(0xff717171),
                          fontSize: 12,
                        ),
                  ),
                  SizedBox(width: 3),
                  if (!widget.iconCustom)
                    Icon(
                      _isOpen ? Icons.keyboard_arrow_up : widget.icon,
                      color: widget.iconColor ?? AppColors.blackColor,
                      size: 15,
                    ),
                  SizedBox(width: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }
}
