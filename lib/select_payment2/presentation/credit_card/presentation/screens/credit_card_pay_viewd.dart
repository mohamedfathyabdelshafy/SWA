import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_states_my_wallet.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/navigation_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import '../../model/card_model.dart';
import 'credit_card.dart';

class CreditCardPayView extends StatefulWidget {
  int index;
  User user;

  CreditCardPayView({super.key, required this.index,required this.user});

  @override
  State<CreditCardPayView> createState() => _CreditCardPayViewState();
}

class _CreditCardPayViewState extends State<CreditCardPayView> {
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.primaryColor,
              size: 32,
            )),
      ),
      body: Form(
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
                                LanguageClass.isEnglish? 'Payment':'دفع',
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 30,
                                    fontFamily: "bold"),
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
                                        ? InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30),
                                                    child: Container(
                                                      height: 270,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            LanguageClass.isEnglish?'Choose Card':"اختر كارت",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "bold",
                                                                color: AppColors
                                                                    .blackColor),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Divider(
                                                              thickness: 0.5,
                                                              color: AppColors
                                                                  .grey),
                                                          Column(
                                                            children: List<
                                                                    Widget>.generate(
                                                                cards.length,
                                                                (index) {
                                                              return Column(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      setState(
                                                                          () {
                                                                        widget.index =
                                                                            index;
                                                                      });
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Checkbox(
                                                                          value: widget.index == index
                                                                              ? true
                                                                              : false,
                                                                          activeColor:
                                                                              Colors.yellow,
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                                                          onChanged:
                                                                              (value) {},
                                                                        ),
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/master_card.png',
                                                                          height:
                                                                              11,
                                                                          width:
                                                                              17,
                                                                          fit: BoxFit
                                                                              .fitWidth,
                                                                        ),
                                                                        Text(
                                                                          "XXXX-XXXX-XXXX-${cards[index].cardNumber!.substring(cards[index].cardNumber!.length - 4)}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontFamily:
                                                                                "regular",
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        Spacer(),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
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
                                                                          child:
                                                                              Icon(Icons.delete),
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
                                                              color: AppColors
                                                                  .grey),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width:
                                                                    sizeWidth *
                                                                        0.03,
                                                              ),
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: AppColors
                                                                          .grey),
                                                                  child:
                                                                      const Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .lightGreen,
                                                                    size: 20,
                                                                  )),
                                                              SizedBox(
                                                                width:
                                                                    sizeWidth *
                                                                        0.03,
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  final card =
                                                                      await Navigator
                                                                          .push<
                                                                              CardModel>(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                                        return const AddCreditCard();
                                                                      },
                                                                    ),
                                                                  );
                                                                  if (card
                                                                      is CardModel) {
                                                                    cards.add(
                                                                        card);
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                },
                                                                child: Text(
                                                                  LanguageClass.isEnglish?'Add New Card':"اضافة كارت جديد",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15.45,
                                                                      fontFamily:
                                                                          "bold",
                                                                      color: AppColors
                                                                          .blackColor),
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
                                                Text(
                                                  (widget.index >= 0 &&
                                                          widget.index <
                                                              cards.length)
                                                      ? "XXXX-XXXX-XXXX-${cards[widget.index].cardNumber!.substring(cards[widget.index].cardNumber!.length - 4)}"
                                                      : "Choose Card",
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: "regular",
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                const Icon(
                                                  Icons
                                                      .keyboard_arrow_down_outlined,
                                                  size: 30,
                                                )
                                              ],
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () async {
                                              //Navigator.pop(context);
                                              final card = await Navigator.push<
                                                  CardModel>(
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
                                              LanguageClass.isEnglish?'Add credit Card':"اضافة كارت جديد",
                                              style: TextStyle(
                                                  fontSize: 15.45,
                                                  fontFamily: "bold",
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
                                      hint:  LanguageClass.isEnglish?'CVV':"الرقم السري",
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
                                          decoration: const BoxDecoration(
                                              color: Color(0xffD865A4)),
                                        ),
                                        Container(
                                            height: sizeHeight * 0.07,
                                            width: 300,
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
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  LanguageClass.isEnglish?"amount":"القيمة",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: "bold",
                                                      color:
                                                          AppColors.greyLight),
                                                ),
                                                Text(
                                                  price.toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: "bold",
                                                      color: AppColors
                                                          .primaryColor),
                                                )
                                              ],
                                            )),
                                      ],
                                    )
                                  : const SizedBox(),
                              const Spacer(),
                              BlocListener(
                                bloc:
                                    BlocProvider.of<ReservationCubit>(context),
                                listener: (context, state) {
                                  if (state is LoadingCreditCardState) {
                                    Constants.showLoadingDialog(context);
                                  } else if (state is LoadedCreditCardState) {
                                    Navigator.pop(context);

                                    showDoneConfirmationDialog(context,
                                        callbackTitle: "Go to OTP",
                                        message: 'Complete the payment process',
                                        callback: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => ConfirmPayWebView(
                                                    webViewLink: state
                                                        .reservationResponseCreditCard
                                                        .message!
                                                        .nextAction!
                                                        .redirectUrl!,
                                                  )));
                                      // launchUrl(Uri.parse(state.url.toString()));
                                    });

                                    // Constants.hideLoadingDialog(context);
                                    // showWebViewDialog(
                                    //     context,
                                    //     state
                                    //             .reservationResponseCreditCard
                                    //             .message
                                    //             ?.nextAction
                                    //             ?.redirectUrl ??
                                    //         "");
                                    // Constants.showDefaultSnackBar(context: context, text: state.reservationResponseCreditCard.message!.statusDescription!);

                                    // showDialog(
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return AlertDialog(
                                    //       title: Column(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceBetween,
                                    //         mainAxisSize: MainAxisSize.min,
                                    //         children: const [
                                    //           Icon(
                                    //             Icons.check_circle,
                                    //             color: Colors.green,
                                    //           ),
                                    //           Text(
                                    //               "You will get a notification by applying your wallet \n In order to agree to pay"),
                                    //         ],
                                    //       ),
                                    //       titleTextStyle: const TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           color: Colors.black,
                                    //           fontSize: 20),
                                    //       content: Column(
                                    //         mainAxisSize: MainAxisSize.min,
                                    //         children: [
                                    //           Row(
                                    //             mainAxisAlignment:
                                    //                 MainAxisAlignment
                                    //                     .spaceBetween,
                                    //             children: [
                                    //               const Text('Amount: '),
                                    //               Text(price.toString())
                                    //             ],
                                    //           ),
                                    //           Row(
                                    //             mainAxisAlignment:
                                    //                 MainAxisAlignment
                                    //                     .spaceBetween,
                                    //             children: [
                                    //               const Text('Url: '),
                                    //               InkWell(
                                    //                   onTap: () {
                                    //                     launchUrl(
                                    //                         Uri.parse(state
                                    //                                 .reservationResponseCreditCard
                                    //                                 .message!
                                    //                                 .nextAction!
                                    //                                 .redirectUrl ??
                                    //                             ""),
                                    //                         mode: LaunchMode
                                    //                             .externalApplication);
                                    //                   },
                                    //                   child: Text(state
                                    //                       .reservationResponseCreditCard
                                    //                       .message!
                                    //                       .nextAction!
                                    //                       .redirectUrl
                                    //                       .toString()))
                                    //             ],
                                    //           )
                                    //         ],
                                    //       ),
                                    //       actionsOverflowButtonSpacing: 20,
                                    //       actions: [
                                    //         ElevatedButton(
                                    //             onPressed: () {
                                    //               Navigator.pop(context);
                                    //               Navigator.pushNamed(context,
                                    //                   Routes.initialRoute);
                                    //             },
                                    //             child: Container(
                                    //               // padding: const EdgeInsets.symmetric(horizontal: 20,vertical:20),
                                    //               // margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                                    //               decoration: BoxDecoration(
                                    //                   // color: color ?? AppColors.darkRed,
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(
                                    //                           100)),
                                    //               child: Center(
                                    //                 child: Text(
                                    //                   'OK',
                                    //                   style: TextStyle(
                                    //                       color:
                                    //                           AppColors.white,
                                    //                       fontWeight:
                                    //                           FontWeight.bold,
                                    //                       fontSize: 22),
                                    //                 ),
                                    //               ),
                                    //             )),
                                    //       ],
                                    //     );
                                    //   },
                                    // );
                                  } else if (state is ErrorCreditCardState) {
                                    Constants.hideLoadingDialog(context);
                                    Constants.showDefaultSnackBar(
                                        context: context,
                                        text: state.error.toString());
                                  }
                                },
                                child: InkWell(
                                  onTap: () {
                                    print(cards[widget.index]
                                        .cardNumber!
                                        .toString()
                                        .replaceAll(" ", ""));
                                    if (formKey.currentState!.validate()) {
                                      final tripOneId =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'tripOneId');
                                      final tripRoundId =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'tripRoundId');
                                      final selectedDayTo =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'selectedDayTo');
                                      final selectedDayFrom =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'selectedDayFrom');
                                      final toStationId =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'toStationId');
                                      final fromStationId =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'fromStationId');
                                      final seatIdsOneTrip =
                                          CacheHelper.getDataToSharedPref(
                                                  key: 'countSeats')
                                              ?.map((e) => int.tryParse(e) ?? 0)
                                              .toList();
                                      final seatIdsRoundTrip =
                                          CacheHelper.getDataToSharedPref(
                                                  key: 'countSeats2')
                                              ?.map((e) => int.tryParse(e) ?? 0)
                                              .toList();
                                      final price =
                                          CacheHelper.getDataToSharedPref(
                                              key: 'price');

                                      print(cards[widget.index]
                                          .month!
                                          .substring(0, 2)
                                          .toString());

                                      print(cards[widget.index]
                                          .month!
                                          .substring(
                                            3,
                                          )
                                          .toString());

                                      print(
                                          "tripOneId${tripOneId}==tripOneId${tripRoundId}=====${seatIdsOneTrip}===${seatIdsRoundTrip}==$price");
                                      print(
                                          "tripOneId${selectedDayTo}==tripOneId${selectedDayFrom}=====${toStationId}===${fromStationId}==$price");

                                      print(
                                          "tripOneId${tripOneId}==tripOneId${tripRoundId}=====${seatIdsOneTrip}===${seatIdsRoundTrip}==$price==");

                                      // if(_user != null && formKey.currentState!.validate()) {
                                      BlocProvider.of<ReservationCubit>(context)
                                          .addReservationCreditCard(
                                        seatIdsOneTrip: seatIdsOneTrip,
                                        custId: widget.user.customerId!,
                                        oneTripID: tripOneId.toString(),
                                        paymentMethodID: 4,
                                        paymentTypeID: 68,
                                        seatIdsRoundTrip:
                                            seatIdsRoundTrip ?? [],
                                        roundTripID: tripRoundId ?? "",
                                        amount:
                                            price.toStringAsFixed(2).toString(),
                                        fromStationID: fromStationId,
                                        toStationId: toStationId,
                                        tripDateGo: selectedDayFrom,
                                        tripDateBack: selectedDayTo,
                                        cvv: cvv.toString(),
                                        cardNumber: cards[widget.index]
                                            .cardNumber!
                                            .toString()
                                            .replaceAll(" ", ""),
                                        cardExpiryYear: cards[widget.index]
                                            .month!
                                            .substring(
                                              3,
                                            )
                                            .toString(),
                                        cardExpiryMonth: cards[widget.index]
                                            .month!
                                            .substring(0, 2)
                                            .toString(),
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: Container(
                                      width: 200,
                                      height: 70,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                      ),
                                      child: Container(
                                        height: 65,
                                        decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child:  Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              LanguageClass.isEnglish? 'Charge':"شحن",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "bold"),
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
              style: TextStyle(color: Colors.white),
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
  const ConfirmPayWebView({
    Key? key,
    required this.webViewLink,
  }) : super(key: key);

  @override
  State<ConfirmPayWebView> createState() => _ConfirmPayWebViewState();
}

class _ConfirmPayWebViewState extends State<ConfirmPayWebView> {
  WebViewController controller = WebViewController()
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
          if (request.url
              .startsWith('https://www.atfawry.com/atfawry/plugin/3ds/')) {
            await Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(NavHelper().navigatorKey.currentContext!);

              Navigator.pushNamed(NavHelper().navigatorKey.currentContext!,
                  Routes.initialRoute);
              showDoneConfirmationDialog(
                  NavHelper().navigatorKey.currentContext!,
                  message: 'Payment completed successfully', callback: () {
                Navigator.pop(NavHelper().navigatorKey.currentContext!);
              });
            });

            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
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
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            Navigator.pushNamed(
                NavHelper().navigatorKey.currentContext!, Routes.initialRoute);
            return Future.value(false);
          },
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
