class TimelineResponse {
  TimelineResponse({
    required this.status,
    required this.header,
    required this.description,
    required this.label,
    required this.isOver,
    required this.createdAt,
    required this.updatedAt,
  });

  final String status;
  final String header;
  final String description;
  final String label;
  final bool isOver;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TimelineResponse copyWith({
    String? status,
    String? header,
    String? description,
    String? label,
    bool? isOver,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimelineResponse(
      status: status ?? this.status,
      header: header ?? this.header,
      description: description ?? this.description,
      label: label ?? this.label,
      isOver: isOver ?? this.isOver,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TimelineResponse.fromJson(Map<String, dynamic> json){
    return TimelineResponse(
      status: json["status"] ?? "",
      header: json["header"] ?? "",
      description: json["description"] ?? "",
      label: json["label"] ?? "",
      isOver: json["is_over"] ?? false,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "header": header,
    "description": description,
    "label": label,
    "is_over": isOver,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  bool get isRequested => status == "REQUESTED";
  bool get isAccepted => status == "CONNECTED";
  bool get isOnTheWay => status == "ON_THE_WAY";
  bool get isArrived => status == "ARRIVED";
  bool get isActive => status == "ON_TRIP";
  bool get isAccessGranted => status == "SHARE_ACCESS_GRANTED";
  bool get isAccessDenied => status == "SHARE_ACCESS_DENIED";
}

/*
{
	"status": "REQUESTED",
	"header": "string",
	"description": "string",
	"label": "string",
	"is_over": true,
	"show_cancel": true,
	"show_auth": true,
	"show_end": true,
	"show_share": true,
	"show_grant": true,
	"show_deny": true,
	"show_leave": true,
	"created_at": "2024-07-26T12:08:23.357Z",
	"updated_at": "2024-07-26T12:08:23.357Z"
}*/