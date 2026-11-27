class NotificationModel {
  final String? id;
  final int? broadcastId;
  final String? type; // 'promotion', 'broadcast', 'order', etc.
  final String? title;
  final String? message;
  final String? imageUrl;
  final String? targetAudience;
  final String? timeAgo;
  final String? createdAt;
  bool isRead;

  NotificationModel({
    this.id,
    this.broadcastId,
    this.type,
    this.title,
    this.message,
    this.imageUrl,
    this.targetAudience,
    this.timeAgo,
    this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"]?.toString(),
        broadcastId: json["broadcast_id"] != null
            ? int.tryParse(json["broadcast_id"].toString())
            : null,
        type: json["type"]?.toString(),
        title: json["title"]?.toString(),
        message: json["message"]?.toString(),
        imageUrl: json["image_url"]?.toString(),
        targetAudience: json["target_audience"]?.toString(),
        timeAgo: json["time_ago"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        isRead: json["is_read"] == true,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "broadcast_id": broadcastId,
        "type": type,
        "title": title,
        "message": message,
        "image_url": imageUrl,
        "target_audience": targetAudience,
        "time_ago": timeAgo,
        "created_at": createdAt,
        "is_read": isRead,
      };
}
