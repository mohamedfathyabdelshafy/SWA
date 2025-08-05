import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/new_statistics.dart/bloc/statistics_bloc.dart';
import 'package:swa/features/new_statistics.dart/model/All_statics_model.dart';
import 'package:swa/features/new_statistics.dart/Sceens/statistics_main.dart';

Widget StatisticsWidget(
    {required BuildContext context,
    required List<statistics> statisticslist,
    required AllStaticsModel allStaticsModel}) {
  return ListView(
    shrinkWrap: true,
    physics: ScrollPhysics(),
    children: [
      ListView.builder(
        itemCount: statisticslist.length,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (BuildContext context, int index) {
          return buildCard(
              color: AppColors.primaryColor,
              title: statisticslist[index].title!,
              value: statisticslist[index].value!,
              icon: statisticslist[index].image,
              ontap: () {
                switch (index) {
                  case 0:
                    showPaymentDetails(context: context, payment: allStaticsModel.message!.payments!);

                    break;

                  case 1:
                    showReservationsDetails(context: context, payment: allStaticsModel.message!.reservations!);
                    break;
                  case 2:
                    showRewardsDetails(context: context, payment: allStaticsModel.message!.rewards!);
                    break;

                  case 3:
                    showPenaltyDetails(context: context, payment: allStaticsModel.message!.penalties!);
                    break;

                  case 4:
                    showFeesDetails(context: context, payment: allStaticsModel.message!.fees!);
                    break;

                  case 5:
                    showRefundsDetails(context: context, payment: allStaticsModel.message!.refunds!);
                    break;

                  default:
                }
              });
        },
        shrinkWrap: true,
        physics: ScrollPhysics(),
      ),
      20.verticalSpace,
      Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            )
          ]),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      width: 20.w,
                      "assets/images/wallet.svg",
                      color: Colors.black,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(LanguageClass.isEnglish ? "Wallet Details" : "تفاصيل المحفظة",
                      style: fontStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, fontFamily: FontFamily.bold)),
                ],
              ),
              10.verticalSpace,
              Row(
                children: [
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor.withOpacity(0.3)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/TrendingUp-24px.svg",
                                    width: 20.w,
                                    color: AppColors.primaryColor,
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    LanguageClass.isEnglish ? "Recharge Wallet" : "شحن المحفظة",
                                    style: fontStyle(
                                        fontFamily: FontFamily.medium,
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              Text(
                                "${allStaticsModel.message!.payments!.fold(
                                      0.0,
                                      (previousValue, element) =>
                                          previousValue + (element.statusId == 22 ? element.amount : 0),
                                    ).toStringAsFixed(2)} ${Routes.curruncy}",
                                style: fontStyle(
                                    fontFamily: FontFamily.bold,
                                    fontSize: 16.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ))),
                  5.horizontalSpace,
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor.withOpacity(0.3)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/bus24.svg",
                                    width: 20.w,
                                    color: AppColors.primaryColor,
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    LanguageClass.isEnglish ? "Booked Seats" : "حجز المقاعد",
                                    style: fontStyle(
                                        fontFamily: FontFamily.medium,
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              Text(
                                "${allStaticsModel.message!.reservations!.fold(
                                      0.0,
                                      (previousValue, element) =>
                                          previousValue + (element.status != 61 ? element.price : 0),
                                    ).toStringAsFixed(2)} ${Routes.curruncy}",
                                style: fontStyle(
                                    fontFamily: FontFamily.bold,
                                    fontSize: 16.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          )))
                ],
              ),
              5.verticalSpace,
              Row(
                children: [
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor.withOpacity(0.3)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/Calendar-24px.svg",
                                    width: 20.w,
                                    color: AppColors.primaryColor,
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    LanguageClass.isEnglish ? "Penalties" : "الغرامات",
                                    style: fontStyle(
                                        fontFamily: FontFamily.medium,
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              Text(
                                "${allStaticsModel.message!.penalties!.fold(0.0, (previousValue, element) => previousValue + element.penalty).toStringAsFixed(2)} ${Routes.curruncy}",
                                style: fontStyle(
                                    fontFamily: FontFamily.bold,
                                    fontSize: 16.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ))),
                  5.horizontalSpace,
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor.withOpacity(0.3)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/MapPin-24px.svg",
                                    width: 20.w,
                                    color: AppColors.primaryColor,
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    LanguageClass.isEnglish ? "Umra Trips" : "رحلات العمرة ",
                                    style: fontStyle(
                                        fontFamily: FontFamily.medium,
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              Text(
                                "0 ${Routes.curruncy}",
                                style: fontStyle(
                                    fontFamily: FontFamily.bold,
                                    fontSize: 16.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          )))
                ],
              )
            ],
          )),
      20.verticalSpace,
      Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            )
          ]),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    width: 20.w,
                    "assets/images/MapPin-24px.svg",
                  ),
                ),
                10.horizontalSpace,
                Text(LanguageClass.isEnglish ? "Favorite Routes" : "الخطوط المفضلة",
                    style: fontStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, fontFamily: FontFamily.bold)),
              ],
            ),
            10.verticalSpace,
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: allStaticsModel?.message?.topRoutes?.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(10.w),
                  margin: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[100]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor.withOpacity(0.3)),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          "assets/images/bus24.svg",
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(allStaticsModel?.message?.topRoutes?[index].routeName ?? "",
                                style: fontStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14.sp, fontFamily: FontFamily.bold)),
                            3.verticalSpace,
                            Text(
                                "${allStaticsModel?.message?.topRoutes?[index].tripCount.toString()} ${LanguageClass.isEnglish ? "Trips" : "رحلات"}",
                                style: fontStyle(
                                    fontWeight: FontWeight.normal, fontSize: 12.sp, fontFamily: FontFamily.regular)),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              "${allStaticsModel?.message?.topRoutes?[index].totalPrice.toString()} ${Routes.curruncy}",
                              style: fontStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                  fontFamily: FontFamily.medium)),
                          5.verticalSpace,
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.blackColor, width: 0.5),
                                color: Colors.white),
                            child: Text(
                              "#${index + 1}",
                              style: fontStyle(
                                  color: Colors.black.withOpacity(0.5), fontSize: 10.sp, fontFamily: FontFamily.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ])),
      20.verticalSpace,
      Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            )
          ]),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    width: 20.w,
                    "assets/images/Calendar-24px.svg",
                  ),
                ),
                10.horizontalSpace,
                Text(LanguageClass.isEnglish ? "Monthly Statistics" : "الاحصائيات الشهرية",
                    style: fontStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, fontFamily: FontFamily.bold)),
              ],
            ),
            10.verticalSpace,
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: allStaticsModel?.message?.monthlyStats?.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(10.w),
                  margin: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[100]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor.withOpacity(0.3)),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          "assets/images/Calendar-24px.svg",
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(allStaticsModel?.message!.monthlyStats![index].monthName ?? "",
                                style: fontStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14.sp, fontFamily: FontFamily.bold)),
                            3.verticalSpace,
                            Text(
                                "${allStaticsModel?.message!.monthlyStats![index].reservationCount.toString()} ${LanguageClass.isEnglish ? "Reservations" : "حجز"}",
                                style: fontStyle(
                                    fontWeight: FontWeight.normal, fontSize: 12.sp, fontFamily: FontFamily.regular)),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${allStaticsModel?.message!.monthlyStats![index].reservationTotal} ${Routes.curruncy}",
                              style: fontStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                  fontFamily: FontFamily.medium)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ]))
    ],
  );
}

Future _printPaymentsReport({
  required List<Payment> payment,
}) async {
  final pdf = pw.Document();
  final isAr = !LanguageClass.isEnglish;

  final ttf = pw.Font.ttf(
    await rootBundle.load('assets/fonts/arabic_medium.ttf'),
  );
  final ttfBold = pw.Font.ttf(
    await rootBundle.load('assets/fonts/arabic_bold.ttf'),
  );

  final logo = pw.MemoryImage(
    (await rootBundle.load('assets/images/Logo.png')).buffer.asUint8List(),
  );

  List<List<Payment>> chunks = chunkList(payment, 20);

  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.natural,
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttfBold,
      ),
      margin: const pw.EdgeInsets.all(10),
      build: (context) {
        return List<pw.Widget>.generate(
          chunks.length,
          (index) {
            return pw.Directionality(
              textDirection: isAr ? pw.TextDirection.rtl : pw.TextDirection.ltr,
              child: pw.Container(
                alignment: pw.Alignment.topRight,
                padding: const pw.EdgeInsets.all(10), // Inner padding from border
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text(LanguageClass.isEnglish ? "Total Payment" : "إجمالي المدفوعات",
                          style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Table(border: pw.TableBorder.all(width: 0.5), children: [
                      pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle, children: [
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Description" : 'تفاصيل',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Amount" : 'القيمة',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Payment Method" : 'طريقة الدفع',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Date" : 'تاريخ الدفع',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Status" : 'الحالة',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ]),
                      for (int i = 0; i < chunks[index].length; i++)
                        pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle, children: [
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              chunks[index][i].description!,
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              chunks[index][i].amount.toString(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              chunks[index][i].paymentMethod!,
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              intl.DateFormat('dd-MM-yyyy hh:mm a').format(chunks[index][i].creationDate!).toString(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              LanguageClass.isEnglish ? 'Confirmed' : 'مؤكد',
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ]),
                    ])
                  ],
                ),
              ),
            );
          },
        );
      }));

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

Future _printPenaltieyReport({
  required List<Penalty> penalty,
}) async {
  final pdf = pw.Document();
  final isAr = !LanguageClass.isEnglish;

  final ttf = pw.Font.ttf(
    await rootBundle.load('assets/fonts/arabic_medium.ttf'),
  );
  final ttfBold = pw.Font.ttf(
    await rootBundle.load('assets/fonts/arabic_bold.ttf'),
  );

  final logo = pw.MemoryImage(
    (await rootBundle.load('assets/images/Logo.png')).buffer.asUint8List(),
  );

  List<List<Penalty>> chunks = chunkList(penalty, 20);

  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.natural,
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttfBold,
      ),
      margin: const pw.EdgeInsets.all(10),
      build: (context) {
        return List<pw.Widget>.generate(
          chunks.length,
          (index) {
            return pw.Directionality(
              textDirection: isAr ? pw.TextDirection.rtl : pw.TextDirection.ltr,
              child: pw.Container(
                alignment: pw.Alignment.topRight,
                padding: const pw.EdgeInsets.all(10), // Inner padding from border
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text(LanguageClass.isEnglish ? "Total Penalties" : "اجمالي الغرامات",
                          style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Table(border: pw.TableBorder.all(width: 0.5), children: [
                      pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle, children: [
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Line name" : ' الخط',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Amount" : 'القيمة',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Date" : 'تاريخ الدفع',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Status" : 'الحالة',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ]),
                      for (int i = 0; i < chunks[index].length; i++)
                        pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle, children: [
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              LanguageClass.isEnglish ? chunks[index][i].lineNameEn! : chunks[index][i].lineNameAr!,
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              "${chunks[index][i].penalty.toString()} ${Routes.curruncy}",
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              intl.DateFormat('dd-MM-yyyy hh:mm a')
                                  .format(chunks[index][i].transactionDate!)
                                  .toString(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              LanguageClass.isEnglish ? 'Confirmed' : 'مؤكد',
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ]),
                    ])
                  ],
                ),
              ),
            );
          },
        );
      }));

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

Future _printFeesReport({
  required List<Fee> fees,
}) async {
  final pdf = pw.Document();
  final isAr = !LanguageClass.isEnglish;

  final ttf = pw.Font.ttf(
    await rootBundle.load('assets/fonts/arabic_medium.ttf'),
  );
  final ttfBold = pw.Font.ttf(
    await rootBundle.load('assets/fonts/arabic_bold.ttf'),
  );

  final logo = pw.MemoryImage(
    (await rootBundle.load('assets/images/Logo.png')).buffer.asUint8List(),
  );

  List<List<Fee>> chunks = chunkList(fees, 20);

  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.natural,
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttfBold,
      ),
      margin: const pw.EdgeInsets.all(10),
      build: (context) {
        return List<pw.Widget>.generate(
          chunks.length,
          (index) {
            return pw.Directionality(
              textDirection: isAr ? pw.TextDirection.rtl : pw.TextDirection.ltr,
              child: pw.Container(
                alignment: pw.Alignment.topRight,
                padding: const pw.EdgeInsets.all(10), // Inner padding from border
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text(LanguageClass.isEnglish ? "Administrative Fees" : "المصاريف الادارية",
                          style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Table(border: pw.TableBorder.all(width: 0.5), children: [
                      pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle, children: [
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Description" : 'تفاصيل',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Amount" : 'القيمة',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Date" : 'تاريخ الدفع',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Status" : 'الحالة',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ]),
                      for (int i = 0; i < chunks[index].length; i++)
                        pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle, children: [
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              " description"!,
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              "${chunks[index][i].feeAmount.toString()} ${Routes.curruncy}",
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              intl.DateFormat('dd-MM-yyyy hh:mm a')
                                  .format(chunks[index][i].transactionDate!)
                                  .toString(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              LanguageClass.isEnglish ? 'Confirmed' : 'مؤكد',
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ]),
                    ])
                  ],
                ),
              ),
            );
          },
        );
      }));

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

Future _printRefundReport({
  required List<Refund> refunds,
}) async {
  final pdf = pw.Document();
  final isAr = !LanguageClass.isEnglish;

  final ttf = pw.Font.ttf(
    await rootBundle.load('assets/fonts/arabic_medium.ttf'),
  );
  final ttfBold = pw.Font.ttf(
    await rootBundle.load('assets/fonts/arabic_bold.ttf'),
  );

  final logo = pw.MemoryImage(
    (await rootBundle.load('assets/images/Logo.png')).buffer.asUint8List(),
  );

  List<List<Refund>> chunks = chunkList(refunds, 20);

  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.natural,
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttfBold,
      ),
      margin: const pw.EdgeInsets.all(10),
      build: (context) {
        return List<pw.Widget>.generate(
          chunks.length,
          (index) {
            return pw.Directionality(
              textDirection: isAr ? pw.TextDirection.rtl : pw.TextDirection.ltr,
              child: pw.Container(
                alignment: pw.Alignment.topRight,
                padding: const pw.EdgeInsets.all(10), // Inner padding from border
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text(LanguageClass.isEnglish ? "Total Refund" : "اجمالي الاسترداد",
                          style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Table(border: pw.TableBorder.all(width: 0.5), children: [
                      pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle, children: [
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Description" : 'تفاصيل',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Amount" : 'القيمة',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Date" : 'تاريخ الدفع',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Status" : 'الحالة',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ]),
                      for (int i = 0; i < chunks[index].length; i++)
                        pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle, children: [
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              " description"!,
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              "${chunks[index][i].amount.toString()} ${Routes.curruncy}",
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              intl.DateFormat('dd-MM-yyyy hh:mm a').format(chunks[index][i].paymentDate!).toString(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              LanguageClass.isEnglish ? 'Confirmed' : 'مؤكد',
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ]),
                    ])
                  ],
                ),
              ),
            );
          },
        );
      }));

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

List<List<T>> chunkList<T>(List<T> list, int chunkSize) {
  List<List<T>> chunks = [];
  for (var i = 0; i < list.length; i += chunkSize) {
    int end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
    chunks.add(list.sublist(i, end));
  }
  return chunks;
}

Future _printReservattionReport({
  required List<Reservation> reservation,
}) async {
  final pdf = pw.Document();
  final isAr = !LanguageClass.isEnglish;

  final ttf = pw.Font.ttf(
    await rootBundle.load('assets/fonts/arabic_medium.ttf'),
  );
  final ttfBold = pw.Font.ttf(
    await rootBundle.load('assets/fonts/arabic_bold.ttf'),
  );

  final logo = pw.MemoryImage(
    (await rootBundle.load('assets/images/Logo.png')).buffer.asUint8List(),
  );

  List<List<Reservation>> chunks = chunkList(reservation, 20);

  print(chunks.length);

  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.natural,
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttfBold,
      ),
      margin: const pw.EdgeInsets.all(10),
      build: (context) {
        return List<pw.Widget>.generate(
          chunks.length,
          (index) {
            return pw.Directionality(
              textDirection: isAr ? pw.TextDirection.rtl : pw.TextDirection.ltr,
              child: pw.Container(
                alignment: pw.Alignment.topRight,
                padding: const pw.EdgeInsets.all(10), // Inner padding from border
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text(LanguageClass.isEnglish ? "Total reservations" : "إجمالي الحجوزات",
                          style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Table(border: pw.TableBorder.all(width: 0.5), children: [
                      pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle, children: [
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Ticket number" : 'رقم التذكرة',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Trip date" : 'تاريخ الرحلة',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Trip time" : 'وقت القيام',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "From" : "من",
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "To" : 'الى',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Price" : 'السعر',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ]),
                      for (int i = 0; i < chunks[index].length; i++)
                        pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle, children: [
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              chunks[index][i].ticketNumber.toString()!,
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              intl.DateFormat('dd-MM-yyyy').format(chunks[index][i].tripDate!).toString(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              intl.DateFormat('hh:mm a').format(chunks[index][i].tripDate!).toString(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              chunks[index][i].fromStation!,
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              chunks[index][i].toStation!,
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              "${chunks[index][i].price} ${Routes.curruncy}",
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ]),
                    ])
                  ],
                ),
              ),
            );
          },
        );
      }));

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

Future _printRewardsReport({
  required List<Reward> reward,
}) async {
  final pdf = pw.Document();
  final isAr = !LanguageClass.isEnglish;

  final ttf = pw.Font.ttf(
    await rootBundle.load('assets/fonts/arabic_medium.ttf'),
  );
  final ttfBold = pw.Font.ttf(
    await rootBundle.load('assets/fonts/arabic_bold.ttf'),
  );

  final logo = pw.MemoryImage(
    (await rootBundle.load('assets/images/Logo.png')).buffer.asUint8List(),
  );

  List<List<Reward>> chunks = chunkList(reward, 20);

  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.natural,
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttfBold,
      ),
      margin: const pw.EdgeInsets.all(10),
      build: (context) {
        return List<pw.Widget>.generate(
          chunks.length,
          (index) {
            return pw.Directionality(
              textDirection: isAr ? pw.TextDirection.rtl : pw.TextDirection.ltr,
              child: pw.Container(
                alignment: pw.Alignment.topRight,
                padding: const pw.EdgeInsets.all(10), // Inner padding from border
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text(LanguageClass.isEnglish ? "Rewards" : "ارصدة الهدايا",
                          style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Table(border: pw.TableBorder.all(width: 0.5), children: [
                      pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle, children: [
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Description" : 'التفاصيل',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "date" : 'تاريخ ',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            LanguageClass.isEnglish ? "Amount" : ' المبلغ',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ]),
                      for (int i = 0; i < chunks[index].length; i++)
                        pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle, children: [
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              LanguageClass.isEnglish ? chunks[index][i].nameEn! : chunks[index][i].nameAr!,
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              intl.DateFormat('dd-MM-yyyy').format(chunks[index][i].creationDate!).toString(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 30,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              "${chunks[index][i].amount} ${Routes.curruncy}",
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ]),
                    ])
                  ],
                ),
              ),
            );
          },
        );
      }));

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

Widget buildCard(
    {required String title,
    required String value,
    required Color color,
    String? icon,
    double fontSize = 18,
    final ontap}) {
  return Container(
    padding: EdgeInsets.all(14),
    margin: EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(
      children: [
        if (icon != null)
          SvgPicture.asset(
            icon,
            color: color,
            width: 20.w,
          ),
        if (icon != null) SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style:
                      fontStyle(color: Colors.black.withOpacity(0.5), fontSize: 12.sp, fontFamily: FontFamily.medium)),
              SizedBox(height: 4),
              Text(value, style: fontStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, fontFamily: FontFamily.bold)),
            ],
          ),
        ),
        InkWell(
            onTap: ontap,
            child:
                Text(LanguageClass.isEnglish ? "Show details" : "عرض التفاصيل", style: TextStyle(color: Colors.black))),
      ],
    ),
  );
}

Future showPaymentDetails({
  required BuildContext context,
  required List<Payment> payment,
}) async {
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
                      width: 30.w,
                      height: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        "assets/images/CreditCard-24px.svg",
                        width: 15.w,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      LanguageClass.isEnglish ? "Total Payment" : "إجمالي المدفوعات",
                      style: fontStyle(fontFamily: FontFamily.bold, fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                5.verticalSpace,
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    LanguageClass.isEnglish
                        ? "Details of all payments in this batch"
                        : "تفاصيل جميع المدفوعات في هذه الفئة",
                    style: fontStyle(
                        fontFamily: FontFamily.regular,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                ),
                10.verticalSpace,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(width: 0.5, color: Colors.grey)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(LanguageClass.isEnglish ? "Total" : "الاجمالي",
                          style: fontStyle(
                              fontFamily: FontFamily.regular,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.6))),
                      5.verticalSpace,
                      Text(
                          "${payment.fold(
                                0.0,
                                (previousValue, element) => previousValue + element.amount,
                              ).toString()} ${Routes.curruncy}",
                          style: fontStyle(
                              fontFamily: FontFamily.bold,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor))
                    ],
                  ),
                ),
                10.verticalSpace,
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: payment.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 0)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    payment[index].description!.toString(),
                                    style: fontStyle(
                                        fontSize: 14.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  Text(
                                    intl.DateFormat('dd-MM-yyyy hh:mm a')
                                        .format(payment[index].creationDate!)
                                        .toString(),
                                    style: fontStyle(
                                        fontSize: 12.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  2.verticalSpace,
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                                    child: Text(
                                      payment[index].paymentMethod!,
                                      style: fontStyle(
                                          fontSize: 12.sp,
                                          fontFamily: FontFamily.medium,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${payment[index].amount.toString()} ${Routes.curruncy}",
                                  style: fontStyle(
                                      fontSize: 14.sp,
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor),
                                ),
                                10.verticalSpace,
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.green.withOpacity(0.2),
                                      border: Border.all(color: Colors.green)),
                                  child: Text(
                                    LanguageClass.isEnglish ? "Completed" : "مكتمل",
                                    style: fontStyle(
                                        fontSize: 8.sp,
                                        fontFamily: FontFamily.bold,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                20.verticalSpace,
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _printPaymentsReport(payment: payment);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor),
                                child: Text(
                                  LanguageClass.isEnglish ? "Export" : "تصدير تقرير",
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
        )),
  );
}

Future showReservationsDetails({
  required BuildContext context,
  required List<Reservation> payment,
}) async {
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
                      width: 30.w,
                      height: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        "assets/images/bus24.svg",
                        width: 15.w,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      LanguageClass.isEnglish ? "Total Reservations" : "إجمالي الحجوزات",
                      style: fontStyle(fontFamily: FontFamily.bold, fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                5.verticalSpace,
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    LanguageClass.isEnglish
                        ? "Details of all reservations in this batch"
                        : "تفاصيل جميع الحجوزات في هذه الفئة",
                    style: fontStyle(
                        fontFamily: FontFamily.regular,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                ),
                10.verticalSpace,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(width: 0.5, color: Colors.grey)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(LanguageClass.isEnglish ? "Total" : "الاجمالي",
                          style: fontStyle(
                              fontFamily: FontFamily.regular,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.6))),
                      5.verticalSpace,
                      Text("${payment.length} ${LanguageClass.isEnglish ? "Reservations" : "حجز"}",
                          style: fontStyle(
                              fontFamily: FontFamily.bold,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor))
                    ],
                  ),
                ),
                10.verticalSpace,
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: payment.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 0)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${payment[index].fromStation} - ${payment[index].toStation}",
                                    style: fontStyle(
                                        fontSize: 12.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  Text(
                                    intl.DateFormat('dd-MM-yyyy hh:mm a').format(payment[index].tripDate!).toString(),
                                    style: fontStyle(
                                        fontSize: 12.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${payment[index].seatNo} ${LanguageClass.isEnglish ? "Seat" : "مقعد"}",
                                  style: fontStyle(
                                      fontSize: 14.sp,
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor),
                                ),
                                10.verticalSpace,
                                payment![index].status == 60
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
                                    : payment[index].status == 61
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
                                        : payment[index].status == 62
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
                                            : payment[index].status == 63
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
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                20.verticalSpace,
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _printReservattionReport(reservation: payment);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor),
                                child: Text(
                                  LanguageClass.isEnglish ? "Export" : "تصدير تقرير",
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
        )),
  );
}

Future showRewardsDetails({
  required BuildContext context,
  required List<Reward> payment,
}) async {
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
                      width: 30.w,
                      height: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        "assets/images/Gift-24px.svg",
                        width: 15.w,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      LanguageClass.isEnglish ? "Rewards" : "ارصدة الهدايا",
                      style: fontStyle(fontFamily: FontFamily.bold, fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                5.verticalSpace,
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    LanguageClass.isEnglish
                        ? "Details of all rewards in this batch"
                        : "تفاصيل جميع الهدايا في هذه الفئة",
                    style: fontStyle(
                        fontFamily: FontFamily.regular,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                ),
                10.verticalSpace,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(width: 0.5, color: Colors.grey)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(LanguageClass.isEnglish ? "Total" : "الاجمالي",
                          style: fontStyle(
                              fontFamily: FontFamily.regular,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.6))),
                      5.verticalSpace,
                      Text(
                          "${payment.fold(
                                0.0,
                                (previousValue, element) => previousValue + element.amount,
                              ).toString()} ${Routes.curruncy}",
                          style: fontStyle(
                              fontFamily: FontFamily.bold,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor))
                    ],
                  ),
                ),
                10.verticalSpace,
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: payment.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 0)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LanguageClass.isEnglish ? payment[index].nameEn! : payment[index].nameAr!,
                                    style: fontStyle(
                                        fontSize: 14.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  Text(
                                    intl.DateFormat('dd-MM-yyyy hh:mm a')
                                        .format(payment[index].creationDate!)
                                        .toString(),
                                    style: fontStyle(
                                        fontSize: 12.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  2.verticalSpace,
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                                    child: Text(
                                      payment[index].rewardsId.toString(),
                                      style: fontStyle(
                                          fontSize: 12.sp,
                                          fontFamily: FontFamily.medium,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${payment[index].amount} ${Routes.curruncy}",
                                  style: fontStyle(
                                      fontSize: 14.sp,
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor),
                                ),
                                10.verticalSpace,
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.green.withOpacity(0.2),
                                      border: Border.all(color: Colors.green)),
                                  child: Text(
                                    LanguageClass.isEnglish ? "Completed" : "مكتمل",
                                    style: fontStyle(
                                        fontSize: 8.sp,
                                        fontFamily: FontFamily.bold,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                20.verticalSpace,
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _printRewardsReport(reward: payment);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor),
                                child: Text(
                                  LanguageClass.isEnglish ? "Export" : "تصدير تقرير",
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
        )),
  );
}

Future showPenaltyDetails({
  required BuildContext context,
  required List<Penalty> payment,
}) async {
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
                      width: 30.w,
                      height: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        "assets/images/warning.svg",
                        width: 15.w,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      LanguageClass.isEnglish ? "Total penalties" : "اجمالي الغرامات",
                      style: fontStyle(fontFamily: FontFamily.bold, fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                5.verticalSpace,
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    LanguageClass.isEnglish
                        ? "Details of all penalties in this batch"
                        : "تفاصيل جميع الغرامات في هذه الفئة",
                    style: fontStyle(
                        fontFamily: FontFamily.regular,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                ),
                10.verticalSpace,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(width: 0.5, color: Colors.grey)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(LanguageClass.isEnglish ? "Total" : "الاجمالي",
                          style: fontStyle(
                              fontFamily: FontFamily.regular,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.6))),
                      5.verticalSpace,
                      Text(
                          "${payment.fold(
                                0.0,
                                (previousValue, element) => previousValue + element.penalty,
                              ).toString()} ${Routes.curruncy}",
                          style: fontStyle(
                              fontFamily: FontFamily.bold,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor))
                    ],
                  ),
                ),
                10.verticalSpace,
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: payment.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 0)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LanguageClass.isEnglish ? payment[index].lineNameEn! : payment[index].lineNameAr!,
                                    style: fontStyle(
                                        fontSize: 14.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  Text(
                                    intl.DateFormat('dd-MM-yyyy hh:mm a')
                                        .format(payment[index].transactionDate!)
                                        .toString(),
                                    style: fontStyle(
                                        fontSize: 12.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  2.verticalSpace,
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${payment[index].penalty} ${Routes.curruncy}",
                                  style: fontStyle(
                                      fontSize: 14.sp,
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor),
                                ),
                                10.verticalSpace,
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.green.withOpacity(0.2),
                                      border: Border.all(color: Colors.green)),
                                  child: Text(
                                    LanguageClass.isEnglish ? "Completed" : "مكتمل",
                                    style: fontStyle(
                                        fontSize: 8.sp,
                                        fontFamily: FontFamily.bold,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                20.verticalSpace,
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _printPenaltieyReport(penalty: payment);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor),
                                child: Text(
                                  LanguageClass.isEnglish ? "Export" : "تصدير تقرير",
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
        )),
  );
}

Future showFeesDetails({
  required BuildContext context,
  required List<Fee> payment,
}) async {
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
                      width: 30.w,
                      height: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        "assets/images/DollarSign-24px.svg",
                        width: 15.w,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      LanguageClass.isEnglish ? "Administrative Fees" : "المصاريف الادارية",
                      style: fontStyle(fontFamily: FontFamily.bold, fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                5.verticalSpace,
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    LanguageClass.isEnglish ? "Details of all fees in this batch" : "تفاصيل جميع المصاريف في هذه الفئة",
                    style: fontStyle(
                        fontFamily: FontFamily.regular,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                ),
                10.verticalSpace,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(width: 0.5, color: Colors.grey)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(LanguageClass.isEnglish ? "Total" : "الاجمالي",
                          style: fontStyle(
                              fontFamily: FontFamily.regular,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.6))),
                      5.verticalSpace,
                      Text(
                          "${payment.fold(
                                0.0,
                                (previousValue, element) => previousValue + element.feeAmount,
                              ).toString()} ${Routes.curruncy}",
                          style: fontStyle(
                              fontFamily: FontFamily.bold,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor))
                    ],
                  ),
                ),
                10.verticalSpace,
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: payment.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 0)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Null",
                                    style: fontStyle(
                                        fontSize: 14.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  Text(
                                    intl.DateFormat('dd-MM-yyyy hh:mm a')
                                        .format(payment[index].transactionDate!)
                                        .toString(),
                                    style: fontStyle(
                                        fontSize: 12.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  2.verticalSpace,
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                                    child: Text(
                                      payment[index].transactionId.toString(),
                                      style: fontStyle(
                                          fontSize: 12.sp,
                                          fontFamily: FontFamily.medium,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${payment[index].feeAmount} ${Routes.curruncy}",
                                  style: fontStyle(
                                      fontSize: 14.sp,
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor),
                                ),
                                10.verticalSpace,
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.green.withOpacity(0.2),
                                      border: Border.all(color: Colors.green)),
                                  child: Text(
                                    LanguageClass.isEnglish ? "Completed" : "مكتمل",
                                    style: fontStyle(
                                        fontSize: 8.sp,
                                        fontFamily: FontFamily.bold,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                20.verticalSpace,
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _printFeesReport(fees: payment);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor),
                                child: Text(
                                  LanguageClass.isEnglish ? "Export" : "تصدير تقرير",
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
        )),
  );
}

Future showRefundsDetails({
  required BuildContext context,
  required List<Refund> payment,
}) async {
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
                      width: 30.w,
                      height: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        "assets/images/TrendingDown-24px.svg",
                        width: 15.w,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      LanguageClass.isEnglish ? "Total Refund" : "اجمالي الاسترداد",
                      style: fontStyle(fontFamily: FontFamily.bold, fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                5.verticalSpace,
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    LanguageClass.isEnglish
                        ? "Details of all refund in this batch"
                        : "تفاصيل جميع الاسترداد في هذه الفئة",
                    style: fontStyle(
                        fontFamily: FontFamily.regular,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                ),
                10.verticalSpace,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(width: 0.5, color: Colors.grey)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(LanguageClass.isEnglish ? "Total" : "الاجمالي",
                          style: fontStyle(
                              fontFamily: FontFamily.regular,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.6))),
                      5.verticalSpace,
                      Text(
                          "${payment.fold(
                                0.0,
                                (previousValue, element) => previousValue + element.amount,
                              ).toString()} ${Routes.curruncy}",
                          style: fontStyle(
                              fontFamily: FontFamily.bold,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor))
                    ],
                  ),
                ),
                10.verticalSpace,
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: payment.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 0)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Null",
                                    style: fontStyle(
                                        fontSize: 14.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  Text(
                                    intl.DateFormat('dd-MM-yyyy hh:mm a')
                                        .format(payment[index].paymentDate!)
                                        .toString(),
                                    style: fontStyle(
                                        fontSize: 12.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  2.verticalSpace,
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                                    child: Text(
                                      payment[index].paymentToCustomerId.toString(),
                                      style: fontStyle(
                                          fontSize: 12.sp,
                                          fontFamily: FontFamily.medium,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${payment[index].amount} ${Routes.curruncy}",
                                  style: fontStyle(
                                      fontSize: 14.sp,
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor),
                                ),
                                10.verticalSpace,
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.green.withOpacity(0.2),
                                      border: Border.all(color: Colors.green)),
                                  child: Text(
                                    LanguageClass.isEnglish ? "Completed" : "مكتمل",
                                    style: fontStyle(
                                        fontSize: 8.sp,
                                        fontFamily: FontFamily.bold,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                20.verticalSpace,
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _printRefundReport(refunds: payment);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor),
                                child: Text(
                                  LanguageClass.isEnglish ? "Export" : "تصدير تقرير",
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
        )),
  );
}
