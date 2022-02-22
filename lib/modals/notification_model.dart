class NotificationModel {
  NotificationModel({
    required this.actorId,
    required this.actorName,
    required this.type,
    required this.notificationId,
    required this.entityId,
    required this.created,
    required this.message,
  });

  String actorId;
  String actorName;
  String type;
  int notificationId;
  String entityId;
  DateTime created;
  String message;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        actorId: json["actor_id"],
        actorName: json["actor_name"],
        type: json["type"],
        notificationId: json["notification_id"],
        entityId: json["entity_id"],
        created: DateTime.parse(json["created"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "actor_id": actorId,
        "actor_name": actorName,
        "type": type,
        "notification_id": notificationId,
        "entity_id": entityId,
        "created": created.toIso8601String(),
        "message": message,
      };
}
