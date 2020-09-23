import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static const double gridViewChildAspectRatio = 1 / 1.3;
  static const EdgeInsets gridViewElementMargin = EdgeInsets.all(6.0);
  static const double standardPaddingDouble = 16.0;
  static const EdgeInsets standardPadding =
      EdgeInsets.all(standardPaddingDouble);
  static const EdgeInsets customButtonMargin =
      EdgeInsets.all(standardPaddingDouble);
  static const double standardBorderRadiusDouble = 8;
  static BorderRadius standardBorderRadius =
      BorderRadius.circular(standardBorderRadiusDouble);

  static const Duration standardAnimationDuration = Duration(milliseconds: 300);
  static const Duration customSnackbarDuration = Duration(seconds: 3);

  // Colors
  static const Color colorLightGrey = Color(0xffA0A0A0);
  static const Color colorDarkGrey = Color(0xff5F5F5F);
  static const Color colorDarkGold = Color(0xff9B712F);

  // Theme
  ThemeData appTheme = ThemeData(
    cupertinoOverrideTheme: const CupertinoThemeData(
      primaryColor: colorDarkGold,
    ),
    accentColor: colorDarkGold,
    scaffoldBackgroundColor: Colors.black,
    fontFamily: 'NeueHelvetica',
    primaryColorLight: Colors.white,
    splashColor: Colors.transparent,
    highlightColor: Colors.grey.withOpacity(0.3),
    dividerColor: colorDarkGrey,
    sliderTheme: const SliderThemeData(
      thumbColor: Colors.white,
      activeTrackColor: colorDarkGold,
      trackHeight: 2,
      inactiveTrackColor: colorDarkGrey,
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: colorDarkGold,
      ),
      bodyText2: TextStyle(
        color: colorDarkGold,
      ),
    ),
  );
}
