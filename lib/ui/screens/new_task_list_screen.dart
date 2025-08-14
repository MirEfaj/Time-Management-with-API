import 'package:flutter/material.dart';
import 'package:time_management/data/models/task_model.dart';
import 'package:time_management/data/models/task_status_count_model.dart';
import 'package:time_management/data/service/network_caller.dart';
import 'package:time_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:time_management/ui/widgets/snack_bar_msg.dart';
import '../../data/utils.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_summary_card.dart';
import 'add_new_task_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _getNewTasksInProgress = false;
  bool _getTasksStatusCountInProgress = false;
  List<TaskModel> _newtaskList = [];
  List<TaskStatusCountModel> _taskStatusCountList = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getNewTasksList();
      _getTaskStatusCountList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Visibility(
                visible: _getTasksStatusCountInProgress == false,
                replacement: CenteredCircularProgressIndicator(),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TaskCountSummaryCard(title: _taskStatusCountList[index].id, count: _taskStatusCountList[index].count);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(width: 10);
                  },
                  itemCount: _taskStatusCountList.length,
                ),
              ),
            ),
            Visibility(
              visible: _getNewTasksInProgress == false,
              replacement: CenteredCircularProgressIndicator(),
              child: Expanded(
                child: ListView.builder(
                  itemCount: _newtaskList.length,
                  // primary: false,
                  // shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return TaskCard(taskType: TaskType.tNew, taskModel: _newtaskList[index], onStatusUpdate: () {
                      _getNewTasksList();
                      _getTaskStatusCountList();
                    },);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskButton,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _getTaskStatusCountList() async {
    _getTasksStatusCountInProgress = true;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getTaskStatusCountURL,
    );

    if (response.isSuccess) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }
      _taskStatusCountList = list;
    } else {
      if(mounted) {
        showSnackBarMessage(context, response.errorMessage!);
      }
    }
    _getTasksStatusCountInProgress = false;
    if(mounted){
    setState(() {});}
  }


  Future<void> _getNewTasksList() async {
    _getNewTasksInProgress = true;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getNewTaskURL,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _newtaskList = list;
    } else {
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage!);
      }
    }
    _getNewTasksInProgress = false;
    if(mounted) {setState(() {});}
  }

  void _onTapAddNewTaskButton() {
    Navigator.pushNamed(context, AddNewTaskScreen.name);
  }
}


