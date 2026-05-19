import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get_it/get_it.dart';
import 'package:swa/bloc_observer.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/utils/app_strings.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/notifcation_services.dart';
import 'package:swa/features/app_info/app_info_injection_container.dart';
import 'package:swa/features/change_password/change_password_injection_container.dart';
import 'package:swa/features/forgot_password/forgot_password_injection_container.dart';
import 'package:swa/features/home/home_injection_container.dart';
import 'package:swa/features/home/presentation/screens/Notification/bloc/notification_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/ticket_injection_container.dart';
import 'package:swa/features/new_statistics.dart/bloc/statistics_bloc.dart';
import 'package:swa/features/payment/electronic_wallet/eWallet_injection_container.dart';
import 'package:swa/features/payment/fawry/fawry_injection_container.dart';
import 'package:swa/features/payment/wallet/data/repo/my_wallet_repo.dart';
import 'package:swa/features/payment/wallet/data/wallet_cubit/wallet_cubit.dart';
import 'package:swa/features/reusable_payment/data/repo/payment_methods_repo.dart';
import 'package:swa/features/reusable_payment/presentation/cubits/Payment_Methods/payment_methods_cubit.dart';
import 'package:swa/features/sign_in/signin_injection_container.dart';
import 'package:swa/features/sign_up/presentation/cubit/register_cubit.dart';
import 'package:swa/features/sign_up/signup_injection_container.dart';
import 'package:swa/injection_container.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/navigation_helper.dart';

import 'core/local_cache_helper.dart';
import 'core/utils/huawei_notification_service.dart';
import 'features/times_trips/times_trips_injection_container.dart';

final sl = GetIt.instance;

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isHuawei = false;

  if (!Platform.isIOS) {
    Future<bool> isHuaweiDevice() async {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.manufacturer.toLowerCase() == 'huawei';
    }

    isHuawei = await isHuaweiDevice();
  }

  print("Tik Tik is huawei: $isHuawei");

  if (!isHuawei) {
    await Firebase.initializeApp();
    await FirebaseNotificationService().setUp();
  } else {
    await FirebaseNotificationService().setUpHuawei();
  }

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
  // final cccc = await PackagesRespo().Convertcurrency(from: 'EGP', to: 'SAR', amount: 1000);
  // log("Currencyyyyyyy: $cccc");
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
          return MultiBlocProvider(
            providers: [
              BlocProvider<PaymentMethodsCubit>(
                create: (context) => PaymentMethodsCubit(
                    sl<PaymentMethodsRepo>(), sl<MyWalletRepo>())
                  ..init(),
              ),
              BlocProvider<WalletCubit>(
                create: (context) => WalletCubit(
                    MyWalletRepo(sl<ApiConsumer>()), PackagesRespo()),
              ),
              BlocProvider<NotificationBloc>(
                create: (context) =>
                    NotificationBloc()..add(getNotificationlist()),
              ),
              BlocProvider(
                  create: (context) =>
                      RegisterCubit(registerUserUseCase: sl())),
            ],
            child: MaterialApp(
              localizationsDelegates: [GlobalMaterialLocalizations.delegate],
              supportedLocales: [const Locale('en'), const Locale('ar')],
              title: AppStrings.appName,
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: scaffoldMessengerKey,
              // home: ReusableCardPaymentScreen(
              //   showCurrencySelector: true,
              //   initialAmount: 100,
              //   onCardSelected: (cardNumber) {},
              //   onSubmit: (cardNumber, expiryDate, cvv) {},
              //   onAddCard: () {},
              // ),
              // initialRoute: '/',
              onGenerateRoute: AppRoute.onGenerateRoute,
            ),
          );
        });
  }
}
