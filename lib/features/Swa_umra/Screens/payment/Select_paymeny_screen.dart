import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/features/Swa_umra/Screens/payment/Electronic_Wallet.dart';
import 'package:swa/features/Swa_umra/Screens/payment/card_payment.dart';
import 'package:swa/features/Swa_umra/Screens/payment/fawry_screen.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/features/payment/wallet/data/model/my_wallet_response_model.dart';
import 'package:swa/features/payment/wallet/data/repo/my_wallet_repo.dart';
import 'package:swa/features/reusable_payment/presentation/screens/reusable_payment_screen.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/data/models/Curruncy_model.dart';

class SelectPaymentUmraScreen extends StatefulWidget {
  const SelectPaymentUmraScreen({super.key, this.user});
  final User? user;
  @override
  State<SelectPaymentUmraScreen> createState() =>
      _SelectPaymentUmraScreenState();
}

class _SelectPaymentUmraScreenState extends State<SelectPaymentUmraScreen> {
  late final int countryid;
  @override
  void initState() {
    super.initState();
    countryid = CacheHelper.getDataToSharedPref(
          key: 'countryid',
        ) ??
        3;
    getwalllet();
  }

  double balance = 0;

  getwalllet() async {
    MyWalletResponseModel? wallet =
        await MyWalletRepo(sl()).getMyWallet(customerId: Routes.customerid!);
    setState(() {
      balance = wallet!.message!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UmraBloc, UmraState>(
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
    );
  }

  void _handleListenner(BuildContext context, UmraState state) {
    if (state.reservationResponseMyWalletModel?.status == 'failed') {
      Constants.showDefaultSnackBar(
          color: AppColors.umragold,
          context: context,
          text: state.reservationResponseMyWalletModel!.message ?? ' ');
    } else if (state.reservationResponseMyWalletModel?.status == 'success') {
      Constants.showDefaultSnackBar(
          color: AppColors.umragold,
          context: context,
          text: state.reservationResponseMyWalletModel!.message ?? ' ');
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  void _onFawryPaymentPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FawryUmraScreen(),
      ),
    );
  }

  void _onVisaPaymentPressed(context) {
    UmraDetails.curruncy = Routes.curruncy!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Umracardpay(
          index: 1,
        ),
      ),
    );
  }

  void _onElectronicWalletPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ElectronicUmraScreen(),
      ),
    );
  }

  void _onWalletPaymentPressed(BuildContext context) {
    context
        .read<UmraBloc>()
        .add(WalletdetactionEvent(PaymentMethodID: 4, paymentTypeID: 67));
  }
}
