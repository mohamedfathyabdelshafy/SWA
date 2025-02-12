import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';

import '../../model/card_model.dart';

class AddCreditCard extends StatefulWidget {
  const AddCreditCard({super.key});

  @override
  State<AddCreditCard> createState() => _AddCreditCardState();
}

class _AddCreditCardState extends State<AddCreditCard> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController cardHolderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: sizeHeight * 0.08,
                ),
                Container(
                  alignment: Alignment.topLeft,
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
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    LanguageClass.isEnglish ? "Add Card" : "اضافة كارت",
                    style: fontStyle(
                        color: AppColors.blackColor,
                        fontSize: 38,
                        fontWeight: FontWeight.w500,
                        fontFamily: FontFamily.medium),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.05,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              width: 1, color: AppColors.primaryColor))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/Repeat Grid 1.svg",
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextFormField(
                              style: fontStyle(
                                  fontFamily: FontFamily.regular,
                                  color: Colors.black,
                                  fontSize: 18),
                              cursorColor: AppColors.blackColor,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(16),
                                CreditCardFormat(number: 4, char: " "),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LanguageClass.isEnglish
                                      ? "Enter number card"
                                      : 'ادخل البطاقة';
                                }
                                return null;
                              },
                              controller: cardNumberController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.info_rounded,
                                    color: Color(0xff616B80),
                                    size: 20,
                                  ),
                                  errorStyle: fontStyle(
                                      color: Colors.red, fontSize: 12),
                                  border: InputBorder.none,
                                  alignLabelWithHint: true,
                                  hintText: LanguageClass.isEnglish
                                      ? "Card Number"
                                      : "رقم البطاقة",
                                  hintStyle: fontStyle(
                                      fontSize: 21,
                                      fontFamily: FontFamily.regular,
                                      color: const Color(0xffA3A3A3))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.03,
                ),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              width: 1, color: AppColors.primaryColor))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: fontStyle(
                              fontFamily: FontFamily.medium,
                              color: Colors.black,
                              fontSize: 18),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            CreditCardFormat(number: 2, char: "/")
                          ],
                          maxLength: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LanguageClass.isEnglish
                                  ? "Enter month and year "
                                  : "ادخل الشهر والسنة";
                            }
                            return null;
                          },
                          controller: monthController,
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.info_rounded,
                                color: Color(0xff616B80),
                                size: 20,
                              ),
                              border: InputBorder.none,
                              alignLabelWithHint: true,
                              hintText:
                                  LanguageClass.isEnglish ? "MM/YY" : "شهر/سنه",
                              hintStyle: fontStyle(
                                  fontSize: 21,
                                  fontFamily: FontFamily.regular,
                                  color: const Color(0xffA3A3A3))),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          style: fontStyle(
                              fontFamily: FontFamily.regular,
                              color: Colors.black,
                              fontSize: 18),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LanguageClass.isEnglish
                                  ? "Enter CVV"
                                  : "ادخل الرقم السري";
                            }
                            return null;
                          },
                          controller: cvvController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.info_rounded,
                                color: Color(0xff616B80),
                                size: 20,
                              ),
                              alignLabelWithHint: true,
                              hintText: LanguageClass.isEnglish
                                  ? "CVV"
                                  : "الرقم السري",
                              hintStyle: fontStyle(
                                  fontSize: 21,
                                  fontFamily: FontFamily.regular,
                                  color: const Color(0xffA3A3A3))),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.03,
                ),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              width: 1, color: AppColors.primaryColor))),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LanguageClass.isEnglish
                                  ? "Enter card holder"
                                  : "ادخل اسم البطاقة";
                            }
                            return null;
                          },
                          controller: cardHolderController,
                          style: fontStyle(
                              fontFamily: FontFamily.regular,
                              color: Colors.black,
                              fontSize: 18),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.info_rounded,
                                color: Color(0xff616B80),
                                size: 20,
                              ),
                              alignLabelWithHint: true,
                              hintText: LanguageClass.isEnglish
                                  ? "Card Holder"
                                  : "اسم البطاقة ",
                              hintStyle: fontStyle(
                                  fontSize: 21,
                                  fontFamily: FontFamily.regular,
                                  color: const Color(0xffA3A3A3))),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Icon(
                        Icons.security_rounded,
                        color: Color(0xff39A85B),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Your payment information will be stores securely",
                        style: fontStyle(
                            fontFamily: FontFamily.regular,
                            fontSize: 11,
                            color: const Color(0xff39A85B)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      final addedCard = CardModel(
                        month: monthController.text,
                        cardName: cardHolderController.text,
                        cardNumber: cardNumberController.text,
                      );

                      final jsonData =
                          CacheHelper.getDataToSharedPref(key: 'cards');
                      print(jsonData.runtimeType);
                      print("Doneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee1");
                      print(jsonData);
                      final card = [];
                      card.add(addedCard);
                      print("Doneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee2$card");
                      if (jsonData != null && jsonData is String) {
                        final cachedcard = json
                            .decode(jsonData)
                            .map<CardModel>((e) => CardModel.fromJsom(e))
                            .toList();
                        card.addAll(cachedcard);
                        print("Doneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee2$card");
                      }

                      CacheHelper.setDataToSharedPref(
                        key: "cards",
                        value: json.encode(
                          card.map((e) => e.toJson()).toList(),
                        ),
                      ).then((value) {
                        print(
                            "from local ${CacheHelper.getDataToSharedPref(key: 'cards')}");
                        Navigator.pop<CardModel>(context, addedCard);
                      });
                    } else {
                      return;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(41)),
                      child: Center(
                        child: Text(
                          LanguageClass.isEnglish ? "Save" : "حفظ",
                          style: fontStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreditCardFormat extends TextInputFormatter {
  int number;
  String char;
  CreditCardFormat({required this.number, required this.char});
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String enteredData = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < enteredData.length; i++) {
      buffer.write(enteredData[i]);
      int index = i + 1;
      if (index % number == 0 && enteredData.length != index) {
        buffer.write(char);
      }
    }
    return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}
