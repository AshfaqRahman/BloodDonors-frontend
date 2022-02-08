import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bms_project/modals/blood_post.dart' as bp;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/environment.dart';

class BloodPost with ChangeNotifier {
  Future createPost(bp.BloodPost bloodPost) async {
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
      var data = json.decode(response.body);
      print(data);
      notifyListeners();
      if (data['code'] == 201) {
        return {
          'success': true,
          'message': data['message'],
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
      return [false, error];
    }
  }
}
