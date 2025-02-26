import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indexed/indexed.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/hex_color.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';

import 'package:swa/features/Swa_umra/Screens/umra_reservation_screen/3_programs_Screen.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/accomidation_model.dart';
import 'package:swa/features/Swa_umra/models/campainlistmodel.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/Swa_umra/models/umral_trip_model.dart';
import 'package:swa/features/Swa_umra/repository/Umra_repository.dart';

class AccomidationScreen extends StatefulWidget {
  final int typeid, selectedpackage;
  final int? umrahReservationID;

  const AccomidationScreen({super.key, required this.selectedpackage, required this.typeid, this.umrahReservationID});

  @override
  State<AccomidationScreen> createState() => _AccomidationScreenState();
}

class _AccomidationScreenState extends State<AccomidationScreen> {
  final UmraBloc _umraBloc = UmraBloc();

  int selectedpackage = 0;
  List<ListElement>? listcampains = [];

  AccomidationModel accomidationModel = AccomidationModel();
  List<bool> checkvalue = [];
  List<AcoomidationRoom> customernumber = [];
  int tapped = 0;

  List<ScrollController> scrollController = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedpackage = widget.selectedpackage;
    _umraBloc.add(GetCompainListEvent());

    _umraBloc.add(GetAccommodationEvent(tripUmrahID: widget.typeid, umrahReservationID: widget.umrahReservationID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener(
          bloc: _umraBloc,
          listener: _handleUmrahListenner,
          child: BlocBuilder(
              bloc: _umraBloc,
              builder: (context, UmraState state) {
                if (state.isloading) return Center(child: CircularProgressIndicator(color: AppColors.umragold));

                return SafeArea(
                    bottom: false,
                    child: Directionality(
                      textDirection: LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
                      child: Column(
                        children: [
                          10.verticalSpace,
                          _buildProgressBar(),
                          10.verticalSpace,
                          accomidationModel.message == null
                              ? _buildNoAccomodationsMessage()
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: accomidationModel.message?.length,
                                    physics: ScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildAccomodationInfo(index),
                                            5.verticalSpace,
                                            if (!(checkvalue[index] == false || tapped != index))
                                              SizedBox(
                                                height: accomidationModel.message![index].roomTypeList!.length > 3
                                                    ? MediaQuery.of(context).size.height * 0.6
                                                    : null,
                                                child: Scrollbar(
                                                  thickness: 10,
                                                  trackVisibility: true,
                                                  interactive: true,
                                                  controller: scrollController[index],
                                                  scrollbarOrientation: LanguageClass.isEnglish
                                                      ? ScrollbarOrientation.right
                                                      : ScrollbarOrientation.left,
                                                  radius: Radius.circular(12),
                                                  thumbVisibility: true,
                                                  child: ListView(
                                                    controller: scrollController[index],
                                                    shrinkWrap: true,
                                                    physics: ScrollPhysics(),
                                                    padding: EdgeInsets.zero,
                                                    children: [
                                                      _buildAccomodationDescription(index),
                                                      5.verticalSpace,
                                                      _buildRoomSelection(index),
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ]);
                                    },
                                  ),
                                ),
                          _buildNextAndPreviousButtons(context),
                        ],
                      ),
                    ));
              }),
        ),
        bottomNavigationBar: Navigationbottombar(currentIndex: 0));
  }

  ListView _buildRoomSelection(int acomodationIndex) {
    return ListView.builder(
      itemCount: accomidationModel.message![acomodationIndex].roomTypeList!.length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      itemBuilder: (BuildContext context, int roomIndex) {
        return accomidationModel.message![acomodationIndex].roomTypeList![roomIndex].isActive!
            ? Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 8.h,
                ),
                padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 9.h),
                decoration: BoxDecoration(
                  color: Color(0xfff4f4f4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80.w,
                      height: 80.w,
                      child:
                          Image.network(accomidationModel.message![acomodationIndex].roomTypeList![roomIndex].image!),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${accomidationModel.message![acomodationIndex].roomTypeList![roomIndex].typeRoom}",
                            style: fontStyle(
                                fontSize: 17.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                                fontFamily: FontFamily.medium),
                          ),
                          2.verticalSpace,
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                                text:
                                    accomidationModel.message![acomodationIndex].roomTypeList![roomIndex].description ??
                                        ' ',
                                style: fontStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    height: 1.2,
                                    fontFamily: FontFamily.regular),
                                children: [
                                  accomidationModel.message![acomodationIndex].roomTypeList![roomIndex].withMoreLink ==
                                          true
                                      ? TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              UmraRepos().launchInWebView(accomidationModel
                                                  .message![acomodationIndex].roomTypeList![roomIndex].moreLink!);
                                            },
                                          text: '...more.',
                                          style: fontStyle(
                                              color: Colors.black,
                                              fontSize: 12.sp,
                                              decoration: TextDecoration.underline,
                                              fontFamily: FontFamily.bold,
                                              fontWeight: FontWeight.w500),
                                        )
                                      : TextSpan()
                                ]),
                          ),
                          12.verticalSpace,
                          Text(
                            LanguageClass.isEnglish ? "Per person" : "سعر الفرد",
                            style: fontStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                                fontFamily: FontFamily.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                customernumber[acomodationIndex].customernumbers[roomIndex] == 0
                                    ? "${(accomidationModel.message![acomodationIndex].roomTypeList![roomIndex].price)} ${Routes.curruncy ?? ""}"
                                    : "${(accomidationModel.message![acomodationIndex].roomTypeList![roomIndex].price * customernumber[acomodationIndex].customernumbers[roomIndex]).toStringAsFixed(2)} ${Routes.curruncy ?? ""}",
                                style: fontStyle(
                                    color: Color(0xffff5d4b),
                                    fontSize: 10.sp,
                                    height: 1.2,
                                    fontFamily: FontFamily.regular,
                                    fontWeight: FontWeight.w500),
                              ),
                              9.horizontalSpace,
                              Text(
                                customernumber[acomodationIndex].customernumbers[roomIndex] == 0
                                    ? "${(accomidationModel.message![acomodationIndex].roomTypeList![roomIndex].priceBeforeDiscount)} ${Routes.curruncy ?? ""}"
                                    : "${(accomidationModel.message![acomodationIndex].roomTypeList![roomIndex].priceBeforeDiscount * customernumber[acomodationIndex].customernumbers[roomIndex]).toStringAsFixed(2)} ${Routes.curruncy ?? ""}",
                                style: fontStyle(
                                  color: Color(0xff9f9f9f),
                                  fontSize: 10.sp,
                                  height: 1.2,
                                  fontFamily: FontFamily.regular,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 80.w,
                                height: 18.h,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            final hasReservedRooms =
                                                customernumber[acomodationIndex].customernumbers[roomIndex] > 0;
                                            if (hasReservedRooms) _decreaseRoomCount(acomodationIndex, roomIndex);
                                          },
                                          child: Container(
                                            height: 18.h,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '-',
                                              textAlign: TextAlign.center,
                                              style: fontStyle(
                                                  color: Colors.black,
                                                  fontFamily: FontFamily.medium,
                                                  height: 1.2,
                                                  fontSize: 16.sp),
                                            ),
                                          )),
                                    ),
                                    Text(
                                      customernumber[acomodationIndex].customernumbers[roomIndex].toString(),
                                      textAlign: TextAlign.center,
                                      style: fontStyle(
                                          color: Colors.black,
                                          height: 1.2,
                                          fontFamily: FontFamily.medium,
                                          fontSize: 10.sp),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            final hasReservedBusSeats = UmraDetails.reservedseats.isNotEmpty;
                                            var _hasReachedMaximumAllowedRooms =
                                                customernumber[acomodationIndex].customernumbers[roomIndex] ==
                                                    accomidationModel.message![acomodationIndex]
                                                        .roomTypeList![roomIndex].numberAllow;

                                            return hasReservedBusSeats
                                                ? _handleReservedSeatsCase(acomodationIndex, roomIndex)
                                                : _hasReachedMaximumAllowedRooms
                                                    ? _showMaximumPersonsAllowedError(context)
                                                    : _increaseRoomCount(acomodationIndex, roomIndex);
                                          },
                                          child: Container(
                                            height: 18.h,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '+',
                                              textAlign: TextAlign.center,
                                              style: fontStyle(
                                                  color: Colors.black,
                                                  height: 1.2,
                                                  fontFamily: FontFamily.medium,
                                                  fontSize: 16.sp),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : SizedBox();
      },
    );
  }

  void _handleReservedSeatsCase(int acomodationIndex, int roomIndex) {
    final isLinkedWithTransportation = accomidationModel.object!.isLinkWithTransportation;
    final totalSeats =
        customernumber[acomodationIndex].customernumbers.fold(0, (previousValue, element) => previousValue + element);
    final reservedSeats = UmraDetails.reservedseats.first.seatsnumber.length;
    final isReservedSeatsMoreThanAllowed = isLinkedWithTransportation == true && totalSeats >= reservedSeats;
    final hasReachedMaxPersonsInRoom = customernumber[acomodationIndex].customernumbers[roomIndex] ==
        accomidationModel.message![acomodationIndex].roomTypeList![roomIndex].numberAllow;

    if (isReservedSeatsMoreThanAllowed) return _showUnEqualSeatAndAccomodationNumberError(context);
    if (hasReachedMaxPersonsInRoom) return _showMaximumPersonsAllowedError(context);
    return _increaseRoomCount(acomodationIndex, roomIndex);
  }

  void _increaseRoomCount(int acomodationIndex, int roomIndex) {
    setState(() {
      customernumber[acomodationIndex].customernumbers[roomIndex]++;
    });
  }

  void _decreaseRoomCount(int acomodationIndex, int roomIndex) {
    customernumber[acomodationIndex].customernumbers[roomIndex]--;
    setState(() {});
  }

  void _showMaximumPersonsAllowedError(BuildContext context) {
    return Constants.showDefaultSnackBar(
        context: context,
        text: LanguageClass.isEnglish
            ? 'this is the maximum persons in this room'
            : 'هذا هو الحد الأقصى لعدد الأشخاص في هذه الغرفة');
  }

  void _showUnEqualSeatAndAccomodationNumberError(BuildContext context) {
    return Constants.showDefaultSnackBar(
        context: context,
        text: LanguageClass.isEnglish
            ? 'select number of persons in the room same as person numbers in transportation'
            : 'حدد عدد الأشخاص في الغرفة بنفس عدد الأشخاص في وسائل النقل');
  }

  Container _buildAccomodationDescription(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
            text: accomidationModel.message![index].description![0].toString(),
            style: fontStyle(
                fontSize: 17.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.2,
                fontFamily: FontFamily.regular),
            children: [
              accomidationModel.message![index].withMoreLink == true
                  ? TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          UmraRepos().launchInWebView(accomidationModel.message![index].moreLink!);
                        },
                      text: '...more.',
                      style: fontStyle(
                          color: Colors.black,
                          fontSize: 17.sp,
                          decoration: TextDecoration.underline,
                          fontFamily: FontFamily.bold,
                          fontWeight: FontWeight.w500),
                    )
                  : TextSpan()
            ]),
      ),
    );
  }

  Widget _buildNoAccomodationsMessage() {
    return Center(
      child: Text(
        LanguageClass.isEnglish ? 'No Accommodation' : 'لا يوجد اقامة',
        style: fontStyle(fontFamily: FontFamily.bold, fontSize: 16.sp, height: 1.2, color: Colors.black),
      ),
    );
  }

  Widget _buildAccomodationInfo(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: accomidationModel.message![index].isRequired == true
                    ? () {}
                    : () {
                        setState(() {
                          checkvalue[index] = !checkvalue[index];
                        });
                      },
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0), border: Border.all(width: 2, color: Color(0xff707070))),
                  padding: EdgeInsets.all(2),
                  child: checkvalue[index]
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: Color(0xff707070)),
                        )
                      : SizedBox(),
                ),
              ),
              4.horizontalSpace,
              Text(
                accomidationModel.message![index].cityName!,
                style: fontStyle(
                    fontSize: 17.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    fontFamily: FontFamily.medium),
              ),
            ],
          ),
          Text(
            "${accomidationModel.message![index].numberNights} Nights",
            style: fontStyle(
                fontSize: 17.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.2,
                fontFamily: FontFamily.medium),
          ),
          Text(
            "${accomidationModel.message![index].accommodationType}",
            style: fontStyle(
                fontSize: 17.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.2,
                fontFamily: FontFamily.medium),
          ),
          Text(
            "${accomidationModel.message![index].accessDate}",
            style: fontStyle(
                fontSize: 17.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.2,
                fontFamily: FontFamily.medium),
          ),
          InkWell(
            onTap: () {
              setState(() {
                tapped == index ? tapped = -1 : tapped = index;
              });
            },
            child: Icon(
              tapped == index ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
              size: 35,
              color: AppColors.umragold,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNextAndPreviousButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 35,
              width: 70,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Color(0xffecb959), borderRadius: BorderRadius.circular(41)),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  LanguageClass.isEnglish ? "Previous" : 'السابق',
                  style: fontStyle(fontFamily: FontFamily.bold, fontSize: 18.sp, color: Colors.white),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              UmraDetails.accomidation = [];
              UmraDetails.accomidationRoom = [];

              print(checkvalue.toString());
              for (int i = 0; i < checkvalue.length; i++) {
                if (UmraDetails.reservedseats.isNotEmpty) {
                  if (accomidationModel.object!.isLinkWithTransportation == true &&
                      customernumber[i].customernumbers.fold(0, (previousValue, element) => previousValue + element) !=
                          UmraDetails.reservedseats.first.seatsnumber.length) {
                    Constants.showDefaultSnackBar(
                        context: context,
                        text: LanguageClass.isEnglish
                            ? 'select number of persons in the room same as person numbers in transportation'
                            : 'حدد عدد الأشخاص في الغرفة بنفس عدد الأشخاص في وسائل النقل');
                  } else {
                    if (checkvalue[i] == true) {
                      if (customernumber[i]
                              .customernumbers
                              .fold(0, (previousValue, element) => previousValue + element) !=
                          0) {
                        UmraDetails.accomidation!.add(accomidationModel.message![i]);

                        UmraDetails.accomidationRoom.add(customernumber[i]);
                      }
                    }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProgramsScreen(
                              typeid: widget.typeid,
                              umrahReservationID: widget.umrahReservationID,
                              selectedpackage: selectedpackage),
                        ));
                  }
                } else {
                  if (checkvalue[i] == true) {
                    if (customernumber[i]
                            .customernumbers
                            .fold(0, (previousValue, element) => previousValue + element) !=
                        0) {
                      UmraDetails.accomidation!.add(accomidationModel.message![i]);

                      UmraDetails.accomidationRoom.add(customernumber[i]);
                    }
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProgramsScreen(
                            typeid: widget.typeid,
                            umrahReservationID: widget.umrahReservationID,
                            selectedpackage: selectedpackage),
                      ));
                }
              }
            },
            child: Container(
              height: 35,
              width: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Color(0xffecb959), borderRadius: BorderRadius.circular(41)),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  LanguageClass.isEnglish ? "Next" : 'التالي',
                  style: fontStyle(fontFamily: FontFamily.bold, fontSize: 18.sp, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: LanguageClass.isEnglish ? 55 : 0, right: LanguageClass.isEnglish ? 0 : 55),
            alignment: LanguageClass.isEnglish ? Alignment.topLeft : Alignment.topRight,
            child: Text(
              LanguageClass.isEnglish ? 'Packages' : 'الحملات',
              style: fontStyle(
                  fontSize: 24.sp, color: Colors.black, fontFamily: FontFamily.bold, fontWeight: FontWeight.w500),
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
                    children: listcampains!.map((campaign) {
                      final index = listcampains!.indexOf(campaign);
                      return Indexed(
                        index: index,
                        key: UniqueKey(),
                        child: InkWell(
                            onTap: () {},
                            child: AnimatedContainer(
                              padding: EdgeInsets.only(
                                  left: selectedpackage == index && index != 0 ? 30 : 5,
                                  right: index == listcampains!.length - 1 ? 15 : 5),
                              margin: EdgeInsets.only(left: index * 80),
                              decoration: BoxDecoration(
                                  boxShadow: selectedpackage == index
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
                                  color: HexColor(listcampains![index].bgColor ?? '#AEAEAE'),
                                  borderRadius: BorderRadius.circular(13)),
                              width: selectedpackage == index ? 148 : 100,
                              height: 47,
                              duration: Duration(microseconds: 100),
                              curve: Curves.linear,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        listcampains![index].name!,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            fontStyle(color: Colors.white, fontFamily: FontFamily.bold, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      );
                    }).toList()),
              ],
            )),
        10.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: Container(
                width: 27,
                height: 27,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2, color: AppColors.umragold),
                    borderRadius: BorderRadius.circular(100)),
                child: Container(
                  width: 15,
                  height: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.umragold,
                      border: Border.all(color: AppColors.umragold),
                      borderRadius: BorderRadius.circular(100)),
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
                    border: Border.all(width: 2, color: AppColors.umragold),
                    borderRadius: BorderRadius.circular(100)),
                child: Container(
                  width: 15,
                  height: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.umragold,
                      border: Border.all(color: AppColors.umragold),
                      borderRadius: BorderRadius.circular(100)),
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
                    border: Border.all(width: 2, color: AppColors.umragold),
                    borderRadius: BorderRadius.circular(100)),
                child: Container(
                  width: 15,
                  height: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.umragold,
                      border: Border.all(color: AppColors.umragold),
                      borderRadius: BorderRadius.circular(100)),
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
                  decoration: BoxDecoration(color: Color(0xffC6C6C6), borderRadius: BorderRadius.circular(100)),
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
                  decoration: BoxDecoration(color: Color(0xffC6C6C6), borderRadius: BorderRadius.circular(100)),
                ),
              ),
            ],
          ),
        ),
        6.verticalSpace,
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      LanguageClass.isEnglish ? 'Packages' : 'الحملات',
                      textAlign: TextAlign.center,
                      style: fontStyle(fontFamily: FontFamily.bold, fontSize: 9.sp, height: 1.2, color: Colors.black),
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
                    LanguageClass.isEnglish ? 'Transportation' : 'الانتقالات',
                    textAlign: TextAlign.center,
                    style: fontStyle(fontFamily: FontFamily.bold, fontSize: 9.sp, height: 1.2, color: Colors.black),
                  ),
                ),
              )),
              Expanded(
                  child: Container(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    LanguageClass.isEnglish ? 'Accommodation' : 'الإقامة',
                    textAlign: TextAlign.center,
                    style: fontStyle(fontFamily: FontFamily.bold, fontSize: 9.sp, height: 1.2, color: Colors.black),
                  ),
                ),
              )),
              Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        LanguageClass.isEnglish ? 'Program' : 'البرنامج',
                        textAlign: TextAlign.center,
                        style: fontStyle(fontFamily: FontFamily.bold, fontSize: 9.sp, height: 1.2, color: Colors.black),
                      ),
                    )),
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    LanguageClass.isEnglish ? 'Reservation' : "الحجز",
                    textAlign: TextAlign.center,
                    style: fontStyle(fontFamily: FontFamily.bold, fontSize: 9.sp, height: 1.2, color: Colors.black),
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  void _handleUmrahListenner(context, UmraState state) {
    if (state.campainlistmodel?.status == "success") {
      listcampains = state.campainlistmodel!.message!.list;
    } else if (state.accomidationModel?.status == "success") {
      accomidationModel = state.accomidationModel!;

      scrollController = List<ScrollController>.filled(state.accomidationModel!.message!.length, ScrollController());

      checkvalue = List<bool>.filled(state.accomidationModel!.message!.length, true);

      for (int i = 0; i < state.accomidationModel!.message!.length; i++) {
        if (widget.umrahReservationID != null) {
          if (state.accomidationModel!.message![i].isReserved == true) {
            checkvalue[i] = true;
            customernumber.add(AcoomidationRoom(
              room: state.accomidationModel!.message![i].roomTypeList!,
              customernumbers: List<int>.filled(state.accomidationModel!.message![i].roomTypeList!.length, 0),
            ));
            for (int j = 0; j < state.accomidationModel!.message![i].roomTypeList!.length; j++) {
              if (state.accomidationModel!.message![i].roomTypeList![j].isreserved == true) {
                customernumber[i].customernumbers[j] =
                    state.accomidationModel!.message![i].roomTypeList![j].personCountReserved!;
              }
            }
          } else {
            checkvalue[i] = false;
          }
        } else {
          customernumber.add(AcoomidationRoom(
            room: state.accomidationModel!.message![i].roomTypeList!,
            customernumbers: List<int>.filled(state.accomidationModel!.message![i].roomTypeList!.length, 0),
          ));
        }
      }
    }
  }
}
