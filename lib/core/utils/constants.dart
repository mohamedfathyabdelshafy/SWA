import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:swa/core/utils/app_colors.dart';

class Constants{
  static Widget customButton({required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical:20),
      //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
      decoration:BoxDecoration(
        color: AppColors.darkRed,
        borderRadius: BorderRadius.circular(10)
      ) ,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22
          ),
        ),
      ),
    );
  }
  static Widget normalText({required BuildContext context, required String text, int? maxLines, Color? color, TextDecoration? textDecoration, double? fontSize, TextDirection? textDirection}){
    return Text(
      text,
      style: TextStyle(
        color: (color != null) ? color : AppColors.blackColor,
        fontSize: (fontSize != null) ? fontSize : (Device.get().isTablet) ? Theme.of(context).textTheme.headline6!.fontSize : Theme.of(context).textTheme.subtitle2!.fontSize,
        decoration: textDecoration
      ),
      maxLines: (maxLines != null) ? maxLines : 1,
      textDirection: (textDirection != null) ? textDirection : TextDirection.ltr,
    );
  }
}