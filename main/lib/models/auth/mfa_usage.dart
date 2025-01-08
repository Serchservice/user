class MfaUsageResponse {
  MfaUsageResponse({
    required this.used,
    required this.unused,
    required this.total,
  });

  final int used;
  final int unused;
  final int total;

  MfaUsageResponse copyWith({
    int? used,
    int? unused,
    int? total,
  }) {
    return MfaUsageResponse(
      used: used ?? this.used,
      unused: unused ?? this.unused,
      total: total ?? this.total,
    );
  }

  factory MfaUsageResponse.fromJson(Map<String, dynamic> json) {
    return MfaUsageResponse(
      used: json["used"] ?? 0,
      unused: json["unused"] ?? 0,
      total: json["total"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "used": used,
    "unused": unused,
    "total": total,
  };
}

/*
{
	"used": 0,
	"unused": 0,
	"total": 0
}*/