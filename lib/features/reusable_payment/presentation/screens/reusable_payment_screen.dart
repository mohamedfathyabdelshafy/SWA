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
  final String? totalAmount;
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
    this.totalAmount,
  });

  @override
  State<ReusablePaymentMethodSelectionScreen> createState() =>
      _ReusablePaymentMethodSelectionScreenState();
}

// class _ReusablePaymentMethodSelectionScreenState
//     extends State<ReusablePaymentMethodSelectionScreen> {
//   bool _walletSwitchOn = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return
//         // Scaffold(
//         // backgroundColor: Colors.white,
//         // body:
//         Directionality(
//       textDirection:
//           LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Column(
//             crossAxisAlignment: LanguageClass.isEnglish
//                 ? CrossAxisAlignment.start
//                 : CrossAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // 50.verticalSpace,
//               // _buildAppBar(context),
//               // 30.verticalSpace,
//               _buildSelectPaymentMethodText(),
//               50.verticalSpace,
//               _buildPaymentMethods()
//             ]),
//       ),
//     );
//     // bottomNavigationBar: Navigationbottombar(
//     //   currentIndex: 0,
//     // ),
//     // );
//   }
//
// // Widgets
//   Widget _buildPaymentMethods() {
//     final bool isWalletSelected =
//         widget.shouldHideOtherPaymentMethodsIfWalletSelected &&
//             widget.hasWalletPayment &&
//             _walletSwitchOn;
//
//     final bool showWallet = widget.shouldHideOtherPaymentMethodsIfWalletSelected
//         ? isWalletSelected
//         : widget.hasWalletPayment;
//
//     final bool showonlycard = widget.countryid == '3';
//
//     return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
//       builder: (context, state) {
//         if (state.isLoading) return CircularProgressIndicator();
//         if (state.isFailure) return _buildErrorWidget(isEmpty: false);
//         if (state.paymentMethods.isEmpty)
//           return _buildErrorWidget(isEmpty: true);
//         return Column(
//           children: [
//             showWallet
//                 ? _buildWalletPaymentMethod(
//                     context,
//                     state.paymentMethods
//                         .firstWhere((e) => e.type == PaymentMethodType.wallet))
//                 : Container(),
//             if (!(widget.shouldHideOtherPaymentMethodsIfWalletSelected &&
//                 isWalletSelected))
//               ...state.paymentMethods.map((e) {
//                 if (showonlycard) {
//                   return e.type == PaymentMethodType.creditCard
//                       ? _buildPaymentMethod(e, context)
//                       : Container();
//                 } else {
//                   return _buildPaymentMethod(e, context);
//                 }
//               }),
//           ],
//         );
//       },
//     );
//     // return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
//     //   builder: (context, state) {
//     //     if (state.isLoading) return CircularProgressIndicator();
//     //     if (state.isFailure) return _buildErrorWidget(isEmpty: false);
//     //     if (state.paymentMethods.isEmpty)
//     //       return _buildErrorWidget(isEmpty: true);
//     //
//     //     final List<Widget> paymentMethodWidgets = [];
//     //
//     //     if (showWallet) {
//     //       final walletMethod = state.paymentMethods
//     //           .firstWhere((e) => e.type == PaymentMethodType.wallet);
//     //       paymentMethodWidgets
//     //           .add(_buildWalletPaymentMethod(context, walletMethod));
//     //     }
//     //
//     //     if (!(widget.shouldHideOtherPaymentMethodsIfWalletSelected &&
//     //         isWalletSelected)) {
//     //       for (var method in state.paymentMethods) {
//     //         if (showonlycard) {
//     //           if (method.type == PaymentMethodType.creditCard) {
//     //             paymentMethodWidgets.add(_buildPaymentMethod(method, context));
//     //           }
//     //         } else {
//     //           if (method.type != PaymentMethodType.wallet) {
//     //             // paymentMethodWidgets.add(_buildPaymentMethod(method, context));
//     //           }
//     //         }
//     //       }
//     //     }
//     //
//     //     return GridView.count(
//     //       shrinkWrap: true,
//     //       physics: NeverScrollableScrollPhysics(),
//     //       crossAxisCount: 2,
//     //       childAspectRatio: 1,
//     //       mainAxisSpacing: 10,
//     //       crossAxisSpacing: 12,
//     //       padding: EdgeInsets.all(0),
//     //       children: paymentMethodWidgets,
//     //     );
//     //   },
//     // );
//   }
//
//   Text _buildErrorWidget({required bool isEmpty}) {
//     final String englishMessage = isEmpty
//         ? 'No payment methods available'
//         : 'Failed to load payment methods';
//     final String arabicMessage = isEmpty
//         ? 'No payment methods available'
//         : 'Failed to load payment methods';
//     return Text(
//       LanguageClass.isEnglish ? englishMessage : arabicMessage,
//       style: fontStyle(
//         color: Colors.black,
//         fontSize: 21,
//         fontFamily: FontFamily.medium,
//       ),
//     );
//   }
//
//   Widget _buildPaymentMethod(PaymentMethod method, BuildContext context) {
//     final isWallet = method.type == PaymentMethodType.wallet;
//     if (isWallet) return Container();
//     return InkWell(
//       onTap: () => onPaymentMethodPressed(method, context),
//       child: Card(
//         elevation: 0.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         color: Colors.white,
//         child: Column(
//           spacing: 10,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // SizedBox(
//             //   height: 5,
//             // ),
//             Image.network(
//               method.image,
//               height: 40,
//               width: 40,
//               fit: BoxFit.fitWidth,
//             ),
//             Text(
//               method.name,
//               style: fontStyle(
//                   color: Colors.black,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   fontFamily: FontFamily.medium),
//             ),
//             // SizedBox(
//             //   height: 5,
//             // )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildWalletPaymentMethod(
//       BuildContext context, PaymentMethod paymentMethod) {
//     log(paymentMethod.image);
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           InkWell(
//             onTap: widget.onWalletPaymentPressed != null
//                 ? () => widget.onWalletPaymentPressed!(context)
//                 : null,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                     width: 30,
//                     height: 30,
//                     alignment: Alignment.center,
//                     padding: EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                         color: AppColors.umragold,
//                         borderRadius: BorderRadius.circular(4)),
//                     child: SvgPicture.asset("assets/images/wallet.svg")
//
//                     //Image.network(paymentMethod.image),
//                     ),
//                 SizedBox(
//                   width: 14,
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       paymentMethod.name,
//                       style: fontStyle(
//                           color: Colors.black,
//                           fontSize: 21,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: FontFamily.medium),
//                     ),
//                     FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Text(
//                         '${widget.walletBalance} ${Routes.curruncy ?? ""}',
//                         style: fontStyle(
//                             color: AppColors.primaryColor,
//                             fontSize: 12.sp,
//                             fontFamily: FontFamily.medium),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           if (widget.walletBalance != null) ...[
//             Spacer(),
//             InkWell(
//               onTap: widget.onWalletPaymentPressed != null
//                   ? () => widget.onWalletPaymentPressed!(context)
//                   : null,
//               child: Container(
//                 width: 56.sp,
//                 height: 40.sp,
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                     color: AppColors.primaryColor,
//                     borderRadius: BorderRadius.circular(8),
//                     border:
//                         Border.all(color: AppColors.primaryColor, width: 2)),
//                 child: Text(
//                   LanguageClass.isEnglish ? 'Pay' : 'دفع',
//                   style: fontStyle(
//                       color: AppColors.white,
//                       fontSize: 16.sp,
//                       fontFamily: FontFamily.medium),
//                 ),
//               ),
//             )
//           ]
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSelectPaymentMethodText() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           LanguageClass.isEnglish
//               ? "Choose payment method"
//               : "اختر طريقة الدفع",
//           style: fontStyle(
//               fontSize: 12.sp,
//               fontFamily: FontFamily.medium,
//               fontWeight: FontWeight.w500),
//         ),
//         20.verticalSpace,
//         widget.hasWalletPayment &&
//                 widget.shouldHideOtherPaymentMethodsIfWalletSelected
//             ? _buildWalletSwitch()
//             : Container(),
//       ],
//     );
//   }
//
//   Widget _buildAppBar(BuildContext context) {
//     return Directionality(
//       textDirection:
//           LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
//       child: Container(
//         child: widget.hasTimer
//             ? Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   InkWell(
//                     onTap: () => widget.onBackPressed(context),
//                     child: Icon(
//                       Icons.arrow_back_rounded,
//                       color: Routes.isomra
//                           ? AppColors.umragold
//                           : AppColors.primaryColor,
//                       size: 35,
//                     ),
//                   ),
//                   Timerwidget()
//                 ],
//               )
//             : InkWell(
//                 onTap: () => widget.onBackPressed(context),
//                 child: Icon(
//                   LanguageClass.isEnglish
//                       ? Icons.arrow_back_rounded
//                       : Icons.arrow_forward,
//                   size: 34,
//                   color: Routes.isomra
//                       ? AppColors.umragold
//                       : AppColors.primaryColor,
//                 ),
//               ),
//       ),
//     );
//   }
//
//   Widget _buildWalletSwitch() {
//     return Row(
//       children: [
//         Text(
//           LanguageClass.isEnglish ? "Wallet deduction" : "خصم من المحفظة",
//           style: fontStyle(
//               color: Colors.black, fontSize: 21, fontFamily: FontFamily.medium),
//         ),
//         const Spacer(),
//         CupertinoSwitch(
//           value: _walletSwitchOn,
//           onChanged: (value) {
//             setState(() {
//               _walletSwitchOn = value;
//             });
//           },
//         ),
//       ],
//     );
//   }
//
//   onPaymentMethodPressed(PaymentMethod paymentMethod, BuildContext context) {
//     final isVisa = paymentMethod.type == PaymentMethodType.creditCard &&
//         widget.onVisaPaymentPressed != null;
//     final isFawry = paymentMethod.type == PaymentMethodType.fawry &&
//         widget.onFawryPressed != null;
//     final isElectronicWallet =
//         paymentMethod.type == PaymentMethodType.electronicWallet &&
//             widget.onElectronicWalletPressed != null;
//
//     if (isVisa) return widget.onVisaPaymentPressed!(context);
//     if (isFawry) return widget.onFawryPressed!(context);
//     if (isElectronicWallet) return widget.onElectronicWalletPressed!(context);
//   }
// }
class _ReusablePaymentMethodSelectionScreenState
    extends State<ReusablePaymentMethodSelectionScreen> {
  bool _showWalletDetails = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Column(
          // crossAxisAlignment: LanguageClass.isEnglish
          //     ? CrossAxisAlignment.start
          //     : CrossAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSelectPaymentMethodText(),
            10.verticalSpace,
            _buildPaymentMethods(),
            if (_showWalletDetails && widget.hasWalletPayment) ...[
              10.verticalSpace,
              _buildWalletDetailsSection(totalAmount: widget.totalAmount),
            ] else ...[
              10.verticalSpace,
            ]
          ]),
    );
  }

  Widget _buildPaymentMethods() {
    final bool showonlycard = widget.countryid == '3';

    return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
      builder: (context, state) {
        if (state.isLoading) return CircularProgressIndicator();
        if (state.isFailure) return _buildErrorWidget(isEmpty: false);
        if (state.paymentMethods.isEmpty) {
          return _buildErrorWidget(isEmpty: true);
        }

        final List<Widget> paymentMethodWidgets = [];

        if (widget.hasWalletPayment) {
          try {
            final walletMethod = state.paymentMethods
                .firstWhere((e) => e.type == PaymentMethodType.wallet);
            paymentMethodWidgets.add(
              _buildWalletPaymentMethodCard(context, walletMethod),
            );
          } catch (e) {
            log(e.toString());
          }
        }

        for (var method in state.paymentMethods) {
          if (method.type == PaymentMethodType.wallet) continue;

          if (showonlycard) {
            if (method.type == PaymentMethodType.creditCard) {
              paymentMethodWidgets.add(_buildPaymentMethod(method, context));
            }
          } else {
            paymentMethodWidgets.add(_buildPaymentMethod(method, context));
          }
        }

        return GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.8,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          padding: EdgeInsets.zero,
          children: paymentMethodWidgets,
        );
      },
    );
  }

  Widget _buildWalletPaymentMethodCard(
      BuildContext context, PaymentMethod method) {
    return InkWell(
      onTap: () {
        setState(() {
          _showWalletDetails = !_showWalletDetails;
        });
      },
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: _showWalletDetails
              ? BorderSide(color: Color(0xffC6E0B0), width: 2)
              : BorderSide.none,
        ),
        color: _showWalletDetails ? Color(0xffEFFFE2) : Colors.white,
        // margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 15,
          children: [
            SvgPicture.asset(
              "assets/images/wallet.svg",
              color: Colors.black,
              height: 20,
              width: 20,
            ),
            Text(
              method.name,
              style: fontStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletDetailsSection({String? totalAmount}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Container(
              //       width: 50,
              //       height: 50,
              //       alignment: Alignment.center,
              //       padding: EdgeInsets.all(10),
              //       decoration: BoxDecoration(
              //         color: AppColors.umragold.withOpacity(0.2),
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       child: SvgPicture.asset("assets/images/wallet.svg"),
              //     ),
              //     SizedBox(width: 14),
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             LanguageClass.isEnglish
              //                 ? 'Wallet Balance'
              //                 : 'رصيد المحفظة',
              //             style: fontStyle(
              //               color: Colors.black,
              //               fontSize: 18,
              //               fontWeight: FontWeight.w600,
              //               fontFamily: FontFamily.medium,
              //             ),
              //           ),
              //           SizedBox(height: 4),
              //           Text(
              //             '${widget.walletBalance ?? 0} ${Routes.curruncy ?? "SAR"}',
              //             style: fontStyle(
              //               color: AppColors.primaryColor,
              //               fontSize: 14,
              //               fontWeight: FontWeight.w500,
              //               fontFamily: FontFamily.medium,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LanguageClass.isEnglish ? 'Current Balance' : 'رصيد الحالي',
                    textAlign: TextAlign.center,
                    style: fontStyle(
                      color: Colors.black,
                      fontFamily: FontFamily.regular,
                      fontSize: 12,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    '${widget.walletBalance ?? 0} ${Routes.curruncy ?? "SAR"}',
                    textAlign: TextAlign.center,
                    style: fontStyle(
                      color: Color(0xff24C61E),
                      fontFamily: FontFamily.medium,
                      fontSize: 12,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LanguageClass.isEnglish
                        ? 'Required amount'
                        : 'المبلغ المطلوب',
                    textAlign: TextAlign.center,
                    style: fontStyle(
                      color: Colors.red,
                      fontFamily: FontFamily.regular,
                      fontSize: 12,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    '${totalAmount ?? 0}',
                    // '${widget.walletBalance ?? 0} ${Routes.curruncy ?? "SAR"}',
                    textAlign: TextAlign.center,
                    style: fontStyle(
                      color: Color(0xffFF0000),
                      fontFamily: FontFamily.medium,
                      fontSize: 12,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LanguageClass.isEnglish
                        ? 'Remaining Balance'
                        : 'الرصيد المتبقي',
                    textAlign: TextAlign.center,
                    style: fontStyle(
                      color: Colors.black,
                      fontFamily: FontFamily.regular,
                      fontSize: 12,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    '${widget.walletBalance ?? 0} ${Routes.curruncy ?? "SAR"}',
                    textAlign: TextAlign.center,
                    style: fontStyle(
                      color: Colors.black,
                      fontFamily: FontFamily.medium,
                      fontSize: 12,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        InkWell(
          onTap: widget.onWalletPaymentPressed != null
              ? () => widget.onWalletPaymentPressed!(context)
              : null,
          child: Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(colors: [
                  Color(0xFFFE5D4B),
                  Color(0xFFFFA57E),
                ])),
            child: Text(
              LanguageClass.isEnglish ? 'Pay $totalAmount' : 'دفع $totalAmount',
              style: fontStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.medium,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPaymentMethod(PaymentMethod method, BuildContext context) {
    return InkWell(
      onTap: () => onPaymentMethodPressed(method, context),
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              method.image,
              height: 35,
              width: 35,
              fit: BoxFit.fitWidth,
            ),
            Text(
              method.name,
              style: fontStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectPaymentMethodText() {
    return Text(
      LanguageClass.isEnglish ? "Choose payment method" : "اختر طريقة الدفع",
      style: fontStyle(
        fontSize: 12.sp,
        fontFamily: FontFamily.medium,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Text _buildErrorWidget({required bool isEmpty}) {
    final String englishMessage = isEmpty
        ? 'No payment methods available'
        : 'Failed to load payment methods';
    final String arabicMessage =
        isEmpty ? 'لا توجد طرق دفع متاحة' : 'فشل تحميل طرق الدفع';
    return Text(
      LanguageClass.isEnglish ? englishMessage : arabicMessage,
      style: fontStyle(
        color: Colors.black,
        fontSize: 21,
        fontFamily: FontFamily.medium,
      ),
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
