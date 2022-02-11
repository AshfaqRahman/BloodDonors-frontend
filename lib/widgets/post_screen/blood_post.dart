import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:bms_project/modals/blood_post_model.dart';
import 'package:bms_project/modals/comment_model.dart';
import 'package:bms_project/providers/comment_provider.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/utils/debug.dart';
import 'package:bms_project/widgets/common/decorations.dart';
import 'package:bms_project/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../../utils/dummy.dart';

class BloodPostWidget extends StatefulWidget {
  
  BloodPost? postData;
  BloodPostWidget({Key? key, this.postData}) : super(key: key);

  @override
  State<BloodPostWidget> createState() => _BloodPostWidgetState();
}

class _BloodPostWidgetState extends State<BloodPostWidget> {
  static String TAG = "BloodPostWidget";
  // https://api.flutter.dev/flutter/intl/DateFormat-class.html
  DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

  bool showComment = false;

  Future<List<Comment>> fetchComments(BuildContext ctx, String postId) async {
    ProviderResponse response =
        await Provider.of<CommentProvider>(ctx, listen: false)
            .getComments(postId);
    Log.d(TAG, response.toJson());
    return response.success ? response.data : [];
  }

  @override
  Widget build(BuildContext context) {
    //widget.postData = BloodPost.fromJson(json.decode(DummyConstants.postData));

    //fetchComments(context, postData!.postId);

    List<Map> infoList = [
      {'title': "Amount: ", 'info': "${widget.postData!.amount}"},
      {'title': "Location: ", 'info': widget.postData!.location.displayName},
      {'title': "Time: ", 'info': dateFormat.format(widget.postData!.created)},
      {'title': "Contact: ", 'info': widget.postData!.contact},
      {
        'title': "Additional info: ",
        'info': widget.postData!.additionalInfo['text']
      },
    ];

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
              PostCreatorInfoWidget(
                  postData: widget.postData, dateFormat: dateFormat),
              const VerticalSpacing(20),
              RichText(
                text: TextSpan(
                    style: Theme.of(context).textTheme.titleLarge,
                    children: [
                      TextSpan(
                        text: widget.postData!.bloodGroup,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      const TextSpan(text: " blood needed."),
                    ]),
              ),
              const VerticalSpacing(5),
              ...infoList.map((e) {
                return Column(
                  children: [
                    const VerticalSpacing(5),
                    InfoWidget(title: e['title'], info: e['info']),
                  ],
                );
              }).toList(),
              const VerticalSpacing(20),
              const Divider(
                thickness: 1,
                height: 10,
              ),
              InteractionSection(
                onCommentButtonPressed: () {
                  setState(() {
                    showComment = !showComment;
                  });
                },
              ), // like, comment , share
              const Divider(
                thickness: 1,
                height: 10,
              ),
              if(showComment)
              const VerticalSpacing(20),
              if (showComment)
                FutureBuilder(
                  future: fetchComments(context, widget.postData!.postId),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Comment>> snapshot) {
                    if (snapshot.hasData) {
                      Log.d(TAG, "inside snapshot");
                      Log.d(
                        TAG, "data size: ${snapshot.data!}");
                      return CommentSection(
                        postId: widget.postData!.postId,
                        commentList: snapshot.data,
                      );
                    } else {
                      return Container();
                    }
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  InfoWidget({
    Key? key,
    required this.title,
    required this.info,
  }) : super(key: key);

  String? title;
  String? info;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            // https://stackoverflow.com/questions/41557139/how-do-i-bold-or-format-a-piece-of-text-within-a-paragraph
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: title ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextSpan(text: info ?? ""),
              ]),
            ),
          ),
        ],
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
  InteractionSection({Key? key, required this.onCommentButtonPressed})
      : super(key: key);

  Function onCommentButtonPressed;

  var buttons = [
    {
      'icon': Icons.thumb_up_alt_outlined,
      'activeIcon': Icons.thumb_up_rounded,
      'title': "Like",
    },
    {
      'icon': Icons.mode_comment_outlined,
      'activeIcon': Icons.mode_comment,
      'title': "Comment",
    },
    {
      'icon': FontAwesomeIcons.shareSquare,
      'activeIcon': FontAwesomeIcons.shareSquare,
      'title': "Share",
    },
  ];

  void onPressed(String button) {
    if (button == "Comment") {
      onCommentButtonPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...buttons.map((Map item) {
          return Flexible(
            child: TextButton(
              onPressed: () {
                onPressed(item['title']);
              },
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

class CommentSection extends StatefulWidget {
  CommentSection({
    Key? key,
    required this.postId,
    this.commentList,
  }) : super(key: key);

  String postId;

  List<Comment>? commentList;
  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  // = DummyConstants.dummyCommentList(5);

  void _onCommentAdd(Comment comment) {
    setState(() {
      widget.commentList!.add(comment);
    });
  }

  @override
  Widget build(BuildContext context) {
    var list = ["int", "int"];

    DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          WriteCommentWidget(
            postId: widget.postId,
            onCommentAdd: _onCommentAdd,
          ),
          VerticalSpacing(10),
          Divider(
            thickness: 1,
            height: 20,
          ),
          if (widget.commentList != null && widget.commentList!.length > 0)
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.commentList!.length,
              itemBuilder: (context, index) {
                return CommentWidget(comment: widget.commentList![index]);
              },
              separatorBuilder: (context, index) {
                return Divider(height: 20);
              },
            ),
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  CommentWidget({
    Key? key,
    this.comment,
  }) : super(key: key);

  Comment? comment;

  final DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

  @override
  Widget build(BuildContext context) {
    return (comment == null)
        ? Container()
        : Row(
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
                    comment!.userName,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    comment!.text,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    dateFormat.format(comment!.created.toLocal()),
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                ],
              )
            ],
          );
  }
}

class WriteCommentWidget extends StatelessWidget {
  static const String TAG = "WriteCommentWidget";
  Function onCommentAdd;

  WriteCommentWidget({
    Key? key,
    required this.postId,
    required this.onCommentAdd,
  }) : super(key: key);

  String postId;

  String? commentInputText;

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
            child: Container(
          height: 40,
          child: TextField(
            decoration: getInputDecoration(context, "", null, 25),
            onChanged: (value) {
              commentInputText = value;
            },
          ),
        )),
        HorizontalSpacing(15),
        Container(
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              if (commentInputText != null && commentInputText != "") {
                Log.d(TAG, "posting comment: $commentInputText");
                Provider.of<CommentProvider>(context, listen: false)
                    .createComment(postId, commentInputText!)
                    .then((ProviderResponse response) {
                  if (response.success) {
                    Comment comment = response.data;
                    onCommentAdd(comment);
                    Log.d(TAG, "data: ${comment.toJson()}");
                  } else {
                    Log.d(TAG, response.message);
                  }
                });
              } else {
                Log.d(TAG, "comment text can't be empty.");
              }
            },
            child: Text("Comment"),
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)))),
          ),
        ),
      ],
    );
  }
}
