import 'package:flutter/material.dart';
import 'package:flutter_advance_todo/notes/add_note.dart';
import 'package:flutter_advance_todo/notes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesScreen(),
      routes: {
        "/add_note": (context) => AddNote(),
        "/notes": (context) => NotesScreen(),
      },
    );
  }
}
