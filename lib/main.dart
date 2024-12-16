import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swa/bloc_observer.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_strings.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/location.dart';
import 'package:swa/features/app_info/app_info_injection_container.dart';
import 'package:swa/features/change_password/change_password_injection_container.dart';
import 'package:swa/features/forgot_password/forgot_password_injection_container.dart';
import 'package:swa/features/home/home_injection_container.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/ticket_injection_container.dart';
import 'package:swa/features/payment/electronic_wallet/eWallet_injection_container.dart';
import 'package:swa/features/payment/fawry/fawry_injection_container.dart';
import 'package:swa/features/sign_in/signin_injection_container.dart';
import 'package:swa/features/sign_up/signup_injection_container.dart';
import 'package:swa/injection_container.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/navigation_helper.dart';

import 'core/local_cache_helper.dart';
import 'package:geolocator/geolocator.dart' as geo;

import 'features/times_trips/times_trips_injection_container.dart';

final sl = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  geo.Geolocator.getServiceStatusStream()
      .listen((geo.ServiceStatus status) async {
    if (await Permission.location.isDenied ||
        await Permission.location.isPermanentlyDenied) {
      Permission.location.request();

      if (await Permission.location.isDenied ||
          await Permission.location.isPermanentlyDenied) {}
    }
  });

  ///Authorization Screens
  await loginDependencyInjectionInit(); //For initializing login
  await registerDependencyInjectionInit(); //For initializing register
  await appInfoDependencyInjectionContainerInit();
  await forgotPasswordDependencyInjectionInit(); //For initializing forgot password
  await changePasswordDependencyInjectionInit(); //For initializing change password
  await homeDependencyInjectionInit(); //For initializing Home
  await fawryDependencyInjectionInit(); //For initializing Fawry
  await eWalletDependencyInjectionInit(); //For initializing E-Wallet
  await TimesTripInjectionInit();
  await TicketHistoryInjectionInit();
  await dependencyInjectionInit();
  //For initializing network info and shared preferences
  await CacheHelper.init();
  LanguageClass.isEnglish =
      await CacheHelper.getDataToSharedPref(key: 'language') ?? true;
  await CacheHelper.deleteDataToSharedPref(key: 'tripOneId');
  await CacheHelper.deleteDataToSharedPref(key: 'tripRoundId');
  await CacheHelper.deleteDataToSharedPref(key: 'countSeats');
  await CacheHelper.deleteDataToSharedPref(key: 'countSeats2');
  await CacheHelper.deleteDataToSharedPref(key: 'numberTrip');
  await CacheHelper.deleteDataToSharedPref(key: "elite");
  await CacheHelper.deleteDataToSharedPref(key: "accessBusTime");
  await CacheHelper.deleteDataToSharedPref(key: "lineName");
  await CacheHelper.deleteDataToSharedPref(key: 'numberTrip2');
  await CacheHelper.deleteDataToSharedPref(key: "elite2");
  await CacheHelper.deleteDataToSharedPref(key: "accessBusTime2");
  await CacheHelper.deleteDataToSharedPref(key: "lineName2");
  runApp(const MyApp());
  Bloc.observer = AppBlocObserver();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        useInheritedMediaQuery: true,
        minTextAdapt: true,
        splitScreenMode: false,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return MaterialApp(
            title: AppStrings.appName,
            navigatorKey: NavHelper().navigatorKey,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: AppRoute.onGenerateRoute,
          );
        });
  }
}
