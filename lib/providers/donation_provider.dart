import 'dart:convert';

import 'package:bms_project/modals/donation_model.dart';
import 'package:bms_project/modals/osm_model.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../utils/constant.dart';
import '../utils/debug.dart';
import '../utils/environment.dart';

class DonationProvider with ChangeNotifier {
  static const String TAG = "DonationProvider";

  Future<ProviderResponse> addDonation(
      OsmLocation location, String date) async {
    String url = "${Environment.apiUrl}/donation";
    String fName = "addDonation(): ";
    Log.d(TAG, "$fName fetching from: $url");

    final body = json.encode(
      {'location': location.toMap(), "donation_time": date},
    );

    try {
      Response response = await post(
        Uri.parse(url),
        body: body,
        headers: await Constants.getHeaders(),
      );

      Log.d(TAG, "$fName  ${response.body}");

      Map data = json.decode(response.body);
      if (data['code'] == HttpSatusCode.CREATED) {
        /* List chatMessageJsonList = data['data'];
        List<ChatMessage> chatMessageList = chatMessageJsonList.map((e) {
          return ChatMessage.fromJson(e);
        }).toList();
        Log.d(TAG, "$fName Total message : ${chatMessageList.length}"); */
        return ProviderResponse(
          success: true,
          message: "ok",
          //data: chatMessageList,
        );
      } else {
        Log.d(TAG, "$fName not http 200");
        return ProviderResponse(
            success: false, message: "error posting donation");
      }
    } catch (e) {
      Log.d(TAG, "$fName error");
      Log.d(TAG, "$fName ${e}");
      return ProviderResponse(success: false, message: "error");
    }
  }

  Future<ProviderResponse> getDonations(String userId) async {
    String url = "${Environment.apiUrl}/donation/$userId";
    String fName = "getDonations():";
    Log.d(TAG, "$fName fetching from: $url");

    try {
      Response response = await get(
        Uri.parse(url),
        headers: await Constants.getHeaders(),
      );

      Log.d(TAG, "$fName  ${response.body}");

      Map data = json.decode(response.body);
      if (data['code'] == HttpSatusCode.OK) {
        List donationListJson = data['data'];
        List<Donation> donationList = donationListJson.map((e) {
          return Donation.fromJson(e);
        }).toList();
        Log.d(TAG, "$fName Total donation : ${donationList.length}");
        return ProviderResponse(
          success: true,
          message: "ok",
          data: donationList,
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
}
