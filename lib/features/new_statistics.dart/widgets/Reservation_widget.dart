import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:intl/intl.dart' as intl;
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_state.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/screen/ticket_pdf.dart';
import 'package:swa/features/new_statistics.dart/Sceens/Reservations_reports.dart';
import 'package:swa/features/new_statistics.dart/bloc/statistics_bloc.dart';

import 'package:swa/features/new_statistics.dart/model/All_statics_model.dart';
import 'package:swa/features/new_statistics.dart/model/Reservationdetails_model.dart';
import 'package:swa/features/new_statistics.dart/widgets/ticket_pdf_details.dart';
import 'package:swa/features/payment/select_payment/presentation/screens/select_payment.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';

Widget ReservationWidget(
    {required AllStaticsModel allStaticsModel, required String walletbalance, required BuildContext context}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "assets/images/CheckCircle-24px.svg",
                        color: Colors.green[600],
                      )),
                  10.horizontalSpace,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LanguageClass.isEnglish ? "Booked" : "الحجوزات الموكدة",
                        style: fontStyle(
                          color: Colors.green[600]!,
                          fontSize: 12.sp,
                          fontFamily: FontFamily.regular,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        " ${allStaticsModel.message!.reservations!.where(
                          (element) {
                            return element.status != 61;
                          },
                        ).length}",
                        style: fontStyle(
                          color: Colors.green[600]!,
                          fontSize: 16.sp,
                          fontFamily: FontFamily.bold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
            10.horizontalSpace,
            Expanded(
                child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<StatisticsBloc>(
                        create: (context) => StatisticsBloc(),
                        child: ReservationsReportsScreen(
                          allStaticsModel: allStaticsModel,
                        ),
                      ),
                    ));
              },
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "assets/images/bus24.svg",
                        color: Colors.blue[600],
                      ),
                    ),
                    10.horizontalSpace,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LanguageClass.isEnglish ? "Total Reservations" : "اجمالي الحجوزات",
                          style: fontStyle(
                            color: Colors.blue[600]!,
                            fontSize: 12.sp,
                            fontFamily: FontFamily.regular,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${allStaticsModel.message!.reservations!.length}",
                          style: fontStyle(
                            color: Colors.blue[600]!,
                            fontSize: 16.sp,
                            fontFamily: FontFamily.bold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
        20.verticalSpace,
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey,
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/images/CreditCard-24px.svg",
                  color: AppColors.primaryColor,
                ),
              ),
              10.horizontalSpace,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LanguageClass.isEnglish ? "Total Amount" : "اجمالي المبلغ",
                    style: fontStyle(
                      color: AppColors.primaryColor,
                      fontSize: 12.sp,
                      fontFamily: FontFamily.regular,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "${allStaticsModel.message!.reservations!.fold(
                          0.0,
                          (previousValue, element) => previousValue + element.price,
                        ).toStringAsFixed(2)} ${Routes.curruncy}",
                    style: fontStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16.sp,
                      fontFamily: FontFamily.bold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        20.verticalSpace,
        // Container(
        //   padding: EdgeInsets.all(10.w),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(8),
        //     border: Border.all(color: Colors.grey),
        //   ),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Row(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Container(
        //             width: 20.w,
        //             child: SvgPicture.asset(
        //               "assets/images/Filter-24px.svg",
        //             ),
        //           ),
        //           5.horizontalSpace,
        //           Text(
        //             LanguageClass.isEnglish ? "Reservation Period" : "فترة الحجوزات",
        //             style: fontStyle(
        //                 fontSize: 14.sp,
        //                 fontFamily: FontFamily.bold,
        //                 fontWeight: FontWeight.w600,
        //                 color: AppColors.blackColor),
        //           )
        //         ],
        //       ),
        //       10.verticalSpace,
        //       TextFormField(
        //           decoration: InputDecoration(
        //               prefixIcon: Icon(Icons.search_rounded),
        //               hintText: LanguageClass.isEnglish ? "Search in transactions" : "البحث في الحجوزات",
        //               border: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey)))),
        //       10.verticalSpace,
        //       Container(
        //           alignment: Alignment.center,
        //           child: DropDownTextField(
        //               padding: EdgeInsets.zero,
        //               initialValue: "${LanguageClass.isEnglish ? "All Types " : "جميع الحالات"}",
        //               onChanged: (value) {},
        //               autovalidateMode: AutovalidateMode.onUserInteraction,
        //               textFieldDecoration: InputDecoration(
        //                 fillColor: Colors.white,
        //                 enabledBorder: OutlineInputBorder(
        //                     borderRadius: BorderRadius.circular(8),
        //                     borderSide: BorderSide(color: Colors.grey, width: 1)),
        //                 disabledBorder: OutlineInputBorder(
        //                     borderRadius: BorderRadius.circular(8),
        //                     borderSide: BorderSide(color: Colors.grey, width: 1)),
        //                 border: OutlineInputBorder(
        //                     borderRadius: BorderRadius.circular(8),
        //                     borderSide: BorderSide(color: Colors.grey, width: 1)),
        //                 filled: true,
        //                 iconColor: Colors.red,
        //                 contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 25),
        //                 suffixIcon: Icon(
        //                   Icons.keyboard_arrow_down_rounded,
        //                   color: Color(0xff898989),
        //                 ),
        //                 hintText: '${LanguageClass.isEnglish ? "All Types " : "جميع الحالات"}',
        //                 errorStyle: fontStyle(
        //                     fontSize: 10.sp,
        //                     fontFamily: FontFamily.regular,
        //                     fontWeight: FontWeight.w500,
        //                     color: Colors.red),
        //                 hintStyle: fontStyle(
        //                   color: Color(0xffA2A2A2),
        //                   fontFamily: FontFamily.medium,
        //                   height: 1.2,
        //                   fontSize: 14.sp,
        //                   fontWeight: FontWeight.normal,
        //                 ),
        //               ),
        //               readOnly: true,
        //               validator: (value) {
        //                 return null;
        //               },
        //               listTextStyle: fontStyle(
        //                 color: Colors.black,
        //                 fontFamily: FontFamily.medium,
        //                 height: 1.2,
        //                 fontSize: 14.sp,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //               textStyle: fontStyle(
        //                 color: Colors.black,
        //                 fontFamily: FontFamily.medium,
        //                 height: 1.2,
        //                 fontSize: 14.sp,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //               dropDownList: [
        //                 DropDownValueModel(
        //                     name: LanguageClass.isEnglish ? "All Types" : "جميع الانواع", value: "All Types"),
        //                 DropDownValueModel(name: LanguageClass.isEnglish ? "Deposit" : "الدفع", value: "Deposit"),
        //                 DropDownValueModel(name: LanguageClass.isEnglish ? "Withdrawal" : "السحب", value: "Withdrawal"),
        //               ])),
        //       10.verticalSpace,
        //       Container(
        //           alignment: Alignment.center,
        //           child: DropDownTextField(
        //               padding: EdgeInsets.zero,
        //               initialValue: "${LanguageClass.isEnglish ? "All Types " : "جميع الحالات"}",
        //               onChanged: (value) {},
        //               autovalidateMode: AutovalidateMode.onUserInteraction,
        //               textFieldDecoration: InputDecoration(
        //                 fillColor: Colors.white,
        //                 enabledBorder: OutlineInputBorder(
        //                     borderRadius: BorderRadius.circular(8),
        //                     borderSide: BorderSide(color: Colors.grey, width: 1)),
        //                 disabledBorder: OutlineInputBorder(
        //                     borderRadius: BorderRadius.circular(8),
        //                     borderSide: BorderSide(color: Colors.grey, width: 1)),
        //                 border: OutlineInputBorder(
        //                     borderRadius: BorderRadius.circular(8),
        //                     borderSide: BorderSide(color: Colors.grey, width: 1)),
        //                 filled: true,
        //                 iconColor: Colors.red,
        //                 contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 25),
        //                 suffixIcon: Icon(
        //                   Icons.keyboard_arrow_down_rounded,
        //                   color: Color(0xff898989),
        //                 ),
        //                 hintText: '${LanguageClass.isEnglish ? "All Sources " : "جميع المصادر"}',
        //                 errorStyle: fontStyle(
        //                     fontSize: 10.sp,
        //                     fontFamily: FontFamily.regular,
        //                     fontWeight: FontWeight.w500,
        //                     color: Colors.red),
        //                 hintStyle: fontStyle(
        //                   color: Color(0xffA2A2A2),
        //                   fontFamily: FontFamily.medium,
        //                   height: 1.2,
        //                   fontSize: 14.sp,
        //                   fontWeight: FontWeight.normal,
        //                 ),
        //               ),
        //               readOnly: true,
        //               validator: (value) {
        //                 return null;
        //               },
        //               listTextStyle: fontStyle(
        //                 color: Colors.black,
        //                 fontFamily: FontFamily.medium,
        //                 height: 1.2,
        //                 fontSize: 14.sp,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //               textStyle: fontStyle(
        //                 color: Colors.black,
        //                 fontFamily: FontFamily.medium,
        //                 height: 1.2,
        //                 fontSize: 14.sp,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //               dropDownList: [
        //                 DropDownValueModel(
        //                     name: LanguageClass.isEnglish ? "All Types" : "جميع المصادر", value: "All sources"),
        //                 DropDownValueModel(name: LanguageClass.isEnglish ? "Deposit" : "الدفع", value: "Deposit"),
        //                 DropDownValueModel(name: LanguageClass.isEnglish ? "Withdrawal" : "السحب", value: "Withdrawal"),
        //               ])),
        //     ],
        //   ),
        // ),
        // 10.verticalSpace,
        Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        LanguageClass.isEnglish ? "All Reservations" : "قائمة الحجوزات",
                        style: fontStyle(
                            fontSize: 14.sp,
                            fontFamily: FontFamily.bold,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor),
                      ),
                      5.horizontalSpace,
                      Text(
                        "(${allStaticsModel.message!.reservations!.length})",
                        style: fontStyle(
                            fontSize: 14.sp,
                            fontFamily: FontFamily.bold,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor),
                      )
                    ],
                  ),
                  10.verticalSpace,
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: allStaticsModel.message!.reservations!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 0),
                                  blurRadius: 10,
                                  spreadRadius: 0)
                            ]),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 25.w,
                                  height: 25.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColors.primaryColor.withOpacity(0.4)),
                                  child: SvgPicture.asset(
                                    "assets/images/bus24.svg",
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                5.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              "TKT-${allStaticsModel.message!.reservations![index].ticketNumber}",
                                              style: fontStyle(
                                                  color: AppColors.blackColor,
                                                  fontFamily: FontFamily.medium,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        LanguageClass.isEnglish ? "mobile app" : "تطبيق الجوال",
                                        style: fontStyle(
                                            color: AppColors.blackColor.withOpacity(0.6),
                                            fontFamily: FontFamily.medium,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      5.verticalSpace,
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    allStaticsModel.message!.reservations![index].status == 60
                                        ? Container(
                                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.green.withOpacity(0.2),
                                                border: Border.all(color: Colors.green)),
                                            child: Text(
                                              LanguageClass.isEnglish ? "Confirmed" : "مؤكد",
                                              style: fontStyle(
                                                  fontSize: 8.sp,
                                                  fontFamily: FontFamily.bold,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green),
                                            ),
                                          )
                                        : allStaticsModel.message!.reservations![index].status == 61
                                            ? Container(
                                                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Colors.red.withOpacity(0.2),
                                                    border: Border.all(color: Colors.red)),
                                                child: Text(
                                                  LanguageClass.isEnglish ? "Canceled" : "ملغى",
                                                  style: fontStyle(
                                                      fontSize: 8.sp,
                                                      fontFamily: FontFamily.bold,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.red),
                                                ),
                                              )
                                            : allStaticsModel.message!.reservations![index].status == 62
                                                ? Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(100),
                                                        color: Colors.orange.withOpacity(0.2),
                                                        border: Border.all(color: Colors.orange)),
                                                    child: Text(
                                                      LanguageClass.isEnglish ? "Edited" : "تم التعديل",
                                                      style: fontStyle(
                                                          fontSize: 8.sp,
                                                          fontFamily: FontFamily.bold,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.orange),
                                                    ),
                                                  )
                                                : allStaticsModel.message!.reservations![index].status == 63
                                                    ? Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(100),
                                                            color: Colors.amber.withOpacity(0.2),
                                                            border: Border.all(color: Colors.amber)),
                                                        child: Text(
                                                          LanguageClass.isEnglish
                                                              ? "Edited with penalty"
                                                              : "تم التعديل بغرامة",
                                                          style: fontStyle(
                                                              fontSize: 8.sp,
                                                              fontFamily: FontFamily.bold,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.amber),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                    2.verticalSpace,
                                    Text(
                                      "${allStaticsModel.message!.reservations![index].price.toString()} ${Routes.curruncy}",
                                      style: fontStyle(
                                          fontSize: 14.sp,
                                          fontFamily: FontFamily.bold,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            20.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20.w,
                                  child: SvgPicture.asset("assets/images/MapPin-24px.svg"),
                                ),
                                5.horizontalSpace,
                                Flexible(
                                  child: Text(
                                    "${allStaticsModel.message!.reservations![index].fromStation}",
                                    style: fontStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 12.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                5.horizontalSpace,
                                Transform.flip(
                                    flipX: !LanguageClass.isEnglish,
                                    child: SvgPicture.asset("assets/images/longarrow.svg")),
                                5.horizontalSpace,
                                Flexible(
                                  child: Text(
                                    "${allStaticsModel.message!.reservations![index].toStation}",
                                    style: fontStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 12.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            10.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20.w,
                                  child: SvgPicture.asset("assets/images/Calendar-24px.svg"),
                                ),
                                5.horizontalSpace,
                                Text(
                                  intl.DateFormat('dd-MM-yyyy hh:mm a')
                                      .format(allStaticsModel.message!.reservations![index].tripDate!)
                                      .toString(),
                                  style: fontStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 12.sp,
                                      fontFamily: FontFamily.medium,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            10.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20.w,
                                  child: SvgPicture.asset("assets/images/Users-24px.svg"),
                                ),
                                5.horizontalSpace,
                                Text(
                                  "${allStaticsModel.message!.reservations![index].seatNo} ${LanguageClass.isEnglish ? "Seats" : "مقعد"}",
                                  style: fontStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 12.sp,
                                      fontFamily: FontFamily.medium,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            10.verticalSpace,
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Divider(
                                color: AppColors.blackColor.withOpacity(0.4),
                              ),
                            ),
                            10.verticalSpace,
                            Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                        child: Text(
                                      intl.DateFormat('dd-MM-yyyy hh:mm a').format(
                                        allStaticsModel.message!.reservations![index].tripDate!,
                                      ),
                                      style: fontStyle(
                                          color: AppColors.blackColor.withOpacity(0.6),
                                          fontSize: 13.sp,
                                          fontFamily: FontFamily.medium,
                                          fontWeight: FontWeight.w600),
                                    ))),
                                Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          BlocProvider.of<StatisticsBloc>(context).add(getReservationdetailsEvent(
                                              reservation: allStaticsModel.message!.reservations![index],
                                              id: allStaticsModel.message!.reservations![index].reservationId!));
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(vertical: 5.h),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(8),
                                                color: AppColors.white),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  LanguageClass.isEnglish ? "Details" : "تفاصيل",
                                                  style: fontStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                      fontFamily: FontFamily.bold,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                5.horizontalSpace,
                                                SvgPicture.asset("assets/images/Eye-24px.svg")
                                              ],
                                            ))))
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  )
                ]))
      ],
    ),
  );
}

Future showReservationspopDetails({
  required BuildContext context,
  required ReservationDetailsModel reservationdetails,
  required Reservation reservation,
}) async {
  TicketCubit _ticketcubit = TicketCubit();
  showDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    useRootNavigator: true,
    context: context,
    builder: (context) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Directionality(
          textDirection: LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: BlocListener(
            bloc: _ticketcubit,
            listener: (context, state) {
              if (state is LoadedTicketdetails) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return Ticketpdfdetails(state.ticketdetailsModel.message, reservationdetails.message);
                })).then((value) {
                  Constants.hideLoadingDialog(context);
                });
              } else if (state is LoadingTicketHistory) {
                Constants.showLoadingDialog(context);
              }
            },
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: InkWell(onTap: () => Navigator.pop(context), child: Icon(Icons.close)),
                  ),
                  5.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(),
                        child: SvgPicture.asset(
                          "assets/images/Calendar-24px.svg",
                          width: 20.w,
                        ),
                      ),
                      5.horizontalSpace,
                      Text(
                        LanguageClass.isEnglish
                            ? "Resrvation date TKT-${reservation.ticketNumber}"
                            : "تاريخ الحجز TKT-${reservation.ticketNumber}",
                        style: fontStyle(fontFamily: FontFamily.bold, fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  5.verticalSpace,
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      LanguageClass.isEnglish
                          ? "All operations related to this reservation"
                          : "تفاصيل وتاريخ جميع العمليات المتعلقة بهذا الحجز",
                      style: fontStyle(
                          fontFamily: FontFamily.regular,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.4)),
                    ),
                  ),
                  20.verticalSpace,
                  Container(
                    padding: EdgeInsetsDirectional.all(10.w),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: SvgPicture.asset("assets/images/MapPin-24px.svg"),
                            ),
                            5.horizontalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${reservation.fromStation}",
                                  style: fontStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 12.sp,
                                      fontFamily: FontFamily.medium,
                                      fontWeight: FontWeight.w600),
                                ),
                                5.horizontalSpace,
                                Transform.flip(
                                    flipX: !LanguageClass.isEnglish,
                                    child: SvgPicture.asset(
                                      "assets/images/longarrow.svg",
                                      height: 7.h,
                                    )),
                                5.horizontalSpace,
                                Text(
                                  "${reservation.toStation}",
                                  style: fontStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 12.sp,
                                      fontFamily: FontFamily.medium,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                        5.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: SvgPicture.asset("assets/images/Calendar-24px.svg"),
                            ),
                            5.horizontalSpace,
                            Text(
                              "${intl.DateFormat('dd-MM-yyyy').format(reservation.tripDate!)}",
                              style: fontStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 12.sp,
                                  fontFamily: FontFamily.medium,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        5.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: SvgPicture.asset("assets/images/Clock-24px.svg"),
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    "${intl.DateFormat('hh:mm a').format(reservation.tripDate!)}",
                                    style: fontStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 12.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: SvgPicture.asset("assets/images/Users-24px.svg"),
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    "${reservation.seatNo}",
                                    style: fontStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 12.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  10.horizontalSpace,
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        LanguageClass.isEnglish ? "Date of Operations" : "تاريخ العمليات",
                        style: fontStyle(
                            color: AppColors.blackColor,
                            fontSize: 14.sp,
                            fontFamily: FontFamily.medium,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Flexible(
                    child: ListView.builder(
                      itemCount: reservationdetails.message.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 10.h),
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: Offset(0, 0),
                            )
                          ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              reservationdetails.message[index].transactionTypeId == 7
                                  ? Container(
                                      padding: EdgeInsets.all(5),
                                      width: 30.w,
                                      height: 30.w,
                                      decoration: BoxDecoration(
                                          color: Colors.green[200], borderRadius: BorderRadius.circular(8)),
                                      child: SvgPicture.asset(
                                        "assets/images/CheckCircle-24px.svg",
                                        color: Colors.green[700],
                                      ),
                                    )
                                  : Container(
                                      width: 30.w,
                                      height: 30.w,
                                      padding: EdgeInsets.all(5),
                                      decoration:
                                          BoxDecoration(color: Colors.red[200], borderRadius: BorderRadius.circular(8)),
                                      child: SvgPicture.asset(
                                        "assets/images/warning.svg",
                                        color: Colors.red[700],
                                      ),
                                    ),
                              10.horizontalSpace,
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reservationdetails.message[index].reason!,
                                      style: fontStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 14.sp,
                                          fontFamily: FontFamily.medium,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      intl.DateFormat('dd-MM-yyyy hh:mm a')
                                          .format(reservationdetails.message[index].tripDat!)
                                          .toString(),
                                      style: fontStyle(
                                          color: AppColors.blackColor.withOpacity(0.6),
                                          fontSize: 12.sp,
                                          fontFamily: FontFamily.medium,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    10.verticalSpace,
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(2), color: Colors.grey[100]),
                                      child: Text(
                                        reservationdetails.message[index].notes!,
                                        style: fontStyle(
                                            color: AppColors.blackColor.withOpacity(0.5),
                                            fontSize: 12.sp,
                                            fontFamily: FontFamily.medium,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                "${reservationdetails.message[index].price!} ${reservationdetails.message[index].currencySymbole}",
                                style: fontStyle(
                                    color: reservationdetails.message[index].transactionTypeId == 7
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 14.sp,
                                    fontFamily: FontFamily.medium,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue[50],
                        border: Border.all(color: Colors.blue)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LanguageClass.isEnglish ? "Summary of amounts" : "ملخص المبالغ",
                          style: fontStyle(
                              color: Colors.blue[700]!,
                              fontFamily: FontFamily.bold,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        5.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              LanguageClass.isEnglish ? "Total amount" : "المبلغ الإجمالي:",
                              style: fontStyle(
                                  color: Colors.blue[700]!,
                                  fontFamily: FontFamily.medium,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "${reservation.price} ${Routes.curruncy}",
                              style: fontStyle(
                                  color: Colors.blue[900]!,
                                  fontFamily: FontFamily.medium,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        5.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              LanguageClass.isEnglish ? "Number of seats" : "عدد المقاعد:",
                              style: fontStyle(
                                  color: Colors.blue[700]!,
                                  fontFamily: FontFamily.medium,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "${reservation.seatNo}",
                              style: fontStyle(
                                  color: Colors.blue[900]!,
                                  fontFamily: FontFamily.medium,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        5.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              LanguageClass.isEnglish ? "Average seat price" : "متوسط سعر المقعد:",
                              style: fontStyle(
                                  color: Colors.blue[700]!,
                                  fontFamily: FontFamily.medium,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "${(reservation.price / reservation.seatNo).toStringAsFixed(2)} ${Routes.curruncy}",
                              style: fontStyle(
                                  color: Colors.blue[900]!,
                                  fontFamily: FontFamily.medium,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                          child: InkWell(
                              onTap: () {
                                _ticketcubit.getTicketdetails(tekitid: reservation.reservationId!);
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor),
                                  child: Text(
                                    LanguageClass.isEnglish ? "Print" : "طباعة التفاصيل",
                                    style: fontStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontFamily: FontFamily.bold,
                                        fontWeight: FontWeight.w600),
                                  )))),
                      10.horizontalSpace,
                      Expanded(
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColors.white),
                                  child: Text(
                                    LanguageClass.isEnglish ? "Close" : "اغلاق",
                                    style: fontStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        fontFamily: FontFamily.bold,
                                        fontWeight: FontWeight.w600),
                                  ))))
                    ],
                  )
                ],
              ),
            ),
          ),
        )),
  );
}
