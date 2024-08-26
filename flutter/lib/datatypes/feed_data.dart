import 'package:done_today/datatypes/dt_task.dart';

class FeedData {
  final List<Task> myTasks;
  final List<Task> myFeed;

  FeedData({required this.myTasks, required this.myFeed});

  int get count => myTasks.length + myFeed.length;
}
