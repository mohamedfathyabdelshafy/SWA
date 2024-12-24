import 'dart:convert';
import 'dart:developer';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/payment/fawry/presentation/screens/fawry.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_states_my_wallet.dart';
import 'package:swa/select_payment2/presentation/credit_card/model/card_model.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/navigation_helper.dart';
import 'package:swa/features/Swa_umra/Screens/payment/Addcard_umra.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/screens/credit_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Umracardpay extends StatefulWidget {
  int index;
  User user;

  Umracardpay({super.key, required this.index, required this.user});

  @override
  State<Umracardpay> createState() => _UmracardpayState();
}

class _UmracardpayState extends State<Umracardpay> {
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

  UmraBloc _umraBloc = new UmraBloc();

  @override
  void initState() {
    // final jsonData = json.decode(CacheHelper.getDataToSharedPref(key: 'cards'));
    final jsonData = CacheHelper.getDataToSharedPref(key: 'cards');
    print(jsonData.runtimeType);
    print(jsonData);
    print("EEeeeeeeeeeeeeeeeeeeeeeeeee");
    widget.index = 0;

    amountController.text = UmraDetails.afterdiscount.toString();

    if (jsonData != null && jsonData is String) {
      cards = json
          .decode(jsonData)
          .map<CardModel>((e) => CardModel.fromJsom(e))
          .toList();
    }
    print("cached cards ${cards}");
    super.initState();
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
    double sizeHeight = context.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener(
        bloc: _umraBloc,
        listener: (context, UmraState state) {
          // TODO: implement listener

          if (state.reservationResponseCreditCard?.status == 'success') {
            showDoneConfirmationDialog(context,
                callbackTitle: "Go to OTP",
                message: 'Complete the payment process', callback: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ConfirmPayWebView(
                            webViewLink: state.reservationResponseCreditCard!
                                .message!.nextAction!.redirectUrl!,
                          ))).then((value) {
                Navigator.pop(context);
              });
              // launchUrl(Uri.parse(state.url.toString()));
            });
          } else if (state.reservationResponseCreditCard?.status == 'failed') {
            Constants.hideLoadingDialog(context);
            Constants.showDefaultSnackBar(
                context: context,
                color: AppColors.umragold,
                text: state.reservationResponseCreditCard!.errormessage
                    .toString());
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
                      child: Column(children: [
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
                              LanguageClass.isEnglish ? 'Payment' : "الدفع",
                              style: TextStyle(
                                  fontSize: 24.sp,
                                  fontFamily: 'bold',
                                  fontWeight: FontWeight.w500),
                            )),
                        Form(
                          key: formKey,
                          child: SizedBox(
                            child: SafeArea(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    border: Border.all(
                                                        color: AppColors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
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
                                                    (widget.index >= 0 &&
                                                            cards.isNotEmpty)
                                                        ? Expanded(
                                                            child: InkWell(
                                                              onTap: () {
                                                                showModalBottomSheet(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          30),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            270,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              LanguageClass.isEnglish ? 'Choose Card' : 'اختر كارت ',
                                                                              style: TextStyle(fontSize: 15, fontFamily: "bold", color: AppColors.blackColor),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Divider(
                                                                                thickness: 0.5,
                                                                                color: AppColors.grey),
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
                                                                                            value: widget.index == index ? true : false,
                                                                                            activeColor: Colors.yellow,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
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
                                                                                            style: TextStyle(
                                                                                              fontSize: 20,
                                                                                              fontFamily: "regular",
                                                                                              color: Colors.black,
                                                                                            ),
                                                                                          ),
                                                                                          Spacer(),
                                                                                          InkWell(
                                                                                            onTap: () {
                                                                                              setState(() {
                                                                                                if (index >= 0 && index < cards.length) {
                                                                                                  cards.removeAt(index);
                                                                                                }
                                                                                                // cards.removeAt(index);
                                                                                                CacheHelper.setDataToSharedPref(
                                                                                                  key: "cards",
                                                                                                  value: json.encode(
                                                                                                    cards.map((e) => e.toJson()).toList(),
                                                                                                  ),
                                                                                                );
                                                                                                Navigator.pop(context);
                                                                                                //  Navigator.pop(context);
                                                                                              });
                                                                                              CacheHelper.setDataToSharedPref(
                                                                                                key: "cards",
                                                                                                value: json.encode(
                                                                                                  cards.map((e) => e.toJson()).toList(),
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
                                                                            Divider(
                                                                                thickness: 0.5,
                                                                                color: AppColors.grey),
                                                                            Row(
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: sizeWidth * 0.03,
                                                                                ),
                                                                                Container(
                                                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.grey),
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
                                                                                          return const Addcardumra();
                                                                                        },
                                                                                      ),
                                                                                    );
                                                                                    if (card is CardModel) {
                                                                                      cards.add(card);
                                                                                      setState(() {});
                                                                                    }
                                                                                  },
                                                                                  child: Text(
                                                                                    LanguageClass.isEnglish ? 'Add New Card' : 'اضافة كارت جديد',
                                                                                    style: TextStyle(fontSize: 15.45, fontFamily: "bold", color: AppColors.blackColor),
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
                                                                      (widget.index >= 0 &&
                                                                              widget.index < cards.length)
                                                                          ? "XXXX-XXXX-XXXX-${cards[widget.index].cardNumber!.substring(cards[widget.index].cardNumber!.length - 4)}"
                                                                          : "Choose Card",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontFamily:
                                                                              "regular",
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  const Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down_outlined,
                                                                    size: 30,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : InkWell(
                                                            onTap: () async {
                                                              //Navigator.pop(context);
                                                              final card =
                                                                  await Navigator
                                                                      .push<
                                                                          CardModel>(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                    return Addcardumra();
                                                                  },
                                                                ),
                                                              );
                                                              if (card
                                                                  is CardModel) {
                                                                cards.add(card);
                                                                setState(() {});
                                                              }
                                                            },
                                                            child: Text(
                                                              LanguageClass
                                                                      .isEnglish
                                                                  ? 'Add credit Card'
                                                                  : "اضافة كارت جديد",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      15.45,
                                                                  fontFamily:
                                                                      "bold",
                                                                  color: AppColors
                                                                      .blackColor),
                                                            ),
                                                          )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              (widget.index >= 0 &&
                                                      cards.isNotEmpty)
                                                  ? PayField(
                                                      height: 20,
                                                      width: 1,
                                                      color: const Color(
                                                          0xff47A9EB),
                                                      hint: LanguageClass
                                                              .isEnglish
                                                          ? 'CVV'
                                                          : 'رقم السري',
                                                      textInputType:
                                                          TextInputType.number,
                                                      onChange: (value) {
                                                        setState(() {
                                                          showCardBack = true;
                                                          cvv = value;
                                                        });
                                                      },
                                                      focusNode: cvvNode,
                                                      maxLength: 3,
                                                      onFieldSubmitted:
                                                          (value) {
                                                        setState(() {
                                                          showCardBack = false;
                                                          amountNode
                                                              .requestFocus();
                                                        });
                                                      },
                                                    )
                                                  : const SizedBox(),
                                              (widget.index >= 0 &&
                                                      cards.isNotEmpty)
                                                  ? Row(
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: 1,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Color(
                                                                      0xffD865A4)),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                              height:
                                                                  sizeHeight *
                                                                      0.07,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          2,
                                                                      horizontal:
                                                                          18),
                                                              decoration: const BoxDecoration(
                                                                  // border: Border.all(
                                                                  //   color: AppColors.blue,
                                                                  //   width: 0.3,
                                                                  // ),
                                                                  // borderRadius:
                                                                  // const BorderRadius.all(Radius.circular(10))
                                                                  ),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    //    padding:
                                                                    //    const EdgeInsets.symmetric(vertical: 2, horizontal: 18),

                                                                    child:
                                                                        TextFormField(
                                                                      autofocus:
                                                                          true,
                                                                      style: fontStyle(
                                                                          color: AppColors
                                                                              .blackColor,
                                                                          fontSize:
                                                                              16),
                                                                      cursorColor:
                                                                          AppColors
                                                                              .blue,
                                                                      controller:
                                                                          amountController,
                                                                      readOnly:
                                                                          true,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            InputBorder.none,
                                                                        hintText: LanguageClass.isEnglish
                                                                            ? 'Amount'
                                                                            : 'القيمة',
                                                                        errorStyle:
                                                                            fontStyle(
                                                                          color:
                                                                              Colors.red,
                                                                          fontSize:
                                                                              11,
                                                                        ),
                                                                        hintStyle: fontStyle(
                                                                            color: AppColors
                                                                                .greyLight,
                                                                            fontSize:
                                                                                15,
                                                                            fontFamily:
                                                                                FontFamily.bold),
                                                                        labelStyle: fontStyle(
                                                                            color: AppColors
                                                                                .grey,
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                FontFamily.bold),
                                                                      ),
                                                                      validator:
                                                                          (value) {
                                                                        if (value!
                                                                            .isEmpty) {
                                                                          return 'This Field is Required';
                                                                        } else {
                                                                          return null;
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              InkWell(
                                                onTap: cards.isNotEmpty
                                                    ? () {
                                                        if (widget.index < 0 ||
                                                            cards.isEmpty) {
                                                          Constants.showDefaultSnackBar(
                                                              color: AppColors
                                                                  .umragold,
                                                              context: context,
                                                              text: LanguageClass
                                                                      .isEnglish
                                                                  ? 'Select card'
                                                                  : 'اختر البطاقة');
                                                        } else {
                                                          print(cards[
                                                                  widget.index]
                                                              .cardNumber!
                                                              .toString()
                                                              .replaceAll(
                                                                  " ", ""));
                                                          if (formKey
                                                              .currentState!
                                                              .validate()) {
                                                            _umraBloc.add(
                                                                cardpaymentEvent(
                                                              PaymentMethodID:
                                                                  4,
                                                              paymentTypeID: 68,
                                                              cvv: cvv
                                                                  .toString(),
                                                              cardNumber: cards[
                                                                      widget
                                                                          .index]
                                                                  .cardNumber!
                                                                  .toString()
                                                                  .replaceAll(
                                                                      " ", ""),
                                                              cardExpiryYear:
                                                                  cards[widget
                                                                          .index]
                                                                      .month!
                                                                      .substring(
                                                                        3,
                                                                      )
                                                                      .toString(),
                                                              cardExpiryMonth:
                                                                  cards[widget
                                                                          .index]
                                                                      .month!
                                                                      .substring(
                                                                          0, 2)
                                                                      .toString(),
                                                            ));
                                                          }
                                                        }
                                                      }
                                                    : () {
                                                        Constants.showDefaultSnackBar(
                                                            color: AppColors
                                                                .umragold,
                                                            context: context,
                                                            text: LanguageClass
                                                                    .isEnglish
                                                                ? 'Add card'
                                                                : 'إضافة بطاقة');
                                                      },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(25),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 70,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  50)),
                                                    ),
                                                    child: Container(
                                                      height: 65,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .umragold,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            LanguageClass
                                                                    .isEnglish
                                                                ? 'Pay'
                                                                : 'ادفع',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "bold"),
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])));
            }
          },
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
          width: 5,
        ),
        SizedBox(
          height: 60,
          width: 265,
          child: TextFormField(
              controller: ctr,
              keyboardType: textInputType,
              style: TextStyle(color: Colors.black),
              // style: fontStyle(color: MyColors.blue, fontSize: 14),
              // cursorColor: MyColors.blue,
              decoration: InputDecoration(
                hintText: hint,

                border: InputBorder.none,
                // errorStyle: fontStyle(color: Colors.red, fontSize: 12),
                hintStyle: TextStyle(
                    color: AppColors.grey, fontSize: 12, fontFamily: "bold"),
                labelStyle: TextStyle(
                    color: AppColors.grey, fontSize: 12, fontFamily: "bold"),
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
    required Function callback}) async {
  return CoolAlert.show(
      barrierDismissible: false,
      context: context,
      confirmBtnText: "ok",
      title: isError ? 'error' : 'success',
      lottieAsset: isError ? 'assets/json/error.json' : 'assets/json/done.json',
      type: isError ? CoolAlertType.error : CoolAlertType.success,
      loopAnimation: false,
      backgroundColor: isError ? Colors.red : Colors.white,
      text: message,
      onConfirmBtnTap: () {
        callback();
      });
}

// void showWebViewDialog(BuildContext context, String? url) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('WebView Dialog'),
//         content: Container(
//             height: 300, // Adjust the height as needed
//             width: 300, // Adjust the width as needed
//             child: InkWell(
//               onTap: () {
//                 launchUrl(Uri.parse(url ?? ""),
//                     mode: LaunchMode.externalApplication);
//               },
//               child: Container(
//                 child: Text(
//                   "url",
//                 ),
//               ),
//             )),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Close'),
//           ),
//         ],
//       );
//     },
//   );
// }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.home, (route) => false,
                    arguments: Routes.isomra);
              },
              icon: Icon(
                Icons.home_outlined,
                color: AppColors.white,
                size: 35,
              ))
        ],
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            Navigator.pushNamedAndRemoveUntil(
                NavHelper().navigatorKey.currentContext!,
                Routes.home,
                (route) => false,
                arguments: Routes.isomra);

            return Future.value(false);
          },
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
                              callbackTitle: LanguageClass.isEnglish
                                  ? 'Payment Error'
                                  : 'حدث خطاء اثنا الدفع',
                              message: LanguageClass.isEnglish
                                  ? 'Payment Error'
                                  : 'حدث خطاء اثنا الدفع', callback: () {
                            Navigator.pop(
                              context,
                            );
                            Navigator.pop(
                              context,
                            );
                          });
                        });

                        return NavigationDecision.prevent;
                      } else if (request.url
                          .startsWith('https://swabus.com/Home/FawryCharge')) {
                        await Future.delayed(const Duration(seconds: 2), () {
                          showDoneConfirmationDialog(context,
                              message: LanguageClass.isEnglish
                                  ? 'Payment completed successfully'
                                  : 'تم عملية الدفع بنجاح', callback: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.home, (route) => false,
                                arguments: Routes.isomra);
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