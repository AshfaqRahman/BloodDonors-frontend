/* {
    "comment_id": "fec20186-2396-4643-a8e2-2f2440814438",
    "text": "Henlo",
    "user_name": "masum",
    "created": "2022-02-09T07:52:48.498Z"
 } */
class Comment {
    Comment({
      required this.commentId,
      required this.text,
      required this.postId,
      required this.userId,
      required this.userName,
      required this.created,
    });

    String commentId;
    String text;
    String postId;
    String userId;
    String userName;
    DateTime created;

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentId: json["comment_id"],
        text: json["text"],
        postId: json["post_id"],
        userId: json["user_id"],
        userName: json["user_name"],
        created: DateTime.parse(json["created"]),
    );

    Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "text": text,
        "post_id": postId,
        "user_id": userId,
        "user_name": userName,
        "created": created.toIso8601String(),
    };
}
