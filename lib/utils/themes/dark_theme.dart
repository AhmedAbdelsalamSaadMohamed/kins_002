import 'package:flutter/material.dart';

const Color main1 = Color.fromRGBO(20, 20, 20, 1);
const Color main2 = Color.fromRGBO(44, 44, 44, 1);

//const Color _color1 = Colors.black;
const Color _color2 = Colors.white;
// const Color background2 = Colors.black12;
const Color onBackground2 = Colors.white54;
const Color _primary = Color(0xff0d3a0a);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: _primary,
  hintColor: _color2,
  focusColor: _primary,
  hoverColor: _primary,
  backgroundColor: main2,
  colorScheme: const ColorScheme.dark().copyWith(
    background: main1,
    onBackground: _color2,

    //primary: main1,
    secondary: _color2,
  ),
  tabBarTheme: const TabBarTheme(
      labelColor: _color2,
      unselectedLabelColor: onBackground2,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: _primary),
        insets: EdgeInsets.all(2),
      )),
  appBarTheme: const AppBarTheme(
    backgroundColor: main2,
    foregroundColor: _color2,
    elevation: 0,
    centerTitle: true,
  ),
  sliderTheme: const SliderThemeData(
      trackHeight: 1,
      thumbColor: Colors.white,
      activeTickMarkColor: Colors.white,
      activeTrackColor: Colors.white,
      disabledActiveTickMarkColor: Colors.grey,
      disabledActiveTrackColor: Colors.grey,
      disabledInactiveTickMarkColor: Colors.grey,
      disabledInactiveTrackColor: Colors.grey,
      disabledThumbColor: Colors.grey,
      thumbShape:
          RoundSliderThumbShape(disabledThumbRadius: 2, enabledThumbRadius: 4),
      rangeThumbShape: RoundRangeSliderThumbShape(
          enabledThumbRadius: 2,
          disabledThumbRadius: 1,
          elevation: 0,
          pressedElevation: 0)),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(main2),
          foregroundColor: MaterialStateProperty.all(_color2),
          elevation: MaterialStateProperty.all(0),
          padding: MaterialStateProperty.all(const EdgeInsets.all(20)))),
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all(_color2),
  )),
  inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _primary),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      fillColor: _color2,
      counterStyle: TextStyle(color: _color2)),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: _color2,
  ),
  snackBarTheme: SnackBarThemeData(actionTextColor: _color2),
  textTheme: TextTheme(
    bodyText1: TextStyle(),
    bodyText2: TextStyle(),
    headline1: TextStyle(),
    headline2: TextStyle(),
    caption: TextStyle(),
    button: TextStyle(),
    headline3: TextStyle(),
    headline4: TextStyle(),
    headline5: TextStyle(),
    headline6: TextStyle(),
    overline: TextStyle(),
    subtitle1: TextStyle(),
    subtitle2: TextStyle(),
  ).apply(displayColor: _color2, bodyColor: _color2, decorationColor: _color2),
);
