import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color lightPrimaryColor = const Color(0xff050404);
Color lightSecondaryColor = const Color(0xff222222);
Color lightAlternateColor = const Color(0xfff1f1f1);
Color lightPrimaryTextColor = const Color(0xff14181b);
Color lightSecondaryTextColor = const Color(0xff57636c);
Color lightBackgroundColor = const Color(0xffffffff);

class LightTheme {
  VisualDensity visualDensity;
  TextTheme textTheme;
  TextTheme logoTheme;
  TextStyle mainFont;

  LightTheme({
    required this.logoTheme,
    required this.textTheme,
    required this.visualDensity,
    required this.mainFont
  });

  ThemeData get theme => ThemeData(
    visualDensity: visualDensity,
    textTheme: textTheme.apply(bodyColor: lightPrimaryColor),
    iconTheme: IconThemeData(color: lightPrimaryColor),
    appBarTheme: AppBarTheme(
      color: lightSecondaryTextColor,
      titleTextStyle: TextStyle(
        color: lightPrimaryTextColor,
        fontFamily: mainFont.fontFamily,
        fontSize: 16
      ),
      iconTheme: IconThemeData(color: lightPrimaryTextColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light, // IOS
        systemNavigationBarColor: lightAlternateColor,
        statusBarColor: lightAlternateColor,
        statusBarIconBrightness: Brightness.dark, // Android
        systemNavigationBarIconBrightness: Brightness.dark, // Android
      )
    ),
    scaffoldBackgroundColor: lightBackgroundColor,
    primaryColor: lightPrimaryColor,
    primaryColorLight: lightSecondaryTextColor,
    primaryColorDark: lightSecondaryColor,
    // focusColor: SColors.darkTheme,
    // splashColor: SColors.lightTheme,
    // textSelectionTheme: const TextSelectionThemeData(
    //   cursorColor: SColors.darkTheme, // Change the cursor color
    //   selectionColor: SColors.hint, // Change the highlight color
    //   selectionHandleColor: SColors.darkTheme, // Change the cursor head color
    // ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: lightPrimaryColor),
    bottomAppBarTheme: BottomAppBarTheme(color: lightSecondaryTextColor,),
    colorScheme: const ColorScheme.light().copyWith(
      background: lightSecondaryTextColor,
      brightness: Brightness.light,
    ),
  );
}