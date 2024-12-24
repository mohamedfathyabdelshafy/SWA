import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as initl;
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/Swa_umra/Screens/Bus_Backseat_screan.dart';
import 'package:swa/features/Swa_umra/Screens/Enter_trip_data.dart';
import 'package:swa/features/Swa_umra/Screens/Ticket_screen.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/campain_list_model.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';

class ReservationUmraScrean extends StatefulWidget {
  ReservationUmraScrean({
    super.key,
  });

  @override
  State<ReservationUmraScrean> createState() => _ReservationUmraScreanState();
}

class _ReservationUmraScreanState extends State<ReservationUmraScrean> {
  final UmraBloc _umraBloc = UmraBloc();

  List selectedseats = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                            LanguageClass.isEnglish ? 'Reservation' : 'الحجز',
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontFamily: 'bold',
                                fontWeight: FontWeight.w500),
                          )),
                      Flexible(
                          child: Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: AppColors.umragold,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    LanguageClass.isEnglish
                                        ? 'Going Trip'
                                        : 'رحلة الذهاب',
                                    style: TextStyle(
                                        fontFamily: 'bold',
                                        fontSize: 23,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Container(
                                          child: SvgPicture.asset(
                                              'assets/images/seatumra.svg'),
                                        ),
                                        2.verticalSpace,
                                        ...UmraDetails.bookedseatsgo
                                            .map((e) => Text(
                                                  '$e ,',
                                                  style: TextStyle(
                                                      fontFamily: 'meduim',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors.white),
                                                ))
                                            .toList(),
                                      ]),
                                )
                              ],
                            ),
                            Text(
                              initl.DateFormat("EEE, MMM d, yyyy")
                                  .format(UmraDetails.tripList.tripDateGo!)
                                  .toString(),
                              style: TextStyle(
                                  fontFamily: 'meduim',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${UmraDetails.tripList.tripTimeGo!} ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'meduim'),
                                            ),
                                          ],
                                        ),
                                        15.verticalSpace,
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${UmraDetails.tripList.tripTimeGo!} ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'meduim'),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                4.horizontalSpace,
                                Container(
                                  width: 5,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0xffFFFFFF),
                                            Color(0xffFFDA2A),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter)),
                                ),
                                10.horizontalSpace,
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'From',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'meduim'),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          '${UmraDetails.tripList.fromGo!}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              height: 1,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'bold'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'to',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'meduim'),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          '${UmraDetails.tripList.toGo!}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              height: 1,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'bold'),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  UmraDetails.tripList.tripTypeName!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      height: 1,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'bold'),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                      20.verticalSpace,
                      Flexible(
                          child: Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: AppColors.umragold,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    LanguageClass.isEnglish
                                        ? 'Back Trip'
                                        : 'رحلة العودة',
                                    style: TextStyle(
                                        fontFamily: 'bold',
                                        fontSize: 23,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Container(
                                          child: SvgPicture.asset(
                                              'assets/images/seatumra.svg'),
                                        ),
                                        2.verticalSpace,
                                        ...UmraDetails.bookedseatsback
                                            .map((e) => Text(
                                                  '$e ,',
                                                  style: TextStyle(
                                                      fontFamily: 'meduim',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors.white),
                                                ))
                                            .toList(),
                                      ]),
                                )
                              ],
                            ),
                            Text(
                              initl.DateFormat("EEE, MMM d, yyyy")
                                  .format(UmraDetails.tripList.tripDateBack!)
                                  .toString(),
                              style: TextStyle(
                                  fontFamily: 'meduim',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${UmraDetails.tripList.tripTimeBack} ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'meduim'),
                                            ),
                                          ],
                                        ),
                                        15.verticalSpace,
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${UmraDetails.tripList.tripTimeBack} ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'meduim'),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                4.horizontalSpace,
                                Container(
                                  width: 5,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0xffFFFFFF),
                                            Color(0xffFFDA2A),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter)),
                                ),
                                10.horizontalSpace,
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'From',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'meduim'),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          UmraDetails.tripList.fromBack!,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              height: 1,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'bold'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'to',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'meduim'),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          UmraDetails.tripList.toBack!,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              height: 1,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'bold'),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  UmraDetails.tripList.tripTypeName!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      height: 1,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'bold'),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                      100.verticalSpace,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TicketScreen()));
                          },
                          child: Constants.customButton(
                              borderradias: 16,
                              text:
                                  LanguageClass.isEnglish ? "continue" : "حجز",
                              color: AppColors.umragold),
                        ),
                      ),
                    ],
                  ),
                ));
          }),
    );
  }
}
