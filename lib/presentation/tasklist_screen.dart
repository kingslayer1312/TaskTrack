import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasktrack/database/tasks_database.dart';
import 'package:tasktrack/presentation/taskdetails_screen.dart';

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
          title: Text('New Task'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title"
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description"
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: "Category"
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
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
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      DateTime? deadline = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 2)
                      );
                      setState(() {
                        pickedDate = deadline;
                      });
                    },
                    child: Text(
                      "SET DEADLINE"
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
                  "CANCEL"
                )
            ),
            TextButton(
              child: Text('DONE'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          newTask();
        },
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 20),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              "Tasks",
              style: GoogleFonts.varelaRound(
                fontWeight: FontWeight.w600,
                fontSize: 50
              ),
            ),
            SizedBox(
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
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              task.name,
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(task.description),
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