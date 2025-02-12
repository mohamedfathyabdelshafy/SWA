import 'package:flutter/material.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/app_info/domain/entities/city.dart';

class CityDropDownTextFieldButton extends StatelessWidget {
  final String hintText;
  final ValueChanged<City> onSelect;
  final List<City> countries;
  Color? bgcolor;
  final double? borderradias;
  TextEditingController? controller;

  CityDropDownTextFieldButton(
      {Key? key,
      required this.hintText,
      required this.onSelect,
      required this.countries,
      this.bgcolor,
      this.controller,
      this.borderradias})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    TextEditingController _controller = new TextEditingController(text: '');

    List<City> searchlist = countries;

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
                                        color: Routes.isomra
                                            ? AppColors.umragold
                                            : AppColors.primaryColor,
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
                                          ? "Select City"
                                          : "اختر مدينة",
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
                                  CustomizedField(
                                    colorText: Colors.black,
                                    onchange: (v) {
                                      if (v.isEmpty || _controller.text == '') {
                                        setStater(() {
                                          searchlist = countries;
                                        });
                                      } else {
                                        final list2 =
                                            countries.where((element) {
                                          final title =
                                              element.cityName!.toLowerCase();

                                          final searc = v.toLowerCase();
                                          return title.contains(searc);
                                        }).toList();

                                        setStater(() {
                                          searchlist = list2;
                                        });
                                      }
                                    },
                                    borderradias: 12,
                                    isPassword: false,
                                    hintText: LanguageClass.isEnglish
                                        ? 'Search'
                                        : 'بحث',
                                    labelcolor: Routes.isomra
                                        ? AppColors.umragold
                                        : AppColors.primaryColor,
                                    obscureText: false,
                                    readonly: false,
                                    color: Color(0xffDDDDDD),
                                    bordercolor: Colors.black,
                                    controller: _controller,
                                    validator: (validator) {},
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
                                                        searchlist[index]
                                                            .cityName;
                                                  });
                                                  onSelect(searchlist[index]);

                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    searchlist[index].cityName,
                                                    style: fontStyle(
                                                        fontFamily:
                                                            FontFamily.medium,
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
                                        itemCount: searchlist.length),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    });
              },
              style: fontStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: FontFamily.medium),
              cursorColor: Color(0xffA2A2A2),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                labelStyle: fontStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                hintText: LanguageClass.isEnglish
                    ? "Select your city"
                    : "ادخل المدينة",
                errorStyle: fontStyle(fontSize: 10),
                border: InputBorder.none,
                hintStyle: fontStyle(
                  color: Color(0xffA2A2A2),
                  fontFamily: FontFamily.medium,
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
      //               style: fontStyle(
      //                 color: Colors.white,
      //                 fontSize: 13,
      //                 fontWeight: FontWeight.normal,
      //               ),
      //             ),
      //           );
      //         }).toList(),
      //         hint: Text(
      //           hintText,
      //           style: fontStyle(
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
