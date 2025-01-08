import 'package:flutter/cupertino.dart';
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
    "file_size": fileSize,
    "is_sent_by_current_user": isSentByCurrentUser,
    "sent_at": sentAt.toIso8601String(),
  };

  bool hasOnlyEmojis(String message) => CommonUtility.containsOnlyEmojis(message);
  bool hasOnlyOneEmoji(String message) => CommonUtility.containsOnlyOneEmoji(message);

  bool get isAudio => type.toLowerCase() == "audio" && message.isNotEmpty;
  bool get isImage => type.toLowerCase() == "image" && message.isNotEmpty;
  bool get isVideo => type.toLowerCase() == "video" && message.isNotEmpty;
  bool get isAsset => isAudio || isImage || isVideo;

  bool get isSending => status.toLowerCase() == "sending";
  bool get isRead => status.toLowerCase() == "read";

  Widget get sendingIcon {
    return Row(
      spacing: 3,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SText(
          text: label,
          color: CommonColors.hint,
          size: Sizing.font(11),
        ),
        if(isSentByCurrentUser)...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 1),
              Icon(
                ChatRoomListItem.getSendingIcon(isSending, isRead),
                color: isSending ? CommonColors.hint : CommonColors.lightTheme,
                size: Sizing.font(12)
              )
            ]
          )
        ]
      ]
    );
  }
}