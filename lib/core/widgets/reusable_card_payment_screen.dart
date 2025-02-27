import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/amount_field.dart';
import 'package:swa/core/widgets/currency_selector.dart';
import 'package:swa/core/widgets/cvv_field.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/select_payment2/data/models/Curruncy_model.dart';
import 'package:swa/select_payment2/presentation/credit_card/model/card_model.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/screens/credit_card.dart';

class ReusableCardPaymentScreen extends StatefulWidget {
  final double initialAmount;
  final bool showCurrencySelector;
  final bool isAmountReadOnly;
  final String? buttonText;

  final Function(String)? onCardSelected;
  final Function()? onAddCard;
  final Function(String currency)? onCurrencyChange;
  final Future Function(_CreditCard card, String amount, String currency) onButtonPressed;

  const ReusableCardPaymentScreen({
    super.key,
    required this.initialAmount,
    this.onCardSelected,
    this.isAmountReadOnly = false,
    this.buttonText,
    this.onAddCard,
    this.onCurrencyChange,
    required this.onButtonPressed,
    this.showCurrencySelector = false,
  });

  @override
  _ReusableCardPaymentScreenState createState() => _ReusableCardPaymentScreenState();
}

class _ReusableCardPaymentScreenState extends State<ReusableCardPaymentScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String? cvv;
  List<CardModel> cards = [];
  TextEditingController cardHolderName = TextEditingController();
  TextEditingController expiryFieldCtrl = TextEditingController();
  TextEditingController cardNumberCtrl = TextEditingController();
  TextEditingController amountController = TextEditingController();
  // TextEditingController amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int selectedCardIndex = 0;
  FocusNode cardHolderNameNode = FocusNode();
  FocusNode cardNumberNode = FocusNode();
  FocusNode amountNode = FocusNode();
  FocusNode cardDateNode = FocusNode();
  FocusNode cvvNode = FocusNode();

  TextEditingController cvvController = TextEditingController();

  @override
  void initState() {
    amountController.text = widget.initialAmount.toString();
    selectedcurruncy = Routes.curruncy!;

    _loadCards();
    if (widget.showCurrencySelector) getAllCurrencies();
    super.initState();
  }

  _loadCards() async {
    final jsonData = await CacheHelper.getDataToSharedPref(key: 'cards');
    if (jsonData != null && jsonData is String) {
      setState(() {
        cards = json.decode(jsonData).map<CardModel>((e) => CardModel.fromJsom(e)).toList();
      });
    }
  }

  Curruncylist? curruncylist;
  String selectedcurruncy = '';

  getAllCurrencies() async {
    var responce = await PackagesRespo().GetallCurrency();

    Constants.showLoadingDialog(context);

    if (responce is Curruncylist) {
      curruncylist = responce;

      Constants.hideLoadingDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.of(context).size.width;
    final isCardSelected = selectedCardIndex >= 0 && cards.isNotEmpty;
    return Form(
      key: formKey,
      child: Directionality(
        textDirection: LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            children: [
              50.verticalSpace,
              _buildTitle(context),
              20.verticalSpace,
              _buildCreditCardSelector(context, sizeWidth),
              10.verticalSpace,
              if (isCardSelected) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CVVField(onChange: (value) => setState(() => cvv = value)),
                        AmountField(
                          controller: amountController,
                        ),
                      ],
                    ),
                    if (widget.showCurrencySelector) _buildCurrencySelector()
                  ],
                ),
              ],
              20.verticalSpace,
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencySelector() {
    return InkWell(
      onTap: () {
        final amount = double.tryParse(amountController.text) ?? 0.0;
        if (amount <= 0.0) return _showEnterValidAmountSnackbar();
        showCurrencySelector(context, currencyList: curruncylist!.message!, onCurrencySelected: (currency) async {
          final double convertedAmount =
              await PackagesRespo().Convertcurrency(amount: amount, from: selectedcurruncy, to: currency.symbol!);
          setState(() {
            amountController.text = convertedAmount.toString();
            selectedcurruncy = currency.symbol!;
          });
          Navigator.pop(context);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            selectedcurruncy,
            style: fontStyle(color: Colors.black, fontFamily: FontFamily.bold),
          ),
          4.horizontalSpace,
          Icon(
            Icons.arrow_drop_down_rounded,
            color: AppColors.umragold,
            size: 20,
          )
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return InkWell(
      onTap: () async {
        if (selectedCardIndex < 0) _showSelectCardSnackbar();
        final isValid = formKey.currentState!.validate();
        if (!isValid) return;
        final amount = double.parse(amountController.text.replaceAll(',', ''));
        final card = _CreditCard(
            cardNumber: cardNumber,
            expDate: cards[selectedCardIndex].month!,
            cvv: cvv!,
            cardHolderName: cards[selectedCardIndex].cardName!);

        await widget.onButtonPressed(card, amount.toString(), selectedcurruncy);
      },
      child: Padding(
        padding: const EdgeInsets.all(0),
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
                borderRadius: BorderRadius.circular(41)),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  widget.buttonText ?? (LanguageClass.isEnglish ? "Payment" : "الدفع"),
                  style: fontStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: FontFamily.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSelectCardSnackbar() => Constants.showDefaultSnackBar(
      color: Colors.red, context: context, text: LanguageClass.isEnglish ? 'Select card' : 'اختر البطاقة');
  void _showEnterValidAmountSnackbar() => Constants.showDefaultSnackBar(
      color: Colors.red, context: context, text: LanguageClass.isEnglish ? 'Enter valid amount' : 'ادخل المبلغ الصحيح');
  Container _buildCreditCardSelector(BuildContext context, double sizeWidth) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.white, border: Border.all(color: AppColors.grey), borderRadius: BorderRadius.circular(15)),
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
          (selectedCardIndex >= 0 && cards.isNotEmpty)
              ? InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(30),
                          child: SizedBox(
                            height: 270,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LanguageClass.isEnglish ? 'Choose Card' : "اختر كارت",
                                  style:
                                      fontStyle(fontSize: 15, fontFamily: FontFamily.bold, color: AppColors.blackColor),
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
                                              selectedCardIndex = index;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: selectedCardIndex == index ? true : false,
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
                                Divider(thickness: 0.5, color: AppColors.grey),
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
                                        LanguageClass.isEnglish ? 'Add New Card' : "اضافة كارت جديد",
                                        style: fontStyle(
                                            fontSize: 15.45, fontFamily: FontFamily.bold, color: AppColors.blackColor),
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
                        (selectedCardIndex >= 0 && selectedCardIndex < cards.length)
                            ? "XXXX-XXXX-XXXX-${cards[selectedCardIndex].cardNumber!.substring(cards[selectedCardIndex].cardNumber!.length - 4)}"
                            : "Choose Card",
                        style: fontStyle(fontSize: 18, fontFamily: FontFamily.regular, color: Colors.black),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 30,
                      )
                    ],
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
                    style: fontStyle(fontSize: 15.45, fontFamily: FontFamily.bold, color: AppColors.blackColor),
                  ),
                )
        ],
      ),
    );
  }

  Row _buildTitle(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: LanguageClass.isEnglish ? Alignment.topLeft : Alignment.topRight,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: AppColors.primaryColor,
              size: 35,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            LanguageClass.isEnglish ? "Payment" : "الدفع",
            style: fontStyle(
                color: AppColors.blackColor, fontSize: 38, fontWeight: FontWeight.w600, fontFamily: FontFamily.medium),
          ),
        ),
      ],
    );
  }
}

class _CreditCard {
  String cardNumber;
  String expDate;
  String cvv;
  String cardHolderName;

  _CreditCard({required this.cardNumber, required this.expDate, required this.cvv, required this.cardHolderName});
}
