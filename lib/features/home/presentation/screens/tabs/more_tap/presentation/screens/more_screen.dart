import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/Screens/Select_type.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/Allpackages_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/FAQ_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/abous_us.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/bus_class.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/contact_us.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/lines_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/privacy_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/stations_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/terms_and_conditions_terms.dart';
import 'package:swa/select_payment2/data/models/Curruncy_model.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

const List<String> list = <String>['En', 'عربي'];

String dropdownValue = LanguageClass.isEnglish ? list.first : list[1];

class _MoreScreenState extends State<MoreScreen> {
  Curruncylist? curruncylist;
  String selectedcurruncy = '';
  bool isloading = true;
  getwalllet() async {
    var responce = await PackagesRespo().GetallCurrency();

    if (responce is Curruncylist) {
      curruncylist = responce;
      isloading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAvailableCountriesCubit>(context)
        .getAvailableCountries();
    getwalllet();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isloading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.umragold,
                ),
              )
            : Directionality(
                textDirection: LanguageClass.isEnglish
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: Padding(
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
                                context, Routes.home, (route) => false,
                                arguments: Routes.isomra);
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
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          LanguageClass.isEnglish ? "More" : "المزيد",
                          style: fontStyle(
                              color: AppColors.blackColor,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: FontFamily.bold),
                        ),
                      ),
                      SizedBox(
                        height: sizeHeight * 0.05,
                      ),
                      Expanded(
                        child: ListView.separated(
                            physics: ScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            reverse: false,
                            itemBuilder: (context, index) {
                              return index == 9
                                  ? curruncylist == null
                                      ? Container()
                                      : InkWell(
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
                                                                    color: Routes.isomra
                                                                        ? AppColors
                                                                            .umragold
                                                                        : AppColors
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
                                                                      ? "Select Currency"
                                                                      : "حدد العملة",
                                                                  style: fontStyle(
                                                                      color: AppColors
                                                                          .blackColor,
                                                                      fontSize:
                                                                          28,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .medium),
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
                                                                                  Routes.curruncy = curruncylist!.message![index].symbol!;

                                                                                  setStater(() {
                                                                                    CacheHelper.setDataToSharedPref(
                                                                                      key: 'curruncycode',
                                                                                      value: curruncylist!.message![index].symbol,
                                                                                    );
                                                                                  });
                                                                                  setState(() {});

                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        curruncylist!.message![index].name!,
                                                                                        style: fontStyle(fontFamily: FontFamily.medium, color: Color(0xffA3A3A3), fontSize: 18),
                                                                                      ),
                                                                                      Text(
                                                                                        curruncylist!.message![index].symbol!,
                                                                                        style: fontStyle(fontFamily: FontFamily.bold, color: Colors.black, fontSize: 14),
                                                                                      ),
                                                                                    ],
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
                                                                        itemCount: curruncylist!
                                                                            .message!
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
                                                Text(
                                                    LanguageClass.isEnglish
                                                        ? " Currency "
                                                        : ' عملة ',
                                                    style: fontStyle(
                                                        color: AppColors
                                                            .blackColor,
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 21)),
                                                Text(
                                                  Routes.curruncy!,
                                                  style: fontStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontFamily:
                                                          FontFamily.medium,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 21),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                  : index == 8
                                      ? BlocBuilder<GetAvailableCountriesCubit,
                                              GetAvailableCountriesCubitState>(
                                          builder: (context, state) {
                                          return state
                                                  is GetAvailableCountriesLoadedState
                                              ? Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 0,
                                                      vertical: 10),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showGeneralDialog(
                                                          context: context,
                                                          pageBuilder: (BuildContext
                                                                  buildContext,
                                                              Animation<double>
                                                                  animation,
                                                              Animation<double>
                                                                  secondaryAnimation) {
                                                            return StatefulBuilder(
                                                                builder: (context,
                                                                    setStater) {
                                                              return Material(
                                                                color: Colors
                                                                    .transparent,
                                                                child:
                                                                    Directionality(
                                                                  textDirection: LanguageClass
                                                                          .isEnglish
                                                                      ? TextDirection
                                                                          .ltr
                                                                      : TextDirection
                                                                          .rtl,
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius: BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(20),
                                                                            bottomRight: Radius.circular(20))),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            30,
                                                                        vertical:
                                                                            5),
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              sizeHeight * 0.08,
                                                                        ),
                                                                        Container(
                                                                          alignment: LanguageClass.isEnglish
                                                                              ? Alignment.topLeft
                                                                              : Alignment.topRight,
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.arrow_back_rounded,
                                                                              color: Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
                                                                              size: 35,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          margin: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 20),
                                                                          child:
                                                                              Text(
                                                                            LanguageClass.isEnglish
                                                                                ? "Select your country"
                                                                                : "اختر الدولة",
                                                                            style: fontStyle(
                                                                                color: AppColors.blackColor,
                                                                                fontSize: 28,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: FontFamily.medium),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              sizeHeight * 0.01,
                                                                        ),
                                                                        Expanded(
                                                                          child: ListView.separated(
                                                                              itemBuilder: (context, index) {
                                                                                return Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        Routes.curruncy = state.countries[index].curruncy;

                                                                                        CacheHelper.setDataToSharedPref(
                                                                                          key: 'curruncycode',
                                                                                          value: state.countries[index].curruncy,
                                                                                        );

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
                                                                                        CacheHelper.setDataToSharedPref(
                                                                                          key: 'curruncycode',
                                                                                          value: state.countries[index].curruncy,
                                                                                        );

                                                                                        Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false, arguments: Routes.isomra);
                                                                                      },
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                        child: Text(
                                                                                          state.countries[index].countryName,
                                                                                          style: fontStyle(fontFamily: FontFamily.medium, color: Color(0xffA3A3A3), fontSize: 18),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                              separatorBuilder: (context, index) {
                                                                                return Divider(
                                                                                  color: Colors.black,
                                                                                );
                                                                              },
                                                                              itemCount: state.countries.length),
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 0,
                                                          vertical: 10),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 25,
                                                            child:
                                                                Image.network(
                                                              Routes
                                                                  .countryflag!,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            Routes.country,
                                                            style: fontStyle(
                                                                color: AppColors
                                                                    .blackColor,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .medium,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 21),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Routes.countryflag == null
                                                  ? Container()
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
                                                          style: fontStyle(
                                                              color: AppColors
                                                                  .blackColor,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .medium,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 21),
                                                        )
                                                      ],
                                                    );
                                        })
                                      : index == 7
                                          ? DropdownButton<String>(
                                              value: dropdownValue,
                                              elevation: 16,
                                              style: fontStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontFamily:
                                                      FontFamily.medium),
                                              underline: Container(),
                                              onChanged: (String? value) {
                                                if (value == list.first) {
                                                  LanguageClass.isEnglish =
                                                      true;
                                                } else {
                                                  LanguageClass.isEnglish =
                                                      false;
                                                }

                                                CacheHelper.setDataToSharedPref(
                                                    key: 'language',
                                                    value: LanguageClass
                                                        .isEnglish);

                                                setState(() {
                                                  dropdownValue = value!;
                                                });
                                              },
                                              items: list.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 0,
                                                        vertical: 10),
                                                    alignment: LanguageClass
                                                            .isEnglish
                                                        ? Alignment.centerLeft
                                                        : Alignment.centerRight,
                                                    child: Text(
                                                      value,
                                                      textAlign: LanguageClass
                                                              .isEnglish
                                                          ? TextAlign.left
                                                          : TextAlign.right,
                                                      style: fontStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontFamily: FontFamily
                                                              .arFontMedium),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                if (index == 1) {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return BlocProvider<
                                                            MoreCubit>(
                                                        create: (context) =>
                                                            MoreCubit(),
                                                        child: StationScreen());
                                                  }));
                                                } else if (index == 2) {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return BlocProvider<
                                                            MoreCubit>(
                                                        create: (context) =>
                                                            MoreCubit(),
                                                        child: BusClasses());
                                                  }));
                                                } else if (index == 3) {
                                                  if (Routes.customerid ==
                                                      null) {
                                                    Constants.showDefaultSnackBar(
                                                        context: context,
                                                        color: Colors.red,
                                                        text: LanguageClass
                                                                .isEnglish
                                                            ? "login first"
                                                            : "سجل الدخول اولا");
                                                  } else {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return BlocProvider<
                                                              MoreCubit>(
                                                          create: (context) =>
                                                              MoreCubit(),
                                                          child:
                                                              packagesScreen());
                                                    }));
                                                  }
                                                } else if (index == 4) {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return BlocProvider<
                                                            MoreCubit>(
                                                        create: (context) =>
                                                            MoreCubit(),
                                                        child: FAQScreen());
                                                  }));
                                                } else if (index == 5) {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return BlocProvider<
                                                            MoreCubit>(
                                                        create: (context) =>
                                                            MoreCubit(),
                                                        child: AboutUsScreen());
                                                  }));
                                                } else if (index == 6) {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return BlocProvider<
                                                            MoreCubit>(
                                                        create: (context) =>
                                                            MoreCubit(),
                                                        child: ContactUs());
                                                  }));
                                                  // Navigator.push(context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) {
                                                  //   return BlocProvider<MoreCubit>(
                                                  //       create: (context) => MoreCubit(),
                                                  //       child: PrivacyScreen());
                                                  // }));
                                                } else if (index == 7) {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return BlocProvider<
                                                            MoreCubit>(
                                                        create: (context) =>
                                                            MoreCubit(),
                                                        child:
                                                            TermsConditionsScreen());
                                                  }));
                                                } else if (index == 8) {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return BlocProvider<
                                                            MoreCubit>(
                                                        create: (context) =>
                                                            MoreCubit(),
                                                        child: ContactUs());
                                                  }));
                                                } else if (index == 0) {
                                                  UmraDetails.isbusforumra =
                                                      false;
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          Routes.home,
                                                          (route) => false,
                                                          arguments:
                                                              !Routes.isomra);
                                                  Routes.isomra =
                                                      !Routes.isomra;
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0,
                                                        vertical: 10),
                                                child: index == 0
                                                    ? Routes.isomra
                                                        ? Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  LanguageClass
                                                                          .isEnglish
                                                                      ? "Swa Bus"
                                                                      : "سوا  باص",
                                                                  style: fontStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .medium),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                    width: 40,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            5),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: AppColors
                                                                          .white,
                                                                    ),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            'assets/images/Icon awesome-bus-alt.svg')),
                                                              ],
                                                            ),
                                                          )
                                                        : Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  LanguageClass
                                                                          .isEnglish
                                                                      ? "Swa Umrah"
                                                                      : "سوا عمرة",
                                                                  style: fontStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .medium),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                    height: 30,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            5),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: AppColors
                                                                          .white,
                                                                    ),
                                                                    child: Image
                                                                        .asset(
                                                                            'assets/images/umrah.png')),
                                                              ],
                                                            ),
                                                          )
                                                    : Text(
                                                        index == 1
                                                            ? LanguageClass
                                                                    .isEnglish
                                                                ? "Lines"
                                                                : "خطوط"
                                                            : index == 2
                                                                ? LanguageClass
                                                                        .isEnglish
                                                                    ? "Bus classes"
                                                                    : "انواع الاتوبيس"
                                                                : index == 3
                                                                    ? LanguageClass
                                                                            .isEnglish
                                                                        ? "Packages"
                                                                        : "الباقات"
                                                                    : index == 4
                                                                        ? LanguageClass
                                                                                .isEnglish
                                                                            ? "FAQ"
                                                                            : "اسئله شائعة"
                                                                        : index ==
                                                                                5
                                                                            ? LanguageClass.isEnglish
                                                                                ? "About Us"
                                                                                : "من نحن"
                                                                            : LanguageClass.isEnglish
                                                                                ? "Contact us"
                                                                                : "تواصل معنا",
                                                        style: fontStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium),
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
                            itemCount: 10),
                      )
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Navigationbottombar(currentIndex: 3),
      ),
    );
  }
}
