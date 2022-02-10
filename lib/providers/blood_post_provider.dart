import 'dart:convert';

import 'package:bms_project/utils/constant.dart' as constants;
import 'package:flutter/material.dart';
import 'package:bms_project/modals/blood_post_model.dart' as bp;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/environment.dart';

class BloodPostProvider with ChangeNotifier {
  Future getPost(String post_id) async {
    var url = '${Environment.apiUrl}/post/blood-post/$post_id';
    print("fetching blood post $post_id from $url");
    String token = await constants.getToken();
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

  Future createPost(bp.BloodPostUserInput bloodPost) async {
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
        return {
          'success': true,
          'message': data['message'],
          'data': bp.BloodPost.fromJson(data['data']),
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? "unknown reason",
        };
      }
    } catch (error) {
      print("error");
      print(error);
      return {
        'success': false,
        'message': error,
      };
    }
  }
}
