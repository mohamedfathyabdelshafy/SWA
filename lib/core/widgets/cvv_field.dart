import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';

class CVVField extends StatelessWidget {
  const CVVField({
    super.key,
    required this.onChange,
    this.controller,
  });
  final TextEditingController? controller;
  final Function(String?) onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20.h,
          width: 1.w,
          decoration: BoxDecoration(color: Routes.isomra ? AppColors.umragold : AppColors.primaryColor),
        ),
        const SizedBox(
          width: 15,
        ),
        SizedBox(
          height: 60,
          width: 150,
          child: TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            controller: controller,
            keyboardType: TextInputType.number,
            style: fontStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: LanguageClass.isEnglish ? 'CVV' : 'رقم السري',
              contentPadding: EdgeInsets.only(top: 10),
              border: InputBorder.none,
              hintStyle: fontStyle(fontSize: 15, fontFamily: FontFamily.bold, color: AppColors.greyLight),
              labelStyle: fontStyle(color: AppColors.grey, fontSize: 12, fontFamily: FontFamily.bold),
              errorStyle: fontStyle(
                color: Colors.red,
                fontSize: 11,
              ),
            ),
            maxLength: 3,
            onChanged: onChange,
            validator: (value) {
              if (value!.isEmpty) return 'This Field is Required';
              if (value.length != 3) return 'Please enter a valid CVV';
              return null;
            },
          ),
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
