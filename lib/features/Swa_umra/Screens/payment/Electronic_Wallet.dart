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
import 'package:swa/features/payment/electronic_wallet/domain/use_cases/ewallet_use_case.dart';
import 'package:swa/features/payment/electronic_wallet/presentation/cubit/eWallet_cubit.dart';
import 'package:swa/features/payment/fawry/presentation/screens/fawry.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';

class ElectronicUmraScreen extends StatefulWidget {
  int? umrahReservationID;
  ElectronicUmraScreen({super.key, this.umrahReservationID});

  @override
  State<ElectronicUmraScreen> createState() => _ElectronicUmraScreenState();
}

class _ElectronicUmraScreenState extends State<ElectronicUmraScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  UmraBloc _umraBloc = UmraBloc();

  @override
  void initState() {
    super.initState();

    amountController.text = widget.umrahReservationID != null
        ? UmraDetails.differentPrice.toString()
        : UmraDetails.afterdiscount.toString();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener(
        bloc: _umraBloc,
        listener: (context, UmraState state) {
          // TODO: implement listener

          if (state.reservationResponseElectronicModel?.status == 'success') {
            Constants.hideLoadingDialog(context);
            // Constants.showDefaultSnackBar(context: context, text: state.reservationResponseElectronicModel.message!.statusDescription!);

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      Text(LanguageClass.isEnglish
                          ? "You will get a notification by applying your wallet \n In order to agree to pay"
                          : "سيصلك إشعار بتطبيق محفظتك \n من أجل الموافقة على الدفع"),
                    ],
                  ),
                  titleTextStyle: fontStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(LanguageClass.isEnglish ? 'Amount: ' : "القيمة"),
                          Text(UmraDetails.afterdiscount.toString())
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Reference Number: '),
                          Text(state.reservationResponseElectronicModel!
                              .message!.referenceNumber
                              .toString())
                        ],
                      )
                    ],
                  ),
                  actionsOverflowButtonSpacing: 20,
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.home, (route) => false,
                              arguments: Routes.isomra);
                        },
                        child: Container(
                          // padding: const EdgeInsets.symmetric(horizontal: 20,vertical:20),
                          // margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                          decoration: BoxDecoration(
                              // color: color ?? AppColors.darkRed,
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              LanguageClass.isEnglish ? 'OK' : "موافقة",
                              style: fontStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          ),
                        )),
                  ],
                );
              },
            );
          } else if (state.reservationResponseElectronicModel?.status ==
              'failed') {
            Constants.hideLoadingDialog(context);
            Constants.showDefaultSnackBar(
                context: context,
                color: AppColors.umragold,
                text: state.reservationResponseElectronicModel!.errormessage!);
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
              return SafeArea(
                  bottom: false,
                  child: Directionality(
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
                                LanguageClass.isEnglish
                                    ? 'Electronic wallet'
                                    : 'محفظة الاكترونية',
                                style: fontStyle(
                                    fontSize: 24.sp,
                                    fontFamily: FontFamily.bold,
                                    fontWeight: FontWeight.w500),
                              )),

                          SizedBox(
                            height: sizeHeight * 0.01,
                          ),

                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 33.w),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 1,
                                          decoration: const BoxDecoration(
                                              color: Color(0xff47A9EB)),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 70,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 18),
                                            decoration: const BoxDecoration(
                                                //color: AppColors.yellow
                                                // border: Border.all(
                                                //   color: AppColors.blue,
                                                //   width: 0.3,
                                                // ),
                                                // borderRadius:
                                                // const BorderRadius.all(Radius.circular(10))
                                                ),
                                            child: TextFormField(
                                              maxLength: 11,
                                              autofocus: true,
                                              style: fontStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 16),
                                              cursorColor: AppColors.blue,
                                              controller: phoneController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp("[0-9]"))
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    LanguageClass.isEnglish
                                                        ? 'Phone Number'
                                                        : 'رقم التليفون',
                                                errorStyle: fontStyle(
                                                  color: Colors.red,
                                                  fontSize: 11,
                                                ),
                                                hintStyle: fontStyle(
                                                    color: AppColors.greyLight,
                                                    fontSize: 15,
                                                    fontFamily:
                                                        FontFamily.bold),
                                                labelStyle: fontStyle(
                                                    color: AppColors.grey,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        FontFamily.bold),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return LanguageClass.isEnglish
                                                      ? 'This Field is Required'
                                                      : 'هذا مطلوب';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 1,
                                          decoration: const BoxDecoration(
                                              color: Color(0xffD865A4)),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 18),
                                            decoration: const BoxDecoration(
                                                // border: Border.all(
                                                //   color: AppColors.blue,
                                                //   width: 0.3,
                                                // ),
                                                // borderRadius:
                                                // const BorderRadius.all(Radius.circular(10))
                                                ),
                                            child: TextFormField(
                                              autofocus: true,
                                              style: fontStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 16),
                                              cursorColor: AppColors.blue,
                                              controller: amountController,
                                              inputFormatters: [
                                                NumericTextFormatter()
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
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
                                                    fontFamily:
                                                        FontFamily.bold),
                                                labelStyle: fontStyle(
                                                    color: AppColors.grey,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        FontFamily.bold),
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
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (formKey.currentState!.validate()) {
                                          UmraDetails.phonenumber =
                                              phoneController.text;
                                          Navigator.pop(
                                              context, phoneController.text);

                                          // if (widget.umrahReservationID !=
                                          //     null) {
                                          //   _umraBloc.add(
                                          //       EditElectronicwalletEvent(
                                          //           PaymentMethodID: 5,
                                          //           paymentTypeID: 68,
                                          //           umrahReservationID: widget
                                          //               .umrahReservationID,
                                          //           phone:
                                          //               phoneController.text));
                                          // } else {
                                          //   _umraBloc.add(ElectronicwalletEvent(
                                          //       PaymentMethodID: 5,
                                          //       paymentTypeID: 68,
                                          //       phone: phoneController.text));
                                          // }
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 30,
                                        ),
                                        child: Constants.customButton(
                                          borderradias: 41,
                                          text: LanguageClass.isEnglish
                                              ? 'Pay'
                                              : 'ادفع',
                                          color: AppColors.umragold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          //})
                        ],
                      )));
            }
          },
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
        onConfirmBtnTap: () {
          callback();
        });
  }
}
