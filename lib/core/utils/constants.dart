import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/arabic_text_sanitizer.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';

import '../../main.dart';

class Constants {
  static Widget customButton(
      {required String text, Color? color, double? borderradias}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
      decoration: BoxDecoration(
          color: color ?? AppColors.darkRed,
          borderRadius: BorderRadius.circular(borderradias ?? 10)),
      child: Center(
        child: Text(
          text,
          style: fontStyle(
              color: AppColors.white,
              fontFamily: FontFamily.bold,
              fontSize: 22),
        ),
      ),
    );
  }

  static Widget normalText(
      {required BuildContext context,
      required String text,
      int? maxLines,
      Color? color,
      TextDecoration? textDecoration,
      double? fontSize,
      TextDirection? textDirection}) {
    return Text(
      text,
      style: fontStyle(
          color: (color != null) ? color : AppColors.blackColor,
          fontSize: (fontSize != null)
              ? fontSize
              : (Device.get().isTablet)
                  ? Theme.of(context).textTheme.labelLarge!.fontSize!
                  : Theme.of(context).textTheme.labelMedium!.fontSize!,
          decoration: textDecoration),
      maxLines: (maxLines != null) ? maxLines : 1,
      textDirection:
          (textDirection != null) ? textDirection : TextDirection.ltr,
    );
  }

  static void showDefaultSnackBar(
      {required BuildContext context,
      required String text,
      VoidCallback? onPress,
      bool? showDuration,
      Color? color}) {
    final displayText = ArabicTextSanitizer.snackBarMessage(text);
    final Color statusColor =
        _snackBarStatusColor(text: displayText, color: color);

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: statusColor,
        duration: (showDuration == null)
            ? const Duration(seconds: 5)
            : const Duration(seconds: 7),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Directionality(
          textDirection:
              LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: Text(
            _capitalizeFirstLetter(displayText),
            textAlign:
                LanguageClass.isEnglish ? TextAlign.start : TextAlign.end,
            style: fontStyle(
                color: AppColors.white,
                fontSize: 14,
                fontFamily: FontFamily.medium,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  static Color _snackBarStatusColor({required String text, Color? color}) {
    if (color != null) {
      if (color == Colors.green || color == Colors.greenAccent) {
        return const Color(0xff2E7D32);
      }
      if (color == Colors.red || color == Colors.redAccent) {
        return const Color(0xffD32F2F);
      }
      if (color == Colors.orange || color == Colors.orangeAccent) {
        return const Color(0xffEF6C00);
      }

      return color;
    }

    final lowerText = text.toLowerCase();
    final successWords = [
      'success',
      'done',
      'confirmed',
      'completed',
      'charged',
      'تم',
      'نجاح',
      'بنجاح'
    ];
    final warningWords = [
      'warning',
      'required',
      'select',
      'choose',
      'empty',
      'تنبيه',
      'مطلوب',
      'اختار',
      'اختر'
    ];
    final errorWords = [
      'error',
      'failed',
      'fail',
      'invalid',
      'wrong',
      'not',
      'no ',
      'cannot',
      'can not',
      'خطأ',
      'فشل',
      'غير',
      'لا '
    ];

    if (successWords.any(lowerText.contains)) {
      return const Color(0xff2E7D32);
    }
    if (warningWords.any(lowerText.contains)) {
      return const Color(0xffEF6C00);
    }
    if (errorWords.any(lowerText.contains)) {
      return const Color(0xffD32F2F);
    }

    return AppColors.primaryColor;
  }

  static String _capitalizeFirstLetter(String text) {
    if (text.trim().isEmpty) return text;

    final firstNonSpaceIndex = text.indexOf(RegExp(r'\S'));
    if (firstNonSpaceIndex < 0) return text;

    final firstChar = text[firstNonSpaceIndex];
    final capitalizedFirstChar = firstChar.toUpperCase();

    if (firstChar == capitalizedFirstChar) return text;

    return text.replaceRange(
      firstNonSpaceIndex,
      firstNonSpaceIndex + 1,
      capitalizedFirstChar,
    );
  }

  ///Loading Dialog its show and hide functions
  static Widget LoadingDialog(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            color: Colors.transparent,
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: CircularProgressIndicator(
              color:
                  Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  static void showLoadingDialog(BuildContext context, {Key? key}) =>
      showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(context),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));
  static void hideLoadingDialog(BuildContext context) => Navigator.pop(context);
  static dynamic showListDialog(
      BuildContext context, String dialogName, Widget listViewWidget) {
    return showDialog(
        context: context,
        builder: (_) {
          return WillPopScope(
            //Set onWillPop to false if need to prevent the dialog from closing
            onWillPop: () async => true,
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(
                    top: 80, bottom: 80, left: 20, right: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Material(
                        child: ListTile(
                          title: Text(dialogName,
                              style: fontStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .fontSize!,
                                  fontFamily: FontFamily.bold,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const Divider(),
                      listViewWidget
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
