import 'dart:convert';

import 'package:bms_project/modals/comment_model.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/utils/environment.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:bms_project/utils/constant.dart' as constants;
import 'package:universal_html/js.dart';

class CommentProvider with ChangeNotifier {
  static String TAG = "CommentProvider";

  void debugPrint(msg) {
    print("$TAG -> $msg");
  }

  Future<ProviderResponse> createComment(String post_id, String comment) async {
    var url = "${Environment.apiUrl}/comment";
    debugPrint("posting comment to $url");
    debugPrint({'post_id': post_id, "text": comment});

    final body = json.encode(
      {'post_id': post_id, "text": comment},
    );

    String token = await constants.getToken();
    try {
      http.Response response =
          await http.post(Uri.parse(url), body: body, headers: {
        'access-control-allow-origin': '*',
        'content-type': 'application/json',
        'authorization': token,
      });

      debugPrint(response.body);
      Map data = json.decode(response.body);

      if (data['code'] == constants.HttpSatusCode.CREATED) {
        debugPrint("comment created successfully");
        Comment commentData = Comment.fromJson(data['data']);
        debugPrint("recieved data: ${commentData.toJson()}");
        notifyListeners();
        return ProviderResponse(
            success: true, message: "comment created", data: commentData);
      } else {
        return ProviderResponse(
            success: false, message: "comment was not created.");
      }
    } catch (error) {
      debugPrint(error);
      return ProviderResponse(success: false, message: "error");
    }
  }

  Future<ProviderResponse> getComments(String post_id) async {
    String url = "${Environment.apiUrl}/comment/$post_id";
    debugPrint("fetching from: $url");
    try {
      Map<String, String> headers = await constants.getHeaders();
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      debugPrint(response.body);
      Map data = json.decode(response.body);
      if (data['code'] == constants.HttpSatusCode.OK) {
        List commentJsonList = data['data'];
        List<Comment> commentList = commentJsonList.map((e) {
          return Comment.fromJson(e);
        }).toList();
        return ProviderResponse(
            success: true, message: "ok", data: commentList);
      } else {
        return ProviderResponse(success: false, message: "no comment found");
      }
    } catch (error) {
      debugPrint(error);
      return ProviderResponse(success: false, message: "error");
    }
  }
}
