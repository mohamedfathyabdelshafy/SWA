import 'package:flutter/material.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/styles.dart';

Widget PinCodeTextField(
    {required BuildContext context,
    required TextEditingController controller}) {
  final size = MediaQuery.of(context).size;

  return Container(
    width: size.width / 5.5,
    height: size.height * 0.1,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
    child: Container(
      width: size.width / 5.5,
      height: size.height * 0.3,
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        obscureText: true,
        maxLength: 1,
        style: fontStyle(
            color: Colors.white, fontSize: 30, fontFamily: FontFamily.medium),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(15), // Apply borderRadius here
              borderSide: BorderSide(
                  color: AppColors.lightBink), // Customize border style
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(15), // Apply borderRadius here
              borderSide: const BorderSide(
                  color: Colors.white), // Customize border style
            ),
            filled: true,
            fillColor: AppColors.lightBink,
            counterText: "",
            border: InputBorder.none),
        validator: (value) {
          if (value!.isEmpty) {
            return null;
          }
          return null;
        },
      ),
    ),
  );
}
