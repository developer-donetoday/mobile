import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done_today/datatypes/dt_message.dart';
import 'package:done_today/datatypes/dt_task.dart';
import 'package:done_today/reusable_ui/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskMessagingScreen extends StatefulWidget {
  Task task;

  TaskMessagingScreen({required this.task});
  @override
  _TaskMessagingScreenState createState() => _TaskMessagingScreenState();
}

class _TaskMessagingScreenState extends State<TaskMessagingScreen> {
  final TextEditingController _controller = TextEditingController();
  int _maxLines = 1;

  var dfm = DateFormat('M/d/yyyy h:mm a');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(
                      15, MediaQuery.of(context).padding.top, 15, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.arrow_back)),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Arrange the date and time that works for both of you, then mark the task complete from this screen. You'll have an opportunity to rate the experience after the task is completed to help us improve Done Today.",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: FutureBuilder(
                        future: widget.task.getAllMessages(),
                        builder:
                            (context, AsyncSnapshot<List<Message>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Message message = snapshot.data![index];
                              message.markRead();
                              return ChatBubble(
                                previousDate: index > 0
                                    ? snapshot.data![index - 1].created
                                    : null,
                                currentDate: message.created,
                                message: message.message,
                                isMe: message.isAuthor,
                                date: dfm.format(message.created),
                              );
                            },
                          );
                        }))
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(color: Colors.grey.shade200),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(
                    15, 7, 15, MediaQuery.of(context).padding.bottom + 7),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLines: _maxLines,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        // Send button logic
                        widget.task
                            .addMessage(_controller.text)
                            .then((onValue) {
                          setState(() {
                            _controller.clear();
                            _maxLines = 1;
                          });
                        });
                      },
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class ChatBubble extends StatelessWidget {
  final DateTime? previousDate;
  final DateTime currentDate;
  final String message;
  final String date;
  final bool isMe;

  const ChatBubble({
    required this.previousDate,
    required this.currentDate,
    required this.message,
    required this.isMe,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    bool showDate = true;
    if (previousDate != null) {
      if (previousDate!.day != currentDate.day) {
        showDate = true;
      } else {
        showDate = currentDate.difference(previousDate!).inMinutes > 15;
      }
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          showDate ? Text(date, style: TextStyle(fontSize: 12)) : Container(),
          Container(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
              decoration: BoxDecoration(
                color: isMe ? Colors.grey.shade200 : BrandColors().primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.grey.shade900 : Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
