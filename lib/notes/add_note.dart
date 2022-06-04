// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advance_todo/notes/controller.dart';
import 'package:flutter_advance_todo/notes.dart';
import 'package:flutter_advance_todo/notes/model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/theme.dart';

class AddNote extends StatefulWidget {
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController notesTitleController = TextEditingController();
  TextEditingController notesDescripController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  NotesController controller = NotesController();

  DateTime date = DateTime(2022, 04, 18);

  pickDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      initialDate: date,
      lastDate: DateTime(2100),
      builder: (context, child) {
        final headerTextColor =
            Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.white;
        final btnTextColor =
            Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.purple;
        final headerColor =
            Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                ? Colors.black
                : Colors.purple;
        final bodyTextColor =
            Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: headerColor, // header background color
              onPrimary: headerTextColor, // header text color
              onSurface: bodyTextColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: btnTextColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (newDate == null) return;
    setState(() {
      date = newDate;
      var formatDate = "${date.month}/${date.day}/${date.year}";
      dateController.text = formatDate.toString();
    });
  }

  SharedPreferences? sharedPreferences;

  getNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? notesList = prefs.getStringList("notes");
    controller.notes =
        notesList!.map((e) => Note.fromJson(json.decode(e))).toList();
    setState(() {});
  }

  addNote() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      controller.notes.add(controller.saveNote(notesTitleController.text,
          notesDescripController.text, dateController.text));
      // controller.notesDescripList.add(notesDescripController.text);
      // controller.notesDatesList.add(dateController.text);
    });
    controller.saveNotes();
    print(jsonEncode(controller.notes));

    // for (var i = 0; i < controller.notes.length; i++) {
    //   print("Title of note is: ${controller.notes[i].title}");
    //   print("Date of note is: ${controller.notes[i].date}");
    //   print("Description of note is: ${controller.notes[i].description}");
    // }

    // controller.saveNotes();
    // print(controller.notesTitleList);
    // print(controller.notesDescripList);
    // print(controller.notesDatesList);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => NotesScreen()),
        (route) => false);
  }

  goToNotes() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NotesScreen()));
  }

  @override
  void initState() {
    dateController.text = "${date.month}/${date.day}/${date.year}";
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final btnColor =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.white
            : Colors.purple;

    final iconColor =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.grey
            : Colors.grey;

    final textColor =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.black
            : Colors.white;

    final appBarColor =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.black
            : Colors.purple;
    final bodyColor =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.grey[900]
            : Colors.white;

    final focusColor =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.white
            : Colors.purple;
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text("Add Note"),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: goToNotes,
          ),
          backgroundColor: appBarColor),
      backgroundColor: bodyColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 22,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Title",
                          style: TextStyle(
                              fontSize: 22,
                              wordSpacing: 1.3,
                              fontWeight: FontWeight.w500),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 7, right: 20),
                      child: SizedBox(
                        height: 75,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ThemeData().colorScheme.copyWith(
                                  primary: focusColor,
                                ),
                          ),
                          child: TextFormField(
                            controller: notesTitleController,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your note title';
                              } else if (value.length < 3) {
                                return "Your note title is too short";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.title_outlined, color: iconColor),
                              hintText: "Enter your note title",
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: focusColor, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 22,
                              wordSpacing: 1.3,
                              fontWeight: FontWeight.w500),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 7, right: 20),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ThemeData().colorScheme.copyWith(
                                primary: focusColor,
                              ),
                        ),
                        child: TextFormField(
                          controller: notesDescripController,
                          keyboardType: TextInputType.name,
                          maxLines: 8, // <--- maxLines

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your note description';
                            } else if (value.length < 8) {
                              return "Your note description is too short";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.description,
                              color: iconColor,
                            ),
                            hintText: "Enter your note description",
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: focusColor, width: 2)),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Date Picker",
                          style: TextStyle(
                              fontSize: 19,
                              wordSpacing: 1.3,
                              fontWeight: FontWeight.w500),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 7, right: 20),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ThemeData().colorScheme.copyWith(
                                primary: Colors.purple,
                              ),
                        ),
                        child: TextFormField(
                            controller: dateController,
                            keyboardType: TextInputType.datetime,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your task date';
                              } else if (value.length < 6) {
                                return "Your task date is too short";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "Pick Date",
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: focusColor, width: 2)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 1),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: iconColor,
                                  ),
                                  onPressed: pickDate,
                                ))),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: addNote,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Text(
                          "Add note",
                          style: TextStyle(fontSize: 18, color: textColor),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(btnColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
