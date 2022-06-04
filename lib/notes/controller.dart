// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advance_todo/notes/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesController {
  SharedPreferences? sharedPreferences;

  // List<String> notesTitleList = [];
  // List<String> notesDescripList = [];
  // List<String> notesDatesList = [];

  List<Note> notes = [];

  Note saveNote(
    String title,
    String description,
    String date,
  ) {
    return Note(
      title,
      description,
      date,
    );
  }

  saveNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notesList = notes.map((i) => json.encode(i.toJson())).toList();
    sharedPreferences!.setStringList("notes", notesList);
    print(notes);
  }
}
