import 'package:intl/intl.dart';
import 'package:user/library.dart';

class ChatReply {
  ChatReply({
    required this.id,
    required this.label,
    required this.message,
    required this.status,
    required this.hasOnlyEmojis,
    required this.hasOnlyOneEmoji,
    required this.fileSize,
    required this.type,
    required this.sender,
    required this.duration,
    required this.isSentByCurrentUser
  });

  final String id;
  final String label;
  final String message;
  final String status;
  final bool hasOnlyEmojis;
  final bool hasOnlyOneEmoji;
  final String fileSize;
  final String type;
  final String sender;
  final String duration;
  final bool isSentByCurrentUser;

  ChatReply copyWith({
    String? id,
    String? label,
    String? message,
    String? status,
    bool? hasOnlyEmojis,
    bool? hasOnlyOneEmoji,
    String? fileSize,
    String? duration,
    String? type,
    String? sender,
    bool? isSentByCurrentUser,
  }) {
    return ChatReply(
      id: id ?? this.id,
      label: label ?? this.label,
      message: message ?? this.message,
      status: status ?? this.status,
      hasOnlyEmojis: hasOnlyEmojis ?? this.hasOnlyEmojis,
      hasOnlyOneEmoji: hasOnlyOneEmoji ?? this.hasOnlyOneEmoji,
      fileSize: fileSize ?? this.fileSize,
      sender: sender ?? this.sender,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      isSentByCurrentUser: isSentByCurrentUser ?? this.isSentByCurrentUser,
    );
  }

  factory ChatReply.fromJson(Map<String, dynamic> json) {
    return ChatReply(
      id: json["id"] ?? "",
      label: json["label"] ?? "",
      message: json["message"] ?? "",
      status: json["status"] ?? "",
      hasOnlyEmojis: json["has_only_emojis"] ?? false,
      hasOnlyOneEmoji: json["has_only_one_emoji"] ?? false,
      fileSize: json["file_size"] ?? "",
      type: json["type"] ?? "",
      sender: json["sender"] ?? "",
      duration: json["duration"] ?? "",
      isSentByCurrentUser: json["is_sent_by_current_user"] ?? false
    );
  }

  factory ChatReply.empty() {
    return ChatReply.fromJson({
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
    });
  }

  factory ChatReply.sending({
    required String message,
    String type = "TEXT",
    String name = "",
    String fileSize = "",
    bool sentByUser = false
  }) {
    return ChatReply.fromJson({
      "id": "",
      "label": DateFormat('hh:mma').format(DateTime.now()),
      "message": message,
      "status": "SENDING",
      "has_only_emojis": CommonUtility.containsOnlyEmojis(message),
      "has_only_one_emoji": CommonUtility.containsOnlyOneEmoji(message),
      "file_size": fileSize,
      "sender": name,
      "type": type,
      "duration": "",
      "is_sent_by_current_user": sentByUser
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "message": message,
    "status": status,
    "has_only_emojis": hasOnlyEmojis,
    "has_only_one_emoji": hasOnlyOneEmoji,
    "file_size": fileSize,
    "type": type,
    "duration": duration,
    "sender": sender,
    "is_sent_by_current_user": isSentByCurrentUser
  };
}