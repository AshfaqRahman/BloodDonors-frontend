import 'dart:convert';

import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/utils/constant.dart';
import 'package:bms_project/utils/debug.dart';
import 'package:flutter/material.dart';
import 'package:bms_project/modals/blood_post_model.dart' as bp;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/environment.dart';

class BloodPostProvider with ChangeNotifier {
  static String TAG = "BloodPostProvider";

  Future getPost(String post_id) async {
    var url = '${Environment.apiUrl}/post/blood-post/$post_id';
    print("fetching blood post $post_id from $url");
    String token = await Constants.getToken();
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'access-control-allow-origin': '*',
        'content-type': 'application/json',
        'authorization': token,
      });
      print("response body");
      print(response.body);
      var data = json.decode(response.body);
      notifyListeners();
      if (data['code'] == 200) {
        print("ok code 200 post found.");
        return {
          'success': true,
          'message': data['message'],
          'data': bp.BloodPost.fromJson(data['data']),
        };
      } else {
        return {
          'success': false,
          'message': "Post not found",
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': "Post not found",
      };
    }
  }

  Future<ProviderResponse> getPosts() async {
    String url = "${Environment.apiUrl}/post/blood-post/";
    Log.d(TAG, "fechting from: $url");

    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: await Constants.getHeaders());

      //Log.d(TAG, response.body);

      Map responseBody = json.decode(response.body);

      if (responseBody['code'] == HttpSatusCode.OK) {
        List postJsonList = responseBody['data'];
        Log.d(TAG, "total post: ${postJsonList.length}");
        List<bp.BloodPost> postList = postJsonList.map((e) {
          return bp.BloodPost.fromJson(e);
        }).toList();
        return ProviderResponse(success: true, message: "ok", data: postList);
      } else {
        return ProviderResponse(success: false, message: "no post found");
      }
    } catch (error) {
      Log.d(TAG, error);
      return ProviderResponse(success: false, message: "error");
    }
  }

  Future<ProviderResponse> createPost(bp.BloodPostUserInput bloodPost) async {
    var url = '${Environment.apiUrl}/post/blood-post/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") as String;
    final body = json.encode(bloodPost.toMap());
    try {
      http.Response response =
          await http.post(Uri.parse(url), body: body, headers: {
        'access-control-allow-origin': '*',
        'content-type': 'application/json',
        'authorization': token,
      });
      print("response body");
      print(response.body);
      var data = json.decode(response.body);
      notifyListeners();
      if (data['code'] == 201) {
        print("ok code 201 post created.");
        bp.BloodPost post = bp.BloodPost.fromJson(data['data']);
        return ProviderResponse(
          success: true,
          message: "Post created successfully.",
          data: post,
        );
      } else {
        return ProviderResponse(
            success: false, message: "Post was not created");
      }
    } catch (error) {
      Log.d(TAG, error);
      return ProviderResponse(success: false, message: "error");
    }
  }
}
