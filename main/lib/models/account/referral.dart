class Referral {
  Referral({
    required this.referId,
    required this.name,
    required this.avatar,
    required this.role,
    required this.info,
  });

  final String referId;
  final String name;
  final String avatar;
  final String role;
  final String info;

  Referral copyWith({
    String? referId,
    String? name,
    String? avatar,
    String? role,
    String? info,
  }) {
    return Referral(
      referId: referId ?? this.referId,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      info: info ?? this.info,
    );
  }

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      referId: json["referId"] ?? "",
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      role: json["role"] ?? "",
      info: json["info"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "referId": referId,
    "name": name,
    "avatar": avatar,
    "role": role,
    "info": info,
  };
}

/*
{
	"referId": "string",
	"name": "string",
	"avatar": "string",
	"role": "string",
	"info": "string"
}*/