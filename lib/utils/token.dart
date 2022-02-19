import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthToken{
  static Future<String> parseUserName() async {
    String token = await getToken();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken['name'] ?? "";
  }

  static Future<String> parseUserId() async{
    String token = await getToken();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken['id'] ?? "";
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") as String;
    return token;
  }

  static Future<Map<String, String>> getHeaders() async {
    return {
      'access-control-allow-origin': '*',
      'content-type': 'application/json',
      'authorization': await getToken(),
    };
  }

  static void deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}