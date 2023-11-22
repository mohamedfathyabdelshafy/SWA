import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/features/payment/electronic_wallet/presentation/screens/electronic_screens.dart';
import 'package:swa/features/payment/fawry2/presentation/screens/fawry.dart';

import '../../../credit_card/presentation/screens/credit_card_pay_viewd.dart';
import '../../../fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';


class SelectPaymentScreen extends StatefulWidget {
  const SelectPaymentScreen({super.key,});
  @override
  State<SelectPaymentScreen> createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.primaryColor,
            size: 34,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              "Select payment" ,
              style: TextStyle(color: AppColors.white,fontSize: 34,fontFamily: "bold"),
            ),
            const SizedBox(height: 37,),
            const SizedBox(height: 17,),
            InkWell(
              onTap: () async {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<FawryReservation>(
                        create: (context) => FawryReservation(),
                        child: CreditCardPayView(index:  1,)
                    ),
                  ),
                );

              },
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/visa.png',
                    height: 50,
                    width: 45,
                    fit: BoxFit.fitWidth,
                  ),
                  Image.asset(
                    'assets/images/master_card.png',
                    height: 50,
                    width: 45,
                    fit: BoxFit.fitWidth,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  customText("Debit or credit card")
                ],
              ),
            ),
            const SizedBox(height: 17,),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<FawryReservation>(
                      create: (context) => FawryReservation(),
                      child: FawryScreenReservation(
                      ),
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: AppColors.yellow2,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color:const Color(0xff4587FF))
                    ),
                    child: SvgPicture.asset(
                      'assets/images/Group 97.svg',
                      // height: 60,
                      // width: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const SizedBox(width: 5,),
                  customText("Pay Fawry")
                ],
              ),
            ),
            const SizedBox(height: 17,),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<FawryReservation>(
                      create: (context) => FawryReservation(),
                      child: ElectronicScreen()
                    ),
                  ),
                );              },
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/icons8-open-wallet-78.png',
                    height: 40,
                    width: 40,
                    fit: BoxFit.fitWidth,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  customText("Electronic wallet")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget customText(text){
    return Text(
      text,
      style: const TextStyle
        (
          color: Colors.white,
          fontSize: 21,
          fontFamily:"regular"
      ),
    );
  }
}