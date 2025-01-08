import 'package:user/library.dart';

class SpeakWithSerch {
  SpeakWithSerch({
    required this.ticket,
    required this.label,
    required this.time,
    required this.status,
    required this.hasSerchMessage,
    required this.updatedAt,
    required this.total,
    required this.issues,
  });

  final String ticket;
  final String label;
  final String time;
  final String status;
  final int total;
  final List<Issue> issues;
  final bool hasSerchMessage;
  final DateTime? updatedAt;

  SpeakWithSerch copyWith({
    String? ticket,
    String? label,
    String? time,
    String? status,
    bool? hasSerchMessage,
    DateTime? updatedAt,
    int? total,
    List<Issue>? issues,
  }) {
    return SpeakWithSerch(
      ticket: ticket ?? this.ticket,
      label: label ?? this.label,
      time: time ?? this.time,
      status: status ?? this.status,
      hasSerchMessage: hasSerchMessage ?? this.hasSerchMessage,
      updatedAt: updatedAt ?? this.updatedAt,
      total: total ?? this.total,
      issues: issues ?? this.issues,
    );
  }

  factory SpeakWithSerch.fromJson(Map<String, dynamic> json) {
    return SpeakWithSerch(
      ticket: json["ticket"] ?? "",
      label: json["label"] ?? "",
      time: json["time"] ?? "",
      status: json["status"] ?? "",
      hasSerchMessage: json["has_serch_message"] ?? false,
      total: json["total"] ?? 0,
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      issues: json["issues"] == null
          ? []
          : List<Issue>.from(json["issues"]!.map((x) => Issue.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "ticket": ticket,
    "label": label,
    "time": time,
    "status": status,
    "has_serch_message": hasSerchMessage,
    "updated_at": updatedAt?.toIso8601String(),
    "total": total,
    "issues": issues.map((x) => x.toJson()).toList(),
  };

  /// RESOLVED
  bool get isResolved => status.isNotEmpty && status == "RESOLVED";

  /// CLOSED
  bool get isClosed => status.isNotEmpty && status == "CLOSED";

  factory SpeakWithSerch.empty() {
    return SpeakWithSerch(
      ticket: "",
      label: "",
      time: "",
      status: "",
      hasSerchMessage: false,
      updatedAt: DateTime.now(),
      total: 0,
      issues: []
    );
  }
}

/*
{
	"ticket": "string",
	"label": "string",
	"time": "string",
	"status": "OPENED",
	"updated_at": "2024-05-03T16:07:52.595Z"
}*/