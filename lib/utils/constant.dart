import 'package:bms_project/utils/debug.dart';
import 'package:bms_project/utils/socket_events_util.dart';
import 'package:bms_project/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:socket_io_client/socket_io_client.dart' as sio;

import 'environment.dart';

class Constants {
  static String TAG = "Constants";
  static DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mma');

  static sio.Socket? socket;

  static sio.Socket getSocket() {
    Log.d("Constants",
        "connecting to socket client sever: ${Environment.SOCKET_URL}");
    if (socket == null) {
      socket = sio.io(
          Environment.SOCKET_URL,
          sio.OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .disableAutoConnect()
              .build());
      //https://stackoverflow.com/questions/68058896/latest-version-of-socket-io-nodejs-is-not-connecting-to-flutter-applications
      socket!.connect();
      Log.d(TAG, "socket connected at ${socket!.connected}");
      //socket.onConnect((data) => null)
      socket!.onConnect((data) async {
        Log.d(TAG, "connected");
        socket!.emit(SocketEvents.USER_REGISTER, await AuthToken.parseUserId());
      });
    }

    return socket!;
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
