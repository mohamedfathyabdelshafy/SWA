import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/Swa_umra/Screens/payment/Electronic_Wallet.dart';
import 'package:swa/features/Swa_umra/Screens/payment/card_payment.dart';
import 'package:swa/features/Swa_umra/Screens/payment/fawry_screen.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/payment/electronic_wallet/presentation/cubit/eWallet_cubit.dart';
import 'package:swa/features/payment/electronic_wallet/presentation/screens/electronic_screens.dart';
import 'package:swa/features/payment/fawry/presentation/cubit/fawry_cubit.dart';
import 'package:swa/features/payment/fawry/presentation/screens/fawry.dart';
import 'package:swa/features/payment/wallet/data/model/my_wallet_response_model.dart';
import 'package:swa/features/payment/wallet/data/repo/my_wallet_repo.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/screens/chargeCard_screen.dart';

class SelectPaymentUmraScreen extends StatefulWidget {
  SelectPaymentUmraScreen({super.key, this.user});
  User? user;
  @override
  State<SelectPaymentUmraScreen> createState() =>
      _SelectPaymentUmraScreenState();
}

class _SelectPaymentUmraScreenState extends State<SelectPaymentUmraScreen> {
  UmraBloc _umraBloc = new UmraBloc();

  var countryid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    getwalllet();
  }

  double balance = 0;

  getwalllet() async {
    MyWalletResponseModel? wallet =
        await MyWalletRepo(sl()).getMyWallet(customerId: Routes.customerid!);
    setState(() {
      balance = wallet!.message!;
    });
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Directionality(
          textDirection:
              LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: BlocListener(
            bloc: _umraBloc,
            listener: (context, UmraState state) {
              // TODO: implement listener

              if (state.reservationResponseMyWalletModel?.status == 'failed') {
                Constants.showDefaultSnackBar(
                    color: AppColors.umragold,
                    context: context,
                    text:
                        state.reservationResponseMyWalletModel!.message ?? ' ');
              } else if (state.reservationResponseMyWalletModel?.status ==
                  'success') {
                Constants.showDefaultSnackBar(
                    color: AppColors.umragold,
                    context: context,
                    text:
                        state.reservationResponseMyWalletModel!.message ?? ' ');
                Navigator.popUntil(context, (route) => route.isFirst);
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
                  return Column(
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
                                ? "Select payment"
                                : "حدد طريقة الدفع",
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontFamily: 'bold',
                                fontWeight: FontWeight.w500),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                _umraBloc.add(WalletdetactionEvent(
                                    PaymentMethodID: 4, paymentTypeID: 67));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 23,
                                    height: 22,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: AppColors.umragold,
                                        borderRadius: BorderRadius.circular(4)),
                                    child: SvgPicture.asset(
                                        'assets/images/wallet.svg'),
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  customText(LanguageClass.isEnglish
                                      ? "Wallet deduction"
                                      : "خصم من المحفظة"),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(7),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: AppColors.umragold,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: AppColors.umragold,
                                            width: 2)),
                                    child: Text(
                                      '${balance} ${Routes.curruncy}',
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
                                          fontFamily: "black"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            countryid == 1
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Umracardpay(
                                                user: widget.user!,
                                                index: 1,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 23,
                                              height: 22,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  color: AppColors.umragold,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: SvgPicture.asset(
                                                  'assets/images/visa.svg'),
                                            ),
                                            SizedBox(
                                              width: 14,
                                            ),
                                            customText(LanguageClass.isEnglish
                                                ? "Pay with Card"
                                                : "الدفع بالبطاقة")
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 17,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FawryUmraScreen(),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 23,
                                              height: 22,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  color: AppColors.umragold,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: SvgPicture.asset(
                                                  'assets/images/fawry.svg'),
                                            ),
                                            SizedBox(
                                              width: 14,
                                            ),
                                            customText(LanguageClass.isEnglish
                                                ? "Pay Fawry"
                                                : "مدفوعات فوري")
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 17,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ElectronicUmraScreen(),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 23,
                                              height: 22,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  color: AppColors.umragold,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: SvgPicture.asset(
                                                  'assets/images/wallet.svg'),
                                            ),
                                            SizedBox(
                                              width: 14,
                                            ),
                                            customText(LanguageClass.isEnglish
                                                ? "Electronic wallet"
                                                : "المحفظة الاكترونية")
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget customText(text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black,
          fontSize: 21,
          fontWeight: FontWeight.w600,
          fontFamily: "meduim"),
    );
  }
}
