import 'dart:convert';

import 'package:bms_project/modals/blood_post_model.dart';
import 'package:bms_project/modals/comment_model.dart';

class DummyConstants {
  static String dummyPostId = "ba46e5ac-89fa-4ada-9b1d-3b862b6d9f92";

  // https://jsontostring.com/
  static String postData =
      "{\"post_id\":\"cc72ceec-0eae-422f-8b55-a34cd78f6ea8\",\"blood_group\":\"AB-\",\"amount\":1,\"contact\":\"1242\",\"due_time\":\"2022-02-09T07:52:00.000Z\",\"additional_info\":\"{\\\"text\\\":\\\"tsdt\\\"}\",\"location\":{\"id\":\"29b23881-c927-4e2a-ab32-d04e69a771d4\",\"latitude\":23.7251291,\"longitude\":90.392544,\"description\":\"AhsanUllahHall,ZahirRaihanSharaniRd,Polashi,Bokshibazar,Dhaka,DhakaMetropolitan,DhakaDistrict,DhakaDivision,1211,Bangladesh\"},\"user_id\":\"d9d5330c-62a3-427e-9aad-a749a29eceeb\",\"user_name\":\"masum\",\"created\":\"2022-02-09T07:52:48.498Z\"}";

  static String commentData =
      "{\"comment_id\":\"a7c83027-0a3b-46fe-8666-ac7fc970bd6d\",\"text\":\"aluvorta\",\"post_id\":\"ba46e5ac-89fa-4ada-9b1d-3b862b6d9f92\",\"user_id\":\"a5c931f9-d9e3-4eb0-b4e6-235059157490\",\"user_name\":\"m\",\"created\":\"2022-02-11T12:24:58.974Z\"}";
  static List<Comment> dummyCommentList(int size) {
    List<Comment> list = [];
    for (int i = 0; i < size; i++) {
      list.add(Comment.fromJson(json.decode(commentData)));
    }
    return list;
  }
}



/* const BloodPostResponse dummyPostPost = BloodPostResponse(
  "fec20186-2396-4643-a8e2-2f2440814437",
  userId,
  userName,
  creationTime,
  dueTime: dueTime,
  location: location,
  bloodGroup: bloodGroup,
  amount: amount,
  contact: contact,
  additionalInfo:); */