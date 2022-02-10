import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") as String;
  return token;
}

void deleteToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}
