import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/icon_back.dart';
import 'package:intl/intl.dart' as intl;

import 'package:swa/features/new_statistics.dart/bloc/statistics_bloc.dart';
import 'package:swa/features/new_statistics.dart/model/All_statics_model.dart';

class ReservationsReportsScreen extends StatefulWidget {
  AllStaticsModel allStaticsModel;
  ReservationsReportsScreen({super.key, required this.allStaticsModel});

  @override
  State<ReservationsReportsScreen> createState() => _ReservationsReportsScreenState();
}

class _ReservationsReportsScreenState extends State<ReservationsReportsScreen> {
  Widget _buildCell(String text, {bool isHeader = false, bool isfirst = false, bool islast = false}) {
    return Container(
      height: 50.h,
      alignment: Alignment.center,
      padding: isHeader ? EdgeInsets.all(12) : EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
      margin: isHeader ? EdgeInsets.only(bottom: 5.h) : EdgeInsets.zero,
      decoration: BoxDecoration(
          color: isHeader ? AppColors.primaryColor.withOpacity(0.3) : Colors.blue[50],
          borderRadius: isfirst
              ? BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))
              : islast
                  ? BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))
                  : null),
      child: Text(
        text,
        style: fontStyle(fontFamily: isHeader ? FontFamily.bold : FontFamily.medium, fontSize: 12.sp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<StatisticsBloc, StatisticsState>(
        bloc: BlocProvider.of<StatisticsBloc>(context),
        listener: (context, state) {
          // TODO: implement listener
        },
        child: BlocBuilder<StatisticsBloc, StatisticsState>(
          bloc: BlocProvider.of<StatisticsBloc>(context),
          builder: (context, state) {
            return Directionality(
              textDirection: LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(width: 34.w, child: iconBack(context)),
                          Text(
                            LanguageClass.isEnglish ? "Reservations reports" : "تقارير الحجوزات",
                            style: fontStyle(color: Colors.black, fontSize: 16.sp, fontFamily: FontFamily.bold),
                          ),
                          Container(
                            width: 34.w,
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Center(
                        child: Text(
                          LanguageClass.isEnglish
                              ? "View and analyze detailed reports related to flight reservations."
                              : "عرض وتحليل التقارير المفصلة المتعلقة بحجوزات الرحلات.",
                          style: fontStyle(color: Colors.black.withOpacity(0.6), fontSize: 12.sp),
                        ),
                      ),
                      10.verticalSpace,
                      Expanded(
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                          spreadRadius: 1)
                                    ],
                                    borderRadius: BorderRadius.circular(8)),
                                child: TabBar(
                                    dividerColor: Colors.transparent,
                                    dividerHeight: 0,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicatorPadding: EdgeInsets.zero,
                                    padding: EdgeInsets.zero,
                                    labelPadding: EdgeInsets.zero,
                                    indicator: null,
                                    labelStyle: fontStyle(
                                        fontFamily: FontFamily.bold, fontSize: 12.sp, fontWeight: FontWeight.w600),
                                    indicatorWeight: 0.1,
                                    indicatorColor: AppColors.primaryColor,
                                    labelColor: Colors.black,
                                    unselectedLabelColor: Colors.grey[500],
                                    tabs: [
                                      Tab(
                                        text: LanguageClass.isEnglish ? "Total Reservations" : "اجمالي الحجوزات",
                                      ),
                                      Tab(
                                        text: LanguageClass.isEnglish ? "Detailed trips" : "الرحلات المفصلة",
                                      ),
                                    ]),
                              ),
                              10.verticalSpace,
                              Expanded(
                                child: TabBarView(children: [
                                  Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5.w),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.black.withOpacity(0.4),
                                              )),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                color: AppColors.primaryColor,
                                              ),
                                              5.horizontalSpace,
                                              Text(
                                                LanguageClass.isEnglish ? "Select date range" : "اختر نطاق التاريخ",
                                                style: fontStyle(fontFamily: FontFamily.medium, fontSize: 12.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                        15.verticalSpace,
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: AppColors.primaryColor,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.picture_as_pdf_rounded,
                                                        color: Colors.white,
                                                      ),
                                                      5.horizontalSpace,
                                                      Text(
                                                        LanguageClass.isEnglish ? "Export to pdf" : "تصدير إلى pdf",
                                                        style: fontStyle(
                                                            fontFamily: FontFamily.medium,
                                                            fontSize: 12.sp,
                                                            color: Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            10.horizontalSpace,
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: AppColors.primaryColor,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.download,
                                                        color: Colors.white,
                                                      ),
                                                      5.horizontalSpace,
                                                      Text(
                                                        LanguageClass.isEnglish ? "Export to Excel" : "تصدير إلى Excel",
                                                        style: fontStyle(
                                                            fontFamily: FontFamily.medium,
                                                            fontSize: 12.sp,
                                                            color: Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        20.verticalSpace,
                                        Flexible(
                                          child: ListView.separated(
                                            itemCount: widget.allStaticsModel.message!.reservations!.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (BuildContext context, int index) {
                                              var formatter =
                                                  intl.DateFormat.yMMMEd(LanguageClass.isEnglish ? 'en_US' : 'ar_SA');

                                              return Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${LanguageClass.isEnglish ? "Date" : "التاريخ"} : ${formatter.format(
                                                      widget.allStaticsModel.message!.reservations![index].tripDate!,
                                                    )}",
                                                    style: fontStyle(
                                                        color: AppColors.primaryColor,
                                                        fontSize: 14.sp,
                                                        fontFamily: FontFamily.bold),
                                                  ),
                                                  5.verticalSpace,
                                                  SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Table(
                                                      defaultColumnWidth: FixedColumnWidth(120.0),
                                                      children: [
                                                        TableRow(children: [
                                                          _buildCell(LanguageClass.isEnglish ? "Time" : 'الوقت',
                                                              isHeader: true, isfirst: true),
                                                          _buildCell(
                                                              LanguageClass.isEnglish ? "Trip Number" : 'رقم الرحلة',
                                                              isHeader: true),
                                                          _buildCell(
                                                              LanguageClass.isEnglish ? "Trip Type" : 'نوع الرحلة',
                                                              isHeader: true),
                                                          _buildCell(LanguageClass.isEnglish ? "From" : 'من',
                                                              isHeader: true),
                                                          _buildCell(LanguageClass.isEnglish ? "To" : 'إلى',
                                                              isHeader: true),
                                                          _buildCell(
                                                              LanguageClass.isEnglish
                                                                  ? 'Number of Reservations'
                                                                  : 'عدد الحجوزات',
                                                              isHeader: true),
                                                          _buildCell(LanguageClass.isEnglish ? "Options" : 'خيارات',
                                                              isHeader: true, islast: true),
                                                        ]),
                                                        TableRow(children: [
                                                          _buildCell(
                                                              intl.DateFormat('hh:mm a')
                                                                  .format(widget.allStaticsModel.message!
                                                                      .reservations![index].tripDate!)
                                                                  .toString(),
                                                              isfirst: true),
                                                          _buildCell(widget.allStaticsModel.message!
                                                              .reservations![index].ticketNumber
                                                              .toString()),
                                                          _buildCell("Null"),
                                                          _buildCell(widget.allStaticsModel.message!
                                                              .reservations![index].fromStation!),
                                                          _buildCell(widget.allStaticsModel.message!
                                                              .reservations![index].toStation!),
                                                          _buildCell(widget
                                                              .allStaticsModel.message!.reservations![index].seatNo
                                                              .toString()),
                                                          InkWell(
                                                            child: Container(
                                                              height: 50.h,
                                                              padding:
                                                                  EdgeInsets.symmetric(horizontal: 12, vertical: 10.h),
                                                              margin: EdgeInsets.zero,
                                                              decoration: BoxDecoration(
                                                                  color: Colors.blue[50],
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius.circular(8),
                                                                      bottomLeft: Radius.circular(8))),
                                                              child: Container(
                                                                height: 40.h,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    color: AppColors.primaryColor),
                                                                alignment: Alignment.center,
                                                                child: Text(
                                                                  LanguageClass.isEnglish ? "View" : "عرض",
                                                                  style: fontStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 12.sp,
                                                                      fontFamily: FontFamily.bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            separatorBuilder: (BuildContext context, int index) {
                                              return Divider();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Text("Detailed trips"),
                                  ),
                                ]),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
