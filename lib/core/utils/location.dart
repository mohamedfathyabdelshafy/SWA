import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/Country_list.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/data/models/Curruncy_model.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/navigation_helper.dart';
import 'dart:developer';

import '../../config/routes/app_routes.dart';
import '../../features/app_info/data/models/country_model.dart';
import '../../features/app_info/domain/entities/country.dart';
import '../../features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import '../../features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import '../local_cache_helper.dart';

// Future<Position> determinePosition(BuildContext context) async {
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//
//   bool? isFirst = CacheHelper.getDataToSharedPref(key: 'locationPermission');
//
//   // Loop to keep checking if the location services are enabled after opening settings
//   while (!serviceEnabled && isFirst == null) {
//     // Show the custom dialog for enabling location services
//     await showDoneConfirmationDialog(context,
//         message: LanguageClass.isEnglish
//             ? "Please enable location services to continue."
//             : "برجاء فتح خدمة الموقع للاستكمال",
//         isError:
//             true, // Shows error alert with an icon (you can customize this)
//         callback: () async {
//       await Geolocator.openLocationSettings(); // Open location settings
//     });
//
//     // Delay to give user some time to open settings and enable the location
//     await Future.delayed(
//         Duration(seconds: 3)); // Small delay to avoid fast loop
//     serviceEnabled =
//         await Geolocator.isLocationServiceEnabled(); // Check if enabled
//   }
//
//   // Permissions check
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied ||
//       permission == LocationPermission.deniedForever) {
//     bool? isFirst = CacheHelper.getDataToSharedPref(key: 'locationPermission');
//
//     print("TIK TIK IS FIRST FROM LOCATION ${isFirst}");
//
//     if (isFirst == null) {
//       permission = await Geolocator.requestPermission();
//       CacheHelper.setDataToSharedPref(key: 'locationPermission', value: true);
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     print('Location permissions are permanently denied.');
//     return Future.error('Location permissions are permanently denied.');
//   }
//
//   if (permission == LocationPermission.whileInUse ||
//       permission == LocationPermission.always) {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.medium,
//     );
//
//     print(
//         "Tik Tik Accurate location: ${position.latitude} , ${position.longitude}");
//
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//
//     log("Placemarks ${placemarks[0].country!}");
//
//     Routes.countryname = placemarks[0].country!.toLowerCase() == "united states"
//         ? "Egypt"
//         : placemarks[0].country!;
//
//     log("Tik Tik Placemarks ${Routes.countryname}");
//
//     CacheHelper.setDataToSharedPref(
//         key: 'defaultCountryID', value: Routes.countryname == "Egypt" ? 1 : 3);
//
//     CacheHelper.setDataToSharedPref(
//         key: 'countryid', value: Routes.countryname == "Egypt" ? 1 : 3);
//
//     // BlocProvider.of<GetAvailableCountriesCubit>(context)
//     //     .getAvailableCountries();
//
//     return position;
//   } else {
//     Routes.countryname = 'Saudi Arabia';
//
//     return Position(
//       accuracy: 0,
//       altitude: 0,
//       heading: 0,
//       latitude: 0,
//       longitude: 0,
//       speed: 0,
//       speedAccuracy: 0,
//       timestamp: DateTime.now(),
//       altitudeAccuracy: 0,
//       headingAccuracy: 0,
//     );
//   }
// }

Future determinePosition(BuildContext context, List<Country> countries) async {
  bool? isCountryChoosen = CacheHelper.getDataToSharedPref(key: 'isCountryChoosen');
  if (isCountryChoosen == true) {
    return null;
  }
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  while (!serviceEnabled) {
    await showDoneConfirmationDialog(
      context,
      message: LanguageClass.isEnglish
          ? "Please enable location services to continue."
          : "برجاء فتح خدمة الموقع للاستكمال",
      isError: true,
      callback: () async {
        await Geolocator.openLocationSettings().then((value) async {
          log("Location value: ${value.toString()}");
          serviceEnabled = await Geolocator.isLocationServiceEnabled();
        });
      },
    );

    // Wait for the user to enable location services
    for (int i = 0; i < 20; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) break;
    }
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever ||
      permission == LocationPermission.unableToDetermine) {
    print("A77med permission: ${permission}");
    permission = await Geolocator.requestPermission();
  }

  // CacheHelper.setDataToSharedPref(key: 'locationPermission', value: true);

  if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);

    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final countryName = placemarks.first.country!;

    print("A7med Country Name: $countryName");
    Routes.countryname = countryName;

    print("COUNTRY ISO: ${placemarks.first.isoCountryCode}");

    final matchedCountry = countries.firstWhere(
      (c) => c.countryName.toLowerCase().contains(countryName.toLowerCase()),
      orElse: () => CountryModel(
        countryId: 1,
        countryName: "Egypt",
        Code: "1",
        Flag: "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png",
        curruncy: "EGP",
      ),
    );
    print("COUNTRY ISO: ${placemarks.first.isoCountryCode}");

    CacheHelper.setDataToSharedPref(
        key: 'countryid', value: matchedCountry.countryId);
    CacheHelper.setDataToSharedPref(
        key: 'defaultCountryID', value: matchedCountry.countryId);
    CacheHelper.setDataToSharedPref(
        key: 'countryflag',
        value: matchedCountry.countryId == 1
            ? "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png"
            : "https://swabus.com/Content/Dashboard/LTR/assets/img/Saudi.png");
    CacheHelper.setDataToSharedPref(
        key: 'curruncycode', value: matchedCountry.curruncy);

    Curruncylist curruncylist = await PackagesRespo().GetallCurrency();

    var currencyId = curruncylist.message
        ?.where((element) =>
            element.symbol!.toLowerCase() ==
            matchedCountry.curruncy.toLowerCase())
        .first
        .code;

    CacheHelper.setDataToSharedPref(key: 'curruncyId', value: currencyId);

    CacheHelper.setDataToSharedPref(
        key: 'country', value: matchedCountry.countryName);

    print("Tik Tik SET $matchedCountry.countryName");

    print("CURRUNCYID SET $currencyId");

    Routes.countryflag = matchedCountry.countryId == 1
        ? "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png"
        : "https://swabus.com/Content/Dashboard/LTR/assets/img/Saudi.png";
    Routes.curruncy = matchedCountry.curruncy;
    Routes.curruncyId = currencyId;

    print("TIKTIK Currency ID: ${matchedCountry.countryId}");

    Routes.country = matchedCountry.countryName;
    log("Location determined: ${Routes.country}");
    return position;
  }
}

Future<dynamic> showDoneConfirmationDialog(BuildContext context,
    {required String message,
    bool isError = false,
    Widget? body,
    required Function callback}) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (dialogContext) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        content: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: Lottie.asset('assets/json/Warning.json')),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  LanguageClass.isEnglish ? 'Warning' : 'تحذير',
                  style: fontStyle(
                      fontFamily: FontFamily.bold,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: fontStyle(
                      fontFamily: FontFamily.medium,
                      color: Colors.black,
                      fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    callback();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primaryColor,
                      textStyle: TextStyle(color: Colors.white)),
                  child: Container(
                      child: Container(
                          width: 50,
                          height: 20,
                          alignment: Alignment.center,
                          child: Text(
                            "ok",
                            style: fontStyle(
                                color: Colors.white,
                                fontFamily: FontFamily.bold),
                          ))))
            ],
          ),
        ),
      ),
    ),
  );
}
