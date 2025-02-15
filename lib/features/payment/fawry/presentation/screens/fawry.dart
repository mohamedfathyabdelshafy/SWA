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
import 'package:swa/features/payment/fawry/domain/use_cases/fawry_use_case.dart';
import 'package:swa/features/payment/fawry/presentation/cubit/fawry_cubit.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_states_my_wallet.dart';

class FawryScreen extends StatefulWidget {
  FawryScreen({
    super.key,
  });

  @override
  State<FawryScreen> createState() => _FawryScreenState();
}

class _FawryScreenState extends State<FawryScreen> {
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
    double sizeHeight = context.height;
    double sizeWidth = context.width;

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
                                    inputFormatters: [NumericTextFormatter()],
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
                                      if (value!.isEmpty) {
                                        return LanguageClass.isEnglish
                                            ? 'This Field is Required'
                                            : "هذا مطلوب";
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
                            bloc: BlocProvider.of<ReservationCubit>(context),
                            listener: (context, state) {
                              if (state is LoadingElectronicWalletState) {
                                Constants.showLoadingDialog(context);
                              } else if (state is LoadedElectronicWalletState) {
                                Constants.hideLoadingDialog(context);
                                // Constants.showDefaultSnackBar(context: context, text: state.reservationResponseElectronicModel.message!.statusDescription!);
                                Constants.showDoneConfirmationDialog(context,
                                    isError: false, callback: () {
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
                                            Text(
                                              amountController.text.toString(),
                                              style: fontStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily: FontFamily.medium,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              LanguageClass.isEnglish
                                                  ? 'Reference Number: '
                                                  : ': رقم المرجعي',
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
                                                                  .reservationResponseElectronicModel
                                                                  .message!
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
                                                          .reservationResponseElectronicModel
                                                          .message!
                                                          .referenceNumber
                                                          .toString(),
                                                      textAlign: TextAlign.end,
                                                      style: fontStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
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
                                        .text!);
                              } else if (state is ErrorElectronicWalletState) {
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
                                  double amount =
                                      double.parse(amountController.text);

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
                                      ? "Chargee"
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
                // }
                //)
              ],
            ),
          ),
        ),
      ),
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
      if (newValue.text.length > 2) {
        value = value.replaceAll(RegExp(r'\D'), '');
        value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
        print("Value ---- $value");
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
