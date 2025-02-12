import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';

import 'package:swa/features/sign_up/presentation/cubit/register_cubit.dart';

class VerifyCodeScreen extends StatefulWidget {
  VerifyCodeScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizeWidth / 10),
        child: Directionality(
          textDirection:
              LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                height: sizeHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: context.height * 0.05),
                    SizedBox(height: context.height * 0.08),
                    Image.asset("assets/images/applogo.png"),
                    SizedBox(height: context.height * 0.1),
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            LanguageClass.isEnglish
                                ? "Enter Code"
                                : "ادخل الكود",
                            style: fontStyle(
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: FontFamily.bold,
                                fontSize: 24),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: PinCodeTextField(
                              appContext: context,

                              pastedTextStyle: fontStyle(
                                color: Color(0xffDDDDDD),
                                fontWeight: FontWeight.bold,
                                fontFamily: FontFamily.bold,
                                fontSize: 14,
                              ),
                              length: 4,
                              obscureText: false,
                              textStyle: fontStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  fontFamily: FontFamily.bold),

                              blinkWhenObscuring: true,
                              backgroundColor: Colors.transparent,

                              animationType: AnimationType.fade,
                              autoUnfocus: true,
                              autoFocus: true,
                              validator: (validator) {
                                if (validator == null || validator.isEmpty) {
                                  return LanguageClass.isEnglish
                                      ? " Enter the code"
                                      : "ادخل الكود";
                                }
                                return null;
                              },
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                disabledColor: Color(0xffDDDDDD),
                                activeColor: const Color(0xffDDDDDD),
                                selectedColor: const Color(0xffDDDDDD),
                                inactiveColor: const Color(0xffDDDDDD),
                                inactiveFillColor: Color(0xffDDDDDD),
                                selectedFillColor: Color(0xffDDDDDD),
                                fieldOuterPadding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                borderWidth: 1,
                                borderRadius: BorderRadius.circular(100),
                                fieldHeight: 60,
                                fieldWidth: 60,
                                activeFillColor: Color(0xffDDDDDD),
                              ),
                              cursorColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              enableActiveFill: true,
                              controller: codeController,
                              keyboardType: TextInputType.number,
                              mainAxisAlignment: MainAxisAlignment.center,

                              onCompleted: (v) async {
                                debugPrint("Completed");
                              },
                              // onTap: () {
                              //   print("Pressed");
                              // },
                              onChanged: (value) {},
                              enablePinAutofill: false,
                              errorTextMargin: const EdgeInsets.only(top: 10),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    BlocListener(
                      bloc: BlocProvider.of<RegisterCubit>(context),
                      listener: (context, state) {
                        if (state is RegisterLoadingState) {
                          Constants.showLoadingDialog(context);
                        } else if (state is EmailsendState) {
                          if (state.message == 'success') {
                            Navigator.pushReplacementNamed(
                                context, Routes.signUpRoute);
                          }
                        } else if (state is RegisterErrorState) {
                          Constants.hideLoadingDialog(context);
                          Constants.showDefaultSnackBar(
                              context: context, text: state.error.toString());
                        }
                      },
                      child: InkWell(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              BlocProvider.of<RegisterCubit>(context)
                                  .confirmemail(otp: codeController.text);
                            }
                          },
                          child: Constants.customButton(
                              borderradias: 41,
                              color: Routes.isomra
                                  ? AppColors.umragold
                                  : AppColors.primaryColor,
                              text: LanguageClass.isEnglish
                                  ? "Enter code"
                                  : "ادخل الرمز")),
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
