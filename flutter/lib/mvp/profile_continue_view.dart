import 'package:done_today/api_client.dart';
import 'package:done_today/datatypes/profile.dart';
import 'package:done_today/mvp/task_list_view.dart';
import 'package:done_today/reusables/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileContinueView extends StatelessWidget {
  final Profile profile;

  ProfileContinueView({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👋',
              style: GoogleFonts.anton(
                fontSize: 36,
              ),
            ),
            Text(
              "Hi, ${profile.name}",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w900,
                fontSize: 36,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                "Thanks for being a part of your community. Set up an authentication method to get your work done today.",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 100,
        child: Row(
          children: [
            CircularButton(
                label: "BACK",
                onTap: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.grey.shade600,
                foregroundColor: Colors.white),
            Spacer(),
            CircularButton(
                label: "CONTINUE",
                onTap: () {
                  Navigator.pop(context);
                  ApiClient().saveProfile(profile);
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(builder: (context) => TaskListView()),
                      )
                      .then((_) {});
                },
                backgroundColor: Colors.black,
                foregroundColor: Colors.white)
          ],
        ),
      )),
    );
  }
}
