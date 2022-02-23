import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mma');

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

  /// Construct a color from a hex code string, of the format #RRGGBB.
  static Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
  }
}

class HttpSatusCode {
  static int CREATED = 201;
  static int OK = 200;
  static int NOT_FOUND = 404;
  static int DELETED = 202;
}
