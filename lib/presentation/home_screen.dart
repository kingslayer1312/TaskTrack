import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasktrack/database/tasks_database.dart';

import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  int numberOfTasks = 0;
  bool isLoading = false;



  String greeting() {
    var hour = DateTime.now().hour;
    if (hour >= 0 && hour <= 12) {
      return "Morning";
    }
    else if (hour >= 12 && hour <= 16) {
      return "Afternoon";
    }
    else {
      return "Evening";
    }
  }

  Future refreshTasks() async {
    setState(() {
      isLoading = true;
    });
    tasks = [];
    tasks = await TasksDatabase.instance.readAllTasks();
    setState(() {
      isLoading = false;
      numberOfTasks = tasks.length;
    });
  }

  @override
  void initState() {
    refreshTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    refreshTasks();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 20),
        child: Center(
          child: Column(
              children: [
                Text(
                  "Good ${greeting()}",
                  style: GoogleFonts.varelaRound(
                    fontSize: 50
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                    "Total tasks: $numberOfTasks"
                ),
              ]
          )
        )
      ),
    );
  }
}