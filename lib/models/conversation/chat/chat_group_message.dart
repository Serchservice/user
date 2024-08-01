import 'package:user/library.dart';

class ChatGroupMessage {
  ChatGroupMessage({
    required this.label,
    required this.time,
    required this.messages,
  });

  final String label;
  final DateTime time;
  final List<ChatMessage> messages;

  ChatGroupMessage copyWith({
    String? label,
    DateTime? time,
    List<ChatMessage>? messages,
  }) {
    return ChatGroupMessage(
      label: label ?? this.label,
      time: time ?? this.time,
      messages: messages ?? this.messages,
    );
  }

  factory ChatGroupMessage.fromJson(Map<String, dynamic> json) {
    return ChatGroupMessage(
      label: json["label"] ?? "",
      time: DateTime.tryParse(json["time"] ?? "") ?? DateTime.now(),
      messages: json["messages"] == null
        ? []
        : List<ChatMessage>.from(json["messages"]!.map((x) => ChatMessage.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "label": label,
    "time": time.toIso8601String(),
    "messages": messages.map((x) => x.toJson()).toList(),
  };
}