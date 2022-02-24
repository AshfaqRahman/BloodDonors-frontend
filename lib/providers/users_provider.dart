import 'dart:convert';

import 'package:bms_project/modals/location.dart';
import 'package:bms_project/modals/user_model.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/utils/debug.dart';
import 'package:bms_project/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constant.dart';

// import '../models/http_exception.dart';
// import './product.dart';

class UsersProvider with ChangeNotifier {
  static const String TAG = "Users";

  late User user;
  Future<dynamic> signUpUser(User user) async {
    var url = '${Environment.apiUrl}/auth/register';
    final body = json.encode(user.toMap());
    try {
      http.Response response = await http.post(Uri.parse(url),
          body: body,
          headers: {
            'access-control-allow-origin': '*',
            'content-type': 'application/json'
          });
      var data = json.decode(response.body);
      notifyListeners();
      if (data['code'] == 409 || data['code'] == 500) {
        return {
          'success': false,
          'message': data['message'],
        };
      } else if (data['code'] == 201) {
        return {
          'success': true,
          'message': 'successfully registered',
        };
      } else {
        return {
          'success': false,
          'message': 'unknown number',
        };
      }
    } catch (error) {
      print("error");
      print(error);
      return [false, error];
    }
  }

  Future<dynamic> signInUser(Map<String, String> userInfo) async {
    var url = '${Environment.apiUrl}/auth/login';
    print("requesting in $url");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = json.encode(userInfo);
    print("Provider.signInUser():");
    print(body);
    try {
      print("yo");
      http.Response response = await http.post(Uri.parse(url),
          body: body,
          headers: {
            'access-control-allow-origin': '*',
            'content-type': 'application/json'
          });
      Log.d(TAG, "signInUser: ${response.body}");
      var data = json.decode(response.body);
      print(data);
      var code = data['code'];
      notifyListeners();
      if (code == 404 || code == 500) {
        return {
          'success': false,
          'message': data['message'],
        };
      } else if (code == 200) {
        prefs.setString('token', data['token']);
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': 'unknown error',
        };
      }
    } catch (error) {
      print("sign in user: error");
      print(error);
      return {
        'success': false,
        'message': error,
      };
    }
  }

  Future<ProviderResponse> getUserData() async {
    // print("inside getUserData");
    var url = '${Environment.apiUrl}/user/me';
    String fName = "getUserData():";
    Log.d(TAG, "$fName fetching from: $url");

    try {
      Response response = await get(
        Uri.parse(url),
        headers: await Constants.getHeaders(),
      );

      Log.d(TAG, "$fName ${response.body}");

      Map data = json.decode(response.body);
      if (data['code'] == HttpSatusCode.OK) {
        ProfileData profileData = ProfileData.fromJson(data['data']);
        Log.d(TAG,
            "$fName id: ${profileData.id}, name: ${profileData.name} profile data fetched");
        return ProviderResponse(
          success: true,
          message: "ok",
          data: profileData,
        );
      } else {
        Log.d(TAG, "$fName not http 200");
        return ProviderResponse(
            success: false, message: "error fetching donation");
      }
    } catch (e) {
      Log.d(TAG, "$fName error");
      Log.d(TAG, "$fName ${e}");
      return ProviderResponse(success: false, message: "error");
    }
  }

  Future<ProviderResponse> searchUser(String name) async {
    String url = "${Environment.apiUrl}/user/search/$name";
    String fName = "searchUser():";
    Log.d(TAG, "$fName fetching from: $url");

    try {
      Response response = await get(
        Uri.parse(url),
        headers: await Constants.getHeaders(),
      );

      Log.d(TAG, "$fName ${response.body}");

      Map data = json.decode(response.body);
      if (data['code'] == HttpSatusCode.OK) {
        List dataListJson = data['data'];
        List<UserSearhResult> userSearchResultList = dataListJson.map((e) {
          return UserSearhResult.fromJson(e);
        }).toList();
        Log.d(TAG, "$fName Total search result : ${userSearchResultList.length}");
        return ProviderResponse(
          success: true,
          message: "ok",
          data: userSearchResultList,
        );
      } else {
        Log.d(TAG, "$fName not http 200");
        return ProviderResponse(
            success: false, message: "error fetching users by search");
      }
    } catch (e) {
      Log.d(TAG, "$fName error");
      Log.d(TAG, "$fName ${e}");
      return ProviderResponse(success: false, message: "error");
    }
  }
}
