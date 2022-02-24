import 'package:bms_project/modals/chat_model.dart';
import 'package:bms_project/modals/location.dart';
import 'package:bms_project/modals/osm_model.dart';

class User {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String bloodGroup;
  final Location location;
  final password;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.bloodGroup,
    required this.location,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'location': location.toMap(),
      'bloodGroup': bloodGroup,
      'gender': gender,
    };
  }
}

class ProfileData {
  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.bloodGroup,
    required this.created,
    required this.gender,
    required this.location,
    required this.available,
    required this.lastDonation,
  });

  String id;
  String name;
  String email;
  String phoneNumber;
  String bloodGroup;
  DateTime created;
  String gender;
  OsmLocation location;
  bool available;
  DateTime? lastDonation;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        bloodGroup: json["blood_group"],
        created: DateTime.parse(json["created"]),
        gender: json["gender"],
        location: OsmLocation.fromJson(json["location"]),
        available: json["available"],
        lastDonation: json["last_donation"]!= null ? DateTime.parse(json["last_donation"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone_number": phoneNumber,
        "blood_group": bloodGroup,
        "created": created.toIso8601String(),
        "gender": gender,
        "location": location.toJson(),
        "available": available,
        "last_donation": lastDonation?.toIso8601String(),
      };
}

/*
{
    "id": "0fd9be52-8afb-4920-a441-fe04a748cca0",
    "name": "Hasan Masum",
    "email": "masum",
    "phone_number": "012345678910",
    "blood_group": "B-",
    "created": "2022-02-22T13:31:58.000Z",
    "gender": "male",
    "location": {
      "latitude": 23.7258624442882,
      "longitude": 90.3916128963992,
      "description": "বাংলাদেশ প্রকৌশল বিশ্ববিদ্যালয়, Dhakeswari Road, খাজে দেওয়ান, বকশীবাজার, ঢাকা, ঢাকা মহানগর, ঢাকা জেলা, ঢাকা বিভাগ, 1211, বাংলাদেশ"
    },
    "available": false,
    "last_donation": "2022-02-15T00:00:00.000Z"
  }
  */

class UserSearhResult {
  UserSearhResult({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory UserSearhResult.fromJson(Map<String, dynamic> json) =>
      UserSearhResult(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  Chat toChat() {
    return Chat(userId: id, userName: name, chatMessage: null, isSender: false);
  }
}

/*
{
  "id": "1be30189-b97a-45b2-a33d-ebff660e0194",
  "name": "Ashfaq Rahman"
}
*/


class UserBloodSearchResult {
  UserBloodSearchResult({
    required this.name,
    required this.id,
    required this.email,
    required this.phone,
    required this.bloodGroup,
    required this.gender,
    required this.location,
  });

  String name;
  String id;
  String email;
  String phone;
  String bloodGroup;
  String gender;
  OsmLocation location;

  factory UserBloodSearchResult.fromJson(Map<String, dynamic> json) =>
      UserBloodSearchResult(
        name: json["name"],
        id: json["id"],
        email: json["email"],
        phone: json["phone"],
        bloodGroup: json["blood_group"],
        gender: json["gender"],
        location: OsmLocation.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "email": email,
        "phone": phone,
        "blood_group": bloodGroup,
        "gender": gender,
        "location": location.toJson(),
      };
}
// bloog gropu search result
/* {
      "name": "Ashfaq Rahman",
      "id": "1be30189-b97a-45b2-a33d-ebff660e0194",
      "email": "ashfaq",
      "phone": "12345678910",
      "blood_group": "O+",
      "gender": "male",
      "location": {
        "latitude": 23.7247350288255,
        "longitude": 90.3930284276748,
        "description": "Ahsan Ullah Hall, জহির রায়হান সরণী সড়ক, পলাশী, বকশীবাজার, ঢাকা, ঢাকা মহানগর, ঢাকা জেলা, ঢাকা বিভাগ, 1211, বাংলাদেশ"
      }
    } */


