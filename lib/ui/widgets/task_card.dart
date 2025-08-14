import 'package:flutter/material.dart';
import 'package:time_management/data/models/task_model.dart';
import 'package:time_management/data/service/network_caller.dart';
import 'package:time_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:time_management/ui/widgets/snack_bar_msg.dart';

import '../../data/utils.dart';

enum TaskType { tNew, progress, completed, cancelled }

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskType,
    required this.taskModel,
    required this.onStatusUpdate,
  });

  final TaskType taskType;
  final TaskModel taskModel;
  final VoidCallback onStatusUpdate;

  @override
  State<TaskCard> createState() => _TaskCardState();

  /// Get chip color based on task type
  static Color _getTaskChipColor(TaskType type) {
    switch (type) {
      case TaskType.tNew:
        return Colors.blue;
      case TaskType.progress:
        return Colors.purple;
      case TaskType.completed:
        return Colors.teal;
      case TaskType.cancelled:
        return Colors.redAccent;
    }
  }

  /// Get chip label based on task type
  // static String _getTaskLabel(TaskType type) {
  //   switch (type) {
  //     case TaskType.tNew:
  //       return 'New';
  //     case TaskType.progress:
  //       return 'Progress';
  //     case TaskType.completed:
  //       return 'Completed';
  //     case TaskType.cancelled:
  //       return 'Cancelled';
  //   }
  // }
}

class _TaskCardState extends State<TaskCard> {
  bool _updateTaskStatusInProgress = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              widget.taskModel.description,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(widget.taskModel.createdDate),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(
                    widget.taskModel.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: TaskCard._getTaskChipColor(widget.taskType),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Visibility(
                      visible: _updateTaskStatusInProgress == false,
                      replacement: CenteredCircularProgressIndicator(),
                      child: IconButton(
                        onPressed: () {
                          _showEditTaskStatusDialog();
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTaskStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Change Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("New"),
                trailing: _getTaskStatusTrilling(TaskType.tNew),
                onTap: () {
                  if (widget.taskType == TaskType.tNew) {
                    return;
                  }
                  _upgreadTaskStatus("New");
                },
              ),
              ListTile(
                title: Text("Progress"),
                trailing: _getTaskStatusTrilling(TaskType.progress),
                onTap: () {
                  if (widget.taskType == TaskType.progress) {
                    return;
                  }
                  _upgreadTaskStatus("Progress");
                },
              ),
              ListTile(
                title: Text("Completed"),
                trailing: _getTaskStatusTrilling(TaskType.completed),
                onTap: () {
                  if (widget.taskType == TaskType.progress) {
                    return;
                  }
                  _upgreadTaskStatus("Completed");
                },
              ),
              ListTile(
                title: Text("Canceled"),
                trailing: _getTaskStatusTrilling(TaskType.cancelled),
                onTap: () {
                  if (widget.taskType == TaskType.progress) {
                    return;
                  }
                  _upgreadTaskStatus("Canceled");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Icon? _getTaskStatusTrilling(TaskType type) {
    return widget.taskType == type ? Icon(Icons.check) : null;
  }

  Future<void> _upgreadTaskStatus(String status) async {
    _updateTaskStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatusByURL(widget.taskModel.id, status),
    );
    _updateTaskStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      widget.onStatusUpdate();
    } else {
      if(mounted){
        showSnackBarMessage(context, response.errorMessage!);
      }
    }
  }
}
