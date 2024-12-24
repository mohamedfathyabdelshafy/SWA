import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';

class FawryUmraScreen extends StatefulWidget {
  FawryUmraScreen({
    super.key,
  });

  @override
  State<FawryUmraScreen> createState() => _FawryUmraScreenState();
}

class _FawryUmraScreenState extends State<FawryUmraScreen> {
  final formKey = GlobalKey<FormState>();
  UmraBloc _umraBloc = UmraBloc();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    amountController.text = UmraDetails.afterdiscount.toString();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: BlocListener(
          bloc: _umraBloc,
          listener: (context, UmraState state) {
            if (state.reservationResponseElectronicModel?.status == 'success') {
              Constants.hideLoadingDialog(context);
              // Constants.showDefaultSnackBar(context: context, text: state.reservationResponseElectronicModel.message!.statusDescription!);
              showDoneConfirmationDialog(context, isError: false, callback: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
                  body: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LanguageClass.isEnglish ? 'Amount: ' : "القيمة",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(UmraDetails.afterdiscount.toString())
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Reference Number: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    Constants.showDefaultSnackBar(
                                        context: context,
                                        text: 'Reference Number copied');
                                    await Clipboard.setData(ClipboardData(
                                        text: state
                                            .reservationResponseElectronicModel!
                                            .message!
                                            .referenceNumber
                                            .toString()));
                                  },
                                  child: Container(
                                      width: 15,
                                      height: 15,
                                      child: Icon(
                                        Icons.copy_outlined,
                                        size: 14,
                                      )),
                                ),
                                Expanded(
                                  child: Text(
                                    state.reservationResponseElectronicModel!
                                        .message!.referenceNumber
                                        .toString(),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  message:
                      "You will get a notification by applying your wallet \n In order to agree to pay");
            } else if (state.reservationResponseElectronicModel?.status ==
                'failed') {
              Constants.hideLoadingDialog(context);
              Constants.showDefaultSnackBar(
                  context: context,
                  text:
                      state.reservationResponseElectronicModel!.errormessage!);
            }
          },
          child: BlocBuilder(
            bloc: _umraBloc,
            builder: (context, UmraState state) {
              if (state.isloading == true) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.umragold,
                  ),
                );
              } else {
                return Directionality(
                    textDirection: LanguageClass.isEnglish
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 27, right: 27),
                          alignment: LanguageClass.isEnglish
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.umragold,
                              size: 25,
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: LanguageClass.isEnglish ? 55 : 0,
                                right: LanguageClass.isEnglish ? 0 : 55),
                            alignment: LanguageClass.isEnglish
                                ? Alignment.topLeft
                                : Alignment.topRight,
                            child: Text(
                              LanguageClass.isEnglish ? 'Fawry' : 'فوري',
                              style: TextStyle(
                                  fontSize: 24.sp,
                                  fontFamily: 'bold',
                                  fontWeight: FontWeight.w500),
                            )),

                        SizedBox(
                          height: sizeHeight * 0.01,
                        ),

                        Expanded(
                          child: Form(
                            key: formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 33),
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
                                            color: AppColors.umragold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 40,
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
                                            style: fontStyle(
                                                color: AppColors.blackColor,
                                                fontSize: 16),
                                            cursorColor: AppColors.blue,
                                            controller: amountController,
                                            readOnly: true,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: LanguageClass.isEnglish
                                                  ? 'Amount'
                                                  : "القيمة",
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
                                                return LanguageClass.isEnglish
                                                    ? 'This Field is Required'
                                                    : "هذا مطلوب";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 50,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _umraBloc.add(FawrypayEvent(
                                          PaymentMethodID: 2,
                                          paymentTypeID: 68));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: Constants.customButton(
                                        borderradias: 41,
                                        text: LanguageClass.isEnglish
                                            ? 'Pay'
                                            : 'ادفع',
                                        color: AppColors.umragold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        // }
                        //)
                      ],
                    ));
              }
            },
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDoneConfirmationDialog(BuildContext context,
      {required String message,
      bool isError = false,
      Widget? body,
      required Function callback}) async {
    return CoolAlert.show(
        barrierDismissible: true,
        context: context,
        confirmBtnText: "ok",
        title: isError ? 'error' : '',
        lottieAsset:
            isError ? 'assets/json/error.json' : 'assets/json/Warning.json',
        type: isError ? CoolAlertType.error : CoolAlertType.success,
        loopAnimation: false,
        backgroundColor: isError ? Colors.red : Colors.white,
        text: message,
        widget: body,
        onConfirmBtnTap: callback());
  }
}
