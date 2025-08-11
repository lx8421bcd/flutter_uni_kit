import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/theme/theme_identifier.dart';

final appThemeLight = ThemeData.light();
final appThemeDark = ThemeData.dark();

final ThemeData themeA = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.blue,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    headlineSmall: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
  extensions: const [
    ThemeIdentifier("themeA")
  ]
);

final ThemeData themeB = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey,
  scaffoldBackgroundColor: Colors.blueGrey[900],
  appBarTheme: AppBarTheme(
    color: Colors.blueGrey[800],
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  extensions: const [
    ThemeIdentifier("themeB")
  ]
);
