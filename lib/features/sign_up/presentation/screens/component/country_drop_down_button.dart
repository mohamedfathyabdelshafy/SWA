import 'package:flutter/material.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';

class CountryDropDownTextFieldButton extends StatelessWidget {
  final String hintText;
  final ValueChanged<Country> onSelect;
  final List<Country> countries;
  final double? borderradias;
  TextEditingController? controller;

  Color? bgcolor;

  CountryDropDownTextFieldButton({
    Key? key,
    this.borderradias,
    this.controller,
    required this.hintText,
    required this.onSelect,
    required this.countries,
    this.bgcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    return Container(
      child: Column(
        children: [
          Container(
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xffDDDDDD),
              borderRadius:
                  BorderRadius.all(Radius.circular(borderradias ?? 33)),
            ),
            child: TextFormField(
              controller: controller,
              readOnly: true,
              onTap: () {
                showGeneralDialog(
                    context: context,
                    pageBuilder: (BuildContext buildContext,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return StatefulBuilder(builder: (context, setStater) {
                        return Material(
                          color: Colors.transparent,
                          child: Directionality(
                            textDirection: LanguageClass.isEnglish
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            child: Container(
                              alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: sizeHeight * 0.08,
                                  ),
                                  Container(
                                    alignment: LanguageClass.isEnglish
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
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
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      LanguageClass.isEnglish
                                          ? "Select your country"
                                          : "ادخل الدولة",
                                      style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "meduim"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizeHeight * 0.01,
                                  ),
                                  Expanded(
                                    child: ListView.separated(
                                        itemBuilder: (context, index) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setStater(() {
                                                    controller!.text =
                                                        countries[index]
                                                            .countryName;
                                                  });
                                                  onSelect(countries[index]);

                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    countries[index]
                                                        .countryName,
                                                    style: TextStyle(
                                                        fontFamily: "meduim",
                                                        color:
                                                            Color(0xffA3A3A3),
                                                        fontSize: 18),
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
                                        itemCount: countries.length),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    });
              },
              style: TextStyle(color: Color(0xffA2A2A2), fontSize: 18),
              cursorColor: Color(0xffA2A2A2),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                labelStyle: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                hintText: LanguageClass.isEnglish
                    ? "Select your country"
                    : "ادخل الدولة",
                errorStyle: const TextStyle(fontSize: 10),
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Color(0xffA2A2A2),
                  fontFamily: 'black',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
      // child: Row(
      //   children: [
      //     Expanded(
      //       child:
      //       DropdownButton<City?>(
      //         // Initial Value
      //         value: null,
      //         icon: Icon(
      //           Icons.arrow_drop_down,
      //           color: Colors.black.withOpacity(0.5),
      //           size: 30.0,
      //         ),
      //         // Array list of items
      //         items: countries.map((item) {
      //           return DropdownMenuItem<City>(
      //             value: item,
      //             child: Text(
      //               item.cityName,
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 13,
      //                 fontWeight: FontWeight.normal,
      //               ),
      //             ),
      //           );
      //         }).toList(),
      //         hint: Text(
      //           hintText,
      //           style: TextStyle(
      //             color: Color(0xffA2A2A2),
      //             fontSize: 16,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         onChanged: (City? newValue) {
      //           if (newValue != null) {
      //             onSelect(newValue);
      //           }
      //         },
      //         isExpanded: true,
      //         underline: const SizedBox(height: 0.0, width: 0.0),
      //         dropdownColor: Colors.black,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
