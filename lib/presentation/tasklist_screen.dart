import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasktrack/database/tasks_database.dart';
import 'package:tasktrack/presentation/taskdetails_screen.dart';
import 'package:tasktrack/themes/eclipsar_theme.dart';
import 'package:tasktrack/themes/polaris_theme.dart';

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

  @override
  void initState() {
    refreshTasks();
    super.initState();
  }

  @override
  void dispose() {
    TasksDatabase.instance.close();
    super.dispose();
  }

  Future refreshTasks() async {
    setState(() {
      isLoading = true;
    });
    tasks = [];
    tasks = await TasksDatabase.instance.readAllTasks();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> newTask() async {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _categoryController = TextEditingController();
    String prioritySelection = "HIGH";
    DateTime? pickedDate;
    var priorities = ['HIGH', 'MEDIUM', 'LOW'];

    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: PolarisTheme.midnightSlate,
          title: Text(
            'New Task',
            style: GoogleFonts.montserrat(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: EclipsarTheme.ivory
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  cursorColor: EclipsarTheme.ivory,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: EclipsarTheme.ivory
                  ),
                  textCapitalization: TextCapitalization.words,
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: EclipsarTheme.ivory
                    ),
                    labelText: "Title"
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  cursorColor: EclipsarTheme.ivory,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: EclipsarTheme.ivory
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: EclipsarTheme.ivory
                      ),
                    labelText: "Description"
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  cursorColor: EclipsarTheme.ivory,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: EclipsarTheme.ivory
                  ),
                  textCapitalization: TextCapitalization.words,
                  controller: _categoryController,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: EclipsarTheme.ivory
                      ),
                    labelText: "Category"
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  dropdownColor: PolarisTheme.midnightSlate,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: EclipsarTheme.ivory
                  ),
                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: EclipsarTheme.ivory
                      ),
                    labelText: "Priority"
                  ),
                  value: prioritySelection,
                  items: priorities.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
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
                    backgroundColor: MaterialStatePropertyAll<Color>(EclipsarTheme.sereneBlue),
                    foregroundColor: MaterialStatePropertyAll<Color>(PolarisTheme.midnightSlate)
                  ),
                    onPressed: () async {
                      DateTime? deadline = await showDatePicker(
                        helpText: "Set Deadline",
                        builder: (context, child) {
                          return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme(
                                    brightness: Brightness.dark,
                                    primary: PolarisTheme.midnightSlate,
                                    onPrimary: PolarisTheme.pureSnow,
                                    secondary: EclipsarTheme.sereneBlue,
                                    onSecondary: EclipsarTheme.deepNavy,
                                    error: PolarisTheme.coralBlaze,
                                    onError: PolarisTheme.mintBreeze,
                                    background: PolarisTheme.midnightSlate,
                                    onBackground: PolarisTheme.midnightSlate,
                                    surface: EclipsarTheme.sereneBlue,
                                    onSurface: PolarisTheme.midnightSlate)
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
                        color: PolarisTheme.midnightSlate
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
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: EclipsarTheme.ivory
                  ),
                )
            ),
            TextButton(
              child: Text(
                  'DONE',
                style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: EclipsarTheme.ivory
                ),
              ),
              onPressed: () async {
                taskDetails = [
                  _titleController.text.trim(),
                  _descriptionController.text.trim(),
                  _categoryController.text.trim(),
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
                refreshTasks();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EclipsarTheme.sereneBlue,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          newTask();
        },
        backgroundColor: PolarisTheme.midnightSlate,
        foregroundColor: EclipsarTheme.ivory,
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
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: PolarisTheme.midnightSlate
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
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
                      refreshTasks();
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: PolarisTheme.midnightSlate,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            title: Text(
                              task.name,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: PolarisTheme.pureSnow
                              ),
                            ),
                            subtitle: Text(
                              task.description,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                  color: PolarisTheme.pureSnow
                              )
                            ),
                            contentPadding: EdgeInsets.all(10),
                            tileColor: Colors.transparent,
                            textColor: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10,
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