import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasktrack/presentation/taskdetails_screen.dart';

import '../database/tasks_database.dart';
import '../models/task.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
    tasks = await TasksDatabase.instance.readAllTasks("deadline");
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: EclipsarTheme.sereneBlue,
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   scrolledUnderElevation: 0.0,
      //   backgroundColor: Colors.transparent,
      //   systemOverlayStyle: const SystemUiOverlayStyle(
      //       statusBarBrightness: Brightness.dark
      //   ),
      // ),
      // body: Padding(
      //   padding: const EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 20),
      //   child: Column(
      //     children: [
      //       const SizedBox(
      //         height: 40,
      //       ),
      //       Text(
      //         "Categories",
      //         style: GoogleFonts.montserrat(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 50,
      //             color: PolarisTheme.midnightSlate
      //         ),
      //       ),
      //       const SizedBox(
      //         height: 20,
      //       ),
      //       Expanded(
      //         child: ListView.builder(
      //             itemCount: tasks.length,
      //             itemBuilder: (context, index) {
      //               final task = tasks[index];
      //               return GestureDetector(
      //                   onTap: () async {
      //                     await Navigator.of(context).push(
      //                         MaterialPageRoute(
      //                             builder: (context) => TaskDetailsScreen(taskID: task.id!)
      //                         )
      //                     );
      //                     refreshTasks();
      //                   },
      //                   child: Column(
      //                     children: [
      //                       Container(
      //                         decoration: BoxDecoration(
      //                           color: PolarisTheme.midnightSlate,
      //                           borderRadius: BorderRadius.circular(20),
      //                         ),
      //                         child: ListTile(
      //                           title: Text(
      //                             task.name,
      //                             style: GoogleFonts.poppins(
      //                                 fontSize: 20,
      //                                 fontWeight: FontWeight.bold,
      //                                 color: PolarisTheme.pureSnow
      //                             ),
      //                           ),
      //                           subtitle: Text(
      //                               task.description,
      //                               style: GoogleFonts.poppins(
      //                                   fontSize: 15,
      //                                   fontWeight: FontWeight.w400,
      //                                   color: PolarisTheme.pureSnow
      //                               )
      //                           ),
      //                           contentPadding: EdgeInsets.all(10),
      //                           tileColor: Colors.transparent,
      //                           textColor: Colors.black,
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         height: 10,
      //                       )
      //                     ],
      //                   )
      //               );
      //             }
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}