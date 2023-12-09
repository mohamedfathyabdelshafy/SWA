import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/sign_in/domain/use_cases/login.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Directionality(
        textDirection:
        LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                height: sizeHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: context.height * 0.05),

                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                            onPressed: (){
                              // Navigator.push(context, MaterialPageRoute(builder: (context){return ForgetPasswordScreen();}));
                              Navigator.pushNamed(context, Routes.initialRoute);
                            },
                            child: Text(
                              LanguageClass.isEnglish?"Skip":"تخطي",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.white
                              ),
                            )
                        ),
                      ],
                    ),
                    SizedBox(height: context.height * 0.05),
                    SvgPicture.asset("assets/images/Swa Logo.svg"),
                    SizedBox(height: context.height * 0.15),
                    SizedBox(
                      height: context.height * 0.22,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CustomizedField(
                                colorText: Colors.white,
                                obscureText: false,
                                color: AppColors.lightBink,
                                hintText: LanguageClass.isEnglish?"Enter your email":
                                "ادخل الايمل",
                                controller: userNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter UserName";
                                  }
                                  return null;
                                }),
                            CustomizedField(
                                colorText: Colors.white,
                                isPassword: true,
                                obscureText: true,
                                color: AppColors.lightBink,
                                hintText: LanguageClass.isEnglish?"Enter Password":
                                "ادخل كلمه المرور",
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return LanguageClass.isEnglish?"Enter Password":
                                    "ادخل كلمه المرور";
                                  }
                                  return null;
                                }),
                          ],
                        ),
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
                            Navigator.pushReplacementNamed(
                                context, Routes.initialRoute);
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
                          child: Constants.customButton(text:LanguageClass.isEnglish? "Login":
                          "دخول")),
                    ),
                    TextButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context){return ForgetPasswordScreen();}));
                          Navigator.pushNamed(
                              context, Routes.forgotPasswordRoute);
                        },
                        child: Text(
                          LanguageClass.isEnglish?"Forget Password ?":"نسيت كلمه المرور",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: AppColors.white),
                        )),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LanguageClass.isEnglish? "Don’t have an account? ":"لا امتلك حساب؟",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context){return SignUpScreen();}));
                            Navigator.pushNamed(context, Routes.signUpRoute);
                          },
                          child: Text(
                            LanguageClass.isEnglish?"Sign UP":
                            "انشاء حساب",
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ],
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
