import 'dart:convert';

import 'package:bms_project/modals/osm_model.dart';

class BloodPost {
  String dueTime;
  OsmLocation location;
  String bloodGroup;
  int amount;
  String contact;
  Map<String, dynamic> additionalInfo;

  BloodPost({
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
