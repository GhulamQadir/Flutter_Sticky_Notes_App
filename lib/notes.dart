// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_null_comparison, prefer_is_empty, deprecated_member_use, avoid_single_cascade_in_expression_statements

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advance_todo/theme/theme_btn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notes/controller.dart';
import 'notes/model.dart';
import 'theme/theme.dart';

class NotesScreen extends StatefulWidget {
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  NotesController controller = NotesController();

  TextEditingController editTitleController = TextEditingController();
  TextEditingController editDescripController = TextEditingController();
  TextEditingController editDateController = TextEditingController();

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
      editDateController.text = formatDate.toString();
    });
  }

  closeDialog() {
    Navigator.of(context).pop();
  }

  addTodo() {
    Navigator.of(context).pushNamed("/add_note");
  }

  SharedPreferences? sharedPreferences;

  getNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? notesList = prefs.getStringList("notes");
    controller.notes =
        notesList!.map((e) => Note.fromJson(json.decode(e))).toList();
    setState(() {});
  }

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  void deleteAllDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.purple,
                  ),
                  Text(
                    "  Clear All",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text("Are you sure you want to delete all your notes?"),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: closeDialog,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )),
                  SizedBox(
                    width: 50,
                  ),
                  TextButton(
                    onPressed: deleteAll,
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ));
        });
  }

  deleteAll() {
    setState(() {
      controller.notes.clear();
      controller.saveNotes();
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final text = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? "Dark Theme"
        : "Light Theme";

    final btnColor =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.white
            : Colors.purple;

    final iconColor =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.black
            : Colors.white;

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
          title: Center(child: Text("Sticky Notes App")),
          backgroundColor: appBarColor),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          controller.notes.length > 1
              ? FloatingActionButton.extended(
                  onPressed: deleteAllDialog,
                  backgroundColor: btnColor,
                  label: Text(
                    'Clear all',
                    style: TextStyle(color: textColor),
                  ),
                  icon: Icon(Icons.clear_rounded, color: iconColor),
                )
              : Text(""),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: FloatingActionButton.extended(
              onPressed: addTodo,
              backgroundColor: btnColor,
              label: Text(
                "Add",
                style: TextStyle(color: textColor),
              ),
              icon: Icon(Icons.add, color: iconColor),
            ),
          ),
        ],
      ),
      backgroundColor: bodyColor,
      drawer: Theme(
          data: Theme.of(context).copyWith(
              // canvasColor: Colors.purple,
              ),
          child: Drawer(
              child: SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Text(text,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                            ChangeThemeButton()
                          ],
                        ),
                      ))))),
      body: controller.notes.length < 1
          ? Center(
              child: Text(
                "You have no notes yet",
                style: TextStyle(
                    // color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
            )
          : Column(children: [
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: controller.notes.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    right: 9, left: 5, bottom: 10),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xfff2f2f2),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Color(0xffebe8e8),
                                            width: 1)),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4),
                                            child: Text(
                                              controller.notes[index].title
                                                  .toString()
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          subtitle: Text(
                                              controller.notes[index]
                                                      .description ??
                                                  '',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14)),
                                          trailing: Wrap(
                                            spacing:
                                                0, // space between two icons
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    var editTitle = controller
                                                        .notes[index].title;
                                                    var editDescrip = controller
                                                        .notes[index]
                                                        .description;
                                                    var editDate = controller
                                                        .notes[index].date;
                                                    setState(() {
                                                      editTitleController.text =
                                                          editTitle!;
                                                      editDescripController
                                                          .text = editDescrip!;
                                                      editDateController.text =
                                                          editDate!;
                                                    });
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                bodyColor,
                                                            title: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    "Edit ToDo"),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child: IconButton(
                                                                        onPressed:
                                                                            closeDialog,
                                                                        icon: Icon(
                                                                            Icons.close))),
                                                              ],
                                                            ),
                                                            content: Form(
                                                              key: _formKey,
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .topLeft,
                                                                        child:
                                                                            Text(
                                                                          "Title",
                                                                          style: TextStyle(
                                                                              fontSize: 19,
                                                                              wordSpacing: 1.3,
                                                                              fontWeight: FontWeight.w500),
                                                                        )),
                                                                    SizedBox(
                                                                      height: 6,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          45,
                                                                      child:
                                                                          Theme(
                                                                        data: Theme.of(context)
                                                                            .copyWith(
                                                                          colorScheme: ThemeData()
                                                                              .colorScheme
                                                                              .copyWith(
                                                                                primary: focusColor,
                                                                              ),
                                                                        ),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              editTitleController,
                                                                          keyboardType:
                                                                              TextInputType.name,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return 'Please enter your note title';
                                                                            } else if (value.length <
                                                                                3) {
                                                                              return "Your note title is too short";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            prefixIcon:
                                                                                Icon(
                                                                              Icons.title,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            hintText:
                                                                                "Enter your note title",
                                                                            focusedBorder:
                                                                                OutlineInputBorder(borderSide: BorderSide(color: focusColor, width: 2)),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.grey, width: 1),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          25,
                                                                    ),
                                                                    Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .topLeft,
                                                                        child:
                                                                            Text(
                                                                          "Description",
                                                                          style: TextStyle(
                                                                              fontSize: 19,
                                                                              wordSpacing: 1.3,
                                                                              fontWeight: FontWeight.w500),
                                                                        )),
                                                                    SizedBox(
                                                                      height: 6,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          Theme(
                                                                        data: Theme.of(context)
                                                                            .copyWith(
                                                                          colorScheme: ThemeData()
                                                                              .colorScheme
                                                                              .copyWith(
                                                                                primary: focusColor,
                                                                              ),
                                                                        ),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              editDescripController,
                                                                          keyboardType:
                                                                              TextInputType.name,
                                                                          maxLines:
                                                                              4,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return 'Please enter your note description';
                                                                            } else if (value.length <
                                                                                8) {
                                                                              return "Your note description is too short";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            prefixIcon:
                                                                                Icon(
                                                                              Icons.description,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            hintText:
                                                                                "Enter your note description",
                                                                            focusedBorder:
                                                                                OutlineInputBorder(borderSide: BorderSide(color: focusColor, width: 2)),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.grey, width: 1),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          30,
                                                                    ),
                                                                    Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .topLeft,
                                                                        child:
                                                                            Text(
                                                                          "Date Picker",
                                                                          style: TextStyle(
                                                                              fontSize: 19,
                                                                              wordSpacing: 1.3,
                                                                              fontWeight: FontWeight.w500),
                                                                        )),
                                                                    SizedBox(
                                                                      height: 6,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          45,
                                                                      child:
                                                                          Theme(
                                                                        data: Theme.of(context)
                                                                            .copyWith(
                                                                          colorScheme: ThemeData()
                                                                              .colorScheme
                                                                              .copyWith(
                                                                                primary: focusColor,
                                                                              ),
                                                                        ),
                                                                        child: TextFormField(
                                                                            controller: editDateController,
                                                                            keyboardType: TextInputType.datetime,
                                                                            validator: (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return 'Please pick your task date';
                                                                              } else if (value.length < 6) {
                                                                                return "Your task date is too short";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration: InputDecoration(
                                                                                hintText: "Pick Date",
                                                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: focusColor, width: 1)),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(color: Colors.grey, width: 1),
                                                                                ),
                                                                                suffixIcon: IconButton(
                                                                                  icon: Icon(Icons.calendar_today, color: Colors.grey),
                                                                                  onPressed: pickDate,
                                                                                ))),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          23,
                                                                    ),
                                                                    TextButton(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                40,
                                                                            right:
                                                                                40),
                                                                        child:
                                                                            Text(
                                                                          "Edit task",
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: textColor),
                                                                        ),
                                                                      ),
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all(btnColor),
                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                          )),
                                                                      onPressed:
                                                                          () {
                                                                        if (!_formKey
                                                                            .currentState!
                                                                            .validate()) {
                                                                          return;
                                                                        }
                                                                        setState(
                                                                            () {
                                                                          controller
                                                                              .notes
                                                                            ..replaceRange(index,
                                                                                index + 1, {
                                                                              controller.saveNote(editTitleController.text, editDescripController.text, editDateController.text)
                                                                            });
                                                                          controller
                                                                              .saveNotes();
                                                                        });
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.purple,
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      controller.notes
                                                          .removeAt(index);

                                                      controller.saveNotes();
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red[600],
                                                    size: 22,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, top: 2, bottom: 3),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              controller.notes[index].date
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )));
                          }),
                    ),
                  ],
                ),
              )
            ]),
    );
  }
}
