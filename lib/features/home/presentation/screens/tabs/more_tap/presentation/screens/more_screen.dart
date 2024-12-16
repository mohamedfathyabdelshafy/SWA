import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/Swa_umra/Screens/Select_type.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/Allpackages_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/FAQ_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/abous_us.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/bus_class.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/contact_us.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/lines_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/privacy_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/stations_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/terms_and_conditions_terms.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.initialRoute, (route) => false);
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
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    LanguageClass.isEnglish ? "More" : "المزيد",
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 38,
                        fontWeight: FontWeight.w500,
                        fontFamily: "roman"),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.05,
                ),
                Expanded(
                  child: ListView.separated(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      itemBuilder: (context, index) {
                        return index == 9
                            ? BlocBuilder<GetAvailableCountriesCubit,
                                    GetAvailableCountriesCubitState>(
                                builder: (context, state) {
                                return state is GetAvailableCountriesLoadedState
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 10),
                                        child: InkWell(
                                          onTap: () {
                                            showGeneralDialog(
                                                context: context,
                                                pageBuilder: (BuildContext
                                                        buildContext,
                                                    Animation<double> animation,
                                                    Animation<double>
                                                        secondaryAnimation) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setStater) {
                                                    return Material(
                                                      color: Colors.transparent,
                                                      child: Directionality(
                                                        textDirection:
                                                            LanguageClass.isEnglish
                                                                ? TextDirection
                                                                    .ltr
                                                                : TextDirection
                                                                    .rtl,
                                                        child: Container(
                                                          alignment: Alignment
                                                              .topRight,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          20))),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      30,
                                                                  vertical: 5),
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height:
                                                                    sizeHeight *
                                                                        0.08,
                                                              ),
                                                              Container(
                                                                alignment: LanguageClass
                                                                        .isEnglish
                                                                    ? Alignment
                                                                        .topLeft
                                                                    : Alignment
                                                                        .topRight,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_back_rounded,
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                    size: 35,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20),
                                                                child: Text(
                                                                  LanguageClass
                                                                          .isEnglish
                                                                      ? "Select your country"
                                                                      : "اختر الدولة",
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .blackColor,
                                                                      fontSize:
                                                                          28,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontFamily:
                                                                          "meduim"),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    sizeHeight *
                                                                        0.01,
                                                              ),
                                                              Expanded(
                                                                child: ListView
                                                                    .separated(
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  Routes.curruncy = state.countries[index].curruncy;

                                                                                  Routes.country = state.countries[index].countryName;

                                                                                  setStater(() {
                                                                                    log(state.countries[index].countryId.toString());
                                                                                    CacheHelper.setDataToSharedPref(
                                                                                      key: 'countryid',
                                                                                      value: state.countries[index].countryId,
                                                                                    );
                                                                                    CacheHelper.setDataToSharedPref(
                                                                                      key: 'countryflag',
                                                                                      value: state.countries[index].Flag,
                                                                                    );
                                                                                    Routes.countryflag = state.countries[index].Flag;
                                                                                  });
                                                                                  Routes.curruncy = state.countries[index].curruncy;

                                                                                  Navigator.pushNamedAndRemoveUntil(context, Routes.initialRoute, (route) => false);
                                                                                },
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                  child: Text(
                                                                                    state.countries[index].countryName,
                                                                                    style: TextStyle(fontFamily: "meduim", color: Color(0xffA3A3A3), fontSize: 18),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                        separatorBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return Divider(
                                                                            color:
                                                                                Colors.black,
                                                                          );
                                                                        },
                                                                        itemCount: state
                                                                            .countries
                                                                            .length),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 25,
                                                  child: Image.network(
                                                    Routes.countryflag!,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  Routes.country!,
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontFamily: "regular",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 21),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          Container(
                                            width: 25,
                                            child: Image.network(
                                              Routes.countryflag!,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            Routes.country!,
                                            style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontFamily: "regular",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 21),
                                          )
                                        ],
                                      );
                              })
                            : InkWell(
                                onTap: () {
                                  if (index == 0) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return BlocProvider<MoreCubit>(
                                          create: (context) => MoreCubit(),
                                          child: StationScreen());
                                    }));
                                  } else if (index == 1) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return BlocProvider<MoreCubit>(
                                          create: (context) => MoreCubit(),
                                          child: BusClasses());
                                    }));
                                  } else if (index == 2) {
                                    if (Routes.customerid == null) {
                                      Constants.showDefaultSnackBar(
                                          context: context,
                                          color: Colors.red,
                                          text: LanguageClass.isEnglish
                                              ? "login first"
                                              : "سجل الدخول اولا");
                                    } else {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return BlocProvider<MoreCubit>(
                                            create: (context) => MoreCubit(),
                                            child: packagesScreen());
                                      }));
                                    }
                                  } else if (index == 3) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return BlocProvider<MoreCubit>(
                                          create: (context) => MoreCubit(),
                                          child: FAQScreen());
                                    }));
                                  } else if (index == 4) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return BlocProvider<MoreCubit>(
                                          create: (context) => MoreCubit(),
                                          child: AboutUsScreen());
                                    }));
                                  } else if (index == 5) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return BlocProvider<MoreCubit>(
                                          create: (context) => MoreCubit(),
                                          child: PrivacyScreen());
                                    }));
                                  } else if (index == 6) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return BlocProvider<MoreCubit>(
                                          create: (context) => MoreCubit(),
                                          child: TermsConditionsScreen());
                                    }));
                                  } else if (index == 7) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return BlocProvider<MoreCubit>(
                                          create: (context) => MoreCubit(),
                                          child: ContactUs());
                                    }));
                                  } else if (index == 8) {
                                    LanguageClass.isEnglish =
                                        !LanguageClass.isEnglish;
                                    print(
                                        "LanguageClass.isEnglish//${LanguageClass.isEnglish}");

                                    CacheHelper.setDataToSharedPref(
                                        key: 'language',
                                        value: LanguageClass.isEnglish);
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        Routes.initialRoute, (route) => false);
                                  } else if (index == 10) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectUmratypeScreen()));
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 10),
                                  child: index == 10
                                      ? Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                LanguageClass.isEnglish
                                                    ? "Swa Umrah"
                                                    : "سوا عمرة",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontFamily: "meduim"),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: AppColors.yellow2,
                                                ),
                                                child: Text(
                                                  "New",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.sp,
                                                      color: AppColors
                                                          .primaryColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Text(
                                          index == 0
                                              ? LanguageClass.isEnglish
                                                  ? "Lines"
                                                  : "خطوط"
                                              : index == 1
                                                  ? LanguageClass.isEnglish
                                                      ? "Bus classes"
                                                      : "انواع الاتوبيس"
                                                  : index == 2
                                                      ? LanguageClass.isEnglish
                                                          ? "Packages"
                                                          : "الباقات"
                                                      : index == 3
                                                          ? LanguageClass
                                                                  .isEnglish
                                                              ? "FAQ"
                                                              : "اسئله شائعة"
                                                          : index == 4
                                                              ? LanguageClass
                                                                      .isEnglish
                                                                  ? "About Us"
                                                                  : "معلومات عنا"
                                                              : index == 5
                                                                  ? LanguageClass
                                                                          .isEnglish
                                                                      ? "Privacy policy"
                                                                      : "سياسة الخصوصية"
                                                                  : index == 6
                                                                      ? LanguageClass
                                                                              .isEnglish
                                                                          ? "Terms And Conditions"
                                                                          : "الأحكام والشروط"
                                                                      : index ==
                                                                              7
                                                                          ? LanguageClass.isEnglish
                                                                              ? "Contact us"
                                                                              : "تواصل معنا"
                                                                          : LanguageClass.isEnglish
                                                                              ? "عربي"
                                                                              : "En",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: "meduim"),
                                        ),
                                ),
                              );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Color(0xffe0e0e0),
                          thickness: 1,
                          height: 5,
                        );
                      },
                      itemCount: 11),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
