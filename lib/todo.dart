// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_null_comparison, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoScreen extends StatefulWidget {
  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController editTaskController = TextEditingController();
  TextEditingController editDateController = TextEditingController();

  DateTime date = DateTime(2022, 04, 18);

  List<String> taskList = [];
  List<String> datesList = [];

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
      dateController.text = formatDate.toString();
      editDateController.text = formatDate.toString();
    });
  }

  closeDialog() {
    Navigator.of(context).pop();
  }

  addTodo() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Add task"),
                SizedBox(
                  width: 10,
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: closeDialog, icon: Icon(Icons.close))),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
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
                        height: 45,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ThemeData().colorScheme.copyWith(
                                  primary: Colors.purple,
                                ),
                          ),
                          child: TextFormField(
                            controller: taskController,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your title';
                              } else if (value.length < 3) {
                                return "Your task title is too short";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "What needs to be done ?",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.purple, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
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
                      SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        height: 45,
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
                        height: 23,
                      ),
                      TextButton(
                        onPressed: addTask,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            "Add new task",
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
                )
              ],
            ),
          );
        });
  }

  addTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (taskController.text == "") {
      print("Please write todo title");
    } else if (dateController.text == "") {
      print("Please pick date");
    } else {
      setState(() {
        taskList.add(taskController.text);
        print(taskList);

        datesList.add(dateController.text);
        print(datesList);
      });
      saveNotes();
      Navigator.of(context).pop();
    }
  }

  SharedPreferences? sharedPreferences;

  saveNotes() async {
    sharedPreferences = await SharedPreferences.getInstance();

    List<String> saveTaskTitle = taskList.map((i) => i.toString()).toList();
    sharedPreferences!.setStringList("notesTitleList", saveTaskTitle);

    List<String> saveTaskDate = datesList.map((i) => i.toString()).toList();
    sharedPreferences!.setStringList("notesList", saveTaskDate);
    print(saveTaskTitle);
    print(saveTaskDate);
  }

  getNotes() async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<String>? getTaskTitleList =
        sharedPreferences?.getStringList('notesTitleList');
    taskList = getTaskTitleList!.map((e) => e.toString()).toList();
    setState(() {});

    List<String>? getTaskDateList =
        sharedPreferences?.getStringList('notesList');
    datesList = getTaskDateList!.map((e) => e.toString()).toList();
    setState(() {});
  }

  @override
  void initState() {
    dateController.text = "${date.month}/${date.day}/${date.year}";
    getNotes();
    super.initState();
  }

  deleteAll() {
    setState(() {
      taskList.clear();
      datesList.clear();
      saveNotes();
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
          body: taskList.length < 1
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
                        taskList.length > 1
                            ? ElevatedButton(
                                onPressed: deleteAll, child: Text("Delete all"))
                            : Container(),
                        Expanded(
                          child: ListView.builder(
                              itemCount: taskList.length,
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
                                            ListTile(
                                              title: Text(
                                                taskList[index],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              subtitle: Text(datesList[index],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13)),
                                              trailing: Wrap(
                                                spacing:
                                                    0, // space between two icons
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        var editTask =
                                                            taskList[index];
                                                        var editDate =
                                                            datesList[index];
                                                        setState(() {
                                                          editTaskController
                                                              .text = editTask;
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
                                                                                editTaskController,
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
                                                                            taskList.replaceRange(index,
                                                                                index + 1, {
                                                                              editTaskController.text
                                                                            });
                                                                            datesList.replaceRange(index,
                                                                                index + 1, {
                                                                              editDateController.text
                                                                            });
                                                                            saveNotes();
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
                                                          taskList
                                                              .removeAt(index);
                                                          datesList
                                                              .removeAt(index);
                                                          saveNotes();
                                                        });
                                                        print(taskList);
                                                        print(datesList);
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
