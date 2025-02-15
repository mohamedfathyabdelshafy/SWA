import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/payment/electronic_wallet/presentation/cubit/eWallet_cubit.dart';
import 'package:swa/features/payment/electronic_wallet/presentation/screens/electronic_screens.dart';
import 'package:swa/features/payment/fawry/presentation/cubit/fawry_cubit.dart';
import 'package:swa/features/payment/fawry/presentation/screens/fawry.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/screens/chargeCard_screen.dart';

class SelectPaymentScreen extends StatefulWidget {
  SelectPaymentScreen({super.key, this.user});
  User? user;
  @override
  State<SelectPaymentScreen> createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Directionality(
          textDirection:
              LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: sizeHeight * 0.08,
              ),
              InkWell(
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
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  LanguageClass.isEnglish
                      ? "Select payment"
                      : "حدد طريقة الدفع",
                  style: fontStyle(
                      color: AppColors.blackColor,
                      fontSize: 38,
                      fontWeight: FontWeight.w500,
                      fontFamily: FontFamily.medium),
                ),
              ),
              SizedBox(
                height: sizeHeight * 0.05,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BlocProvider<ReservationCubit>(
                                    create: (context) => ReservationCubit(),
                                    child: chargeCard(
                                      user: widget.user!,
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
                          Expanded(
                            child: customText(LanguageClass.isEnglish
                                ? "Debit or credit card"
                                : "بطاقة الخصم او الائتمان"),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    countryid == 3
                        ? SizedBox()
                        : Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider<LoginCubit>(
                                            create: (context) =>
                                                sl<LoginCubit>(),
                                          ),
                                          BlocProvider<FawryCubit>(
                                            create: (context) =>
                                                sl<FawryCubit>(),
                                          ),
                                          BlocProvider<ReservationCubit>(
                                            create: (context) =>
                                                ReservationCubit(),
                                          ),
                                        ],
                                        child: FawryScreen(),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          MultiBlocProvider(providers: [
                                        BlocProvider<LoginCubit>(
                                          create: (context) => sl<LoginCubit>(),
                                        ),
                                        BlocProvider<EWalletCubit>(
                                          create: (context) =>
                                              sl<EWalletCubit>(),
                                        ),
                                      ], child: const ElectronicScreen()),
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
      style: fontStyle(
          color: Colors.black, fontSize: 21, fontFamily: FontFamily.medium),
    );
  }
}
