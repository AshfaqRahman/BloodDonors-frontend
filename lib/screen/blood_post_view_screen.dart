import 'package:bms_project/modals/blood_post_model.dart';
import 'package:flutter/material.dart';

import '../widgets/post_screen/blood_post.dart';

class BloodPostScreen extends StatelessWidget {
  static String route = "/blood-post";
  const BloodPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BloodPost? data =
        ModalRoute.of(context)!.settings.arguments as BloodPost?;
    print("BloodPostScreen");
    print(data?.toJson());
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 30, bottom: 30),
          child: BloodPostWidget(postData: data),
        ),
      ),
    );
  }
}
