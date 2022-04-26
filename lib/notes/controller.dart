import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesController {
  SharedPreferences? sharedPreferences;

  List<String> notesTitleList = [];
  List<String> notesDescripList = [];
  List<String> notesDatesList = [];

  saveNotes() async {
    sharedPreferences = await SharedPreferences.getInstance();

    List<String> saveNotesTitle =
        notesTitleList.map((i) => i.toString()).toList();
    sharedPreferences!.setStringList("notesTitleList", saveNotesTitle);

    List<String> saveNotesDescrip =
        notesDescripList.map((i) => i.toString()).toList();
    sharedPreferences!.setStringList("notesDescripList", saveNotesDescrip);

    List<String> saveNotesDate =
        notesDatesList.map((i) => i.toString()).toList();
    sharedPreferences!.setStringList("notesDateList", saveNotesDate);
    print(saveNotesTitle);
    print(saveNotesDescrip);
    print(saveNotesDate);
  }
}
