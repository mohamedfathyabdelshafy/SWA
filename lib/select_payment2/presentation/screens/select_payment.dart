import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/Timer_widget.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_states.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/features/payment/wallet/data/model/my_wallet_response_model.dart';
import 'package:swa/features/payment/wallet/data/repo/my_wallet_repo.dart';
import 'package:swa/features/reusable_payment/presentation/screens/reusable_payment_screen.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/main.dart';
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
  const SelectPaymentScreen2({super.key, this.user, required this.promcodeid, required this.discount});
  final User? user;
  final String promcodeid;
  final String discount;
  @override
  State<SelectPaymentScreen2> createState() => _SelectPaymentScreen2State();
}

class _SelectPaymentScreen2State extends State<SelectPaymentScreen2> {
  int? countryid;
  double balance = 0;

  getwalllet() async {
    MyWalletResponseModel? wallet = await MyWalletRepo(sl()).getMyWallet(customerId: Routes.customerid!);
    setState(() {
      balance = wallet!.message!;
    });
  }

  @override
  void initState() {
    super.initState();
    countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    getwalllet();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReservationCubit(),
      child: BlocListener<ReservationCubit, ReservationStates>(
        listener: _handleListenner,
        child: ReusablePaymentMethodSelectionScreen(
          onBackPressed: (context) => Navigator.pop(context),
          onElectronicWalletPressed: _onElectronicWalletPressed,
          onVisaPaymentPressed: _onVisaPaymentPressed,
          onFawryPressed: _onFawryPaymentPressed,
          onWalletPaymentPressed: _onWalletPaymentPressed,
          hasWalletPayment: true,
          shouldHideOtherPaymentMethodsIfWalletSelected: true,
          hasTimer: true,
          walletBalance: balance,
        ),
      ),
    );
  }

  void _handleListenner(BuildContext context, state) {
    if (state is LoadingMyWalletState) {
      Constants.showLoadingDialog(context);
    }
    if (state is LoadedMyWalletState) {
      Constants.hideLoadingDialog(context);
      Constants.showDefaultSnackBar(
          context: context,
          color: state.reservationResponseMyWalletModel.status == 'success' ? Colors.green : Colors.red,
          text: state.reservationResponseMyWalletModel.message!);
      if (state.reservationResponseMyWalletModel.status == 'success') {
        Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false, arguments: Routes.isomra);
      }
    }
    if (state is ErrorMyWalletState) {
      Constants.hideLoadingDialog(context);
      Constants.showDefaultSnackBar(context: context, text: state.error);
    }
  }

  void _onFawryPaymentPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ReservationCubit>(
          create: (context) => ReservationCubit(),
          child: FawryScreenReservation(user: widget.user!),
        ),
      ),
    );
  }

  void _onVisaPaymentPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ReservationCubit>(
            create: (context) => ReservationCubit(),
            child: CreditCardPayView(
                Discount: widget.discount, promocodeid: widget.promcodeid, index: 1, user: widget.user!)),
      ),
    );
  }

  void _onElectronicWalletPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ReservationCubit>(
            create: (context) => ReservationCubit(), child: ElectronicScreen2(user: widget.user!)),
      ),
    );
  }

  void _onWalletPaymentPressed(BuildContext context) {
    BlocProvider.of<ReservationCubit>(context).addReservationMyWallet(
        promocodeid: widget.promcodeid,
        custId: widget.user!.customerId!,
        paymentTypeID: 67,
        trips: Routes.resrvedtrips);
  }
}
