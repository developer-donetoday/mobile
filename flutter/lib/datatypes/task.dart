import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done_today/api_client.dart';
import 'package:done_today/mvp/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Message {
  String documentId;
  Map<String, dynamic> data;

  Message(this.documentId, this.data);

  String get author => data['author'];
  String get message => data['message'];
  Timestamp? get created => data['created'];

  Future<Widget> getAuthorWidget() async {
    var profile = await ApiClient().getProfile(data['author']);
    return Material(
      child: InkWell(
        onTap: () => {},
        child: Row(
          children: [
            Text(
              profile!.displayName(),
              style:
                  GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              DateTimeFormatter.formatWithTime(
                  created != null ? created!.toDate() : DateTime.now()),
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  String documentId;
  Map<String, dynamic> data;

  Task(this.documentId, this.data);

  String get author => data['author'];
  String get student => data['student'];
  String get task => data['task'];
  bool get completed => data['completed'];
  Timestamp get created => data['created'];
  Timestamp get updated => data['updated'];

  List<Message> messages = [];

  Future<List<Message>> getMessages() async {
    var messageDocuments = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(documentId)
        .collection('messages')
        .orderBy('created', descending: false)
        .get();
    return messageDocuments.docs
        .map((messageDocument) =>
            Message(messageDocument.id, messageDocument.data()))
        .toList();
  }

  Future<void> addMessage(String message) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(documentId)
        .collection('messages')
        .add({
      'author': await ApiClient().getProfileId(),
      'message': message,
      'created': FieldValue.serverTimestamp(),
    });
  }

  Future<int> getMessageCount() async {
    var messageDocuments = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(documentId)
        .collection('messages')
        .get();
    return messageDocuments.docs.length;
  }

  Future<void> markComplete() async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(documentId)
        .update({
      'completed': true,
      'updated': FieldValue.serverTimestamp(),
    });
  }

  Future<Widget> getAuthorWidget() async {
    var profile = await ApiClient().getProfile(author);
    return Row(
      children: [
        Text(
          profile!.name,
          style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          DateTimeFormatter.formatWithTime(created.toDate()),
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w300,
              fontSize: 12,
              color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
