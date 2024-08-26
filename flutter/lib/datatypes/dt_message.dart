import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Message {
  late String id;
  late Map<String, dynamic> data;

  Message.fromFirestore(QueryDocumentSnapshot document) {
    id = document.id;
    data = document.data() as Map<String, dynamic>;
  }

  String get message {
    return data["message"] ?? "N/A";
  }

  String get author {
    return data["author"] ?? "N/A";
  }

  DateTime get created {
    return (data["created"] as Timestamp).toDate();
  }

  bool get isAuthor {
    return data["author"] == FirebaseAuth.instance.currentUser!.uid;
  }

  bool get read {
    return data["read"] ?? false;
  }

  Future<void> markRead() async {
    if (!isAuthor && !data["read"]) {
      await FirebaseFirestore.instance
          .collection("messages")
          .doc(id)
          .update({"read": true});
    }
  }
}
