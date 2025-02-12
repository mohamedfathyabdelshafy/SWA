import 'package:flutter/material.dart';

// This uses the MaterialBasedCupertinoThemeData mechs so that
// we have one base text theme for both Material and Cupertino widgets
TextTheme myBaseTextTheme = TextTheme(
  headlineSmall: myHeadline3,
  headlineMedium: myHeadline5, //Replace the one in main app with headline6
  headlineLarge: myHeadline6, //Replace the one in main app with headline5
  displaySmall: mySubtitle1,
  displayLarge: mySubtitle2,
  displayMedium: myCaption,
);

TextStyle myHeadline3 = const TextStyle(
  // ignore: avoid_redundant_argument_values
  inherit: true,
  // color: myColorSchemes.onSurface,
  // backgroundColor: myColorSchemes.background,
  fontSize: 48,
  fontWeight: FontWeight.w400,
  fontStyle: FontStyle.normal,
  letterSpacing: 0.0,
  textBaseline: TextBaseline.alphabetic,
  leadingDistribution: TextLeadingDistribution.even,
  debugLabel: 'Headline3',
);

TextStyle myHeadline5 = const TextStyle(
  // ignore: avoid_redundant_argument_values
  inherit: true,
  // color: myColorSchemes.onSurface,
  // backgroundColor: myColorSchemes.background,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  // fontStyle: FontStyle.normal,
  // letterSpacing: 0.0,
  // textBaseline: TextBaseline.alphabetic,
  // leadingDistribution: TextLeadingDistribution.even,
  debugLabel: 'Headline5',
);

TextStyle myHeadline6 = const TextStyle(
  // ignore: avoid_redundant_argument_values
  inherit: true,
  // color: myColorSchemes.onSurface,
  // backgroundColor: myColorSchemes.background,
  fontSize: 18,
  // fontWeight: FontWeight.w500,
  // fontStyle: FontStyle.normal,
  // letterSpacing: 0.15,
  // textBaseline: TextBaseline.alphabetic,
  // leadingDistribution: TextLeadingDistribution.even,
  debugLabel: 'Headline6',
);

TextStyle mySubtitle1 = const TextStyle(
  // ignore: avoid_redundant_argument_values
  inherit: true,
  // color: myColorSchemes.onSurface,
  // backgroundColor: myColorSchemes.background,
  fontSize: 16,
  // fontWeight: FontWeight.w400,
  // fontStyle: FontStyle.normal,
  // letterSpacing: 0.15,
  // textBaseline: TextBaseline.alphabetic,
  // leadingDistribution: TextLeadingDistribution.even,
  debugLabel: 'Subtitle1',
);

TextStyle mySubtitle2 = const TextStyle(
  // ignore: avoid_redundant_argument_values
  inherit: true,
  // color: myColorSchemes.onSurface,
  // backgroundColor: myColorSchemes.background,
  fontSize: 14,
  // fontWeight: FontWeight.w500,
  // fontStyle: FontStyle.normal,
  // letterSpacing: 0.1,
  // textBaseline: TextBaseline.alphabetic,
  // leadingDistribution: TextLeadingDistribution.even,
  debugLabel: 'Subtitle2',
);

TextStyle myCaption = const TextStyle(
  // ignore: avoid_redundant_argument_values
  inherit: true,
  // color: myColorSchemes.onSurface,
  // backgroundColor: myColorSchemes.background,
  fontSize: 12,
  fontWeight: FontWeight.w400,
  // fontStyle: FontStyle.normal,
  // letterSpacing: 0.4,
  // textBaseline: TextBaseline.alphabetic,
  // leadingDistribution: TextLeadingDistribution.even,
  debugLabel: 'Caption',
);
