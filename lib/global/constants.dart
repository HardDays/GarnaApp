import 'package:flutter/material.dart';

class Constants {
  static const double gridViewChildAspectRatio = 1 / 1.3;
  static const EdgeInsets gridViewElementMargin = EdgeInsets.all(6.0);
  static const double standardPaddingDouble = 16.0;
  static const EdgeInsets standardPadding =
      EdgeInsets.all(standardPaddingDouble);
  static const EdgeInsets customButtonMargin =
      EdgeInsets.symmetric(horizontal: 52);
  static const double standardBorderRadiusDouble = 8;
  static BorderRadius standardBorderRadius =
      BorderRadius.circular(standardBorderRadiusDouble);

  // Colors
  static const Color colorGrey = Color(0xffA0A0A0);

  // Theme
  ThemeData appTheme = ThemeData(
    accentColor: const Color(0xff9B712F),
    scaffoldBackgroundColor: Colors.black,
    fontFamily: 'NeueHelvetica',
    primaryColorLight: Colors.white,
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: Color(0xff9B712F),
      ),
      bodyText2: TextStyle(
        color: Color(0xff9B712F),
      ),
    ),
  );
}
