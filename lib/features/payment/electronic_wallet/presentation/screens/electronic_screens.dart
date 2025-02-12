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
import 'package:swa/features/payment/electronic_wallet/domain/use_cases/ewallet_use_case.dart';
import 'package:swa/features/payment/electronic_wallet/presentation/cubit/eWallet_cubit.dart';
import 'package:swa/features/payment/fawry/presentation/screens/fawry.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';

class ElectronicScreen extends StatefulWidget {
  const ElectronicScreen({super.key});

  @override
  State<ElectronicScreen> createState() => _ElectronicScreenState();
}

class _ElectronicScreenState extends State<ElectronicScreen> {
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
                  child: BlocListener(
                    bloc: BlocProvider.of<LoginCubit>(context),
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
                                      vertical: 2, horizontal: 18),
                                  decoration: const BoxDecoration(
                                      //color: AppColors.yellow
                                      // border: Border.all(
                                      //   color: AppColors.blue,
                                      //   width: 0.3,
                                      // ),
                                      // borderRadius:
                                      // const BorderRadius.all(Radius.circular(10))
                                      ),
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
                                      if (value!.isEmpty) {
                                        return LanguageClass.isEnglish
                                            ? 'This Field is Required'
                                            : 'هذا مطلوب';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
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
                                    inputFormatters: [NumericTextFormatter()],
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
                                      if (value!.isEmpty) {
                                        return 'This Field is Required';
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
                          BlocListener(
                            bloc: BlocProvider.of<EWalletCubit>(context),
                            listener: (context, state) {
                              if (state is EWalletLoadingState) {
                                Constants.showLoadingDialog(context);
                              } else if (state is EWalletLoadedState) {
                                Constants.hideLoadingDialog(context);

                                // Constants.showDefaultSnackBar(context: context, text: state.reservationResponseElectronicModel.message!.statusDescription!);
                                showDoneConfirmationDialog(
                                  context,
                                  isError: false,
                                  callback: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, Routes.home, (route) => false,
                                        arguments: Routes.isomra);
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
                                                InkWell(
                                                  onTap: () async {
                                                    Constants.showDefaultSnackBar(
                                                        context: context,
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
                              }
                            },
                            child: InkWell(
                              onTap: () {
                                if (_user != null &&
                                    formKey.currentState!.validate()) {
                                  BlocProvider.of<EWalletCubit>(context)
                                      .eWalletPaymentFunction(EWalletParams(
                                    customerId: _user!.customerId.toString(),
                                    amount: amountController.text,
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
        title: isError ? 'error' : '',
        lottieAsset:
            isError ? 'assets/json/error.json' : 'assets/json/Warning.json',
        type: isError ? CoolAlertType.error : CoolAlertType.success,
        loopAnimation: false,
        backgroundColor: isError ? Colors.red : Colors.white,
        text: message,
        widget: body,
        onConfirmBtnTap: () {
          callback();
        });
  }
}
