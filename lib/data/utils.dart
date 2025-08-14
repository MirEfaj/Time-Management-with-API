class Urls{
  static const String _baseUrl = "http://35.73.30.144:2005/api/v1";

  static const String registrationURL ="$_baseUrl/Registration";
  static const String loginURL ="$_baseUrl/Login";
  static const String createNewTaskURL ="$_baseUrl/createTask";
  static const String getNewTaskURL ="$_baseUrl/listTaskByStatus/New";
  static const String getProgressTaskURL ="$_baseUrl/listTaskByStatus/Progress";
  static const String getCancelledTaskURL ="$_baseUrl/listTaskByStatus/Cancelled";
  static const String getCompletedTaskURL ="$_baseUrl/listTaskByStatus/Completed";
  static const String getTaskStatusCountURL ="$_baseUrl/taskStatusCount";
  static const String updateProfileURL ="$_baseUrl/ProfileUpdate";
  static  String updateTaskStatusByURL(String taskId, String status)  =>
      "$_baseUrl/updateTaskStatus/$taskId/$status";
}