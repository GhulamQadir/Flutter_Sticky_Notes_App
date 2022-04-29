// ignore_for_file: prefer_const_constructors, unused_label

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  getThemeBoolSP() async {}

  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class ChangeTheme {
  static final lightTheme = ThemeData(
      // textTheme: TextTheme(
      //   bodyText2: TextStyle(color: Colors.black),
      // ),
      colorScheme: ColorScheme.light(),
      // scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.purple,
      ));
  static final darkTheme = ThemeData(
      colorScheme: ColorScheme.dark(),
      // textTheme: TextTheme(
      //   bodyText2: TextStyle(color: Colors.white),
      // ),
      // scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(backgroundColor: Colors.black));
}
