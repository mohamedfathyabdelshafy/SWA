import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/payment/electronic_wallet/domain/use_cases/ewallet_use_case.dart';
import 'package:swa/features/payment/electronic_wallet/presentation/cubit/eWallet_cubit.dart';
import 'package:swa/features/payment/fawry/presentation/screens/fawry.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';

class AddWalletBalanceWithElectronicWalletScreen extends StatefulWidget {
  const AddWalletBalanceWithElectronicWalletScreen({super.key});

  @override
  State<AddWalletBalanceWithElectronicWalletScreen> createState() =>
      _AddWalletBalanceWithElectronicWalletScreenState();
}

class _AddWalletBalanceWithElectronicWalletScreenState
    extends State<AddWalletBalanceWithElectronicWalletScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  User? _user;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      BlocProvider.of<LoginCubit>(context).getUserData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Changed build to override
    double sizeHeight = context.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
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
                  //margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    LanguageClass.isEnglish
                        ? 'Electronic wallet'
                        : 'محفظة الاكترونية',
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

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: BlocListener<LoginCubit, LoginState>(
                    // Listen to LoginCubit
                    listener: (context, state) {
                      if (state is UserLoginLoadedState) {
                        _user = state.userResponse.user;
                      }
                    },
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 1,
                                decoration: const BoxDecoration(
                                    color: Color(0xff47A9EB)),
                              ),
                              Expanded(
                                child: Container(
                                  height: 70,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 18),
                                  decoration: const BoxDecoration(),
                                  child: TextFormField(
                                    maxLength: 11,
                                    autofocus: true,
                                    style: fontStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16),
                                    cursorColor: AppColors.blue,
                                    controller: phoneController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9]"))
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      counter: SizedBox.shrink(),
                                      hintText: LanguageClass.isEnglish
                                          ? 'Phone Number'
                                          : 'رقم التليفون',
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
                                      return value!.isEmpty
                                          ? LanguageClass.isEnglish
                                              ? 'This Field is Required'
                                              : 'هذا مطلوب'
                                          : value.length < 11
                                              ? LanguageClass.isEnglish
                                                  ? 'Phone Number must be 11 digits'
                                                  : 'رقم التليفون يجب ان يكون 11 رقم'
                                              : null;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              ValueListenableBuilder<TextEditingValue>(
                                valueListenable: phoneController,
                                builder: (context, value, child) {
                                  final digitsOnly = value.text
                                      .replaceAll(RegExp(r'[^0-9]'), '');
                                  return Text(
                                    "${digitsOnly.length}/11", // Display digits entered vs max length
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 20,
                                width: 1,
                                decoration: const BoxDecoration(
                                    color: Color(0xffD865A4)),
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 18),
                                  decoration: const BoxDecoration(
                                      // border: Border.all(
                                      //   color: AppColors.blue,
                                      //   width: 0.3,
                                      // ),
                                      // borderRadius:
                                      // const BorderRadius.all(Radius.circular(10))
                                      ),
                                  child: TextFormField(
                                    autofocus: true,
                                    style: fontStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16),
                                    cursorColor: AppColors.blue,
                                    controller: amountController,
                                    inputFormatters: [
                                      NumericTextFormatter(), // Assuming NumericTextFormatter is defined elsewhere or imported
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9,]')),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Amount',
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
                                      } else if (isNAN < 9) {
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
                          BlocListener<EWalletCubit, EWalletState>(
                            // Listen to EWalletCubit
                            listener: (context, state) {
                              if (state is EWalletLoadingState) {
                                Constants.showLoadingDialog(context);
                              } else if (state is EWalletLoadedState) {
                                Constants.hideLoadingDialog(context);

                                showDoneConfirmationDialog(
                                  context,
                                  isError: false,
                                  callback: () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (context.mounted) {
                                        // You might want to navigate or update UI here
                                      }
                                    });
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
                                                        .paymentMessageResponse
                                                        .paymentMessage!
                                                        .referenceNumber
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
                                                                .paymentMessageResponse
                                                                .paymentMessage!
                                                                .referenceNumber
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
                                  message: state.paymentMessageResponse.text!
                                      .toString(),
                                );
                              } else if (state is EWalletErrorState) {
                                Constants.hideLoadingDialog(context);
                                Constants.showDefaultSnackBar(
                                    context: context,
                                    text: state.error.toString());
                              } else if (state is EWalletConfirmationState) {
                                Constants.hideLoadingDialog(context);
                                showDoneConfirmationDialog(
                                  context,
                                  isError:
                                      false, // Or set to true if it's a negative confirmation
                                  message: state.message,
                                  callback: () {
                                    // Handle confirmation action, e.g., navigate or refresh
                                    Navigator.pop(context); // Close the dialog
                                  },
                                );
                              } else if (state is EWalletWarningState) {
                                Constants.hideLoadingDialog(context);
                                showDoneConfirmationDialog(
                                  context,
                                  isError:
                                      true, // Warnings are usually treated as errors for display
                                  message: state.message,
                                  callback: () {
                                    // Handle warning action
                                    Navigator.pop(context);
                                  },
                                );
                              } else if (state is EWalletImageState) {
                                Constants.hideLoadingDialog(context);
                                _showImageDialog(context, state.message);
                              } else if (state is EWalletImageWithGiftState) {
                                Constants.hideLoadingDialog(context);
                                // You might want a different dialog for gift images
                                _showImageDialog(context, state.message,
                                    hasGift: true);
                              }
                            },
                            child: InkWell(
                              onTap: () {
                                if (_user != null &&
                                    formKey.currentState!.validate()) {
                                  BlocProvider.of<EWalletCubit>(context)
                                      .eWalletPaymentFunction(EWalletParams(
                                    customerId: _user!.customerId.toString(),
                                    amount: amountController.text
                                        .replaceAll(",", ""),
                                    mobileNumber: phoneController.text,
                                  ));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                ),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                //})
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
        title:
            isError ? 'error' : '', // Title is set to 'error' for isError=true
        lottieAsset:
            isError ? 'assets/json/error.json' : 'assets/json/Warning.json',
        type: CoolAlertType.custom,
        loopAnimation: false,
        backgroundColor: isError
            ? Colors.red
            : Colors.white, // Background color also changes
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
                    ? "E-Wallet Transaction Details"
                    : "تفاصيل معاملة المحفظة الإلكترونية",
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

// Ensure NumericTextFormatter is defined or imported if it's not part of the provided snippets.
// For example:
class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // This is a simple example. You might want more sophisticated logic
    // for formatting numbers with commas based on locale.
    final text = newValue.text.replaceAll(',', '');
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    try {
      final num = double.parse(text);
      final formatter =
          intl.NumberFormat('#,##0.##'); // Adjust format as needed
      final newText = formatter.format(num);
      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    } catch (e) {
      return oldValue; // Revert to old value if parsing fails
    }
  }
}

// Make sure to import intl for NumberFormat:
// import 'package:intl/intl.dart';
