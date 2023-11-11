import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/styles.dart';


class FawryScreen extends StatefulWidget {
  @override
  State<FawryScreen> createState() => _FawryScreenState();
}

class _FawryScreenState extends State<FawryScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //SizedBox(height: 30.h,),
            Row(
              children: [

                // Container(
                //   padding: EdgeInsets.all(5),
                //   decoration: BoxDecoration(
                //       color: AppColors.yellow2,
                //       borderRadius: BorderRadius.circular(5),
                //       border: Border.all(color: AppColors.blue2)
                //   ),
                //   child: SvgPicture.asset(
                //     'assets/images/Group 97.svg',
                //     // height: 60,
                //     // width: 100,
                //     fit: BoxFit.fitWidth,
                //   ),
                // ),
                // SizedBox(width: 5.w,),
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
            SizedBox(height: 30,),
            // BlocConsumer<WalletBloc, WalletState>(
            // listener: (context, state) {
            //   if (state is FawryLoadingState) {
            //     showDialog<void>(
            //       barrierDismissible: false,
            //       context: context,
            //       builder: (_) {
            //         return Center(
            //             child: showLoadingWidget(context, width: 120, height: 120));
            //       },
            //     );
            //   }
            //   if (state is FawryLoadedState) {
            //     Navigator.pop(context);
            //     showDialog(
            //       barrierDismissible: false,
            //       context: context,
            //       builder: (context) {
            //         return AlertDialog(
            //           content: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               LottieBuilder.asset(
            //                 'assets/json/done.json',
            //                 height: 120,
            //                 repeat: false,
            //               ),
            //               Text(
            //                 Singleton().isEnglishSelected
            //                     ? 'You will get a notification by applying your wallet In order to agree to pay'
            //                     : 'ستحصل على إشعار بتطبيق محفظتك من أجل الموافقة على الدفع',
            //                 textAlign: TextAlign.center,
            //                 style: fontStyle(
            //                   fontSize: 18,
            //                   color: Colors.black,
            //                 ),
            //               ),
            //               const SizedBox(
            //                 height: 10,
            //               ),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text(
            //                     Singleton().isEnglishSelected
            //                         ? 'Amount : '
            //                         : 'القيمة : ',
            //                     textAlign: TextAlign.center,
            //                     style: fontStyle(
            //                       fontSize: 16,
            //                       color: Colors.black,
            //                     ),
            //                   ),
            //                   Text(
            //                     state.amount,
            //                     textAlign: TextAlign.center,
            //                     style: fontStyle(
            //                       fontSize: 17,
            //                       fontWeight: FontWeight.bold,
            //                       color: Colors.black,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text(
            //                     Singleton().isEnglishSelected
            //                         ? 'ReferenceNumber : '
            //                         : ' : رقم المرجع',
            //                     textAlign: TextAlign.center,
            //                     style: fontStyle(
            //                       fontSize: 14,
            //                       color: Colors.black,
            //                     ),
            //                   ),
            //                   SelectableText(
            //                     state.referenceNumber,
            //                     textAlign: TextAlign.center,
            //                     style: fontStyle(
            //                       fontSize: 15,
            //                       fontWeight: FontWeight.bold,
            //                       color: Colors.black,
            //                     ),
            //                   ),
            //                   InkWell(
            //                     onTap: () async {
            //                       await Clipboard.setData(
            //                         ClipboardData(
            //                           text: state.referenceNumber.toString(),
            //                         ),
            //                       );
            //                       showSnackBar(
            //                         context,
            //                         Singleton().isEnglishSelected
            //                             ? 'Copied'
            //                             : 'تم النسخ',
            //                       );
            //                     },
            //                     child: const Icon(
            //                       Icons.copy,
            //                       size: 20,
            //                     ),
            //                   )
            //                 ],
            //               ),
            //               const SizedBox(
            //                 height: 15,
            //               ),
            //               SizedBox(
            //                 width: 200,
            //                 height: 40,
            //                 child: ElevatedButton(
            //                   style: ElevatedButton.styleFrom(
            //                     padding: const EdgeInsets.symmetric(
            //                         horizontal: 8, vertical: 8),
            //                     backgroundColor: AppColors.blue,
            //                     shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(22),
            //                     ),
            //                   ),
            //                   onPressed: () {
            //                     Navigator.pop(context);
            //                     Navigator.pop(context);
            //                   },
            //                   child: Text(
            //                     'OK',
            //                     style: fontStyle(color: Colors.white),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //     );
            //     // showDoneConfirmationDialog(context,
            //     //     message: ,
            //     //     callback: () {
            //     //   Navigator.pop(context);
            //     //   Navigator.pop(context);
            //     // });
            //   }
            //   if (state is FawryErrorState) {
            //     Navigator.pop(context);
            //     showDoneConfirmationDialog(context,
            //         isError: true, message: state.message, callback: () {
            //           Navigator.pop(context);
            //         });
            //   }
            // },
            // builder: (context, state) {
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
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
                          decoration: BoxDecoration(
                              color: Color(0xff47A9EB)

                          ),
                        ),
                        SizedBox(width: 5,),
                        Container(
                          height: 40,
                          width: 300,
                          //    padding:
                          //    const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                          decoration: BoxDecoration(
                            // color: Colors.red
                            // border: Border.all(
                            //   color: AppColors.blue,
                            //   width: 0.3,
                            // ),

                          ),
                          child: TextFormField(
                            autofocus: true,
                            style: fontStyle(color: AppColors.blue, fontSize: 16),
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
                                  fontFamily: FontFamily.bold),
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
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Constants.customButton(text: "Charge", color: AppColors.primaryColor,),
                    )

                  ],
                ),
              ),
            )
            // }
            //)
          ],
        ),
      ),
    );
  }
}

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      var value = newValue.text;
      if (newValue.text.length > 2) {
        value = value.replaceAll(RegExp(r'\D'), '');
        value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
        print("Value ---- $value");
      }
      return TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(
            offset: value.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
