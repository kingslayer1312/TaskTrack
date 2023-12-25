import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tasktrack/database/tasks_database.dart';

import '../models/task.dart';

class TaskDetailsScreen extends StatefulWidget {
  final int taskID;
  const TaskDetailsScreen({
    Key? key,
    required this.taskID,
  }) : super(key: key);

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {

  late Task task = Task(
      name: "name $num",
      description: "description",
      category: "category",
      priority: "priority",
      deadline: DateTime.now(),
      status: false
  );
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshTask();
  }

  Future refreshTask() async {
    setState(() {
      isLoading = true;
    });
    this.task = await TasksDatabase.instance.readTaskByID(widget.taskID);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 20),
        child: Column(
          children: [
            Text(
              task.name
            ),
            Text(
              task.description
            ),
            Text(
              task.category
            ),
            Text(
              task.status ? "COMPLETED" : "PENDING"
            ),
            Text(
              DateFormat.yMMMd().format(task.deadline)
            ),
            IconButton(
              onPressed: () async {
                await TasksDatabase.instance.deleteTask(widget.taskID);
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.delete)
            )
          ],
        ),
      ),
    );
  }
}