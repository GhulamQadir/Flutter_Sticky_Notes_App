// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_advance_todo/notes/controller.dart';
import 'package:flutter_advance_todo/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.purple,
              onPrimary: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.purple, // button text color
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
    sharedPreferences = await SharedPreferences.getInstance();

    List<String>? getNotesTitleList =
        sharedPreferences?.getStringList('notesTitleList');
    controller.notesTitleList =
        getNotesTitleList!.map((e) => e.toString()).toList();
    setState(() {});

    List<String>? getNotesDescripList =
        sharedPreferences?.getStringList('notesDescripList');
    controller.notesDescripList =
        getNotesDescripList!.map((e) => e.toString()).toList();
    setState(() {});

    List<String>? getNotesDateList =
        sharedPreferences?.getStringList('notesDateList');
    controller.notesDatesList =
        getNotesDateList!.map((e) => e.toString()).toList();
    setState(() {});
  }

  addNote() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      controller.notesTitleList.add(notesTitleController.text);
      controller.notesDescripList.add(notesDescripController.text);
      controller.notesDatesList.add(dateController.text);
    });
    controller.saveNotes();
    print(controller.notesTitleList);
    print(controller.notesDescripList);
    print(controller.notesDatesList);
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            backgroundColor: Colors.purple),
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
                                    primary: Colors.purple,
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
                                prefixIcon: Icon(
                                  Icons.title_outlined,
                                ),
                                hintText: "Enter your note title",
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple, width: 1)),
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
                                  primary: Colors.purple,
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
                              ),
                              hintText: "Enter your note description",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.purple, width: 2)),
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
                                          color: Colors.purple, width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today),
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
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.purple[500]),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
      ),
    );
  }
}
