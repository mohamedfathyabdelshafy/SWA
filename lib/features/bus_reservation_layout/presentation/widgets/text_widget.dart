import 'package:flutter/material.dart';
import 'package:swa/core/utils/styles.dart';

class TextWidget extends StatelessWidget {
  TextWidget(
      {super.key,
      required this.text,
      this.fontFamily,
      this.fontSize,
      this.color});
  String text;
  double? fontSize;
  String? fontFamily;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: fontStyle(
          color: color ?? Colors.white,
          fontSize: fontSize ?? 18,
          fontFamily: FontFamily.regular),
    );
  }
}
