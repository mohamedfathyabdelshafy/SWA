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
import 'package:swa/features/change_password/presentation/cubit/new_password_cubit.dart';
import 'package:swa/features/change_password/presentation/screens/code_screen.dart';
import 'package:swa/features/change_password/presentation/screens/new_password.dart';
import 'package:swa/features/forgot_password/domain/use_cases/forgot_password.dart';
import 'package:swa/features/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';

import '../../../../main.dart';
import '../../../create_passcode/presentation/pages/create_passcode.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sizeWidth / 10),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: context.height * 0.05),
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
                  SizedBox(height: context.height * 0.08),
                  Image.asset(Routes.isomra
                      ? 'assets/images/swaumra.png'
                      : "assets/images/applogo.png"),
                  SizedBox(height: context.height * 0.1),
                  Text(
                    LanguageClass.isEnglish
                        ? "Forgot Password"
                        : "نسيت كلمه المرور",
                    style: fontStyle(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontFamily.bold,
                        fontSize: 24),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    LanguageClass.isEnglish
                        ? "Please enter your retested email to send the custom Regain code via email"
                        : " الرجاء إدخال بريدك الإلكتروني المعاد اختباره لإرسال الرمز المخصص عبر البريد الإلكتروني ",
                    style: fontStyle(
                      color: Color(0xffA3A3A3),
                      fontSize: 13,
                      fontFamily: FontFamily.regular,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomizedField(
                    colorText: Colors.black,
                    borderradias: 33,
                    isPassword: false,
                    obscureText: false,
                    color: Color(0xffDDDDDD),
                    hintText: LanguageClass.isEnglish
                        ? "Enter Email"
                        : "ادخل الايميل",
                    controller: emailController,
                    validator: (validator) {
                      if (validator == null || validator.isEmpty) {
                        return LanguageClass.isEnglish
                            ? "Enter Email"
                            : "ادخل الايميل";
                      }
                      String pattern =
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(validator)) {
                        return LanguageClass.isEnglish
                            ? "Your Email is invalid"
                            : "ايميلك غير صحيح";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  BlocListener(
                    bloc: BlocProvider.of<ForgotPasswordCubit>(context),
                    listener: (context, state) {
                      if (state is ForgotPasswordLoadingState) {
                        Constants.showLoadingDialog(context);
                      } else if (state is ForgotPasswordLoadedState) {
                        Constants.hideLoadingDialog(context);
                        if (state.messageResponse.status == 'failed') {
                          Constants.showDefaultSnackBar(
                              context: context,
                              text: state.messageResponse.massage.toString());
                        } else if (state.messageResponse.status == 'success') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider<LoginCubit>(
                                              create: (context) =>
                                                  sl<LoginCubit>(),
                                            ),
                                            BlocProvider<NewPasswordCubit>(
                                              create: (context) =>
                                                  sl<NewPasswordCubit>(),
                                            ),
                                          ],
                                          child: CodeScreen(
                                            userId:
                                                state.messageResponse.massage!,
                                          ))));
                        }
                      } else if (state is ForgotPasswordErrorState) {
                        Constants.hideLoadingDialog(context);
                        Constants.showDefaultSnackBar(
                            context: context, text: state.error.toString());
                      }
                    },
                    child: InkWell(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<ForgotPasswordCubit>(context)
                                .forgotPassword(ForgotPasswordParams(
                                    email: emailController.text));
                          }
                        },
                        child: Constants.customButton(
                            borderradias: 41,
                            color: Routes.isomra
                                ? AppColors.umragold
                                : AppColors.primaryColor,
                            text: LanguageClass.isEnglish
                                ? "Send Code"
                                : "ارسال الكود")),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
