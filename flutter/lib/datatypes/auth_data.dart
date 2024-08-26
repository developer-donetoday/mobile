import 'package:shared_preferences/shared_preferences.dart';

class AuthData {
  final String username;
  final String password;

  AuthData(this.username, this.password);

  static Future<AuthData?> getLocalAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userEmail = prefs.getString('userEmail');
    var userPassword = prefs.getString('userPassword');
    if (userEmail == null || userPassword == null) {
      return null;
    }
    print("User email: $userEmail, User password: $userPassword");
    return AuthData(userEmail, userPassword);
  }

  void save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', username);
    prefs.setString('userPassword', password);
    // Save the username and password to shared preferences
  }
}
