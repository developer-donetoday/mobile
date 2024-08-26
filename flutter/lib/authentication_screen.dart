import 'package:done_today/api_client.dart';
import 'package:done_today/datatypes/auth_data.dart';
import 'package:done_today/feed_screen.dart';
import 'package:done_today/neighborhood_screen.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatefulWidget {
  final bool isLogin;

  const AuthenticationScreen({Key? key, required this.isLogin})
      : super(key: key);
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.isLogin) {
                  ApiClient()
                      .loginWithEmailPassword(AuthData(
                          this._usernameController.text,
                          this._passwordController.text))
                      .then((value) {
                    if (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeFeedScreen()),
                      );
                    }
                  });
                } else {
                  ApiClient()
                      .registerWithEmailPassword(AuthData(
                          this._usernameController.text,
                          this._passwordController.text))
                      .then((value) {
                    if (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeFeedScreen()),
                      );
                    }
                  });
                }
                // Handle login logic here, using _usernameController.text and _passwordController.text
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
