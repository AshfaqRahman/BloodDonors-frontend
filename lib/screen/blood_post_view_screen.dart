import 'package:bms_project/modals/blood_post_model.dart';
import 'package:bms_project/utils/debug.dart';
import 'package:flutter/material.dart';

import '../widgets/post_screen/blood_post.dart';

class BloodPostScreen extends StatelessWidget {
  static String TAG = "BloodPostScreen";
  static String route = "/blood-post";
  const BloodPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BloodPost? data =
        ModalRoute.of(context)!.settings.arguments as BloodPost?;
    Log.d(TAG, "BloodPostScreen");
    Log.d(TAG, data?.toJson());
    return Scaffold(
      appBar: AppBar(
        title: Text("Blood Donors",
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        
      ),
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
