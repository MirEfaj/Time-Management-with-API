import 'package:flutter/material.dart';
import '../widgets/tm_app_bar.dart';
import 'cancelled_task_list_screen.dart';
import 'completed_task_list_screen.dart';
import 'new_task_list_screen.dart';
import 'progress_task_list_screen.dart';

class MainNavBarHolderScreen extends StatefulWidget {
  const MainNavBarHolderScreen({super.key});
  static const String name = '/main-nav-bar-holder';
  @override
  State<MainNavBarHolderScreen> createState() => _MainNavBarHolderScreenState();
}

class _MainNavBarHolderScreenState extends State<MainNavBarHolderScreen> {
  final List<Widget> _screens = [
    NewTaskListScreen(),
    ProgressTaskListScreen(),
    CompletedTaskListScreen(),
    CancelledTaskListScreen()
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tmAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
          onDestinationSelected: (int index){
          _selectedIndex = index;
          setState(() { });
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.new_label_outlined), label: "New"),
            NavigationDestination(icon: Icon(Icons.update), label: "Progress"),
            NavigationDestination(icon: Icon(Icons.done), label: "Complete"),
            NavigationDestination(icon: Icon(Icons.cancel_outlined), label: "Cancel"),
          ]),
    );
  }
}


