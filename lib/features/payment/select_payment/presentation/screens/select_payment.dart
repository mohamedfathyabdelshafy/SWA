import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/payment/electronic_wallet/presentation/cubit/eWallet_cubit.dart';
import 'package:swa/features/payment/electronic_wallet/presentation/screens/electronic_screens.dart';
import 'package:swa/features/payment/fawry/presentation/cubit/fawry_cubit.dart';
import 'package:swa/features/payment/fawry/presentation/screens/fawry.dart';
import 'package:swa/features/reusable_payment/presentation/screens/reusable_payment_screen.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/screens/chargeCard_screen.dart';

class SelectPaymentScreen extends StatefulWidget {
  final User? user;
  const SelectPaymentScreen({super.key, this.user});
  @override
  State<SelectPaymentScreen> createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
  var countryid;

  @override
  void initState() {
    super.initState();

    countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => _onBackPressed(context),
                child: Icon(
                  LanguageClass.isEnglish
                      ? Icons.arrow_back_rounded
                      : Icons.arrow_forward_rounded,
                  color: Routes.isomra
                      ? AppColors.umragold
                      : AppColors.primaryColor,
                  size: 34,
                ),
              ),
              const SizedBox(height: 28),
              ReusablePaymentMethodSelectionScreen(
                countryid: countryid,
                onBackPressed: _onBackPressed,
                onVisaPaymentPressed: _onVisaPaymentPressed,
                onElectronicWalletPressed: _onElectronicWalletPressed,
                onFawryPressed: _onFawryPaymentPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onBackPressed(context) {
    Navigator.pop(context);
  }

  void _onVisaPaymentPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ReservationCubit>(
            create: (context) => ReservationCubit(),
            child: AddWalletBalanceWithCreditCardScreen(
              user: widget.user!,
              index: 0,
            )),
      ),
    );
  }

  void _onFawryPaymentPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<LoginCubit>(
              create: (context) => sl<LoginCubit>(),
            ),
            BlocProvider<FawryCubit>(
              create: (context) => sl<FawryCubit>(),
            ),
            BlocProvider<ReservationCubit>(
              create: (context) => ReservationCubit(),
            ),
          ],
          child: WalletFawryScreen(),
        ),
      ),
    );
  }

  void _onElectronicWalletPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(providers: [
          BlocProvider<LoginCubit>(
            create: (context) => sl<LoginCubit>(),
          ),
          BlocProvider<EWalletCubit>(
            create: (context) => sl<EWalletCubit>(),
          ),
        ], child: const AddWalletBalanceWithElectronicWalletScreen()),
      ),
    );
  }
}
