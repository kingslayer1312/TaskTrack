import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasktrack/database/tasks_database.dart';
import 'package:tasktrack/themes/duskenvale_theme.dart';
import 'package:tasktrack/themes/eclipsar_theme.dart';

import '../models/task.dart';
import '../themes/polaris_theme.dart';

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
      backgroundColor: EclipsarTheme.sereneBlue,
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
                  "TaskTrack",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: PolarisTheme.midnightSlate
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: PolarisTheme.midnightSlate
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                PhysicalModel(
                  color: Colors.white,
                  elevation: 30,
                  shadowColor: Colors.blue,
                  borderRadius: BorderRadius.circular(150),
                  child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                          color: PolarisTheme.midnightSlate,
                          shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                              color: EclipsarTheme.deepNavy,
                              shape: BoxShape.circle
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total Tasks",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: PolarisTheme.coralBlaze
                                  ),
                                ),
                                Divider(
                                  thickness: 0.5,
                                  color: PolarisTheme.pureSnow,
                                ),
                                Text(
                                  "$numberOfTasks",
                                  style: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: PolarisTheme.mintBreeze
                                  ),
                                ),
                              ],
                            ),
                          )
                        ),
                      )
                  )
                ),
              ]
          )
        )
      ),
    );
  }
}