class React {
    React({
        required this.reactName,
        required this.postId,
        required this.created,
        required this.userId,
        required this.userName,
    });

    String reactName;
    String postId;
    DateTime created;
    String userId;
    String userName;

    factory React.fromJson(Map<String, dynamic> json) => React(
        reactName: json["react_name"],
        postId: json["post_id"],
        created: DateTime.parse(json["created"]),
        userId: json["user_id"],
        userName: json["user_name"],
    );

    Map<String, dynamic> toJson() => {
        "react_name": reactName,
        "post_id": postId,
        "created": created.toIso8601String(),
        "user_id": userId,
        "user_name": userName,
    };
}
