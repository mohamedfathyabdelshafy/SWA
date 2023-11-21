import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/payment/fawry/domain/use_cases/fawry_use_case.dart';
import 'package:swa/features/payment/fawry/presentation/cubit/fawry_cubit.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';

import '../PLOH/fawry_Reservation_cubit.dart';
import '../PLOH/fawry_Reservation_states.dart';


class FawryScreenReservation extends StatefulWidget {
  FawryScreenReservation({super.key,required this.price,
  required this.roundTripID,
    this.seatIdsRoundTrip,
    required this.seatIdsOneTrip,
    required this.oneTripID
  });
 double price;
List<dynamic> seatIdsOneTrip;
  String oneTripID;
 List<dynamic>? seatIdsRoundTrip;
  String roundTripID;
  @override
  State<FawryScreenReservation> createState() => _FawryScreenReservationState();
}

class _FawryScreenReservationState extends State<FawryScreenReservation> {
  final formKey = GlobalKey<FormState>();
  User? _user;
  late String amount;
  @override
  void initState() {
     amount = widget.price.toString();

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
             const Row(
                children:  [
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
                              height: 40,
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
                              child: TextFormField(
                                autofocus: true,
                                style: fontStyle(color: AppColors.white, fontSize: 16),
                                cursorColor: AppColors.blue,
                                controller: amountController,
                                inputFormatters: [NumericTextFormatter()],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Amount',
                                  errorStyle: fontStyle(
                                    color: Colors.red,
                                    fontSize: 11,
                                  ),
                                  hintStyle: fontStyle(
                                      color: AppColors.greyLight,
                                      fontSize: 15,
                                      fontFamily: FontFamily.bold),
                                  labelStyle: fontStyle(
                                      color: AppColors.grey,
                                      fontSize: 12,
                                      fontFamily: FontFamily.bold
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This Field is Required';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                       BlocListener(
                          bloc: BlocProvider.of<FawryReservation>(context),
                          listener: (context, state) {
                            if(state is FawryLoadingReservationState){
                              Constants.showLoadingDialog(context);
                            }else if (state is FawryLoadedReservationState) {
                              Constants.hideLoadingDialog(context);
                              Constants.showDefaultSnackBar(context: context, text: state.paymentMessageResponse.paymentMessage!.statusDescription);

                              Future.delayed(const Duration(seconds: 5), () {
                                Navigator.pushReplacementNamed(context, Routes.initialRoute);
                              });
                            }else if (state is FawryErrorReservationState) {
                              Constants.hideLoadingDialog(context);
                              Constants.showDefaultSnackBar(context: context, text: state.error.toString());
                            }
                          },
                          child:
                          InkWell(
                            onTap: (){
                              final tripOneId = CacheHelper.getDataToSharedPref(key: 'tripOneId');
                              final tripRoundId = CacheHelper.getDataToSharedPref(key: 'tripRoundId');
                              print("tripOneId${tripOneId}=====================tripOneId${tripRoundId}");

                              // if(_user != null && formKey.currentState!.validate()) {
                                BlocProvider.of<FawryReservation>(context).addReservation(
                                    seatIdsOneTrip:widget.seatIdsOneTrip ,
                                    custId: 4,
                                    oneTripID:tripOneId.toString(),
                                    paymentMethodID: "2",
                                    paymentTypeID: "68",
                                  seatIdsRoundTrip:widget.seatIdsRoundTrip ,
                                  roundTripID:tripRoundId.toString(),
                                  amount:widget.price
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
