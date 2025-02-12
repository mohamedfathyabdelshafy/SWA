import 'package:flutter/material.dart';
import 'package:swa/core/utils/language.dart';

const dynamic enFontRegular = 'regular';
const dynamic enFontBold = 'bold';
const dynamic enFontLight = 'English_Black';
const dynamic enFontMediuem = 'meduim';

const dynamic arFontMedium = "Arabic_Medium";
const dynamic arFontBold = "Arabic_Bold";
const dynamic arFontRegular = "Arabic_Regular";

enum FontFamily { regular, bold, medium, arFontMedium }

TextStyle fontStyle(
    {double fontSize = 16,
    Color color = Colors.black,
    double? height,
    TextDecoration? decoration,
    TextOverflow? overflow,
    FontFamily fontFamily = FontFamily.regular,
    FontWeight? fontWeight}) {
  String _fontFamily = fontFamily.name;
  switch (fontFamily) {
    case FontFamily.regular:
      _fontFamily = LanguageClass.isEnglish ? enFontRegular : arFontRegular;
      break;
    case FontFamily.bold:
      _fontFamily = LanguageClass.isEnglish ? enFontBold : arFontBold;
      break;
    case FontFamily.medium:
      _fontFamily = LanguageClass.isEnglish ? enFontMediuem : arFontMedium;
      break;
    case FontFamily.arFontMedium:
      _fontFamily = arFontMedium;
      break;
    default:
      _fontFamily = LanguageClass.isEnglish ? enFontRegular : arFontRegular;
  }

  return TextStyle(
    fontSize: fontSize,
    fontFamily: _fontFamily,
    color: color,
    overflow: overflow,
    decoration: decoration ?? null,
    height: 1.2,
    fontWeight: fontWeight,
  );
}
