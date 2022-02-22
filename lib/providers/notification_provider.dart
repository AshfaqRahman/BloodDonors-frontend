import 'dart:convert';

import 'package:bms_project/modals/notification_model.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/utils/token.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../utils/constant.dart';
import '../utils/debug.dart';
import '../utils/environment.dart';

class NotificationProvider with ChangeNotifier {
  static const String TAG = "NotificationProvider";

  Future<ProviderResponse> getNotications() async {
    String fName = "getNotications():";
    String url = "${Environment.apiUrl}/notification/";
    Log.d(TAG, "$fName fetching from: $url");

    try {
      Response response = await get(
        Uri.parse(url),
        headers: await Constants.getHeaders(),
      );

      //Log.d(TAG,"$fName  ${response.body}");

      Map data = json.decode(response.body);
      if (data['code'] == HttpSatusCode.OK) {
        List notificationJsonList = data['data'];

        List<NotificationModel> notificationList = [];

        String userId = await AuthToken.parseUserId();
        for (int i = 0; i < notificationJsonList.length; i++) {
          NotificationModel notificationModel =
              NotificationModel.fromJson(notificationJsonList[i]);

          if (notificationModel.actorId != userId)
            notificationList.add(notificationModel);
        }
        
        Log.d(TAG, "$fName Total notifications : ${notificationList.length}");
        return ProviderResponse(
          success: true,
          message: "ok",
          data: notificationList,
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
