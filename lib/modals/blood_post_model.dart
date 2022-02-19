import 'dart:convert';

import 'package:bms_project/modals/osm_model.dart';
import 'package:bms_project/utils/debug.dart';

class BloodPostUserInput {
  String dueTime;
  OsmLocation location;
  String bloodGroup;
  int amount;
  String contact;
  Map<String, dynamic> additionalInfo;

  BloodPostUserInput({
    required this.dueTime,
    required this.location,
    required this.bloodGroup,
    required this.amount,
    required this.contact,
    required this.additionalInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'due_time': dueTime,
      'location': location.toMap(),
      'blood_group': bloodGroup,
      'amount': amount,
      'contact': contact,
      'additional_info': json.encode(additionalInfo),
    };
  }
}
/*
json
{
    "post_id": "fec20186-2396-4643-a8e2-2f2440814437",
    "blood_group": "AB-",
    "amount": 1,
    "contact": "1242",
    "due_time": "2022-02-09T07:52:00.000Z",
    "additional_info": "{\"text\":\"tsdt\"}",
    "location": {
      "id": "29b23881-c927-4e2a-ab32-d04e69a771d4",
      "latitude": 23.7251291,
      "longitude": 90.392544,
      "description": "Ahsan Ullah Hall, Zahir Raihan Sharani Rd, Polashi, Bokshibazar, Dhaka, Dhaka Metropolitan, Dhaka District, Dhaka Division, 1211, Bangladesh"
    },
    "user_id": "d9d5330c-62a3-427e-9aad-a749a29eceeb",
    "user_name": "masum",
    "created": "2022-02-09T07:52:48.498Z"
  }
*/

class BloodPost {
  BloodPost({
    required this.postId,
    required this.bloodGroup,
    required this.amount,
    required this.contact,
    required this.dueTime,
    required this.additionalInfo,
    required this.location,
    required this.userId,
    required this.userName,
    required this.created,
  });

  String postId;
  String bloodGroup;
  int amount;
  String contact;
  DateTime dueTime;
  Map<String, dynamic> additionalInfo;
  OsmLocation location;
  String userId;
  String userName;
  DateTime created;

  factory BloodPost.fromJson(Map<String, dynamic> jsonData) {
    //Log.d("BloodPost.fromJson", jsonData);
    return BloodPost(
      postId: jsonData["post_id"],
      bloodGroup: jsonData["blood_group"],
      amount: jsonData["amount"],
      contact: jsonData["contact"],
      dueTime: DateTime.parse(jsonData["due_time"]),
      additionalInfo: json.decode(jsonData["additional_info"]),
      location: OsmLocation.fromJson(jsonData["location"]),
      userId: jsonData["user_id"],
      userName: jsonData["user_name"],
      created: DateTime.parse(jsonData["created"]??DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "blood_group": bloodGroup,
        "amount": amount,
        "contact": contact,
        "due_time": dueTime.toIso8601String(),
        "additional_info": additionalInfo,
        "location": location.toJson(),
        "user_id": userId,
        "user_name": userName,
        "created": created.toIso8601String(),
      };
}
