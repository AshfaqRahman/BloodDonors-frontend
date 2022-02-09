import 'dart:convert';

import 'package:bms_project/modals/blood_post.dart';
import 'package:flutter/material.dart';

class BloodPostWidget extends StatelessWidget {
  final BloodPostResponse postData;
  const BloodPostWidget(this.postData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.4,
      child: Card(
        color: Colors.white,
        elevation: 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(
                //radius: 200,
                child: ClipOval(
                  child: Image.network(
                    'https://avatars.githubusercontent.com/u/55390870?v=4',
                  ),
                ),
              ),
              Column(
                children: [
                  Text(postData.userName),
                  Text(postData.creationTime),
                ],
              )
            ]),
            Text("${postData.amount} bags ${postData.bloodGroup} blood needed."),
            FittedBox(child: Text("Location: ${postData.location.displayName}")),
            Text("Time: ${postData.dueTime}"),
            Text("Contact: ${postData.contact}"),
            Text(
                "Additional info: ${postData.additionalInfo['text']}")
          ],
        ),
      ),
    );
  }
}
