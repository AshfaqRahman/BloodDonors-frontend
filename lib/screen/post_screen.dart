import 'package:bms_project/modals/blood_post.dart';
import 'package:bms_project/widgets/post/blood_post.dart';
import 'package:flutter/material.dart';

class BloodPostScreen extends StatelessWidget {
  static String route = "/blood-post";
  const BloodPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BloodPostResponse data =
        ModalRoute.of(context)!.settings.arguments as BloodPostResponse;
    print("BloodPostScreen");
    print(data.toMap());
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: BloodPostWidget(data),
      ),
    );
  }
}
