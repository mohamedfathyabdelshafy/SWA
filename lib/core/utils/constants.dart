import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:swa/core/utils/app_colors.dart';

class Constants {
  static Widget customButton(
      {required String text, Color? color, double? borderradias}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
      decoration: BoxDecoration(
          color: color ?? AppColors.darkRed,
          borderRadius: BorderRadius.circular(borderradias ?? 10)),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
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
      style: TextStyle(
          color: (color != null) ? color : AppColors.blackColor,
          fontSize: (fontSize != null)
              ? fontSize
              : (Device.get().isTablet)
                  ? Theme.of(context).textTheme.headline6!.fontSize
                  : Theme.of(context).textTheme.subtitle2!.fontSize,
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.blackColor,
        content: Text(
          text,
          style: TextStyle(
              color: color ?? AppColors.primaryColor,
              fontSize: (Device.get().isTablet)
                  ? Theme.of(context).textTheme.headline5!.fontSize
                  : Theme.of(context).textTheme.subtitle1!.fontSize,
              fontWeight: FontWeight.bold),
        ),
        duration: (showDuration == null)
            ? const Duration(seconds: 2)
            : const Duration(seconds: 4),
      ),
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
              color: AppColors.primaryColor,
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
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .fontSize,
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
