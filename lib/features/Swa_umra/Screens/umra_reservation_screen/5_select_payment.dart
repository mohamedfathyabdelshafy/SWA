// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:swa/features/Swa_umra/Screens/payment/Electronic_Wallet.dart';
import 'package:swa/features/Swa_umra/Screens/payment/card_payment.dart';
import 'package:swa/features/Swa_umra/Screens/payment/fawry_screen.dart';
import 'package:swa/features/reusable_payment/presentation/screens/reusable_payment_screen.dart';

class SelectPaymentUmra extends StatelessWidget {
  final int? umrahReservationID;
  const SelectPaymentUmra({super.key, this.umrahReservationID});

  @override
  Widget build(BuildContext context) {
    return ReusablePaymentMethodSelectionScreen(
      onBackPressed: (context) => Navigator.pop(context),
      onElectronicWalletPressed: _onElectronicWalletPressed,
      onVisaPaymentPressed: _onVisaPaymentPressed,
      onFawryPressed: _onFawryPressed,
    );
  }

  void _onElectronicWalletPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ElectronicUmraScreen(
          umrahReservationID: umrahReservationID,
        ),
      ),
    );
  }

  void _onVisaPaymentPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Umracardpay(
          index: 1,
          umrahReservationID: umrahReservationID,
        ),
      ),
    );
  }

  void _onFawryPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FawryUmraScreen(
          umrahReservationID: umrahReservationID,
        ),
      ),
    );
  }
}
