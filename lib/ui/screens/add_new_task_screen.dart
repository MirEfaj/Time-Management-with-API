import 'package:flutter/material.dart';
import 'package:time_management/data/service/network_caller.dart';
import 'package:time_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:time_management/ui/widgets/screen_background.dart';
import 'package:time_management/ui/widgets/snack_bar_msg.dart';
import 'package:time_management/ui/widgets/tm_app_bar.dart';

import '../../data/utils.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});
  static const String name = "/add-new-task";

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:tmAppBar(),
      body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(height: 50,),
                  Text("Add New Task", style: Theme.of(context).textTheme.titleLarge,),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "Title"
                    ),
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return "Enter Your Title";
                      }
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText: "Description",
                    ),
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return "Enter Your Descsription";
                      }
                    },
                  ),
                  const SizedBox(height: 20,),
                  Visibility(
                    visible: addNewTaskInProgress == false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ElevatedButton.icon(onPressed: _addNewTask,
                      icon: Icon(Icons.add_comment_outlined),
                      label: Text("Add Task"),
                                     ),
                  )
                ],
              ),
            ),
          )),
    );
  }
  void _addNewTask(){
    if(_formKey.currentState!.validate()){
      _addCreateTask();
    }
  }

  Future<void> _addCreateTask() async{
    addNewTaskInProgress = true;
    setState(() { });
    Map<String, String> responseBody = {
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "status":"New"
    };
    NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.createNewTaskURL,
        body: responseBody
    );
    addNewTaskInProgress = false;
    setState(() { });
    if(response.isSuccess){
      _titleController.clear();
      _descriptionController.clear();
      showSnackBarMessage(context, "Added New Task");
    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }




  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
