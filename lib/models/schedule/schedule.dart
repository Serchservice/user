class Schedule {
  Schedule({
    required this.id,
    required this.time,
    required this.avatar,
    required this.name,
    required this.category,
    required this.image,
    required this.status,
    required this.reason,
    required this.closedBy,
    required this.closedAt,
    required this.closedOnTime,
    required this.label,
    required this.rating,
    required this.createdAt,
    required this.snt,
  });

  final String id;
  final String time;
  final String avatar;
  final String name;
  final String category;
  final String image;
  final String status;
  final String reason;
  final String closedBy;
  final String closedAt;
  final bool closedOnTime;
  final String label;
  final double rating;
  final DateTime createdAt;
  final String snt;

  Schedule copyWith({
    String? id,
    String? time,
    String? avatar,
    String? name,
    String? category,
    String? image,
    String? status,
    String? reason,
    String? closedBy,
    String? closedAt,
    bool? closedOnTime,
    String? label,
    double? rating,
    DateTime? createdAt,
    String? snt,
  }) {
    return Schedule(
      id: id ?? this.id,
      time: time ?? this.time,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      category: category ?? this.category,
      image: image ?? this.image,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      closedBy: closedBy ?? this.closedBy,
      closedAt: closedAt ?? this.closedAt,
      closedOnTime: closedOnTime ?? this.closedOnTime,
      label: label ?? this.label,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      snt: snt ?? this.snt,
    );
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json["id"] ?? "",
      time: json["time"] ?? "",
      avatar: json["avatar"] ?? "",
      name: json["name"] ?? "",
      category: json["category"] ?? "",
      image: json["image"] ?? "",
      status: json["status"] ?? "",
      reason: json["reason"] ?? "",
      closedBy: json["closed_by"] ?? "",
      closedAt: json["closed_at"] ?? "",
      closedOnTime: json["closed_on_time"] ?? false,
      label: json["label"] ?? "",
      rating: json["rating"] ?? 0.0,
      createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
      snt: json["snt"] ?? "",
    );
  }

  factory Schedule.empty() {
    return Schedule.fromJson({
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
      "label": "",
      "created_at": "",
      "snt": "",
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "time": time,
    "avatar": avatar,
    "name": name,
    "category": category,
    "image": image,
    "status": status,
    "reason": reason,
    "closed_by": closedBy,
    "closed_at": closedAt,
    "closed_on_time": closedOnTime,
    "rating": rating,
    "label": label,
    "created_at": createdAt.toIso8601String(),
    "snt": snt,
  };

  factory Schedule.fromStringedJson(Map<String, String?> json) {
    return Schedule(
      id: json["id"] ?? "",
      time: json["time"] ?? "",
      avatar: json["avatar"] ?? "",
      name: json["name"] ?? "",
      category: json["category"] ?? "",
      image: json["image"] ?? "",
      status: json["status"] ?? "",
      reason: json["reason"] ?? "",
      closedBy: json["closed_by"] ?? "",
      closedAt: json["closed_at"] ?? "",
      closedOnTime: json["closed_on_time"] == 'true',
      label: json["label"] ?? "",
      rating: double.tryParse(json["rating"] ?? "0.0") ?? 0.0,
      createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
      snt: json["snt"] ?? "",
    );
  }

  Map<String, String> toStringedJson() => {
    "id": id,
    "time": time,
    "avatar": avatar,
    "name": name,
    "category": category,
    "image": image,
    "status": status,
    "reason": reason,
    "closed_by": closedBy,
    "closed_at": closedAt,
    "closed_on_time": closedOnTime.toString(),
    "rating": rating.toString(),
    "label": label,
    "created_at": createdAt.toIso8601String(),
    "snt": snt,
  };

  bool get isAccepted => status == "ACCEPTED";
  bool get isPending => status == "PENDING";
}

/*
{
  "id": "string",
  "time": "string",
  "avatar": "string",
  "name": "string",
  "category": "string",
  "image": "string",
  "status": "PENDING",
  "reason": "string",
  "closed_by": "string",
  "closed_at": "string",
  "closed_on_time": true,
  "rating": 0.0,
  "label": "string",
  "created_at": "string",
  "snt": "string"
}
*/