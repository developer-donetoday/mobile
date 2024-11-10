import 'package:done_today/api_client.dart';
import 'package:done_today/datatypes/auth_code.dart';
import 'package:done_today/datatypes/profile.dart';
import 'package:done_today/mvp/create_profile_view.dart';
import 'package:done_today/mvp/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllProfilesView extends StatefulWidget {
  @override
  _AllProfilesViewState createState() => _AllProfilesViewState();
}

class _AllProfilesViewState extends State<AllProfilesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Profiles",
          style: GoogleFonts.montserrat(
              height: .9, fontWeight: FontWeight.w800, fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateProfileView()));
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: ApiClient().getProfiles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("An error occurred"),
              );
            }
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Profile profile = snapshot.data![index];
                return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UpdateProfileView(profile: profile)));
                    },
                    title: Text(profile.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.email,
                          style: TextStyle(fontSize: 12),
                        ),
                        Text("Is Admin: ${profile.isAdmin}",
                            style: TextStyle(fontSize: 12)),
                        FutureBuilder(
                            future: ApiClient().getCode(profile.documentId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data is AuthCode) {
                                return Text(
                                  "Authentication Code: ${snapshot.data!.code}",
                                  style: TextStyle(fontSize: 12),
                                );
                              }
                              return Container();
                            }),
                      ],
                    ));
              },
            );
          },
        ),
      ),
    );
  }
}
