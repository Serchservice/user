import 'package:intl/intl.dart';

class Issue {
  Issue({
    required this.message,
    required this.label,
    required this.isSerch,
    required this.isRead,
    required this.sentAt,
    this.isSending = false
  });

  final String message;
  final String label;
  final bool isSerch;
  final bool isRead;
  final DateTime sentAt;
  final bool isSending;

  Issue copyWith({
    String? message,
    String? label,
    bool? isSerch,
    bool? isRead,
    DateTime? sentAt,
    bool? isSending
  }) {
    return Issue(
      message: message ?? this.message,
      label: label ?? this.label,
      isSerch: isSerch ?? this.isSerch,
      isRead: isRead ?? this.isRead,
      sentAt: sentAt ?? this.sentAt,
      isSending: isSending ?? this.isSending,
    );
  }

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      message: json["message"] ?? "",
      label: json["label"] ?? "",
      isSerch: json["is_serch"] ?? false,
      isRead: json["is_read"] ?? false,
      sentAt: DateTime.tryParse(json["sent_at"] ?? "") ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "label": label,
    "is_serch": isSerch,
    "is_read": isRead,
    "sent_at": sentAt.toIso8601String(),
  };

  factory Issue.sending({required String message}) {
    return Issue(
      message: message,
      label: DateFormat.EEEE().format(DateTime.now()),
      isSerch: false,
      isRead: false,
      sentAt: DateTime.now(),
      isSending: true
    );
  }
}