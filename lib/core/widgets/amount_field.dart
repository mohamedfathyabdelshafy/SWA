import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/payment_packages/fawrypayment.dart';

class AmountField extends StatelessWidget {
  final bool isReadOnly;
  final TextEditingController controller;
  const AmountField({super.key, this.isReadOnly = false, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 1,
          decoration: const BoxDecoration(color: Color(0xffD865A4)),
        ),
        Container(
            width: 150.w,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
            decoration: const BoxDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: TextFormField(
                    autofocus: true,
                    cursorColor: AppColors.blue,
                    readOnly: isReadOnly,
                    controller: controller,
                    inputFormatters: [
                      NumericTextFormatter(),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                    ],
                    keyboardType: TextInputType.number,
                    style: fontStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: LanguageClass.isEnglish ? 'Amount' : 'القيمة',
                      errorStyle: fontStyle(
                        color: Colors.red,
                        fontSize: 11,
                      ),
                      hintStyle: fontStyle(color: AppColors.greyLight, fontSize: 15, fontFamily: FontFamily.bold),
                      labelStyle: fontStyle(color: AppColors.grey, fontSize: 12, fontFamily: FontFamily.bold),
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
              ],
            )),
      ],
    );
  }
}
