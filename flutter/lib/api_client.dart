import 'package:done_today/datatypes/auth_code.dart';
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

    if (_cachedProfiles.containsKey(profileId)) {
      return _cachedProfiles[profileId];
    }

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
      ApiClient()
          .saveProfile(Profile(profileDocument.id, profileDocument.data()!));
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
    if (profile.isAdmin) {
      var taskDocuments = await FirebaseFirestore.instance
          .collection('tasks')
          .where('completed', isEqualTo: false)
          .get();
      return taskDocuments.docs
          .map((taskDocument) => Task(taskDocument.id, taskDocument.data()))
          .toList();
    }
    var taskDocuments = await FirebaseFirestore.instance
        .collection('tasks')
        .where('author', isEqualTo: profile.documentId)
        .where('completed', isEqualTo: false)
        .get();
    return taskDocuments.docs
        .map((taskDocument) => Task(taskDocument.id, taskDocument.data()))
        .toList();
  }

  Future<List<Profile>> getProfiles() async {
    var profileDocuments =
        await FirebaseFirestore.instance.collection('profiles').get();
    return profileDocuments.docs
        .map((profileDocument) =>
            Profile(profileDocument.id, profileDocument.data()))
        .toList();
  }

  Future<AuthCode?> getCode(String profileId) async {
    var codeDocument = await FirebaseFirestore.instance
        .collection('codes')
        .where('profile', isEqualTo: profileId)
        .get();
    if (codeDocument.docs.isEmpty) {
      return null;
    }
    return AuthCode(codeDocument.docs.first.id, codeDocument.docs.first.data());
  }

  Future<void> createProfile(
    String name,
    String email,
    String phoneNumber, {
    bool isAdmin = false,
  }) async {
    var newDocument =
        await FirebaseFirestore.instance.collection('profiles').add({
      'name': name,
      'email': email,
      'phone': phoneNumber,
      'is_admin': isAdmin,
    });
    await FirebaseFirestore.instance.collection('codes').add({
      'profile': newDocument.id,
      "is_used": false,
      'code': (1000 +
              (9999 - 1000) *
                  (new DateTime.now().millisecondsSinceEpoch % 10000) ~/
                  10000)
          .toString()
    });
  }

  Future<void> updateProfile(
    Profile profile,
    String name,
    String email,
    String phoneNumber, {
    bool isAdmin = false,
  }) async {
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(profile.documentId)
        .update({
      'name': name,
      'email': email,
      'phone': phoneNumber,
      'is_admin': isAdmin,
    });
  }
}
