import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/navigation_helper.dart';

class Constants {
  static Future<dynamic> showDoneConfirmationDialog(BuildContext context,
      {required String message,
      bool isError = false,
      Widget? body,
      required Function callback}) async {
    return CoolAlert.show(
        barrierDismissible: true,
        context: context,
        type: CoolAlertType.custom,
        confirmBtnText: "ok",
        title: isError ? 'error' : '',
        lottieAsset:
            isError ? 'assets/json/error.json' : 'assets/json/Warning.json',
        loopAnimation: false,
        backgroundColor: isError ? Colors.red : Colors.white,
        text: message,
        widget: body,
        onConfirmBtnTap: callback());
  }

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
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color ?? Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
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
