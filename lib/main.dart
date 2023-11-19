import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:swa/bloc_observer.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_strings.dart';
import 'package:swa/features/change_password/change_password_injection_container.dart';
import 'package:swa/features/forgot_password/forgot_password_injection_container.dart';
import 'package:swa/features/home/home_injection_container.dart';
import 'package:swa/features/payment/electronic_wallet/eWallet_injection_container.dart';
import 'package:swa/features/payment/fawry/fawry_injection_container.dart';
import 'package:swa/features/sign_in/signin_injection_container.dart';
import 'package:swa/features/sign_up/signup_injection_container.dart';
import 'package:swa/injection_container.dart';

import 'features/bus_reservation_layout/bus_layout_injection_container.dart';
import 'features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'features/times_trips/times_trips_injection_container.dart';


final sl = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ///Authorization Screens
  await loginDependencyInjectionInit();//For initializing login
  await registerDependencyInjectionInit();//For initializing register
  await forgotPasswordDependencyInjectionInit();//For initializing forgot password
  await changePasswordDependencyInjectionInit();//For initializing change password
  await homeDependencyInjectionInit();//For initializing Home
  await fawryDependencyInjectionInit();//For initializing Fawry
  await eWalletDependencyInjectionInit();//For initializing E-Wallet
await TimesTripInjectionInit();
await BusLayoutInjectionInit();


  await dependencyInjectionInit();//For initializing network info and shared preferences
  runApp(const MyApp());
  Bloc.observer = AppBlocObserver();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: AppRoute.onGenerateRoute,
    );
  }
}