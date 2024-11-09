import 'dart:async';

import 'package:done_today/datatypes/task.dart';
import 'package:done_today/mvp/full_screen_processing_view.dart';
import 'package:done_today/mvp/task_list_view.dart';
import 'package:done_today/mvp/utils.dart';
import 'package:done_today/reusables/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskMessagingView extends StatefulWidget {
  Task task;

  TaskMessagingView(this.task);

  @override
  _TaskMessagingViewState createState() => _TaskMessagingViewState();
}

class _TaskMessagingViewState extends State<TaskMessagingView> {
  TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "\"" + widget.task.task + "\"",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              height: 0.9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          FutureBuilder(
                              future: widget.task.getAuthorWidget(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return snapshot.data!;
                                } else {
                                  return Container();
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      children: [
                        CircularButton(
                          label: "MESSAGES",
                          onTap: () {},
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CircularButton(
                            label: "COMPLETE",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      FullScreenProcessingView(process: () {
                                        widget.task.markComplete();
                                        Timer(Duration(seconds: 2), () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      TaskListView()),
                                              (route) => false);
                                        });
                                      })));
                            },
                            backgroundColor: Colors.greenAccent.shade700,
                            foregroundColor: Colors.white)
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
                  FutureBuilder(
                    initialData: widget.task.messages,
                    future: widget.task.getMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        widget.task.messages = snapshot.data as List<Message>;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.task.messages.map<Widget>((message) {
                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        message.author == widget.task.author
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          message.message,
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  FutureBuilder(
                                    future: message.getAuthorWidget(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return snapshot.data!;
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    height: 0,
                                    color: Colors.grey.shade300,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                height: 0,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.grey.shade200),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        onChanged: (value) {
                          if (value.contains("\n")) {
                            _messageController.text =
                                value.replaceAll("\n", "");
                            FocusScope.of(context).unfocus();
                          }
                        },
                        style: GoogleFonts.roboto(fontSize: 16),
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message',
                        ),
                      ),
                    ),
                    CircularButton(
                        label: "SEND",
                        onTap: () async {
                          if (_messageController.text.isEmpty) return;
                          await widget.task.addMessage(_messageController.text);
                          setState(() {
                            _messageController.clear();
                          });
                        },
                        backgroundColor: Colors.greenAccent.shade700,
                        foregroundColor: Colors.white)
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
