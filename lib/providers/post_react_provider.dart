import 'dart:convert';

import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/utils/constant.dart';
import 'package:bms_project/utils/debug.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../modals/react_model.dart';
import '../utils/environment.dart';

class PostReactProvider with ChangeNotifier {
  static const String TAG = "PostReactProvider->";

  Future<ProviderResponse> submitReact(String postId) async {
    var url = '${Environment.apiUrl}/react/post';
    Log.d(TAG, "submitting react to $url");
    Map body = {"post_id": postId};

    try {
      Response response = await post(
        Uri.parse(url),
        body: json.encode(body),
        headers: await Constants.getHeaders(),
      );

      Log.d(TAG, response.body);

      Map data = json.decode(response.body);
      if (data['code'] == HttpSatusCode.CREATED) {
        React react = React.fromJson(data['data']);
        return ProviderResponse(success: true, message: "react sumitted", data:  react);
      } else {
        return ProviderResponse(
            success: false, message: "react was not sumitted");
      }
    } catch (e) {
      return ProviderResponse(success: false, message: "unexpected error.");
    }
  }



  Future<ProviderResponse> removeReact(String postId) async {
    var url = '${Environment.apiUrl}/react/post/$postId';
    Log.d(TAG, "removing react from $url");
    try {
      Response response = await delete(
        Uri.parse(url),
        headers: await Constants.getHeaders(),
      );

      Log.d(TAG, response.body);

      Map data = json.decode(response.body);
      if (data['code'] == HttpSatusCode.DELETED) {
        return ProviderResponse(success: true, message: "react removed");
      } else {
        return ProviderResponse(
            success: false, message: "react was not removed");
      }
    } catch (e) {
      return ProviderResponse(success: false, message: "unexpected error.");
    }
  }

  Future<ProviderResponse> getReacts(String postId) async {
    var url = '${Environment.apiUrl}/react/post/$postId';
    Log.d(TAG, "fetching reacts from $url");

    try {
      Response response = await get(
        Uri.parse(url),
        headers: await Constants.getHeaders(),
      );

      Log.d(TAG, response.body);

      Map data = json.decode(response.body);
      if (data['code'] == HttpSatusCode.OK) {
        List reactJsonList = data['data'];
        List<React> reactList = reactJsonList.map((e) {
          return React.fromJson(e);
        }).toList();
        Log.d(TAG, "Total react : ${reactList.length}");
        return ProviderResponse(success: true, message: "ok", data: reactList);
      } else {
        return ProviderResponse(
            success: false, message: "error fetching reacts");
      }
    } catch (e) {
      return ProviderResponse(success: false, message: "unexpected error.");
    }
  }


}
