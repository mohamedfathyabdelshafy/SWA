import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_country_cities_cubit/get_available_country_cities_cubit.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/presentation/PLOH/change_password_cubit.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/presentation/screen/change_password.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/presentation/PLOH/personal_info_cubit.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/presentation/screen/personal_info.dart';
import 'package:swa/features/sign_in/data/data_sources/login_local_data_source.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/dete_respo.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/main.dart';

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
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    print("_user${user?.customerId ?? 0}");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: Routes.isomra
                        ? AppColors.umragold
                        : AppColors.primaryColor,
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
                  LanguageClass.isEnglish ? "My Account" : "حسابي",
                  style: fontStyle(
                      color: AppColors.blackColor,
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.medium),
                ),
              ),
              SizedBox(
                height: sizeHeight * 0.01,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 17,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider<PersonalInfoCubit>(
                                              create: (context) =>
                                                  PersonalInfoCubit(),
                                            ),
                                            BlocProvider<
                                                    GetAvailableCountriesCubit>(
                                                create: (context) => sl<
                                                    GetAvailableCountriesCubit>()),
                                            BlocProvider<
                                                    GetAvailableCountryCitiesCubit>(
                                                create: (context) => sl<
                                                    GetAvailableCountryCitiesCubit>()),
                                          ],
                                          child: PersonalInfoScreen(
                                            user: user,
                                          ))));
                        },
                        child: customText(
                          LanguageClass.isEnglish
                              ? "Personal Info"
                              : "معلومات شخصية",
                        )),
                    Divider(
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
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
                        child: customText(LanguageClass.isEnglish
                            ? "Change Password"
                            : "تغير كلمة المرور")),
                    Divider(
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          loginLocalDataSource.clearUserData();

                          Routes.customerid = null;
                          Routes.user = null;

                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.signInRoute,
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: customText(
                            LanguageClass.isEnglish ? "Logout" : "خروج")),
                    Divider(
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
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
                                title: Text(
                                  LanguageClass.isEnglish
                                      ? "Delete Account"
                                      : "حذف الحساب",
                                  style: fontStyle(
                                      fontSize: 20,
                                      fontFamily: FontFamily.bold,
                                      color: Routes.isomra
                                          ? AppColors.umragold
                                          : AppColors.primaryColor),
                                ),
                                content: Text(
                                  LanguageClass.isEnglish
                                      ? "Are you sure you want to delete your account?"
                                      : "هل انت متاكد انك تريد ان تحذف حسابك؟",
                                  style: fontStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: FontFamily.medium,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text(
                                      LanguageClass.isEnglish
                                          ? "Cancel"
                                          : "الغاء",
                                      style: fontStyle(
                                        fontSize: 18,
                                        color: Routes.isomra
                                            ? AppColors.umragold
                                            : AppColors.primaryColor,
                                        fontFamily: FontFamily.bold,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      userdelete
                                          .deleteuserfun(user.customerId!);
                                      loginLocalDataSource.clearUserData();
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        Routes.signInRoute,
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                    child: Text(
                                      LanguageClass.isEnglish ? "OK" : "موافقة",
                                      style: fontStyle(
                                        fontSize: 18,
                                        color: Routes.isomra
                                            ? AppColors.umragold
                                            : AppColors.primaryColor,
                                        fontFamily: FontFamily.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: customText(LanguageClass.isEnglish
                            ? "Delete account"
                            : "حذف الحساب")),
                  ],
                ),
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
      style: fontStyle(
          color: Colors.black, fontSize: 18, fontFamily: FontFamily.medium),
    );
  }
}
