import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as initl;
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/hex_color.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/Swa_umra/Screens/Bus_Backseat_screan.dart';
import 'package:swa/features/Swa_umra/Screens/Enter_trip_data.dart';
import 'package:swa/features/Swa_umra/Screens/Reservation_screan.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/campain_list_model.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';

class SleactbackseatScrean extends StatefulWidget {
  Campainlist tripdetails;

  int selectedpackage;
  SleactbackseatScrean(
      {super.key, required this.tripdetails, required this.selectedpackage});

  @override
  State<SleactbackseatScrean> createState() => _SleactbackseatScreanState();
}

class _SleactbackseatScreanState extends State<SleactbackseatScrean> {
  final UmraBloc _umraBloc = UmraBloc();

  List selectedseats = [];

  List seatsnum = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _umraBloc.add(GetSeatsEvent(
        tripId:
            widget.tripdetails.tripList![widget.selectedpackage].tripIdBack));
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
                            LanguageClass.isEnglish
                                ? 'Select return seats'
                                : 'حدد مقاعد العودة',
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontFamily: 'bold',
                                fontWeight: FontWeight.w500),
                          )),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 108,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppColors.umragold,
                              borderRadius: BorderRadius.circular(14),
                              image: widget.tripdetails.image == null
                                  ? DecorationImage(
                                      image: AssetImage(
                                        'assets/images/mask.png',
                                      ),
                                      fit: BoxFit.cover,
                                      opacity: 1,
                                      colorFilter: new ColorFilter.mode(
                                          AppColors.umragold,
                                          BlendMode.multiply),
                                      alignment: Alignment.center,
                                    )
                                  : DecorationImage(
                                      fit: BoxFit.cover,
                                      opacity: 1,
                                      colorFilter: ColorFilter.mode(
                                          HexColor(widget.tripdetails.bgColor!),
                                          BlendMode.multiply),
                                      alignment: Alignment.center,
                                      image: NetworkImage(
                                        widget.tripdetails.image!,
                                      ))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  widget
                                      .tripdetails
                                      .tripList![widget.selectedpackage]
                                      .campaignName!,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'bold',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${widget.tripdetails.tripList![widget.selectedpackage].nights} ${LanguageClass.isEnglish == true ? 'Nights' : 'ليالي'}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'bold',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                          initl.DateFormat("EEE, MMM d, yyyy")
                                              .format(widget
                                                  .tripdetails
                                                  .tripList![
                                                      widget.selectedpackage]
                                                  .tripDateBack!)
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'bold',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      widget
                                              .tripdetails
                                              .tripList![widget.selectedpackage]
                                              .withTransportaion!
                                          ? Text(
                                              LanguageClass.isEnglish
                                                  ? 'Transportation'
                                                  : 'مواصلات',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'bold',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white))
                                          : SizedBox(),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                          widget
                                              .tripdetails
                                              .tripList![widget.selectedpackage]
                                              .tripTimeBack!,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'bold',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (selectedseats.isEmpty) {
                                            Constants.showDefaultSnackBar(
                                                color: AppColors.umragold,
                                                context: context,
                                                text: LanguageClass.isEnglish
                                                    ? 'Please select seats'
                                                    : 'الرجاء تحديد المقاعد');
                                          } else {
                                            UmraDetails.bookedseatsback =
                                                seatsnum;
                                            UmraDetails.bookedseatsidback =
                                                selectedseats;

                                            UmraDetails.tripList =
                                                widget.tripdetails.tripList![
                                                    widget.selectedpackage];

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReservationUmraScrean()));
                                          }
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 80,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black54,
                                                    offset: Offset(0, 2),
                                                    blurRadius: 14,
                                                    spreadRadius: 0)
                                              ],
                                              color: AppColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(41)),
                                          child: Text(
                                              LanguageClass.isEnglish
                                                  ? 'Book'
                                                  : 'احجز',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'bold',
                                                fontWeight: FontWeight.w500,
                                                color: HexColor(widget
                                                        .tripdetails
                                                        .bgColor!) ??
                                                    AppColors.umragold,
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                          LanguageClass.isEnglish
                                              ? 'Availability ${widget.tripdetails.tripList![widget.selectedpackage].availability}'
                                              : 'المتاح ${widget.tripdetails.tripList![widget.selectedpackage].availability}',
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'bold',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Expanded(
                          child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 45.w),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.16,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: SvgPicture.asset(
                                      'assets/images/frontbus.svg',
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.16,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25),
                                    child: SvgPicture.asset(
                                      'assets/images/backbus.svg',
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height * 0.115,
                                bottom: 5,
                                left: 10,
                                right: 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 33),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      for (int index = 0;
                                          index <
                                              state.seatsmodel!.message!
                                                  .busDetailsVm!.totalRow!;
                                          index++)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            for (int i = 0;
                                                i <
                                                    state
                                                        .seatsmodel!
                                                        .message!
                                                        .busDetailsVm!
                                                        .totalColumn!;
                                                i++)
                                              Expanded(
                                                child: state
                                                            .seatsmodel!
                                                            .message!
                                                            .busDetailsVm!
                                                            .rowList![index]
                                                            .seats[i]
                                                            .isAvailable ==
                                                        true
                                                    ? InkWell(
                                                        onTap: () {
                                                          if (state
                                                                      .seatsmodel!
                                                                      .message!
                                                                      .busDetailsVm!
                                                                      .rowList![
                                                                          index]
                                                                      .seats[i]
                                                                      .isReserved ==
                                                                  false &&
                                                              state
                                                                      .seatsmodel!
                                                                      .message!
                                                                      .busDetailsVm!
                                                                      .rowList![
                                                                          index]
                                                                      .seats[i]
                                                                      .isAvailable ==
                                                                  true) {
                                                            print(state
                                                                .seatsmodel!
                                                                .message!
                                                                .busDetailsVm!
                                                                .rowList![index]
                                                                .seats[i]
                                                                .seatBusID
                                                                .toString());
                                                            if (selectedseats
                                                                .contains(state
                                                                    .seatsmodel!
                                                                    .message!
                                                                    .busDetailsVm!
                                                                    .rowList![
                                                                        index]
                                                                    .seats[i]
                                                                    .seatBusID)) {
                                                              seatsnum.remove(state
                                                                  .seatsmodel!
                                                                  .message!
                                                                  .busDetailsVm!
                                                                  .rowList![
                                                                      index]
                                                                  .seats[i]
                                                                  .seatNo);
                                                              selectedseats.remove(state
                                                                  .seatsmodel!
                                                                  .message!
                                                                  .busDetailsVm!
                                                                  .rowList![
                                                                      index]
                                                                  .seats[i]
                                                                  .seatBusID);

                                                              _umraBloc.add(RemoveHoldSeatEvent(
                                                                  seatsId: [
                                                                    state
                                                                        .seatsmodel!
                                                                        .message!
                                                                        .busDetailsVm!
                                                                        .rowList![
                                                                            index]
                                                                        .seats[
                                                                            i]
                                                                        .seatBusID!
                                                                        .toInt()
                                                                  ],
                                                                  tripId: widget
                                                                      .tripdetails
                                                                      .tripList![
                                                                          widget
                                                                              .selectedpackage]
                                                                      .tripIdBack));
                                                            } else {
                                                              _umraBloc.add(HoldseatEvent(
                                                                  seatId: state
                                                                      .seatsmodel!
                                                                      .message!
                                                                      .busDetailsVm!
                                                                      .rowList![
                                                                          index]
                                                                      .seats[i]
                                                                      .seatBusID!
                                                                      .toInt(),
                                                                  tripId: widget
                                                                      .tripdetails
                                                                      .tripList![
                                                                          widget
                                                                              .selectedpackage]
                                                                      .tripIdBack));

                                                              selectedseats.add(state
                                                                  .seatsmodel!
                                                                  .message!
                                                                  .busDetailsVm!
                                                                  .rowList![
                                                                      index]
                                                                  .seats[i]
                                                                  .seatBusID);

                                                              seatsnum.add(state
                                                                  .seatsmodel!
                                                                  .message!
                                                                  .busDetailsVm!
                                                                  .rowList![
                                                                      index]
                                                                  .seats[i]
                                                                  .seatNo);
                                                            }

                                                            setState(() {});
                                                          }
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width:
                                                              double.infinity,
                                                          height: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.49) /
                                                              state
                                                                  .seatsmodel!
                                                                  .message!
                                                                  .busDetailsVm!
                                                                  .totalRow!,
                                                          margin:
                                                              EdgeInsets.all(1),
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/images/busseat.svg',
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                fit:
                                                                    BoxFit.fill,
                                                                color: selectedseats.contains(state
                                                                        .seatsmodel!
                                                                        .message!
                                                                        .busDetailsVm!
                                                                        .rowList![
                                                                            index]
                                                                        .seats[
                                                                            i]
                                                                        .seatBusID)
                                                                    ? Color(
                                                                        0xffB55BCB)
                                                                    : state.seatsmodel!.message!.busDetailsVm!.rowList![index].seats[i].isAvailable! &&
                                                                            !state.seatsmodel!.message!.busDetailsVm!.rowList![index].seats[i].isReserved!
                                                                        ? AppColors.umragold
                                                                        : null,
                                                              ),
                                                              FittedBox(
                                                                fit: BoxFit
                                                                    .contain,
                                                                child: Text(
                                                                  state
                                                                      .seatsmodel!
                                                                      .message!
                                                                      .busDetailsVm!
                                                                      .rowList![
                                                                          index]
                                                                      .seats[i]
                                                                      .seatNo
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: state
                                                                              .seatsmodel!
                                                                              .message!
                                                                              .busDetailsVm!
                                                                              .rowList![
                                                                                  index]
                                                                              .seats[
                                                                                  i]
                                                                              .isAvailable!
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black,
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          'bold',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
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
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: AppColors.umragold,
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(
                                '${LanguageClass.isEnglish ? "available" : 'متاح'} : ${state.seatsmodel!.message!.emptySeats.toString()}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'meduim',
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                            Flexible(
                                child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xffB55BCB),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(
                                '${LanguageClass.isEnglish ? "selected" : 'مختار'} : ${selectedseats.length}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'meduim',
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                            Flexible(
                                child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(
                                '${LanguageClass.isEnglish ? "unavailable" : 'غير متاح'} : ${state.seatsmodel!.message!.totalSeats! - state.seatsmodel!.message!.emptySeats!}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff313131),
                                    fontFamily: 'meduim',
                                    fontWeight: FontWeight.w600),
                              ),
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ));
          }),
    );
  }
}
