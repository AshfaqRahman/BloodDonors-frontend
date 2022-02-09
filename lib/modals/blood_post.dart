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

class BloodPostResponse extends BloodPost {
  String postId;
  String userId;
  String userName;
  String creationTime;

  BloodPostResponse(this.postId, this.userId, this.userName, this.creationTime,
      {required String dueTime,
      required OsmLocation location,
      required String bloodGroup,
      required int amount,
      required String contact,
      required Map<String, dynamic> additionalInfo})
      : super(
            dueTime: dueTime,
            location: location,
            bloodGroup: bloodGroup,
            amount: amount,
            contact: contact,
            additionalInfo: additionalInfo);

  static BloodPostResponse toBloodPostResponse(Map mp) {
    print("toBloodPostResponse");
    print(mp);
    BloodPostResponse data = BloodPostResponse(
      mp['post_id'],
      mp['user_id'],
      mp['user_name'],
      mp['created'],
      dueTime: mp['due_time'],
      location: OsmLocation(
        latitude: mp['location']['latitude'],
        longitude: mp['location']['longitude'],
        displayName: mp['location']['description'],
        type: "",
      ),
      bloodGroup: mp['blood_group'],
      amount: mp['amount'],
      contact: mp['contact'],
      additionalInfo: json.decode(mp['additional_info']),
    );

    return data;
  }
}/* {
  post_id: 77c32f50-8efc-46de-95e9-72382b15103b,
   blood_group: AB+,
    amount: 1, 
    contact: 12, 
    due_time: 2022-02-09T08:29:00.000Z,
     additional_info: {"text":"535"}, 
     location: {id: 29b23881-c927-4e2a-ab32-d04e69a771d4, 
     latitude: 23.7251291, longitude: 90.392544, 
     description: Ahsan Ullah Hall, Zahir Raihan Sharani Rd, Polashi, Bokshibazar, Dhaka, Dhaka Metropolitan, Dhaka District, Dhaka Division, 1211, Bangladesh}, 
     user_id: d9d5330c-62a3-427e-9aad-a749a29eceeb, 
     user_name: masum, 
     created: 2022-02-09T08:29:11.504Z
     } */
