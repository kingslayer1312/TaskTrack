import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tasktrack/database/tasks_database.dart';
import 'package:tasktrack/themes/app_theme.dart';
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

  String getCurrentTime() {
    return "${DateFormat("kk:mm").format(DateTime.now())} ${DateTime.now().timeZoneName}";
  }

  Future refreshTasks() async {
    setState(() {
      isLoading = true;
    });
    tasks = [];
    tasks = await TasksDatabase.instance.readAllTasks("deadline");
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
      backgroundColor: AppTheme.dun,
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
                    fontWeight: FontWeight.w400,
                    fontSize: 60,
                    color: Colors.black87
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                PhysicalModel(
                    color: Colors.white70,
                    elevation: 30,
                    shadowColor: AppTheme.khaki,
                    borderRadius: BorderRadius.circular(150),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: Container(
                          height: 60.0,
                          width: 300.0,
                          color: AppTheme.gunmetal,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat("dd.MM.yyyy").format(DateTime.now()),
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.white70
                                  ),
                                ),
                                Spacer(
                                  flex: 2,
                                ),
                                VerticalDivider(
                                  color: AppTheme.dun,
                                ),
                                Spacer(
                                  flex: 2,
                                ),
                                Text(
                                  getCurrentTime(),
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.white70
                                  ),
                                ),
                              ],
                            ),
                          )// Adjust the color as needed
                      ),
                    ),
                ),
                SizedBox(
                  height: 50,
                ),
                PhysicalModel(
                  color: Colors.white70,
                  elevation: 30,
                  shadowColor: AppTheme.khaki,
                  borderRadius: BorderRadius.circular(150),
                  child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                          color: AppTheme.gunmetal,
                          shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                              color: AppTheme.khaki,
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
                                    color: AppTheme.gunmetal
                                  ),
                                ),
                                Divider(
                                  thickness: 0.5,
                                  color: Colors.black87,
                                ),
                                Text(
                                  "$numberOfTasks",
                                  style: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.hookersGreen
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