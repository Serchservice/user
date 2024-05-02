import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color darkPrimaryColor = const Color(0xff14181b);
Color darkSecondaryColor = const Color(0xfff1f1f1);
Color darkAlternateColor = const Color(0xff212836);
Color darkPrimaryTextColor = const Color(0xffffffff);
Color darkSecondaryTextColor = const Color(0xff95A1AC);
Color darkBackgroundColor = const Color(0xff050404);

class DarkTheme {
  VisualDensity visualDensity;
  TextTheme textTheme;
  TextTheme logoTheme;
  TextStyle mainFont;

  DarkTheme({
    required this.logoTheme,
    required this.textTheme,
    required this.visualDensity,
    required this.mainFont
  });

  ThemeData get theme => ThemeData(
    visualDensity: visualDensity,
    textTheme: textTheme.apply(bodyColor: darkPrimaryColor),
    scaffoldBackgroundColor: darkBackgroundColor,
    iconTheme: IconThemeData(color: darkPrimaryColor),
    appBarTheme: AppBarTheme(
      color: darkAlternateColor,
      titleTextStyle: TextStyle(
        color: darkPrimaryTextColor,
        fontFamily: mainFont.fontFamily,
        fontSize: 16
      ),
      iconTheme: IconThemeData(color: darkPrimaryTextColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark, // IOS
        systemNavigationBarColor: darkAlternateColor,
        statusBarColor: darkAlternateColor,
        statusBarIconBrightness: Brightness.light, // Android
        systemNavigationBarIconBrightness: Brightness.light, // Android
      )
    ),
    primaryColor: darkPrimaryColor,
    primaryColorLight: darkBackgroundColor,
    primaryColorDark: darkPrimaryTextColor,
    // focusColor: darkPrimaryColor,
    splashColor: darkAlternateColor,
    // textSelectionTheme: TextSelectionThemeData(
    //   cursorColor: darkPrimaryColor, // Change the cursor color
    //   selectionColor: SColors.hint, // Change the highlight color
    //   selectionHandleColor: darkPrimaryColor, // Change the cursor head color
    // ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: darkPrimaryColor),
    bottomAppBarTheme: BottomAppBarTheme(color: darkAlternateColor),
    colorScheme: const ColorScheme.light().copyWith(
      background: darkAlternateColor,
      brightness: Brightness.dark,
    ),
  );
}