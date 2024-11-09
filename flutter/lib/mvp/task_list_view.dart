import 'dart:async';

import 'package:done_today/api_client.dart';
import 'package:done_today/datatypes/profile.dart';
import 'package:done_today/datatypes/task.dart';
import 'package:done_today/mvp/onboarding_view.dart';
import 'package:done_today/mvp/task_messaging_view.dart';
import 'package:done_today/reusables/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskListView extends StatefulWidget {
  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  TextEditingController _taskTextEditingController = TextEditingController();

  Profile? profile;
  bool _isPosting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        edgeOffset: 40,
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () {
            setState(() {});
          });
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
              child: FutureBuilder(
                  initialData: profile,
                  future: ApiClient().getProfile(null),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.hasData) {
                        profile = snapshot.data as Profile;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, ${profile!.name}",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600),
                            ),
                            userTaskListView()
                          ],
                        );
                      }
                    }
                    return Container();
                  }),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            //   child: Divider(
            //     height: 0,
            //     thickness: 1,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                  padding: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _isPosting
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: LinearProgressIndicator(),
                            )
                          : Container(),
                      Text(
                        "${_isPosting ? 'Posting' : 'New'} Task",
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          height: 0,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TextField(
                        controller: _taskTextEditingController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter a brief description of the task",
                        ),
                        onChanged: (value) {
                          if (value.contains("\n")) {
                            _taskTextEditingController.text =
                                value.replaceAll("\n", "");
                            FocusScope.of(context).unfocus();
                          }
                        },
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          height: 1,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircularButton(
                              label: "ADD",
                              onTap: () {
                                if (_taskTextEditingController
                                    .text.isNotEmpty) {
                                  setState(() {
                                    _isPosting = true;
                                  });
                                  ApiClient()
                                      .createTask(profile!,
                                          _taskTextEditingController.text)
                                      .then((value) {
                                    Timer(Duration(seconds: 1), () {
                                      setState(() {
                                        _taskTextEditingController.clear();
                                        _isPosting = false;
                                      });
                                    });
                                  });
                                }
                              },
                              backgroundColor: Colors.greenAccent.shade700,
                              foregroundColor: Colors.white)
                        ],
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircularButton(
                      label: "SIGN OUT",
                      onTap: () {
                        ApiClient().signOut();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => OnboardingView()));
                      },
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget userTaskListView() {
    // if (profile == null) {
    //   return Container();
    // }
    return FutureBuilder(
        future: ApiClient().getTasks(profile!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Task> tasks = snapshot.data as List<Task>;
            if (tasks.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your\nTasks (0)",
                    style: GoogleFonts.montserrat(
                        height: .9, fontWeight: FontWeight.w800, fontSize: 36),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20.0),
                  //   child: Container(
                  //     height: 100,
                  //     child: Center(
                  //       child: Text(
                  //         "When you have tasks, they will appear here",
                  //         style: GoogleFonts.roboto(
                  //           fontSize: 12,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your\nTasks (${tasks.length})",
                  style: GoogleFonts.montserrat(
                      height: .9, fontWeight: FontWeight.w800, fontSize: 36),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: (tasks.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Container(
                          child: Column(children: [
                        Container(
                            clipBehavior: Clip.hardEdge,
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                              // color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          TaskMessagingView(e)));
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(e.task),
                                            ]),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      FutureBuilder(
                                        future: e.getMessageCount(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade400,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                snapshot.data.toString(),
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white),
                                              ),
                                            );
                                          }
                                          return Container();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ])),
                    );
                  }).toList()),
                ),
              ],
            );
          }
          return Container();
        });
  }
}
