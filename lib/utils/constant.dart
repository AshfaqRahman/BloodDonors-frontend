import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") as String;
  return token;
}

Future<Map<String, String>> getHeaders() async {
  return {
    'access-control-allow-origin': '*',
    'content-type': 'application/json',
    'authorization': await getToken(),
  };
}

void deleteToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

class HttpSatusCode {
  static int CREATED = 201;
  static int OK = 200;
  static int NOT_FOUND = 404;
}
