import 'package:flutter/material.dart';
import 'package:tasktrack/presentation/home_screen.dart';
import 'package:tasktrack/presentation/tasklist_screen.dart';
import 'package:tasktrack/themes/app_theme.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 70,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        backgroundColor: AppTheme.gunmetal,
        indicatorColor: AppTheme.dun,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white70,
            ),
            selectedIcon: Icon(
              Icons.home,
              color: Colors.black87,
            ),
            label: 'Home'
          ),
          NavigationDestination(
            icon: Icon(
              Icons.task_outlined,
              color: Colors.white70,
            ),
              selectedIcon: Icon(
                Icons.task,
                color: Colors.black87,
              ),
            label: 'Tasks'
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: const <Widget>[
          HomeScreen(),
          TasklistScreen(),
        ],
      ),
    );
  }
}