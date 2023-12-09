import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/presentation/PLOH/change_password_cubit.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/presentation/screen/change_password.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/presentation/PLOH/personal_info_cubit.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/presentation/screen/personal_info.dart';
import 'package:swa/features/sign_in/data/data_sources/login_local_data_source.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/dete_respo.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';

class MyAccountScreen extends StatelessWidget {
  MyAccountScreen({
    super.key,
    required this.user,
    required this.loginLocalDataSource,
  });
  User user;

  Userdeleterespo userdelete = new Userdeleterespo();

  final LoginLocalDataSource loginLocalDataSource;

  @override
  Widget build(BuildContext context) {
    print("_user${user?.customerId ?? 0}");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Directionality(
        textDirection:
        LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LanguageClass.isEnglish? "My Account":"حسابي",
                style: TextStyle(
                    color: AppColors.white, fontSize: 34, fontFamily: "bold"),
              ),
              const SizedBox(
                height: 37,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 17,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BlocProvider<PersonalInfoCubit>(
                              create: (context) => PersonalInfoCubit(),
                              child: PersonalInfoScreen(
                                user: user,
                              ));
                        }));
                      },
                      child: customText(LanguageClass.isEnglish?"Personal Info":"معلومات شخصية")),
                  const SizedBox(
                    height: 17,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BlocProvider<ChangePasswordCubit>(
                            create: (context) => ChangePasswordCubit(),
                            child: ChangePassword(
                              user: user,
                            ),
                          );
                        }));
                      },
                      child: customText(LanguageClass.isEnglish?"Change Password":"تغير كلمة المرور")),
                  const SizedBox(
                    height: 17,
                  ),
                  InkWell(
                      onTap: () {
                        loginLocalDataSource.clearUserData();

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.signInRoute,
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: customText(LanguageClass.isEnglish?"Logout":"خروج")),
                  const SizedBox(
                    height: 17,
                  ),
                  InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              backgroundColor: AppColors.darkPurple,
                              title: Text(LanguageClass.isEnglish?"Delete Account":"حذف الحساب",style: TextStyle(
                                fontSize: 20,
                                fontFamily: "bold",
                                color: AppColors.primaryColor
                              ),),
                              content: Text(LanguageClass.isEnglish?"Are you sure you want to delete your account?":
                              "هل انت متاكد انك تريد ان تحذف حسابك؟",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "regular",

                              ),),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text(LanguageClass.isEnglish?"Cancel":"الغاء",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primaryColor,
                                      fontFamily: "bold",

                                    ),),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                    userdelete.deleteuserfun(user.customerId!);
                                    loginLocalDataSource.clearUserData();
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      Routes.signInRoute,
                                          (Route<dynamic> route) => false,

                                    );
                                  },
                                  child: Text(LanguageClass.isEnglish?"OK":"موافقة",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primaryColor,
                                      fontFamily: "bold",

                                    ),),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: customText(LanguageClass.isEnglish?"Delete account":"حذق الحساب")),
                ],
              ),
              const Spacer(),


            ],

          ),
        ),
      ),
    );
  }

  Widget customText(text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.white, fontSize: 21, fontFamily: "bold"),
    );
  }
}
