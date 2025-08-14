import 'package:flutter/material.dart';
import 'package:time_management/ui/widgets/centered_circular_progress_indicator.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils.dart';
import '../widgets/snack_bar_msg.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_summary_card.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {

  bool _getCancelledTasksInProgress = false;
  List<TaskModel> _cancelledTaskList = [];
  @override
  void initState() {
    _getCancelledTasksList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Visibility(
            visible: _getCancelledTasksInProgress == false,
            replacement: CenteredCircularProgressIndicator(),
            child: Expanded(
              child: ListView.builder(
                itemCount: _cancelledTaskList.length,            
                itemBuilder: (context, index) {
                  return TaskCard(taskType: TaskType.cancelled, taskModel: _cancelledTaskList[index], onStatusUpdate: () {
                    _getCancelledTasksList();
                  },);
                },
              ),
            ),
          ),
        ],
      ),

    );
  }

  Future<void> _getCancelledTasksList() async {
    _getCancelledTasksInProgress = true;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getCancelledTaskURL,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getCancelledTasksInProgress = false;
    setState(() {});
  }

}


