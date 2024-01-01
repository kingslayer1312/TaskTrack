import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasktrack/database/tasks_database.dart';
import 'package:tasktrack/presentation/taskdetails_screen.dart';
import 'package:tasktrack/themes/app_theme.dart';

import '../models/task.dart';

class TasklistScreen extends StatefulWidget {
  const TasklistScreen({super.key});
  @override
  State<TasklistScreen> createState() => _TasklistScreenState();
}

class _TasklistScreenState extends State<TasklistScreen> {
  late List<Task> tasks = [];
  bool isLoading = false;
  List<String> taskDetails = [];

  String ordering = "deadline";

  @override
  void initState() {
    refreshTasks(ordering);
    super.initState();
  }

  @override
  void dispose() {
    TasksDatabase.instance.close();
    super.dispose();
  }

  Future refreshTasks(String condition) async {
    setState(() {
      isLoading = true;
    });
    tasks = [];
    tasks = await TasksDatabase.instance.readAllTasks(condition);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> newTask() async {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    String categorySelection = "GENERAL";
    String prioritySelection = "TOP";
    DateTime? pickedDate;
    var categories = ['GENERAL', 'WORK', 'HOME', 'FITNESS', 'FINANCE'];
    var priorities = ['TOP', 'MID', 'LOW'];

    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.khaki,
          title: Text(
            'New Task',
            style: GoogleFonts.montserrat(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black87
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  cursorColor: Colors.black87,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87
                  ),
                  textCapitalization: TextCapitalization.words,
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: Colors.black87
                    ),
                    labelText: "Title"
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  cursorColor: AppTheme.gunmetal,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black87
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Colors.black87
                      ),
                    labelText: "Description"
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  dropdownColor: AppTheme.dun,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70
                  ),
                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Colors.black87
                      ),
                      labelText: "Category"
                  ),
                  value: categorySelection,
                  items: categories.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                          items,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black87
                          )
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      categorySelection = newValue!;
                    });
                  },
                  onSaved: (String? newValue) {
                    setState(() {
                      categorySelection = newValue!;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  dropdownColor: AppTheme.dun,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70
                  ),
                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.black87
                      ),
                    labelText: "Priority"
                  ),
                  value: prioritySelection,
                  items: priorities.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                          items,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black87
                          )
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      prioritySelection = newValue!;
                    });
                  },
                  onSaved: (String? newValue) {
                    setState(() {
                      prioritySelection = newValue!;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.dun),
                    foregroundColor: MaterialStatePropertyAll<Color>(AppTheme.gunmetal)
                  ),
                    onPressed: () async {
                      DateTime? deadline = await showDatePicker(
                        helpText: "Set Deadline",
                        builder: (context, child) {
                          return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme(
                                    brightness: Brightness.dark,
                                    primary: AppTheme.dun,
                                    onPrimary: AppTheme.gunmetal,
                                    secondary: AppTheme.dun,
                                    onSecondary: AppTheme.gunmetal,
                                    error: AppTheme.hookersGreen,
                                    onError: AppTheme.hookersGreen,
                                    background: AppTheme.gunmetal,
                                    onBackground: AppTheme.gunmetal,
                                    surface: AppTheme.gunmetal,
                                    onSurface: AppTheme.dun)
                              ),
                              child: child!);
                        },
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 2)
                      );
                      setState(() {
                        pickedDate = deadline;
                      });
                    },
                    child: Text(
                      "SET DEADLINE",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.gunmetal
                      ),
                    )
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "CANCEL",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.gunmetal
                  ),
                )
            ),
            TextButton(
              child: Text(
                  'DONE',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.gunmetal
                ),
              ),
              onPressed: () async {
                taskDetails = [
                  _titleController.text.trim(),
                  _descriptionController.text.trim(),
                  categorySelection,
                  prioritySelection,
                  pickedDate?.toIso8601String() ?? ""
                ];
                Task task = Task(
                    name: taskDetails[0],
                    description: taskDetails[1],
                    category: taskDetails[2],
                    priority: taskDetails[3],
                    deadline: DateTime.parse(taskDetails[4]),
                    status: false
                );
                await TasksDatabase.instance.createTask(task);
                Navigator.of(context).pop();
                refreshTasks("priority");
              },
            ),
          ],
        );
      },
    );
  }

  Color getPriorityColor(String priority) {
    if (priority == "TOP") {
      return Colors.redAccent;
    }
    else if (priority == "MID") {
      return Colors.yellow;
    }
    else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dun,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          newTask();
        },
        backgroundColor: AppTheme.gunmetal,
        foregroundColor: AppTheme.dun,
        child: const Icon(Icons.add),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 20),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              "Tasks",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
                fontSize: 60,
                color: Colors.black87
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Sort Tasks",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.gunmetal),
                    foregroundColor: MaterialStatePropertyAll<Color>(AppTheme.dun)
                ),
                onPressed: () {
                  setState(() {
                    if (ordering == "priority") {
                      ordering = "deadline";
                    }
                    else {
                      ordering = "priority";
                    }
                  });
                  refreshTasks(ordering);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sort),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      (ordering == "priority") ? "deadline".toUpperCase() : "priority".toUpperCase(),
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                )
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              thickness: 1,
              height: 20,
              indent: 10,
              endIndent: 10,
              color: Colors.black87,
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TaskDetailsScreen(taskID: task.id!)
                        )
                      );
                      refreshTasks(ordering);
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.gunmetal,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.name,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white70
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_month_rounded,
                                          color: Colors.white70,
                                          size: 22,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                            "${task.deadline.day}/"
                                                "${task.deadline.month}/"
                                                "${task.deadline.year}",
                                            style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white70
                                            )
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Spacer(

                                ),
                                Text(
                                  task.priority,
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: getPriorityColor(task.priority)
                                  ),
                                ),
                              ],
                            ),
                          )
                        ),
                        SizedBox(
                          height: 8,
                        )
                      ],
                    )
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}