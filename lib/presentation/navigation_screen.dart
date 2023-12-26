import 'package:flutter/material.dart';
import 'package:tasktrack/presentation/category_screen.dart';
import 'package:tasktrack/presentation/home_screen.dart';
import 'package:tasktrack/presentation/tasklist_screen.dart';
import 'package:tasktrack/themes/duskenvale_theme.dart';
import 'package:tasktrack/themes/eclipsar_theme.dart';
import 'package:tasktrack/themes/polaris_theme.dart';

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
        backgroundColor: PolarisTheme.midnightSlate,
        indicatorColor: PolarisTheme.coralBlaze,
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
              color: EclipsarTheme.ivory,
            ),
            selectedIcon: Icon(Icons.home),
            label: 'Home'
          ),
          NavigationDestination(
            icon: Icon(
              Icons.task_outlined,
              color: EclipsarTheme.ivory,
            ),
            selectedIcon: Icon(Icons.task),
            label: 'Tasks'
          ),
          NavigationDestination(
            icon: Icon(
              Icons.category_outlined,
              color: EclipsarTheme.ivory,
            ),
            selectedIcon: Icon(Icons.category),
            label: 'Categories'
          )
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: const <Widget>[
          HomeScreen(),
          TasklistScreen(),
          CategoryScreen()
        ],
      ),
    );
  }
}