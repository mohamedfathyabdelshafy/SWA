import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.primaryColor,
            size: 34,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: const [
                Text(
                  'Electronic wallet',
                  style: TextStyle(
                      color: Colors.white, fontSize: 30, fontFamily: "bold"),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
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
                            decoration:
                                const BoxDecoration(color: Color(0xff47A9EB)),
                          ),
                          Container(
                            height: 70,
                            width: 300,
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
                                  color: AppColors.white, fontSize: 16),
                              cursorColor: AppColors.blue,
                              controller: phoneController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]"))
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Phone Number',
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
                          Container(
                            height: 50,
                            width: 300,
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
                                  color: AppColors.white, fontSize: 16),
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
                        ],
                      ),
                      const Spacer(),
                      BlocListener(
                        bloc: BlocProvider.of<EWalletCubit>(context),
                        listener: (context, state) {
                          if (state is EWalletLoadingState) {
                            Constants.showLoadingDialog(context);
                          } else if (state is EWalletLoadedState) {
                            Constants.hideLoadingDialog(context);
                            Constants.showDefaultSnackBar(
                                context: context,
                                text: state.paymentMessageResponse
                                    .paymentMessage!.statusDescription);
                            Future.delayed(const Duration(seconds: 5), () {
                              Navigator.pushReplacementNamed(
                                  context, Routes.initialRoute);
                            });
                          } else if (state is EWalletErrorState) {
                            Constants.hideLoadingDialog(context);
                            Constants.showDefaultSnackBar(
                                context: context, text: state.error.toString());
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
                              text: "Charge",
                              color: AppColors.primaryColor,
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
    );
  }
}
