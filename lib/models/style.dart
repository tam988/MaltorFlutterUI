import 'dart:ui';

import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.lime,
      // 0x1E1F06FF),
      primaryColor: isDarkTheme ? Colors.black : Colors.lime,
      accentColor: isDarkTheme ? Colors.black54 : Colors.amber,
      canvasColor:
          isDarkTheme ? Colors.black : Color.fromRGBO(238, 242, 242, 1),
      fontFamily: 'Raleway',
      textTheme: ThemeData.light().textTheme.copyWith(
          bodyText1: TextStyle(
            color: isDarkTheme ? Colors.white : Color.fromRGBO(20, 51, 51, 1),
          ),
          bodyText2: TextStyle(
            color: isDarkTheme ? Colors.white : Color.fromRGBO(20, 51, 51, 1),
            fontSize: 15,
          ),
          headline1: TextStyle(
            fontSize: 20.0,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black,
          )),
      visualDensity: VisualDensity.adaptivePlatformDensity,

      //   primarySwatch: Colors.red,
      //   primaryColor: isDarkTheme ? Colors.black : Colors.white,
      //   backgroundColor: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
      //   indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      //   buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      //   hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
      //   highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      //   hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      //   focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      //   disabledColor: Colors.grey,
      //   textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      //   cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      //   canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      //   brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      //   buttonTheme: Theme.of(context).buttonTheme.copyWith(
      //       colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      //   appBarTheme: AppBarTheme(
      //     elevation: 0.0,
      //   ),
    );
  }
}