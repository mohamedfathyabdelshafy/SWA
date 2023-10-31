import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_strings.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/features/create_passcode/presentation/pages/create_passcode.dart';
import 'package:swa/features/done_login/presentation/pages/done_login.dart';
import 'package:swa/features/forgot_password/presentation/pages/forgot_password.dart';
import 'package:swa/features/home/presentation/pages/home.dart';
import 'package:swa/features/new_password/presentation/pages/new_password.dart';
import 'package:swa/features/sign_in/presentation/pages/login.dart';
import 'package:swa/features/sign_up/presentation/pages/sign_up.dart';

class Routes {
  static const String initialRoute = '/';
  // static const String signInRoute = '/signIn';
  static const String doneLoginRoute = '/doneLogin';
  static const String signUpRoute = '/signUp';
  static const String newPasswordRoute = '/newPassword';
  static const String forgotPasswordRoute = '/forgotPassword';
  static const String createPasscode = '/createPasscode';
  static const String homeRoute = '/home';


}

class AppRoute {
  static Route? onGenerateRoute(RouteSettings settings){
    final Object? args = settings.arguments;
    switch(settings.name){
      case Routes.initialRoute:
        return MaterialPageRoute(builder: (context) => LoginScreen());
        // return MaterialPageRoute(builder: (context) => MultiBlocProvider(
        //   providers: [
        //     BlocProvider<CampusThemeCubit>(create: (context) => sl<CampusThemeCubit>(),),
        //     BlocProvider<LoginCubit>(create: (context) => sl<LoginCubit>(),),
        //   ],
        //   child: const MyHomeScreen()
        // ),);
      // case Routes.welcomeRoute:
      //   return MaterialPageRoute(builder: (context) => const WelcomeScreen());
      // case Routes.loginRoute:
      //   return MaterialPageRoute(builder: (context) => MultiBlocProvider(
      //     providers: [
      //       BlocProvider<LoginCubit>(create: (context) => sl<LoginCubit>(),),
      //       BlocProvider<CampusThemeCubit>(create: (context) => sl<CampusThemeCubit>(),),
      //     ],
      //     child: const LoginScreen()
      //   ));
      case Routes.doneLoginRoute:
        return MaterialPageRoute(builder: (context) => const DoneLoginScreen());
      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (context) => SignUpScreen());
      case Routes.newPasswordRoute:
        return MaterialPageRoute(builder: (context) => NewPasswordScreen());
      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(builder: (context) => ForgetPasswordScreen());
      case Routes.createPasscode:
        return MaterialPageRoute(builder: (context) => CreatePasscodeFormScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      default :
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context){
      return Scaffold(
        appBar: AppBar(
          title: Constants.normalText(context: context, text: AppStrings.error),
          centerTitle: true,
        ),
        body: Center(
          child: Constants.normalText(context: context, text: AppStrings.noRouteFound),
        ),
      );
    });
  }

}