import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/sign_in/domain/use_cases/login.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool? isback = false;

  LoginScreen({
    Key? key,
    this.isback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sizeWidth / 10),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                height: sizeHeight,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context){return ForgetPasswordScreen();}));
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Routes.home, (route) => false,
                                  arguments: Routes.isomra);
                            },
                            child: Text(
                              LanguageClass.isEnglish ? "Skip" : "تخطي",
                              style: fontStyle(
                                  fontSize: 16,
                                  fontFamily: FontFamily.medium,
                                  fontWeight: FontWeight.normal,
                                  color: Routes.isomra
                                      ? AppColors.umragold
                                      : AppColors.primaryColor),
                            )),
                      ],
                    ),
                    SizedBox(height: context.height * 0.05),
                    Image.asset(Routes.isomra
                        ? "assets/images/swaumra.png"
                        : "assets/images/applogo.png"),
                    SizedBox(height: context.height * 0.1),
                    SizedBox(
                      child: Column(
                        children: [
                          CustomizedField(
                              colorText: Colors.black,
                              borderradias: 33,
                              obscureText: false,
                              color: Color(0xffDDDDDD),
                              hintText: LanguageClass.isEnglish
                                  ? "Enter your email or phone"
                                  : " ادخل الايميل او التليفون",
                              controller: userNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter UserName";
                                }
                                return null;
                              }),
                          SizedBox(
                            height: 19,
                          ),
                          CustomizedField(
                              colorText: Colors.black,
                              borderradias: 33,
                              isPassword: true,
                              obscureText: true,
                              color: Color(0xffDDDDDD),
                              hintText: LanguageClass.isEnglish
                                  ? "Enter Password"
                                  : "ادخل كلمه المرور",
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LanguageClass.isEnglish
                                      ? "Enter Password"
                                      : "ادخل كلمه المرور";
                                }
                                return null;
                              }),
                          SizedBox(
                            height: 19,
                          ),
                        ],
                      ),
                    ),
                    BlocListener(
                      bloc: BlocProvider.of<LoginCubit>(context),
                      listener: (context, state) {
                        if (state is LoginLoadingState) {
                          Constants.showLoadingDialog(context);
                        } else if (state is UserLoginLoadedState) {
                          Constants.hideLoadingDialog(context);
                          if (state.userResponse.status == 'failed') {
                            Constants.showDefaultSnackBar(
                                context: context,
                                text: state.userResponse.massage.toString());
                          } else {
                            Routes.user = state.userResponse.user;
                            if (isback == true) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Routes.home, (route) => false,
                                  arguments: Routes.isomra);
                            }

                            Routes.customerid =
                                state.userResponse.user!.customerId;
                          }
                        } else if (state is LoginErrorState) {
                          Constants.hideLoadingDialog(context);
                          Constants.showDefaultSnackBar(
                              context: context, text: state.error.toString());
                        }
                      },
                      child: InkWell(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              BlocProvider.of<LoginCubit>(context).userLogin(
                                  UserLoginParams(
                                      username: userNameController.text,
                                      password: passwordController.text));
                            }
                          },
                          child: Constants.customButton(
                              borderradias: 41,
                              color: Routes.isomra
                                  ? AppColors.umragold
                                  : AppColors.primaryColor,
                              text:
                                  LanguageClass.isEnglish ? "Login" : "دخول")),
                    ),
                    TextButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context){return ForgetPasswordScreen();}));
                          Navigator.pushNamed(
                              context, Routes.forgotPasswordRoute);
                        },
                        child: Text(
                          LanguageClass.isEnglish
                              ? "Forget Password ?"
                              : "نسيت كلمه المرور",
                          style: fontStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              fontFamily: FontFamily.regular,
                              color: Routes.isomra
                                  ? AppColors.umragold
                                  : AppColors.primaryColor),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageClass.isEnglish
                              ? "Don’t have an account? "
                              : "لا امتلك حساب؟",
                          style: fontStyle(
                            color: Color(0xffA3A3A3),
                            fontSize: 17,
                            fontFamily: FontFamily.medium,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context){return SignUpScreen();}));
                            Navigator.pushNamed(context, Routes.EmailRoute);
                          },
                          child: Text(
                            LanguageClass.isEnglish ? "Sign UP" : "انشاء حساب",
                            style: fontStyle(
                              color: Routes.isomra
                                  ? AppColors.umragold
                                  : AppColors.primaryColor,
                              fontSize: 17,
                              fontFamily: FontFamily.regular,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40,
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
