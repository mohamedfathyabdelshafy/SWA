import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/presentation/PLOH/change_password_cubit.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/presentation/PLOH/change_password_states.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key, required this.user});
  User user;
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<ChangePasswordCubit, ChangePasswordStates>(
        bloc: BlocProvider.of<ChangePasswordCubit>(context),
        listener: (context, state) {
          if (state is ChangePasswordLoading) {
            Constants.showLoadingDialog(context);
          }
          if (state is ChangePasswordLoaded) {
            Constants.hideLoadingDialog(context);
            Constants.showDefaultSnackBar(
                context: context, text: state.changePasswordResponse.message!);
          }
          if (state is ChangePasswordError) {
            Constants.hideLoadingDialog(context);
            Constants.showDefaultSnackBar(context: context, text: state.msg);
          }
        },
        child: Directionality(
          textDirection:
              LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: ListView(
                padding: EdgeInsets.zero,
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
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      LanguageClass.isEnglish
                          ? "Change Password"
                          : "تغير كلمة المرور",
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          fontFamily: "roman"),
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight * 0.03,
                  ),
                  CustomizedField(
                    colorText: Color(0xffA2A2A2),
                    borderradias: 12,
                    isPassword: true,
                    obscureText: true,
                    color: Color(0xffDDDDDD),
                    controller: oldPassController,
                    validator: (validator) {
                      if (validator == null || validator.isEmpty) {
                        return LanguageClass.isEnglish
                            ? "Enter your old password"
                            : "ادخل كلمة المرور القديمة ";
                      }
                      return null;
                    },
                    labelText: LanguageClass.isEnglish
                        ? "Old Password"
                        : "كلمة المرور القديمة ",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomizedField(
                    colorText: Color(0xffA2A2A2),
                    borderradias: 12,
                    isPassword: true,
                    obscureText: true,
                    color: Color(0xffDDDDDD),
                    controller: newPassController,
                    validator: (validator) {
                      if (validator == null || validator.isEmpty) {
                        return LanguageClass.isEnglish
                            ? "Enter your new Password"
                            : "ادخل كلمة المرور القديمة ";
                      }
                      return null;
                    },
                    labelText: LanguageClass.isEnglish
                        ? "New Password"
                        : "كلمة المرور الجديدة",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomizedField(
                    colorText: Color(0xffA2A2A2),
                    borderradias: 12,
                    isPassword: true,
                    obscureText: true,
                    color: Color(0xffDDDDDD),
                    controller: confirmPassController,
                    validator: (validator) {
                      if (validator == null || validator.isEmpty) {
                        return LanguageClass.isEnglish
                            ? "Confirm your password"
                            : "موافقة كلمة المرور";
                      }
                      return null;
                    },
                    labelText: LanguageClass.isEnglish
                        ? "Confirm New Password"
                        : "الموافقة علي كلمة المرور",
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      if (!formKey.currentState!.validate()) return;
                      BlocProvider.of<ChangePasswordCubit>(context)
                          .changePassword(
                              userId: user.userId!,
                              oldPass: oldPassController.text,
                              newPass: confirmPassController.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Constants.customButton(
                          borderradias: 41,
                          text: LanguageClass.isEnglish ? "Save" : "حفظ",
                          color: AppColors.primaryColor),
                    ),
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
