class GuestStatus {
  GuestStatus({
    required this.user,
    required this.provider,
    required this.amount,
    required this.more,
    required this.status,
    required this.label,
    required this.rating,
    required this.trip,
    required this.createdAt,
  });

  final String user;
  final String provider;
  final String amount;
  final String more;
  final String status;
  final String label;
  final double rating;
  final String trip;
  final DateTime? createdAt;

  GuestStatus copyWith({
    String? user,
    String? provider,
    String? amount,
    String? more,
    String? status,
    String? label,
    double? rating,
    String? trip,
    DateTime? createdAt,
  }) {
    return GuestStatus(
      user: user ?? this.user,
      provider: provider ?? this.provider,
      amount: amount ?? this.amount,
      more: more ?? this.more,
      status: status ?? this.status,
      label: label ?? this.label,
      rating: rating ?? this.rating,
      trip: trip ?? this.trip,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory GuestStatus.fromJson(Map<String, dynamic> json) {
    return GuestStatus(
      user: json["user"] ?? "",
      provider: json["provider"] ?? "",
      amount: json["amount"] ?? "",
      more: json["more"] ?? "",
      status: json["status"] ?? "",
      label: json["label"] ?? "",
      rating: json["rating"] ?? 0.0,
      trip: json["trip"] ?? "",
      createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"] ?? "") : DateTime.now(),
    );
  }

  factory GuestStatus.empty() {
    return GuestStatus.fromJson({
      "user": "string",
      "provider": "string",
      "amount": "string",
      "more": "string",
      "status": "string",
      "label": "string",
      "rating": 0.0,
      "trip": "string",
      "created_at": "2024-05-10T06:43:58.977Z"
    });
  }

  Map<String, dynamic> toJson() => {
    "user": user,
    "provider": provider,
    "amount": amount,
    "more": more,
    "status": status,
    "label": label,
    "rating": rating,
    "trip": trip,
    "created_at": createdAt?.toIso8601String(),
  };
}