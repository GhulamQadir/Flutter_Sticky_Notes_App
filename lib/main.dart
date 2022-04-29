// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_advance_todo/notes/add_note.dart';
import 'package:flutter_advance_todo/notes.dart';
import 'package:flutter_advance_todo/theme/theme_btn.dart';
import 'package:provider/provider.dart';

import 'theme/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
              themeMode: themeProvider.themeMode,
              theme: ChangeTheme.lightTheme,
              darkTheme: ChangeTheme.darkTheme,
              debugShowCheckedModeBanner: false,
              home: NotesScreen(),
              routes: {
                "/add_note": (context) => AddNote(),
                "/notes": (context) => NotesScreen(),
                "/theme-btn": (context) => ChangeThemeButton(),
              });
        });
  }
}
