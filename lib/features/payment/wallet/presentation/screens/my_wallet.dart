import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/payment/select_payment/presentation/screens/select_payment.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/select_payment2/presentation/screens/select_payment.dart';

class MyCredit extends StatelessWidget {
  const MyCredit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.primaryColor,
            size: 30,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "My wallet",
              style: fontStyle(
                  color: AppColors.white,
                  fontSize: 34,
                  fontFamily: FontFamily.bold),
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              "Your Credit",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18, color: AppColors.darkGrey),
            ),
            Text(
              "EGP2,343",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 31,
                  color: AppColors.white),
            ),
            const Spacer(
              flex: 7,
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<ReservationCubit>(
                      create: (context) => ReservationCubit(),
                      child: SelectPaymentScreen(),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Charge my wallet",
                      style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                ),
              ),
            )
            //Spacer(flex: 7,)
          ],
        ),
      ),
    );
  }
}
