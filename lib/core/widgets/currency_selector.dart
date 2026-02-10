import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/select_payment2/data/models/Curruncy_model.dart';

class _CurrencySelector extends StatefulWidget {
  final List<Currency> currencyList;
  final Function(Currency) onCurrencySelected;
  const _CurrencySelector({super.key, required this.currencyList, required this.onCurrencySelected});

  @override
  State<_CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<_CurrencySelector> {
  final TextEditingController _searchController = TextEditingController();
  List<Currency> _filteredCurrencyList = [];

  @override
  void initState() {
    super.initState();
    _filteredCurrencyList = widget.currencyList;

    _searchController.addListener(() {
      _filterCurrencies();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCurrencies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencyList = widget.currencyList;
      } else {
        _filteredCurrencyList = widget.currencyList.where((currency) {
          return currency.symbol!.toLowerCase().contains(query) || currency.symbol!.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 200.0),
        child: Container(
          alignment: Alignment.topRight,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),
              Container(
                alignment: LanguageClass.isEnglish ? Alignment.topLeft : Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
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
                  LanguageClass.isEnglish ? "Select Currency" : "حدد العملة",
                  style: fontStyle(
                      color: AppColors.blackColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.medium),
                ),
              ),
              SizedBox(
                height: sizeHeight * 0.01,
              ),
              // Search Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: LanguageClass.isEnglish ? "Search currency" : "ابحث عن العملة",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              Expanded(
                child: _filteredCurrencyList.isEmpty
                    ? Text(
                        LanguageClass.isEnglish ? "No currencies found" : "لم يتم العثور على عملات",
                        style: fontStyle(
                          fontFamily: FontFamily.medium,
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  widget.onCurrencySelected(_filteredCurrencyList[index]);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _filteredCurrencyList[index].name!,
                                        style: fontStyle(
                                            fontFamily: FontFamily.medium, color: Color(0xffA3A3A3), fontSize: 18),
                                      ),
                                      Text(
                                        _filteredCurrencyList[index].symbol!,
                                        style:
                                            fontStyle(fontFamily: FontFamily.bold, color: Colors.black, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.black,
                          );
                        },
                        itemCount: _filteredCurrencyList.length),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showCurrencySelector(BuildContext context,
    {required List<Currency> currencyList, required Function(Currency) onCurrencySelected}) {
  showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, _, __) {
        return StatefulBuilder(builder: (context, setStater) {
          return Material(
            color: Colors.transparent,
            child: _CurrencySelector(
              currencyList: currencyList,
              onCurrencySelected: onCurrencySelected,
            ),
          );
        });
      });
}
