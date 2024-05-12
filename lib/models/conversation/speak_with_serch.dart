import 'package:user/library.dart';

class SpeakWithSerch {
  SpeakWithSerch({
    required this.ticket,
    required this.label,
    required this.time,
    required this.status,
    required this.issues,
    required this.updatedAt,
  });

  final String ticket;
  final String label;
  final String time;
  final String status;
  final List<Issue> issues;
  final DateTime? updatedAt;

  SpeakWithSerch copyWith({
    String? ticket,
    String? label,
    String? time,
    String? status,
    List<Issue>? issues,
    DateTime? updatedAt,
  }) {
    return SpeakWithSerch(
      ticket: ticket ?? this.ticket,
      label: label ?? this.label,
      time: time ?? this.time,
      status: status ?? this.status,
      issues: issues ?? this.issues,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory SpeakWithSerch.fromJson(Map<String, dynamic> json) {
    return SpeakWithSerch(
      ticket: json["ticket"] ?? "",
      label: json["label"] ?? "",
      time: json["time"] ?? "",
      status: json["status"] ?? "",
      issues: json["issues"] == null
        ? []
        : List<Issue>.from(json["issues"]!.map((x) => Issue.fromJson(x))),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "ticket": ticket,
    "label": label,
    "time": time,
    "status": status,
    "issues": issues.map((x) => x.toJson()).toList(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  /// RESOLVED
  bool get isResolved => status.isNotEmpty && status == "RESOLVED";

  /// CLOSED
  bool get isClosed => status.isNotEmpty && status == "CLOSED";
}

/*
{
	"ticket": "string",
	"label": "string",
	"time": "string",
	"status": "OPENED",
	"issues": [
		{
			"message": "string",
			"label": "string",
			"is_serch": true,
			"is_read": true,
			"sent_at": "2024-05-03T16:07:52.589Z"
		}
	],
	"updated_at": "2024-05-03T16:07:52.595Z"
}*/