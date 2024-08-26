import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done_today/datatypes/dt_message.dart';
import 'package:done_today/reusable_ui/task_progress_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Task {
  late Map<String, dynamic> data;
  late String id;

  Task.fromFirestore(QueryDocumentSnapshot document) {
    id = document.id;
    data = document.data() as Map<String, dynamic>;
  }

  String get description {
    return data["description"] ?? "N/A";
  }

  String get status {
    if (data["tasker"] == null) {
      return "Waiting for a student to accept this task for you";
    }
    return "Task accepted by ${data["tasker"]}";
  }

  TaskProgress get progress {
    if (completed) {
      return TaskProgress.Completed;
    }
    if (tasker != null) {
      return TaskProgress.InProgress;
    }
    return TaskProgress.Pending;
  }

  String get author {
    return data["author"] ?? "N/A";
  }

  bool get isAuthor {
    return data["author"] == FirebaseAuth.instance.currentUser!.uid;
  }

  String get privacySetting {
    return data["privacy_setting"] ?? "N/A";
  }

  bool get completed {
    return data["completed"] ?? false;
  }

  String? get tasker {
    return data["tasker"];
  }

  DateTime? get completedAt {
    return data["completed_at"] != null
        ? (data["completed_at"] as Timestamp).toDate()
        : null;
  }

  DateTime get lastUpdated {
    return data["last_updated"] != null
        ? (data["last_updated"] as Timestamp).toDate()
        : DateTime.now();
  }

  DateTime get created {
    return data["created"] != null
        ? (data["created"] as Timestamp).toDate()
        : DateTime.now();
  }

  DocumentReference get reference {
    return FirebaseFirestore.instance.collection('tasks').doc(id);
  }

  Future<List<Message>> getAllMessages() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(id)
        .collection('messages')
        .orderBy("created", descending: false)
        .get();
    return snapshot.docs.map((e) => Message.fromFirestore(e)).toList();
  }

  Future<void> addMessage(String message) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(id)
        .collection('messages')
        .add({
      "message": message,
      "author": FirebaseAuth.instance.currentUser!.uid,
      "created": FieldValue.serverTimestamp(),
      "read": false
    });
  }
}
