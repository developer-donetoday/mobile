import 'package:done_today/datatypes/profile.dart';
import 'package:done_today/datatypes/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }

  Map<String, Profile> _cachedProfiles = {};

  ApiClient._internal();

  String getUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> saveProfile(Profile profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile', profile.documentId);
  }

  Future<String?> getProfileId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile')!;
  }

  void signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile');
  }

  Future<Profile?> getProfile(String? profileId) async {
    profileId ??= await getProfileId();

    // if (_cachedProfiles.containsKey(profileId)) {
    //   return _cachedProfiles[profileId];
    // }

    if (profileId != null) {
      var profileDocument = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(profileId)
          .get();
      _cachedProfiles[profileId] =
          Profile(profileDocument.id, profileDocument.data()!);
      return _cachedProfiles[profileId];
    } else {
      return null;
    }
  }

  Future<Profile?> useCode(code) async {
    var codeDocument = await FirebaseFirestore.instance
        .collection('codes')
        .where('code', isEqualTo: code)
        .get();
    if (codeDocument.docs.isNotEmpty) {
      var codeData = codeDocument.docs.first.data();
      var profileDocument = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(codeData["profile"])
          .get();
      return Profile(profileDocument.id, profileDocument.data()!);
    } else {
      print('Code not found');
      return null;
    }
  }

  Future createTask(Profile profile, String task) async {
    await FirebaseFirestore.instance.collection('tasks').add({
      'author': profile.documentId,
      'student': null,
      'task': task,
      'completed': false,
      'created': FieldValue.serverTimestamp(),
      'updated': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Task>> getTasks(Profile profile) async {
    var taskDocuments = await FirebaseFirestore.instance
        .collection('tasks')
        .where('author', isEqualTo: profile.documentId)
        .where('completed', isEqualTo: false)
        .get();
    return taskDocuments.docs
        .map((taskDocument) => Task(taskDocument.id, taskDocument.data()))
        .toList();
  }
}
