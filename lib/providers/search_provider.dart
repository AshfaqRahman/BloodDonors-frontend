import 'dart:convert';

import 'package:bms_project/modals/user_model.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../utils/constant.dart';
import '../utils/debug.dart';
import '../utils/environment.dart';

class SearchProvider with ChangeNotifier {
  static String TAG = "SearchProvider";

  Future<ProviderResponse> searchBlood(String bloodGroup) async{
    String url = "${Environment.apiUrl}/user/search-bg/$bloodGroup";
    String fName = "searchBlood():";
    Log.d(TAG, "$fName fetching from: $url");

    try {
      Response response = await get(
        Uri.parse(url),
        headers: await Constants.getHeaders(),
      );

      //Log.d(TAG, "$fName ${response.body}");

      Map data = json.decode(response.body);
      if (data['code'] == HttpSatusCode.OK) {
        List dataListJson = data['data'];
        List<UserBloodSearchResult> userSearchResultList = dataListJson.map((e) {
          return UserBloodSearchResult.fromJson(e);
        }).toList();
        Log.d(TAG, "$fName Total search result  of bloog group $bloodGroup: ${userSearchResultList.length}");
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