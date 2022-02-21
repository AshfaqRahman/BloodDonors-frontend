import 'package:flutter_dotenv/flutter_dotenv.dart';

// https://developer.school/tutorials/how-to-use-environment-variables-with-flutter-dotenv
class Environment {
  static String get apiUrl {
    return dotenv.env['API_URL'] ?? "http://localhost:8080/api/";
  }

  static String get SOCKET_URL {
    return dotenv.env['SOCKET_URL'] ?? "no";
  }
}
