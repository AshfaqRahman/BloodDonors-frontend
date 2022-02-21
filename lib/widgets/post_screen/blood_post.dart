import 'dart:core';
import 'dart:math';

import 'package:bms_project/modals/blood_post_model.dart';
import 'package:bms_project/modals/comment_model.dart';
import 'package:bms_project/modals/react_model.dart';
import 'package:bms_project/providers/comment_provider.dart';
import 'package:bms_project/providers/post_react_provider.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/utils/debug.dart';
import 'package:bms_project/utils/token.dart';
import 'package:bms_project/widgets/common/decorations.dart';
import 'package:bms_project/widgets/common/margin.dart';
import 'package:bms_project/widgets/common/profile_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    //Log.d(TAG, widget.postData!.toJson());
    List<Map> infoList = [
      {'title': "Amount: ", 'info': "${widget.postData!.amount}"},
      {'title': "Location: ", 'info': widget.postData!.location.displayName},
      {
        'title': "Time: ",
        'info': dateFormat.format(widget.postData!.dueTime.toLocal())
      },
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
              InteractionSection(
                bloodPost: widget.postData!,
              ), // like, comment , share
              const Divider(
                thickness: 1,
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  static const String TAG = "InfoWidget";

  InfoWidget({
    Key? key,
    required this.title,
    required this.info,
  }) : super(key: key);

  String? title;
  String? info;

  @override
  Widget build(BuildContext context) {
    //Log.d(TAG, "$title: $info");
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            // https://stackoverflow.com/questions/41557139/how-do-i-bold-or-format-a-piece-of-text-within-a-paragraph
            child: RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.subtitle2,
                  children: [
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
      ProfilePictureFromName(
          name: postData!.userName,
          radius: 25,
          fontsize: 15,
          characterCount: 2),
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

class InteractionSection extends StatefulWidget {
  InteractionSection({Key? key, required this.bloodPost}) : super(key: key);

  BloodPost bloodPost;

  @override
  State<InteractionSection> createState() => _InteractionSectionState();
}

class _InteractionSectionState extends State<InteractionSection> {
  static const String TAG = "InteractionSection";

  bool showComment = false; // state variable
  bool isLiked = false; // state variable for like button
  List<React> reactList = [];
  int totalReactCnt = 0;
  List<Comment> commentList = [];
  int totalComments = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<PostReactProvider>(context, listen: false)
        .getReacts(widget.bloodPost.postId)
        .then((value) async {
      if (value.success) {
        reactList = value.data;
        Log.d(TAG, "react count: ${reactList.length}");
        totalReactCnt = reactList.length;
        String userId = await AuthToken.parseUserId();
        for (int i = 0; i < reactList.length; i++) {
          //Log.d(TAG, "user ${reactList[i].userId} likes the post");
          if (reactList[i].userId == userId) {
            Log.d(TAG, "$userId likes the post ${widget.bloodPost.postId}");
            isLiked = true;
            break;
          }
        }
        setState(() {});
      }
    });
  }

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

  void onPressed(String button) async {
    if (button == "Comment") {
      setState(() {
        showComment = !showComment; // toggle comment section
      });
    } else if (button == "Like") {
      Log.d(TAG, "Like button pressed for post ${widget.bloodPost.postId}");
      _toggleReact();
    }
  }

  void _toggleReact() async {
    if (!isLiked) {
      // add react
      setState(() {
        isLiked = true;
        totalReactCnt++;
      });
      ProviderResponse response =
          await Provider.of<PostReactProvider>(context, listen: false)
              .submitReact(widget.bloodPost.postId);
      if (response.success) {
        React react = response.data;
        reactList.add(react);
      }
    } else {
      setState(() {
        isLiked = false;
        totalReactCnt--;
      });
      // remove react
      ProviderResponse response =
          await Provider.of<PostReactProvider>(context, listen: false)
              .removeReact(widget.bloodPost.postId);

      if (response.success) {
        for (int i = 0; i < reactList.length; i++) {
          React react = reactList[i];
          if (react.userId == await AuthToken.parseUserId()) {
            setState(() {
              reactList.removeAt(i);
            });
            break;
          }
        }
      }
    }
  }

  Icon interactionIcon(Map item) {
    if (item['title'] == "Like" && isLiked) return Icon(item['activeIcon']);
    return Icon(item['icon']);
  }

  Future<List<Comment>> fetchComments(BuildContext ctx, String postId) async {
    ProviderResponse response =
        await Provider.of<CommentProvider>(context, listen: false)
            .getComments(postId);
    //Log.d(TAG, response.toJson());
    return response.success ? response.data : [];
  }

  // comment is submitted from WriteComment
  void _onCommentAdd(Comment comment) {
    commentList.add(comment);
    setState(() {
      totalComments++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Log.d(TAG, "redrawing $TAG");
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${totalReactCnt} likes"),
              Text("${totalComments} comments"),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
          height: 10,
        ),
        Row(
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
                      interactionIcon(item),
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
        ),
        // comment section
        if (showComment) const VerticalSpacing(20),
        FutureBuilder(
          future: fetchComments(context, widget.bloodPost.postId),
          builder:
              (BuildContext context, AsyncSnapshot<List<Comment>> snapshot) {
            if (snapshot.hasData) {
              Log.d(TAG,
                  "total comments of post ${widget.bloodPost.postId}: ${snapshot.data!.length}");
              totalComments = snapshot.data!.length;
              return showComment
                  ? Column(
                      children: [
                        FutureBuilder(
                          future: AuthToken.parseUserName(),
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            if (!snapshot.hasData) return Container();

                            String userName = snapshot.data ?? "";
                            if (userName == "") return Container();

                            return WriteCommentWidget(
                              postId: widget.bloodPost.postId,
                              onCommentAdd: _onCommentAdd,
                              userName: userName,
                            );
                          },
                        ),
                        const VerticalSpacing(10),
                        const Divider(
                          thickness: 1,
                          height: 20,
                        ),
                        CommentSection(
                          postId: widget.bloodPost.postId,
                          commentList: snapshot.data,
                        ),
                      ],
                    )
                  : Container();
            } else {
              return Container();
            }
          },
        )
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          if (widget.commentList != null && widget.commentList!.length > 0)
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.commentList!.length,
              itemBuilder: (context, index) {
                return CommentWidget(comment: widget.commentList![index]);
              },
              separatorBuilder: (context, index) {
                return const Divider(height: 20);
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
              ProfilePictureFromName(
                  name: comment!.userName,
                  radius: 20,
                  fontsize: 15,
                  characterCount: 2),
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
    required this.userName,
  }) : super(key: key);

  String postId;
  final String userName;

  TextEditingController _commentTextController = TextEditingController();

  String? commentInputText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfilePictureFromName(
            name: userName, radius: 20, fontsize: 15, characterCount: 2),
        HorizontalSpacing(15),
        Flexible(
            child: Container(
          height: 40,
          child: TextField(
            controller: _commentTextController,
            decoration: getInputDecoration(context, "", null, 25),
            onSubmitted: (comment) {
              if (comment != "") {
                sendComment(context, comment);
              } else {
                Log.d(TAG, "comment text can't be empty.");
              }
            },
          ),
        )),
        const HorizontalSpacing(15),
        Container(
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              String comment = _commentTextController.text;
              if (comment != "") {
                sendComment(context, comment);
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

  void sendComment(BuildContext context, String comment) {
    Log.d(TAG, "sendComment: sending: $comment");
    Provider.of<CommentProvider>(context, listen: false)
        .createComment(postId, comment)
        .then((ProviderResponse response) {
      if (response.success) {
        Comment comment = response.data;
        onCommentAdd(comment);
        Log.d(TAG, "data: ${comment.toJson()}");
      } else {
        Log.d(TAG, response.message);
      }
    });
  }
}
