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
import 'package:swa/core/widgets/currency_selector.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/Allpackages_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/FAQ_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/abous_us.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/bus_class.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/contact_us.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/stations_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/terms_and_conditions_terms.dart';
import 'package:swa/features/payment/wallet/data/wallet_cubit/wallet_cubit.dart';
import 'package:swa/features/reusable_payment/presentation/cubits/Payment_Methods/payment_methods_cubit.dart';
import 'package:swa/select_payment2/data/models/Curruncy_model.dart';

import '../../../../../../../../main.dart';
import '../../../../../../../Swa_umra/Screens/Select_type.dart';
import '../../../../../../../payment/fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';
import '../../../../../../../sign_in/presentation/cubit/login_cubit.dart';
import '../../../../../../../times_trips/presentation/PLOH/times_trips_cubit.dart';
import '../../../../../cubit/home_cubit.dart';
import '../../../../Notification/Notification_screen.dart';
import '../../../my_home.dart';
import '../../../ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import '../packages/bloc/packages_bloc.dart';

//Refactor currency code , country flag ...

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

  final appsCount = CacheHelper.getDataToSharedPref(key: "appsCount");

  void updateNotificationCount(int newCount) {
    setState(() {
      count = newCount;
    });
  }

  int? count;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAvailableCountriesCubit>(context).getAvailableCountries();
    getwalllet();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isloading
            ? Center(
                child: CircularProgressIndicator(
                  color: Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
                ),
              )
            : Directionality(
                textDirection: LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: sizeHeight * 0.08,
                      ),
                      Container(
                        alignment: LanguageClass.isEnglish ? Alignment.topLeft : Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false,
                                arguments: Routes.isomra);
                          },
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
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
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            reverse: false,
                            itemBuilder: (context, index) {
                              return index == 10
                                  ? curruncylist == null
                                      ? Container()
                                      : InkWell(
                                          onTap: () {
                                            showCurrencySelector(context, currencyList: curruncylist!.message!,
                                                onCurrencySelected: (currency) {
                                              // context.read<WalletCubit>().convertWalletBalance(currency.symbol!);
                                              Routes.curruncy = currency.symbol!;
                                              Routes.curruncyId = currency.currencyId;

                                              CacheHelper.setDataToSharedPref(
                                                key: 'curruncycode',
                                                value: currency.symbol,
                                              );

                                              CacheHelper.setDataToSharedPref(
                                                key: 'curruncyId',
                                                value: currency.currencyId,
                                              );

                                              setState(() {});
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                            child: Row(
                                              children: [
                                                Text(LanguageClass.isEnglish ? " Currency " : ' عملة ',
                                                    style: fontStyle(
                                                        color: AppColors.blackColor,
                                                        fontFamily: FontFamily.medium,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 21)),
                                                Text(
                                                  CacheHelper.getDataToSharedPref(
                                                        key: 'curruncycode',
                                                      ) ??
                                                      Routes.curruncy,
                                                  style: fontStyle(
                                                      color: AppColors.blackColor,
                                                      fontFamily: FontFamily.medium,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 21),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                  : index == 9
                                      ? BlocBuilder<GetAvailableCountriesCubit, GetAvailableCountriesCubitState>(
                                          builder: (context, state) {
                                          return state is GetAvailableCountriesLoadedState
                                              ? Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showGeneralDialog(
                                                          context: context,
                                                          pageBuilder: (BuildContext buildContext,
                                                              Animation<double> animation,
                                                              Animation<double> secondaryAnimation) {
                                                            return StatefulBuilder(builder: (context, setStater) {
                                                              return Material(
                                                                color: Colors.transparent,
                                                                child: Directionality(
                                                                  textDirection: LanguageClass.isEnglish
                                                                      ? TextDirection.ltr
                                                                      : TextDirection.rtl,
                                                                  child: Container(
                                                                    alignment: Alignment.topRight,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        borderRadius: BorderRadius.only(
                                                                            bottomLeft: Radius.circular(20),
                                                                            bottomRight: Radius.circular(20))),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal: 30, vertical: 5),
                                                                    width: double.infinity,
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
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
                                                                          margin: const EdgeInsets.symmetric(
                                                                              horizontal: 20),
                                                                          child: Text(
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
                                                                          height: sizeHeight * 0.01,
                                                                        ),
                                                                        Expanded(
                                                                          child: ListView.separated(
                                                                              itemBuilder: (context, index) {
                                                                                return Column(
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment.start,
                                                                                  crossAxisAlignment:
                                                                                      CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        Routes.curruncy = state
                                                                                            .countries[index].curruncy;
                                                                                        CacheHelper.setDataToSharedPref(
                                                                                          key: 'curruncycode',
                                                                                          value: state.countries[index]
                                                                                              .curruncy,
                                                                                        );

                                                                                        Routes.country = state
                                                                                            .countries[index]
                                                                                            .countryName;
                                                                                        print(
                                                                                            "Tik Tik Countries: ${Routes.country}");
                                                                                        setStater(() {
                                                                                          log(state.countries[index]
                                                                                              .countryId
                                                                                              .toString());
                                                                                          CacheHelper
                                                                                              .setDataToSharedPref(
                                                                                            key: 'countryid',
                                                                                            value: state
                                                                                                .countries[index]
                                                                                                .countryId
                                                                                                .toString(),
                                                                                          );
                                                                                          CacheHelper
                                                                                              .setDataToSharedPref(
                                                                                            key: 'countryflag',
                                                                                            value: state
                                                                                                .countries[index].Flag,
                                                                                          );
                                                                                          Routes.countryflag = state
                                                                                              .countries[index].Flag;
                                                                                        });
                                                                                        Routes.curruncy = state
                                                                                            .countries[index].curruncy;
                                                                                        CacheHelper.setDataToSharedPref(
                                                                                          key: 'curruncycode',
                                                                                          value: state.countries[index]
                                                                                              .curruncy,
                                                                                        );

                                                                                        Navigator
                                                                                            .pushNamedAndRemoveUntil(
                                                                                                context,
                                                                                                Routes.home,
                                                                                                (route) => false,
                                                                                                arguments:
                                                                                                    Routes.isomra);
                                                                                      },
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        padding: EdgeInsets.symmetric(
                                                                                            horizontal: 10),
                                                                                        child: Text(
                                                                                          state.countries[index]
                                                                                              .countryName,
                                                                                          style: fontStyle(
                                                                                              fontFamily:
                                                                                                  FontFamily.medium,
                                                                                              color: Color(0xffA3A3A3),
                                                                                              fontSize: 18),
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
                                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 25,
                                                            child: Image.network(
                                                              // CacheHelper
                                                              //         .getDataToSharedPref(
                                                              //       key:
                                                              //           'countryflag',
                                                              //     ) ??
                                                              //     Routes
                                                              //         .countryflag,

                                                              Routes.country == "Saudi Arabia" ||
                                                                      Routes.country.trim() == 'السعودية'
                                                                  ? "https://swabus.com/Content/Dashboard/LTR/assets/img/Saudi.png"
                                                                  : "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png",
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Routes.country == "Saudi Arabia" ||
                                                                  Routes.country.trim() == 'السعودية'
                                                              ? LanguageClass.isEnglish
                                                                  ? Text(
                                                                      "Saudi Arabia",
                                                                      style: fontStyle(
                                                                          color: AppColors.blackColor,
                                                                          fontFamily: FontFamily.medium,
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: 21),
                                                                    )
                                                                  : Text(
                                                                      "السعودية",
                                                                      style: fontStyle(
                                                                          color: AppColors.blackColor,
                                                                          fontFamily: FontFamily.medium,
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: 21),
                                                                    )
                                                              : LanguageClass.isEnglish
                                                                  ? Text(
                                                                      "Egypt",
                                                                      style: fontStyle(
                                                                          color: AppColors.blackColor,
                                                                          fontFamily: FontFamily.medium,
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: 21),
                                                                    )
                                                                  : Text(
                                                                      "مصر",
                                                                      style: fontStyle(
                                                                          color: AppColors.blackColor,
                                                                          fontFamily: FontFamily.medium,
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: 21),
                                                                    ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : CacheHelper.getDataToSharedPref(
                                                        key: 'countryflag',
                                                      ) ==
                                                      null
                                                  ? Container()
                                                  : Row(
                                                      children: [
                                                        Container(
                                                          width: 25,
                                                          child: Image.network(
                                                            //     CacheHelper
                                                            //         .getDataToSharedPref(
                                                            //   key: 'countryflag',
                                                            // ),
                                                            Routes.country == "Saudi Arabia" ||
                                                                    Routes.country.trim() == 'السعودية'
                                                                ? "https://swabus.com/Content/Dashboard/LTR/assets/img/Saudi.png"
                                                                : "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png",
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          Routes.country,
                                                          style: fontStyle(
                                                              color: AppColors.blackColor,
                                                              fontFamily: FontFamily.medium,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 21),
                                                        )
                                                      ],
                                                    );
                                        })
                                      : index == 8
                                          ? DropdownButton<String>(
                                              value: dropdownValue,
                                              elevation: 16,
                                              style: fontStyle(
                                                  color: Colors.black, fontSize: 18, fontFamily: FontFamily.medium),
                                              underline: Container(),
                                              onChanged: (String? value) {
                                                if (value == list.first) {
                                                  LanguageClass.isEnglish = true;
                                                } else {
                                                  LanguageClass.isEnglish = false;
                                                }

                                                CacheHelper.setDataToSharedPref(
                                                    key: 'language', value: LanguageClass.isEnglish);

                                                setState(() {
                                                  dropdownValue = value!;
                                                });

                                                BlocProvider.of<GetAvailableCountriesCubit>(context)
                                                    .getAvailableCountries();

                                                BlocProvider.of<PaymentMethodsCubit>(context).getPaymentMethods();
                                              },
                                              items: list.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                    alignment: LanguageClass.isEnglish
                                                        ? Alignment.centerLeft
                                                        : Alignment.centerRight,
                                                    child: Text(
                                                      value,
                                                      textAlign:
                                                          LanguageClass.isEnglish ? TextAlign.left : TextAlign.right,
                                                      style: fontStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontFamily: FontFamily.arFontMedium),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                if (index == 2) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return BlocProvider<MoreCubit>(
                                                        create: (context) => MoreCubit(), child: StationScreen());
                                                  }));
                                                } else if (index == 1) {
                                                  if (Routes.customerid == null) {
                                                    Constants.showDefaultSnackBar(
                                                        context: context,
                                                        color: Colors.red,
                                                        text: LanguageClass.isEnglish
                                                            ? "Login first"
                                                            : "سجل الدخول اولا");
                                                  } else {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                      return NotificationScreen(
                                                        isScreenHome: false,
                                                        updateNotificationCount: updateNotificationCount,
                                                      );
                                                    }));
                                                  }
                                                } else if (index == 3) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return BlocProvider<MoreCubit>(
                                                        create: (context) => MoreCubit(), child: BusClasses());
                                                  }));
                                                } else if (index == 4) {
                                                  if (Routes.customerid == null) {
                                                    Constants.showDefaultSnackBar(
                                                        context: context,
                                                        color: Colors.red,
                                                        text: LanguageClass.isEnglish
                                                            ? "Login first"
                                                            : "سجل الدخول اولا");
                                                  } else {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                      return BlocProvider<MoreCubit>(
                                                          create: (context) => MoreCubit(), child: packagesScreen());
                                                    }));
                                                  }
                                                } else if (index == 5) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return BlocProvider<MoreCubit>(
                                                        create: (context) => MoreCubit(), child: FAQScreen());
                                                  }));
                                                } else if (index == 6) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return BlocProvider<MoreCubit>(
                                                        create: (context) => MoreCubit(), child: AboutUsScreen());
                                                  }));
                                                } else if (index == 7) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return BlocProvider<MoreCubit>(
                                                        create: (context) => MoreCubit(), child: ContactUs());
                                                  }));
                                                  // Navigator.push(context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) {
                                                  //   return BlocProvider<MoreCubit>(
                                                  //       create: (context) => MoreCubit(),
                                                  //       child: PrivacyScreen());
                                                  // }));
                                                } else if (index == 8) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return BlocProvider<MoreCubit>(
                                                        create: (context) => MoreCubit(),
                                                        child: TermsConditionsScreen());
                                                  }));
                                                } else if (index == 9) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return BlocProvider<MoreCubit>(
                                                        create: (context) => MoreCubit(), child: ContactUs());
                                                  }));
                                                } else if (index == 0) {
                                                  // UmraDetails.isbusforumra = false;
                                                  // Navigator.pushNamedAndRemoveUntil(
                                                  //     context, Routes.home, (route) => false,
                                                  //     arguments: !Routes.isomra);
                                                  // Routes.isomra = !Routes.isomra;

                                                  if (int.parse(appsCount.toString()) > 1) {
                                                    Routes.isomra
                                                        ? {
                                                            Routes.isomra = false,
                                                            Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => MultiBlocProvider(providers: [
                                                                        BlocProvider<LoginCubit>(
                                                                          create: (context) => sl<LoginCubit>(),
                                                                        ),
                                                                        BlocProvider<PackagesBloc>(
                                                                          create: (context) => PackagesBloc(),
                                                                        ),
                                                                        BlocProvider<FawryReservation>(
                                                                          create: (context) => sl<FawryReservation>(),
                                                                        ),
                                                                        BlocProvider<GetAvailableCountriesCubit>(
                                                                          create: (context) =>
                                                                              sl<GetAvailableCountriesCubit>(),
                                                                        ),
                                                                        BlocProvider<HomeCubit>(
                                                                          create: (context) => sl<HomeCubit>(),
                                                                        ),
                                                                        BlocProvider<TimesTripsCubit>(
                                                                            create: (context) => sl<TimesTripsCubit>()),
                                                                        BlocProvider<TicketCubit>(
                                                                            create: (context) => sl<TicketCubit>()),
                                                                      ], child: MyHome())),
                                                              (route) => false,
                                                            ),
                                                          }
                                                        : {
                                                            Routes.isomra = true,
                                                            Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => MultiBlocProvider(providers: [
                                                                        BlocProvider<LoginCubit>(
                                                                          create: (context) => sl<LoginCubit>(),
                                                                        ),
                                                                        BlocProvider<PackagesBloc>(
                                                                          create: (context) => PackagesBloc(),
                                                                        ),
                                                                        BlocProvider<FawryReservation>(
                                                                          create: (context) => sl<FawryReservation>(),
                                                                        ),
                                                                        BlocProvider<GetAvailableCountriesCubit>(
                                                                          create: (context) =>
                                                                              sl<GetAvailableCountriesCubit>(),
                                                                        ),
                                                                        BlocProvider<HomeCubit>(
                                                                          create: (context) => sl<HomeCubit>(),
                                                                        ),
                                                                        BlocProvider<TimesTripsCubit>(
                                                                            create: (context) => sl<TimesTripsCubit>()),
                                                                        BlocProvider<TicketCubit>(
                                                                            create: (context) => sl<TicketCubit>()),
                                                                      ], child: SelectUmratypeScreen())),
                                                              (route) => false,
                                                            ),
                                                          };
                                                  }
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                child: index == 0
                                                    ?
                                                    //SizedBox()
                                                    int.parse(appsCount.toString()) > 1
                                                        ? Routes.isomra
                                                            ? Container(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      LanguageClass.isEnglish ? "Swa Bus" : "سوا باص",
                                                                      style: fontStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 18,
                                                                          fontFamily: FontFamily.medium),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Container(
                                                                        width: 40,
                                                                        alignment: Alignment.center,
                                                                        padding: const EdgeInsets.all(5),
                                                                        decoration: BoxDecoration(
                                                                          color: AppColors.white,
                                                                        ),
                                                                        child: SvgPicture.asset(
                                                                            'assets/images/Icon awesome-bus-alt.svg')),
                                                                  ],
                                                                ),
                                                              )
                                                            : Container(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      LanguageClass.isEnglish
                                                                          ? "Swa Umrah"
                                                                          : "سوا عمرة",
                                                                      style: fontStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 18,
                                                                          fontFamily: FontFamily.medium),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Container(
                                                                        height: 30,
                                                                        alignment: Alignment.center,
                                                                        padding: const EdgeInsets.all(5),
                                                                        decoration: BoxDecoration(
                                                                          color: AppColors.white,
                                                                        ),
                                                                        child: Image.asset('assets/images/umrah.png')),
                                                                  ],
                                                                ),
                                                              )
                                                        : SizedBox.shrink()
                                                    : Text(
                                                        index == 1
                                                            ? LanguageClass.isEnglish
                                                                ? "Notifications"
                                                                : "الاشعارات"
                                                            : index == 2
                                                                ? LanguageClass.isEnglish
                                                                    ? "Lines"
                                                                    : "خطوط"
                                                                : index == 3
                                                                    ? LanguageClass.isEnglish
                                                                        ? "Bus classes"
                                                                        : "انواع الاتوبيس"
                                                                    : index == 4
                                                                        ? LanguageClass.isEnglish
                                                                            ? "Packages"
                                                                            : "الباقات"
                                                                        : index == 5
                                                                            ? LanguageClass.isEnglish
                                                                                ? "FAQ"
                                                                                : "اسئله شائعة"
                                                                            : index == 6
                                                                                ? LanguageClass.isEnglish
                                                                                    ? "About Us"
                                                                                    : "من نحن"
                                                                                : LanguageClass.isEnglish
                                                                                    ? "Contact us"
                                                                                    : "تواصل معنا",
                                                        style: fontStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontFamily: FontFamily.medium),
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
        bottomNavigationBar: Navigationbottombar(currentIndex: 3),
      ),
    );
  }
}
