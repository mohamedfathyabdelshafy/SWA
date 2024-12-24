import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';

class FawrypayScreen extends StatefulWidget {
  FawrypayScreen({
    super.key,
  });

  @override
  State<FawrypayScreen> createState() => _FawrypayScreenState();
}

class _FawrypayScreenState extends State<FawrypayScreen> {
  final formKey = GlobalKey<FormState>();
  final price = CacheHelper.getDataToSharedPref(key: 'price');
  PackagesBloc _packagesBloc = new PackagesBloc();

  @override
  void initState() {
    // Future.delayed(const Duration(seconds: 0)).then((_) async {
    //   BlocProvider.of<LoginCubit>(context).getUserData();
    // });
    super.initState();
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
        title: isError ? 'error' : 'success',
        lottieAsset:
            isError ? 'assets/json/error.json' : 'assets/json/done.json',
        type: isError ? CoolAlertType.error : CoolAlertType.success,
        loopAnimation: false,
        backgroundColor: isError ? Colors.red : Colors.white,
        text: message,
        widget: body,
        onConfirmBtnTap: () {
          callback();
        });
  }

  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
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
                      color: AppColors.primaryColor,
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
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 38,
                        fontWeight: FontWeight.w600,
                        fontFamily: "roman"),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.01,
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  // BlocListener(
                  //   bloc: BlocProvider.of<LoginCubit>(context),
                  //   listener: (context, state) {
                  //     if (state is UserLoginLoadedState) {
                  //       _user = state.userResponse.user;
                  //     }
                  //   },
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
                              decoration:
                                  const BoxDecoration(color: Color(0xff47A9EB)),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Container(

                                  //    padding:
                                  //    const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                                  decoration: const BoxDecoration(
                                      // color: Colors.red
                                      // border: Border.all(
                                      //   color: AppColors.blue,
                                      //   width: 0.3,
                                      // ),

                                      ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        LanguageClass.isEnglish
                                            ? "amount"
                                            : "القيمة",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "bold",
                                            color: AppColors.greyLight),
                                      ),
                                      Text(
                                        Routes.Amount.toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "bold",
                                            color: AppColors.primaryColor),
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        const Spacer(),
                        BlocListener(
                          bloc: _packagesBloc,
                          listener: (context, PackagesState state) {
                            if (state.isloading == true) {
                              Constants.showLoadingDialog(context);
                            } else if (state.reservationResponseElectronicModel
                                    ?.status ==
                                'success') {
                              Constants.hideLoadingDialog(context);
                              // Constants.showDefaultSnackBar(context: context, text: state.reservationResponseElectronicModel.message!.statusDescription!);
                              showDoneConfirmationDialog(context,
                                  isError: false, callback: () {
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
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(price.toString())
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Reference Number: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
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
                                                                .reservationResponseElectronicModel!
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
                                                        .reservationResponseElectronicModel!
                                                        .message!
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
                                  message:
                                      "You will get a notification by applying your wallet \n In order to agree to pay");
                            } else if (state.reservationResponseElectronicModel
                                    ?.status ==
                                'failed') {
                              Constants.hideLoadingDialog(context);
                              Constants.showDefaultSnackBar(
                                  context: context,
                                  text: state
                                      .reservationResponseElectronicModel!
                                      .errormessage!);
                            }
                          },
                          child: InkWell(
                            onTap: () {
                              // if(_user != null && formKey.currentState!.validate()) {
                              _packagesBloc.add(packagefawryEvent(
                                  Amount: Routes.Amount,
                                  FromStationID:
                                      int.parse(Routes.FromStationID!),
                                  PackageID: Routes.PackageID,
                                  PackagePriceID: Routes.PackageID,
                                  ToStationID: int.parse(Routes.ToStationID!),
                                  PaymentMethodID: 2,
                                  PaymentTypeID: 68,
                                  PromoCodeID: Routes.PromoCodeID));
                              //}
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Constants.customButton(
                                text:
                                    LanguageClass.isEnglish ? "Charge" : "شحن",
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // )
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
