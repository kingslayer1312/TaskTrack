import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasktrack/database/tasks_database.dart';
import '../models/task.dart';
import '../themes/app_theme.dart';


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
        backgroundColor: AppTheme.dun,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(
                20, 1.2 * kToolbarHeight, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppTheme.gunmetal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Text(
                          task.name,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              color: Colors.white70
                          )
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppTheme.gunmetal,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description",
                              style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Divider(

                            ),
                            Text(
                                task.description,
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Colors.white,
                                )
                            ),
                          ],
                        )
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppTheme.gunmetal,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Deadline",
                              style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Divider(

                            ),
                            Text(
                                "${task.deadline.day}/"
                                    "${task.deadline.month}/"
                                    "${task.deadline.year}",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Colors.white,
                                )
                            ),
                          ],
                        )
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppTheme.gunmetal,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Priority",
                              style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Divider(

                            ),
                            Text(
                                "${task.priority}",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Colors.white,
                                )
                            ),
                          ],
                        )
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppTheme.gunmetal,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Category",
                              style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Divider(

                            ),
                            Text(
                                "${task.category}",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Colors.white
                                )
                            ),
                          ],
                        )
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(Colors.red.shade700),
                        ),
                          onPressed: () async {
                            await TasksDatabase.instance.deleteTask(task.id!);
                            Navigator.pop(context);
                          },
                        child: Icon(
                          Icons.delete_outline_outlined,
                          color: AppTheme.gunmetal,
                          size: 28,
                        ),
                      ),
                    )
                  ]
              ),
            )
        )
    );
  }
}