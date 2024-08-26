import 'package:done_today/authentication_screen.dart';
import 'package:done_today/datatypes/auth_data.dart';
import 'package:done_today/feed_screen.dart';
import 'package:done_today/neighborhood_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (FirebaseAuth.instance.currentUser != null) {
        return;
      }
      AuthData.getLocalAuth().then((authData) {
        print(authData);
        if (authData != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeFeedScreen()),
          );
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Done Today'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthenticationScreen(
                            isLogin: true,
                          )),
                );
                // Add navigation or functionality for Get Started button
              },
              child: const Text('Returning User?'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthenticationScreen(
                            isLogin: false,
                          )),
                );
                // Add navigation or functionality for Neighbor button
              },
              child: const Text('Neighbor'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AuthenticationScreen(isLogin: false)),
                );
                // Add navigation or functionality for Student button
              },
              child: const Text('Student'),
            ),
          ],
        ),
      ),
    );
  }
}
