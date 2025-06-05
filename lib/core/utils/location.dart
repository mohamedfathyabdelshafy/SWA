import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/select_payment2/data/models/Curruncy_model.dart';
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

Future<Position> determinePosition(
    BuildContext context, List<Country> countries) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  while (!serviceEnabled) {
    await showDoneConfirmationDialog(
      context,
      message: LanguageClass.isEnglish
          ? "Please enable location services to continue."
          : "برجاء فتح خدمة الموقع للاستكمال",
      isError: true,
      callback: () async {
        await Geolocator.openLocationSettings();
      },
    );

    await Future.delayed(Duration(seconds: 3));
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
  }

  CacheHelper.setDataToSharedPref(key: 'locationPermission', value: true);

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied.');
  }

  if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);

    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final countryName =
        placemarks.first.country?.toLowerCase() == "united states"
            ? "Egypt"
            : placemarks.first.country!;
    Routes.countryname = countryName;

    print("COUNTRY ISO: ${placemarks.first.isoCountryCode}");

    final matchedCountry = countries.firstWhere(
      (c) => c.countryName.toLowerCase().contains(countryName.toLowerCase()),
      orElse: () => CountryModel(
        countryId: 3,
        countryName: "Saudi Arabia",
        Code: "3",
        Flag: "https://swabus.com/Content/Dashboard/LTR/assets/img/Saudi.png",
        curruncy: "SAR",
      ),
    );

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

    print("CURRUNCYID SET $currencyId");

    Routes.countryflag = matchedCountry.countryId == 1
        ? "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png"
        : "https://swabus.com/Content/Dashboard/LTR/assets/img/Saudi.png";
    Routes.curruncy = matchedCountry.curruncy;
    Routes.curruncyId = currencyId;

    print("TIKTIK Currency ID: ${Routes.curruncyId}");

    Routes.country = matchedCountry.countryName;
    log("Location determined: ${Routes.country}");
    return position;
  }

  return Future.error('Failed to get valid location permissions.');
}

Future<dynamic> showDoneConfirmationDialog(BuildContext context,
    {required String message,
    bool isError = false,
    Widget? body,
    required Function callback}) async {
  return CoolAlert.show(
    barrierDismissible: false,
    context: context,
    confirmBtnText: "OK",
    title: isError
        ? LanguageClass.isEnglish
            ? 'Warning'
            : 'تحذير'
        : '',
    lottieAsset: 'assets/json/Warning.json',
    type: isError ? CoolAlertType.error : CoolAlertType.success,
    loopAnimation: false,
    backgroundColor: Colors.white,
    text: message,
    widget: body,
    onConfirmBtnTap: () {
      callback(); // Execute the callback function after tapping OK
    },
  );
}
