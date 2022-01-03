import 'package:flutter/material.dart';
import 'package:kins_v002/constant/const_colors.dart';

class Themes {
  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: Colors.black,
      background: Colors.white,
      onBackground: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, foregroundColor: primaryColor),
    iconTheme: const IconThemeData(color: Colors.grey),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: IconThemeData(color: primaryColor),
      showUnselectedLabels: true,
    ),
    inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.black), focusColor: primaryColor),
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: primaryColor,
      secondary: Colors.white,
      background: Colors.black54,
      onBackground: Colors.black26,
      //surface: Colors.white
    ),
    scaffoldBackgroundColor: Colors.black54,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black26, foregroundColor: Colors.white),
    iconTheme: const IconThemeData(color: Colors.white),
    buttonTheme: const ButtonThemeData(buttonColor: Colors.black26),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black26))),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.white,
      selectedIconTheme: IconThemeData(color: primaryColor),
      showUnselectedLabels: true,
    ),
  );
}
