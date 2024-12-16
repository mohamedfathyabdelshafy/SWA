import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/Timer_widget.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/select_payment2/data/models/trip_reservartion_model.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_states_my_wallet.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/screens/credit_card_pay_viewd.dart';
import 'package:swa/select_payment2/presentation/screens/electronic_screens.dart';
import 'package:swa/select_payment2/presentation/screens/fawry.dart';

import '../../../../../core/local_cache_helper.dart';
import '../../../../../core/utils/constants.dart';
import '../../../config/routes/app_routes.dart';

class SelectPaymentScreen2 extends StatefulWidget {
  SelectPaymentScreen2(
      {super.key, this.user, required this.promcodeid, required this.discount});
  User? user;
  String promcodeid;
  String discount;
  @override
  State<SelectPaymentScreen2> createState() => _SelectPaymentScreen2State();
}

class _SelectPaymentScreen2State extends State<SelectPaymentScreen2> {
  bool _switchValue = true;
  int? countryid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: sizeHeight * 0.08,
              ),
              Container(
                alignment: LanguageClass.isEnglish
                    ? Alignment.topLeft
                    : Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.primaryColor,
                        size: 35,
                      ),
                    ),
                    Timerwidget()
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  LanguageClass.isEnglish
                      ? "Select payment"
                      : "حدد طريقة الدفع",
                  style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 38,
                      fontWeight: FontWeight.w500,
                      fontFamily: "roman"),
                ),
              ),
              SizedBox(
                height: sizeHeight * 0.01,
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 17,
                  ),
                  BlocListener(
                    bloc: BlocProvider.of<ReservationCubit>(context),
                    listener: (context, state) {
                      if (state is LoadingMyWalletState) {
                        Constants.showLoadingDialog(context);
                      }
                      if (state is LoadedMyWalletState) {
                        Constants.hideLoadingDialog(context);
                        Constants.showDefaultSnackBar(
                            context: context,
                            color:
                                state.reservationResponseMyWalletModel.status ==
                                        'success'
                                    ? Colors.green
                                    : Colors.red,
                            text: state
                                .reservationResponseMyWalletModel.message!);
                        if (state.reservationResponseMyWalletModel.status ==
                            'success') {
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.initialRoute, (route) => false);
                        }
                      }
                      if (state is ErrorMyWalletState) {
                        Constants.hideLoadingDialog(context);
                        Constants.showDefaultSnackBar(
                            context: context, text: state.error);
                      }
                    },
                    child: InkWell(
                      onTap: () async {
                        BlocProvider.of<ReservationCubit>(context)
                            .addReservationMyWallet(
                                promocodeid: widget.promcodeid,
                                custId: widget.user!.customerId!,
                                paymentTypeID: 67,
                                trips: Routes.resrvedtrips);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.wallet),
                          const SizedBox(
                            width: 5,
                          ),
                          customText(LanguageClass.isEnglish
                              ? "Wallet deduction"
                              : "خصم من المحفظة"),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            padding: EdgeInsets.all(7),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.primaryColor, width: 2)),
                            child: Text(
                              widget.user!.walletBalance.toString(),
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontFamily: "black"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  countryid == 3
                      ? SizedBox()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BlocProvider<ReservationCubit>(
                                            create: (context) =>
                                                ReservationCubit(),
                                            child: CreditCardPayView(
                                                Discount: widget.discount,
                                                promocodeid: widget.promcodeid,
                                                index: 1,
                                                user: widget.user!)),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/master_card.png',
                                    height: 50,
                                    width: 45,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  customText(LanguageClass.isEnglish
                                      ? "Pay with card"
                                      : "الدفع بالبطاقة")
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BlocProvider<ReservationCubit>(
                                      create: (context) => ReservationCubit(),
                                      child: FawryScreenReservation(
                                          user: widget.user!),
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: AppColors.yellow2,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: const Color(0xff4587FF))),
                                    child: SvgPicture.asset(
                                      'assets/images/Group 97.svg',
                                      // height: 60,
                                      // width: 100,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  customText(LanguageClass.isEnglish
                                      ? "Pay Fawry"
                                      : "مدفوعات فوري")
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BlocProvider<ReservationCubit>(
                                            create: (context) =>
                                                ReservationCubit(),
                                            child: ElectronicScreen2(
                                                user: widget.user!)),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/icons8-open-wallet-78.png',
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  customText(LanguageClass.isEnglish
                                      ? "Electronic wallet"
                                      : "المحفظة الاكترونية")
                                ],
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customText(text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black, fontSize: 21, fontFamily: "roman"),
    );
  }
}
