import 'package:flutter/material.dart';
import 'package:time_management/ui/widgets/centered_circular_progress_indicator.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils.dart';
import '../widgets/snack_bar_msg.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_summary_card.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  bool _getCompletedTasksInProgress = false;
  List<TaskModel> _completedTaskList = [];
  @override
  void initState() {
    _getCompletedTasksList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Visibility(
            visible: _getCompletedTasksInProgress == false,
            replacement: CenteredCircularProgressIndicator(),
            child: Expanded(
              child: ListView.builder(
                itemCount: _completedTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(taskType: TaskType.completed, taskModel: _completedTaskList[index], onStatusUpdate: () {_getCompletedTasksList();  },);
                },
              ),
            ),
          ),
        ],
      ),

    );
  }
  Future<void> _getCompletedTasksList() async {
    _getCompletedTasksInProgress = true;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getCompletedTaskURL,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getCompletedTasksInProgress = false;
    setState(() {});
  }
}


