class ReferralProgram {
  ReferralProgram({
    required this.name,
    required this.avatar,
    required this.role,
    required this.referralCode,
    required this.referLink,
  });

  final String name;
  final String avatar;
  final String role;
  final String referralCode;
  final String referLink;

  ReferralProgram copyWith({
    String? name,
    String? avatar,
    String? role,
    String? referralCode,
    String? referLink,
  }) {
    return ReferralProgram(
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      referralCode: referralCode ?? this.referralCode,
      referLink: referLink ?? this.referLink,
    );
  }

  factory ReferralProgram.fromJson(Map<String, dynamic> json) {
    return ReferralProgram(
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      role: json["role"] ?? "",
      referralCode: json["referralCode"] ?? "",
      referLink: json["referLink"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "avatar": avatar,
    "role": role,
    "referralCode": referralCode,
    "referLink": referLink,
  };
}

/*
{
	"name": "string",
	"avatar": "string",
	"role": "string",
	"referralCode": "string",
	"referLink": "string",
}*/