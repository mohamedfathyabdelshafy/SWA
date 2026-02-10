import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/change_password/domain/use_cases/new_password.dart';
import 'package:swa/features/change_password/presentation/cubit/new_password_cubit.dart';
import 'package:swa/features/forgot_password/domain/use_cases/submit_password.dart';
import 'package:swa/features/sign_in/data/models/user_model.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';

import '../../../../core/utils/styles.dart';
import '../cubit/forgot_password_cubit.dart';

class SubmitPasswordScreen extends StatefulWidget {
  SubmitPasswordScreen({Key? key, required this.userId, required this.code})
      : super(key: key);
  String userId;
  String code;

  @override
  State<SubmitPasswordScreen> createState() => _SubmitPasswordScreenState();
}

class _SubmitPasswordScreenState extends State<SubmitPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController REnewPassController = TextEditingController();

  User? _user;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      BlocProvider.of<LoginCubit>(context).getUserData();
    });
    super.initState();
  }

  @override
  void dispose() {
    newPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("SUBMIT PASSWORD SCREEN");
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizeWidth / 10),
        child: BlocListener(
          bloc: BlocProvider.of<ForgotPasswordCubit>(context),
          listener: (context, state) {
            // if (state is UserLoginLoadedState) {
            //   _user = state.userResponse.user;
            // }
          },
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
                      Image.asset(Routes.isomra
                          ? "assets/images/swaumra.png"
                          : "assets/images/applogo.png"),
                      SizedBox(height: context.height * 0.1),
                      Column(
                        children: [
                          // CustomizedField(
                          //     colorText: Color(0xffA2A2A2),
                          //     borderradias: 33,
                          //     isPassword: true,
                          //     obscureText: true,
                          //     color: Color(0xffDDDDDD),
                          //     hintText: LanguageClass.isEnglish
                          //         ? "Enter old password"
                          //         : "ادخل كلمة المرور القديمة",
                          //     controller: oldPassController,
                          //     validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //         return LanguageClass.isEnglish
                          //             ? "Enter old password"
                          //             : "ادخل كلمة المرور القديمة";
                          //       }
                          //       return null;
                          //     }),
                          // SizedBox(
                          //   height: 19,
                          // ),
                          CustomizedField(
                              colorText: Color(0xffA2A2A2),
                              borderradias: 33,
                              isPassword: true,
                              obscureText: true,
                              color: Color(0xffDDDDDD),
                              hintText: LanguageClass.isEnglish
                                  ? "Enter new password"
                                  : "ادخل كلمة المرور الجديدة",
                              controller: newPassController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LanguageClass.isEnglish
                                      ? "Enter new password"
                                      : " ادخال كلمة المرور";
                                }
                                return null;
                              }),
                          SizedBox(
                            height: 19,
                          ),
                          CustomizedField(
                              colorText: Color(0xffA2A2A2),
                              borderradias: 33,
                              isPassword: true,
                              obscureText: true,
                              color: Color(0xffDDDDDD),
                              hintText: LanguageClass.isEnglish
                                  ? "ReEnter new password"
                                  : "اعادة ادخال كلمة المرور",
                              controller: REnewPassController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LanguageClass.isEnglish
                                      ? "Re-enter New Password"
                                      : "اعادة ادخال كلمة المرور الجديدة";
                                } else if (value != newPassController.text) {
                                  return LanguageClass.isEnglish
                                      ? "Passwords doesn't match"
                                      : "كلمتا المرور غير متطابقتان";
                                }
                                return null;
                              }),
                        ],
                      ),
                      const Spacer(),
                      BlocListener(
                        bloc: BlocProvider.of<ForgotPasswordCubit>(context),
                        listener: (context, state) {
                          if (state is ForgotPasswordLoadingState) {
                            Constants.showLoadingDialog(context);
                          } else if (state is ForgotPasswordLoadedState) {
                            Constants.hideLoadingDialog(context);
                            // Navigator.pushNamedAndRemoveUntil(context,
                            //     Routes.doneLoginRoute, (route) => false);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) {
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 30),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/Swa Logo.svg",
                                          height: 60,
                                          color: Routes.isomra
                                              ? AppColors.umragold
                                              : AppColors.primaryColor,
                                        ),
                                        const SizedBox(height: 30),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Routes.isomra
                                                ? AppColors.umragold
                                                : AppColors.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            LanguageClass.isEnglish
                                                ? "Your password has been reset successfully!"
                                                : "!تم إعادة ضبط كلمة المرور بنجاح",
                                            textAlign: TextAlign.center,
                                            style: fontStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: FontFamily.medium,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pop(); // Close dialog
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              Routes.signInRoute,
                                              (r) => false,
                                            );
                                          },
                                          child: Constants.customButton(
                                            text: LanguageClass.isEnglish
                                                ? "Login"
                                                : "تسجيل الدخول",
                                            color: Routes.isomra
                                                ? AppColors.umragold
                                                : AppColors.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            print("Marfoda m3lm");
                          } else if (state is ForgotPasswordErrorState) {
                            Constants.hideLoadingDialog(context);
                            Constants.showDefaultSnackBar(
                              context: context,
                              text: state.error.toString(),
                            );
                          }
                        },
                        child: InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                ///Change old password to code
                                BlocProvider.of<ForgotPasswordCubit>(context)
                                    .submitPassword(
                                  SubmitPasswordParams(
                                    code: widget.code,
                                    newPassword: newPassController.text,
                                    userId: widget.userId,
                                  ),
                                );
                              }
                            },
                            child: Constants.customButton(
                                borderradias: 41,
                                color: Routes.isomra
                                    ? AppColors.umragold
                                    : AppColors.primaryColor,
                                text: LanguageClass.isEnglish ? "Done" : "تم")),
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
      ),
    );
  }
}
