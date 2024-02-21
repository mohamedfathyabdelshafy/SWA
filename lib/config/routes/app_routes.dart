import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_strings.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_country_cities_cubit/get_available_country_cities_cubit.dart';
import 'package:swa/features/done_login/presentation/pages/done_login.dart';
import 'package:swa/features/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:swa/features/forgot_password/presentation/screens/forgot_password.dart';
import 'package:swa/features/home/presentation/cubit/home_cubit.dart';
import 'package:swa/features/home/presentation/screens/home.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/payment/fawry/presentation/cubit/fawry_cubit.dart';
import 'package:swa/features/payment/fawry/presentation/screens/fawry.dart';
import 'package:swa/features/payment/fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/sign_in/presentation/screens/login.dart';
import 'package:swa/features/sign_up/presentation/cubit/register_cubit.dart';
import 'package:swa/features/sign_up/presentation/screens/sign_up.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';

class Routes {
  static const String initialRoute = '/';
  static const String signInRoute = '/signIn';
  static const String doneLoginRoute = '/doneLogin';
  static const String signUpRoute = '/signUp';
  static const String newPasswordRoute = '/newPassword';
  static const String forgotPasswordRoute = '/forgotPassword';
  static const String createPasscode = '/createPasscode';

  ///Payment Screens
  static const String myWalletScreen = '/myCredit';
  static const String fawryPaymentScreen = '/fawry';
  static const String eWalletScreen = '/eWallet';
  static const String timesScreen = '/timesScreen';

// static const String homeRoute = '/home';
}

class AppRoute {
  static Route? onGenerateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;
    switch (settings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider<LoginCubit>(
                    create: (context) => sl<LoginCubit>(),
                  ),
                  BlocProvider<FawryReservation>(
                    create: (context) => sl<FawryReservation>(),
                  ),
                  BlocProvider<HomeCubit>(
                    create: (context) => sl<HomeCubit>(),
                  ),
                  BlocProvider<TimesTripsCubit>(
                      create: (context) => sl<TimesTripsCubit>()),
                  BlocProvider<TicketCubit>(
                      create: (context) => sl<TicketCubit>()),
                ], child: const HomeScreen()));
      case Routes.signInRoute:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<LoginCubit>(),
            child: LoginScreen(),
          ),
        );
      case Routes.doneLoginRoute:
        return MaterialPageRoute(builder: (context) => const DoneLoginScreen());
      case Routes.signUpRoute:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<RegisterCubit>()),
              BlocProvider<GetAvailableCountriesCubit>(
                  create: (context) => sl<GetAvailableCountriesCubit>()),
              BlocProvider<GetAvailableCountryCitiesCubit>(
                  create: (context) => sl<GetAvailableCountryCitiesCubit>()),
            ],
            child: SignUpScreen(),
          ),
        );
      case Routes.newPasswordRoute:
      // return MaterialPageRoute(
      //     builder: (context) => MultiBlocProvider(providers: [
      //           BlocProvider<LoginCubit>(
      //             create: (context) => sl<LoginCubit>(),
      //           ),
      //           BlocProvider<NewPasswordCubit>(
      //             create: (context) => sl<NewPasswordCubit>(),
      //           ),
      //         ], child: const NewPasswordScreen()));
      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<ForgotPasswordCubit>(),
            child: const ForgetPasswordScreen(),
          ),
        );
      // case Routes.createPasscode:
      //   return MaterialPageRoute(
      //       builder: (context) => CreatePasscodeFormScreen());
      // // case Routes.myWalletScreen:
      // //   return MaterialPageRoute(builder: (context) => const MyCredit());
      case Routes.fawryPaymentScreen:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider<LoginCubit>(
                    create: (context) => sl<LoginCubit>(),
                  ),
                  BlocProvider<FawryCubit>(
                    create: (context) => sl<FawryCubit>(),
                  ),
                ], child: FawryScreen() //ElectronicScreen
                    ));
      case Routes.eWalletScreen:
      // return MaterialPageRoute(builder: (context) => MultiBlocProvider(
      //     providers: [
      //       BlocProvider<LoginCubit>(create: (context) => sl<LoginCubit>(),),
      //       BlocProvider<EWalletCubit>(create: (context) => sl<EWalletCubit>(),),
      //     ],
      //     child: const ElectronicScreen()
      // ));
      case Routes.timesScreen:
      // return MaterialPageRoute(builder: (context) => const TimesScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Constants.normalText(context: context, text: AppStrings.error),
          centerTitle: true,
        ),
        body: Center(
          child: Constants.normalText(
              context: context, text: AppStrings.noRouteFound),
        ),
      );
    });
  }
}
