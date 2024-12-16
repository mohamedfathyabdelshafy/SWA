import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/payment/select_payment/presentation/screens/select_payment.dart';
import 'package:swa/features/payment/wallet/data/model/my_wallet_response_model.dart';
import 'package:swa/features/payment/wallet/data/repo/my_wallet_repo.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';

class MyCredit extends StatefulWidget {
  MyCredit({super.key, required this.user});
  User? user;

  @override
  State<MyCredit> createState() => _MyCreditState();
}

class _MyCreditState extends State<MyCredit> {
  MyWalletResponseModel? myWalletResponseModel;
  MyWalletRepo myWalletRepo = MyWalletRepo(sl());

  int? countryid;

  @override
  void initState() {
    if (widget.user != null) {
      get();
    }

    super.initState();
    countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
  }

  void get() async {
    myWalletResponseModel =
        await myWalletRepo.getMyWallet(customerId: widget.user!.customerId!);
    print(widget.user!.customerId!);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Directionality(
          textDirection:
              LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: sizeHeight * 0.08,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                alignment: LanguageClass.isEnglish
                    ? Alignment.topLeft
                    : Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.initialRoute, (route) => false);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.primaryColor,
                    size: 35,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LanguageClass.isEnglish ? "My wallet" : "محفظتي",
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 38,
                          fontWeight: FontWeight.w500,
                          fontFamily: "roman"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        get();
                      },
                      child: Icon(
                        Icons.refresh,
                        color: AppColors.primaryColor,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: sizeHeight * 0.1,
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  LanguageClass.isEnglish ? "Your Credit" : "رصيدك ",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 21,
                      color: Color(0xffA3A3A3),
                      fontFamily: 'roman'),
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  myWalletResponseModel?.message?.toString() ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'bold',
                      fontSize: 38,
                      color: AppColors.blackColor),
                ),
              ),
              SizedBox(
                height: 30,
              ),

              countryid == 3
                  ? SizedBox()
                  : InkWell(
                      onTap: () {
                        if (widget.user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<ReservationCubit>(
                                create: (context) => ReservationCubit(),
                                child: SelectPaymentScreen(user: widget.user),
                              ),
                            ),
                          ).then((value) {
                            get();
                          });
                        } else {
                          Navigator.pushNamed(
                              context, arguments: 'wallet', Routes.signInRoute);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 40),

                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(41)),
                          child: Center(
                            child: Text(
                              LanguageClass.isEnglish
                                  ? "Add Credit"
                                  : "شحن محفظتي",
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontFamily: 'bold',
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
      ),
    );
  }
}
