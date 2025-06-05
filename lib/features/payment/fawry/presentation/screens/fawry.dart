import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_states_my_wallet.dart';
import 'package:intl/intl.dart' as intl; // Import for NumericTextFormatter

class WalletFawryScreen extends StatefulWidget {
  WalletFawryScreen({
    super.key,
  });

  @override
  State<WalletFawryScreen> createState() => _WalletFawryScreenState();
}

class _WalletFawryScreenState extends State<WalletFawryScreen> {
  final formKey = GlobalKey<FormState>();
  User? _user;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      BlocProvider.of<LoginCubit>(context).getUserData();
    });
    super.initState();
  }

  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(
        "FAWRY 1"); // This print statement will always execute when build is called
    double sizeHeight = context.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SizedBox(
            height: sizeHeight * 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: Routes.isomra
                          ? AppColors.umragold
                          : AppColors.primaryColor,
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
                    LanguageClass.isEnglish ? 'Fawry' : 'فوري',
                    style: fontStyle(
                        color: AppColors.blackColor,
                        fontSize: 38,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.medium),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.01,
                ),
                Expanded(
                  child: BlocListener<LoginCubit, LoginState>(
                    // Added type to BlocListener for clarity
                    listener: (context, state) {
                      if (state is UserLoginLoadedState) {
                        _user = state.userResponse.user;
                      }
                    },
                    child: Form(
                      key: formKey,
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          //Text(""),
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 1,
                                decoration: const BoxDecoration(
                                    color: Color(0xff47A9EB)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  //    padding:
                                  //    const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                                  decoration: const BoxDecoration(
                                      // color: Colors.red
                                      // border: Border.all(
                                      //   color: AppColors.blue,
                                      //   width: 0.3,
                                      // ),

                                      ),
                                  child: TextFormField(
                                    autofocus: true,
                                    style: fontStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16),
                                    cursorColor: AppColors.blue,
                                    controller: amountController,
                                    inputFormatters: [
                                      NumericTextFormatter(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9,]')),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: LanguageClass.isEnglish
                                          ? 'Amount'
                                          : "القيمة",
                                      errorStyle: fontStyle(
                                        color: Colors.red,
                                        fontSize: 11,
                                      ),
                                      hintStyle: fontStyle(
                                          color: AppColors.greyLight,
                                          fontSize: 15,
                                          fontFamily: FontFamily.bold),
                                      labelStyle: fontStyle(
                                          color: AppColors.grey,
                                          fontSize: 12,
                                          fontFamily: FontFamily.bold),
                                    ),
                                    validator: (value) {
                                      //check if only numbers or ","
                                      value = value?.replaceAll(',', '');
                                      final isNAN =
                                          double.tryParse(value ?? '');
                                      if (isNAN == null || isNAN == 0) {
                                        return LanguageClass.isEnglish
                                            ? 'Invalid Amount'
                                            : "من فضلك ادخل قيمة صحيحة";
                                      } else if (isNAN < 10) {
                                        return LanguageClass.isEnglish
                                            ? 'اقل قيمة للشحن 10 جنيهات'
                                            : 'The least amount for charge is 10 EGP';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 50,
                          ),
                          BlocListener<ReservationCubit, ReservationStates>(
                            // Added type to BlocListener for clarity
                            listener: (context, state) {
                              if (state is LoadingElectronicWalletState) {
                                Constants.showLoadingDialog(context);
                              } else if (state is LoadedElectronicWalletState) {
                                Constants.hideLoadingDialog(context);
                                // The success state for fawrycharge has message and referenceNumber
                                showDoneConfirmationDialog(
                                  context,
                                  isError: false,
                                  callback: () {
                                    Navigator.pop(context); // Pop dialog
                                    Navigator.pop(context); // Pop Fawry screen
                                  },
                                  body: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            LanguageClass.isEnglish
                                                ? 'Amount: '
                                                : "القيمة",
                                            style: fontStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: FontFamily.medium,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(amountController.text.toString())
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Reference Number: ',
                                            style: fontStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: FontFamily.medium,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    state
                                                        .reservationResponseElectronicModel
                                                        .message!
                                                        .referenceNumber // Access referenceNumber from message
                                                        .toString(),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    Constants.showDefaultSnackBar(
                                                        context: context,
                                                        color: Colors.green,
                                                        text:
                                                            'Reference Number copied');
                                                    await Clipboard.setData(
                                                        ClipboardData(
                                                            text: state
                                                                .reservationResponseElectronicModel
                                                                .message!
                                                                .referenceNumber // Access referenceNumber from message
                                                                .toString()));
                                                  },
                                                  child: Container(
                                                      width: 15,
                                                      height: 15,
                                                      child: Icon(
                                                        Icons.copy_outlined,
                                                        size: 14,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  message: state
                                      .reservationResponseElectronicModel
                                      .text!, // 'text' field should be the main message
                                );
                              } else if (state is ErrorElectronicWalletState) {
                                Constants.hideLoadingDialog(context);
                                Constants.showDefaultSnackBar(
                                    context: context,
                                    text: state.error.toString());
                              } else if (state
                                  is ConfirmationElectronicWalletState) {
                                Constants.hideLoadingDialog(context);
                                showDoneConfirmationDialog(
                                  context,
                                  isError:
                                      false, // Usually confirmation is not an error
                                  message: state.message,
                                  callback: () {
                                    Navigator.pop(context); // Close dialog
                                  },
                                );
                              } else if (state
                                  is WarningElectronicWalletState) {
                                Constants.hideLoadingDialog(context);
                                showDoneConfirmationDialog(
                                  context,
                                  isError:
                                      true, // Warnings are often treated as errors for user alerts
                                  message: state.message,
                                  callback: () {
                                    Navigator.pop(context); // Close dialog
                                  },
                                );
                              } else if (state is ImageElectronicWalletState) {
                                Constants.hideLoadingDialog(context);
                                _showImageDialog(context,
                                    state.message); // Call helper for image
                              } else if (state
                                  is ImageWithGiftElectronicWalletState) {
                                Constants.hideLoadingDialog(context);
                                _showImageDialog(context, state.message,
                                    hasGift:
                                        true); // Call helper for image with gift
                              }
                            },
                            child: InkWell(
                              onTap: () {
                                if (_user != null &&
                                    formKey.currentState!.validate()) {
                                  double amount = double.parse(amountController
                                      .text
                                      .replaceAll(',', ''));

                                  BlocProvider.of<ReservationCubit>(context)
                                      .fawrycharge(
                                          customerid: _user!.customerId!,
                                          amount: amount
                                              .toStringAsFixed(2)
                                              .toString());
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Constants.customButton(
                                  borderradias: 41,
                                  text: LanguageClass.isEnglish
                                      ? "Charge"
                                      : "شحن",
                                  color: Routes.isomra
                                      ? AppColors.umragold
                                      : AppColors.primaryColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDoneConfirmationDialog(BuildContext context,
      {required String message,
      bool isError = false,
      Widget? body,
      required Function callback}) async {
    return CoolAlert.show(
        barrierDismissible: true,
        context: context,
        confirmBtnText: "ok",
        title: isError ? 'error' : '',
        lottieAsset:
            isError ? 'assets/json/error.json' : 'assets/json/Warning.json',
        type: CoolAlertType.custom,
        loopAnimation: false,
        backgroundColor: isError ? Colors.red : Colors.white,
        text: message,
        widget: body,
        onConfirmBtnTap: () {
          callback();
        });
  }

  // Helper method to show image dialog
  void _showImageDialog(BuildContext context, String imageUrlOrBase64,
      {bool hasGift = false}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Determine if it's a URL or Base64 string.
              // Assuming it's a network URL for now. If Base64, you'll need to decode.
              Image.network(
                imageUrlOrBase64,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                      Icons.error); // Fallback for image loading error
                },
              ),
              if (hasGift) // Optional: display text for gift
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      LanguageClass.isEnglish
                          ? "You received a gift!"
                          : "لقد تلقيت هدية!",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              const SizedBox(height: 16),
              Text(
                LanguageClass.isEnglish
                    ? "Fawry Transaction Details"
                    : "تفاصيل معاملة فوري",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(LanguageClass.isEnglish ? "Close" : "إغلاق"),
            ),
          ],
        );
      },
    );
  }
}

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      var value = newValue.text;
      // Remove all non-digit characters first to process
      value = value.replaceAll(RegExp(r'\D'), '');

      // Apply comma formatting if value length is greater than 3 (or as per your desired format)
      if (value.length > 3) {
        // Adjusted from >2 to >3, common for thousands separator
        final formatter = intl.NumberFormat(
            '#,##0'); // No decimals for integer part formatting
        try {
          value = formatter.format(int.parse(value));
        } catch (e) {
          // Fallback if parsing fails (e.g., during incomplete typing)
          return oldValue;
        }
      }
      return TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(
            offset: value.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
