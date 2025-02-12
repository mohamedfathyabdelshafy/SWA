import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:intl/intl.dart' as init;
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/bus_reservation_layout/data/models/BusSeatsModel.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/Container_Widget.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_model.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_widget.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/text_widget.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Response_ticket_history_Model.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/repo/ticket_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_state.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/screen/edit_BusLayout.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/screen/ticket_pdf.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/main.dart';

class TicketHistory extends StatefulWidget {
  TicketHistory({super.key, required this.user});
  User? user;
  @override
  State<TicketHistory> createState() => _TicketHistoryState();
}

class _TicketHistoryState extends State<TicketHistory> {
  TicketRepo ticketRepo = TicketRepo(sl());
  String? from, to;
  bool dawnload = false;
  int reservationid = 0;

  BusSeatsModel? busSeatsModel;

  @override
  void initState() {
    get();
    super.initState();

    //   Future.delayed(const Duration(seconds: 0)).then((_) async {
    //     BlocProvider.of<TicketCubit>(context).getTicketHistory(3);
    //   });
  }

  get() async {
    BlocProvider.of<TicketCubit>(context)
        .getTicketHistory(customerId: widget.user?.customerId ?? 0);
  }

  cancelticket(int id) async {
    BlocProvider.of<TicketCubit>(context).cancelticket(id: id);
  }

  TicketCubit _ticketCubit = TicketCubit();
  BusLayoutRepo busLayoutRepo = BusLayoutRepo(apiConsumer: (sl()));

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener(
        bloc: BlocProvider.of<TicketCubit>(context),
        listener: (context, state) {
          print(state);

          if (state is Cancelticketstate) {
            Constants.showDefaultSnackBar(
                context: context, color: Colors.green, text: state.message);

            get();
          }

          if (state is Loadededitpolicy) {
            showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Material(
                      color: Colors.transparent,
                      child: Container(
                        color: Colors.white,
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(30),
                        width: MediaQuery.of(context).size.width - 50,
                        child: SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Icon(
                                    Icons.close,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                LanguageClass.isEnglish
                                    ? 'Terms for edit or cancel '
                                    : "شروط التعديل أو الإلغاء",
                                textDirection: LanguageClass.isEnglish
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                                style: fontStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: state.message.length,
                                  itemBuilder: (context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Text(
                                        "${index + 1}- ${state.message[index]}",
                                        textAlign: LanguageClass.isEnglish
                                            ? TextAlign.left
                                            : TextAlign.right,
                                        textDirection: LanguageClass.isEnglish
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                        style: fontStyle(
                                            color: Color(0xff818181),
                                            fontSize: 14,
                                            fontFamily: FontFamily.regular),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      LanguageClass.isEnglish
                                                          ? 'Are you sure you want cancel the ticket?'
                                                          : "هل أنت متأكد أنك تريد إلغاء التذكرة؟",
                                                      textDirection:
                                                          LanguageClass.isEnglish
                                                              ? TextDirection
                                                                  .ltr
                                                              : TextDirection
                                                                  .rtl,
                                                      style: fontStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    content: Row(
                                                      children: [
                                                        Expanded(
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      cancelticket(
                                                                          reservationid);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                12)),
                                                                        backgroundColor:
                                                                            AppColors
                                                                                .primaryColor),
                                                                    child: Text(
                                                                        LanguageClass.isEnglish
                                                                            ? 'Yes'
                                                                            : 'نعم',
                                                                        style: fontStyle(
                                                                            color:
                                                                                AppColors.white,
                                                                            fontFamily: FontFamily.medium,
                                                                            fontSize: 14.sp)))),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                12)),
                                                                        backgroundColor:
                                                                            AppColors.blue),
                                                                    child: Text(
                                                                      LanguageClass
                                                                              .isEnglish
                                                                          ? 'No'
                                                                          : 'لا',
                                                                      style: fontStyle(
                                                                          color: AppColors
                                                                              .white,
                                                                          fontFamily: FontFamily
                                                                              .medium,
                                                                          fontSize:
                                                                              14.sp),
                                                                    )))
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              backgroundColor:
                                                  AppColors.primaryColor),
                                          child: Text(
                                            LanguageClass.isEnglish
                                                ? 'Cancel ticket'
                                                : 'إلغاء التذكرة',
                                            style: fontStyle(
                                                color: AppColors.white,
                                                fontFamily: FontFamily.medium,
                                                fontSize: 14.sp),
                                          ))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MultiBlocProvider(
                                                            providers: [
                                                              BlocProvider<
                                                                  BusLayoutCubit>(
                                                                create: (context) =>
                                                                    BusLayoutCubit(),
                                                              )
                                                            ],
                                                            // Replace with your actual cubit creation logic
                                                            child:
                                                                BusLayoutEditScreen(
                                                              user: widget.user,
                                                              from: from!,
                                                              reservationID:
                                                                  reservationid,
                                                              to: to!,
                                                            )))).then(
                                                (value) async {
                                              Navigator.pop(context);
                                              get();
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              backgroundColor: AppColors.blue),
                                          child: Text(
                                            LanguageClass.isEnglish
                                                ? 'Edit ticket'
                                                : 'تعديل التذكرة',
                                            style: fontStyle(
                                                color: AppColors.white,
                                                fontFamily: FontFamily.medium,
                                                fontSize: 14.sp),
                                          )))
                                ],
                              )
                            ],
                          ),
                        ),
                      ));
                });
          }
          if (state is LoadedTicketdetails && !dawnload) {
            showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Material(
                      color: Colors.transparent,
                      child: Container(
                        color: Colors.white,
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(30),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width - 50,
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: ListView(
                            children: [
                              Text(
                                LanguageClass.isEnglish
                                    ? 'Terms and conditions '
                                    : "الشروط والأحكام",
                                textDirection: LanguageClass.isEnglish
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                                style: fontStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: state.ticketdetailsModel.message!
                                      .policy!.length,
                                  itemBuilder: (context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Text(
                                        "${index + 1}- ${state.ticketdetailsModel.message!.policy![index]}",
                                        textDirection: LanguageClass.isEnglish
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                        style: fontStyle(
                                            color: Color(0xff818181),
                                            fontSize: 14,
                                            fontFamily: FontFamily.regular),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.primaryColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        LanguageClass.isEnglish ? "Done" : 'تم',
                                        style: fontStyle(
                                            fontFamily: FontFamily.bold,
                                            fontSize: 14.sp,
                                            color: Colors.white),
                                      ),
                                    )),
                              )
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 40),
                              //   child: ElevatedButton(
                              //
                              //       onPressed: () {
                              //         Navigator.pop(context);
                              //       },
                              //       child: Text(LanguageClass.isEnglish
                              //           ? "Done"
                              //           : 'تم',
                              //       style: fontStyle(color: Colors.black),)),
                              // )
                            ],
                          ),
                        ),
                      ));
                });
          } else if (state is LoadedTicketdetails && dawnload) {
            print(state.ticketdetailsModel.message!.policy!.length);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return PdfPreviewPage(state.ticketdetailsModel.message,
                  state.ticketdetailsModel.message!.policy!.length);
            }));
            dawnload = false;
          }
        },
        child: BlocBuilder<TicketCubit, TicketStates>(
          builder: (context, state) {
            if (state is LoadingTicketHistory) {
              return Center(
                child: CircularProgressIndicator(
                  color: Routes.isomra
                      ? AppColors.umragold
                      : AppColors.primaryColor,
                ),
              );
            } else if (state is ErrorTicketHistory) {
              return Directionality(
                textDirection: LanguageClass.isEnglish
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      alignment: LanguageClass.isEnglish
                          ? Alignment.topLeft
                          : Alignment.topRight,
                      child: Text(
                        LanguageClass.isEnglish ? "Ticket" : "تذاكارك",
                        textAlign: LanguageClass.isEnglish
                            ? TextAlign.left
                            : TextAlign.right,
                        style: fontStyle(
                            color: AppColors.blackColor,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFamily: FontFamily.medium),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          LanguageClass.isEnglish
                              ? "You have no ticket available"
                              : "لا يوجد تزاكر",
                          style: fontStyle(
                              color: Color(0xffA3A3A3),
                              fontSize: 21,
                              fontFamily: FontFamily.regular),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is LoadedTicketHistory) {
              return SizedBox(
                height: sizeHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: sizeHeight * 0.1,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.topLeft,
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
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        LanguageClass.isEnglish ? "Ticket" : "تذاكارك",
                        style: fontStyle(
                            color: AppColors.blackColor,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFamily: FontFamily.medium),
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            itemCount: state.responseTicketHistoryModel.message
                                    ?.length ??
                                0,
                            itemBuilder: (context, index) {
                              print(
                                  "responseTicketHistoryModel?.message?.length${state.responseTicketHistoryModel.message?.length}");
                              final ticket = state
                                  .responseTicketHistoryModel.message![index];
                              return Container(
                                height: 230,
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: state.responseTicketHistoryModel
                                                    .message![index].isPaid ==
                                                false ||
                                            state.responseTicketHistoryModel
                                                    .message![index].status ==
                                                61
                                        ? AppColors.darkGrey
                                        : Color(0xffFF5D4B)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    state.responseTicketHistoryModel
                                                .message![index].isPaid ==
                                            false
                                        ? DateTime.now()
                                                    .difference(state
                                                        .responseTicketHistoryModel
                                                        .message![index]
                                                        .reservationDate!)
                                                    .inMinutes >
                                                60
                                            ? Text(
                                                '${LanguageClass.isEnglish ? 'Expired' : 'منتهي الصلاحية'}',
                                                style: fontStyle(
                                                    fontFamily: FontFamily.bold,
                                                    fontSize: 13,
                                                    color: Color(0xfff7f8f9)),
                                              )
                                            : Container(
                                                alignment: Alignment.center,
                                                child: TimerCountdown(
                                                  format: CountDownTimerFormat
                                                      .minutesSeconds,
                                                  endTime: DateTime.now().add(
                                                    Duration(
                                                      minutes: (59 -
                                                          DateTime.now()
                                                              .difference(state
                                                                  .responseTicketHistoryModel
                                                                  .message![
                                                                      index]
                                                                  .reservationDate!)
                                                              .inMinutes),
                                                      seconds: 59,
                                                    ),
                                                  ),
                                                  onEnd: () {
                                                    print("Timer finished");
                                                  },
                                                  descriptionTextStyle:
                                                      fontStyle(
                                                          color:
                                                              AppColors.yellow2,
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontSize: 12),
                                                  minutesDescription:
                                                      '${LanguageClass.isEnglish ? 'remaining' : 'للدفع'}',
                                                  secondsDescription:
                                                      '${LanguageClass.isEnglish ? 'to pay' : 'متبقي'}',
                                                  spacerWidth: 0,
                                                  colonsTextStyle: fontStyle(
                                                      color: Colors.white),
                                                  timeTextStyle: fontStyle(
                                                      color: AppColors.yellow2,
                                                      fontSize: 13,
                                                      fontFamily:
                                                          FontFamily.medium),
                                                ),
                                              )
                                        : SizedBox(),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 17,
                                                  ),
                                                  Expanded(
                                                      child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            '${state.responseTicketHistoryModel.message![index].tripDate!.day.toString()}/${state.responseTicketHistoryModel.message![index].tripDate!.month.toString()}/${state.responseTicketHistoryModel.message![index].tripDate!.year.toString()}',
                                                            style: fontStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .medium,
                                                                fontSize: 13),
                                                          ),
                                                          Text(
                                                            init.DateFormat(
                                                                    'hh:mm a')
                                                                .format(state
                                                                    .responseTicketHistoryModel
                                                                    .message![
                                                                        index]
                                                                    .tripDate!)
                                                                .toString(),
                                                            style: fontStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .medium,
                                                                fontSize: 13),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        width: 5,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    2),
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .topCenter,
                                                                end: Alignment
                                                                    .bottomCenter,
                                                                colors: [
                                                                  AppColors
                                                                      .white,
                                                                  AppColors
                                                                      .yellow2
                                                                ])),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Column(
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
                                                                  ? "From"
                                                                  : "من",
                                                              style: fontStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
                                                                  fontSize: 12),
                                                            ),
                                                            Text(
                                                              state
                                                                  .responseTicketHistoryModel
                                                                  .message![
                                                                      index]
                                                                  .from!,
                                                              style: fontStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
                                                                  fontSize: 12),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              LanguageClass
                                                                      .isEnglish
                                                                  ? "To"
                                                                  : "الي",
                                                              style: fontStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
                                                                  fontSize: 12),
                                                            ),
                                                            Text(
                                                              state
                                                                  .responseTicketHistoryModel
                                                                  .message![
                                                                      index]
                                                                  .to!,
                                                              style: fontStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                                  Text(
                                                    "${Routes.curruncy} ${state.responseTicketHistoryModel.message![index].price}",
                                                    style: fontStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              )),
                                          Expanded(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 14,
                                                    height: 14,
                                                    alignment: Alignment.center,
                                                    child: Image.asset(
                                                        "assets/images/Icon fa-solid-bus.png"),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    state
                                                        .responseTicketHistoryModel
                                                        .message![index]
                                                        .tripNumber
                                                        .toString(),
                                                    style: fontStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  busLayoutRepo
                                                      .getBusSeatsData(
                                                          tripId: state
                                                              .responseTicketHistoryModel
                                                              .message![index]
                                                              .tripId!)
                                                      .then((value) async {
                                                    busSeatsModel = await value;

                                                    if (busSeatsModel != null) {
                                                      for (int i = 0;
                                                          i <
                                                              busSeatsModel!
                                                                  .busSeatDetails!
                                                                  .busDetails!
                                                                  .totalRow!;
                                                          i++) {
                                                        for (int j = 0;
                                                            j <
                                                                busSeatsModel!
                                                                    .busSeatDetails!
                                                                    .busDetails!
                                                                    .rowList![i]
                                                                    .seats
                                                                    .length;
                                                            j++) {
                                                          if (busSeatsModel
                                                                      ?.busSeatDetails
                                                                      ?.busDetails
                                                                      ?.rowList?[
                                                                          i]
                                                                      .seats[j]
                                                                      .isReserved ==
                                                                  true ||
                                                              busSeatsModel
                                                                      ?.busSeatDetails
                                                                      ?.busDetails
                                                                      ?.rowList?[
                                                                          i]
                                                                      .seats[j]
                                                                      .isAvailable ==
                                                                  true) {
                                                            busSeatsModel
                                                                    ?.busSeatDetails
                                                                    ?.busDetails
                                                                    ?.rowList?[i]
                                                                    .seats[j]
                                                                    .seatState =
                                                                SeatState.sold;
                                                          }

                                                          for (var n = 0;
                                                              n <
                                                                  state
                                                                      .responseTicketHistoryModel
                                                                      .message![
                                                                          index]
                                                                      .seatNoList!
                                                                      .length;
                                                              n++) {
                                                            if (busSeatsModel
                                                                    ?.busSeatDetails
                                                                    ?.busDetails
                                                                    ?.rowList?[
                                                                        i]
                                                                    .seats[j]
                                                                    .seatNo ==
                                                                state
                                                                    .responseTicketHistoryModel
                                                                    .message![
                                                                        index]
                                                                    .seatNoList![n]) {
                                                              busSeatsModel
                                                                      ?.busSeatDetails
                                                                      ?.busDetails
                                                                      ?.rowList?[i]
                                                                      .seats[j]
                                                                      .seatState =
                                                                  SeatState
                                                                      .booked;
                                                            }
                                                          }
                                                        }
                                                      }

                                                      setState(() {});
                                                    }

                                                    showGeneralDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        barrierLabel:
                                                            MaterialLocalizations
                                                                    .of(context)
                                                                .modalBarrierDismissLabel,
                                                        barrierColor: Colors
                                                            .black
                                                            .withOpacity(0.5),
                                                        transitionDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                        pageBuilder: (context,
                                                            Animation<double>
                                                                animation,
                                                            Animation<double>
                                                                secondaryAnimation) {
                                                          return Material(
                                                              child: SafeArea(
                                                                  child: Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: AppColors
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      child:
                                                                          SeatLayoutWidget(
                                                                        seatHeight:
                                                                            sizeHeight *
                                                                                .036,
                                                                        onSeatStateChanged: (rowI,
                                                                            colI,
                                                                            seatState,
                                                                            seat) {},
                                                                        stateModel:
                                                                            SeatLayoutStateModel(
                                                                          rows: busSeatsModel?.busSeatDetails?.busDetails?.rowList?.length ??
                                                                              0,
                                                                          cols: busSeatsModel?.busSeatDetails?.busDetails?.totalColumn ??
                                                                              5,
                                                                          seatSvgSize: 30
                                                                              .sp
                                                                              .toInt(),
                                                                          pathSelectedSeat:
                                                                              'assets/images/unavailable_seats.svg',
                                                                          pathDisabledSeat:
                                                                              'assets/images/unavailable_seats.svg',
                                                                          pathSoldSeat:
                                                                              'assets/images/disabled_seats.svg',
                                                                          pathUnSelectedSeat:
                                                                              'assets/images/unavailable_seats.svg',
                                                                          currentSeats:
                                                                              List.generate(
                                                                            busSeatsModel?.busSeatDetails?.busDetails?.rowList?.length ??
                                                                                0,

                                                                            // Number of rows based on totalSeats
                                                                            (row) =>
                                                                                busSeatsModel!.busSeatDetails!.busDetails!.rowList![row].seats,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ])));
                                                        });
                                                  });
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Container(
                                                        width: 14,
                                                        height: 14,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Image.asset(
                                                            "assets/images/chairs.png"),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                        width: 70,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Wrap(
                                                          direction:
                                                              Axis.horizontal,
                                                          children: [
                                                            Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        0.0),
                                                                child:
                                                                    Container(
                                                                  child: Text(
                                                                    '${state.responseTicketHistoryModel.message![index].seatNoList!.length} ${LanguageClass.isEnglish ? ' Seats' : ' كرسي'}',
                                                                    style: fontStyle(
                                                                        color: AppColors
                                                                            .white,
                                                                        fontFamily:
                                                                            FontFamily
                                                                                .bold,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        state
                                                            .responseTicketHistoryModel
                                                            .message![index]
                                                            .statusName!,
                                                        style: fontStyle(
                                                            fontFamily:
                                                                FontFamily.bold,
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xfff7f8f9)),
                                                      ),
                                                      state
                                                                  .responseTicketHistoryModel
                                                                  .message![
                                                                      index]
                                                                  .isPaid ==
                                                              true
                                                          ? SizedBox()
                                                          : Text(
                                                              '${LanguageClass.isEnglish ? 'Not paid' : 'لم يتم الدفع'}',
                                                              style: fontStyle(
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
                                                                  fontSize: 12,
                                                                  color: AppColors
                                                                      .yellow2),
                                                            ),
                                                    ]),
                                              ),
                                              state
                                                          .responseTicketHistoryModel
                                                          .message![index]
                                                          .CanEditOrCancel ==
                                                      true
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: InkWell(
                                                        onTap: () {
                                                          reservationid = state
                                                              .responseTicketHistoryModel
                                                              .message![index]
                                                              .reservationId!;

                                                          from = state
                                                              .responseTicketHistoryModel
                                                              .message![index]
                                                              .from!;
                                                          to = state
                                                              .responseTicketHistoryModel
                                                              .message![index]
                                                              .to!;
                                                          BlocProvider.of<
                                                                      TicketCubit>(
                                                                  context)
                                                              .geteditpolicy();
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 5),
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
                                                                        15)
                                                              ],
                                                              color: AppColors
                                                                  .white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12)),
                                                          child: Text(
                                                            LanguageClass
                                                                    .isEnglish
                                                                ? 'Edit / Cancel'
                                                                : 'تعديل / إلغاء',
                                                            style: fontStyle(
                                                              color: AppColors
                                                                  .primaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Text(
                                                      state
                                                          .responseTicketHistoryModel
                                                          .message![index]
                                                          .servecietype!,
                                                      style: fontStyle(
                                                          fontFamily:
                                                              FontFamily.bold,
                                                          fontSize: 15,
                                                          color: Color(
                                                              0xfff7f8f9)),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                    state.responseTicketHistoryModel
                                                    .message![index].isPaid ==
                                                false ||
                                            state.responseTicketHistoryModel
                                                    .message![index].status ==
                                                61
                                        ? SizedBox()
                                        : Container(
                                            height: 30,
                                            margin: EdgeInsets.all(5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      BlocProvider.of<
                                                                  TicketCubit>(
                                                              context)
                                                          .getTicketdetails(
                                                              tekitid: ticket!
                                                                      .reservationId! ??
                                                                  0);
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color:
                                                              AppColors.white),
                                                      child: Text(
                                                        LanguageClass.isEnglish
                                                            ? "Policy"
                                                            : "الخصوصية",
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: fontStyle(
                                                            color: AppColors
                                                                .primaryColor,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                FontFamily
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      dawnload = true;

                                                      BlocProvider.of<
                                                                  TicketCubit>(
                                                              context)
                                                          .getTicketdetails(
                                                              tekitid: ticket!
                                                                      .reservationId! ??
                                                                  0);
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color: AppColors
                                                              .darkPurple),
                                                      child: Text(
                                                        LanguageClass.isEnglish
                                                            ? "Download"
                                                            : "تنزيل",
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: fontStyle(
                                                            color:
                                                                AppColors.white,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                FontFamily
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                              );
                            })),
                    // Expanded(
                    //   child: ListView.builder(
                    //       shrinkWrap: true,
                    //       physics: ScrollPhysics(),
                    //       padding: EdgeInsets.only(bottom: 0),
                    //       itemCount: state
                    //               .responseTicketHistoryModel.message?.length ??
                    //           0,
                    //       itemBuilder: (context, index) {
                    //         print(
                    //             "responseTicketHistoryModel?.message?.length${state.responseTicketHistoryModel.message?.length}");
                    //         final ticket = state
                    //             .responseTicketHistoryModel.message![index];
                    //         return SizedBox(
                    //           height: sizeHeight * 0.8,
                    //           child: Column(
                    //             children: [
                    //               Expanded(
                    //                 child: Column(
                    //                   children: [
                    //                     Padding(
                    //                       padding: const EdgeInsets.symmetric(
                    //                           horizontal: 50),
                    //                       child: Container(
                    //                         height: sizeHeight * 0.63,
                    //                         width: sizeWidth * 0.8,
                    //                         decoration: BoxDecoration(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(20),
                    //                             border: Border.all(
                    //                                 color: Colors.white)),
                    //                         child: Padding(
                    //                           padding:
                    //                               const EdgeInsets.symmetric(
                    //                                   vertical: 15),
                    //                           child: ListView(
                    //                             shrinkWrap: true,
                    //                             physics: const ScrollPhysics(),
                    //                             children: [
                    //                               const Padding(
                    //                                 padding:
                    //                                     EdgeInsets.symmetric(
                    //                                         horizontal: 15),
                    //                                 child: Text(
                    //                                   "Departure on",
                    //                                   style: fontStyle(
                    //                                       color: Colors.white,
                    //                                       fontFamily:FontFamily.regular,
                    //                                       fontSize: 12),
                    //                                 ),
                    //                               ),
                    //                               Padding(
                    //                                 padding: const EdgeInsets
                    //                                     .symmetric(
                    //                                     horizontal: 15,
                    //                                     vertical: 5),
                    //                                 child: Row(
                    //                                   children: [
                    //                                     Text(
                    //                                       "#${ticket?.tripNumber?.toString()}" ??
                    //                                           "",
                    //                                       style: fontStyle(
                    //                                           fontFamily:
                    //                                               "regular",
                    //                                           fontSize: 15,
                    //                                           color:
                    //                                               Colors.white),
                    //                                     ),
                    //                                     SizedBox(
                    //                                       width:
                    //                                           sizeWidth * 0.05,
                    //                                     ),
                    //                                     Container(
                    //                                       padding:
                    //                                           const EdgeInsets
                    //                                               .symmetric(
                    //                                               horizontal:
                    //                                                   10),
                    //                                       width:
                    //                                           sizeWidth * 0.45,
                    //                                       decoration: BoxDecoration(
                    //                                           borderRadius:
                    //                                               BorderRadius
                    //                                                   .circular(
                    //                                                       15),
                    //                                           color: AppColors
                    //                                               .primaryColor),
                    //                                       child: Text(
                    //                                         ticket?.servecietype ??
                    //                                             " ",
                    //                                         style: fontStyle(
                    //                                           color:
                    //                                               Colors.white,
                    //                                           fontSize: 18,
                    //                                           fontFamily:
                    //                                               "regular",
                    //                                         ),
                    //                                       ),
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               ),
                    //                               Padding(
                    //                                 padding: const EdgeInsets
                    //                                     .symmetric(
                    //                                     horizontal: 25,
                    //                                     vertical: 5),
                    //                                 child: Row(
                    //                                   children: [
                    //                                     SvgPicture.asset(
                    //                                         "assets/images/Icon awesome-bus-alt.svg"),
                    //                                     SizedBox(
                    //                                       width:
                    //                                           sizeWidth * 0.02,
                    //                                     ),
                    //                                     Text(
                    //                                       ticket?.tripDate !=
                    //                                               null
                    //                                           ? init.DateFormat(
                    //                                                   "yyyy-MMM-dd")
                    //                                               .format(ticket!
                    //                                                   .tripDate!)
                    //                                           : "",
                    //                                       style: fontStyle(
                    //                                           fontFamily:
                    //                                               "regular",
                    //                                           fontSize: 15,
                    //                                           color:
                    //                                               Colors.white),
                    //                                     ),
                    //                                     SizedBox(
                    //                                       width:
                    //                                           sizeWidth * 0.02,
                    //                                     ),
                    //                                     Text(
                    //                                       ticket?.accessBusTime
                    //                                               .toString() ??
                    //                                           "",
                    //                                       style: fontStyle(
                    //                                           fontFamily:
                    //                                               "regular",
                    //                                           fontSize: 15,
                    //                                           color:
                    //                                               Colors.white),
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               ),
                    //                               SizedBox(
                    //                                 width: sizeWidth * 0.9,
                    //                                 child: const Divider(
                    //                                   thickness: 1,
                    //                                   color: Colors.white,
                    //                                 ),
                    //                                 //  child:const  Text(
                    //                                 //   "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ",
                    //                                 //   style: fontStyle(
                    //                                 //     color: Colors.white,
                    //                                 //     fontSize: 20,
                    //                                 //     fontFamily:FontFamily.regular
                    //                                 //   ),
                    //                                 // ),
                    //                               ),
                    //                               Padding(
                    //                                 padding: const EdgeInsets
                    //                                     .symmetric(
                    //                                     horizontal: 15),
                    //                                 child: Row(
                    //                                   children: [
                    //                                     Container(
                    //                                       height: sizeHeight *
                    //                                           0.018,
                    //                                       width: sizeHeight *
                    //                                           0.018,
                    //                                       decoration: BoxDecoration(
                    //                                           shape: BoxShape
                    //                                               .circle,
                    //                                           color: Colors
                    //                                               .transparent,
                    //                                           border: Border.all(
                    //                                               color: Colors
                    //                                                   .white)),
                    //                                     ),
                    //                                     SizedBox(
                    //                                       width:
                    //                                           sizeWidth * 0.02,
                    //                                     ),
                    //                                     TextWidget(
                    //                                       text: "From",
                    //                                       fontSize: 15,
                    //                                     )
                    //                                   ],
                    //                                 ),
                    //                               ),
                    //                               Padding(
                    //                                 padding: const EdgeInsets
                    //                                     .symmetric(
                    //                                     horizontal: 10),
                    //                                 child: Row(
                    //                                   children: [
                    //                                     Expanded(
                    //                                       child: Padding(
                    //                                         padding:
                    //                                             const EdgeInsets
                    //                                                 .symmetric(
                    //                                                 horizontal:
                    //                                                     5),
                    //                                         child: TextWidget(
                    //                                           text: ticket
                    //                                                   ?.from ??
                    //                                               "",
                    //                                           fontSize: 14,
                    //                                         ),
                    //                                       ),
                    //                                     )
                    //                                   ],
                    //                                 ),
                    //                               ),
                    //                               Padding(
                    //                                 padding: const EdgeInsets
                    //                                     .symmetric(
                    //                                     horizontal: 18),
                    //                                 child: Row(
                    //                                   children: [
                    //                                     ContainerWidget(
                    //                                       color: AppColors
                    //                                           .primaryColor,
                    //                                       height: 0.013,
                    //                                     ),
                    //                                     SizedBox(
                    //                                       width:
                    //                                           sizeWidth * 0.005,
                    //                                     ),
                    //                                     Padding(
                    //                                       padding:
                    //                                           const EdgeInsets
                    //                                               .symmetric(
                    //                                               horizontal:
                    //                                                   12),
                    //                                       child: TextWidget(
                    //                                         text: "",
                    //                                         fontSize: 15,
                    //                                       ),
                    //                                     )
                    //                                   ],
                    //                                 ),
                    //                               ),
                    //                               Padding(
                    //                                 padding: const EdgeInsets
                    //                                     .symmetric(
                    //                                     horizontal: 18),
                    //                                 child: Row(
                    //                                   children: [
                    //                                     ContainerWidget(
                    //                                       color: AppColors
                    //                                           .primaryColor,
                    //                                       height: 0,
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               ),
                    //                               Padding(
                    //                                 padding: const EdgeInsets
                    //                                     .symmetric(
                    //                                     horizontal: 15),
                    //                                 child: Row(
                    //                                   children: [
                    //                                     ContainerWidget(
                    //                                       color: AppColors
                    //                                           .primaryColor,
                    //                                       height: 0.020,
                    //                                     ),
                    //                                     Padding(
                    //                                       padding:
                    //                                           const EdgeInsets
                    //                                               .symmetric(
                    //                                               horizontal:
                    //                                                   12),
                    //                                       child: TextWidget(
                    //                                         text: "To",
                    //                                         fontSize: 15,
                    //                                         color: AppColors
                    //                                             .primaryColor,
                    //                                       ),
                    //                                     )
                    //                                   ],
                    //                                 ),
                    //                               ),
                    //                               Row(
                    //                                 children: [
                    //                                   Expanded(
                    //                                     child: Padding(
                    //                                       padding:
                    //                                           const EdgeInsets
                    //                                               .symmetric(
                    //                                               horizontal:
                    //                                                   10),
                    //                                       child: TextWidget(
                    //                                         text: ticket?.to ??
                    //                                             "",
                    //                                         fontSize: 14,
                    //                                       ),
                    //                                     ),
                    //                                   )
                    //                                 ],
                    //                               ),
                    //                               Container(
                    //                                   width: sizeWidth,
                    //                                   child: Wrap(
                    //                                     direction:
                    //                                         Axis.horizontal,
                    //                                     children: [
                    //                                       for (int i = 0;
                    //                                           i <
                    //                                               ticket!
                    //                                                   .seatNoList!
                    //                                                   .length;
                    //                                           i++)
                    //                                         Container(
                    //                                           width: 40,
                    //                                           child: Padding(
                    //                                             padding:
                    //                                                 const EdgeInsets
                    //                                                     .all(
                    //                                                     5.0),
                    //                                             child: Row(
                    //                                               children: [
                    //                                                 Container(
                    //                                                   child:
                    //                                                       Column(
                    //                                                     children: [
                    //                                                       Text(
                    //                                                         ticket!.seatNoList![i].toString(),
                    //                                                         style: fontStyle(
                    //                                                             color: AppColors.primaryColor,
                    //                                                             fontFamily:FontFamily.bold,
                    //                                                             fontSize: 12),
                    //                                                       ),
                    //                                                       SvgPicture
                    //                                                           .asset(
                    //                                                         "assets/images/unavailable_seats.svg",
                    //                                                         color:
                    //                                                             AppColors.primaryColor,
                    //                                                         height:
                    //                                                             18,
                    //                                                       )
                    //                                                     ],
                    //                                                   ),
                    //                                                 ),
                    //                                                 //SizedBox(width: 5,)
                    //                                               ],
                    //                                             ),
                    //                                           ),
                    //                                         )
                    //                                     ],
                    //                                   )),
                    //                               SizedBox(
                    //                                 width: sizeWidth * 0.9,

                    //                                 child: const Divider(
                    //                                   thickness: 1,
                    //                                   color: Colors.white,
                    //                                 ),
                    //                                 //  child:const  Text(
                    //                                 //   "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ",
                    //                                 //   style: fontStyle(
                    //                                 //     color: Colors.white,
                    //                                 //     fontSize: 20,
                    //                                 //     fontFamily:FontFamily.regular
                    //                                 //   ),
                    //                                 // ),
                    //                               ),
                    //                               Padding(
                    //                                 padding:
                    //                                     const EdgeInsets.all(5),
                    //                                 child: Row(
                    //                                   mainAxisAlignment:
                    //                                       MainAxisAlignment
                    //                                           .spaceBetween,
                    //                                   children: [
                    //                                     Text(
                    //                                       ("${Routes.curruncy}  ${ticket?.price ?? 0}")
                    //                                           .toString(),
                    //                                       style: fontStyle(
                    //                                           color: AppColors
                    //                                               .primaryColor,
                    //                                           fontFamily:
                    //                                               "bold",
                    //                                           fontSize: 25),
                    //                                     )
                    //                                   ],
                    //                                 ),
                    //                               ),
                    //                               Container(
                    //                                 margin: EdgeInsets.all(5),
                    //                                 child: Row(
                    //                                   children: [
                    //                                     Expanded(
                    //                                       child: InkWell(
                    //                                         onTap: () {
                    //                                           BlocProvider.of<
                    //                                                       TicketCubit>(
                    //                                                   context)
                    //                                               .getTicketdetails(
                    //                                                   tekitid:
                    //                                                       ticket!.reservationId! ??
                    //                                                           0);
                    //                                         },
                    //                                         child: Container(
                    //                                           height: 50,
                    //                                           alignment:
                    //                                               Alignment
                    //                                                   .center,
                    //                                           decoration: BoxDecoration(
                    //                                               borderRadius:
                    //                                                   BorderRadius
                    //                                                       .circular(
                    //                                                           12),
                    //                                               color: AppColors
                    //                                                   .darkGrey),
                    //                                           child: Text(
                    //                                             LanguageClass
                    //                                                     .isEnglish
                    //                                                 ? "Policy"
                    //                                                 : "الخصوصية",
                    //                                             textAlign:
                    //                                                 TextAlign
                    //                                                     .end,
                    //                                             style: fontStyle(
                    //                                                 color: AppColors
                    //                                                     .white,
                    //                                                 fontSize:
                    //                                                     20,
                    //                                                 fontFamily:
                    //                                                     "bold"),
                    //                                           ),
                    //                                         ),
                    //                                       ),
                    //                                     ),
                    //                                     SizedBox(
                    //                                       width: 20,
                    //                                     ),
                    //                                     Expanded(
                    //                                       child: InkWell(
                    //                                         onTap: () {
                    //                                           dawnload = true;

                    //                                           BlocProvider.of<
                    //                                                       TicketCubit>(
                    //                                                   context)
                    //                                               .getTicketdetails(
                    //                                                   tekitid:
                    //                                                       ticket!.reservationId! ??
                    //                                                           0);
                    //                                         },
                    //                                         child: Container(
                    //                                           height: 50,
                    //                                           alignment:
                    //                                               Alignment
                    //                                                   .center,
                    //                                           decoration: BoxDecoration(
                    //                                               borderRadius:
                    //                                                   BorderRadius
                    //                                                       .circular(
                    //                                                           12),
                    //                                               color: AppColors
                    //                                                   .darkPurple),
                    //                                           child: Text(
                    //                                             LanguageClass
                    //                                                     .isEnglish
                    //                                                 ? "Download"
                    //                                                 : "تنزيل",
                    //                                             textAlign:
                    //                                                 TextAlign
                    //                                                     .end,
                    //                                             style: fontStyle(
                    //                                                 color: AppColors
                    //                                                     .white,
                    //                                                 fontSize:
                    //                                                     20,
                    //                                                 fontFamily:
                    //                                                     "bold"),
                    //                                           ),
                    //                                         ),
                    //                                       ),
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               )
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       }),
                    // ),
                  ],
                ),
              );
            } else {
              get();

              return Container();
            }
          },
        ),
      ),
      bottomNavigationBar: Navigationbottombar(currentIndex: 1),
    );
  }
}
