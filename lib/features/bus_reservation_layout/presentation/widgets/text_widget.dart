import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
   TextWidget({super.key,
   required this.text,
     this.fontFamily,
     this.fontSize,
     this.color
   });
String text;
double? fontSize;
String? fontFamily;
Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color:color?? Colors.white,
        fontSize: fontSize ??18,
        fontFamily: fontFamily ?? "regular"
      ),
    );
  }
}
