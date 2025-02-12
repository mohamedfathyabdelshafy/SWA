import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/Screens/payment/Electronic_Wallet.dart';
import 'package:swa/features/Swa_umra/Screens/payment/card_payment.dart';
import 'package:swa/features/Swa_umra/Screens/payment/fawry_screen.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/payment_type_model.dart';
import 'package:swa/features/payment/wallet/data/model/my_wallet_response_model.dart';
import 'package:swa/features/payment/wallet/data/repo/my_wallet_repo.dart';
import 'package:swa/main.dart';

class SelectPaymentumra extends StatefulWidget {
  int? umrahReservationID;

  SelectPaymentumra({super.key, this.umrahReservationID});

  @override
  State<SelectPaymentumra> createState() => _SelectPaymentumraState();
}

class _SelectPaymentumraState extends State<SelectPaymentumra> {
  UmraBloc _umraBloc = UmraBloc();
  List<paymentbody>? paymentTypelist = [];
  double balance = 0;

  getwalllet() async {
    MyWalletResponseModel? wallet =
        await MyWalletRepo(sl()).getMyWallet(customerId: Routes.customerid!);
    setState(() {
      balance = wallet!.message!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _umraBloc.add(getpaymentstypeEvent());

    if (Routes.user != null) {
      getwalllet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener(
          bloc: _umraBloc,
          listener: (context, UmraState state) {
            // TODO: implement listener

            if (state.paymenttypemodel?.status == 'success') {
              paymentTypelist = state.paymenttypemodel!.message;
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
                    child: Directionality(
                  textDirection: LanguageClass.isEnglish
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.verticalSpace,
                      Container(
                        alignment: Alignment.topRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            LanguageClass.isEnglish ? 'Cancel' : 'إلغاء',
                            textAlign: TextAlign.right,
                            style: fontStyle(
                                color: Color(0xff00b1ff),
                                fontFamily: FontFamily.medium,
                                fontSize: 16.sp,
                                height: 1.5),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          LanguageClass.isEnglish ? 'Payment' : 'الدفع',
                          textAlign: TextAlign.start,
                          style: fontStyle(
                              color: Colors.black,
                              fontFamily: FontFamily.bold,
                              fontSize: 28.sp,
                              height: 1.5),
                        ),
                      ),
                      30.verticalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          LanguageClass.isEnglish
                              ? 'Select payment method'
                              : 'اختر طريقة الدفع',
                          textAlign: TextAlign.start,
                          style: fontStyle(
                              color: Color(0xff585858),
                              fontFamily: FontFamily.medium,
                              fontSize: 16.sp,
                              height: 1.5),
                        ),
                      ),
                      30.verticalSpace,
                      Expanded(
                        child: ListView.builder(
                          itemCount: paymentTypelist!.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          physics: ScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 15.h),
                              child: InkWell(
                                onTap: () {
                                  if (paymentTypelist![index].pageId == 2) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Umracardpay(
                                          index: 1,
                                          umrahReservationID:
                                              widget.umrahReservationID,
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        Navigator.pop(
                                            context, paymentTypelist![index]);
                                      }
                                    });
                                  } else if (paymentTypelist![index].pageId ==
                                      1) {
                                    Navigator.pop(
                                        context, paymentTypelist![index]);
                                  } else if (paymentTypelist![index].pageId ==
                                      3) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FawryUmraScreen(
                                          umrahReservationID:
                                              widget.umrahReservationID,
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        Navigator.pop(
                                            context, paymentTypelist![index]);
                                      }
                                    });
                                  } else if (paymentTypelist![index].pageId ==
                                      4) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ElectronicUmraScreen(
                                          umrahReservationID:
                                              widget.umrahReservationID,
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        Navigator.pop(
                                            context, paymentTypelist![index]);
                                      }
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    paymentTypelist![index].image == null
                                        ? Container(
                                            width: 48.w,
                                          )
                                        : Container(
                                            width: 48.w,
                                            child: Image.network(
                                              paymentTypelist![index]
                                                  .image
                                                  .toString(),
                                              width: 48.w,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                    19.horizontalSpace,
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              paymentTypelist![index]
                                                  .pageName
                                                  .toString(),
                                              style: fontStyle(
                                                fontFamily: FontFamily.medium,
                                                fontSize: 17.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                            if (paymentTypelist![index]
                                                .hasWalletBalance!) ...[
                                              20.horizontalSpace,
                                              Text(
                                                '$balance ${Routes.curruncy}',
                                                style: fontStyle(
                                                    color: Color(0xff23c956),
                                                    fontSize: 10.sp,
                                                    fontFamily: FontFamily.bold,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              )
                                            ]
                                          ],
                                        ),
                                        Text(
                                          paymentTypelist![index]
                                              .description
                                              .toString(),
                                          style: fontStyle(
                                            fontFamily: FontFamily.regular,
                                            fontSize: 12.sp,
                                            color: Color(0xff585858),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ));
              }
            },
          ),
        ),
        bottomNavigationBar: Navigationbottombar(
          currentIndex: 0,
        ));
  }
}
