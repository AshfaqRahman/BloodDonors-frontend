import 'package:shared_preferences/shared_preferences.dart';

class AuthUtil {
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token") as String?;
    return token;
  }

  static void logout() async {
    deleteToken();
  }

  static void deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
