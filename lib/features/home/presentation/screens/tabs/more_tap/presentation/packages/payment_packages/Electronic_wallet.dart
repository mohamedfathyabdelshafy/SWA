import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_states_my_wallet.dart';

class Electronicwalletpackage extends StatefulWidget {
  Electronicwalletpackage({
    super.key,
  });
  @override
  State<Electronicwalletpackage> createState() =>
      _ElectronicwalletpackageState();
}

class _ElectronicwalletpackageState extends State<Electronicwalletpackage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  PackagesBloc _packagesBloc = new PackagesBloc();
  @override
  void initState() {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SizedBox(
                  height: sizeHeight * 0.08,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.home, (route) => false,
                          arguments: Routes.isomra);
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
                    LanguageClass.isEnglish
                        ? 'Electronic wallet'
                        : "المحفظة الاكترونية",
                    style: fontStyle(
                        color: AppColors.blackColor,
                        fontSize: 38,
                        fontWeight: FontWeight.w500,
                        fontFamily: FontFamily.medium),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.05,
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 1,
                              decoration:
                                  const BoxDecoration(color: Color(0xff47A9EB)),
                            ),
                            Expanded(
                              child: Container(
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
                                        : "موبيل",
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 1,
                              decoration:
                                  const BoxDecoration(color: Color(0xffD865A4)),
                            ),
                            Expanded(
                              child: Container(
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        LanguageClass.isEnglish
                                            ? "amount"
                                            : "القيمة",
                                        style: fontStyle(
                                            fontSize: 15,
                                            fontFamily: FontFamily.bold,
                                            color: AppColors.greyLight),
                                      ),
                                      Text(
                                        Routes.Amount,
                                        style: fontStyle(
                                            fontSize: 18,
                                            fontFamily: FontFamily.bold,
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

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                        Text(LanguageClass.isEnglish
                                            ? "You will get a notification by applying your wallet \n In order to agree to pay"
                                            : "سيصلك إشعار بتطبيق محفظتك \n من أجل الموافقة على الدفع"),
                                      ],
                                    ),
                                    titleTextStyle: fontStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(LanguageClass.isEnglish
                                                ? 'Amount: '
                                                : "القيمة"),
                                            Text(Routes.Amount.toString())
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Reference Number: '),
                                            Text(state
                                                .reservationResponseElectronicModel!
                                                .message!
                                                .referenceNumber
                                                .toString())
                                          ],
                                        )
                                      ],
                                    ),
                                    actionsOverflowButtonSpacing: 20,
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Routes.home,
                                                (route) => false,
                                                arguments: Routes.isomra);
                                          },
                                          child: Container(
                                            // padding: const EdgeInsets.symmetric(horizontal: 20,vertical:20),
                                            // margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                                            decoration: BoxDecoration(
                                                // color: color ?? AppColors.darkRed,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Center(
                                              child: Text(
                                                LanguageClass.isEnglish
                                                    ? 'OK'
                                                    : "موافقة",
                                                style: fontStyle(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22),
                                              ),
                                            ),
                                          )),
                                    ],
                                  );
                                },
                              );
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
                              log(phoneController.text);
                              if (phoneController.text == null ||
                                  phoneController.text == '') {
                                Constants.showDefaultSnackBar(
                                  context: context,
                                  text: LanguageClass.isEnglish
                                      ? 'Enter phone number'
                                      : "المحفظة الاكترونية",
                                );
                              } else {
                                _packagesBloc.add(PackageelectronicEvent(
                                    Amount: Routes.Amount,
                                    FromStationID:
                                        int.parse(Routes.FromStationID!),
                                    PackageID: Routes.PackageID,
                                    PackagePriceID: Routes.PackageID,
                                    ToStationID: int.parse(Routes.ToStationID!),
                                    PaymentMethodID: 5,
                                    PaymentTypeID: 68,
                                    phone: phoneController.text));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              child: Constants.customButton(
                                text:
                                    LanguageClass.isEnglish ? "Charge" : "شحن",
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //  )
                //})
              ],
            ),
          ),
        ),
      ),
    );
  }
}
