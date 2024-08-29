import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done_today/datatypes/dt_message.dart';
import 'package:done_today/datatypes/dt_task.dart';
import 'package:done_today/reusable_ui/action_views.dart';
import 'package:done_today/reusable_ui/brand_colors.dart';
import 'package:done_today/reusable_ui/feedback_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskMessagingScreen extends StatefulWidget {
  Task task;

  TaskMessagingScreen({required this.task});
  @override
  _TaskMessagingScreenState createState() => _TaskMessagingScreenState();
}

class _TaskMessagingScreenState extends State<TaskMessagingScreen> {
  ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  int _maxLines = 1;
  bool helpExpanded = false;
  bool firstLoad = true;

  var dfm = DateFormat('M/d/yyyy h:mm a');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
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
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                    color: Colors.grey.shade100,
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(
                      0, MediaQuery.of(context).padding.top, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                        onExpansionChanged: (value) => setState(() {
                          helpExpanded = value;
                        }),
                        shape: const Border(),
                        trailing: helpExpanded
                            ? Icon(Icons.cancel)
                            : Icon(Icons.help_outline_rounded),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(15)),
                              child: ExpansionTile(
                                clipBehavior: Clip.antiAlias,
                                shape: const Border(),
                                title: Text(
                                  "How To Schedule",
                                  style: TextStyle(fontSize: 14),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      "Use the conversation below to arrange the date and time that works for both of you. Contact Done Today support if you're having an issue with scheduling.",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade800),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(15)),
                              child: ExpansionTile(
                                clipBehavior: Clip.antiAlias,
                                shape: const Border(),
                                title: Text(
                                  "After The Task",
                                  style: TextStyle(fontSize: 14),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      "After the task is completed, you'll have an opportunity to rate the experience to help us improve Done Today.",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade800),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.shade200,
                          ),
                          child: Material(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 15, 15, 15),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Meet John"),
                                            Text(
                                              "Student at UC Santa Cruz",
                                              style: TextStyle(
                                                  color: Colors.grey.shade700),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.shade200,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child: Row(
                              children: [
                                Text(
                                  "All Done?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    color: BrandColors().primary,
                                    borderRadius: BorderRadius.circular(7.5),
                                  ),
                                  child: Material(
                                    clipBehavior: Clip.antiAlias,
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        ActionViews().showPopupDrawer(
                                            context, FeedbackBottomSheet());
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 5, 5, 5),
                                        child: Text(
                                          "Mark Complete",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: FutureBuilder(
                        future: widget.task.getAllMessages(),
                        builder:
                            (context, AsyncSnapshot<List<Message>> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (firstLoad) {
                            firstLoad = false;
                            Timer(Duration(milliseconds: 400), () {
                              _scrollDown();
                            });
                          }
                          return ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        100),
                            itemCount: snapshot.data!.length + 1,
                            itemBuilder: (context, index) {
                              if (index == snapshot.data!.length) {
                                return SizedBox(height: 20);
                              }
                              Message message = snapshot.data![index];
                              widget.task.markMessageRead(message);
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
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border:
                        Border(top: BorderSide(color: Colors.grey.shade300))),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(
                    15, 7, 15, MediaQuery.of(context).padding.bottom + 7),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onTap: () {
                          Timer(Duration(milliseconds: 400), () {
                            _scrollDown();
                          });
                        },
                        controller: _textController,
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
                            .addMessage(_textController.text)
                            .then((onValue) {
                          setState(() {
                            _textController.clear();
                            _maxLines = 1;
                          });
                          Timer(Duration(milliseconds: 400), () {
                            _scrollDown();
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Spacer(),
              showDate
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(date, style: TextStyle(fontSize: 8)),
                    )
                  : Container(),
              Spacer()
            ],
          ),
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
