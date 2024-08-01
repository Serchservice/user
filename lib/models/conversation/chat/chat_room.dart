import 'package:user/library.dart';

class ChatRoom {
  ChatRoom({
    required this.room,
    required this.roommate,
    required this.name,
    required this.avatar,
    required this.category,
    required this.image,
    required this.label,
    required this.message,
    required this.messageId,
    required this.status,
    required this.count,
    required this.groups,
    required this.lastSeen,
    required this.sentAt,
    required this.isBookmarked,
    required this.bookmark,
    required this.schedule,
  });

  final String room;
  final String roommate;
  final String name;
  final String avatar;
  final String category;
  final String image;
  final String label;
  final String message;
  final String messageId;
  final String status;
  final int count;
  final List<ChatGroupMessage> groups;
  final String lastSeen;
  final DateTime sentAt;
  final bool isBookmarked;
  final String bookmark;
  final Schedule schedule;

  ChatRoom copyWith({
    String? room,
    String? roommate,
    String? name,
    String? avatar,
    String? category,
    String? image,
    String? label,
    String? message,
    String? messageId,
    String? status,
    int? count,
    List<ChatGroupMessage>? groups,
    String? lastSeen,
    DateTime? sentAt,
    bool? isBookmarked,
    String? bookmark,
    Schedule? schedule,
  }) {
    return ChatRoom(
      room: room ?? this.room,
      roommate: roommate ?? this.roommate,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      category: category ?? this.category,
      image: image ?? this.image,
      label: label ?? this.label,
      message: message ?? this.message,
      messageId: messageId ?? this.messageId,
      status: status ?? this.status,
      count: count ?? this.count,
      groups: groups ?? this.groups,
      lastSeen: lastSeen ?? this.lastSeen,
      sentAt: sentAt ?? this.sentAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      bookmark: bookmark ?? this.bookmark,
      schedule: schedule ?? this.schedule,
    );
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      room: json["room"] ?? "",
      roommate: json["roommate"] ?? "",
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      category: json["category"] ?? "",
      image: json["image"] ?? "",
      label: json["label"] ?? "",
      message: json["message"] ?? "",
      messageId: json["message_id"] ?? "",
      status: json["status"] ?? "",
      bookmark: json["bookmark"] ?? "",
      schedule: json["schedule"] != null ? Schedule.fromJson(json["schedule"]) : Schedule.empty(),
      count: json["count"] ?? 0,
      groups: json["groups"] == null
          ? []
          : List<ChatGroupMessage>.from(json["groups"]!.map((x) => ChatGroupMessage.fromJson(x))),
      lastSeen: json["last_seen"] ?? "",
      sentAt: DateTime.tryParse(json["sent_at"] ?? "") ?? DateTime.now(),
      isBookmarked: json["is_bookmarked"] ?? false,
    );
  }

  factory ChatRoom.empty() {
    return ChatRoom.fromJson({
      "room": "",
      "roommate": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "name": "",
      "avatar": "",
      "category": "",
      "image": "",
      "label": "",
      "message": "",
      "message_id": "",
      "bookmark": "",
      "schedule": {
        "id": "",
        "time": "",
        "avatar": "",
        "name": "",
        "category": "",
        "image": "",
        "status": "PENDING",
        "reason": "",
        "closed_by": "",
        "closed_at": "",
        "closed_on_time": true,
        "rating": 0.0,
        "label": ""
      },
      "status": "SENDING",
      "count": 0,
      "groups": [
        {
          "label": "",
          "time": "2024-05-22T23:12:01.257Z",
          "messages": [
            {
              "id": "",
              "label": "",
              "room": "",
              "message": "",
              "name": "",
              "status": "SENDING",
              "type": "TEXT",
              "duration": "",
              "reply": {
                "id": "",
                "label": "",
                "message": "",
                "status": "SENDING",
                "has_only_emojis": true,
                "has_only_one_emoji": true,
                "file_size": "",
                "sender": "",
                "type": "",
                "duration": "",
                "is_sent_by_current_user": false
              },
              "has_only_emojis": true,
              "has_only_one_emoji": true,
              "file_size": "",
              "is_sent_by_current_user": true,
              "sent_at": "2024-05-22T23:12:01.257Z"
            }
          ]
        }
      ],
      "last_seen": "",
      "sent_at": "2024-05-22T23:12:01.258Z",
      "is_bookmarked": false,
    });
  }

  Map<String, dynamic> toJson() => {
    "room": room,
    "roommate": roommate,
    "name": name,
    "avatar": avatar,
    "category": category,
    "image": image,
    "label": label,
    "message": message,
    "message_id": messageId,
    "bookmark": bookmark,
    "schedule": schedule.toJson(),
    "status": status,
    "count": count,
    "groups": groups.map((x) => x.toJson()).toList(),
    "last_seen": lastSeen,
    "sent_at": sentAt.toIso8601String(),
    "is_bookmarked": isBookmarked,
  };

  /// Check if the chat room has schedule
  bool get isScheduled => schedule.id.isNotEmpty;
}
