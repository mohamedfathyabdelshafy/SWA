import 'dart:developer';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as initl;
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/hex_color.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/Swa_umra/Screens/payment/Select_paymeny_screen.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/sign_in/presentation/screens/login.dart';
import 'package:swa/main.dart';

class TicketScreen extends StatefulWidget {
  TicketScreen({
    super.key,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final UmraBloc _umraBloc = UmraBloc();

  TextEditingController _promocodetext = new TextEditingController(text: '');

  List selectedseats = [];
  double discount = 0;
  bool accept = false;

  double afterdiscount = 0;

  String promocodid = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    afterdiscount = (UmraDetails.tripList.price / 2) *
        (UmraDetails.bookedseatsgo.length + UmraDetails.bookedseatsback.length);

    UmraDetails.afterdiscount = afterdiscount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener(
        bloc: _umraBloc,
        listener: (context, UmraState state) {
          if (state.policyticketmodel?.status == 'success') {
            showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.5),
                useRootNavigator: true,
                builder: (context) {
                  return StatefulBuilder(builder: (buildContext,
                      StateSetter setStater /*You can rename this!*/) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    LanguageClass.isEnglish
                                        ? 'Terms and conditions '
                                        : "الشروط والأحكام",
                                    textAlign: LanguageClass.isEnglish
                                        ? TextAlign.left
                                        : TextAlign.right,
                                    textDirection: LanguageClass.isEnglish
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'bold',
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ListView.builder(
                                    itemCount: state
                                        .policyticketmodel!.message!.length,
                                    shrinkWrap: true,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Text(
                                              "${index + 1}- ${state.policyticketmodel!.message![index]}",
                                              textAlign: TextAlign.justify,
                                              textDirection:
                                                  LanguageClass.isEnglish
                                                      ? TextDirection.ltr
                                                      : TextDirection.rtl,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'meduim',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black)));
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                });
          } else if (state.promocodemodel?.status == 'failed') {
            _promocodetext.text = '';
            afterdiscount = (UmraDetails.tripList.price / 2) *
                (UmraDetails.bookedseatsgo.length +
                    UmraDetails.bookedseatsback.length);

            UmraDetails.afterdiscount = afterdiscount;

            discount = 0;
            UmraDetails.dicount = discount;
            UmraDetails.promocodid = '';
            Constants.showDefaultSnackBar(
                color: AppColors.umragold,
                context: context,
                text: state.promocodemodel!.errormessage ?? ' ');
          } else if (state.promocodemodel?.status == 'success') {
            discount = state.promocodemodel!.message!.discount!;

            promocodid = state.promocodemodel!.message!.promoCodeId.toString();

            UmraDetails.promocodid = promocodid;
            double totalprice = (UmraDetails.tripList.price / 2) *
                (UmraDetails.bookedseatsgo.length +
                    UmraDetails.bookedseatsback.length);

            if (state.promocodemodel!.message!.isPrecentage == true) {
              discount =
                  totalprice * state.promocodemodel!.message!.discount! / 100;

              UmraDetails.dicount = discount;
              afterdiscount = totalprice - discount;
              UmraDetails.afterdiscount = afterdiscount;
            } else {
              discount = state.promocodemodel!.message!.discount!;
              UmraDetails.dicount = discount;
              afterdiscount = totalprice - discount;
              UmraDetails.afterdiscount = afterdiscount;
            }
          }
          // TODO: implement listener
        },
        child: BlocBuilder(
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
                              LanguageClass.isEnglish ? 'Ticket' : 'التذكرة',
                              style: TextStyle(
                                  fontSize: 24.sp,
                                  fontFamily: 'bold',
                                  fontWeight: FontWeight.w500),
                            )),
                        Container(
                            child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: AppColors.umragold,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      LanguageClass.isEnglish
                                          ? 'Round Trip'
                                          : 'التذكرة',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'bold'),
                                    ),
                                    Text(
                                      UmraDetails.tripList.campaignName!,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'bold'),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      initl.DateFormat("EEE, MMM d, yyyy")
                                          .format(
                                              UmraDetails.tripList.tripDateGo!)
                                          .toString(),
                                      style: TextStyle(
                                          fontFamily: 'meduim',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white),
                                    ),
                                    Text(
                                      '   :  ',
                                      style: TextStyle(
                                          fontFamily: 'meduim',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white),
                                    ),
                                    Text(
                                      initl.DateFormat("EEE, MMM d, yyyy")
                                          .format(UmraDetails
                                              .tripList.tripDateBack!)
                                          .toString(),
                                      style: TextStyle(
                                          fontFamily: 'meduim',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              UmraDetails.tripList.fromGo!
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: 'bold',
                                                  fontSize: 14,
                                                  height: 1,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.white),
                                            ),
                                          ),
                                          Container(
                                            width: 14,
                                            height: 14,
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              'assets/images/arrowforward.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              UmraDetails.tripList.toGo!,
                                              style: TextStyle(
                                                  fontFamily: 'bold',
                                                  fontSize: 14,
                                                  height: 1,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/time.svg',
                                          width: 16,
                                          height: 16,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            UmraDetails.tripList.tripTimeGo!,
                                            style: TextStyle(
                                                fontFamily: 'bold',
                                                fontSize: 14,
                                                height: 1,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Wrap(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Container(
                                              child: SvgPicture.asset(
                                                  'assets/images/seatumra.svg'),
                                            ),
                                            2.verticalSpace,
                                            ...UmraDetails.bookedseatsgo
                                                .map((e) => Text(
                                                      '$e ,',
                                                      style: TextStyle(
                                                          fontFamily: 'meduim',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              AppColors.white),
                                                    ))
                                                .toList(),
                                          ]),
                                    )
                                  ],
                                ),
                                5.verticalSpace,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.loose,
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              UmraDetails.tripList.fromBack!
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: 'bold',
                                                  fontSize: 14,
                                                  height: 1,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.white),
                                            ),
                                          ),
                                          Container(
                                            width: 14,
                                            height: 14,
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              'assets/images/arrowforward.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              UmraDetails.tripList.toBack!,
                                              style: TextStyle(
                                                  fontFamily: 'bold',
                                                  fontSize: 14,
                                                  height: 1,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/time.svg',
                                          width: 16,
                                          height: 16,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            UmraDetails.tripList.tripTimeBack!,
                                            style: TextStyle(
                                                fontFamily: 'bold',
                                                fontSize: 14,
                                                height: 1,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Wrap(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Container(
                                              child: SvgPicture.asset(
                                                  'assets/images/seatumra.svg'),
                                            ),
                                            2.verticalSpace,
                                            ...UmraDetails.bookedseatsback
                                                .map((e) => Text(
                                                      '$e ,',
                                                      style: TextStyle(
                                                          fontFamily: 'meduim',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              AppColors.white),
                                                    ))
                                                .toList(),
                                          ]),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                        20.verticalSpace,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: DottedLine(
                            dashColor: Color(0xff707070),
                          ),
                        ),
                        20.verticalSpace,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 35.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                LanguageClass.isEnglish ? 'Price' : 'السعر',
                                style: TextStyle(
                                    fontFamily: 'bold',
                                    fontSize: 14,
                                    height: 1,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor),
                              ),
                              Text(
                                '${(UmraDetails.tripList.price / 2) * (UmraDetails.bookedseatsgo.length + UmraDetails.bookedseatsback.length)} ${Routes.curruncy}',
                                style: TextStyle(
                                    fontFamily: 'bold',
                                    fontSize: 14,
                                    height: 1,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor),
                              ),
                            ],
                          ),
                        ),
                        15.verticalSpace,
                        Container(
                          height: 44,
                          margin: EdgeInsets.symmetric(horizontal: 33.w),
                          decoration: BoxDecoration(
                              color: Color(0xffDEDEDE),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xffa7a7a7).withOpacity(0.1),
                                    blurRadius: 3,
                                    offset: Offset(0, 3))
                              ]),
                          child: TextField(
                            controller: _promocodetext,
                            style: TextStyle(
                                color: Color(0xff969696),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: LanguageClass.isEnglish
                                  ? 'I have a Promo Code !'
                                  : 'لدي كود خصم',
                              hintStyle: TextStyle(
                                  color: Color(0xff969696),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              suffixIcon: InkWell(
                                onTap: () {
                                  if (_promocodetext.text != "") {
                                    _umraBloc.add(CheckpromcodeEvent(
                                        code: _promocodetext.text));
                                  } else {
                                    Constants.showDefaultSnackBar(
                                        color: AppColors.umragold,
                                        context: context,
                                        text: LanguageClass.isEnglish
                                            ? 'Please enter code'
                                            : 'من فضلك  ادخل الكود ');
                                  }
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: AppColors.umragold,
                                      borderRadius: BorderRadius.circular(22)),
                                  padding: EdgeInsets.only(left: 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    LanguageClass.isEnglish
                                        ? 'Redeem'
                                        : "تطبيق",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        15.verticalSpace,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 35.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                LanguageClass.isEnglish ? 'Disscount' : 'خصم',
                                style: TextStyle(
                                    fontFamily: 'bold',
                                    fontSize: 14,
                                    height: 1,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor),
                              ),
                              Text(
                                discount.toString(),
                                style: TextStyle(
                                    fontFamily: 'bold',
                                    fontSize: 14,
                                    height: 1,
                                    fontWeight: FontWeight.w600,
                                    color: HexColor('#FF0000')),
                              ),
                            ],
                          ),
                        ),
                        20.verticalSpace,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          width: double.infinity,
                          child: Divider(
                            color: Color(0xff707070),
                            height: 1,
                          ),
                        ),
                        20.verticalSpace,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 35.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                LanguageClass.isEnglish
                                    ? 'Total Price'
                                    : 'السعر الاجمالي',
                                style: TextStyle(
                                    fontFamily: 'bold',
                                    fontSize: 14,
                                    height: 1,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor),
                              ),
                              Text(
                                '${afterdiscount} ${Routes.curruncy}',
                                style: TextStyle(
                                    fontFamily: 'bold',
                                    fontSize: 14,
                                    height: 1,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                  value: accept,
                                  hoverColor: Colors.black,
                                  checkColor: AppColors.umragold,
                                  focusColor: Colors.black,
                                  activeColor: Colors.black,
                                  fillColor:
                                      MaterialStatePropertyAll(Colors.white),
                                  onChanged: (value) {
                                    setState(() {
                                      accept = !accept;
                                    });

                                    if (accept) {
                                      _umraBloc.add(Getpolicyevent());
                                    }
                                  }),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    LanguageClass.isEnglish
                                        ? 'I read and accept Swa Umrah terms and conditions'
                                        : 'لقد قرأت وأوافق على شروط وأحكام سوا عمرة',
                                    style: TextStyle(
                                        fontFamily: 'meduim',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: InkWell(
                            onTap: () {
                              if (Routes.user != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SelectPaymentUmraScreen(
                                              user: Routes.user,
                                            )));
                              } else {
                                if (accept == false) {
                                  Constants.showDefaultSnackBar(
                                      context: context,
                                      color: AppColors.umragold,
                                      text: LanguageClass.isEnglish
                                          ? "accept terms and conditions "
                                          : 'قبول الشروط والأحكام');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider<LoginCubit>(
                                              create: (context) =>
                                                  sl<LoginCubit>(),
                                            ),
                                          ],
                                          child: LoginScreen(
                                            isback: true,
                                          ),
                                        ),
                                      ));
                                }
                              }
                            },
                            child: Constants.customButton(
                                borderradias: 40,
                                text: LanguageClass.isEnglish
                                    ? "Proceed to Payment"
                                    : "الدفع",
                                color: AppColors.umragold),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ));
            }),
      ),
    );
  }
}
