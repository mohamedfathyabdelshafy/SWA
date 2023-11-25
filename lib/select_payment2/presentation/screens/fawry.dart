import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import '../PLOH/reservation_my_wallet_cuibit/reservation_states_my_wallet.dart';


class FawryScreenReservation extends StatefulWidget {
  FawryScreenReservation({super.key,

  });

  @override
  State<FawryScreenReservation> createState() => _FawryScreenReservationState();
}

class _FawryScreenReservationState extends State<FawryScreenReservation> {
  final formKey = GlobalKey<FormState>();
  final price =CacheHelper.getDataToSharedPref(key: 'price');

  User? _user;
  @override
  void initState() {

    // Future.delayed(const Duration(seconds: 0)).then((_) async {
    //   BlocProvider.of<LoginCubit>(context).getUserData();
    // });
    super.initState();
  }

  TextEditingController amountController = TextEditingController( );
  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    'Fawry' ,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: "bold"
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                // BlocListener(
                //   bloc: BlocProvider.of<LoginCubit>(context),
                //   listener: (context, state) {
                //     if (state is UserLoginLoadedState) {
                //       _user = state.userResponse.user;
                //     }
                //   },
                  child: Form(
                    key: formKey,
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        //Text(""),
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 1,
                              decoration: const BoxDecoration(
                                color: Color(0xff47A9EB)
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Container(
                              height:sizeHeight * 0.07,
                              width: 300,
                              //    padding:
                              //    const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                              decoration: const BoxDecoration(
                                // color: Colors.red
                                // border: Border.all(
                                //   color: AppColors.blue,
                                //   width: 0.3,
                                // ),

                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "amount",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "bold",
                                        color: AppColors.greyLight
                                    ),
                                  ),
                                  Text(
                                    price.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "bold",
                                        color: AppColors.primaryColor
                                    ),
                                  )
                                ],
                              )
                            ),
                          ],
                        ),
                        const Spacer(),
                       BlocListener(
                          bloc: BlocProvider.of<ReservationCubit>(context),
                         listener: (context, state) {
                           if(state is LoadingElectronicWalletState){
                             Constants.showLoadingDialog(context);
                           }else if (state is LoadedElectronicWalletState) {
                             Constants.hideLoadingDialog(context);
                             // Constants.showDefaultSnackBar(context: context, text: state.reservationResponseElectronicModel.message!.statusDescription!);



                             showDialog(
                               context: context,
                               builder: (BuildContext context) {
                                 return AlertDialog(
                                   title: Column(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     mainAxisSize: MainAxisSize.min,
                                     children: const [
                                       Icon(
                                         Icons.check_circle,
                                         color: Colors.green,
                                       ),
                                       Text("You will get a notification by applying your wallet \n In order to agree to pay"),
                                     ],
                                   ),
                                   titleTextStyle: const TextStyle(
                                       fontWeight: FontWeight.bold,
                                       color: Colors.black,
                                       fontSize: 20
                                   ),
                                   content: Column(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           const Text('Amount: '),
                                           Text(price.toString())
                                         ],
                                       ),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           const Text('Reference Number: '),
                                           Text(state.reservationResponseElectronicModel.message!.referenceNumber.toString())
                                         ],
                                       )
                                     ],
                                   ),
                                   actionsOverflowButtonSpacing: 20,
                                   actions: [
                                     ElevatedButton(
                                       onPressed: (){
                                         Navigator.pop(context);
                                         Navigator.pushNamed(context, Routes.initialRoute);
                                       },
                                       child: Container(
                                         // padding: const EdgeInsets.symmetric(horizontal: 20,vertical:20),
                                         // margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                                         decoration:BoxDecoration(
                                           // color: color ?? AppColors.darkRed,
                                           borderRadius: BorderRadius.circular(100)
                                         ) ,
                                         child: Center(
                                           child: Text(
                                             'OK',
                                             style: TextStyle(
                                               color: AppColors.white,
                                               fontWeight: FontWeight.bold,
                                               fontSize: 22
                                             ),
                                           ),
                                         ),
                                       )
                                     ),
                                   ],

                                 );
                               },
                             );


                           }else if (state is ErrorElectronicWalletState) {
                             Constants.hideLoadingDialog(context);
                             Constants.showDefaultSnackBar(context: context, text: state.error.toString());
                           }
                         },
                          child:
                          InkWell(
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
                              print("tripOneId${tripOneId}==tripOneId${tripRoundId }=====${seatIdsOneTrip}===${seatIdsRoundTrip}==$price");
                              print("tripOneId${selectedDayTo}==tripOneId${selectedDayFrom }=====${toStationId}===${fromStationId}==$price");

                              print("tripOneId${tripOneId}==tripOneId${tripRoundId }=====${seatIdsOneTrip}===${seatIdsRoundTrip}==$price==");

                              // if(_user != null && formKey.currentState!.validate()) {
                                BlocProvider.of<ReservationCubit>(context).addReservationFawry(
                                    seatIdsOneTrip:seatIdsOneTrip,
                                    custId: 4,
                                    oneTripID:tripOneId.toString(),
                                    paymentMethodID: 2,
                                    paymentTypeID: 68,
                                    seatIdsRoundTrip:seatIdsRoundTrip??[],
                                    roundTripID:tripRoundId??"",
                                    amount:price.toStringAsFixed(2).toString(),
                                    fromStationID:fromStationId,
                                    toStationId:toStationId,
                                    tripDateGo:selectedDayFrom,
                                    tripDateBack: selectedDayTo
                                );
                              //}
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Constants.customButton(text: "Charge", color: AppColors.primaryColor,),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
             // )
              // }
              //)
            ],
          ),
        ),
      ),
    );
  }
}

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;
      var value = newValue.text;
      if (newValue.text.length > 2) {
        value = value.replaceAll(RegExp(r'\D'), '');
        value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
        print("Value ---- $value");
      }
      return TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
