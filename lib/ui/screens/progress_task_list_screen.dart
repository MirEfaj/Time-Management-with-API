import 'package:flutter/material.dart';
import 'package:time_management/ui/widgets/centered_circular_progress_indicator.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils.dart';
import '../widgets/snack_bar_msg.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_summary_card.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  bool _getProgressTasksInProgress = false;
  List<TaskModel> _progresstaskList = [];
  @override
  void initState() {
    _getProgressTasksList();
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Visibility(
            visible: _getProgressTasksInProgress == false,
            replacement: CenteredCircularProgressIndicator(),
            child: Expanded(
              child: ListView.builder(
                itemCount: _progresstaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(taskType: TaskType.progress, taskModel: _progresstaskList[index], onStatusUpdate: () {_getProgressTasksList();  },);
                },
              ),
            ),
          ),
        ],
      ),

    );
  }
  Future<void> _getProgressTasksList() async {
    _getProgressTasksInProgress = true;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getProgressTaskURL,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _progresstaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getProgressTasksInProgress = false;
    setState(() {});
  }

}


