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
import '../../features/home/presentation/screens/tabs/more_tap/presentation/packages/payment_packages/cardpayment_packages.dart';
import '../local_cache_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// //
// Future determinePosition(BuildContext context, List<Country> countries) async {
//   bool? isCountryChoosen =
//       CacheHelper.getDataToSharedPref(key: 'isCountryChoosen');
//   if (isCountryChoosen == true) {
//     return null;
//   }
//   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//
//   while (!serviceEnabled) {
//     await showDoneConfirmationDialog(
//       context,
//       message: LanguageClass.isEnglish
//           ? "Please enable location services to continue."
//           : "برجاء فتح خدمة الموقع للاستكمال",
//       isError: true,
//       callback: () async {
//         await Geolocator.openLocationSettings().then((value) async {
//           log("Location value: ${value.toString()}");
//           serviceEnabled = await Geolocator.isLocationServiceEnabled();
//         });
//       },
//     );
//
//     // Wait for the user to enable location services
//     for (int i = 0; i < 20; i++) {
//       await Future.delayed(Duration(milliseconds: 500));
//       serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (serviceEnabled) break;
//     }
//   }
//
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied ||
//       permission == LocationPermission.deniedForever ||
//       permission == LocationPermission.unableToDetermine) {
//     print("A77med permission: ${permission}");
//     permission = await Geolocator.requestPermission();
//   }
//
//   // CacheHelper.setDataToSharedPref(key: 'locationPermission', value: true);
//
//   if (permission == LocationPermission.whileInUse ||
//       permission == LocationPermission.always) {
//     final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.medium);
//
//     final placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     final countryName = placemarks.first.country!;
//
//     print("A7med Country Name: $countryName");
//     Routes.countryname = countryName;
//
//     print("COUNTRY ISO: ${placemarks.first.isoCountryCode}");
//
//     final matchedCountry = countries.firstWhere(
//       (c) => c.countryName.toLowerCase().contains(countryName.toLowerCase()),
//       orElse: () => CountryModel(
//         countryId: 1,
//         countryName: "Egypt",
//         Code: "1",
//         Flag: "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png",
//         curruncy: "EGP",
//       ),
//     );
//     print("COUNTRY ISO: ${placemarks.first.isoCountryCode}");
//
//     CacheHelper.setDataToSharedPref(
//         key: 'countryid', value: matchedCountry.countryId);
//     CacheHelper.setDataToSharedPref(
//         key: 'defaultCountryID', value: matchedCountry.countryId);
//     CacheHelper.setDataToSharedPref(
//         key: 'countryflag',
//         value: matchedCountry.countryId == 1
//             ? "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png"
//             : "https://swabus.com/Content/Dashboard/LTR/assets/img/Saudi.png");
//     CacheHelper.setDataToSharedPref(
//         key: 'curruncycode', value: matchedCountry.curruncy);
//
//     Curruncylist curruncylist = await PackagesRespo().GetallCurrency();
//
//     var currencyId = curruncylist.message
//         ?.where((element) =>
//             element.symbol!.toLowerCase() ==
//             matchedCountry.curruncy.toLowerCase())
//         .first
//         .code;
//
//     CacheHelper.setDataToSharedPref(key: 'curruncyId', value: currencyId);
//
//     CacheHelper.setDataToSharedPref(
//         key: 'country', value: matchedCountry.countryName);
//
//     print("Tik Tik SET $matchedCountry.countryName");
//
//     print("CURRUNCYID SET $currencyId");
//
//     Routes.countryflag = matchedCountry.countryId == 1
//         ? "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png"
//         : "https://swabus.com/Content/Dashboard/LTR/assets/img/Saudi.png";
//     Routes.curruncy = matchedCountry.curruncy;
//     Routes.curruncyId = currencyId;
//
//     print("TIKTIK Currency ID: ${matchedCountry.countryId}");
//
//     Routes.country = matchedCountry.countryName;
//     log("Location determined: ${Routes.country}");
//     return position;
//   }
// }
//
// Future<dynamic> showDoneConfirmationDialog(BuildContext context,
//     {required String message,
//     bool isError = false,
//     Widget? body,
//     required Function callback}) async {
//   return await showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (dialogContext) => WillPopScope(
//       onWillPop: () async => false,
//       child: AlertDialog(
//         content: Container(
//           decoration: BoxDecoration(
//               color: Colors.white, borderRadius: BorderRadius.circular(8)),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                   height: 80,
//                   alignment: Alignment.center,
//                   child: Lottie.asset('assets/json/Warning.json')),
//               const SizedBox(height: 10),
//               Center(
//                 child: Text(
//                   LanguageClass.isEnglish ? 'Warning' : 'تحذير',
//                   style: fontStyle(
//                       fontFamily: FontFamily.bold,
//                       fontSize: 18,
//                       color: Colors.black),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Center(
//                 child: Text(
//                   message,
//                   textAlign: TextAlign.center,
//                   style: fontStyle(
//                       fontFamily: FontFamily.medium,
//                       color: Colors.black,
//                       fontSize: 14),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(dialogContext);
//                     callback();
//                   },
//                   style: ElevatedButton.styleFrom(
//                       elevation: 0,
//                       backgroundColor: AppColors.primaryColor,
//                       textStyle: TextStyle(color: Colors.white)),
//                   child: Container(
//                       child: Container(
//                           width: 50,
//                           height: 20,
//                           alignment: Alignment.center,
//                           child: Text(
//                             "ok",
//                             style: fontStyle(
//                                 color: Colors.white,
//                                 fontFamily: FontFamily.bold),
//                           ))))
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
/// ------------
// Future determinePosition(BuildContext context, List<Country> countries) async {
//   bool? isCountryChoosen =
//       CacheHelper.getDataToSharedPref(key: 'isCountryChoosen');
//   if (isCountryChoosen == true) {
//     return null;
//   }
//
//   try {
//     Position? position = await _tryGetGPSLocation(context);
//     if (position != null) {
//       await _setCountryFromPosition(position, countries);
//       return position;
//     }
//   } catch (e) {
//     print("GPS location failed: $e");
//   }
//
//   print("Trying to get country from IP...");
//   try {
//     Map<String, dynamic>? ipData = await _getCountryFromIP();
//     if (ipData != null) {
//       String countryCode = ipData['country_code'] ?? '';
//       String countryName = ipData['country_name'] ?? '';
//
//       print("IP Detection Result - Code: $countryCode, Name: $countryName");
//
//       if (countryCode.isNotEmpty) {
//         await _setCountryFromCode(countryCode, countryName, countries);
//         return null;
//       }
//     }
//   } catch (e) {
//     print("IP location failed: $e");
//   }
//
//   print("Trying to get country from device locale...");
//   try {
//     String? countryCode = _getCountryFromLocale();
//     print("Locale Detection Result: $countryCode");
//
//     if (countryCode != null) {
//       await _setCountryFromCode(countryCode, '', countries);
//       return null;
//     }
//   } catch (e) {
//     print("Locale failed: $e");
//   }
//
//   print("Using default country: Egypt");
//   await _setDefaultCountry(countries);
//   return null;
// }
//
// Future<Position?> _tryGetGPSLocation(BuildContext context) async {
//   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//
//   if (!serviceEnabled) {
//     await showDoneConfirmationDialog(
//       context,
//       message: LanguageClass.isEnglish
//           ? "Please enable location services to continue."
//           : "برجاء فتح خدمة الموقع للاستكمال",
//       isError: true,
//       callback: () async {
//         await Geolocator.openLocationSettings();
//       },
//     );
//
//     for (int i = 0; i < 20; i++) {
//       await Future.delayed(Duration(milliseconds: 500));
//       serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (serviceEnabled) break;
//     }
//
//     if (!serviceEnabled) {
//       print("Location service not enabled");
//       return null;
//     }
//   }
//
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied ||
//       permission == LocationPermission.unableToDetermine) {
//     permission = await Geolocator.requestPermission();
//   }
//
//   if (permission == LocationPermission.denied ||
//       permission == LocationPermission.deniedForever) {
//     print("Location permission denied - will try alternative methods");
//     return null;
//   }
//
//   if (permission == LocationPermission.whileInUse ||
//       permission == LocationPermission.always) {
//     try {
//       return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.medium,
//         timeLimit: Duration(seconds: 10),
//       );
//     } catch (e) {
//       print("Error getting position: $e");
//       return null;
//     }
//   }
//
//   return null;
// }
//
// Future<Map<String, dynamic>?> _getCountryFromIP() async {
//   try {
//     print("Trying ipapi.co...");
//     final response = await http
//         .get(
//           Uri.parse('https://ipapi.co/json/'),
//         )
//         .timeout(Duration(seconds: 8));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       print("ipapi.co response: ${data}");
//
//       return {
//         'country_code': data['country_code'],
//         'country_name': data['country_name'],
//       };
//     }
//   } catch (e) {
//     print("ipapi.co error: $e");
//   }
//
//   try {
//     print("Trying ip-api.com...");
//     final response = await http
//         .get(
//           Uri.parse(
//               'http://ip-api.com/json/?fields=status,country,countryCode'),
//         )
//         .timeout(Duration(seconds: 8));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       print("ip-api.com response: ${data}");
//
//       if (data['status'] == 'success') {
//         return {
//           'country_code': data['countryCode'],
//           'country_name': data['country'],
//         };
//       }
//     }
//   } catch (e) {
//     print("ip-api.com error: $e");
//   }
//
//   try {
//     print("Trying ipinfo.io...");
//     final response = await http
//         .get(
//           Uri.parse('https://ipinfo.io/json'),
//         )
//         .timeout(Duration(seconds: 8));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       print("ipinfo.io response: ${data}");
//
//       return {
//         'country_code': data['country'],
//         'country_name': _getCountryNameFromCode(data['country']),
//       };
//     }
//   } catch (e) {
//     print("ipinfo.io error: $e");
//   }
//
//   return null;
// }
//
// String? _getCountryFromLocale() {
//   try {
//     final locale = Platform.localeName;
//     print("Platform.localeName: $locale");
//
//     if (locale.contains('_')) {
//       String code = locale.split('_').last;
//       print("Extracted country code from locale: $code");
//       return code;
//     }
//   } catch (e) {
//     print("Locale error: $e");
//   }
//   return null;
// }
//
// Future<void> _setCountryFromPosition(
//     Position position, List<Country> countries) async {
//   try {
//     final placemarks = await placemarkFromCoordinates(
//       position.latitude,
//       position.longitude,
//     );
//     final countryName = placemarks.first.country!;
//     final countryCode = placemarks.first.isoCountryCode ?? '';
//
//     print("✅ Country from GPS: $countryName ($countryCode)");
//     Routes.countryname = countryName;
//
//     await _saveCountryData(countryName, countryCode, countries);
//   } catch (e) {
//     print("Error getting country from position: $e");
//   }
// }
//
// Future<void> _setCountryFromCode(
//     String countryCode, String countryName, List<Country> countries) async {
//   if (countryName.isEmpty) {
//     countryName = _getCountryNameFromCode(countryCode);
//   }
//
//   print("✅ Country from code: $countryName ($countryCode)");
//   Routes.countryname = countryName;
//
//   await _saveCountryData(countryName, countryCode, countries);
// }
//
// String _getCountryNameFromCode(String countryCode) {
//   switch (countryCode.toUpperCase()) {
//     case 'EG':
//       return 'Egypt';
//     case 'SA':
//       return 'Saudi Arabia';
//     case 'AE':
//       return 'United Arab Emirates';
//     case 'US':
//       return 'United States';
//     case 'GB':
//       return 'United Kingdom';
//     case 'DE':
//       return 'Germany';
//     case 'FR':
//       return 'France';
//     default:
//       return 'Egypt'; // Default
//   }
// }
//
// Future<void> _saveCountryData(
//     String countryName, String? countryCode, List<Country> countries) async {
//   print("Searching for country in list: $countryName");
//
//   final matchedCountry = countries.firstWhere(
//     (c) {
//       bool matches =
//           c.countryName.toLowerCase().contains(countryName.toLowerCase()) ||
//               countryName.toLowerCase().contains(c.countryName.toLowerCase());
//       print("Comparing: ${c.countryName} with $countryName = $matches");
//       return matches;
//     },
//     orElse: () {
//       print("No match found, using default Egypt");
//       return CountryModel(
//         countryId: 1,
//         countryName: "Egypt",
//         Code: "1",
//         Flag: "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png",
//         curruncy: "EGP",
//       );
//     },
//   );
//
//   print(
//       "✅ Final matched country: ${matchedCountry.countryName} (ID: ${matchedCountry.countryId})");
//
//   CacheHelper.setDataToSharedPref(
//       key: 'countryid', value: matchedCountry.countryId);
//   CacheHelper.setDataToSharedPref(
//       key: 'defaultCountryID', value: matchedCountry.countryId);
//   CacheHelper.setDataToSharedPref(
//       key: 'countryflag',
//       value: matchedCountry.countryId == 1
//           ? "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png"
//           : "https://swabus.com/Content/Dashboard/LTR/assets/img/Saudi.png");
//   CacheHelper.setDataToSharedPref(
//       key: 'curruncycode', value: matchedCountry.curruncy);
//
//   Curruncylist curruncylist = await PackagesRespo().GetallCurrency();
//
//   var currencyId = curruncylist.message
//       ?.where((element) =>
//           element.symbol!.toLowerCase() ==
//           matchedCountry.curruncy.toLowerCase())
//       .first
//       .code;
//
//   CacheHelper.setDataToSharedPref(key: 'curruncyId', value: currencyId);
//   CacheHelper.setDataToSharedPref(
//       key: 'country', value: matchedCountry.countryName);
//
//   Routes.countryflag = matchedCountry.countryId == 1
//       ? "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png"
//       : "https://swabus.com/Content/Dashboard/LTR/assets/img/Saudi.png";
//   Routes.curruncy = matchedCountry.curruncy;
//   Routes.curruncyId = currencyId;
//   Routes.country = matchedCountry.countryName;
//
//   print("💾 Country data saved successfully!");
// }
//
// Future<void> _setDefaultCountry(List<Country> countries) async {
//   print("⚠️ Using default country: Egypt");
//   await _saveCountryData('Egypt', 'EG', countries);
// }

Future determinePosition(BuildContext context, List<Country> countries) async {
  bool? isCountryChoosen =
      CacheHelper.getDataToSharedPref(key: 'isCountryChoosen');
  if (isCountryChoosen == true) {
    return null;
  }

  print("🚀 Getting country from device settings...");
  String? countryCode = _getCountryFromDeviceSettings();

  if (countryCode != null && countryCode.isNotEmpty) {
    print("✅ Country from device: $countryCode");
    await _setCountryFromCode(countryCode, countries);

    _updateLocationInBackground(context, countries);

    return null;
  }

  print("⚠️ Locale failed, trying GPS...");
  try {
    Position? position = await _tryGetGPSLocation(context);
    if (position != null) {
      await _setCountryFromPosition(position, countries);
      return position;
    }
  } catch (e) {
    print("GPS failed: $e");
  }

  print("⚠️ Using default: Egypt");
  await _setDefaultCountry(countries);
  return null;
}

String? _getCountryFromDeviceSettings() {
  try {
    final locale = Platform.localeName;
    print("Platform.localeName: $locale");

    if (locale.contains('_')) {
      return locale.split('_').last.toUpperCase();
    }

    final localeEnv = Platform.environment['LANG'];
    print("Environment LANG: $localeEnv");

    if (localeEnv != null && localeEnv.contains('_')) {
      String code = localeEnv.split('_')[1].split('.').first;
      return code.toUpperCase();
    }
  } catch (e) {
    print("Error getting locale: $e");
  }
  return null;
}

void _updateLocationInBackground(
    BuildContext context, List<Country> countries) async {
  await Future.delayed(Duration(seconds: 2));

  try {
    Position? position = await _tryGetGPSLocation(context);
    if (position != null) {
      await _setCountryFromPosition(position, countries);
      print("🔄 Location updated in background");
    }
  } catch (e) {
    print("Background GPS update failed: $e");
  }
}

Future<Position?> _tryGetGPSLocation(BuildContext context) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return null;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.unableToDetermine) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return null;
  }

  if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 5),
      );
    } catch (e) {
      print("Error getting position: $e");
      return null;
    }
  }

  return null;
}

Future<void> _setCountryFromPosition(
    Position position, List<Country> countries) async {
  try {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final countryName = placemarks.first.country!;
    final countryCode = placemarks.first.isoCountryCode ?? '';

    print("✅ GPS Country: $countryName ($countryCode)");
    Routes.countryname = countryName;

    await _saveCountryData(countryName, countries);
  } catch (e) {
    print("Error: $e");
  }
}

Future<void> _setCountryFromCode(
    String countryCode, List<Country> countries) async {
  String countryName = _getCountryNameFromCode(countryCode);

  print("✅ Device Country: $countryName ($countryCode)");
  Routes.countryname = countryName;

  await _saveCountryData(countryName, countries);
}

String _getCountryNameFromCode(String countryCode) {
  switch (countryCode.toUpperCase()) {
    case 'EG':
      return 'Egypt';
    case 'SA':
      return 'Saudi Arabia';
    default:
      return 'Egypt';
  }
}

Future<void> _saveCountryData(
    String countryName, List<Country> countries) async {
  print("Searching for: $countryName");

  final matchedCountry = countries.firstWhere(
    (c) =>
        c.countryName.toLowerCase() == countryName.toLowerCase() ||
        c.countryName.toLowerCase().contains(countryName.toLowerCase()) ||
        countryName.toLowerCase().contains(c.countryName.toLowerCase()),
    orElse: () => CountryModel(
      countryId: 1,
      countryName: "Egypt",
      Code: "1",
      Flag: "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png",
      curruncy: "EGP",
    ),
  );

  print("✅ Matched: ${matchedCountry.countryName}");

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

  Routes.countryflag = matchedCountry.countryId == 1
      ? "https://swabus.com/Content/Dashboard/LTR/assets/img/Egypt.png"
      : "https://swabus.com/Content/Dashboard/LTR/assets/img/Saudi.png";
  Routes.curruncy = matchedCountry.curruncy;
  Routes.curruncyId = currencyId;
  Routes.country = matchedCountry.countryName;

  print("💾 Saved!");
}

// Default
Future<void> _setDefaultCountry(List<Country> countries) async {
  await _saveCountryData('Egypt', countries);
}
