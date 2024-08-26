import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done_today/api_client.dart';
import 'package:done_today/datatypes/dt_task.dart';
import 'package:done_today/reusable_ui/task_progress_bar.dart';
import 'package:done_today/reusable_ui/unread_counter_view.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatefulWidget {
  final Task task;

  const FeedCard({Key? key, required this.task}) : super(key: key);

  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.task.isAuthor
            ? Container()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.task.author),
                        Text(
                          widget.task.created.toString(),
                          style: TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  )
                ],
              ),
        Padding(
          padding: EdgeInsets.only(top: widget.task.isAuthor ? 0 : 5),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.description,
                      style: TextStyle(fontSize: 14),
                    ),
                    widget.task.isAuthor
                        ? Text(
                            widget.task.status,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade700),
                          )
                        : Container(),
                  ],
                ),
              ),
              widget.task.isAuthor
                  ? StreamBuilder(
                      stream: widget.task.reference
                          .collection('messages')
                          .where("author",
                              isNotEqualTo: ApiClient().getUserId())
                          .where("read", isEqualTo: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return UnreadCounterView(
                              count: snapshot.data!.docs.length);
                        }
                        return UnreadCounterView(count: -1);
                      })
                  : Container()
            ],
          ),
        ),
        widget.task.isAuthor
            ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: TaskProgressBar(progress: widget.task.progress),
              )
            : Container()
      ],
    );
  }
}
