import 'dart:convert';

import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/utils/debug.dart';
import 'package:bms_project/utils/environment.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../modals/chat_model.dart';
import '../utils/constant.dart';

class ChatProvider with ChangeNotifier {
  static const String TAG = "ChatProvider";

  Future<ProviderResponse> getChats() async {
    String url = "${Environment.apiUrl}/message/";
    Log.d(TAG, "fetching from: $url");

    try {
      Response response = await get(
        Uri.parse(url),
        headers: await Constants.getHeaders(),
      );

      Log.d(TAG, response.body);

      Map data = json.decode(response.body);
      if (data['code'] == HttpSatusCode.OK) {
        List chatJsonList = data['data'];
        List<Chat> chatList = chatJsonList.map((e) {
          return Chat.fromJson(e);
        }).toList();
        Log.d(TAG, "Total chat : ${chatList.length}");
        return ProviderResponse(
          success: true,
          message: "ok",
          data: chatList,
        );
      } else {
        return ProviderResponse(
            success: false, message: "error fetching reacts");
      }
    } catch (e) {
      return ProviderResponse(success: false, message: "Chat list error");
    }
  }
}
