import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/new_statistics.dart/widgets/Payment_widget.dart';
import 'package:swa/features/new_statistics.dart/widgets/Reservation_widget.dart';
import 'package:swa/features/new_statistics.dart/widgets/Statistics_widget.dart';
import 'package:swa/features/new_statistics.dart/bloc/statistics_bloc.dart';
import 'package:swa/features/new_statistics.dart/model/All_statics_model.dart';
import 'package:swa/features/payment/select_payment/presentation/screens/select_payment.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';

class statisticsMainScreen extends StatefulWidget {
  const statisticsMainScreen({super.key});

  @override
  State<statisticsMainScreen> createState() => _statisticsMainScreenState();
}

class _statisticsMainScreenState extends State<statisticsMainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (Routes.user != null) {
      BlocProvider.of<StatisticsBloc>(context).add(GetmainstatisticsEvent());
      BlocProvider.of<StatisticsBloc>(context).add(GetAllStatisticsEvent());
    }
  }

  List<statistics> statisticslist = [];

  String? walletbalance = '';

  List<statistics> Allstatisticslist = [];

  AllStaticsModel? allStaticsModel = AllStaticsModel(
      message: Statisticdata(
          monthlyStats: [],
          topRoutes: [],
          payments: [],
          reservations: [],
          fees: [],
          penalties: [],
          refunds: [],
          rewards: [],
          summary: Summary()));

  void _openChargePaymentScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ReservationCubit>(
          create: (context) => ReservationCubit(),
          child: SelectPaymentScreen(user: Routes.user),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Navigationbottombar(
          currentIndex: 2,
        ),
        backgroundColor: Colors.white,
        body: Directionality(
            textDirection:
                LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
            child: Routes.user == null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            LanguageClass.isEnglish
                                ? "Please Login"
                                : "يرجى تسجيل الدخول",
                            textAlign: TextAlign.center,
                            style: fontStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontFamily: FontFamily.medium,
                              fontSize: 20.sp,
                            ),
                          ),
                          18.verticalSpace,
                          SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Routes.signInRoute);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                              ),
                              child: Text(
                                LanguageClass.isEnglish
                                    ? "Login"
                                    : "تسجيل الدخول",
                                style: fontStyle(
                                  color: Colors.white,
                                  fontFamily: FontFamily.bold,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SafeArea(
                    child: BlocListener<StatisticsBloc, StatisticsState>(
                        bloc: BlocProvider.of<StatisticsBloc>(context),
                        listener: (context, state) {
                          if (state is MainstatisticsState) {
                            walletbalance = state
                                .mainStaticsModel?.message?.walletBalance
                                .toString();

                            statisticslist = [
                              statistics(
                                title: LanguageClass.isEnglish
                                    ? "Wallet Balance"
                                    : "رصيد المحفظة",
                                subtitle: Routes.curruncy,
                                value: state
                                    .mainStaticsModel?.message?.walletBalance
                                    .toString(),
                                image: 'assets/images/wallet.svg',
                              ),
                              statistics(
                                title: LanguageClass.isEnglish
                                    ? "Total Reservation"
                                    : "اجمالي الحجوزات",
                                subtitle: LanguageClass.isEnglish
                                    ? "reservation"
                                    : "حجز",
                                value: state.mainStaticsModel?.message
                                    ?.totalReservationCount
                                    .toString(),
                                image: 'assets/images/bus24.svg',
                              ),
                              statistics(
                                title: LanguageClass.isEnglish
                                    ? "Total spend"
                                    : "اجمالي النفقات",
                                subtitle: Routes.curruncy,
                                value: state.mainStaticsModel?.message
                                    ?.totalReservationAmount
                                    .toString(),
                                image: 'assets/images/CreditCard-24px.svg',
                              ),
                              statistics(
                                title: LanguageClass.isEnglish
                                    ? "Total Loyalty"
                                    : "نقاظ الولاء",
                                subtitle:
                                    LanguageClass.isEnglish ? "point" : "نقطة",
                                value: state
                                    .mainStaticsModel?.message?.totalLoyalty
                                    .toString(),
                                image: 'assets/images/Calendar-24px.svg',
                              ),
                            ];
                          } else if (state is AllstatisticsState) {
                            allStaticsModel = state.allStaticsModel;
                            Allstatisticslist = [
                              statistics(
                                title: LanguageClass.isEnglish
                                    ? "Total Payment"
                                    : "إجمالي المدفوعات",
                                subtitle: LanguageClass.isEnglish
                                    ? "reservation"
                                    : "حجز",
                                value: state.allStaticsModel!.message?.summary
                                    ?.totalPayment
                                    .toString(),
                                image: 'assets/images/CreditCard-24px.svg',
                              ),
                              statistics(
                                title: LanguageClass.isEnglish
                                    ? "Total Reservation"
                                    : "إجمالي الحجوزات",
                                subtitle: LanguageClass.isEnglish
                                    ? "reservation"
                                    : "حجز",
                                value: state.allStaticsModel!.message?.summary
                                    ?.totalReservationCount
                                    .toString(),
                                image: 'assets/images/bus24.svg',
                              ),
                              statistics(
                                title: LanguageClass.isEnglish
                                    ? "Total Gifts"
                                    : "أرصدة الهدايا",
                                subtitle: Routes.curruncy,
                                value: state.allStaticsModel!.message?.summary
                                    ?.totalReward
                                    .toString(),
                                image: 'assets/images/Gift-24px.svg',
                              ),
                              statistics(
                                title: LanguageClass.isEnglish
                                    ? "Total Penalty"
                                    : "إجمالي الغرامات",
                                subtitle:
                                    LanguageClass.isEnglish ? "point" : "نقطة",
                                value: state.allStaticsModel!.message?.summary
                                    ?.totalPenalty
                                    .toString(),
                                image: 'assets/images/warning.svg',
                              ),
                              statistics(
                                title: LanguageClass.isEnglish
                                    ? "Administrative Expenses"
                                    : "المصاريف الإدارية",
                                subtitle:
                                    LanguageClass.isEnglish ? "point" : "نقطة",
                                value: state.allStaticsModel!.message?.summary
                                    ?.totalFees
                                    .toString(),
                                image: 'assets/images/DollarSign-24px.svg',
                              ),
                              statistics(
                                title: LanguageClass.isEnglish
                                    ? "Total Refund"
                                    : "اجمالي الاسترداد",
                                subtitle:
                                    LanguageClass.isEnglish ? "point" : "نقطة",
                                value: state.allStaticsModel!.message?.summary
                                    ?.totalRefund
                                    .toString(),
                                image: 'assets/images/TrendingDown-24px.svg',
                              ),
                            ];
                          } else if (state is ReservationdetailsState) {
                            showReservationspopDetails(
                                reservation: state.reservation!,
                                context: context,
                                reservationdetails:
                                    state.reservationdetailsModel!);
                          }
                        },
                        child: BlocBuilder<StatisticsBloc, StatisticsState>(
                            bloc: BlocProvider.of<StatisticsBloc>(context),
                            builder: (context, state) {
                              if (state is Loading) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: AppColors.primaryColor));
                              } else {
                                return Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                      ),
                                      height: 80,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.09),
                                                blurRadius: 14,
                                                offset: const Offset(0, 15),
                                                spreadRadius: 1)
                                          ]),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 45.w,
                                            height: 45.w,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.person_rounded,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ),
                                          15.horizontalSpace,
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                Routes.user!.name!,
                                                style: fontStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                Routes.user!.pinCode.toString(),
                                                style: fontStyle(
                                                  color: Colors.black,
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    20.verticalSpace,
                                    Expanded(
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w),
                                        physics: ScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 1.8,
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 7,
                                                mainAxisSpacing: 7),
                                        itemCount: statisticslist.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: AppColors
                                                        .primaryColor)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 30.w,
                                                  height: 30.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: AppColors
                                                          .primaryColor
                                                          .withOpacity(0.4)),
                                                  child: SvgPicture.asset(
                                                    statisticslist[index]
                                                        .image!,
                                                    width: 15.w,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                8.horizontalSpace,
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        statisticslist[index]
                                                            .title!,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: fontStyle(
                                                          color: Colors.black,
                                                          fontSize: 11.sp,
                                                          fontFamily:
                                                              FontFamily.bold,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        statisticslist[index]
                                                            .value!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: fontStyle(
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontSize: 13.sp,
                                                          fontFamily:
                                                              FontFamily.bold,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        statisticslist[index]
                                                            .subtitle!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: fontStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize: 10.sp,
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (index == 0) ...[
                                                  4.horizontalSpace,
                                                  InkWell(
                                                    onTap:
                                                        _openChargePaymentScreen,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.r),
                                                    child: Container(
                                                      width: 26.w,
                                                      height: 26.w,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.green
                                                                .withOpacity(
                                                                    0.25),
                                                            blurRadius: 6,
                                                            offset:
                                                                const Offset(
                                                                    0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Icon(
                                                        Icons.add_rounded,
                                                        color: Colors.white,
                                                        size: 18.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: DefaultTabController(
                                          length: 3,
                                          initialIndex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16.w),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5.h,
                                                    horizontal: 10.w),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          offset: Offset(0, 4),
                                                          blurRadius: 4,
                                                          spreadRadius: 1)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: TabBar(
                                                    dividerColor:
                                                        Colors.transparent,
                                                    dividerHeight: 0,
                                                    indicatorSize:
                                                        TabBarIndicatorSize.tab,
                                                    indicatorPadding:
                                                        EdgeInsets.zero,
                                                    padding: EdgeInsets.zero,
                                                    labelPadding:
                                                        EdgeInsets.zero,
                                                    indicator: null,
                                                    labelStyle: fontStyle(
                                                        fontFamily:
                                                            FontFamily.bold,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    indicatorWeight: 0.1,
                                                    indicatorColor:
                                                        Colors.transparent,
                                                    labelColor: Colors.black,
                                                    unselectedLabelColor:
                                                        Colors.grey[500],
                                                    tabs: [
                                                      Tab(
                                                        text: LanguageClass
                                                                .isEnglish
                                                            ? "Statistics"
                                                            : "الاحصائيات",
                                                      ),
                                                      Tab(
                                                        text: LanguageClass
                                                                .isEnglish
                                                            ? "Transactions"
                                                            : "المعاملات",
                                                      ),
                                                      Tab(
                                                        text: LanguageClass
                                                                .isEnglish
                                                            ? "Reservations"
                                                            : "الحجوزات",
                                                      ),
                                                    ]),
                                              ),
                                              10.verticalSpace,
                                              Expanded(
                                                child: TabBarView(
                                                  children: [
                                                    StatisticsWidget(
                                                        context: context,
                                                        statisticslist:
                                                            Allstatisticslist,
                                                        allStaticsModel:
                                                            allStaticsModel!),
                                                    paymentWidget(
                                                        context: context,
                                                        allStatics:
                                                            allStaticsModel!,
                                                        walletbalance:
                                                            walletbalance!),
                                                    ReservationWidget(
                                                        context: context,
                                                        allStaticsModel:
                                                            allStaticsModel!,
                                                        walletbalance:
                                                            walletbalance!),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ))
                                  ],
                                );
                              }
                            })))));
  }
}

class statistics {
  String? title;
  String? subtitle;
  String? value;

  String? image;
  statistics({this.title, this.subtitle, this.value, this.image});
}
