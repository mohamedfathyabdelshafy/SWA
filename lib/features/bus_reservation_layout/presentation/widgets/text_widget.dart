import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
   TextWidget({super.key,
   required this.text,
     this.fontFamily,
     this.fontSize
   });
String text;
double? fontSize;
String? fontFamily;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize ??18,
        fontFamily: fontFamily ?? "regular"
      ),
    );
  }
}
