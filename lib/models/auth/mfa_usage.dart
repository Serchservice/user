class MfaUsage {
  MfaUsage({
    required this.used,
    required this.unused,
    required this.total,
  });

  final int used;
  final int unused;
  final int total;

  MfaUsage copyWith({
    int? used,
    int? unused,
    int? total,
  }) {
    return MfaUsage(
      used: used ?? this.used,
      unused: unused ?? this.unused,
      total: total ?? this.total,
    );
  }

  factory MfaUsage.fromJson(Map<String, dynamic> json) {
    return MfaUsage(
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