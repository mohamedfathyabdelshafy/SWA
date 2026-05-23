import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/Timer_widget.dart';
import 'package:swa/features/reusable_payment/data/models/payment_method.dart';
import 'package:swa/features/reusable_payment/presentation/cubits/Payment_Methods/payment_methods_cubit.dart';

class ReusablePaymentMethodSelectionScreen extends StatefulWidget {
  final void Function(BuildContext context) onBackPressed;
  final void Function(BuildContext context)? onWalletPaymentPressed;
  final bool hasTimer;
  final countryid;
  final bool hasWalletPayment;
  final double? walletBalance;
  final bool shouldHideOtherPaymentMethodsIfWalletSelected;
  final void Function(BuildContext context)? onVisaPaymentPressed;
  final void Function(BuildContext context)? onFawryPressed;
  final void Function(BuildContext context)? onElectronicWalletPressed;

  const ReusablePaymentMethodSelectionScreen({
    super.key,
    required this.onBackPressed,
    this.onWalletPaymentPressed,
    this.countryid,
    this.hasWalletPayment = false,
    this.shouldHideOtherPaymentMethodsIfWalletSelected = false,
    this.onVisaPaymentPressed,
    this.onFawryPressed,
    this.onElectronicWalletPressed,
    this.hasTimer = false,
    this.walletBalance,
  });

  @override
  State<ReusablePaymentMethodSelectionScreen> createState() =>
      _ReusablePaymentMethodSelectionScreenState();
}

class _ReusablePaymentMethodSelectionScreenState
    extends State<ReusablePaymentMethodSelectionScreen> {
  bool _walletSwitchOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
              crossAxisAlignment: LanguageClass.isEnglish
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                50.verticalSpace,
                _buildAppBar(context),
                30.verticalSpace,
                _buildSelectPaymentMethodText(),
                50.verticalSpace,
                _buildPaymentMethods()
              ]),
        ),
      ),
      bottomNavigationBar: Navigationbottombar(
        currentIndex: 0,
      ),
    );
  }

// Widgets
  Widget _buildPaymentMethods() {
    final bool isWalletSelected =
        widget.shouldHideOtherPaymentMethodsIfWalletSelected &&
            widget.hasWalletPayment &&
            _walletSwitchOn;

    final bool showWallet = widget.shouldHideOtherPaymentMethodsIfWalletSelected
        ? isWalletSelected
        : widget.hasWalletPayment;

    final bool showonlycard = widget.countryid == '3';

    return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
      builder: (context, state) {
        if (state.isLoading) return CircularProgressIndicator();
        if (state.isFailure) return _buildErrorWidget(isEmpty: false);
        if (state.paymentMethods.isEmpty)
          return _buildErrorWidget(isEmpty: true);
        return Column(
          children: [
            showWallet
                ? _buildWalletPaymentMethod(
                    context,
                    state.paymentMethods
                        .firstWhere((e) => e.type == PaymentMethodType.wallet))
                : Container(),
            if (!(widget.shouldHideOtherPaymentMethodsIfWalletSelected &&
                isWalletSelected))
              ...state.paymentMethods.map((e) {
                if (showonlycard) {
                  return e.type == PaymentMethodType.creditCard
                      ? _buildPaymentMethod(e, context)
                      : Container();
                } else {
                  return _buildPaymentMethod(e, context);
                }
              }),
          ],
        );
      },
    );
  }

  Text _buildErrorWidget({required bool isEmpty}) {
    final String englishMessage = isEmpty
        ? 'No payment methods available'
        : 'Failed to load payment methods';
    final String arabicMessage = isEmpty
        ? 'No payment methods available'
        : 'Failed to load payment methods';
    return Text(
      LanguageClass.isEnglish ? englishMessage : arabicMessage,
      style: fontStyle(
        color: Colors.black,
        fontSize: 21,
        fontFamily: FontFamily.medium,
      ),
    );
  }

  Widget _buildPaymentMethod(PaymentMethod method, BuildContext context) {
    final isWallet = method.type == PaymentMethodType.wallet;
    if (isWallet) return Container();
    return InkWell(
      onTap: () => onPaymentMethodPressed(method, context),
      child: Row(
        children: [
          Image.network(
            method.image,
            height: 60,
            width: 60,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            width: 14,
          ),
          Text(
            method.name,
            style: fontStyle(
                color: Colors.black,
                fontSize: 21,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.medium),
          )
        ],
      ),
    );
  }

  Widget _buildWalletPaymentMethod(
      BuildContext context, PaymentMethod paymentMethod) {
    log(paymentMethod.image);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          InkWell(
            onTap: widget.onWalletPaymentPressed != null
                ? () => widget.onWalletPaymentPressed!(context)
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: AppColors.umragold,
                        borderRadius: BorderRadius.circular(4)),
                    child: SvgPicture.asset("assets/images/wallet.svg")

                    //Image.network(paymentMethod.image),
                    ),
                SizedBox(
                  width: 14,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paymentMethod.name,
                      style: fontStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontFamily.medium),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${widget.walletBalance} ${Routes.curruncy ?? ""}',
                        style: fontStyle(
                            color: AppColors.primaryColor,
                            fontSize: 12.sp,
                            fontFamily: FontFamily.medium),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.walletBalance != null) ...[
            Spacer(),
            InkWell(
              onTap: widget.onWalletPaymentPressed != null
                  ? () => widget.onWalletPaymentPressed!(context)
                  : null,
              child: Container(
                width: 56.sp,
                height: 40.sp,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColors.primaryColor, width: 2)),
                child: Text(
                  LanguageClass.isEnglish ? 'Pay' : 'دفع',
                  style: fontStyle(
                      color: AppColors.white,
                      fontSize: 16.sp,
                      fontFamily: FontFamily.medium),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildSelectPaymentMethodText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LanguageClass.isEnglish ? "Select Payment Method" : "حدد طريقة الدفع",
          style: fontStyle(
              fontSize: 24.sp,
              fontFamily: FontFamily.bold,
              fontWeight: FontWeight.w500),
        ),
        20.verticalSpace,
        widget.hasWalletPayment &&
                widget.shouldHideOtherPaymentMethodsIfWalletSelected
            ? _buildWalletSwitch()
            : Container(),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Directionality(
      textDirection:
          LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Container(
        child: widget.hasTimer
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => widget.onBackPressed(context),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Routes.isomra
                          ? AppColors.umragold
                          : AppColors.primaryColor,
                      size: 35,
                    ),
                  ),
                  Timerwidget()
                ],
              )
            : InkWell(
                onTap: () => widget.onBackPressed(context),
                child: Icon(
                  LanguageClass.isEnglish
                      ? Icons.arrow_back_rounded
                      : Icons.arrow_forward,
                  size: 34,
                  color: Routes.isomra
                      ? AppColors.umragold
                      : AppColors.primaryColor,
                ),
              ),
      ),
    );
  }

  Widget _buildWalletSwitch() {
    return Row(
      children: [
        Text(
          LanguageClass.isEnglish ? "Wallet deduction" : "خصم من المحفظة",
          style: fontStyle(
              color: Colors.black, fontSize: 21, fontFamily: FontFamily.medium),
        ),
        const Spacer(),
        CupertinoSwitch(
          value: _walletSwitchOn,
          onChanged: (value) {
            setState(() {
              _walletSwitchOn = value;
            });
          },
        ),
      ],
    );
  }

  onPaymentMethodPressed(PaymentMethod paymentMethod, BuildContext context) {
    final isVisa = paymentMethod.type == PaymentMethodType.creditCard &&
        widget.onVisaPaymentPressed != null;
    final isFawry = paymentMethod.type == PaymentMethodType.fawry &&
        widget.onFawryPressed != null;
    final isElectronicWallet =
        paymentMethod.type == PaymentMethodType.electronicWallet &&
            widget.onElectronicWalletPressed != null;

    if (isVisa) return widget.onVisaPaymentPressed!(context);
    if (isFawry) return widget.onFawryPressed!(context);
    if (isElectronicWallet) return widget.onElectronicWalletPressed!(context);
  }
}
