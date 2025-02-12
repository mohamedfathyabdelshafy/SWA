import 'dart:developer';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/Screens/Trip_list_screen.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/Umra_tickets_model.dart';
import 'package:swa/features/Swa_umra/models/campain_model.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/main.dart';

class UmraBookedScreen extends StatefulWidget {
  UmraBookedScreen({
    super.key,
  });

  @override
  State<UmraBookedScreen> createState() => _UmraBookedScreenState();
}

class _UmraBookedScreenState extends State<UmraBookedScreen> {
  final UmraBloc _umraBloc = UmraBloc();
  UmraTicketsModel umraTickets =
      UmraTicketsModel(message: Message(result: Result(bookingList: [])));
  @override
  void initState() {
    var countryid = CacheHelper.getDataToSharedPref(
          key: 'countryid',
        ) ??
        1;
    // TODO: implement initState
    super.initState();
    if (Routes.user != null) {
      _umraBloc.add(GetbookedumraEvent());

      UmraDetails.dateTypeID = countryid == 1 ? 113 : 112;
    }
  }

  int inn = -1;
  bool iscancel = false;

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener(
        bloc: _umraBloc,
        listener: (context, UmraState state) {
          if (state.cancelrespnce?.status == 'success') {
            Constants.showDefaultSnackBar(
                color: AppColors.umragold,
                context: context,
                text: state.cancelrespnce!.message ?? ' ');
            _umraBloc.add(GetbookedumraEvent());
          } else if (state.cancelrespnce?.status == 'failed') {
            Constants.showDefaultSnackBar(
                color: AppColors.primaryColor,
                context: context,
                text: state.cancelrespnce!.message ?? ' ');
            _umraBloc.add(GetbookedumraEvent());
          } else if (state.umraTicketsModel?.status == 'success') {
            umraTickets = state.umraTicketsModel!;
          } else if (state.policyticketmodel?.status == 'success') {
            showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.2),
                useRootNavigator: true,
                builder: (context) {
                  return StatefulBuilder(builder: (buildContext,
                      StateSetter setStater /*You can rename this!*/) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      content: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.7,
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10.w),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            border:
                                Border.all(color: Color(0xff707070), width: 2),
                            borderRadius: BorderRadius.circular(16)),
                        child: Scrollbar(
                          thickness: 10,
                          trackVisibility: true,
                          scrollbarOrientation: ScrollbarOrientation.right,
                          radius: Radius.circular(10),
                          child: ListView(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            children: [
                              20.verticalSpace,
                              Text(
                                iscancel
                                    ? LanguageClass.isEnglish
                                        ? 'Cancelation Policy '
                                        : "سياسة الإلغاء"
                                    : LanguageClass.isEnglish
                                        ? 'Edit Policy '
                                        : "سياسة التعديل",
                                textAlign: LanguageClass.isEnglish
                                    ? TextAlign.left
                                    : TextAlign.right,
                                textDirection: LanguageClass.isEnglish
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                                style: fontStyle(
                                  color: Colors.black,
                                  fontFamily: FontFamily.medium,
                                  fontSize: 29.sp,
                                ),
                              ),
                              20.verticalSpace,
                              ListView.builder(
                                itemCount:
                                    state.policyticketmodel!.message!.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                padding: EdgeInsets.only(left: 10.w),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      margin: EdgeInsets.only(top: 15.h),
                                      child: Text(
                                          "${state.policyticketmodel!.message![index]}",
                                          textAlign: TextAlign.justify,
                                          textDirection: LanguageClass.isEnglish
                                              ? TextDirection.ltr
                                              : TextDirection.rtl,
                                          style: fontStyle(
                                              fontSize: 14.sp,
                                              fontFamily: FontFamily.medium,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)));
                                },
                              ),
                              10.verticalSpace,
                              iscancel
                                  ? InkWell(
                                      onTap: () {
                                        _umraBloc.add(CancelReservationEvent(
                                            reservationID: umraTickets
                                                .message!
                                                .result!
                                                .bookingList![inn]
                                                .umrahReservationId!));

                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Constants.customButton(
                                            borderradias: 30,
                                            text: LanguageClass.isEnglish
                                                ? "cancel the trip"
                                                : "الغاء الرحلة",
                                            color: AppColors.umragold),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Navigator.pop(context);

                                        UmraDetails.totalBokkedprice =
                                            umraTickets.message!.result!
                                                .bookingList![inn].totalPrice;

                                        log(UmraDetails.totalBokkedprice
                                            .toString());

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TriplistScreen(
                                                      city: umraTickets
                                                          .message!
                                                          .result!
                                                          .bookingList![inn]
                                                          .cityId
                                                          .toString(),
                                                      date: umraTickets
                                                          .message!
                                                          .result!
                                                          .bookingList![inn]
                                                          .umrahDate!,
                                                      typeid: umraTickets
                                                          .message!
                                                          .result!
                                                          .bookingList![inn]
                                                          .tripTypeUmrahId!,
                                                      umrahReservationID:
                                                          umraTickets
                                                              .message!
                                                              .result!
                                                              .bookingList![inn]
                                                              .umrahReservationId,
                                                    ))).then((value) {
                                          _umraBloc.add(GetbookedumraEvent());
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Constants.customButton(
                                            borderradias: 30,
                                            text: LanguageClass.isEnglish
                                                ? "Edit trip"
                                                : "تعديل الرحلة",
                                            color: AppColors.umragold),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    );
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
                return Directionality(
                  textDirection: LanguageClass.isEnglish
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: Column(
                    children: [
                      SizedBox(
                        height: sizeHeight * 0.08,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        alignment: LanguageClass.isEnglish
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.home, (route) => false,
                                arguments: Routes.isomra);
                          },
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Routes.isomra
                                ? AppColors.umragold
                                : AppColors.primaryColor,
                            size: 35,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        alignment: LanguageClass.isEnglish
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        child: Text(
                          LanguageClass.isEnglish ? 'Booking' : 'الحجز',
                          style: fontStyle(
                              color: AppColors.blackColor,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: FontFamily.bold),
                        ),
                      ),
                      SizedBox(
                        height: sizeHeight * 0.05,
                      ),
                      Expanded(
                        child: umraTickets.message!.result!.bookingList!.isEmpty
                            ? Center(
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? 'No Booked Tickets'
                                      : 'لا يوجد تذاكر محجوزة',
                                  style: fontStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontFamily: FontFamily.medium,
                                  ),
                                ),
                              )
                            : ListView(
                                reverse: false,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                padding: EdgeInsets.zero,
                                children: [
                                  ListView.builder(
                                    itemCount: umraTickets
                                        .message!.result!.bookingList!.length,
                                    shrinkWrap: true,
                                    reverse: true,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 27.w),
                                    physics: ScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 15.h),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                umraTickets
                                                        .message!
                                                        .result!
                                                        .bookingList![index]
                                                        .canEdit!
                                                    ? InkWell(
                                                        onTap: () {
                                                          inn = index;
                                                          iscancel = false;
                                                          _umraBloc.add(
                                                              Getpolicyevent(
                                                                  type:
                                                                      'PloicyEdit'));
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.edit,
                                                              color: AppColors
                                                                  .umragold,
                                                              size: 15,
                                                            ),
                                                            2.horizontalSpace,
                                                            Text(
                                                              LanguageClass
                                                                      .isEnglish
                                                                  ? 'Edit'
                                                                  : 'تعديل',
                                                              style: fontStyle(
                                                                color: AppColors
                                                                    .umragold,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .regular,
                                                                fontSize: 14.sp,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : 0.horizontalSpace,
                                                9.horizontalSpace,
                                                umraTickets
                                                        .message!
                                                        .result!
                                                        .bookingList![index]
                                                        .canCancel!
                                                    ? InkWell(
                                                        onTap: () {
                                                          inn = index;
                                                          iscancel = true;
                                                          _umraBloc.add(
                                                              Getpolicyevent(
                                                                  type:
                                                                      'PloicyCancel'));
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .cancel_outlined,
                                                              color: AppColors
                                                                  .umragold,
                                                              size: 15,
                                                            ),
                                                            2.horizontalSpace,
                                                            Text(
                                                              LanguageClass
                                                                      .isEnglish
                                                                  ? 'cancel'
                                                                  : 'الغاء',
                                                              style: fontStyle(
                                                                color: AppColors
                                                                    .umragold,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .regular,
                                                                fontSize: 14.sp,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : 0.horizontalSpace,
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(19.w),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: AppColors.umragold,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      umraTickets
                                                          .message!
                                                          .result!
                                                          .bookingList![index]
                                                          .transportation!
                                                          .title!,
                                                      style: fontStyle(
                                                          color: Colors.white,
                                                          fontSize: 23.sp,
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    13.verticalSpace,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                            fit: FlexFit.loose,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  umraTickets
                                                                      .message!
                                                                      .result!
                                                                      .bookingList![
                                                                          index]
                                                                      .transportation!
                                                                      .tripTitle!,
                                                                  style: fontStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20.sp,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .bold,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                6.verticalSpace,
                                                                FittedBox(
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        umraTickets.message?.result!.bookingList?[index].transportation?.fromDate ==
                                                                                ''
                                                                            ? Container()
                                                                            : FittedBox(
                                                                                fit: BoxFit.contain,
                                                                                child: Text(
                                                                                  umraTickets.message?.result!.bookingList?[index].transportation?.fromDate ?? '-',
                                                                                  style: fontStyle(color: Colors.white, fontSize: 14.sp, fontFamily: FontFamily.medium, fontWeight: FontWeight.w500),
                                                                                ),
                                                                              ),
                                                                        FittedBox(
                                                                          fit: BoxFit
                                                                              .contain,
                                                                          child:
                                                                              Text(
                                                                            ' : ',
                                                                            style: fontStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 14.sp,
                                                                                fontFamily: FontFamily.medium,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                        umraTickets.message!.result!.bookingList![index].transportation!.toDate ==
                                                                                ''
                                                                            ? Container()
                                                                            : FittedBox(
                                                                                fit: BoxFit.contain,
                                                                                child: Text(
                                                                                  umraTickets.message!.result!.bookingList![index].transportation!.toDate ?? ' ',
                                                                                  style: fontStyle(color: Colors.white, fontSize: 14.sp, fontFamily: FontFamily.medium, fontWeight: FontWeight.w500),
                                                                                ),
                                                                              ),
                                                                      ]),
                                                                ),
                                                                12.verticalSpace,
                                                                ListView
                                                                    .builder(
                                                                  itemCount: umraTickets
                                                                      .message!
                                                                      .result!
                                                                      .bookingList![
                                                                          index]
                                                                      .transportation!
                                                                      .transportaionList!
                                                                      .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  physics:
                                                                      ScrollPhysics(),
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index2) {
                                                                    return Container(
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              8.h),
                                                                      child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 4,
                                                                                  child: Container(
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(umraTickets.message!.result!.bookingList![index].transportation!.transportaionList![index2].fromCity!, style: fontStyle(color: Colors.white, fontSize: 14.sp, fontFamily: FontFamily.bold, fontWeight: FontWeight.w500)),
                                                                                        RotationTransition(
                                                                                          turns: LanguageClass.isEnglish ? AlwaysStoppedAnimation(360) : new AlwaysStoppedAnimation(180 / 360),
                                                                                          child: Container(
                                                                                            width: 10.w,
                                                                                            child: Image.asset('assets/images/Icon ion-arrow-forwa.png'),
                                                                                          ),
                                                                                        ),
                                                                                        Text(umraTickets.message!.result!.bookingList![index].transportation!.transportaionList![index2].toCity!, style: fontStyle(color: Colors.white, fontSize: 14.sp, fontFamily: FontFamily.bold, fontWeight: FontWeight.w500)),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                5.horizontalSpace,
                                                                                Expanded(
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      BusLayoutRepo(apiConsumer: (sl())).getReservationSeatsData(reservationID: umraTickets.message!.result!.bookingList![index].transportation!.transportaionList![index2].reservationId!).then((value) async {
                                                                                        showDialog(
                                                                                            context: context,
                                                                                            barrierColor: Colors.black.withOpacity(0.5),
                                                                                            useRootNavigator: true,
                                                                                            builder: (context) {
                                                                                              return AlertDialog(
                                                                                                  alignment: LanguageClass.isEnglish ? Alignment.centerRight : Alignment.centerLeft,
                                                                                                  insetPadding: EdgeInsets.all(0),
                                                                                                  contentPadding: EdgeInsets.zero,
                                                                                                  backgroundColor: Colors.white,
                                                                                                  titlePadding: EdgeInsets.zero,
                                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                                                                  content: Builder(builder: (context) {
                                                                                                    return Container(
                                                                                                      height: MediaQuery.of(context).size.height * 0.6,
                                                                                                      alignment: Alignment.center,
                                                                                                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                                                                                                        SizedBox(
                                                                                                          height: 10,
                                                                                                        ),
                                                                                                        Padding(
                                                                                                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                                                                                                          child: Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                            children: [
                                                                                                              InkWell(
                                                                                                                onTap: () {
                                                                                                                  Navigator.pop(context);
                                                                                                                },
                                                                                                                child: Container(
                                                                                                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    color: Colors.white,
                                                                                                                    boxShadow: [
                                                                                                                      BoxShadow(offset: Offset(0, 0), color: Colors.black.withOpacity(0.2), blurRadius: 14, spreadRadius: 0)
                                                                                                                    ],
                                                                                                                    borderRadius: BorderRadius.circular(
                                                                                                                      30,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  child: Text(
                                                                                                                    LanguageClass.isEnglish ? 'Done' : 'انهاء',
                                                                                                                    style: fontStyle(
                                                                                                                      color: Colors.black,
                                                                                                                      fontFamily: FontFamily.regular,
                                                                                                                      fontSize: 14.sp,
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
                                                                                                            alignment: Alignment.topCenter,
                                                                                                            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
                                                                                                            child: Stack(
                                                                                                              alignment: Alignment.topCenter,
                                                                                                              children: [
                                                                                                                Positioned(
                                                                                                                  top: 0,
                                                                                                                  left: 0,
                                                                                                                  right: 0,
                                                                                                                  child: Container(
                                                                                                                      height: 112.h,
                                                                                                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                                                                                                      child: SvgPicture.asset(
                                                                                                                        'assets/images/busfront.svg',
                                                                                                                        fit: BoxFit.fitHeight,
                                                                                                                      )),
                                                                                                                ),
                                                                                                                Positioned(
                                                                                                                  bottom: 0,
                                                                                                                  left: 0,
                                                                                                                  right: 0,
                                                                                                                  child: Container(
                                                                                                                      height: 144.h,
                                                                                                                      padding: EdgeInsets.symmetric(horizontal: 25),
                                                                                                                      child: SvgPicture.asset(
                                                                                                                        'assets/images/backbus.svg',
                                                                                                                        fit: BoxFit.fitHeight,
                                                                                                                      )),
                                                                                                                ),
                                                                                                                Positioned(
                                                                                                                  top: 77.h,
                                                                                                                  bottom: 5.h,
                                                                                                                  left: 75.w,
                                                                                                                  right: 75.w,
                                                                                                                  child: Column(
                                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                                    children: [
                                                                                                                      for (int index = 0; index < value.message.busDetailsVm.totalRow; index++)
                                                                                                                        Row(
                                                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                          children: [
                                                                                                                            for (int i = 0; i < value.message.busDetailsVm.totalColumn; i++)
                                                                                                                              Expanded(
                                                                                                                                child: value.message.busDetailsVm.rowList[index].seats[i].isAvailable == true
                                                                                                                                    ? InkWell(
                                                                                                                                        onTap: () {},
                                                                                                                                        child: Container(
                                                                                                                                          alignment: Alignment.center,
                                                                                                                                          width: double.infinity,
                                                                                                                                          height: (MediaQuery.of(context).size.height * 0.6 * 0.55) / value.message.busDetailsVm.totalRow,
                                                                                                                                          margin: EdgeInsets.all(1),
                                                                                                                                          child: Stack(
                                                                                                                                            alignment: Alignment.center,
                                                                                                                                            children: [
                                                                                                                                              SvgPicture.asset(
                                                                                                                                                'assets/images/busseat.svg',
                                                                                                                                                alignment: Alignment.center,
                                                                                                                                                fit: BoxFit.fitHeight,
                                                                                                                                                color: value.message.mySeatListId.contains(value.message.busDetailsVm.rowList[index].seats[i].seatBusID)
                                                                                                                                                    ? Color(0xffB55BCB)
                                                                                                                                                    : value.message.busDetailsVm.rowList[index].seats[i].isAvailable! && !value.message.busDetailsVm.rowList[index].seats[i].isReserved!
                                                                                                                                                        ? AppColors.umragold
                                                                                                                                                        : null,
                                                                                                                                              ),
                                                                                                                                              FittedBox(
                                                                                                                                                fit: BoxFit.contain,
                                                                                                                                                child: Text(
                                                                                                                                                  value.message.busDetailsVm.rowList[index].seats[i].seatNo.toString(),
                                                                                                                                                  style: fontStyle(color: value.message.busDetailsVm.rowList[index].seats[i].isReserved == false || value.message.mySeatListId.contains(value.message.busDetailsVm.rowList[index].seats[i].seatBusID) ? Colors.white : Colors.black, fontSize: 13, fontFamily: FontFamily.bold, fontWeight: FontWeight.w600),
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
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                        )),
                                                                                                      ]),
                                                                                                    );
                                                                                                  }));
                                                                                            });
                                                                                      });
                                                                                    },
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          width: 12.w,
                                                                                          alignment: Alignment.center,
                                                                                          child: SvgPicture.asset('assets/images/Icon material-event-.svg'),
                                                                                        ),
                                                                                        3.horizontalSpace,
                                                                                        Text(umraTickets.message!.result!.bookingList![index].transportation!.transportaionList![index2].seatCount.toString(), style: fontStyle(color: Colors.white, fontSize: 12.sp, fontFamily: FontFamily.medium, fontWeight: FontWeight.w500)),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            FittedBox(
                                                                              fit: BoxFit.fitWidth,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  FittedBox(
                                                                                    fit: BoxFit.contain,
                                                                                    child: Text(
                                                                                      "${umraTickets.message!.result!.bookingList![index].transportation!.transportaionList![index2].fromDate!} ${umraTickets.message!.result!.bookingList![index].transportation!.transportaionList![index2].fromTime!}",
                                                                                      style: fontStyle(color: Colors.white, fontSize: 12.sp, fontFamily: FontFamily.medium, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                  ),
                                                                                  14.horizontalSpace,
                                                                                  FittedBox(
                                                                                    fit: BoxFit.contain,
                                                                                    child: Text(
                                                                                      "${umraTickets.message!.result!.bookingList![index].transportation!.transportaionList![index2].toDate!} ${umraTickets.message!.result!.bookingList![index].transportation!.transportaionList![index2].toTime!}",
                                                                                      style: fontStyle(color: Colors.white, fontSize: 12.sp, fontFamily: FontFamily.medium, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]),
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            )),
                                                        5.horizontalSpace,
                                                        Container(
                                                          width: 59.w,
                                                          height: 59.w,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                          child: QrImageView(
                                                              data: umraTickets
                                                                  .message!
                                                                  .result!
                                                                  .bookingList![
                                                                      index]
                                                                  .transportation!
                                                                  .qrCode!),
                                                        )
                                                      ],
                                                    ),
                                                    DottedLine(
                                                      direction:
                                                          Axis.horizontal,
                                                      lineLength:
                                                          double.infinity,
                                                      lineThickness: 1.0,
                                                      dashLength: 4.0,
                                                      dashColor: Colors.white,
                                                      dashRadius: 0.0,
                                                    ),
                                                    12.verticalSpace,
                                                    Text(
                                                      umraTickets
                                                          .message!
                                                          .result!
                                                          .bookingList![index]
                                                          .accommodation!
                                                          .title!,
                                                      style: fontStyle(
                                                          color: Colors.white,
                                                          fontSize: 23.sp,
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    13.verticalSpace,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                            fit: FlexFit.loose,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ListView
                                                                    .builder(
                                                                  itemCount: umraTickets
                                                                      .message!
                                                                      .result!
                                                                      .bookingList![
                                                                          index]
                                                                      .accommodation!
                                                                      .accommodationModel!
                                                                      .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  physics:
                                                                      ScrollPhysics(),
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index2) {
                                                                    return Container(
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              8.h),
                                                                      child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            FittedBox(
                                                                              fit: BoxFit.fitWidth,
                                                                              child: Text(
                                                                                umraTickets.message!.result!.bookingList![index].accommodation!.accommodationModel![index2].cityName!,
                                                                                style: fontStyle(color: Colors.white, height: 1.2, fontSize: 15.sp, fontFamily: FontFamily.medium, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ),
                                                                            FittedBox(
                                                                              fit: BoxFit.fitWidth,
                                                                              child: Text(
                                                                                '${umraTickets.message!.result!.bookingList![index].accommodation!.accommodationModel![index2].hotelName}  ${umraTickets.message!.result!.bookingList![index].accommodation!.accommodationModel![index2].date}  ${umraTickets.message!.result!.bookingList![index].accommodation!.accommodationModel![index2].nights} ${LanguageClass.isEnglish ? 'Nights' : 'ليالي'} .',
                                                                                textDirection: LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
                                                                                style: fontStyle(color: Colors.white, fontSize: 15.sp, fontFamily: FontFamily.medium, height: 1.2, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ),
                                                                            ListView.builder(
                                                                              shrinkWrap: true,
                                                                              physics: ScrollPhysics(),
                                                                              padding: EdgeInsets.zero,
                                                                              itemCount: umraTickets.message!.result!.bookingList![index].accommodation!.accommodationModel![index2].accommodationList!.length,
                                                                              itemBuilder: (BuildContext context, int index3) {
                                                                                return FittedBox(
                                                                                  fit: BoxFit.fitWidth,
                                                                                  child: Text(
                                                                                    '${umraTickets.message!.result!.bookingList![index].accommodation!.accommodationModel![index2].accommodationList![index3].personCount} ${LanguageClass.isEnglish ? 'Person' : 'فرد'} ( ${umraTickets.message!.result!.bookingList![index].accommodation!.accommodationModel![index2].accommodationList![index3].roomType} )  ${umraTickets.message!.result!.bookingList![index].accommodation!.accommodationModel![index2].accommodationList![index3].accommodationType}',
                                                                                    style: fontStyle(color: Colors.white, fontSize: 15.sp, fontFamily: FontFamily.medium, height: 1.2, fontWeight: FontWeight.w500),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ]),
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            )),
                                                        5.horizontalSpace,
                                                        Container(
                                                          width: 59.w,
                                                          height: 59.w,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                          child: QrImageView(
                                                              data: umraTickets
                                                                  .message!
                                                                  .result!
                                                                  .bookingList![
                                                                      index]
                                                                  .accommodation!
                                                                  .qrCode!),
                                                        )
                                                      ],
                                                    ),
                                                    12.verticalSpace,
                                                    DottedLine(
                                                      direction:
                                                          Axis.horizontal,
                                                      lineLength:
                                                          double.infinity,
                                                      lineThickness: 1.0,
                                                      dashLength: 4.0,
                                                      dashColor: Colors.white,
                                                      dashRadius: 0.0,
                                                    ),
                                                    12.verticalSpace,
                                                    Text(
                                                      umraTickets
                                                          .message!
                                                          .result!
                                                          .bookingList![index]
                                                          .program!
                                                          .title!,
                                                      style: fontStyle(
                                                          color: Colors.white,
                                                          fontSize: 23.sp,
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    13.verticalSpace,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                            fit: FlexFit.loose,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ListView
                                                                    .builder(
                                                                  itemCount: umraTickets
                                                                      .message!
                                                                      .result!
                                                                      .bookingList![
                                                                          index]
                                                                      .program!
                                                                      .programList!
                                                                      .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  physics:
                                                                      ScrollPhysics(),
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index2) {
                                                                    return Container(
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              8.h),
                                                                      child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              umraTickets.message!.result!.bookingList![index].program!.programList![index2].title!,
                                                                              style: fontStyle(color: Colors.white, height: 1.2, fontSize: 15.sp, fontFamily: FontFamily.medium, fontWeight: FontWeight.w500),
                                                                            ),
                                                                            Text(
                                                                              '${umraTickets.message!.result!.bookingList![index].program!.programList![index2].personCount} ${LanguageClass.isEnglish ? 'Person' : 'فرد'}      ${umraTickets.message!.result!.bookingList![index].program!.programList![index2].date}',
                                                                              style: fontStyle(color: Colors.white, fontSize: 15.sp, fontFamily: FontFamily.medium, height: 1.2, fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ]),
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            )),
                                                        5.horizontalSpace,
                                                        Container(
                                                          width: 59.w,
                                                          height: 59.w,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                          child: QrImageView(
                                                              data: umraTickets
                                                                  .message!
                                                                  .result!
                                                                  .bookingList![
                                                                      index]
                                                                  .program!
                                                                  .qrCode!),
                                                        ),
                                                      ],
                                                    ),
                                                    12.verticalSpace,
                                                    DottedLine(
                                                      direction:
                                                          Axis.horizontal,
                                                      lineLength:
                                                          double.infinity,
                                                      lineThickness: 1.0,
                                                      dashLength: 4.0,
                                                      dashColor: Colors.white,
                                                      dashRadius: 0.0,
                                                    ),
                                                    12.verticalSpace,
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                LanguageClass
                                                                        .isEnglish
                                                                    ? "Total"
                                                                    : 'الإجمالي',
                                                                style: fontStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        17.sp,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .medium,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Text(
                                                                '${umraTickets.message!.result!.bookingList![index].totalPrice} ${umraTickets.message!.result!.bookingList![index].countryId == 3 ? 'SAR' : 'EGP'}',
                                                                style: fontStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        23.sp,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .medium,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              )
                                                            ],
                                                          )
                                                        ])
                                                  ]),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                      )
                    ],
                  ),
                );
              }
            }),
      ),
      bottomNavigationBar: Navigationbottombar(currentIndex: 1),
    );
  }
}
