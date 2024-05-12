class RecentTransaction {
  RecentTransaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.time,
    required this.status,
    required this.type,
    required this.mode,
    required this.isIncoming,
    required this.requestedAt,
    required this.completedAt,
  });

  final String id;
  final String name;
  final String amount;
  final String time;
  final String status;
  final String type;
  final String mode;
  final bool isIncoming;
  final String requestedAt;
  final String completedAt;

  RecentTransaction copyWith({
    String? id,
    String? name,
    String? amount,
    String? time,
    String? status,
    String? type,
    String? mode,
    bool? isIncoming,
    String? requestedAt,
    String? completedAt,
  }) {
    return RecentTransaction(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      time: time ?? this.time,
      status: status ?? this.status,
      type: type ?? this.type,
      mode: mode ?? this.mode,
      isIncoming: isIncoming ?? this.isIncoming,
      requestedAt: requestedAt ?? this.requestedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  factory RecentTransaction.fromJson(Map<String, dynamic> json) {
    return RecentTransaction(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      amount: json["amount"] ?? "",
      time: json["time"] ?? "",
      status: json["status"] ?? "",
      type: json["type"] ?? "",
      mode: json["mode"] ?? "",
      isIncoming: json["is_incoming"] ?? false,
      requestedAt: json["requested_at"] ?? "",
      completedAt: json["completed_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "amount": amount,
    "time": time,
    "status": status,
    "type": type,
    "mode": mode,
    "is_incoming": isIncoming,
    "requested_at": requestedAt,
    "completed_at": completedAt,
  };
}

/*
{
	"id": "string",
	"name": "string",
	"amount": "string",
	"time": "string",
	"status": "PENDING",
	"type": "TIP2FIX",
	"mode": "string",
	"is_incoming": true,
	"requested_at": "string",
	"completed_at": "string"
}*/