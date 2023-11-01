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
  static void showDefaultSnackBar({required BuildContext context, required String text, VoidCallback? onPress, bool? showDuration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,

        content: Text(
          text,
          style: TextStyle(
              color: Theme.of(context).canvasColor,
              fontSize: (Device.get().isTablet) ? Theme.of(context).textTheme.headline5!.fontSize : Theme.of(context).textTheme.subtitle1!.fontSize,
              fontWeight: FontWeight.bold
          ),
        ),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            if (showDuration == null) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            } else {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            }
            if(onPress != null) {
              onPress();
            }
          },
        ),
        duration: (showDuration == null) ? const Duration(seconds: 5) : const Duration(seconds: 10),
      ),
    );
  }
  ///Loading Dialog its show and hide functions
  static Widget LoadingDialog(BuildContext context){
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
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
  static void showLoadingDialog(BuildContext context, {Key? key}) => showDialog<void>(context: context, useRootNavigator: false, barrierDismissible: false, builder: (_) => LoadingDialog(context),).then((_) => FocusScope.of(context).requestFocus(FocusNode()));
  static void hideLoadingDialog(BuildContext context) => Navigator.pop(context);
}