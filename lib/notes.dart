// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_null_comparison, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notes/controller.dart';

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
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.purple, // header background color
              onPrimary: Colors.white, // header text color
              // onSurface: Colors.green, // body text color
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

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  deleteAll() {
    setState(() {
      controller.notesTitleList.clear();
      controller.notesDescripList.clear();
      controller.notesDatesList.clear();
      controller.saveNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
              title: Center(child: Text("Advance ToDo App")),
              backgroundColor: Colors.purple),
          floatingActionButton: FloatingActionButton(
            onPressed: addTodo,
            backgroundColor: Colors.purple,
            child: Icon(Icons.add),
          ),
          body: controller.notesTitleList.length < 1
              ? Center(
                  child: Text(
                    "No tasks added yet",
                    style: TextStyle(
                        color: Colors.black,
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
                        controller.notesTitleList.length > 1
                            ? ElevatedButton(
                                onPressed: deleteAll, child: Text("Delete all"))
                            : Container(),
                        Expanded(
                          child: ListView.builder(
                              itemCount: controller.notesTitleList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 9, left: 5, bottom: 10),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xfff2f2f2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Color(0xffebe8e8),
                                                width: 1)),
                                        child: Column(
                                          children: [
                                            Text(controller
                                                .notesDatesList[index]),
                                            ListTile(
                                              title: Text(
                                                controller
                                                    .notesTitleList[index],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              subtitle: Text(
                                                  controller
                                                      .notesDescripList[index],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13)),
                                              trailing: Wrap(
                                                spacing:
                                                    0, // space between two icons
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        var editTitle = controller
                                                                .notesTitleList[
                                                            index];
                                                        var editDescrip = controller
                                                                .notesDescripList[
                                                            index];
                                                        var editDate = controller
                                                                .notesDatesList[
                                                            index];
                                                        setState(() {
                                                          editTitleController
                                                              .text = editTitle;
                                                          editDescripController
                                                                  .text =
                                                              editDescrip;
                                                          editDateController
                                                              .text = editDate;
                                                        });
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
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
                                                                            icon:
                                                                                Icon(Icons.close))),
                                                                  ],
                                                                ),
                                                                content: Form(
                                                                  key: _formKey,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Align(
                                                                          alignment: Alignment
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
                                                                        height:
                                                                            6,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            45,
                                                                        child:
                                                                            Theme(
                                                                          data:
                                                                              Theme.of(context).copyWith(
                                                                            colorScheme: ThemeData().colorScheme.copyWith(
                                                                                  primary: Colors.purple,
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
                                                                              if (value == null || value.isEmpty) {
                                                                                return 'Please enter your title';
                                                                              } else if (value.length < 3) {
                                                                                return "Your task title is too short";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              hintText: "What needs to be done ?",
                                                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple, width: 1)),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey, width: 1),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            45,
                                                                        child:
                                                                            Theme(
                                                                          data:
                                                                              Theme.of(context).copyWith(
                                                                            colorScheme: ThemeData().colorScheme.copyWith(
                                                                                  primary: Colors.purple,
                                                                                ),
                                                                          ),
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                editDescripController,
                                                                            keyboardType:
                                                                                TextInputType.name,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return 'Please enter your title';
                                                                              } else if (value.length < 3) {
                                                                                return "Your task title is too short";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              hintText: "What needs to be done ?",
                                                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple, width: 1)),
                                                                              enabledBorder: OutlineInputBorder(
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
                                                                          alignment: Alignment
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
                                                                        height:
                                                                            6,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            45,
                                                                        child:
                                                                            Theme(
                                                                          data:
                                                                              Theme.of(context).copyWith(
                                                                            colorScheme: ThemeData().colorScheme.copyWith(
                                                                                  primary: Colors.purple,
                                                                                ),
                                                                          ),
                                                                          child: TextFormField(
                                                                              controller: editDateController,
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
                                                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple, width: 1)),
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(color: Colors.grey, width: 1),
                                                                                  ),
                                                                                  suffixIcon: IconButton(
                                                                                    icon: Icon(Icons.calendar_today),
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
                                                                              left: 40,
                                                                              right: 40),
                                                                          child:
                                                                              Text(
                                                                            "Edit task",
                                                                            style:
                                                                                TextStyle(fontSize: 18, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                        style: ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all(Colors.purple[500]),
                                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                            )),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            controller.notesTitleList.replaceRange(index,
                                                                                index + 1, {
                                                                              editTitleController.text
                                                                            });
                                                                            controller.notesDescripList.replaceRange(index,
                                                                                index + 1, {
                                                                              editDescripController.text
                                                                            });
                                                                            controller.notesDatesList.replaceRange(index,
                                                                                index + 1, {
                                                                              editDateController.text
                                                                            });
                                                                            controller.saveNotes();
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
                                                          controller
                                                              .notesTitleList
                                                              .removeAt(index);

                                                          controller
                                                              .notesDescripList
                                                              .removeAt(index);
                                                          controller
                                                              .notesDatesList
                                                              .removeAt(index);
                                                          controller
                                                              .saveNotes();
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
                                          ],
                                        )));
                              }),
                        ),
                      ],
                    ),
                  )
                ]),
        ));
  }
}
