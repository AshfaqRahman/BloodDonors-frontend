import 'package:bms_project/modals/chat_message_model.dart';

class Chat {
  Chat({
    required this.userId,
    required this.userName,
    required this.chatMessage,
    required this.isSender,
  });

  String userId;
  String userName;
  ChatMessage chatMessage;
  bool isSender;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        userId: json["user_id"],
        userName: json["user_name"],
        chatMessage: ChatMessage.fromJson(json["last_message"]),
        isSender: json["is_sender"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "last_message": chatMessage.toJson(),
        "is_sender": isSender,
      };
}
