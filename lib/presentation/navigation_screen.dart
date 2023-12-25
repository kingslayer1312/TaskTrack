import 'package:flutter/material.dart';
import 'package:tasktrack/presentation/category_screen.dart';
import 'package:tasktrack/presentation/home_screen.dart';
import 'package:tasktrack/presentation/tasklist_screen.dart';

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
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'
          ),
          NavigationDestination(
              icon: Icon(Icons.task_outlined),
              selectedIcon: Icon(Icons.task),
              label: 'Tasks'
          ),
          NavigationDestination(
              icon: Icon(Icons.category_outlined),
              selectedIcon: Icon(Icons.category),
              label: 'Categories'
          )
        ],
      ),
      body: IndexedStack(
        children: <Widget>[
          HomeScreen(),
          TasklistScreen(),
          CategoryScreen()
        ],
        index: currentPageIndex,
      ),
    );
  }
}