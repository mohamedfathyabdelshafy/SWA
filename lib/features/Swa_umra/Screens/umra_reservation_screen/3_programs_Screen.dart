import 'dart:developer';

import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indexed/indexed.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/hex_color.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/Screens/umra_reservation_screen/4_reservation_screen.dart';

import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';

import 'package:swa/features/Swa_umra/models/campainlistmodel.dart';
import 'package:swa/features/Swa_umra/models/programs_model.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/Swa_umra/repository/Umra_repository.dart';
import 'package:html/parser.dart' show parse;

import 'customer_details_form.dart';

class ProgramsScreen extends StatefulWidget {
  int typeid, selectedpackage;
  int? umrahReservationID;

  ProgramsScreen(
      {super.key,
      required this.selectedpackage,
      required this.typeid,
      this.umrahReservationID});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  final UmraBloc _umraBloc = UmraBloc();
  // List<bool> checkvalue = [];

  int selectedpackage = 0;
  int descriptiontap = -1;

  Map<int, int> programsReservationCount = {};

  List<ListElement>? listcampains = [];
  ProgramsModel? programsModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedpackage = widget.selectedpackage;
    _umraBloc.add(GetCompainListEvent());
    _umraBloc.add(GetprogramsEvent(
      tripUmrahID: widget.typeid,
      umrahReservationID: widget.umrahReservationID,
    ));
  }

  String stripHtml(String htmlString) {
    final document = parse(htmlString);
    return parse(document.body?.text).documentElement?.text ?? '';
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
            } else if (state.programsModel?.status == "success") {
              programsModel = state.programsModel;
              state.programsModel!.message?.forEach((element) {
                log("test hena");
                programsReservationCount[element.tripUnrahProgramId!] = 0;
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
                                    left: LanguageClass.isEnglish ? 16.sp : 0,
                                    right: LanguageClass.isEnglish ? 0 : 16.sp),
                                alignment: LanguageClass.isEnglish
                                    ? Alignment.topLeft
                                    : Alignment.topRight,
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? 'Packages'
                                      : 'الحملات',
                                  style: fontStyle(
                                      fontSize: 24.sp,
                                      fontFamily: FontFamily.bold,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                )),
                            SizedBox(
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
                                                            left: LanguageClass
                                                                    .isEnglish
                                                                ? (selectedpackage == index &&
                                                                        index !=
                                                                            0
                                                                    ? 30
                                                                    : 5)
                                                                : (selectedpackage ==
                                                                            index &&
                                                                        index !=
                                                                            0
                                                                    ? 5
                                                                    : 30),
                                                            right: LanguageClass
                                                                    .isEnglish
                                                                ? (index ==
                                                                        listcampains!.length -
                                                                            1
                                                                    ? 15
                                                                    : 5)
                                                                : (index ==
                                                                        listcampains!.length -
                                                                            1
                                                                    ? 5
                                                                    : 15)),
                                                        margin: EdgeInsets.only(
                                                            left: index * 80),
                                                        decoration:
                                                            BoxDecoration(
                                                                boxShadow:
                                                                    selectedpackage ==
                                                                            index
                                                                        ? [
                                                                            BoxShadow(
                                                                                offset: Offset(4, 0),
                                                                                color: Colors.black.withOpacity(0.4),
                                                                                blurRadius: 4,
                                                                                spreadRadius: 0)
                                                                          ]
                                                                        : [
                                                                            BoxShadow(
                                                                                offset: Offset(4, 0),
                                                                                color: Colors.black.withOpacity(0.2),
                                                                                blurRadius: 2,
                                                                                spreadRadius: 0)
                                                                          ],
                                                                color: HexColor(
                                                                    listcampains![index]
                                                                            .bgColor ??
                                                                        '#AEAEAE'),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            13)),
                                                        width:
                                                            selectedpackage ==
                                                                    index
                                                                ? 140
                                                                : 120,
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
                                                                style:
                                                                    fontStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .bold,
                                                                  fontSize: selectedpackage ==
                                                                          index
                                                                      ? 12.sp
                                                                      : 10.sp,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
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
                            SizedBox(
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
                            10.verticalSpace,
                            programsModel?.message == null ||
                                    programsModel!.message!.isEmpty
                                ? Expanded(
                                    child: Center(
                                      child: Text(
                                        LanguageClass.isEnglish
                                            ? 'There are currently no programs'
                                            : 'لا يوجد برامج حالياً',
                                        style: fontStyle(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                            fontFamily: FontFamily.medium),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                        itemCount:
                                            programsModel?.message?.length,
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final program =
                                              programsModel!.message![index];

                                          final programId =
                                              program.tripUnrahProgramId!;

                                          int programReservationCount =
                                              programsReservationCount[
                                                      programId] ??
                                                  0;

                                          final descriptionHtml = programsModel!
                                              .message![index].description![0];
                                          final plainTextPreview =
                                              stripHtml(descriptionHtml);

                                          return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                10.verticalSpace,
                                                Container(
                                                  width: double.infinity,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 6.h),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.w),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  programsReservationCount[
                                                                      programId] = 0;
                                                                });
                                                              },
                                                              child: Container(
                                                                width: 20.w,
                                                                height: 20.w,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                0),
                                                                    border: Border.all(
                                                                        width:
                                                                            2,
                                                                        color: Color(
                                                                            0xff707070))),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(2),
                                                                child: programReservationCount >
                                                                        0
                                                                    ? Container(
                                                                        width:
                                                                            18.w,
                                                                        height:
                                                                            18.w,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(0),
                                                                            color: Color(0xff707070)),
                                                                      )
                                                                    : SizedBox(),
                                                              ),
                                                            ),
                                                            10.horizontalSpace,
                                                            Expanded(
                                                              child: Text(
                                                                programsModel!
                                                                    .message![
                                                                        index]
                                                                    .title!,
                                                                style:
                                                                    fontStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  height: 1.2,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        programReservationCount !=
                                                                0
                                                            ? "${double.parse((programsModel!.message![index].price * programReservationCount).toString()).toStringAsFixed(2)} ${Routes.curruncy ?? ""}"
                                                            : "${programsModel!.message![index].price} ${Routes.curruncy ?? ""}",
                                                        style: fontStyle(
                                                          fontSize: 14.sp,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1.2,
                                                          fontFamily:
                                                              FontFamily.medium,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                program.isRequired ?? false
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .only(
                                                                    start:
                                                                        45.w),
                                                        child: Text(
                                                          LanguageClass
                                                                  .isEnglish
                                                              ? '*required'
                                                              : '*مطلوب',
                                                          style: fontStyle(
                                                            fontSize: 12.sp,
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1.2,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.w),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                        child: Container(
                                                          width: 80.w,
                                                          height: 80.w,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Image.network(
                                                            programsModel!
                                                                .message![index]
                                                                .image!,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      7.horizontalSpace,
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              child: programsModel!
                                                                      .message![
                                                                          index]
                                                                      .description![
                                                                          0]
                                                                      .toString()
                                                                      .contains(
                                                                          "</")
                                                                  ? ExpandableNotifier(
                                                                      child:
                                                                          Builder(
                                                                        builder:
                                                                            (context) {
                                                                          final controller = ExpandableController.of(
                                                                              context,
                                                                              required: true);

                                                                          return ExpandablePanel(
                                                                            theme:
                                                                                ExpandableThemeData(
                                                                              headerAlignment: ExpandablePanelHeaderAlignment.center,
                                                                              tapBodyToExpand: true,
                                                                              tapBodyToCollapse: true,
                                                                              hasIcon: false,
                                                                            ),
                                                                            collapsed:
                                                                                Text(
                                                                              stripHtml(descriptionHtml),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: fontStyle(
                                                                                fontSize: 14.sp,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.normal,
                                                                                height: 1.2,
                                                                              ),
                                                                            ),
                                                                            expanded:
                                                                                Html(
                                                                              data: descriptionHtml,
                                                                              style: {
                                                                                "*": Style(
                                                                                  fontSize: FontSize(14.sp),
                                                                                  color: Colors.black,
                                                                                  lineHeight: LineHeight.number(1.2),
                                                                                ),
                                                                              },
                                                                            ),
                                                                            builder: (_,
                                                                                collapsed,
                                                                                expanded) {
                                                                              return Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Expandable(
                                                                                    collapsed: collapsed,
                                                                                    expanded: expanded,
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () => controller.toggle(),
                                                                                    child: Padding(
                                                                                        padding: EdgeInsets.only(top: 4),
                                                                                        child: Icon(
                                                                                          controller!.expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                                                                          color: AppColors.umragold,
                                                                                        )),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    )
                                                                  : RichText(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      softWrap:
                                                                          true,
                                                                      maxLines:
                                                                          3,
                                                                      text: TextSpan(
                                                                          text: programsModel?.message![index].description![0].toString(),
                                                                          recognizer: TapGestureRecognizer()
                                                                            ..onTap = () {
                                                                              setState(() {
                                                                                descriptiontap = index;
                                                                              });
                                                                            },
                                                                          style: fontStyle(
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            fontSize:
                                                                                13.sp,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            height:
                                                                                1.2,
                                                                            fontFamily:
                                                                                FontFamily.bold,
                                                                          ),
                                                                          children: [
                                                                            programsModel?.message![index].withMoreLink == true
                                                                                ? TextSpan(
                                                                                    recognizer: TapGestureRecognizer()
                                                                                      ..onTap = () {
                                                                                        UmraRepos().launchInWebView(programsModel?.message![index].moreLink!);
                                                                                      },
                                                                                    text: '...more.',
                                                                                    style: fontStyle(overflow: TextOverflow.visible, color: Color(0xff009dff), fontSize: 13.sp, decoration: TextDecoration.underline, fontFamily: FontFamily.bold, fontWeight: FontWeight.w500),
                                                                                  )
                                                                                : TextSpan()
                                                                          ]),
                                                                    ),
                                                            ),
                                                            6.verticalSpace,
                                                            Container(
                                                              width: 80.w,
                                                              height: 18.h,
                                                              decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .umragold,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4)),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    child: InkWell(
                                                                        onTap: () {
                                                                          final canDecreaseCount =
                                                                              programReservationCount > 0;
                                                                          if (canDecreaseCount) {
                                                                            setState(() {
                                                                              programsReservationCount[programId] = programReservationCount - 1;
                                                                            });
                                                                          }
                                                                        },
                                                                        child: Container(
                                                                          height:
                                                                              18.h,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical: 2.sp,
                                                                              horizontal: 8.sp),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: programsReservationCount[programId]! > 0 ? Colors.white : Colors.grey,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(4), // Rounded corners
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.remove,
                                                                            size:
                                                                                14.sp,
                                                                            color: programsReservationCount[programId]! > 0
                                                                                ? Colors.white
                                                                                : Colors.grey,
                                                                          ),
                                                                          //     Text(
                                                                          //   '-',
                                                                          //   textAlign:
                                                                          //       TextAlign.center,
                                                                          //   style: fontStyle(
                                                                          //       color: Colors.white,
                                                                          //       fontFamily: FontFamily.medium,
                                                                          //       height: 1.2,
                                                                          //       fontSize: 16.sp),
                                                                          // ),
                                                                        )),
                                                                  ),
                                                                  Text(
                                                                    programsReservationCount[
                                                                            programId]
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: fontStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        height:
                                                                            1.2,
                                                                        fontFamily:
                                                                            FontFamily
                                                                                .medium,
                                                                        fontSize:
                                                                            12.sp),
                                                                  ),
                                                                  Expanded(
                                                                    child: InkWell(
                                                                        onTap: () {
                                                                          // print(checkvalue.toString());
                                                                          setState(
                                                                              () {
                                                                            final isMax =
                                                                                program.personCountReserved! != 0 && program.personCountReserved! <= programsReservationCount[programId]!;
                                                                            if (isMax)
                                                                              return _showMaxError(context);

                                                                            programsReservationCount[programId] =
                                                                                programReservationCount + 1;
                                                                            programReservationCount +
                                                                                1;
                                                                          });
                                                                        },
                                                                        child: Container(
                                                                          height:
                                                                              18.h,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical: 2.sp,
                                                                              horizontal: 8.sp),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(color: Colors.white),
                                                                            borderRadius:
                                                                                BorderRadius.circular(4), // Rounded corners
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                14.sp,
                                                                          ),

                                                                          // Text(
                                                                          //   '+',
                                                                          //   textAlign:
                                                                          //       TextAlign.center,
                                                                          //   style: fontStyle(
                                                                          //       color: Colors.white,
                                                                          //       height: 1.2,
                                                                          //       fontFamily: FontFamily.medium,
                                                                          //       fontSize: 16.sp),
                                                                          // ),
                                                                        )),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ]);
                                        })),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Container(
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
                                        height: 40.sp,
                                        width: 80.sp,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 2.h),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Color(0xffecb959),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            LanguageClass.isEnglish
                                                ? "Previous"
                                                : 'السابق',
                                            style: fontStyle(
                                                fontFamily: FontFamily.bold,
                                                fontSize: 16.sp,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      // onTap: () {
                                      //   UmraDetails.umraprograms = [];
                                      //   UmraDetails.programsNumber = [];
                                      //
                                      //   // check if response is not success
                                      //   // check if any program is required and count is less than 0
                                      //   final isSucces =
                                      //       programsModel?.status == 'success';
                                      //   bool hasRequiredUnselectedPrograms =
                                      //       false;
                                      //   if (!isSucces) return;
                                      //
                                      //   programsModel?.message
                                      //       ?.forEach((program) {
                                      //     final isProgramRequiredAndCountLessThanZero =
                                      //         program.isRequired == true &&
                                      //             programsReservationCount[program
                                      //                     .tripUnrahProgramId]! <=
                                      //                 0;
                                      //     hasRequiredUnselectedPrograms =
                                      //         isProgramRequiredAndCountLessThanZero;
                                      //     if (isProgramRequiredAndCountLessThanZero)
                                      //       return _showErrorSnackbar(context);
                                      //
                                      //     if (programsReservationCount[
                                      //             program.tripUnrahProgramId]! >
                                      //         0) {
                                      //       UmraDetails.umraprograms
                                      //           .add(program);
                                      //       UmraDetails.programsNumber.add(
                                      //           programsReservationCount[program
                                      //               .tripUnrahProgramId]!);
                                      //     }
                                      //   });
                                      //   if (!hasRequiredUnselectedPrograms)
                                      //     Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 ReservationScreen(
                                      //                   umrahReservationID: widget
                                      //                       .umrahReservationID,
                                      //                   selectedpackage:
                                      //                       selectedpackage,
                                      //                   typeid: widget.typeid,
                                      //                 )));
                                      // },

                                      onTap: () {
                                        UmraDetails.umraprograms = [];
                                        UmraDetails.programsNumber = [];

                                        final isSucces =
                                            programsModel?.status == 'success';
                                        bool hasRequiredUnselectedPrograms =
                                            false;
                                        if (!isSucces) return;

                                        programsModel?.message
                                            ?.forEach((program) {
                                          final isProgramRequiredAndCountLessThanZero =
                                              program.isRequired == true &&
                                                  programsReservationCount[program
                                                          .tripUnrahProgramId]! <=
                                                      0;
                                          hasRequiredUnselectedPrograms =
                                              isProgramRequiredAndCountLessThanZero;
                                          if (isProgramRequiredAndCountLessThanZero)
                                            return _showErrorSnackbar(context);

                                          if (programsReservationCount[
                                                  program.tripUnrahProgramId]! >
                                              0) {
                                            UmraDetails.umraprograms
                                                .add(program);
                                            UmraDetails.programsNumber.add(
                                                programsReservationCount[program
                                                    .tripUnrahProgramId]!);
                                          }
                                        });

                                        // Calculate total reserved seats for PassengerFormScreen
                                        int totalReservedSeats = 0;
                                        for (var entry
                                            in programsReservationCount
                                                .entries) {
                                          totalReservedSeats += entry.value;
                                        }
                                        // Ensure at least 1 passenger is reserved if companions are needed
                                        // If totalReservedSeats is 0, it means no programs were selected,
                                        // but if it's a new reservation (umrahReservationID == null),
                                        // we should proceed to PassengerFormScreen for at least the primary passenger.
                                        if (widget.umrahReservationID == null &&
                                            totalReservedSeats == 0) {
                                          // If no programs selected for a new reservation, assume 1 primary passenger
                                          totalReservedSeats = 1;
                                        }

                                        if (!hasRequiredUnselectedPrograms)
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PassengerFormScreen(
                                                        reservedSeats:
                                                            totalReservedSeats,
                                                        umrahReservationID: widget
                                                            .umrahReservationID,
                                                        selectedpackage:
                                                            selectedpackage,
                                                        typeid: widget.typeid,
                                                      )));
                                      },
                                      child: Container(
                                        height: 40.sp,
                                        width: 80.sp,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Color(0xffecb959),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            LanguageClass.isEnglish
                                                ? "Next"
                                                : 'التالي',
                                            style: fontStyle(
                                                fontFamily: FontFamily.bold,
                                                fontSize: 16.sp,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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

  void _showErrorSnackbar(BuildContext context) {
    return Constants.showDefaultSnackBar(
        color: Colors.red,
        context: context,
        text: LanguageClass.isEnglish
            ? 'Please Select Programs'
            : 'اختر البرامج');
  }

  void _showMaxError(BuildContext context) {
    return Constants.showDefaultSnackBar(
        color: Colors.red,
        context: context,
        text: LanguageClass.isEnglish
            ? 'this is the maximum persons in this program'
            : 'هذا هو الحد الأقصى لعدد الأشخاص في هذه البرنامج');
  }
}
