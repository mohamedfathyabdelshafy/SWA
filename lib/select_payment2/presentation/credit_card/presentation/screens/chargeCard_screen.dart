import 'dart:convert';
import 'dart:developer';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/currency_selector.dart';
import 'package:swa/features/Swa_umra/Screens/Select_type.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/home/presentation/cubit/home_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/features/home/presentation/screens/tabs/my_home.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/payment/fawry/presentation/screens/fawry.dart';
import 'package:swa/features/payment/fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/data/models/Curruncy_model.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_states_my_wallet.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/navigation_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import '../../model/card_model.dart';
import 'credit_card.dart';

class AddWalletBalanceWithCreditCardScreen extends StatefulWidget {
  int index;
  User user;

  AddWalletBalanceWithCreditCardScreen({super.key, required this.index, required this.user});

  @override
  State<AddWalletBalanceWithCreditCardScreen> createState() => _AddWalletBalanceWithCreditCardScreenState();
}

class _AddWalletBalanceWithCreditCardScreenState extends State<AddWalletBalanceWithCreditCardScreen> {
  final price = CacheHelper.getDataToSharedPref(key: 'price');

  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  List<CardModel> cards = [];
  TextEditingController cardHolderName = TextEditingController();
  TextEditingController expiryFieldCtrl = TextEditingController();
  TextEditingController cardNumberCtrl = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool showCardBack = false;
  int selectedIndex = 0;
  FocusNode cardHolderNameNode = FocusNode();
  FocusNode cardNumberNode = FocusNode();
  FocusNode amountNode = FocusNode();
  FocusNode cardDateNode = FocusNode();
  FocusNode cvvNode = FocusNode();

  @override
  void initState() {
    // final jsonData = json.decode(CacheHelper.getDataToSharedPref(key: 'cards'));
    final jsonData = CacheHelper.getDataToSharedPref(key: 'cards');
    print(jsonData.runtimeType);
    print(jsonData);
    print("EEeeeeeeeeeeeeeeeeeeeeeeeee");
    widget.index = 0;

    if (jsonData != null && jsonData is String) {
      cards = json.decode(jsonData).map<CardModel>((e) => CardModel.fromJsom(e)).toList();
    }
    print("cached cards ${cards}");
    getwalllet();
    selectedcurruncy = Routes.curruncy!;

    super.initState();
  }

  Curruncylist? curruncylist;
  String selectedcurruncy = '';

  getwalllet() async {
    var responce = await PackagesRespo().GetallCurrency();

    Constants.showLoadingDialog(context);

    if (responce is Curruncylist) {
      curruncylist = responce;

      Constants.hideLoadingDialog(context);
    }
  }

  bool isloading = false;

  double payamount = 0.0;

  convertcurruncy({String? from, String? to, double? amount}) async {
    isloading = true;
    var responce = await PackagesRespo().Convertcurrency(amount: amount, from: from, to: to);

    setState(() {
      payamount = responce;

      isloading = false;
    });
  }

  @override
  void dispose() {
    cardHolderName.dispose();
    cardNumberNode.dispose();
    amountNode.dispose();
    cardDateNode.dispose();
    cvvNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
              size: 32,
            )),
      ),
      body: Directionality(
        textDirection: LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Form(
          key: formKey,
          child: SizedBox(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  LanguageClass.isEnglish ? 'Payment' : "الدفع",
                                  style:
                                      fontStyle(color: AppColors.blackColor, fontSize: 30, fontFamily: FontFamily.bold),
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      border: Border.all(color: AppColors.grey),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/master_card.png',
                                        height: 11,
                                        width: 17,
                                        fit: BoxFit.fitWidth,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      (widget.index >= 0 && cards.isNotEmpty)
                                          ? Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return Padding(
                                                        padding: const EdgeInsets.all(30),
                                                        child: Container(
                                                          height: 270,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                LanguageClass.isEnglish ? 'Choose Card' : 'اختر كارت ',
                                                                style: fontStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: FontFamily.bold,
                                                                    color: AppColors.blackColor),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Divider(thickness: 0.5, color: AppColors.grey),
                                                              Column(
                                                                children: List<Widget>.generate(cards.length, (index) {
                                                                  return Column(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap: () {
                                                                          Navigator.pop(context);
                                                                          setState(() {
                                                                            widget.index = index;
                                                                          });
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            Checkbox(
                                                                              value:
                                                                                  widget.index == index ? true : false,
                                                                              activeColor: Colors.yellow,
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius:
                                                                                      BorderRadius.circular(100)),
                                                                              onChanged: (value) {},
                                                                            ),
                                                                            Image.asset(
                                                                              'assets/images/master_card.png',
                                                                              height: 11,
                                                                              width: 17,
                                                                              fit: BoxFit.fitWidth,
                                                                            ),
                                                                            Text(
                                                                              "XXXX-XXXX-XXXX-${cards[index].cardNumber!.substring(cards[index].cardNumber!.length - 4)}",
                                                                              style: fontStyle(
                                                                                fontSize: 20,
                                                                                fontFamily: FontFamily.regular,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  if (index >= 0 &&
                                                                                      index < cards.length) {
                                                                                    cards.removeAt(index);
                                                                                  }
                                                                                  // cards.removeAt(index);
                                                                                  CacheHelper.setDataToSharedPref(
                                                                                    key: "cards",
                                                                                    value: json.encode(
                                                                                      cards
                                                                                          .map((e) => e.toJson())
                                                                                          .toList(),
                                                                                    ),
                                                                                  );
                                                                                  Navigator.pop(context);
                                                                                  //  Navigator.pop(context);
                                                                                });
                                                                                CacheHelper.setDataToSharedPref(
                                                                                  key: "cards",
                                                                                  value: json.encode(
                                                                                    cards
                                                                                        .map((e) => e.toJson())
                                                                                        .toList(),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              child: Icon(Icons.delete),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                }),
                                                              ),
                                                              Divider(thickness: 0.5, color: AppColors.grey),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: sizeWidth * 0.03,
                                                                  ),
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          color: AppColors.grey),
                                                                      child: const Icon(
                                                                        Icons.add,
                                                                        color: Colors.lightGreen,
                                                                        size: 20,
                                                                      )),
                                                                  SizedBox(
                                                                    width: sizeWidth * 0.03,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      Navigator.pop(context);
                                                                      final card = await Navigator.push<CardModel>(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) {
                                                                            return const AddCreditCard();
                                                                          },
                                                                        ),
                                                                      );
                                                                      if (card is CardModel) {
                                                                        cards.add(card);
                                                                        setState(() {});
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      LanguageClass.isEnglish
                                                                          ? 'Add New Card'
                                                                          : 'اضافة كارت جديد',
                                                                      style: fontStyle(
                                                                          fontSize: 15.45,
                                                                          fontFamily: FontFamily.bold,
                                                                          color: AppColors.blackColor),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        (widget.index >= 0 && widget.index < cards.length)
                                                            ? "XXXX-XXXX-XXXX-${cards[widget.index].cardNumber!.substring(cards[widget.index].cardNumber!.length - 4)}"
                                                            : "Choose Card",
                                                        style: fontStyle(
                                                            fontSize: 18,
                                                            fontFamily: FontFamily.regular,
                                                            color: Colors.black),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    const Icon(
                                                      Icons.keyboard_arrow_down_outlined,
                                                      size: 30,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () async {
                                                //Navigator.pop(context);
                                                final card = await Navigator.push<CardModel>(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return AddCreditCard();
                                                    },
                                                  ),
                                                );
                                                if (card is CardModel) {
                                                  cards.add(card);
                                                  setState(() {});
                                                }
                                              },
                                              child: Text(
                                                LanguageClass.isEnglish ? 'Add credit Card' : "اضافة كارت جديد",
                                                style: fontStyle(
                                                    fontSize: 15.45,
                                                    fontFamily: FontFamily.bold,
                                                    color: AppColors.blackColor),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                (widget.index >= 0 && cards.isNotEmpty)
                                    ? PayField(
                                        height: 20,
                                        width: 1,
                                        color: const Color(0xff47A9EB),
                                        hint: LanguageClass.isEnglish ? 'CVV' : 'رقم السري',
                                        textInputType: TextInputType.number,
                                        onChange: (value) {
                                          setState(() {
                                            showCardBack = true;
                                            cvv = value;
                                          });
                                        },
                                        focusNode: cvvNode,
                                        maxLength: 3,
                                        onFieldSubmitted: (value) {
                                          setState(() {
                                            showCardBack = false;
                                            amountNode.requestFocus();
                                          });
                                        },
                                      )
                                    : const SizedBox(),
                                (widget.index >= 0 && cards.isNotEmpty)
                                    ? Row(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 1,
                                            decoration: const BoxDecoration(color: Color(0xffD865A4)),
                                          ),
                                          Expanded(
                                            child: Container(
                                                height: sizeHeight * 0.07,
                                                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                                                decoration: const BoxDecoration(
                                                    // border: Border.all(
                                                    //   color: AppColors.blue,
                                                    //   width: 0.3,
                                                    // ),
                                                    // borderRadius:
                                                    // const BorderRadius.all(Radius.circular(10))
                                                    ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      //    padding:
                                                      //    const EdgeInsets.symmetric(vertical: 2, horizontal: 18),

                                                      child: TextFormField(
                                                        autofocus: true,
                                                        style: fontStyle(color: AppColors.blackColor, fontSize: 16),
                                                        cursorColor: AppColors.blue,
                                                        controller: amountController,
                                                        inputFormatters: [
                                                          NumericTextFormatter(),
                                                          FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                                                        ],
                                                        keyboardType: TextInputType.number,
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          hintText: LanguageClass.isEnglish ? 'Amount' : 'القيمة',
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
                                                    4.horizontalSpace,
                                                    2.horizontalSpace,
                                                    InkWell(
                                                      onTap: () {
                                                        showCurrencySelector(context,
                                                            currencyList: curruncylist!.message!,
                                                            onCurrencySelected: (currency) {
                                                          setState(() {
                                                            amountController.text = '';
                                                            selectedcurruncy = currency.symbol!;
                                                          });
                                                          Navigator.pop(context);
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              selectedcurruncy,
                                                              style: fontStyle(
                                                                  color: Colors.black, fontFamily: FontFamily.bold),
                                                            ),
                                                            4.horizontalSpace,
                                                            Icon(
                                                              Icons.arrow_drop_down_rounded,
                                                              color: AppColors.umragold,
                                                              size: 20,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 50,
                                ),
                                BlocListener(
                                  bloc: BlocProvider.of<ReservationCubit>(context),
                                  listener: (context, state) {
                                    if (state is LoadingCreditCardState || isloading) {
                                      Constants.showLoadingDialog(context);
                                    } else if (state is LoadedCreditCardState) {
                                      Constants.hideLoadingDialog(context);

                                      NavHelper().navigate(ConfirmPayWebView(
                                        webViewLink:
                                            state.reservationResponseCreditCard.message!.nextAction!.redirectUrl!,
                                      ));

                                      showDoneConfirmationDialog(context,
                                          callbackTitle: "Go to OTP",
                                          isWarning: true,
                                          message: LanguageClass.isEnglish
                                              ? 'Complete the payment process'
                                              : 'اكمل عملية الدفع', callback: () {
                                        // NavHelper().goBack();
                                      });
                                    } else if (state is ErrorCreditCardState) {
                                      Constants.hideLoadingDialog(context);
                                      Constants.showDefaultSnackBar(context: context, text: state.error.toString());
                                    }
                                  },
                                  child: InkWell(
                                    onTap: cards.isNotEmpty
                                        ? () {
                                            if (widget.index < 0) {
                                              Constants.showDefaultSnackBar(
                                                  color: Colors.red, context: context, text: 'Select card');
                                            } else {
                                              if (formKey.currentState!.validate()) {
                                                double? amount =
                                                    double.tryParse(amountController.text.replaceAll(',', ''));
                                                log("Amount $amount");

                                                convertcurruncy(
                                                  amount: amount,
                                                  from: selectedcurruncy,
                                                  to: 'EGP',
                                                ).then((value) {
                                                  log("expiry ${cards[widget.index].month}");
                                                  BlocProvider.of<ReservationCubit>(context).chargebycard(
                                                    custId: widget.user.customerId!,
                                                    curruncy: selectedcurruncy,
                                                    amount: payamount.toStringAsFixed(2).toString(),
                                                    cvv: cvv.toString(),
                                                    cardNumber:
                                                        cards[widget.index].cardNumber!.toString().replaceAll(" ", ""),
                                                    cardExpiryYear: cards[widget.index]
                                                        .month!
                                                        .substring(
                                                          3,
                                                        )
                                                        .toString(),
                                                    cardExpiryMonth:
                                                        cards[widget.index].month!.substring(0, 2).toString(),
                                                  );
                                                });
                                              }
                                            }
                                          }
                                        : () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: Container(
                                        width: 200,
                                        height: 70,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                        ),
                                        child: Container(
                                          height: 65,
                                          decoration: BoxDecoration(
                                              color: Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
                                              borderRadius: BorderRadius.circular(15)),
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                LanguageClass.isEnglish ? 'Charge' : 'شحن',
                                                style: fontStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: FontFamily.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PayField extends StatelessWidget {
  PayField(
      {required this.hint,
      required this.onChange,
      this.ctr,
      this.maxLength,
      this.focusNode,
      this.textInputType,
      this.onFieldSubmitted,
      this.height,
      required this.color,
      this.width});
  final TextEditingController? ctr;
  final String hint;
  final Function onChange;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final Function? onFieldSubmitted;
  final double? height;
  final double? width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(color: color),
        ),
        const SizedBox(
          width: 15,
        ),
        SizedBox(
          height: 60,
          width: 265,
          child: TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              controller: ctr,
              keyboardType: textInputType,
              style: fontStyle(color: Colors.black),
              // style: fontStyle(color: MyColors.blue, fontSize: 14),
              // cursorColor: MyColors.blue,
              decoration: InputDecoration(
                hintText: hint,
                contentPadding: EdgeInsets.only(top: 10),

                border: InputBorder.none,
                // errorStyle: fontStyle(color: Colors.red, fontSize: 12),
                hintStyle: fontStyle(fontSize: 15, fontFamily: FontFamily.bold, color: AppColors.greyLight),
                labelStyle: fontStyle(color: AppColors.grey, fontSize: 12, fontFamily: FontFamily.bold),
                // contentPadding: const EdgeInsets.symmetric(
                //   horizontal: 10,
                //   vertical: 5,
                // ),
                // counterText: "",
              ),
              maxLength: maxLength ?? 16,
              onChanged: (value) => onChange(value),
              focusNode: focusNode,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This Field is Required';
                } else {
                  return null;
                }
              },
              onFieldSubmitted: (value) {
                if (onFieldSubmitted != null) {
                  onFieldSubmitted!(value);
                }
              }),
        ),
        const Icon(
          Icons.info_rounded,
          color: Color(0xff616B80),
          size: 2,
        )
      ],
    );
  }
}

Future<dynamic> showDoneConfirmationDialog(BuildContext context,
    {required String message,
    String? callbackTitle,
    bool isError = false,
    bool isWarning = false,
    required VoidCallback? callback}) async {
  return CoolAlert.show(
      barrierDismissible: false,
      context: context,
      confirmBtnText: "ok",
      title: isError
          ? LanguageClass.isEnglish
              ? 'Error'
              : 'خطأ'
          : isWarning
              ? LanguageClass.isEnglish
                  ? 'Please'
                  : 'يرجى'
              : LanguageClass.isEnglish
                  ? 'Success'
                  : 'تم بنجاح',
      lottieAsset: isError
          ? 'assets/json/error.json'
          : isWarning
              ? 'assets/json/Warning.json'
              : 'assets/json/done.json',
      type: isError ? CoolAlertType.error : CoolAlertType.success,
      loopAnimation: false,
      backgroundColor: isError ? Colors.red : Colors.white,
      text: message,
      onConfirmBtnTap: callback);
}

class ConfirmPayWebView extends StatefulWidget {
  final String webViewLink;
  ConfirmPayWebView({
    Key? key,
    required this.webViewLink,
  }) : super(key: key);

  @override
  State<ConfirmPayWebView> createState() => _ConfirmPayWebViewState();
}

class _ConfirmPayWebViewState extends State<ConfirmPayWebView> {
  WebViewController controller = WebViewController();
  @override
  void initState() {
    controller.loadRequest(Uri.parse(widget.webViewLink));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("henaaa 222");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            NavHelper().goBack();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                // NavHelper().navigate();
                // Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false, arguments: Routes.isomra);
              },
              icon: Icon(
                Icons.home_outlined,
                color: AppColors.white,
                size: 35,
              ))
        ],
      ),
      body: SafeArea(
        child: PopScope(
          canPop: false,
          child: WebViewWidget(
              controller: controller
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(const Color(0x00000000))
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onProgress: (int progress) {
                      // Update loading bar.
                    },
                    onPageStarted: (String url) {},
                    onPageFinished: (String url) {},
                    onWebResourceError: (WebResourceError error) {},
                    onNavigationRequest: (NavigationRequest request) async {
                      log(request.url);
                      if (request.url.contains('825151')) {
                        await Future.delayed(const Duration(seconds: 2), () {
                          showDoneConfirmationDialog(context,
                              isError: true,
                              callbackTitle: LanguageClass.isEnglish ? 'Payment Error' : 'حدث خطاء اثنا الدفع',
                              message: LanguageClass.isEnglish ? 'Payment Error' : 'حدث خطاء اثنا الدفع', callback: () {
                            NavHelper().goBack();
                            NavHelper().goBack();
                          });
                        });

                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith('https://swabus.com/Home/FawryCharge')) {
                        await Future.delayed(const Duration(seconds: 2), () {
                          showDoneConfirmationDialog(context,
                              message: LanguageClass.isEnglish
                                  ? 'Payment completed successfully'
                                  : 'تم عملية الدفع بنجاح', callback: () {
                            NavHelper().navigate(
                                MultiBlocProvider(providers: [
                                  BlocProvider<LoginCubit>(
                                    create: (context) => sl<LoginCubit>(),
                                  ),
                                  BlocProvider<PackagesBloc>(
                                    create: (context) => PackagesBloc(),
                                  ),
                                  BlocProvider<FawryReservation>(
                                    create: (context) => sl<FawryReservation>(),
                                  ),
                                  BlocProvider<GetAvailableCountriesCubit>(
                                    create: (context) => sl<GetAvailableCountriesCubit>(),
                                  ),
                                  BlocProvider<HomeCubit>(
                                    create: (context) => sl<HomeCubit>(),
                                  ),
                                  BlocProvider<TimesTripsCubit>(create: (context) => sl<TimesTripsCubit>()),
                                  BlocProvider<TicketCubit>(create: (context) => sl<TicketCubit>()),
                                ], child: Routes.isomra ? SelectUmratypeScreen() : MyHome()),
                                replace: true);
                          });
                        });

                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                )),
        ),
      ),
    );
  }
}
