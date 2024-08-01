import 'package:intl/intl.dart';
import 'package:user/library.dart';

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.label,
    required this.room,
    required this.message,
    required this.status,
    required this.type,
    required this.duration,
    required this.reply,
    required this.hasOnlyEmojis,
    required this.hasOnlyOneEmoji,
    required this.fileSize,
    required this.isSentByCurrentUser,
    required this.sentAt,
    required this.name,
  });

  final String id;
  final String label;
  final String room;
  final String message;
  final String status;
  final String type;
  final String duration;
  final ChatReply? reply;
  final bool hasOnlyEmojis;
  final bool hasOnlyOneEmoji;
  final String fileSize;
  final bool isSentByCurrentUser;
  final DateTime sentAt;
  final String name;

  ChatMessage copyWith({
    String? id,
    String? label,
    String? room,
    String? message,
    String? status,
    String? type,
    String? duration,
    ChatReply? reply,
    bool? hasOnlyEmojis,
    bool? hasOnlyOneEmoji,
    String? fileSize,
    bool? isSentByCurrentUser,
    DateTime? sentAt,
    String? name,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      label: label ?? this.label,
      room: room ?? this.room,
      message: message ?? this.message,
      status: status ?? this.status,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      reply: reply ?? this.reply,
      hasOnlyEmojis: hasOnlyEmojis ?? this.hasOnlyEmojis,
      hasOnlyOneEmoji: hasOnlyOneEmoji ?? this.hasOnlyOneEmoji,
      fileSize: fileSize ?? this.fileSize,
      isSentByCurrentUser: isSentByCurrentUser ?? this.isSentByCurrentUser,
      sentAt: sentAt ?? this.sentAt,
      name: name ?? this.name,
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json["id"] ?? "",
      label: json["label"] ?? "",
      room: json["room"] ?? "",
      message: json["message"] ?? "",
      name: json["name"] ?? "",
      status: json["status"] ?? "",
      type: json["type"] ?? "",
      duration: json["duration"] ?? "",
      reply: json["reply"] == null ? null : ChatReply.fromJson(json["reply"]),
      hasOnlyEmojis: json["has_only_emojis"] ?? false,
      hasOnlyOneEmoji: json["has_only_one_emoji"] ?? false,
      fileSize: json["file_size"] ?? "",
      isSentByCurrentUser: json["is_sent_by_current_user"] ?? false,
      sentAt: DateTime.tryParse(json["sent_at"] ?? "") ?? DateTime.now(),
    );
  }

  factory ChatMessage.empty() {
    return ChatMessage.fromJson({
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
    });
  }

  factory ChatMessage.sending({
    required String message,
    ChatReply? reply,
    String type = "TEXT",
    String fileSize = ""
  }) {
    return ChatMessage.fromJson({
      "id": "",
      "label": DateFormat('hh:mma').format(DateTime.now()),
      "room": "",
      "message": message,
      "name": Database.auth.name,
      "status": "SENDING",
      "type": type,
      "duration": "",
      "reply": reply?.toJson(),
      "has_only_emojis": CommonUtility.containsOnlyEmojis(message),
      "has_only_one_emoji": CommonUtility.containsOnlyOneEmoji(message),
      "file_size": fileSize,
      "is_sent_by_current_user": true,
      "sent_at": DateTime.now().toIso8601String()
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "room": room,
    "message": message,
    "name": name,
    "status": status,
    "type": type,
    "duration": duration,
    "reply": reply?.toJson(),
    "has_only_emojis": hasOnlyEmojis,
    "has_only_one_emoji": hasOnlyOneEmoji,
    "file_size": fileSize,
    "is_sent_by_current_user": isSentByCurrentUser,
    "sent_at": sentAt.toIso8601String(),
  };
}