import 'dart:async';
import 'dart:ffi';

import 'package:done_today/api_client.dart';
import 'package:done_today/datatypes/dt_task.dart';
import 'package:done_today/datatypes/feed_data.dart';
import 'package:done_today/onboarding_screen.dart';
import 'package:done_today/reusable_ui/action_views.dart';
import 'package:done_today/reusable_ui/brand_colors.dart';
import 'package:done_today/reusable_ui/circular_button.dart';
import 'package:done_today/reusable_ui/feed_card.dart';
import 'package:done_today/reusable_ui/new_post_bottom_sheet.dart';
import 'package:done_today/reusable_ui/rectangle_button.dart';
import 'package:done_today/task_progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HomeFeedScreen extends StatefulWidget {
  @override
  _HomeFeedScreenState createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  Future<FeedData>? _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = ApiClient().getTasks();
  }

  Future<void> _refreshData() async {
    setState(() {
      _tasksFuture = ApiClient().getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          FutureBuilder(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: () {
                      return _refreshData();
                    },
                    child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: EdgeInsets.only(top: 20.0, bottom: 0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            ApiClient().logout();
                                            Navigator.pushAndRemoveUntil<
                                                dynamic>(
                                              context,
                                              MaterialPageRoute<dynamic>(
                                                builder:
                                                    (BuildContext context) =>
                                                        OnboardingScreen(),
                                              ),
                                              (route) =>
                                                  false, //if you want to disable back feature set to false
                                            );
                                          },
                                          child: Text("Logout")),
                                    ],
                                  ),
                                  Icon(
                                    Icons.eco,
                                    size: 70,
                                    color: BrandColors().primary,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                          width: 100,
                                          image: AssetImage(
                                              "lib/assets/done_today_title.png"))
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.greenAccent.shade100,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          "Done Today is still in development. Please be patient as we work to bring you the best experience possible.",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  Colors.greenAccent.shade700),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (index == 1) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: snapshot.data!.myTasks.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15.0, 0, 15, 15),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Your Tasks",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        TextButton(
                                            onPressed: () {
                                              ActionViews().showPopupDrawer(
                                                  context,
                                                  NewPostBottomSheet());
                                            },
                                            child: Text(
                                              "New",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade800),
                                            ))
                                      ],
                                    ),
                                  );
                                }
                                var task = snapshot.data!.myTasks[index - 1];
                                return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 0, 15, 15),
                                    child: Ink(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.15),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            )
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TaskMessagingScreen(
                                                        task: task,
                                                      )),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: FeedCard(task: task),
                                          ),
                                        )));
                              },
                            );
                          }
                          if (index == 2) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: snapshot.data!.myFeed.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15.0, 0, 15, 15),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Happening Nearby",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        TextButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Feature not yet implemented")),
                                              );
                                            },
                                            child: Text(
                                              "Map",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade800),
                                            ))
                                      ],
                                    ),
                                  );
                                }
                                var task = snapshot.data!.myFeed[index - 1];
                                return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 0, 15, 15),
                                    child: Ink(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.15),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            )
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onTap: () {
                                            // ActionViews()
                                            //     .showPopupDrawer(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: FeedCard(task: task),
                                          ),
                                        )));
                              },
                            );
                          }
                        }),
                  );
                } else {
                  print("loading");
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
        ],
      ),
    );
  }
}
