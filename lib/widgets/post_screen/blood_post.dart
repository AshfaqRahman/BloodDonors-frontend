import 'dart:convert';
import 'dart:math';

import 'package:bms_project/modals/blood_post_model.dart';
import 'package:bms_project/widgets/common/decorations.dart';
import 'package:bms_project/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import '../../utils/dummy.dart';

class BloodPostWidget extends StatelessWidget {
  BloodPost? postData;
  BloodPostWidget({Key? key, this.postData}) : super(key: key);

  // https://api.flutter.dev/flutter/intl/DateFormat-class.html
  DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

  @override
  Widget build(BuildContext context) {
    postData = BloodPost.fromJson(json.decode(DummyConstants.postData));
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      //height: MediaQuery.of(context).size.height*0.4,
      child: Card(
        color: Colors.white,
        elevation: 6,
        child: Container(
          padding:
              const EdgeInsets.only(top: 24, bottom: 12, left: 24, right: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostCreatorInfoWidget(postData: postData, dateFormat: dateFormat),
              const VerticalSpacing(20),
              Text(
                  "${postData!.amount} bags ${postData!.bloodGroup} blood needed."),
              const VerticalSpacing(20),
              Text("Location: ${postData!.location.displayName}"),
              const VerticalSpacing(20),
              Text("Time: ${dateFormat.format(postData!.dueTime.toLocal())}"),
              const VerticalSpacing(20),
              Text("Contact: ${postData!.contact}"),
              const VerticalSpacing(20),
              Text("Additional info: ${postData!.additionalInfo['text']}"),
              const VerticalSpacing(20),
              const Divider(
                thickness: 1,
                height: 10,
              ),
              InteractionSection(),
              const Divider(
                thickness: 1,
                height: 10,
              ),
              const VerticalSpacing(20),
              CommentSection()
            ],
          ),
        ),
      ),
    );
  }
}

class PostCreatorInfoWidget extends StatelessWidget {
  const PostCreatorInfoWidget({
    Key? key,
    required this.postData,
    required this.dateFormat,
  }) : super(key: key);

  final BloodPost? postData;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      CircleAvatar(
        //radius: 200,
        child: ClipOval(
          child: Icon(
            Icons.account_circle,
            size: 40,
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          ),
        ),
      ),
      const HorizontalSpacing(20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            postData!.userName,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(dateFormat.format(postData!.created.toLocal())),
        ],
      )
    ]);
  }
}

class InteractionSection extends StatelessWidget {
  InteractionSection({
    Key? key,
  }) : super(key: key);

  var buttons = [
    {'icon': Icons.thumb_up, 'title': "Like", 'onPressed': () {}},
    {'icon': Icons.comment, 'title': "Comment", 'onPressed': () {}},
    {'icon': FontAwesomeIcons.share, 'title': "Share", 'onPressed': () {}},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...buttons.map((Map item) {
          return Flexible(
            child: TextButton(
              onPressed: item['onPressed'],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item["icon"]),
                  const VerticalDivider(
                    width: 5,
                  ),
                  Text(item["title"]),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class CommentSection extends StatelessWidget {
  const CommentSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = ["int", "int"];

    return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          WriteCommentWidget(),
          Row(
            children: [
              CircleAvatar(
                //radius: 200,
                child: ClipOval(
                  child: Icon(
                    Icons.account_circle,
                    size: 30,
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                  ),
                ),
              ),
              const HorizontalSpacing(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hasan Masum",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text("int"),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class WriteCommentWidget extends StatelessWidget {
  const WriteCommentWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          //radius: 200,
          child: ClipOval(
            child: Icon(
              Icons.account_circle,
              size: 30,
              color:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
            ),
          ),
        ),
        HorizontalSpacing(15),
        Flexible(
            child: TextField(
          decoration: getInputDecoration(context, "", null, 25),
        )),
        HorizontalSpacing(25),
        ElevatedButton(
          onPressed: () {},
          child: Text("Comment"),
        ),
      ],
    );
  }
}
