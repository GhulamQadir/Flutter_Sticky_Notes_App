// ignore_for_file: prefer_const_constructors, unused_label

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class ChangeTheme {
  static final lightTheme = ThemeData(
    textTheme: TextTheme(
      bodyText2: TextStyle(color: Colors.black),
    ),
    colorScheme: ColorScheme.light(),
  );
  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(),
    textTheme: TextTheme(
      bodyText2: TextStyle(color: Colors.white),
    ),
  );
}
