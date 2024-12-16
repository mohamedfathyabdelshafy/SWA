import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/payment_packages/Electronic_wallet.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/payment_packages/cardpayment_packages.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/payment_packages/fawrypayment.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_states_my_wallet.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/screens/credit_card_pay_viewd.dart';

class packagePaymentScreen extends StatefulWidget {
  packagePaymentScreen({
    super.key,
  });
  @override
  State<packagePaymentScreen> createState() => _packagePaymentScreenState();
}

class _packagePaymentScreenState extends State<packagePaymentScreen> {
  bool _switchValue = true;

  PackagesBloc packagesBloc = new PackagesBloc();

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
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.primaryColor,
                    size: 35,
                  ),
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
                      fontWeight: FontWeight.w600,
                      fontFamily: "roman"),
                ),
              ),
              SizedBox(
                height: sizeHeight * 0.01,
              ),
              Row(
                children: [
                  customText(LanguageClass.isEnglish
                      ? "Wallet deduction"
                      : "خصم من المحفظة"),
                  const Spacer(),
                  CupertinoSwitch(
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                  ),
                ],
              ),
              _switchValue
                  ? const SizedBox()
                  : Column(
                      children: [
                        const SizedBox(
                          height: 17,
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<ReservationCubit>(
                                        create: (context) => ReservationCubit(),
                                        child: Cardpaymentscreen(
                                          index: 1,
                                        )),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/visa.png',
                                height: 50,
                                width: 45,
                                fit: BoxFit.fitWidth,
                              ),
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
                                  ? "Debit or credit card"
                                  : "بطاقة الخصم او الأئتمان")
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
                                  child: FawrypayScreen(),
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
                                        create: (context) => ReservationCubit(),
                                        child: Electronicwalletpackage()),
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
              SizedBox(
                height: 50,
              ),
              _switchValue
                  ? BlocListener(
                      bloc: packagesBloc,
                      listener: (context, PackagesState state) {
                        if (state.reservationResponseMyWalletModel?.status ==
                            'success') {
                          Constants.hideLoadingDialog(context);
                          Constants.showDefaultSnackBar(
                              context: context,
                              color: Colors.green,
                              text: state
                                  .reservationResponseMyWalletModel!.message!);
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.initialRoute, (route) => false);
                        } else if (state
                                .reservationResponseMyWalletModel?.status ==
                            'failed') {
                          Constants.hideLoadingDialog(context);
                          Constants.showDefaultSnackBar(
                              context: context,
                              color: Colors.red,
                              text: state
                                  .reservationResponseMyWalletModel!.message!);
                        }
                      },
                      child: InkWell(
                        onTap: () {
                          final tripOneId =
                              CacheHelper.getDataToSharedPref(key: 'tripOneId');
                          final tripRoundId = CacheHelper.getDataToSharedPref(
                              key: 'tripRoundId');
                          final selectedDayTo = CacheHelper.getDataToSharedPref(
                              key: 'selectedDayTo');
                          final selectedDayFrom =
                              CacheHelper.getDataToSharedPref(
                                  key: 'selectedDayFrom');
                          final toStationId = CacheHelper.getDataToSharedPref(
                              key: 'toStationId');
                          final fromStationId = CacheHelper.getDataToSharedPref(
                              key: 'fromStationId');
                          final seatIdsOneTrip =
                              CacheHelper.getDataToSharedPref(key: 'countSeats')
                                  ?.map((e) => int.tryParse(e) ?? 0)
                                  .toList();
                          final seatIdsRoundTrip =
                              CacheHelper.getDataToSharedPref(
                                      key: 'countSeats2')
                                  ?.map((e) => int.tryParse(e) ?? 0)
                                  .toList();
                          final price =
                              CacheHelper.getDataToSharedPref(key: 'price');
                          print(
                              "tripOneId${tripOneId}==tripRoundId${tripRoundId}=====seatIdsOneTrip${seatIdsOneTrip}===seatIdsRoundTrip${seatIdsRoundTrip}==$price");
                          print(
                              "tripOneId${selectedDayTo}==tripOneId${selectedDayFrom}=====${toStationId}===${fromStationId}==$price");

                          packagesBloc.add(packeydetcutpaymentevent(
                              Amount: Routes.Amount,
                              FromStationID: int.parse(Routes.FromStationID!),
                              PackageID: Routes.PackageID,
                              PackagePriceID: Routes.PackagePriceID,
                              PaymentTypeID: 67,
                              PaymentMethodID: 4,
                              PromoCodeID: Routes.PromoCodeID,
                              ToStationID: int.parse(Routes.ToStationID!)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Constants.customButton(
                            borderradias: 41,
                            text: LanguageClass.isEnglish ? "payment" : "دفع",
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    )
                  : SizedBox()
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
          color: Colors.black, fontSize: 21, fontFamily: "regular"),
    );
  }
}
