import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:indexed/indexed.dart';
import 'package:intl/intl.dart' as intl;
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/hex_color.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/Screens/umra_reservation_screen/1_transportation_screen.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/campainlistmodel.dart';
import 'package:swa/features/Swa_umra/models/page_model.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/Swa_umra/repository/Umra_repository.dart';
import 'package:jhijri_picker/_src/_jWidgets.dart';
import 'package:jhijri/jHijri.dart';

class TriplistScreen extends StatefulWidget {
  String city, date;
  int typeid;
  int? umrahReservationID;
  TriplistScreen(
      {super.key,
      required this.city,
      required this.date,
      this.umrahReservationID,
      required this.typeid});

  @override
  State<TriplistScreen> createState() => _TriplistScreenState();
}

class _TriplistScreenState extends State<TriplistScreen> {
  final UmraBloc _umraBloc = UmraBloc();

  int selectedpackage = 0;
  List<ListElement>? listcampains = [];

  int opentap = -1;
  int selectedtripid = -1;

  bool transportationactive = true;
  bool addprogram = true;

  List<bool> checkvalue = [];
  List<Pagedata> pagedata = [];

  DateTime? date;

  String selectedDate = '';
  int tripumraid = 0;
  bool ishijiri = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _umraBloc.add(GetCompainListEvent());
    _umraBloc.add(GetPageListEvent());

    if (widget.umrahReservationID != null) {
      UmraDetails.tripdate = widget.date;
      UmraDetails.cityid = widget.city;
      UmraDetails.tripTypeUmrahID = widget.typeid;
    }
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
              UmraDetails.campainid =
                  state.campainlistmodel!.message!.list!.first.campiagnUmraId!;
              _umraBloc.add(GetPackageListEvent(
                  reservationid: widget.umrahReservationID,
                  campianID: state
                      .campainlistmodel!.message!.list!.first.campiagnUmraId!,
                  city: widget.city,
                  date: widget.date,
                  typeid: widget.typeid));
            } else if (state.pagelistmodel?.status == "success") {
              pagedata = state.pagelistmodel!.message!;
            } else if (state.packagesModel?.status == "success") {
              for (int i = 0; i < state.packagesModel!.message!.length; i++) {
                if (state.packagesModel!.message![i].isReserved == true) {
                  selectedtripid = i;

                  tripumraid = state.packagesModel!.message![i].tripUmrahId!;
                }
              }
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
                              margin:
                                  const EdgeInsets.only(left: 27, right: 27),
                              alignment: LanguageClass.isEnglish
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.arrow_back_rounded,
                                      color: AppColors.umragold,
                                      size: 25,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      customdatepicker(
                                        context: context,
                                        hijiri: ishijiri,
                                        onchange: (hdate) {
                                          date = hdate.date;
                                          hdate.jhijri.fDisplay =
                                              DisplayFormat.MMDDYYYY;

                                          ishijiri
                                              ? selectedDate =
                                                  hdate.jhijri.toString()
                                              : selectedDate =
                                                  intl.DateFormat('MM-dd-yyyy')
                                                      .format(date!)
                                                      .toString();

                                          _umraBloc.add(GetPackageListEvent(
                                              reservationid:
                                                  widget.umrahReservationID,
                                              campianID: UmraDetails.campainid,
                                              city: widget.city,
                                              date: selectedDate,
                                              typeid: widget.typeid));
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    child: SvgPicture.asset(
                                        'assets/images/calender.svg'),
                                  )
                                ],
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
                                  LanguageClass.isEnglish
                                      ? 'Packages'
                                      : 'الحملات',
                                  style: fontStyle(
                                      fontSize: 24.sp,
                                      fontFamily: FontFamily.bold,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                )),
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
                                            listcampains!.length,
                                            (index) => Indexed(
                                                  index: index,
                                                  key: UniqueKey(),
                                                  child: InkWell(
                                                    onTap: () {
                                                      UmraDetails.campainid =
                                                          listcampains![index]
                                                              .campiagnUmraId!;
                                                      _umraBloc.add(GetPackageListEvent(
                                                          reservationid: widget
                                                              .umrahReservationID,
                                                          campianID: listcampains![
                                                                  index]
                                                              .campiagnUmraId!,
                                                          city: widget.city,
                                                          date: widget.date,
                                                          typeid:
                                                              widget.typeid));
                                                      setState(() {
                                                        selectedpackage = index;
                                                      });
                                                      print(selectedpackage);
                                                    },
                                                    child: AnimatedContainer(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              selectedpackage ==
                                                                      index
                                                                  ? 30
                                                                  : 5,
                                                          right: 5),
                                                      margin: EdgeInsets.only(
                                                          left: index * 80),
                                                      decoration: BoxDecoration(
                                                          boxShadow:
                                                              selectedpackage ==
                                                                      index
                                                                  ? [
                                                                      BoxShadow(
                                                                          offset: Offset(4,
                                                                              0),
                                                                          color: Colors.black.withOpacity(
                                                                              0.4),
                                                                          blurRadius:
                                                                              4,
                                                                          spreadRadius:
                                                                              0)
                                                                    ]
                                                                  : [
                                                                      BoxShadow(
                                                                          offset: Offset(4,
                                                                              0),
                                                                          color: Colors.black.withOpacity(
                                                                              0.2),
                                                                          blurRadius:
                                                                              2,
                                                                          spreadRadius:
                                                                              0)
                                                                    ],
                                                          color: HexColor(
                                                              listcampains![
                                                                          index]
                                                                      .bgColor ??
                                                                  '#AEAEAE'),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      13)),
                                                      width: selectedpackage ==
                                                              index
                                                          ? 148
                                                          : 100,
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
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitWidth,
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
                                                                style: fontStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .bold,
                                                                    fontSize:
                                                                        18),
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
                            10.verticalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: selectedtripid != -1
                                        ? Container(
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
                                                      color:
                                                          AppColors.umragold),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                            ),
                                          )
                                        : Container(
                                            width: 27,
                                            height: 27,
                                            decoration: BoxDecoration(
                                                color: Color(0xffC6C6C6),
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                          ),
                                  ),
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
                            Container(
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
                            Expanded(
                              child: state.packagesModel!.message!.length > 0
                                  ? ListView.builder(
                                      itemCount:
                                          state.packagesModel!.message!.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      physics: ScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return state.packagesModel!
                                                .message![index].isActive!
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
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
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      margin: EdgeInsets.only(
                                                          top: 10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                          image:
                                                              DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  opacity: 1,
                                                                  colorFilter: ColorFilter.mode(
                                                                      HexColor(state
                                                                          .packagesModel!
                                                                          .message![
                                                                              index]
                                                                          .bgColor!),
                                                                      BlendMode
                                                                          .multiply),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  image:
                                                                      NetworkImage(
                                                                    state
                                                                        .packagesModel!
                                                                        .message![
                                                                            index]
                                                                        .image!,
                                                                  ))),
                                                      child: Column(
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
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Flexible(
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  child: Text(
                                                                    state
                                                                        .packagesModel!
                                                                        .message![
                                                                            index]
                                                                        .name!,
                                                                    style: fontStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            FontFamily
                                                                                .bold,
                                                                        fontSize:
                                                                            25.sp),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                '${LanguageClass.isEnglish ? 'Availability' : 'المتاح'}  ${state.packagesModel!.message![index].availability!}',
                                                                style: fontStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .bold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        11.sp),
                                                              ),
                                                            ],
                                                          ),
                                                          9.verticalSpace,
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                width: 100.w,
                                                                child: Wrap(
                                                                  alignment:
                                                                      WrapAlignment
                                                                          .start,
                                                                  runAlignment:
                                                                      WrapAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      WrapCrossAlignment
                                                                          .start,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  runSpacing:
                                                                      2.w,
                                                                  spacing: 2.w,
                                                                  children: state
                                                                      .packagesModel!
                                                                      .message![
                                                                          index]
                                                                      .nightList!
                                                                      .map((e) =>
                                                                          FittedBox(
                                                                            fit:
                                                                                BoxFit.fitWidth,
                                                                            child:
                                                                                Container(
                                                                              child: Text(
                                                                                '${e.cityName!} ${e.nights!} ${LanguageClass.isEnglish ? 'N' : 'ليلة'}',
                                                                                style: fontStyle(color: Colors.white, fontFamily: FontFamily.bold, fontWeight: FontWeight.w400, fontSize: 12.sp),
                                                                              ),
                                                                            ),
                                                                          ))
                                                                      .toList(),
                                                                ),
                                                              ),
                                                              4.horizontalSpace,
                                                              Container(
                                                                width: 20.w,
                                                                child: state
                                                                            .packagesModel!
                                                                            .message![index]
                                                                            .accommodationType ==
                                                                        ''
                                                                    ? 0.horizontalSpace
                                                                    : FittedBox(
                                                                        fit: BoxFit
                                                                            .contain,
                                                                        child:
                                                                            Text(
                                                                          state.packagesModel!.message![index].accommodationType ??
                                                                              '-',
                                                                          style: fontStyle(
                                                                              color: Colors.white,
                                                                              fontFamily: FontFamily.bold,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 13.sp),
                                                                        ),
                                                                      ),
                                                              ),
                                                              4.horizontalSpace,
                                                              FittedBox(
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                                child: Text(
                                                                  state
                                                                      .packagesModel!
                                                                      .message![
                                                                          index]
                                                                      .tripTime!,
                                                                  style: fontStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .bold,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          12.sp),
                                                                ),
                                                              ),
                                                              2.horizontalSpace,
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedtripid ==
                                                                            index
                                                                        ? selectedtripid =
                                                                            -1
                                                                        : selectedtripid =
                                                                            index;

                                                                    tripumraid = state
                                                                        .packagesModel!
                                                                        .message![
                                                                            index]
                                                                        .tripUmrahId!;
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          20.w,
                                                                      vertical:
                                                                          6.h),
                                                                  decoration: BoxDecoration(
                                                                      color: selectedtripid ==
                                                                              index
                                                                          ? Color(
                                                                              0xffecb959)
                                                                          : Colors
                                                                              .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              41)),
                                                                  child: Text(
                                                                    LanguageClass
                                                                            .isEnglish
                                                                        ? "Select"
                                                                        : 'اختر',
                                                                    style: fontStyle(
                                                                        color: selectedtripid ==
                                                                                index
                                                                            ? Colors
                                                                                .white
                                                                            : Color(
                                                                                0xffCACACA),
                                                                        fontFamily:
                                                                            FontFamily
                                                                                .bold,
                                                                        fontSize: 14
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                state
                                                                    .packagesModel!
                                                                    .message![
                                                                        index]
                                                                    .tripDate!,
                                                                style: fontStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .bold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        12.sp),
                                                              ),
                                                              10.horizontalSpace,
                                                              state
                                                                      .packagesModel!
                                                                      .message![
                                                                          index]
                                                                      .withTransportation!
                                                                  ? Text(
                                                                      LanguageClass
                                                                              .isEnglish
                                                                          ? 'Transportation'
                                                                          : 'المواصلات',
                                                                      style: fontStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontFamily: FontFamily
                                                                              .bold,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontSize:
                                                                              12.sp),
                                                                    )
                                                                  : SizedBox(),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  opentap == index
                                                      ? Flexible(
                                                          child:
                                                              ListView.builder(
                                                            itemCount: state
                                                                .packagesModel!
                                                                .message![index]
                                                                .detailsList!
                                                                .length,
                                                            shrinkWrap: true,
                                                            physics:
                                                                ScrollPhysics(),
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index2) {
                                                              return state
                                                                      .packagesModel!
                                                                      .message![
                                                                          index]
                                                                      .detailsList![
                                                                          index2]
                                                                      .isActive!
                                                                  ? Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 10),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Expanded(
                                                                              child: RichText(
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                            text:
                                                                                TextSpan(text: state.packagesModel!.message![index].detailsList![index2].description!, style: fontStyle(color: Colors.black, fontSize: 13.sp, height: 1, fontFamily: FontFamily.medium, fontWeight: FontWeight.w500), children: [
                                                                              state.packagesModel!.message![index].detailsList![index2].withMoreLink!
                                                                                  ? TextSpan(
                                                                                      recognizer: TapGestureRecognizer()
                                                                                        ..onTap = () {
                                                                                          UmraRepos().launchInWebView(state.packagesModel!.message![index].detailsList![index2].moreLink!);
                                                                                        },
                                                                                      text: '... more.',
                                                                                      style: fontStyle(color: Colors.black, fontSize: 14.sp, decoration: TextDecoration.underline, fontFamily: FontFamily.bold, fontWeight: FontWeight.w500),
                                                                                    )
                                                                                  : TextSpan()
                                                                            ]),
                                                                          )),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : SizedBox();
                                                            },
                                                          ),
                                                        )
                                                      : SizedBox()
                                                ],
                                              )
                                            : SizedBox();
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                        LanguageClass.isEnglish
                                            ? 'No Packages!'
                                            : 'لا يوجد حملات',
                                        style: fontStyle(
                                          color: Colors.black,
                                          fontFamily: FontFamily.bold,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 20.w),
                              alignment: LanguageClass.isEnglish
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft,
                              child: InkWell(
                                onTap: () {
                                  if (selectedtripid != -1) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TransportationScreen(
                                                  umrahReservationID:
                                                      widget.umrahReservationID,
                                                  selectedpackage:
                                                      selectedpackage,
                                                  typeid: tripumraid),
                                        ));
                                  }
                                },
                                child: Container(
                                  height: 35,
                                  width: 70,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: selectedtripid == -1
                                          ? Color(0xffC3C3C3)
                                          : Color(0xffecb959),
                                      borderRadius: BorderRadius.circular(41)),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      LanguageClass.isEnglish
                                          ? "Next"
                                          : 'التالي',
                                      style: fontStyle(
                                          fontFamily: FontFamily.bold,
                                          fontSize: 18.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )
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

  Future customdatepicker(
      {required BuildContext context,
      required bool hijiri,
      required onchange(JPickerValue date)}) async {
    return showGlobalDatePicker(
      context: context,
      headerTitle: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: InkWell(
            onTap: () {
              Navigator.pop(context);
              ishijiri = !ishijiri;
              customdatepicker(
                context: context,
                hijiri: ishijiri,
                onchange: onchange,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  hijiri
                      ? LanguageClass.isEnglish
                          ? 'Hijri'
                          : 'هجري'
                      : LanguageClass.isEnglish
                          ? 'Gregorian'
                          : "ميلادي",
                  style: fontStyle(
                      height: 1.2,
                      fontFamily: FontFamily.medium,
                      fontSize: 14.sp,
                      color: AppColors.blackColor),
                ),
                5.horizontalSpace,
                Icon(
                  Icons.change_circle_rounded,
                  color: AppColors.umragold,
                  size: 20,
                )
              ],
            )),
      ),
      selectedDate: JDateModel(jhijri: JHijri.now(), dateTime: DateTime.now()),
      pickerMode: DatePickerMode.day,
      pickerTheme: Theme.of(context),
      textDirection: TextDirection.ltr,
      buttons: Container(),
      locale: LanguageClass.isEnglish ? Locale("en", "US") : Locale("ar", ""),
      pickerType: hijiri ? PickerType.JHijri : PickerType.JNormal,
      onChange: onchange,
      primaryColor: AppColors.umragold,
      calendarTextColor: Colors.black,
      backgroundColor: Colors.white,
      borderRadius: const Radius.circular(0),
      buttonTextColor: Colors.white,
    );
  }
}
