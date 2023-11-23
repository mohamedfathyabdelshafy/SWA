import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/features/payment/electronic_wallet/presentation/screens/electronic_screens.dart';
import 'package:swa/features/payment/fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';
import 'package:swa/features/select_payment2/presentation/credit_card/presentation/screens/credit_card_pay_viewd.dart';
import 'package:swa/features/select_payment2/presentation/screens/fawry.dart';
import 'package:swa/features/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/features/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_states_my_wallet.dart';
import 'package:swa/features/select_payment2/presentation/screens/electronic_screens.dart';

import '../../../../../core/local_cache_helper.dart';
import '../../../../../core/utils/constants.dart';
class SelectPaymentScreen2 extends StatefulWidget {
  const SelectPaymentScreen2({super.key,});
  @override
  State<SelectPaymentScreen2> createState() => _SelectPaymentScreen2State();
}

class _SelectPaymentScreen2State extends State<SelectPaymentScreen2> {
  bool _switchValue = true;

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
            Row(
              children: [
                customText("Wallet deduction"),
                const Spacer(),
                CupertinoSwitch(
                  value: _switchValue,

                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                ),
              ],
            ),
            _switchValue ?const SizedBox():  Column(
             children: [
               const SizedBox(height: 17,),
               InkWell(
                 onTap: () async {

                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => BlocProvider<ReservationCubit>(
                           create: (context) => ReservationCubit(),
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
                       builder: (context) => BlocProvider<ReservationCubit>(
                         create: (context) => ReservationCubit(),
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
                       builder: (context) => BlocProvider<ReservationCubit>(
                           create: (context) => ReservationCubit(),
                           child:const ElectronicScreen2()
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
            const Spacer(),
            BlocListener(
              bloc: BlocProvider.of<ReservationCubit>(context),
              listener: (context,state){
                if(state is LoadingMyWalletState){
                }if(state is LoadedMyWalletState){
                  Constants.hideLoadingDialog(context);
                  Constants.showDefaultSnackBar(context: context, text: state.reservationResponseMyWalletModel.message!);
                }if(state is ErrorMyWalletState){
                  Constants.hideLoadingDialog(context);
                  Constants.showDefaultSnackBar(context: context, text: state.error);
                }
              },
              child: InkWell(
                onTap: (){
                  final tripOneId = CacheHelper.getDataToSharedPref(key: 'tripOneId');
                  final tripRoundId = CacheHelper.getDataToSharedPref(key: 'tripRoundId');
                  final selectedDayTo = CacheHelper.getDataToSharedPref(key: 'selectedDayTo');
                  final selectedDayFrom = CacheHelper.getDataToSharedPref(key: 'selectedDayFrom');
                  final toStationId = CacheHelper.getDataToSharedPref(key: 'toStationId');
                  final fromStationId = CacheHelper.getDataToSharedPref(key: 'fromStationId');
                  final seatIdsOneTrip = CacheHelper.getDataToSharedPref(key: 'countSeats')?.map((e) => int.tryParse(e) ?? 0).toList();
                  final seatIdsRoundTrip = CacheHelper.getDataToSharedPref(key: 'countSeats2')?.map((e) => int.tryParse(e) ?? 0).toList();
                  final price =CacheHelper.getDataToSharedPref(key: 'price');
                  print("tripOneId${tripOneId}==tripRoundId${tripRoundId }=====seatIdsOneTrip${seatIdsOneTrip}===seatIdsRoundTrip${seatIdsRoundTrip}==$price");
                  print("tripOneId${selectedDayTo}==tripOneId${selectedDayFrom }=====${toStationId}===${fromStationId}==$price");

                  // if(_user != null && formKey.currentState!.validate()) {
                  BlocProvider.of<ReservationCubit>(context).addReservationMyWallet(
                    toStationId:toStationId ,
                    fromStationID:fromStationId ,
                    tripDateGo:selectedDayFrom ,
                    tripDateBack:selectedDayTo ,
                    seatIdsOneTrip:seatIdsOneTrip ,
                    custId: 4,
                    oneTripID:tripOneId.toString(),
                    paymentTypeID: 67,
                    seatIdsRoundTrip:seatIdsRoundTrip??[],
                    roundTripID:tripRoundId.toString(),
                    amount:price.toStringAsFixed(2).toString(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30,),
                  child: Constants.customButton(text: "payment",color:AppColors.primaryColor,),
                ),
              ),
            )
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