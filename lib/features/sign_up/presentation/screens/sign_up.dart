import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/hex_color.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/sign_up/domain/use_cases/register.dart';
import 'package:swa/features/sign_up/presentation/cubit/register_cubit.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Directionality(
        textDirection:
        LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Stack(
          children: [
            Image.asset(
              "assets/images/oranaa.agency_85935_A_Cinematic_Scene_from_2023_Romantic_Comedy_eec33b5c-a92f-40cb-ab53-e6c1790831cc.png",
              fit: BoxFit.fill,
              width: double.infinity,
            ),
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.height * 0.05),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryColor,
                        size: 35,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: context.height * 0.01),
                          Text(
                            LanguageClass.isEnglish?"Sign Up":"انشاء حساب",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: HexColor('#F7F8F9'),
                                fontSize: 35),
                          ),
                          // SizedBox(height:context.height *0.03 ,),
                          SizedBox(
                            height: context.height * 0.25,
                          ),
                          CustomizedField(
                            colorText: AppColors.greyLight,
                            controller: nameController,
                            validator: (validator) {
                              if (validator == null || validator.isEmpty) {
                                return LanguageClass.isEnglish?"Enter name":"ادخل الاسم";
                              }
                              return null;
                            },
                            color: Colors.black.withOpacity(0.5),
                            labelText: LanguageClass.isEnglish?"Full Name":"الاسم كامل",
                          ),
                          CustomizedField(
                            colorText: AppColors.greyLight,
                            controller: mobileController,
                            keyboardType: TextInputType.number,
                            maxLength: 11,
                            validator: (validator) {
                              if (validator == null || validator.isEmpty) {
                                return LanguageClass.isEnglish?"Enter phone":"ادخل الموبيل";
                              }
                              return null;
                            },
                            color: Colors.black.withOpacity(0.5),
                            labelText: LanguageClass.isEnglish?"Phone Number":"ادخل الرقم",
                          ),
                          CustomizedField(
                            colorText: AppColors.greyLight,
                            controller: emailController,
                            validator: (validator) {
                              if (validator == null || validator.isEmpty) {
                                return LanguageClass.isEnglish?"Enter Email":"ادخل الايميل";
                              }
                              String pattern =
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                              RegExp regex = RegExp(pattern);
                              if (!regex.hasMatch(validator)) {
                                return LanguageClass.isEnglish?"Your Email is invalid":"هذا الايميل غير صالح";
                              } else {
                                return null;
                              }
                            },
                            color: Colors.black.withOpacity(0.5),
                            labelText: "Email",
                          ),
                          CustomizedField(
                            isPassword: true,
                            obscureText: true,
                            colorText: AppColors.greyLight,
                            controller: passwordController,
                            validator: (validator) {
                              if (validator == null || validator.isEmpty) {
                                return LanguageClass.isEnglish?"Enter your password":"ادخل كلمة المرور";
                              }
                              return null;
                            },
                            color: Colors.black.withOpacity(0.5),
                            labelText: LanguageClass.isEnglish?"Enter Your Password(min 8 characters)":"ادخل كلمة المرور لا تقل عن 8 احرف",
                          ),
                          CustomizedField(
                            isPassword: true,
                            obscureText: true,
                            colorText: AppColors.greyLight,
                            controller: rePasswordController,
                            validator: (validator) {
                              if (validator == null || validator.isEmpty) {
                                return LanguageClass.isEnglish? "Confirm your password":"اعادة ادخال كلمة المرور";
                              }
                              return null;
                            },
                            color: Colors.black.withOpacity(0.5),
                            labelText: LanguageClass.isEnglish?"Confirm Your Password":"موافقة كلمة المرور",
                          ),
                          BlocListener(
                            bloc: BlocProvider.of<RegisterCubit>(context),
                            listener: (context, state) {
                              if (state is RegisterLoadingState) {
                                Constants.showLoadingDialog(context);
                              } else if (state is UserRegisterLoadedState) {
                                Constants.hideLoadingDialog(context);
                                Constants.showDefaultSnackBar(
                                    context: context,
                                    text:
                                        state.messageResponse.massage.toString());

                                Navigator.pushReplacementNamed(
                                    context, Routes.signInRoute);
                              } else if (state is RegisterErrorState) {
                                Constants.hideLoadingDialog(context);
                                Constants.showDefaultSnackBar(
                                    context: context,
                                    text: state.error.toString());
                              }
                            },
                            child: InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  BlocProvider.of<RegisterCubit>(context)
                                      .registerUser(UserRegisterParams(
                                          name: nameController.text,
                                          mobile: mobileController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                          userType: "Customer"));
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    LanguageClass.isEnglish?"Sign Up":"انشاء الحساب",
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
