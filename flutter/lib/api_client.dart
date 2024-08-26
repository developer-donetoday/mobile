import 'package:done_today/datatypes/auth_data.dart';
import 'package:done_today/datatypes/dt_task.dart';
import 'package:done_today/datatypes/feed_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal();

  String getUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<bool> loginWithEmailPassword(AuthData authData) async {
    try {
      await Firebase.initializeApp();
      final auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
          email: authData.username, password: authData.password);
      print('Login successful');
      authData.save();
      return true;
    } catch (e) {
      print('Login failed: $e');
      return false;
    }
  }

  Future<bool> registerWithEmailPassword(AuthData authData) async {
    try {
      await Firebase.initializeApp();
      final auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
          email: authData.username, password: authData.password);
      print('Registration successful');
      authData.save();
      return true;
    } catch (e) {
      print('Registration failed: $e');
      return false;
    }
  }

  Future<bool> createTask(String taskDescription, String privacySetting) async {
    try {
      final task = {
        'description': taskDescription,
        'author': FirebaseAuth.instance.currentUser!.uid,
        "privacy_setting": privacySetting,
        "completed": false,
        "tasker": null,
        "completed_at": null,
        "last_updated": FieldValue.serverTimestamp(),
        'created': FieldValue.serverTimestamp(),
      };
      await FirebaseFirestore.instance.collection('tasks').add(task);
      return true;
    } catch (e) {
      print('Failed to create task: $e');
      return false;
    }
  }

  Future<FeedData> getTasks() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('tasks').get();
      var allTasks = snapshot.docs.map((e) => Task.fromFirestore(e)).toList();
      List<Task> myTasks = [];
      List<Task> myFeed = [];
      for (var task in allTasks) {
        if (task.author == FirebaseAuth.instance.currentUser!.uid) {
          myTasks.add(task);
        } else {
          myFeed.add(task);
        }
      }
      return FeedData(myTasks: myTasks, myFeed: myFeed);
    } catch (e) {
      print('Failed to get tasks: $e');
      return FeedData(myTasks: [], myFeed: []);
    }
  }
}
