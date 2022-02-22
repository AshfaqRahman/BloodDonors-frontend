import 'package:bms_project/modals/osm_model.dart';

class Donation {
  Donation({
    required this.userId,
    required this.userName,
    required this.created,
    required this.donationTime,
    required this.location,
  });

  String userId;
  String userName;
  DateTime created;
  DateTime donationTime;
  OsmLocation location;

  factory Donation.fromJson(Map<String, dynamic> json) => Donation(
        userId: json["user_id"],
        userName: json["user_name"],
        created: DateTime.parse(json["created"]),
        donationTime: DateTime.parse(json["donation_time"]),
        location: OsmLocation.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "created": created.toIso8601String(),
        "donation_time": donationTime.toIso8601String(),
        "location": location.toJson(),
      };
}
