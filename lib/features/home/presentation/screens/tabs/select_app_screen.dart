import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/home/presentation/cubit/home_cubit.dart';
import 'package:swa/features/home/presentation/screens/home.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/payment/fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';

class SelectappScreen extends StatelessWidget {
  const SelectappScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    return Scaffold(
      backgroundColor: Color(0xffEFEFEF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: sizeHeight * 0.1,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Choose App',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'bold', fontSize: 24),
            ),
          ),
          SizedBox(
            height: sizeHeight * 0.08,
          ),
          InkWell(
            onTap: () {
              Routes.isomra = false;
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.home, (route) => false,
                  arguments: false);
            },
            child: Container(
              alignment: Alignment.center,
              child: Container(
                width: 156,
                height: 156,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/swabus.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () {
              Routes.isomra = true;

              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.home, (route) => false,
                  arguments: true);
            },
            child: Container(
              alignment: Alignment.center,
              child: Container(
                width: 156,
                height: 156,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/swaumra2.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
