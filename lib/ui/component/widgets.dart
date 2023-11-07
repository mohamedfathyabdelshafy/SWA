

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:swa/core/utilts/styles.dart';

showLoadingDialog(BuildContext context, {bool showMessage = false}) {
  Future.delayed(Duration(milliseconds: 100), () {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SizedBox.expand(
          child: (Container(
            color: Colors.white.withOpacity(0.4),
            child: Center(
              child: LottieBuilder.asset('assets/json/loading.json'),
            ),
          )),
        );
      },
    );
  });
}

showLoadingWidget(BuildContext context,
    {double width = 80, double height = 80}) {
  return Center(
    child: LottieBuilder.asset(
      'assets/json/loading.json',
      width: width,
      height: height,
    ),
  );
}

hideLoadingDialog(BuildContext context, Function function) {
  Future.delayed(Duration(milliseconds: 100), () {
    Navigator.pop(context);
  });

  function();
}

showSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: fontStyle(color: Colors.white),
      textAlign: TextAlign.center,
    ),
    backgroundColor: isError ? Colors.red : Colors.green[600],
    shape: const RoundedRectangleBorder(
        side: BorderSide(style: BorderStyle.solid)),
    elevation: 6,
  ));
}

showNoDataWidget(BuildContext context,
    {double width = 80, double height = 80}) {
  return LottieBuilder.asset(
    'assets/json/no_data.json',
    width: width,
    height: height,
    repeat: false,
  );
}

Future<dynamic> showDoneConfirmationDialog(BuildContext context,
    {required String message,
    String? callbackTitle,
    bool isError = false,
    required Function callback}) async {
  return CoolAlert.show(
      barrierDismissible: false,
      context: context,
      // confirmBtnText: callbackTitle ?? Localizationss().localize('ok'),
      // title: Localizationss().localize(isError ? 'error' : 'success'),
      lottieAsset: isError ? 'assets/json/error.json' : 'assets/json/done.json',
      type: isError ? CoolAlertType.error : CoolAlertType.success,
      loopAnimation: false,
      backgroundColor: isError ? Colors.red : Colors.white,
      text: message,
      onConfirmBtnTap: () {
        callback();
      });
}

Future<dynamic> showAlertDialog(BuildContext context,
    {required String message,
    required String title,
    required Function callback}) async {
  return CoolAlert.show(
      barrierDismissible: false,
      context: context,
      // confirmBtnText: Localizationss().localize('ok'),
      title: title,
      type: CoolAlertType.warning,
      loopAnimation: false,
      backgroundColor: Colors.white,
      text: message,
      onConfirmBtnTap: () {
        callback();
      });
}
