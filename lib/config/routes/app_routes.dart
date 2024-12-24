import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_strings.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_country_cities_cubit/get_available_country_cities_cubit.dart';
import 'package:swa/features/change_password/presentation/screens/code_screen.dart';
import 'package:swa/features/done_login/presentation/pages/done_login.dart';
import 'package:swa/features/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:swa/features/forgot_password/presentation/screens/forgot_password.dart';
import 'package:swa/features/home/presentation/cubit/home_cubit.dart';
import 'package:swa/features/home/presentation/screens/Update_screen/update_screen.dart';
import 'package:swa/features/home/presentation/screens/home.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/select_app_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/payment/fawry/presentation/cubit/fawry_cubit.dart';
import 'package:swa/features/payment/fawry/presentation/screens/fawry.dart';
import 'package:swa/features/payment/fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/sign_in/presentation/screens/login.dart';
import 'package:swa/features/sign_up/presentation/cubit/register_cubit.dart';
import 'package:swa/features/sign_up/presentation/screens/email_screen.dart';
import 'package:swa/features/sign_up/presentation/screens/sign_up.dart';
import 'package:swa/features/sign_up/presentation/screens/verifed_code.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/data/models/trip_reservartion_model.dart';

class Routes {
  static const String initialRoute = '/';
  static const String home = 'home';

  static const String signInRoute = '/signIn';
  static const String doneLoginRoute = '/doneLogin';
  static const String signUpRoute = '/signUp';
  static const String EmailRoute = '/emailscreen';
  static const String verifyemailroure = '/coderoute';

  static const String newPasswordRoute = '/newPassword';
  static const String forgotPasswordRoute = '/forgotPassword';
  static const String createPasscode = '/createPasscode';
  static const String updateapp = '/updateapp';

  ///Payment Screens
  static const String myWalletScreen = '/myCredit';
  static const String fawryPaymentScreen = '/fawry';
  static const String eWalletScreen = '/eWallet';
  static const String timesScreen = '/timesScreen';

// static const String homeRoute = '/home';

  static String countryname = 'Eg';

  static String country = 'Egypt';

  static String emailaddress = '';

  static String? countryflag;
  static String? curruncy, ToStationID, FromStationID;

  static int? customerid;
  static User? user;
  static String Amount = '';

  static double discount = 0;
  static bool ispercentage = false;

  static String PromoCodeID = '';
  static bool isomra = false;

  static String? PackageID, PackagePriceID;

  static List<TripReservationList> resrvedtrips = [];
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
                  BlocProvider<PackagesBloc>(
                    create: (context) => PackagesBloc(),
                  ),
                  BlocProvider<FawryReservation>(
                    create: (context) => sl<FawryReservation>(),
                  ),
                  BlocProvider<GetAvailableCountriesCubit>(
                    create: (context) => sl<GetAvailableCountriesCubit>(),
                  ),
                  BlocProvider<HomeCubit>(
                    create: (context) => sl<HomeCubit>(),
                  ),
                  BlocProvider<TimesTripsCubit>(
                      create: (context) => sl<TimesTripsCubit>()),
                  BlocProvider<TicketCubit>(
                      create: (context) => sl<TicketCubit>()),
                ], child: const SelectappScreen()));

      case Routes.home:
        bool isomra = settings.arguments as bool;
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                    providers: [
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
                        create: (context) => sl<GetAvailableCountriesCubit>(),
                      ),
                      BlocProvider<HomeCubit>(
                        create: (context) => sl<HomeCubit>(),
                      ),
                      BlocProvider<TimesTripsCubit>(
                          create: (context) => sl<TimesTripsCubit>()),
                      BlocProvider<TicketCubit>(
                          create: (context) => sl<TicketCubit>()),
                    ],
                    child: HomeScreen(
                      isumra: isomra,
                    )));

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

      case Routes.EmailRoute:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<RegisterCubit>()),
              BlocProvider<GetAvailableCountriesCubit>(
                  create: (context) => sl<GetAvailableCountriesCubit>()),
              BlocProvider<GetAvailableCountryCitiesCubit>(
                  create: (context) => sl<GetAvailableCountryCitiesCubit>()),
            ],
            child: Emailscreen(),
          ),
        );

      case Routes.verifyemailroure:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<RegisterCubit>()),
              BlocProvider<GetAvailableCountriesCubit>(
                  create: (context) => sl<GetAvailableCountriesCubit>()),
              BlocProvider<GetAvailableCountryCitiesCubit>(
                  create: (context) => sl<GetAvailableCountryCitiesCubit>()),
            ],
            child: VerifyCodeScreen(),
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
      case Routes.updateapp:
        return MaterialPageRoute(builder: (context) => UpdateAppScreen());
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
