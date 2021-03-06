import 'package:flutter_dotenv/flutter_dotenv.dart';

// https://developer.school/tutorials/how-to-use-environment-variables-with-flutter-dotenv
class Environment {
  static const bool debug = true;
  static String get apiUrl {
    return debug ? dotenv.env['API_URL']! : dotenv.env['API_URL_REMOTE']!;
  }

  static String get SOCKET_URL {
    return debug ? dotenv.env['SOCKET_URL']! : dotenv.env['SOCKET_URL_REMOTE']!;
  }
}
