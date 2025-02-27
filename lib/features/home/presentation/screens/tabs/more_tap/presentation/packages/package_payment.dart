import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/payment_packages/Electronic_wallet.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/payment_packages/cardpayment_packages.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/payment_packages/fawrypayment.dart';
import 'package:swa/features/reusable_payment/presentation/screens/reusable_payment_screen.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';

class PackagePaymentScreen extends StatelessWidget {
  const PackagePaymentScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackagesBloc(),
      child: BlocListener<PackagesBloc, PackagesState>(
        listener: _handleListenner,
        child: ReusablePaymentMethodSelectionScreen(
          onBackPressed: (context) => Navigator.pop(context),
          onElectronicWalletPressed: _onElectronicWalletPressed,
          onVisaPaymentPressed: _onVisaPaymentPressed,
          onFawryPressed: _onFawryPaymentPressed,
          onWalletPaymentPressed: _onWalletPaymentPressed,
          hasWalletPayment: true,
          shouldHideOtherPaymentMethodsIfWalletSelected: true,
        ),
      ),
    );
  }

  void _handleListenner(BuildContext context, PackagesState state) {
    if (state.reservationResponseMyWalletModel?.status == 'success') {
      Constants.hideLoadingDialog(context);
      Constants.showDefaultSnackBar(
          context: context, color: Colors.green, text: state.reservationResponseMyWalletModel!.message!);
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false, arguments: Routes.isomra);
    } else if (state.reservationResponseMyWalletModel?.status == 'failed') {
      Constants.hideLoadingDialog(context);
      Constants.showDefaultSnackBar(
          context: context, color: Colors.red, text: state.reservationResponseMyWalletModel!.message!);
    }
  }

  void _onFawryPaymentPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ReservationCubit>(
          create: (context) => ReservationCubit(),
          child: FawrypayScreen(),
        ),
      ),
    );
  }

  void _onVisaPaymentPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BlocProvider<ReservationCubit>(create: (context) => ReservationCubit(), child: Cardpaymentscreen(index: 1)),
      ),
    );
  }

  void _onElectronicWalletPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BlocProvider<ReservationCubit>(create: (context) => ReservationCubit(), child: Electronicwalletpackage()),
      ),
    );
  }

  void _onWalletPaymentPressed(BuildContext context) {
    context.read<PackagesBloc>().add(packeydetcutpaymentevent(
        Amount: Routes.Amount,
        FromStationID: int.parse(Routes.FromStationID!),
        PackageID: Routes.PackageID,
        PackagePriceID: Routes.PackagePriceID,
        PaymentTypeID: 67,
        PaymentMethodID: 4,
        PromoCodeID: Routes.PromoCodeID,
        ToStationID: int.parse(Routes.ToStationID!)));
  }
}
