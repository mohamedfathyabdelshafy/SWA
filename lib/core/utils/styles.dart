import 'package:flutter/material.dart';

const dynamic enFontRegular = 'English_Regular';
const dynamic enFontBold = 'English_Bold';
const dynamic enFontLight = 'English_Black';
const dynamic enFontMediuem = 'English_Medium';

const dynamic arFontMedium = "Arabic_Medium";
const dynamic arFontBold = "Arabic_Bold";
const dynamic arFontRegular = "Arabic_Regular";

enum FontFamily {
  regular,
  bold,
  medium,
}

TextStyle fontStyle(
    {double fontSize = 16,
      Color color = Colors.white,
      FontFamily fontFamily = FontFamily.regular,
      FontWeight? fontWeight}) {
  String _fontFamily = fontFamily.name;
  // switch (fontFamily) {
  //   case FontFamily.regular:
  //     _fontFamily =
  //         Singleton().isEnglishSelected ? enFontRegular : arFontRegular;
  //     break;
  //   case FontFamily.bold:
  //     _fontFamily = Singleton().isEnglishSelected ? enFontBold : arFontBold;
  //     break;
  //   case FontFamily.medium:
  //     _fontFamily =
  //         Singleton().isEnglishSelected ? enFontMediuem : arFontMedium;
  //     break;
  //   default:
  //     _fontFamily =
  //         Singleton().isEnglishSelected ? enFontRegular : arFontRegular;
  // }

  return TextStyle(
    fontSize: fontSize,
    fontFamily: _fontFamily,
    color: color,
    fontWeight: fontWeight,
  );
}